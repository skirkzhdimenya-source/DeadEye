local Main = {}

-- =========================================================
-- SERVICES
-- =========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- =========================================================
-- UI REFERENCES
-- =========================================================

local mainPage = nil
local createToggle = nil
local setToggleVisual = nil

local parryToggle = nil
local parryKnob = nil
local parryKeyButton = nil

-- =========================================================
-- STATES
-- =========================================================

local circleEnabled = false
local parryEnabled = false
local autoSkillCheckEnabled = false
local kingScourgeEnabled = false

local parryHotkey = Enum.KeyCode.Z
local waitingForParryHotkey = false

-- =========================================================
-- CONNECTIONS
-- =========================================================

local connections = {}

local function addConnection(connection)
    if connection then
        table.insert(connections, connection)
    end

    return connection
end

local function disconnectConnection(connection)
    if connection then
        pcall(function()
            connection:Disconnect()
        end)
    end
end

local function disconnectAll()
    for _, connection in ipairs(connections) do
        disconnectConnection(connection)
    end

    table.clear(connections)
end

-- =========================================================
-- CIRCLE
-- =========================================================

local circleRadius = 7.7
local circleLineThickness = 0.2
local circleSegments = 128

local circleFolder = nil
local circleParts = {}
local circleConnection = nil

local localRoot = nil
local characterAddedConnection = nil

local function updateLocalRoot(character)
    if not character then
        localRoot = nil
        return
    end

    localRoot =
        character:FindFirstChild("HumanoidRootPart")
        or character:WaitForChild("HumanoidRootPart", 10)
end

updateLocalRoot(player.Character)

characterAddedConnection =
    addConnection(
        player.CharacterAdded:Connect(function(character)
            updateLocalRoot(character)
        end)
    )

local function createCircle()

    if circleFolder then
        return
    end

    circleFolder = Instance.new("Folder")
    circleFolder.Name = "CircleZone"
    circleFolder.Parent = Workspace

    table.clear(circleParts)

    local segmentLength =
        (
            2
            * math.pi
            * circleRadius
            / circleSegments
        ) + 0.2

    for i = 1, circleSegments do

        local part = Instance.new("Part")

        part.Size =
            Vector3.new(
                circleLineThickness,
                0.15,
                segmentLength
            )

        part.Material = Enum.Material.Neon
        part.Transparency = 0.3

        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false

        part.Anchored = true
        part.Parent = circleFolder

        table.insert(circleParts, part)
    end

    circleConnection =
        addConnection(
            RunService.RenderStepped:Connect(function()

                if not localRoot
                    or not localRoot.Parent
                then
                    return
                end

                for i, part in ipairs(circleParts) do

                    local angle =
                        (
                            i
                            / circleSegments
                        )
                        * math.pi
                        * 2

                    local position =
                        localRoot.Position
                        + Vector3.new(
                            math.cos(angle)
                                * circleRadius,

                            -3,

                            math.sin(angle)
                                * circleRadius
                        )

                    part.Position = position

                    part.CFrame =
                        CFrame.new(position)
                        * CFrame.Angles(
                            0,
                            -angle,
                            0
                        )
                end

            end)
        )
end

local function destroyCircle()

    if circleConnection then
        disconnectConnection(circleConnection)
        circleConnection = nil
    end

    for _, part in ipairs(circleParts) do
        if part then
            pcall(function()
                part:Destroy()
            end)
        end
    end

    table.clear(circleParts)

    if circleFolder then
        pcall(function()
            circleFolder:Destroy()
        end)

        circleFolder = nil
    end
end

-- =========================================================
-- PARRY
-- =========================================================

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

local parryMonitorConnection = nil

local localParryConnections = {}

local function disconnectLocalParryConnections()

    for _, connection in ipairs(localParryConnections) do

        disconnectConnection(connection)

    end

    table.clear(localParryConnections)
end

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

    local ok, controller =
        pcall(
            function()

                return ParryClient.new({

                    tool = tool,

                    animationId =
                        "109133187196613",

                    lockDuration = 0.8,

                    debug = false

                })

            end
        )

    if ok then
        parryController = controller
    end

end

local function isInParryRange(attackerCharacter)

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
        - attackerRoot.Position
    ).Magnitude <= PARRY_RADIUS
end

local function performParry(attackerCharacter)

    if not parryEnabled then
        return
    end

    if not isInParryRange(attackerCharacter) then
        return
    end

    if not parryController then
        return
    end

    local canUseOk, canUse =
        pcall(
            function()
                return parryController:CanUse()
            end
        )

    if not canUseOk
        or not canUse
    then
        return
    end

    pcall(function()
        parryController:Parry()
    end)

    pcall(function()
        emoteHandler:FireServer("StopEmote")
    end)
end

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

    for _, track in ipairs(
        animator:GetPlayingAnimationTracks()
    ) do

        if track.Animation then

            local animationId =
                track.Animation.AnimationId

            if PARRY_ANIMATIONS[animationId] then
                return true
            end

        end
    end

    return false
end

local function startParryMonitor()

    if parryMonitorConnection then
        return
    end

    parryMonitorConnection =
        addConnection(
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

                    for _, otherPlayer in ipairs(
                        Players:GetPlayers()
                    ) do

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
                                            - attackerRoot.Position
                                        ).Magnitude

                                    if distance <= PARRY_RADIUS then

                                        if isPlayingParryAnimation(
                                            attackerCharacter
                                        ) then

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
        )
end

local function stopParryMonitor()

    if parryMonitorConnection then

        disconnectConnection(
            parryMonitorConnection
        )

        parryMonitorConnection = nil
    end
end

local function setupLocalParryCharacter(
    character
)

    disconnectLocalParryConnections()

    setupParry(character)

    if not character then
        return
    end

    table.insert(
        localParryConnections,

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
    )

    table.insert(
        localParryConnections,

        character.ChildRemoved:Connect(
            function(child)

                if child == currentTool
                    or child.Name ==
                        "Parrying Dagger"
                then

                    currentTool = nil
                    parryController = nil

                    task.defer(function()

                        if character
                            and character.Parent
                        then

                            setupParry(
                                character
                            )
                        end

                    end)

                end

            end
        )
    )
end

local function setupInitialParry()

    if player.Character then

        setupLocalParryCharacter(
            player.Character
        )

    end
end

setupInitialParry()

addConnection(
    player.CharacterAdded:Connect(
        function(character)

            task.defer(function()

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

            end)

        end
    )
)

addConnection(
    player.CharacterRemoving:Connect(
        function(character)

            currentTool = nil
            parryController = nil

            disconnectLocalParryConnections()

        end
    )
)

task.spawn(function()

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

            else

                currentTool = nil
                parryController = nil

            end
        end
    end
end)

startParryMonitor()

-- =========================================================
-- AUTO SKILL CHECK
-- =========================================================

local skillCheckPlayerGui =
    player:WaitForChild("PlayerGui")

local skillCheckScript = nil

local Check = nil
local Line = nil
local Goal = nil

local lastCheck = nil
local lastLine = nil
local lastGoal = nil

local wasInSuccess = false

local handleSkillCheck = nil
local endScourgeMode = nil
local v_u_9 = nil

local kingScourgeInputFunction = nil
local kingScourgeWasInSuccess = false
local kingScourgeConnection = nil

local CollectionService =
    game:GetService("CollectionService")

-- =========================================================
-- FIND SKILLCHECK
-- =========================================================

local function updateSkillCheckReferences()

    local newScript = nil

    local character = player.Character

    if character then

        newScript =
            character:FindFirstChild(
                "Skillcheck-gen"
            )

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
        skillCheckPlayerGui:FindFirstChild(
            "SkillCheckPromptGui"
        )

    if not skillCheckGui then
        return false
    end

    local newCheck =
        skillCheckGui:FindFirstChild(
            "Check"
        )

    if not newCheck then
        return false
    end

    local newLine =
        newCheck:FindFirstChild(
            "Line"
        )

    local newGoal =
        newCheck:FindFirstChild(
            "Goal"
        )

    if not newLine
        or not newGoal
    then
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
-- FIND endScourgeMode
-- =========================================================

local function findEndScourgeMode()

    if not Line
        or not Goal
    then
        return nil
    end

    local callbacks =
        filtergc(
            "function",
            {
                Upvalues = {
                    Line,
                    Goal
                }
            }
        )

    for _, callback in callbacks do

        local ok, upvalues =
            pcall(
                debug.getupvalues,
                callback
            )

        if ok then

            for _, value in upvalues do

                if type(value) == "function" then

                    local ok2, uv =
                        pcall(
                            debug.getupvalues,
                            value
                        )

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

        endScourgeMode =
            findEndScourgeMode()

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
-- FIND KING SCOURGE INPUT FUNCTION
-- =========================================================

local function findKingScourgeInputFunction()

    if not Line
        or not Goal
    then
        return nil
    end

    local callbacks =
        filtergc(
            "function",
            {
                Upvalues = {
                    Line,
                    Goal
                }
            }
        )

    for _, callback in ipairs(callbacks) do

        local ok, upvalues =
            pcall(
                debug.getupvalues,
                callback
            )

        if ok then

            local constantsOk, constants =
                pcall(
                    debug.getconstants,
                    callback
                )

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
-- KING SCOURGE v_u_9
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

    kingScourgeInputFunction = nil

    return nil
end

-- =========================================================
-- KING SCOURGE SUCCESS
-- =========================================================

local function kingScourgeSuccess()

    if not kingScourgeInputFunction then
        return
    end

    local ok =
        pcall(function()

            local current10 =
                debug.getupvalue(
                    kingScourgeInputFunction,
                    5
                )

            local endScourgeModeFn =
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

            if type(current10) ~= "number"
                or type(endScourgeModeFn) ~= "function"
                or not currentGoal
                or not Line
            then
                error("Invalid KingScourge upvalues")
            end

            KingScourgeHit:FireServer(
                v_u_13,
                "success"
            )

            Great:Play()

            current10 =
                current10 - 1

            debug.setupvalue(
                kingScourgeInputFunction,
                5,
                current10
            )

            if current10 <= 0 then

                endScourgeModeFn()

            else

                currentGoal.Rotation =
                    Line.Rotation
                    + math.random(
                        135,
                        225
                    )
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
-- START KING SCOURGE
-- =========================================================

local function startKingScourge()

    if kingScourgeConnection then
        return
    end

    kingScourgeWasInSuccess = false

    kingScourgeConnection =
        RunService.Heartbeat:Connect(
            function()

                if not kingScourgeEnabled then

                    kingScourgeWasInSuccess =
                        false

                    return
                end

                local skillCheckChanged =
                    updateSkillCheckReferences()

                if not Check then

                    kingScourgeWasInSuccess =
                        false

                    return
                end

                if skillCheckChanged then

                    kingScourgeInputFunction =
                        nil

                    kingScourgeWasInSuccess =
                        false
                end

                if not kingScourgeInputFunction then

                    kingScourgeInputFunction =
                        findKingScourgeInputFunction()
                end

                if not kingScourgeInputFunction then

                    kingScourgeWasInSuccess =
                        false

                    return
                end

                if not Check.Visible then

                    kingScourgeWasInSuccess =
                        false

                    return
                end

                local currentVU9 =
                    getKingScourgeVU9()

                if not kingScourgeInputFunction then

                    kingScourgeWasInSuccess =
                        false

                    return
                end

                if currentVU9 ~= true then

                    kingScourgeWasInSuccess =
                        false

                    return
                end

                local rotation =
                    Line.Rotation

                local goalRotation =
                    Goal.Rotation

                local successStart =
                    102
                    + goalRotation

                local successEnd =
                    116
                    + goalRotation

                local inSuccess =
                    rotation >= successStart
                    and rotation <= successEnd

                if inSuccess
                    and not kingScourgeWasInSuccess
                then

                    kingScourgeSuccess()
                end

                kingScourgeWasInSuccess =
                    inSuccess
            end
        )
end

local function stopKingScourge()

    kingScourgeWasInSuccess = false
    kingScourgeInputFunction = nil

    if kingScourgeConnection then

        disconnectConnection(
            kingScourgeConnection
        )

        kingScourgeConnection = nil
    end
end

local function setKingScourgeEnabled(
    enabled
)

    kingScourgeEnabled = enabled

    if enabled then

        startKingScourge()

    else

        stopKingScourge()
    end

    if kingScourgeToggle
        and kingScourgeKnob
    then

        setToggleVisual(
            kingScourgeToggle,
            kingScourgeKnob,
            enabled
        )
    end
end

-- =========================================================
-- FIND handleSkillCheck
-- =========================================================

local function findHandleSkillCheck()

    if not Line
        or not Goal
    then
        return nil
    end

    local callbacks =
        filtergc(
            "function",
            {
                Upvalues = {
                    Line,
                    Goal
                }
            }
        )

    for _, callback in callbacks do

        local ok, upvalues =
            pcall(
                debug.getupvalues,
                callback
            )

        if ok then

            for _, value in upvalues do

                if type(value) == "function" then

                    local constantsOk, constants =
                        pcall(
                            debug.getconstants,
                            value
                        )

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
-- AUTO SKILL CHECK CONNECTION
-- =========================================================

local autoSkillCheckConnection = nil

local function startAutoSkillCheck()

    if autoSkillCheckConnection then
        return
    end

    autoSkillCheckConnection =
        RunService.Heartbeat:Connect(
            function()

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

                local rotation =
                    Line.Rotation

                local goalRotation =
                    Goal.Rotation

                local successStart =
                    102
                    + goalRotation

                local successEnd =
                    116
                    + goalRotation

                local inSuccess =
                    rotation >= successStart
                    and rotation <= successEnd

                if inSuccess
                    and not wasInSuccess
                then

                    local ok =
                        pcall(
                            handleSkillCheck,
                            "success"
                        )

                    if not ok then

                        handleSkillCheck =
                            nil
                    end
                end

                wasInSuccess =
                    inSuccess
            end
        )
end

startAutoSkillCheck()

local function setAutoSkillCheckEnabled(
    enabled
)

    autoSkillCheckEnabled = enabled

    if not enabled then

        wasInSuccess = false
        handleSkillCheck = nil

    else

        updateSkillCheckReferences()

        if Check
            and Line
            and Goal
        then

            handleSkillCheck =
                findHandleSkillCheck()

        else

            handleSkillCheck = nil
        end
    end
end

-- =========================================================
-- GUI REFERENCES
-- =========================================================

local kingScourgeToggle = nil
local kingScourgeKnob = nil

local autoSkillCheckToggle = nil
local autoSkillCheckKnob = nil

-- =========================================================
-- MAIN MOUNT
-- =========================================================

function Main.mount(ui)

    if not ui then
        error("Main.mount: ui is required")
    end

    mainPage =
        assert(
            ui.mainPage,
            "Main.mount: mainPage is missing"
        )

    createToggle =
        assert(
            ui.createToggle,
            "Main.mount: createToggle is missing"
        )

    setToggleVisual =
        assert(
            ui.setToggleVisual,
            "Main.mount: setToggleVisual is missing"
        )

    -- =====================================================
    -- CIRCLE GUI
    -- =====================================================

    local circleLabel =
        Instance.new("TextLabel")

    circleLabel.Name =
        "CircleLabel"

    circleLabel.Size =
        UDim2.new(
            0,
            80,
            0,
            25
        )

    circleLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            5
        )

    circleLabel.BackgroundTransparency = 1
    circleLabel.Text = "circle"

    circleLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    circleLabel.TextSize = 12
    circleLabel.Font =
        Enum.Font.SourceSans

    circleLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    circleLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    circleLabel.Parent = mainPage

    local circleToggle, circleKnob =
        createToggle(
            mainPage,
            11
        )

    setToggleVisual(
        circleToggle,
        circleKnob,
        circleEnabled
    )

    addConnection(
        circleToggle.MouseButton1Click:Connect(
            function()

                circleEnabled =
                    not circleEnabled

                if circleEnabled then
                    createCircle()
                else
                    destroyCircle()
                end

                setToggleVisual(
                    circleToggle,
                    circleKnob,
                    circleEnabled
                )

            end
        )
    )

    -- =====================================================
    -- PARRY GUI
    -- =====================================================

    local parryLabel =
        Instance.new("TextLabel")

    parryLabel.Name =
        "ParryLabel"

    parryLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    parryLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            36
        )

    parryLabel.BackgroundTransparency = 1
    parryLabel.Text = "Parry"

    parryLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    parryLabel.TextSize = 12
    parryLabel.Font =
        Enum.Font.SourceSans

    parryLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    parryLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    parryLabel.Parent = mainPage

    parryKeyButton =
        Instance.new("TextButton")

    parryKeyButton.Name =
        "ParryKeyButton"

    parryKeyButton.Size =
        UDim2.new(
            0,
            32,
            0,
            18
        )

    parryKeyButton.Position =
        UDim2.new(
            1,
            -88,
            0,
            42
        )

    parryKeyButton.BackgroundColor3 =
        Color3.fromRGB(
            55,
            55,
            55
        )

    parryKeyButton.TextColor3 =
        Color3.fromRGB(
            200,
            200,
            200
        )

    parryKeyButton.Text =
        parryHotkey.Name

    parryKeyButton.TextSize = 10
    parryKeyButton.Font =
        Enum.Font.SourceSans

    parryKeyButton.BorderSizePixel = 0
    parryKeyButton.AutoButtonColor = false
    parryKeyButton.Parent = mainPage

    local parryKeyCorner =
        Instance.new("UICorner")

    parryKeyCorner.CornerRadius =
        UDim.new(
            0,
            3
        )

    parryKeyCorner.Parent =
        parryKeyButton

    parryToggle,
    parryKnob =
        createToggle(
            mainPage,
            42
        )

    setToggleVisual(
        parryToggle,
        parryKnob,
        parryEnabled
    )

    -- ВАЖНО:
    -- обработчик находится внутри mount,
    -- после создания parryToggle.

    addConnection(
        parryToggle.MouseButton1Click:Connect(
            function()

                parryEnabled =
                    not parryEnabled

                setToggleVisual(
                    parryToggle,
                    parryKnob,
                    parryEnabled
                )

            end
        )
    )

    addConnection(
        parryKeyButton.MouseButton1Click:Connect(
            function()

                waitingForParryHotkey = true
                parryKeyButton.Text = "..."

            end
        )
    )

    -- =====================================================
    -- AUTO SKILL CHECK GUI
    -- =====================================================

    local autoSkillCheckLabel =
        Instance.new("TextLabel")

    autoSkillCheckLabel.Name =
        "AutoSkillCheckLabel"

    autoSkillCheckLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    autoSkillCheckLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            67
        )

    autoSkillCheckLabel.BackgroundTransparency = 1

    autoSkillCheckLabel.Text =
        "Auto Skill Check"

    autoSkillCheckLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    autoSkillCheckLabel.TextSize = 12
    autoSkillCheckLabel.Font =
        Enum.Font.SourceSans

    autoSkillCheckLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    autoSkillCheckLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    autoSkillCheckLabel.Parent =
        mainPage

    autoSkillCheckToggle,
    autoSkillCheckKnob =
        createToggle(
            mainPage,
            73
        )

    setToggleVisual(
        autoSkillCheckToggle,
        autoSkillCheckKnob,
        autoSkillCheckEnabled
    )

    addConnection(
        autoSkillCheckToggle.MouseButton1Click:Connect(
            function()

                setAutoSkillCheckEnabled(
                    not autoSkillCheckEnabled
                )

                setToggleVisual(
                    autoSkillCheckToggle,
                    autoSkillCheckKnob,
                    autoSkillCheckEnabled
                )

            end
        )
    )

    -- =====================================================
    -- KINGSCOURGE GUI
    -- =====================================================

    local kingScourgeLabel =
        Instance.new("TextLabel")

    kingScourgeLabel.Name =
        "KingScourgeLabel"

    kingScourgeLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    kingScourgeLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            98
        )

    kingScourgeLabel.BackgroundTransparency = 1
    kingScourgeLabel.Text = "KingScourge"

    kingScourgeLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    kingScourgeLabel.TextSize = 12
    kingScourgeLabel.Font =
        Enum.Font.SourceSans

    kingScourgeLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    kingScourgeLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    kingScourgeLabel.Parent =
        mainPage

    kingScourgeToggle,
    kingScourgeKnob =
        createToggle(
            mainPage,
            104
        )

    setToggleVisual(
        kingScourgeToggle,
        kingScourgeKnob,
        kingScourgeEnabled
    )

    addConnection(
        kingScourgeToggle.MouseButton1Click:Connect(
            function()

                setKingScourgeEnabled(
                    not kingScourgeEnabled
                )

            end
        )
    )

end

-- =========================================================
-- HOTKEY API
-- =========================================================

function Main.beginHotkey()

    if not parryKeyButton then
        return
    end

    waitingForParryHotkey = true
    parryKeyButton.Text = "..."
end

function Main.assignHotkey(key)

    if not waitingForParryHotkey then
        return false
    end

    if key == Enum.KeyCode.Escape then

        waitingForParryHotkey = false

        if parryKeyButton then
            parryKeyButton.Text =
                parryHotkey.Name
        end

        return true
    end

    parryHotkey = key
    waitingForParryHotkey = false

    if parryKeyButton then
        parryKeyButton.Text =
            parryHotkey.Name
    end

    return true
end

function Main.handleKey(key)

    if waitingForParryHotkey then
        return false
    end

    if key == parryHotkey then

        parryEnabled =
            not parryEnabled

        if parryToggle
            and parryKnob
        then

            setToggleVisual(
                parryToggle,
                parryKnob,
                parryEnabled
            )
        end

        return true
    end

    return false
end

-- =========================================================
-- PUBLIC STATE FUNCTIONS
-- =========================================================

function Main.setParryEnabled(enabled)

    parryEnabled = enabled

    if parryToggle
        and parryKnob
    then

        setToggleVisual(
            parryToggle,
            parryKnob,
            enabled
        )
    end
end

function Main.toggleParry()

    Main.setParryEnabled(
        not parryEnabled
    )
end

function Main.setCircleEnabled(enabled)

    circleEnabled = enabled

    if enabled then
        createCircle()
    else
        destroyCircle()
    end
end

function Main.setAutoSkillCheckEnabled(enabled)

    setAutoSkillCheckEnabled(enabled)

    if autoSkillCheckToggle
        and autoSkillCheckKnob
    then

        setToggleVisual(
            autoSkillCheckToggle,
            autoSkillCheckKnob,
            enabled
        )
    end
end

function Main.setKingScourgeEnabled(enabled)

    setKingScourgeEnabled(enabled)
end

-- =========================================================
-- DESTROY
-- =========================================================

function Main.destroy()

    waitingForParryHotkey = false

    parryEnabled = false
    circleEnabled = false
    autoSkillCheckEnabled = false
    kingScourgeEnabled = false

    destroyCircle()

    stopParryMonitor()
    stopKingScourge()

    if autoSkillCheckConnection then

        disconnectConnection(
            autoSkillCheckConnection
        )

        autoSkillCheckConnection = nil
    end

    disconnectLocalParryConnections()

    parryController = nil
    currentTool = nil

    disconnectAll()

    parryToggle = nil
    parryKnob = nil
    parryKeyButton = nil

    autoSkillCheckToggle = nil
    autoSkillCheckKnob = nil

    kingScourgeToggle = nil
    kingScourgeKnob = nil

    mainPage = nil
    createToggle = nil
    setToggleVisual = nil
end

return Main
