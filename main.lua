-- Main-tab gameplay features module.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local root = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")

local parryEnabled = false
local circleEnabled = false
local autoSkillCheckEnabled = false
local kingScourgeEnabled = false
local kingScourgeToggle, kingScourgeKnob
local autoSkillCheckConnection
local setKingScourgeEnabled, setAutoSkillCheckEnabled
local createCircle, destroyCircle
local setToggleVisual

local parryToggle, parryKnob, parryKeyButton
local parryHotkey = Enum.KeyCode.Z
local waitingForHotkey = false

-- =========================================================
-- CIRCLE
-- =========================================================

do

    local radius = 7.7
    local lineThickness = 0.2
    local segments = 128

    local folder = nil
    local parts = {}
    local circleConnection = nil

    function createCircle()

        if folder then
            return
        end

        folder = Instance.new("Folder")

        folder.Name =
            "CircleZone"

        folder.Parent =
            workspace

        parts = {}

        local segmentLength =
            (
                2
                * math.pi
                * radius
                / segments
            )
            + 0.2

        for i = 1, segments do

            local part =
                Instance.new("Part")

            part.Size =
                Vector3.new(
                    lineThickness,
                    0.15,
                    segmentLength
                )

            part.Material =
                Enum.Material.Neon

            part.Transparency = 0.3

            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false

            part.Anchored = true
            part.Parent = folder

            table.insert(
                parts,
                part
            )

        end

        circleConnection =
            RunService.RenderStepped:Connect(
                function()

                    if not root
                        or not root.Parent
                    then
                        return
                    end

                    for i, part
                        in ipairs(parts)
                    do

                        local angle =
                            (
                                i / segments
                            )
                            * math.pi
                            * 2

                        local position =
                            root.Position
                            +
                            Vector3.new(
                                math.cos(angle)
                                    * radius,

                                -3,

                                math.sin(angle)
                                    * radius
                            )

                        part.Position =
                            position

                        part.CFrame =
                            CFrame.new(
                                position
                            )
                            *
                            CFrame.Angles(
                                0,
                                -angle,
                                0
                            )

                    end

                end
            )

    end

    function destroyCircle()

        if circleConnection then

            circleConnection:Disconnect()
            circleConnection = nil

        end

        if folder then

            folder:Destroy()
            folder = nil

        end

        parts = {}

    end

end

-- =========================================================
-- PARRY
-- =========================================================

do

    local ReplicatedStorage =
        game:GetService("ReplicatedStorage")

    local PARRY_ANIMATIONS = {

        ["rbxassetid://122812055447896"] = true,
        ["rbxassetid://135002183282873"] = true,
        ["rbxassetid://105374834496520"] = true,
        ["rbxassetid://110355011987939"] = true,
        ["rbxassetid://117042998468241"] = true,
        ["rbxassetid://129784271201071"] = true,
        ["rbxassetid://113255068724446"] = true,
        ["rbxassetid://118907603246885"] = true,
        ["rbxassetid://115244153053858"] = true,
        ["rbxassetid://111229698330816"] = true,
        ["rbxassetid://138720291317243"] = true,

    }

    local PARRY_RADIUS = 7.7

    local ParryClient =
        require(
            ReplicatedStorage.Modules.Items.ParryClient
        )

    local emoteHandler =
        ReplicatedStorage
            :WaitForChild("Remotes")
            :WaitForChild("EmoteHandler")

    local parryController = nil
    local currentTool = nil

    -- =====================================================
    -- SETUP PARRY
    -- =====================================================

    local function setupParry(character)

        parryController = nil
        currentTool = nil

        if not character then
            return
        end

        local tool =
            character:FindFirstChild(
                "Parrying Dagger"
            )

        if not tool then
            return
        end

        currentTool = tool

        parryController =
            ParryClient.new({

                tool = tool,

                animationId =
                    "109133187196613",

                lockDuration = 0.8,

                debug = false

            })

    end

    -- =====================================================
    -- RANGE CHECK
    -- =====================================================

    local function isInParryRange(
        attackerCharacter
    )

        local myCharacter =
            player.Character

        if not myCharacter then
            return false
        end

        local myRoot =
            myCharacter:FindFirstChild(
                "HumanoidRootPart"
            )

        local attackerRoot =
            attackerCharacter
                and attackerCharacter:FindFirstChild(
                    "HumanoidRootPart"
                )

        if not myRoot
            or not attackerRoot
        then
            return false
        end

        return (
            myRoot.Position
            -
            attackerRoot.Position
        ).Magnitude <= PARRY_RADIUS

    end

    -- =====================================================
    -- PERFORM PARRY
    -- =====================================================

    local function performParry(
        attackerCharacter
    )

        if not parryEnabled then
            return
        end

        if not isInParryRange(
            attackerCharacter
        ) then
            return
        end

        if not parryController then
            return
        end

        if not parryController:CanUse() then
            return
        end

        parryController:Parry()

        emoteHandler:FireServer(
            "StopEmote"
        )

    end

    -- =====================================================
    -- CHECK PARRY ANIMATION
    -- =====================================================

    local function isPlayingParryAnimation(
        attackerCharacter
    )

        local humanoid =
            attackerCharacter:FindFirstChildOfClass(
                "Humanoid"
            )

        if not humanoid then
            return false
        end

        local animator =
            humanoid:FindFirstChildOfClass(
                "Animator"
            )

        if not animator then
            return false
        end

        for _, track
            in ipairs(
                animator:GetPlayingAnimationTracks()
            )
        do

            if track.Animation then

                local animationId =
                    track.Animation.AnimationId

                if PARRY_ANIMATIONS[
                    animationId
                ]
                then
                    return true
                end

            end

        end

        return false

    end

    -- =====================================================
    -- MONITORING
    -- =====================================================

    local parryMonitorConnection

    parryMonitorConnection =
        RunService.Heartbeat:Connect(
            function()

                if not parryEnabled then
                    return
                end

                if not parryController then
                    return
                end

                local myCharacter =
                    player.Character

                local myRoot =
                    myCharacter
                        and myCharacter:FindFirstChild(
                            "HumanoidRootPart"
                        )

                if not myRoot then
                    return
                end

                for _, otherPlayer
                    in ipairs(
                        Players:GetPlayers()
                    )
                do

                    if otherPlayer ~= player then

                        local attackerCharacter =
                            otherPlayer.Character

                        if attackerCharacter then

                            local attackerRoot =
                                attackerCharacter:FindFirstChild(
                                    "HumanoidRootPart"
                                )

                            if attackerRoot then

                                local distance =
                                    (
                                        myRoot.Position
                                        -
                                        attackerRoot.Position
                                    ).Magnitude

                                if distance <= PARRY_RADIUS then

                                    if isPlayingParryAnimation(
                                        attackerCharacter
                                    )
                                    then

                                        performParry(
                                            attackerCharacter
                                        )

                                        break

                                    end

                                end

                            end

                        end

                    end

                end

            end
        )

    -- =====================================================
    -- SETUP LOCAL CHARACTER
    -- =====================================================

    local function setupLocalParryCharacter(
        character
    )

        setupParry(character)

        character.ChildAdded:Connect(
            function(child)

                if child:IsA("Tool")
                    and child.Name ==
                        "Parrying Dagger"
                then

                    setupParry(character)

                end

            end
        )

        character.ChildRemoved:Connect(
            function(child)

                if child == currentTool
                    or child.Name ==
                        "Parrying Dagger"
                then

                    currentTool = nil
                    parryController = nil

                    task.defer(
                        function()

                            if character
                                and character.Parent
                            then

                                setupParry(
                                    character
                                )

                            end

                        end
                    )

                end

            end
        )

    end

    -- =====================================================
    -- INITIAL CHARACTER
    -- =====================================================

    if player.Character then

        setupLocalParryCharacter(
            player.Character
        )

    end

    -- =====================================================
    -- CHARACTER ADDED
    -- =====================================================

    player.CharacterAdded:Connect(
        function(character)

            task.defer(
                function()

                    if not character.Parent then
                        return
                    end

                    character:WaitForChild(
                        "Humanoid",
                        10
                    )

                    character:WaitForChild(
                        "HumanoidRootPart",
                        10
                    )

                    setupLocalParryCharacter(
                        character
                    )

                end
            )

        end
    )

    -- =====================================================
    -- CHARACTER REMOVING
    -- =====================================================

    player.CharacterRemoving:Connect(
        function(character)

            currentTool = nil
            parryController = nil

        end
    )

    -- =====================================================
    -- PERIODIC TOOL CHECK
    -- =====================================================

    task.spawn(
        function()

            while true do

                task.wait(2)

                local currentCharacter =
                    player.Character

                local tool =
                    currentCharacter
                        and currentCharacter:FindFirstChild(
                            "Parrying Dagger"
                        )

                if tool ~= currentTool then

                    if tool then

                        setupParry(
                            currentCharacter
                        )

                    end

                end

            end

        end
    )

end

-- =========================================================
-- AUTO SKILL CHECK
-- =========================================================

do

    local skillCheckPlayerGui = player:WaitForChild("PlayerGui")
    local skillCheckScript = nil

    local Check = nil
    local Line = nil
    local Goal = nil

    local lastCheck = nil
    local lastLine = nil
    local lastGoal = nil

    local wasInSuccess = false
    local handleSkillCheck = nil

    local CollectionService = game:GetService("CollectionService")

    local endScourgeMode = nil
    local v_u_9 = nil

    local kingScourgeInputFunction = nil
    local kingScourgeWasInSuccess = false
    local kingScourgeConnection = nil


    -- =========================================================
    -- ПОИСК SKILLCHECK
    -- =========================================================

    local function updateSkillCheckReferences()

        local newScript = nil

        local character = player.Character

        if character then
            newScript = character:FindFirstChild("Skillcheck-gen")
        end

        if newScript ~= skillCheckScript then

            skillCheckScript = newScript

            Check = nil
            Line = nil
            Goal = nil

            handleSkillCheck = nil
            endScourgeMode = nil
            kingScourgeInputFunction = nil

            lastCheck = nil
            lastLine = nil
            lastGoal = nil

            wasInSuccess = false
            kingScourgeWasInSuccess = false

        end

        if not skillCheckScript then

            Check = nil
            Line = nil
            Goal = nil

            return false

        end

        local skillCheckGui =
            skillCheckPlayerGui:FindFirstChild("SkillCheckPromptGui")

        if not skillCheckGui then
            return false
        end

        local newCheck =
            skillCheckGui:FindFirstChild("Check")

        if not newCheck then
            return false
        end

        local newLine =
            newCheck:FindFirstChild("Line")

        local newGoal =
            newCheck:FindFirstChild("Goal")

        if not newLine or not newGoal then
            return false
        end

        local changed =
            Check ~= newCheck
            or Line ~= newLine
            or Goal ~= newGoal

        Check = newCheck
        Line = newLine
        Goal = newGoal

        if changed then

            lastCheck = Check
            lastLine = Line
            lastGoal = Goal

            handleSkillCheck = nil
            endScourgeMode = nil
            kingScourgeInputFunction = nil

            wasInSuccess = false
            kingScourgeWasInSuccess = false

        end

        return changed

    end


    -- =========================================================
    -- ПОИСК endScourgeMode
    -- =========================================================

    local function findEndScourgeMode()

        local callbacks = filtergc("function", {
            Upvalues = {
                Line,
                Goal
            }
        })

        for _, callback in callbacks do

            local ok, upvalues =
                pcall(debug.getupvalues, callback)

            if ok then

                for _, value in upvalues do

                    if type(value) == "function" then

                        local ok2, uv =
                            pcall(debug.getupvalues, value)

                        if ok2
                            and uv[4] == player
                            and uv[5] == CollectionService
                            and uv[8] == Check
                            and uv[9] == Line
                            and uv[10] == Goal
                        then
                            return value
                        end

                    end

                end

            end

        end

        return nil

    end


    -- =========================================================
    -- v_u_9
    -- =========================================================

    local function updateVU9()

        if not endScourgeMode then
            endScourgeMode = findEndScourgeMode()
        end

        if not endScourgeMode then

            v_u_9 = nil

            return nil

        end

        local ok, value =
            pcall(
                debug.getupvalue,
                endScourgeMode,
                1
            )

        if ok then

            v_u_9 = value

            return value

        end

        endScourgeMode = nil
        v_u_9 = nil

        return nil

    end


    -- =========================================================
    -- ПОИСК InputBegan CALLBACK
    -- =========================================================

    local function findKingScourgeInputFunction()

        local callbacks = filtergc("function", {
            Upvalues = {
                Line,
                Goal
            }
        })

        for _, callback in ipairs(callbacks) do

            local ok, upvalues =
                pcall(debug.getupvalues, callback)

            if ok then

                local constantsOk, constants =
                    pcall(debug.getconstants, callback)

                if constantsOk then

                    local hasSpace = false
                    local hasSuccess = false
                    local hasFireServer = false
                    local has1305 = false

                    for _, constant in ipairs(constants) do

                        if constant == "Space" then

                            hasSpace = true

                        elseif constant == "success" then

                            hasSuccess = true

                        elseif constant == "FireServer" then

                            hasFireServer = true

                        elseif constant == 130.5 then

                            has1305 = true

                        end

                    end

                    if upvalues[3] == Line
                        and upvalues[4] == Goal
                        and type(upvalues[5]) == "number"
                        and type(upvalues[6]) == "function"
                        and hasSpace
                        and hasSuccess
                        and hasFireServer
                        and has1305
                    then

                        return callback

                    end

                end

            end

        end

        return nil

    end


    -- =========================================================
    -- v_u_9 KING SCOURGE
    -- =========================================================

    local function getKingScourgeVU9()

        if not kingScourgeInputFunction then
            return nil
        end

        local ok, value =
            pcall(
                debug.getupvalue,
                kingScourgeInputFunction,
                2
            )

        if ok then
            return value
        end

        -- Старый callback больше недоступен
        kingScourgeInputFunction = nil

        return nil

    end


    -- =========================================================
    -- SUCCESS
    -- =========================================================

    local function kingScourgeSuccess()

        if not kingScourgeInputFunction then
            return
        end

        local ok

        local current10 =
            debug.getupvalue(
                kingScourgeInputFunction,
                5
            )

        local endScourgeMode =
            debug.getupvalue(
                kingScourgeInputFunction,
                6
            )

        local current14 =
            debug.getupvalue(
                kingScourgeInputFunction,
                7
            )

        local startScourgeSpin =
            debug.getupvalue(
                kingScourgeInputFunction,
                8
            )

        local KingScourgeHit =
            debug.getupvalue(
                kingScourgeInputFunction,
                9
            )

        local v_u_13 =
            debug.getupvalue(
                kingScourgeInputFunction,
                10
            )

        local Great =
            debug.getupvalue(
                kingScourgeInputFunction,
                11
            )

        local currentGoal =
            debug.getupvalue(
                kingScourgeInputFunction,
                4
            )

        ok = pcall(function()

            KingScourgeHit:FireServer(
                v_u_13,
                "success"
            )

            Great:Play()

            current10 = current10 - 1

            debug.setupvalue(
                kingScourgeInputFunction,
                5,
                current10
            )

            if current10 <= 0 then

                endScourgeMode()

            else

                currentGoal.Rotation =
                    Line.Rotation
                    + math.random(135, 225)
                    - 130.5

                if current14 then

                    current14:Cancel()

                    debug.setupvalue(
                        kingScourgeInputFunction,
                        7,
                        nil
                    )

                end

                startScourgeSpin()

            end

        end)

        if not ok then
            kingScourgeInputFunction = nil
        end

    end


    -- =========================================================
    -- START / STOP KING SCOURGE
    -- =========================================================

    local function startKingScourge()

        if kingScourgeConnection then
            return
        end

        kingScourgeWasInSuccess = false

        kingScourgeConnection =
            RunService.Heartbeat:Connect(function()

                if not kingScourgeEnabled then

                    kingScourgeWasInSuccess = false

                    return

                end

                local skillCheckChanged =
                    updateSkillCheckReferences()

                if not Check then

                    kingScourgeWasInSuccess = false

                    return

                end

                if skillCheckChanged then

                    kingScourgeInputFunction = nil
                    kingScourgeWasInSuccess = false

                end

                -- ПОСТОЯННЫЙ ПОИСК InputBegan

                if not kingScourgeInputFunction then

                    kingScourgeInputFunction =
                        findKingScourgeInputFunction()

                end

                if not kingScourgeInputFunction then

                    kingScourgeWasInSuccess = false

                    return

                end

                if not Check.Visible then

                    kingScourgeWasInSuccess = false

                    return

                end

                -- Актуальное значение v_u_9

                local v_u_9 =
                    getKingScourgeVU9()

                -- Если старый callback пропал во время проверки,
                -- сбрасываем его, и на следующем Heartbeat найдём заново

                if not kingScourgeInputFunction then

                    kingScourgeWasInSuccess = false

                    return

                end

                -- KingScourge работает только когда v_u_9 == true

                if v_u_9 ~= true then

                    kingScourgeWasInSuccess = false

                    return

                end

                local rotation = Line.Rotation
                local goalRotation = Goal.Rotation

                local successStart =
                    102 + goalRotation

                local successEnd =
                    116 + goalRotation

                local inSuccess =
                    rotation >= successStart
                    and rotation <= successEnd

                if inSuccess
                    and not kingScourgeWasInSuccess
                then

                    kingScourgeSuccess()

                end

                kingScourgeWasInSuccess = inSuccess

            end)

    end


    local function stopKingScourge()

        kingScourgeWasInSuccess = false
        kingScourgeInputFunction = nil

        if kingScourgeConnection then

            kingScourgeConnection:Disconnect()
            kingScourgeConnection = nil

        end

    end


    -- =========================================================
    -- ВКЛЮЧЕНИЕ KING SCOURGE
    -- =========================================================

    function setKingScourgeEnabled(enabled)

        kingScourgeEnabled = enabled

        if enabled then

            startKingScourge()

        else

            stopKingScourge()

        end

        setToggleVisual(
            kingScourgeToggle,
            kingScourgeKnob,
            enabled
        )

    end


    -- =========================================================
    -- ПОИСК handleSkillCheck
    -- =========================================================

    local function findHandleSkillCheck()

        local callbacks = filtergc("function", {
            Upvalues = {
                Line,
                Goal
            }
        })

        for _, callback in callbacks do

            local ok, upvalues =
                pcall(debug.getupvalues, callback)

            if ok then

                for _, value in upvalues do

                    if type(value) == "function" then

                        local constantsOk, constants =
                            pcall(debug.getconstants, value)

                        if constantsOk then

                            local hasSuccess = false

                            for _, constant in constants do

                                if constant == "success" then

                                    hasSuccess = true

                                    break

                                end

                            end

                            if hasSuccess then
                                return value
                            end

                        end

                    end

                end

            end

        end

        return nil

    end


    -- =========================================================
    -- MONITORING AUTO SKILL CHECK
    -- =========================================================

    autoSkillCheckConnection =
        RunService.Heartbeat:Connect(function()

            if not autoSkillCheckEnabled then

                wasInSuccess = false

                return

            end

            local skillCheckChanged =
                updateSkillCheckReferences()

            if not Check then

                wasInSuccess = false

                return

            end

            if skillCheckChanged then

                handleSkillCheck = nil
                endScourgeMode = nil
                wasInSuccess = false

            end

            local currentVU9 =
                updateVU9()

            if currentVU9 == true then

                wasInSuccess = false

                return

            end

            if not handleSkillCheck then

                handleSkillCheck =
                    findHandleSkillCheck()

            end

            if not handleSkillCheck then

                wasInSuccess = false

                return

            end

            if not Check.Visible then

                wasInSuccess = false

                return

            end

            local rotation = Line.Rotation
            local goalRotation = Goal.Rotation

            local successStart =
                102 + goalRotation

            local successEnd =
                116 + goalRotation

            local inSuccess =
                rotation >= successStart
                and rotation <= successEnd

            if inSuccess and not wasInSuccess then

                local ok =
                    pcall(
                        handleSkillCheck,
                        "success"
                    )

                if not ok then
                    handleSkillCheck = nil
                end

            end

            wasInSuccess = inSuccess

        end)


    -- =========================================================
    -- ВКЛЮЧЕНИЕ / ВЫКЛЮЧЕНИЕ AUTO SKILL CHECK
    -- =========================================================

    function setAutoSkillCheckEnabled(enabled)

        autoSkillCheckEnabled = enabled

        if not enabled then

            wasInSuccess = false
            handleSkillCheck = nil

        else

            updateSkillCheckReferences()

            if Check and Line and Goal then

                handleSkillCheck =
                    findHandleSkillCheck()

            else

                handleSkillCheck = nil

            end

        end

    end

end
local Main = {}

function Main.mount(ui)
    local mainPage = ui.mainPage
    local createToggle = ui.createToggle
    setToggleVisual = ui.setToggleVisual

-- =========================================================
-- CIRCLE
-- =========================================================

do
    local circleLabel = Instance.new("TextLabel")
    circleLabel.Name = "CircleLabel"
    circleLabel.Size = UDim2.new(0, 80, 0, 25)
    circleLabel.Position = UDim2.new(0, 10, 0, 5)
    circleLabel.BackgroundTransparency = 1
    circleLabel.Text = "circle"
    circleLabel.TextColor3 = Color3.fromRGB(242, 242, 242)
    circleLabel.TextSize = 12
    circleLabel.Font = Enum.Font.SourceSans
    circleLabel.TextXAlignment = Enum.TextXAlignment.Left
    circleLabel.TextYAlignment = Enum.TextYAlignment.Center
    circleLabel.Parent = mainPage

    local toggle, knob = createToggle(mainPage, 11)

    toggle.MouseButton1Click:Connect(function()
        circleEnabled = not circleEnabled

        if circleEnabled then
            createCircle()
        else
            destroyCircle()
        end

        setToggleVisual(toggle, knob, circleEnabled)
    end)

    -- =========================================================
    -- PARRY
    -- =========================================================

    local parryLabel = Instance.new("TextLabel")
    parryLabel.Name = "ParryLabel"
    parryLabel.Size = UDim2.new(0, 110, 0, 25)
    parryLabel.Position = UDim2.new(0, 10, 0, 36)
    parryLabel.BackgroundTransparency = 1
    parryLabel.Text = "Parry"
    parryLabel.TextColor3 = Color3.fromRGB(242, 242, 242)
    parryLabel.TextSize = 12
    parryLabel.Font = Enum.Font.SourceSans
    parryLabel.TextXAlignment = Enum.TextXAlignment.Left
    parryLabel.TextYAlignment = Enum.TextYAlignment.Center
    parryLabel.Parent = mainPage

    parryKeyButton = Instance.new("TextButton")
    parryKeyButton.Name = "ParryKeyButton"
    parryKeyButton.Size = UDim2.new(0, 32, 0, 18)
    parryKeyButton.Position = UDim2.new(1, -88, 0, 42)
    parryKeyButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    parryKeyButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    parryKeyButton.Text = parryHotkey.Name
    parryKeyButton.TextSize = 10
    parryKeyButton.Font = Enum.Font.SourceSans
    parryKeyButton.BorderSizePixel = 0
    parryKeyButton.AutoButtonColor = false
    parryKeyButton.Parent = mainPage

    local parryKeyCorner = Instance.new("UICorner")
    parryKeyCorner.CornerRadius = UDim.new(0, 3)
    parryKeyCorner.Parent = parryKeyButton

    parryToggle, parryKnob = createToggle(mainPage, 42)

    setToggleVisual(parryToggle, parryKnob, false)

    -- =========================================================
    -- AUTO SKILL CHECK 
    -- =========================================================

    local autoSkillCheckLabel = Instance.new("TextLabel")

    autoSkillCheckLabel.Name = "AutoSkillCheckLabel"
    autoSkillCheckLabel.Size = UDim2.new(0, 110, 0, 25)
    autoSkillCheckLabel.Position = UDim2.new(0, 10, 0, 67)
    autoSkillCheckLabel.BackgroundTransparency = 1
    autoSkillCheckLabel.Text = "Auto Skill Check"
    autoSkillCheckLabel.TextColor3 = Color3.fromRGB(242, 242, 242)
    autoSkillCheckLabel.TextSize = 12
    autoSkillCheckLabel.Font = Enum.Font.SourceSans
    autoSkillCheckLabel.TextXAlignment = Enum.TextXAlignment.Left
    autoSkillCheckLabel.TextYAlignment = Enum.TextYAlignment.Center
    autoSkillCheckLabel.Parent = mainPage

    local autoSkillCheckToggle, autoSkillCheckKnob =
        createToggle(mainPage, 73)

    setToggleVisual(
        autoSkillCheckToggle,
        autoSkillCheckKnob,
        false
    )

    autoSkillCheckToggle.MouseButton1Click:Connect(function()
        setAutoSkillCheckEnabled(not autoSkillCheckEnabled)

        setToggleVisual(
            autoSkillCheckToggle,
            autoSkillCheckKnob,
            autoSkillCheckEnabled
        )
    end)

    -- =========================================================
    -- KINGSCOURGE GUI
    -- =========================================================

    local kingScourgeLabel = Instance.new("TextLabel")

    kingScourgeLabel.Name = "KingScourgeLabel"
    kingScourgeLabel.Size = UDim2.new(0, 110, 0, 25)
    kingScourgeLabel.Position = UDim2.new(0, 10, 0, 98)
    kingScourgeLabel.BackgroundTransparency = 1
    kingScourgeLabel.Text = "KingScourge"
    kingScourgeLabel.TextColor3 = Color3.fromRGB(242, 242, 242)
    kingScourgeLabel.TextSize = 12
    kingScourgeLabel.Font = Enum.Font.SourceSans
    kingScourgeLabel.TextXAlignment = Enum.TextXAlignment.Left
    kingScourgeLabel.TextYAlignment = Enum.TextYAlignment.Center
    kingScourgeLabel.Parent = mainPage

    kingScourgeToggle, kingScourgeKnob =
        createToggle(mainPage, 104)

    setToggleVisual(
        kingScourgeToggle,
        kingScourgeKnob,
        false
    )

    kingScourgeToggle.MouseButton1Click:Connect(function()
        setKingScourgeEnabled(
            not kingScourgeEnabled
        )
    end)
end
end

parryToggle.MouseButton1Click:Connect(function()
    Main.toggleParry()
end)
parryKeyButton.MouseButton1Click:Connect(function()
    Main.beginHotkey()
end)

function Main.setParryEnabled(enabled)
    parryEnabled = enabled
    setToggleVisual(parryToggle, parryKnob, enabled)
end

function Main.toggleParry()
    Main.setParryEnabled(not parryEnabled)
end

function Main.handleKey(key)
    if key == parryHotkey then Main.toggleParry(); return true end
    return false
end

function Main.beginHotkey()
    waitingForHotkey = true
    parryKeyButton.Text = "..."
end

function Main.assignHotkey(key)
    if not waitingForHotkey then return false end
    if key ~= Enum.KeyCode.Escape then parryHotkey = key end
    parryKeyButton.Text = parryHotkey.Name
    waitingForHotkey = nil
    return true
end

function Main.destroy()
    setAutoSkillCheckEnabled(false)
    setKingScourgeEnabled(false)
    destroyCircle()
    if autoSkillCheckConnection then
        autoSkillCheckConnection:Disconnect()
        autoSkillCheckConnection = nil
    end
end

return Main
