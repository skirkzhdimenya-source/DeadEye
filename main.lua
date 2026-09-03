local G = getgenv().DeadEye

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local root = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")

local mainPage = G.UI.MainPage

print("[Main] запущен")
print("[Main] MainPage найден:", mainPage ~= nil)

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

    if destroyCircle then
        destroyCircle()
    end
end

-- =========================================================
-- CIRCLE GUI
-- =========================================================

local createToggle = G.Functions.createToggle
local setToggleVisual = G.Functions.setToggleVisual

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

circleToggle.MouseButton1Click:Connect(function()

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

end)

do

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local parryMonitorConnection = nil

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

G.Cleanup.Parry = function()
    parryEnabled = false

    if parryMonitorConnection then
        parryMonitorConnection:Disconnect()
        parryMonitorConnection = nil
    end

    parryController = nil
    currentTool = nil
end

end
