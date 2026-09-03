local G = getgenv().DeadEye

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local root =
    (player.Character or player.CharacterAdded:Wait())
        :WaitForChild("HumanoidRootPart")

local mainPage = G.UI.MainPage

print("[Main] запущен")
print("[Main] MainPage найден:", mainPage ~= nil)

-- =========================================================
-- ОБЩИЕ GUI ФУНКЦИИ
-- =========================================================

local createToggle = G.Functions.createToggle
local setToggleVisual = G.Functions.setToggleVisual

-- =========================================================
-- CIRCLE
-- =========================================================

local circleEnabled = false

local radius = 7.7
local lineThickness = 0.2
local segments = 128

local folder = nil
local parts = {}
local circleConnection = nil

local function createCircle()

    if folder then
        return
    end

    folder = Instance.new("Folder")
    folder.Name = "CircleZone"
    folder.Parent = workspace

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

        local part = Instance.new("Part")

        part.Size =
            Vector3.new(
                lineThickness,
                0.15,
                segmentLength
            )

        part.Material = Enum.Material.Neon
        part.Transparency = 0.3

        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false

        part.Anchored = true
        part.Parent = folder

        table.insert(parts, part)

    end

    circleConnection =
        RunService.RenderStepped:Connect(
            function()

                if not root
                    or not root.Parent
                then
                    return
                end

                for i, part in ipairs(parts) do

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

                    part.Position = position

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

local function destroyCircle()

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

G.Cleanup.Circle = function()

    circleEnabled = false

    destroyCircle()

end

-- =========================================================
-- CIRCLE GUI
-- =========================================================

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

local circleToggle, circleKnob =
    createToggle(mainPage, 11)

setToggleVisual(
    circleToggle,
    circleKnob,
    false
)

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

-- =========================================================
-- PARRY
-- =========================================================

do

    local ReplicatedStorage =
        game:GetService("ReplicatedStorage")

    local parryEnabled = false
    local parryHotkey = Enum.KeyCode.Z

    local parryMonitorConnection = nil
    local parryCharacterAddedConnection = nil
    local parryCharacterRemovingConnection = nil
    local parryChildAddedConnection = nil
    local parryChildRemovedConnection = nil
    local parryInputConnection = nil

    local parryLoopRunning = true

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

        if parryChildAddedConnection then

            parryChildAddedConnection:Disconnect()
            parryChildAddedConnection = nil

        end

        if parryChildRemovedConnection then

            parryChildRemovedConnection:Disconnect()
            parryChildRemovedConnection = nil

        end

        parryChildAddedConnection =
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

        parryChildRemovedConnection =
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

                                if not parryLoopRunning then
                                    return
                                end

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

    parryCharacterAddedConnection =
        player.CharacterAdded:Connect(
            function(character)

                task.defer(
                    function()

                        if not parryLoopRunning then
                            return
                        end

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

                        if not parryLoopRunning then
                            return
                        end

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

    parryCharacterRemovingConnection =
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

            while parryLoopRunning do

                task.wait(2)

                if not parryLoopRunning then
                    break
                end

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

        end
    )

    -- =====================================================
    -- PARRY GUI
    -- =====================================================

    local parryLabel =
        Instance.new("TextLabel")

    parryLabel.Name =
        "ParryLabel"

    parryLabel.Size =
        UDim2.new(0, 110, 0, 25)

    parryLabel.Position =
        UDim2.new(0, 10, 0, 36)

    parryLabel.BackgroundTransparency = 1

    parryLabel.Text =
        "Parry"

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

    parryLabel.Parent =
        mainPage

    local parryKeyButton =
        Instance.new("TextButton")

    parryKeyButton.Name =
        "ParryKeyButton"

    parryKeyButton.Size =
        UDim2.new(0, 32, 0, 18)

    parryKeyButton.Position =
        UDim2.new(1, -88, 0, 42)

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
        UDim.new(0, 3)

    parryKeyCorner.Parent =
        parryKeyButton

    local parryToggle, parryKnob =
        createToggle(
            mainPage,
            42
        )

    setToggleVisual(
        parryToggle,
        parryKnob,
        false
    )

    -- =====================================================
    -- PARRY TOGGLE
    -- =====================================================

    local function setParryEnabled(enabled)

        parryEnabled = enabled

        setToggleVisual(
            parryToggle,
            parryKnob,
            enabled
        )

    end

    parryToggle.MouseButton1Click:Connect(
        function()

            setParryEnabled(
                not parryEnabled
            )

        end
    )

    -- =====================================================
    -- PARRY HOTKEY CHANGE
    -- =====================================================

    local waitingForParryHotkey = false

    parryKeyButton.MouseButton1Click:Connect(
        function()

            waitingForParryHotkey = true
            parryKeyButton.Text = "..."

        end
    )

    parryInputConnection =
        UserInputService.InputBegan:Connect(
            function(input)

                if input.UserInputType ~=
                    Enum.UserInputType.Keyboard
                then
                    return
                end

                if waitingForParryHotkey then

                    if input.KeyCode ==
                        Enum.KeyCode.Escape
                    then

                        waitingForParryHotkey = false
                        parryKeyButton.Text =
                            parryHotkey.Name

                        return

                    end

                    parryHotkey =
                        input.KeyCode

                    parryKeyButton.Text =
                        parryHotkey.Name

                    waitingForParryHotkey = false

                    return

                end

                if input.KeyCode ==
                    parryHotkey
                then

                    setParryEnabled(
                        not parryEnabled
                    )

                end

            end
        )

    -- =====================================================
    -- PARRY CLEANUP
    -- =====================================================

    G.Cleanup.Parry = function()

        parryEnabled = false
        parryLoopRunning = false
        waitingForParryHotkey = false

        if parryMonitorConnection then

            parryMonitorConnection:Disconnect()
            parryMonitorConnection = nil

        end

        if parryCharacterAddedConnection then

            parryCharacterAddedConnection:Disconnect()
            parryCharacterAddedConnection = nil

        end

        if parryCharacterRemovingConnection then

            parryCharacterRemovingConnection:Disconnect()
            parryCharacterRemovingConnection = nil

        end

        if parryChildAddedConnection then

            parryChildAddedConnection:Disconnect()
            parryChildAddedConnection = nil

        end

        if parryChildRemovedConnection then

            parryChildRemovedConnection:Disconnect()
            parryChildRemovedConnection = nil

        end

        if parryInputConnection then

            parryInputConnection:Disconnect()
            parryInputConnection = nil

        end

        parryController = nil
        currentTool = nil

    end

end
