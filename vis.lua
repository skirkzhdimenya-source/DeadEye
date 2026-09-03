local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local root = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
local Workspace = game:GetService("Workspace")
local parryEnabled = false
local parryHotkey = Enum.KeyCode.Z
local MIN_THICKNESS = 0.05
local MAX_THICKNESS = 0.4
local cam = workspace.Camera
local GRAVITY_DEFAULT = 126 
local GRAVITY_ALT = 96
local SPEED = 165
local NUM_POINTS = 40
local TIME_STEP = 0.08
local LINE_THICKNESS = 0.4

-- затухание линии рядом с камерой
local FADE_START_DIST = 30
local FADE_END_DIST = 7

-- стены, которые считаются "стенами" для детекции соприкосновения / остановки
local WALL_NAMES = {}

local function updateWallNames()
    for key in pairs(WALL_NAMES) do
        WALL_NAMES[key] = nil
    end
    for _, player in ipairs(Players:GetPlayers()) do
        WALL_NAMES[player.Name] = true
    end
end

Players.PlayerAdded:Connect(updateWallNames)
Players.PlayerRemoving:Connect(updateWallNames)
updateWallNames() -- для уже существующих

local IMPACT_SPHERE_RADIUS = 0.6
local IMPACT_SPHERE_TRANSPARENCY = 0.5

-- цвет линии Y при соприкосновении со стеной
local Y_HIT_COLOR = Color3.fromRGB(255, 40, 40)
local Y_NORMAL_COLOR = Color3.new(1, 0.6, 0)

local currentMode = nil -- "Trajectory" или "TrajectoryPlus", nil когда выключено
local renderConnection = nil
local inputConnection = nil

local updateTrajectory
local hideTrajectory
local updateTrajectoryPlus
local hideTrajectoryPlus
local createCircle
local destroyCircle

local circleEnabled = false

local autoSkillCheckEnabled = false
local kingScourgeEnabled = false

local kingScourgeToggle = nil
local kingScourgeKnob = nil

local setKingScourgeEnabled
local setAutoSkillCheckEnabled
local setToggleVisual

local autoSkillCheckConnection = nil

local cleanupESP

local fovValue = 70
local fovConnection = nil

local parryToggle
local parryKnob
local parryKeyButton

local trajectoryKeyButton
local trajectoryPlusKeyButton
local trajectoryToggle
local trajectoryPlusToggle
local trajectoryKnob
local trajectoryPlusKnob
local trajectoryEnabled = false
local trajectoryPlusEnabled = false
local trajectoryHotkey = Enum.KeyCode.G
local trajectoryPlusHotkey = Enum.KeyCode.Y
local waitingForHotkey = nil

-- ===== ТОЧКИ ТРАЕКТОРИИ (общие для обоих режимов, пересчитываются каждый кадр) =====
local points = {}
for i = 1, NUM_POINTS do
    points[i] = Vector3.new(0, 0, 0)
end

-- ===== ОБЩИЙ КОНТЕЙНЕР =====
local trajectoryFolder = Instance.new("Folder")
trajectoryFolder.Name = "TrajectoryVisuals"
trajectoryFolder.Parent = Workspace

-- находит стену (инстанс) по попаданию, поднимаясь по иерархии до Workspace
local function findWallInstance(hitInstance)
    local inst = hitInstance
    while inst and inst ~= Workspace do
        if WALL_NAMES[inst.Name] then
            return inst
        end
        inst = inst.Parent
    end
    return nil
end

-- прозрачность в зависимости от расстояния до камеры
local function fadeTransparency(camPos, segPos)
    local dist = (segPos - camPos).Magnitude
    if dist >= FADE_START_DIST then
        return 0
    elseif dist <= FADE_END_DIST then
        return 1
    else
        local t = (dist - FADE_END_DIST) / (FADE_START_DIST - FADE_END_DIST)
        return 1 - t
    end
end

--========================================================================
-- TRAJECTORY — точная копия исходной, изначально рабочей версии.
-- Обычные Part, останавливается на первой встреченной стене из WALL_NAMES.
--========================================================================

do

    local segmentsTrajectory = {}

    for i = 1, NUM_POINTS - 1 do

        local segment = Instance.new("Part")

        segment.Anchored = true
        segment.CanCollide = false
        segment.CanQuery = false
        segment.CanTouch = false
        segment.Massless = true

        segment.Material = Enum.Material.Neon
        segment.Color = Color3.new(1, 0.6, 0)
        segment.Transparency = 1

        segment.Size = Vector3.new(
            LINE_THICKNESS,
            LINE_THICKNESS,
            0.1
        )

        segment.Parent = trajectoryFolder

        segmentsTrajectory[i] = segment

    end

    local impactSphereTrajectory =
        Instance.new("Part")

    impactSphereTrajectory.Name =
        "TrajectoryWallImpact"

    impactSphereTrajectory.Shape =
        Enum.PartType.Ball

    impactSphereTrajectory.Anchored = true
    impactSphereTrajectory.CanCollide = false
    impactSphereTrajectory.CanQuery = false
    impactSphereTrajectory.CanTouch = false
    impactSphereTrajectory.Massless = true

    impactSphereTrajectory.Material =
        Enum.Material.Neon

    impactSphereTrajectory.Color =
        Color3.fromRGB(
            0,
            255,
            0
        )

    impactSphereTrajectory.Transparency = 1

    impactSphereTrajectory.Size =
        Vector3.new(
            IMPACT_SPHERE_RADIUS,
            IMPACT_SPHERE_RADIUS,
            IMPACT_SPHERE_RADIUS
        ) * 2

    impactSphereTrajectory.Parent =
        trajectoryFolder

    local rayParamsTrajectory =
        RaycastParams.new()

    rayParamsTrajectory.FilterType =
        Enum.RaycastFilterType.Exclude

    rayParamsTrajectory.FilterDescendantsInstances = {
        trajectoryFolder
    }

    rayParamsTrajectory.IgnoreWater = true

    local function placeSegment(
        segment,
        p0,
        p1
    )

        local distance =
            (p1 - p0).Magnitude

        local mid =
            (p0 + p1) / 2

        segment.Size =
            Vector3.new(
                LINE_THICKNESS,
                LINE_THICKNESS,
                math.max(
                    distance,
                    0.01
                )
            )

        segment.CFrame =
            CFrame.new(
                mid,
                p1
            )

    end

    function updateTrajectory()

        local startPos =
            cam.CFrame.Position

        local dir =
            cam.CFrame.LookVector

        local gravity =
            Vector3.new(
                0,
                -GRAVITY_DEFAULT,
                0
            )

        for i = 1, NUM_POINTS do

            local t =
                i * TIME_STEP

            points[i] =
                startPos
                + dir * SPEED * t
                + 0.5 * gravity * t * t

        end

        local hitWallPos = nil

        for i = 1, NUM_POINTS - 1 do

            local p0 =
                (i == 1)
                and startPos
                or points[i - 1]

            local p1 =
                points[i]

            if hitWallPos then

                segmentsTrajectory[i].Transparency = 1

            else

                local rayResult =
                    Workspace:Raycast(
                        p0,
                        p1 - p0,
                        rayParamsTrajectory
                    )

                if rayResult
                    and findWallInstance(
                        rayResult.Instance
                    )
                then

                    hitWallPos =
                        rayResult.Position

                    placeSegment(
                        segmentsTrajectory[i],
                        p0,
                        hitWallPos
                    )

                    segmentsTrajectory[i].Transparency =
                        fadeTransparency(
                            startPos,
                            (p0 + hitWallPos) / 2
                        )

                else

                    placeSegment(
                        segmentsTrajectory[i],
                        p0,
                        p1
                    )

                    segmentsTrajectory[i].Transparency =
                        fadeTransparency(
                            startPos,
                            (p0 + p1) / 2
                        )

                end

            end

        end

        if hitWallPos then

            impactSphereTrajectory.Position =
                hitWallPos

            impactSphereTrajectory.Transparency =
                IMPACT_SPHERE_TRANSPARENCY

        else

            impactSphereTrajectory.Transparency = 1

        end

    end

    function hideTrajectory()

        for _, seg
            in ipairs(segmentsTrajectory)
        do

            seg.Transparency = 1

        end

        impactSphereTrajectory.Transparency = 1

    end

end

-- =========================================================
-- TRAJECTORY PLUS
-- =========================================================

do

    local anchorPart = Instance.new("Part")

    anchorPart.Name =
        "AdornmentAnchor"

    anchorPart.Anchored = true

    anchorPart.CanCollide = false
    anchorPart.CanQuery = false
    anchorPart.CanTouch = false

    anchorPart.Transparency = 1

    anchorPart.Size =
        Vector3.new(
            0.1,
            0.1,
            0.1
        )

    anchorPart.CFrame =
        CFrame.new(0, 0, 0)

    anchorPart.Parent =
        trajectoryFolder

    -- =====================================================
    -- SEGMENTS
    -- =====================================================

    local segmentsTrajectoryPlus = {}

    for i = 1, NUM_POINTS - 1 do

        local segment =
            Instance.new(
                "BoxHandleAdornment"
            )

        segment.Name =
            "SegmentTrajectoryPlus" .. i

        segment.Adornee =
            anchorPart

        segment.Size =
            Vector3.new(
                LINE_THICKNESS,
                LINE_THICKNESS,
                0.1
            )

        segment.Color3 =
            Y_NORMAL_COLOR

        segment.Transparency = 1

        segment.AlwaysOnTop = true

        segment.ZIndex = 10

        segment.Parent =
            anchorPart

        segmentsTrajectoryPlus[i] =
            segment

    end

    -- =====================================================
    -- IMPACT SPHERE
    -- =====================================================

    local impactSphereTrajectoryPlus =
        Instance.new(
            "SphereHandleAdornment"
        )

    impactSphereTrajectoryPlus.Name =
        "TrajectoryWallImpactPlus"

    impactSphereTrajectoryPlus.Adornee =
        anchorPart

    impactSphereTrajectoryPlus.Radius =
        IMPACT_SPHERE_RADIUS

    impactSphereTrajectoryPlus.Color3 =
        Y_HIT_COLOR

    impactSphereTrajectoryPlus.Transparency = 1

    impactSphereTrajectoryPlus.AlwaysOnTop =
        true

    impactSphereTrajectoryPlus.ZIndex = 10

    impactSphereTrajectoryPlus.CFrame =
        CFrame.new(0, 0, 0)

    impactSphereTrajectoryPlus.Parent =
        anchorPart

    -- =====================================================
    -- RAYCAST
    -- =====================================================

    local rayParamsTrajectoryPlus =
        RaycastParams.new()

    rayParamsTrajectoryPlus.FilterType =
        Enum.RaycastFilterType.Exclude

    rayParamsTrajectoryPlus.FilterDescendantsInstances = {
        anchorPart
    }

    rayParamsTrajectoryPlus.IgnoreWater =
        true

    -- =====================================================
    -- MIN SEGMENT LENGTH
    -- =====================================================

    local MIN_SEGMENT_LENGTH = 0.2

    -- =====================================================
    -- PLACE ADORNMENT
    -- =====================================================

    local function placeAdornment(
        adorn,
        p0,
        p1,
        thickness
    )

        local distance =
            (p1 - p0).Magnitude

        if distance < MIN_SEGMENT_LENGTH then

            adorn.Transparency = 1

            return

        end

        local mid =
            (p0 + p1) / 2

        adorn.Size =
            Vector3.new(
                thickness,
                thickness,
                distance
            )

        adorn.CFrame =
            CFrame.new(
                mid,
                p1
            )

        adorn.Transparency = 0

    end

    -- =====================================================
    -- UPDATE TRAJECTORY PLUS
    -- =====================================================

    function updateTrajectoryPlus()

        local startPos =
            cam.CFrame.Position

        local dir =
            cam.CFrame.LookVector

        local gravity =
            Vector3.new(
                0,
                -GRAVITY_ALT,
                0
            )

        -- Вычисляем точки

        for i = 1, NUM_POINTS do

            local t =
                i * TIME_STEP

            points[i] =
                startPos
                + dir * SPEED * t
                + 0.5 * gravity * t * t

        end

        local hitFound = false
        local hitPos = nil

        -- Проходим по сегментам

        for i = 1, NUM_POINTS - 1 do

            local p0 =
                (i == 1)
                and startPos
                or points[i - 1]

            local p1 =
                points[i]

            local midPoint =
                (p0 + p1) / 2

            -- =================================================
            -- THICKNESS
            -- =================================================

            local distToCam =
                (midPoint - startPos).Magnitude

            local tFade =
                1 -
                (
                    distToCam -
                    FADE_END_DIST
                )
                /
                (
                    FADE_START_DIST -
                    FADE_END_DIST
                )

            tFade =
                math.clamp(
                    tFade,
                    0,
                    1
                )

            local thickness =
                MIN_THICKNESS
                +
                (
                    MAX_THICKNESS -
                    MIN_THICKNESS
                )
                *
                (
                    1 - tFade
                )

            -- =================================================
            -- ПОСЛЕ ПОПАДАНИЯ
            -- =================================================

            if hitFound then

                segmentsTrajectoryPlus[i].Transparency =
                    1

                segmentsTrajectoryPlus[i].Color3 =
                    Y_NORMAL_COLOR

                continue

            end

            -- =================================================
            -- RAYCAST
            -- =================================================

            local rayResult =
                Workspace:Raycast(
                    p0,
                    p1 - p0,
                    rayParamsTrajectoryPlus
                )

            if rayResult
                and findWallInstance(
                    rayResult.Instance
                )
            then

                -- Нашли стену

                hitFound = true

                hitPos =
                    rayResult.Position

                -- Рисуем только до стены

                placeAdornment(
                    segmentsTrajectoryPlus[i],
                    p0,
                    hitPos,
                    thickness
                )

                local midHit =
                    (p0 + hitPos) / 2

                segmentsTrajectoryPlus[i].Transparency =
                    fadeTransparency(
                        startPos,
                        midHit
                    )

                segmentsTrajectoryPlus[i].Color3 =
                    Y_HIT_COLOR

            else

                -- Обычный сегмент

                placeAdornment(
                    segmentsTrajectoryPlus[i],
                    p0,
                    p1,
                    thickness
                )

                segmentsTrajectoryPlus[i].Transparency =
                    fadeTransparency(
                        startPos,
                        midPoint
                    )

                segmentsTrajectoryPlus[i].Color3 =
                    Y_NORMAL_COLOR

            end

        end

        -- =====================================================
        -- IMPACT
        -- =====================================================

        if hitFound then

            impactSphereTrajectoryPlus.CFrame =
                CFrame.new(hitPos)

            impactSphereTrajectoryPlus.Transparency =
                IMPACT_SPHERE_TRANSPARENCY

        else

            impactSphereTrajectoryPlus.Transparency =
                1

        end

    end

    -- =====================================================
    -- HIDE TRAJECTORY PLUS
    -- =====================================================

    function hideTrajectoryPlus()

        for _, seg
            in ipairs(
                segmentsTrajectoryPlus
            )
        do

            seg.Transparency = 1

        end

        impactSphereTrajectoryPlus.Transparency =
            1

    end

end

local Vis = {}

function Vis.mount(ui)
    local visPage = ui.visPage
    local createToggle = ui.createToggle
    setToggleVisual = ui.setToggleVisual

-- =========================================================
-- VIS: TRAJECTORY
-- =========================================================

do
    local function createFeatureRow(parent, labelText, y, defaultKey)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 110, 0, 25)
        label.Position = UDim2.new(0, 10, 0, y)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(242, 242, 242)
        label.TextSize = 12
        label.Font = Enum.Font.SourceSans
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = parent

        local keyButton = Instance.new("TextButton")
        keyButton.Size = UDim2.new(0, 32, 0, 18)
        keyButton.Position = UDim2.new(1, -88, 0, y + 6)
        keyButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        keyButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        keyButton.Text = defaultKey.Name
        keyButton.TextSize = 10
        keyButton.Font = Enum.Font.SourceSans
        keyButton.BorderSizePixel = 0
        keyButton.AutoButtonColor = false
        keyButton.Parent = parent

        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 3)
        keyCorner.Parent = keyButton

        local toggleButton, toggleKnob = createToggle(parent, y + 6)

        return keyButton, toggleButton, toggleKnob
    end

    trajectoryKeyButton, trajectoryToggle, trajectoryKnob =
        createFeatureRow(visPage, "Trajectory", 5, Enum.KeyCode.G)

    trajectoryPlusKeyButton, trajectoryPlusToggle, trajectoryPlusKnob =
        createFeatureRow(visPage, "TrajectoryPlus", 36, Enum.KeyCode.Y)
end
-- =========================================================
-- FOV
-- =========================================================
do
    fovValue = 70 -- текущее значение FOV

    fovConnection = RunService.RenderStepped:Connect(function()
        cam.FieldOfView = fovValue
    end)

    local fovLabel = Instance.new("TextLabel")
    fovLabel.Name = "FovLabel"
    fovLabel.Size = UDim2.new(0, 110, 0, 25)
    fovLabel.Position = UDim2.new(0, 10, 0, 67)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "FOV"
    fovLabel.TextColor3 = Color3.fromRGB(242, 242, 242)
    fovLabel.TextSize = 12
    fovLabel.Font = Enum.Font.SourceSans
    fovLabel.TextXAlignment = Enum.TextXAlignment.Left
    fovLabel.TextYAlignment = Enum.TextYAlignment.Center
    fovLabel.Parent = visPage

    -- Значение FOV
    local fovValueLabel = Instance.new("TextLabel")
    fovValueLabel.Name = "FovValue"
    fovValueLabel.Size = UDim2.new(0, 35, 0, 18)
    fovValueLabel.Position = UDim2.new(1, -43, 0, 70)
    fovValueLabel.BackgroundTransparency = 1
    fovValueLabel.Text = tostring(fovValue)
    fovValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    fovValueLabel.TextSize = 10
    fovValueLabel.Font = Enum.Font.SourceSans
    fovValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    fovValueLabel.Parent = visPage

    -- Ползунок
    local fovSlider = Instance.new("TextButton")
    fovSlider.Name = "FovSlider"
    fovSlider.Size = UDim2.new(0, 120, 0, 6)
    fovSlider.Position = UDim2.new(0, 10, 0, 94)
    fovSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    fovSlider.BorderSizePixel = 0
    fovSlider.Text = ""
    fovSlider.AutoButtonColor = false
    fovSlider.Parent = visPage

    local fovSliderCorner = Instance.new("UICorner")
    fovSliderCorner.CornerRadius = UDim.new(1, 0)
    fovSliderCorner.Parent = fovSlider

    -- Заполненная часть
    local fovFill = Instance.new("Frame")
    fovFill.Name = "Fill"
    fovFill.Size = UDim2.new(
        (fovValue - 10) / (120 - 10),
        0,
        1,
        0
    )
    fovFill.BackgroundColor3 = Color3.fromRGB(100, 160, 220)
    fovFill.BorderSizePixel = 0
    fovFill.Parent = fovSlider

    local fovFillCorner = Instance.new("UICorner")
    fovFillCorner.CornerRadius = UDim.new(1, 0)
    fovFillCorner.Parent = fovFill

    -- Кружок-ползунок
    local fovKnob = Instance.new("Frame")
    fovKnob.Name = "Knob"
    fovKnob.Size = UDim2.new(0, 12, 0, 12)
    fovKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    fovKnob.Position = UDim2.new(
        (fovValue - 10) / (120 - 10),
        0,
        0.5,
        0
    )
    fovKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    fovKnob.BorderSizePixel = 0
    fovKnob.Parent = fovSlider

    local fovKnobCorner = Instance.new("UICorner")
    fovKnobCorner.CornerRadius = UDim.new(1, 0)
    fovKnobCorner.Parent = fovKnob

    -- Изменение значения
    local fovDragging = false

    local function updateFov(inputX)
        local sliderX = fovSlider.AbsolutePosition.X
        local sliderWidth = fovSlider.AbsoluteSize.X

        local percent = (inputX - sliderX) / sliderWidth
        percent = math.clamp(percent, 0, 1)

        fovValue = math.floor(10 + percent * (120 - 10) + 0.5)

        fovValueLabel.Text = tostring(fovValue)

        fovFill.Size = UDim2.new(percent, 0, 1, 0)
        fovKnob.Position = UDim2.new(percent, 0, 0.5, 0)
    end

    fovSlider.MouseButton1Down:Connect(function()
        fovDragging = true
        updateFov(UserInputService:GetMouseLocation().X)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if fovDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFov(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            fovDragging = false
        end
    end)
end

-- =========================================================
-- ESP PLAYERS
-- =========================================================
do
    local espPickerFrames = {}
    local espPickerConnections = {}

    -- =========================================================
    -- ESP PLAYERS / KILLERS
    -- =========================================================

    local espPlayersEnabled = false
    local espKillerEnabled = false

    local espFillEnabled = true
    local espKillerFillEnabled = true

    local espFillColor = Color3.fromRGB(255, 0, 0)
    local espOutlineColor = Color3.fromRGB(255, 255, 255)

    local espKillerFillColor = Color3.fromRGB(255, 0, 0)
    local espKillerOutlineColor = Color3.fromRGB(255, 255, 255)

    local espHighlights = {}
    local espKillerHighlights = {}

    local espCharacterConnections = {}

    local function isKiller(plr)

        if plr == player then
            return false
        end

        local character = plr.Character

        if not character then
            return false
        end

        return character:FindFirstChild("Weapon", true) ~= nil

    end

    -- =========================================================
    -- REMOVE PLAYER ESP
    -- =========================================================

    local function removeESP(plr)

        local highlight = espHighlights[plr]

        if highlight then
            highlight:Destroy()
            espHighlights[plr] = nil
        end

    end

    -- =========================================================
    -- REMOVE KILLER ESP
    -- =========================================================

    local function removeKillerESP(plr)

        local highlight = espKillerHighlights[plr]

        if highlight then
            highlight:Destroy()
            espKillerHighlights[plr] = nil
        end

    end

    -- =========================================================
    -- CREATE PLAYER ESP
    -- =========================================================

    local function createESP(plr)

        if plr == player then
            return
        end

        if not espPlayersEnabled then
            return
        end

        -- Killer'ы НЕ получают Player ESP
        if isKiller(plr) then
            removeESP(plr)
            return
        end

        local character = plr.Character

        if not character then
            return
        end

        removeESP(plr)

        local highlight = Instance.new("Highlight")

        highlight.Name = "ESPPlayers"
        highlight.Adornee = character

        highlight.FillColor = espFillColor
        highlight.FillTransparency =
            espFillEnabled and 0.5 or 1

        highlight.OutlineColor = espOutlineColor
        highlight.OutlineTransparency = 0

        highlight.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop

        highlight.Parent = character

        espHighlights[plr] = highlight

    end

    -- =========================================================
    -- CREATE KILLER ESP
    -- =========================================================

    local function createKillerESP(plr)

        if plr == player then
            return
        end

        if not espKillerEnabled then
            return
        end

        -- Только игроки с Weapon
        if not isKiller(plr) then
            removeKillerESP(plr)
            return
        end

        local character = plr.Character

        if not character then
            return
        end

        removeKillerESP(plr)

        local highlight = Instance.new("Highlight")

        highlight.Name = "ESPKiller"
        highlight.Adornee = character

        highlight.FillColor = espKillerFillColor

        highlight.FillTransparency =
            espKillerFillEnabled and 0.5 or 1

        highlight.OutlineColor =
            espKillerOutlineColor

        highlight.OutlineTransparency = 0

        highlight.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop

        highlight.Parent = character

        espKillerHighlights[plr] = highlight

    end

    -- =========================================================
    -- REFRESH PLAYER TYPE
    -- =========================================================

    local function refreshESP(plr)

        if plr == player then
            return
        end

        if isKiller(plr) then

            -- Killer
            removeESP(plr)

            if espKillerEnabled then
                createKillerESP(plr)
            end

        else

            -- Player
            removeKillerESP(plr)

            if espPlayersEnabled then
                createESP(plr)
            end

        end

    end

    -- =========================================================
    -- ENABLE PLAYER ESP
    -- =========================================================

    local function enableESPPlayers()

        espPlayersEnabled = true

        for _, plr in ipairs(Players:GetPlayers()) do

            if plr ~= player then
                refreshESP(plr)
            end

        end

    end

    -- =========================================================
    -- DISABLE PLAYER ESP
    -- =========================================================

    local function disableESPPlayers()

        espPlayersEnabled = false

        for plr, highlight in pairs(espHighlights) do

            if highlight then
                highlight:Destroy()
            end

            espHighlights[plr] = nil

        end

    end

    -- =========================================================
    -- ENABLE KILLER ESP
    -- =========================================================

    local function enableESPKillers()

        espKillerEnabled = true

        for _, plr in ipairs(Players:GetPlayers()) do

            if plr ~= player then
                refreshESP(plr)
            end

        end

    end

    -- =========================================================
    -- DISABLE KILLER ESP
    -- =========================================================

    local function disableESPKillers()

        espKillerEnabled = false

        for plr, highlight in pairs(espKillerHighlights) do

            if highlight then
                highlight:Destroy()
            end

            espKillerHighlights[plr] = nil

        end

    end

    -- =========================================================
    -- UPDATE NORMAL ESP
    -- =========================================================

    local function updateESP()

        for plr, highlight in pairs(espHighlights) do

            if highlight and plr ~= player then

                highlight.FillColor =
                    espFillColor

                highlight.FillTransparency =
                    espFillEnabled and 0.5 or 1

                highlight.OutlineColor =
                    espOutlineColor

                highlight.OutlineTransparency = 0

            end

        end

    end

    -- =========================================================
    -- UPDATE KILLER ESP
    -- =========================================================

    local function updateKillerESP()

        for plr, highlight in pairs(espKillerHighlights) do

            if highlight and plr ~= player then

                highlight.FillColor =
                    espKillerFillColor

                highlight.FillTransparency =
                    espKillerFillEnabled and 0.5 or 1

                highlight.OutlineColor =
                    espKillerOutlineColor

                highlight.OutlineTransparency = 0

            end

        end

    end

    -- =========================================================
    -- CHARACTER MONITORING
    -- =========================================================

    local function setupCharacterMonitoring(plr)

        if plr == player then
            return
        end

        if espCharacterConnections[plr] then

            for _, connection in pairs(
                espCharacterConnections[plr]
            ) do

                connection:Disconnect()

            end

        end

        espCharacterConnections[plr] = {}

        local function monitorCharacter(character)

            table.insert(
                espCharacterConnections[plr],

                character.ChildAdded:Connect(
                    function(child)

                        if child.Name == "Weapon" then
                            refreshESP(plr)
                        end

                    end
                )
            )

            table.insert(
                espCharacterConnections[plr],

                character.ChildRemoved:Connect(
                    function(child)

                        if child.Name == "Weapon" then
                            refreshESP(plr)
                        end

                    end
                )
            )

            task.wait(0.1)

            refreshESP(plr)

        end

        if plr.Character then
            monitorCharacter(plr.Character)
        end

        table.insert(
            espCharacterConnections[plr],

            plr.CharacterAdded:Connect(
                function(character)

                    task.wait(0.1)

                    monitorCharacter(character)

                end
            )
        )

    end

    local function cleanupCharacterMonitoring(plr)

        if espCharacterConnections[plr] then

            for _, connection in pairs(
                espCharacterConnections[plr]
            ) do

                connection:Disconnect()

            end

            espCharacterConnections[plr] = nil

        end

    end

    -- =========================================================
    -- PLAYER SETUP
    -- =========================================================

    local function setupESPPlayer(plr)

        if plr == player then
            return
        end

        setupCharacterMonitoring(plr)

        if plr.Character then
            refreshESP(plr)
        end

    end

    local function removeESPPlayer(plr)

        removeESP(plr)
        removeKillerESP(plr)
        cleanupCharacterMonitoring(plr)

    end

    for _, plr in ipairs(Players:GetPlayers()) do
        setupESPPlayer(plr)
    end

    local espPlayerAddedConnection =
        Players.PlayerAdded:Connect(
            function(plr)

                if plr ~= player then
                    setupESPPlayer(plr)
                end

            end
        )

    local espPlayerRemovingConnection =
        Players.PlayerRemoving:Connect(
            function(plr)

                removeESPPlayer(plr)

            end
        )

    -- =========================================================
    -- HSV COLOR PICKER
    -- =========================================================

    local function createColorPicker(
        parent,
        button,
        initialColor,
        callback
    )

        local picker = Instance.new("Frame")

        picker.Name = "ColorPicker"
        picker.Size = UDim2.new(0, 315, 0, 185)

        picker.Position = UDim2.new(
            1,
            -325,
            0,
            button.Position.Y.Offset - 5
        )

        picker.BackgroundColor3 =
            Color3.fromRGB(30, 30, 30)

        picker.BorderSizePixel = 0
        picker.Visible = false
        picker.ZIndex = 100
        picker.Parent = parent

        local pickerCorner =
            Instance.new("UICorner")

        pickerCorner.CornerRadius =
            UDim.new(0, 6)

        pickerCorner.Parent = picker

        -- =====================================================
        -- HSV
        -- =====================================================

        local h, s, v =
            initialColor:ToHSV()

        local hueValue = h
        local saturationValue = s
        local valueValue = v

        -- =====================================================
        -- HUE WHEEL
        -- =====================================================

        local hueWheel =
            Instance.new("Frame")

        hueWheel.Name = "HueWheel"

        hueWheel.Size =
            UDim2.new(0, 150, 0, 150)

        hueWheel.Position =
            UDim2.new(0, 10, 0, 12)

        hueWheel.BackgroundTransparency = 1
        hueWheel.BorderSizePixel = 0
        hueWheel.ZIndex = 101
        hueWheel.Parent = picker

        local hueCenter = 75
        local hueRadius = 64

        local hueSegmentCount = 360

        for i = 0, hueSegmentCount - 1 do

            local segment =
                Instance.new("Frame")

            local angle =
                (i / hueSegmentCount)
                * math.pi
                * 2

            segment.Size =
                UDim2.new(0, 4, 0, 19)

            segment.AnchorPoint =
                Vector2.new(0.5, 0.5)

            segment.Position =
                UDim2.new(
                    0,
                    hueCenter +
                        math.cos(angle) *
                        hueRadius,

                    0,
                    hueCenter +
                        math.sin(angle) *
                        hueRadius
                )

            segment.Rotation =
                math.deg(angle) + 90

            segment.BackgroundColor3 =
                Color3.fromHSV(
                    i / hueSegmentCount,
                    1,
                    1
                )

            segment.BorderSizePixel = 0
            segment.ZIndex = 102
            segment.Parent = hueWheel

        end

        -- =====================================================
        -- HUE SELECTOR
        -- =====================================================

        local hueSelector =
            Instance.new("Frame")

        hueSelector.Name = "HueSelector"

        hueSelector.Size =
            UDim2.new(0, 12, 0, 12)

        hueSelector.AnchorPoint =
            Vector2.new(0.5, 0.5)

        hueSelector.BackgroundColor3 =
            Color3.fromRGB(255, 255, 255)

        hueSelector.BorderSizePixel = 2

        hueSelector.BorderColor3 =
            Color3.fromRGB(0, 0, 0)

        hueSelector.ZIndex = 110
        hueSelector.Parent = hueWheel

        local hueSelectorCorner =
            Instance.new("UICorner")

        hueSelectorCorner.CornerRadius =
            UDim.new(1, 0)

        hueSelectorCorner.Parent =
            hueSelector

        -- =====================================================
        -- SATURATION / VALUE SQUARE
        -- =====================================================

        local svSquare =
            Instance.new("Frame")

        svSquare.Name = "SVSquare"

        svSquare.Size =
            UDim2.new(0, 145, 0, 145)

        svSquare.Position =
            UDim2.new(0, 170, 0, 12)

        svSquare.BackgroundColor3 =
            Color3.fromHSV(
                hueValue,
                1,
                1
            )

        svSquare.BorderSizePixel = 0
        svSquare.ZIndex = 101
        svSquare.Parent = picker

        local svCorner =
            Instance.new("UICorner")

        svCorner.CornerRadius =
            UDim.new(0, 3)

        svCorner.Parent = svSquare

        -- Белый -> прозрачный слева направо
        local whiteOverlay =
            Instance.new("Frame")

        whiteOverlay.Name =
            "WhiteOverlay"

        whiteOverlay.Size =
            UDim2.new(1, 0, 1, 0)

        whiteOverlay.BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            )

        whiteOverlay.BorderSizePixel = 0
        whiteOverlay.ZIndex = 102
        whiteOverlay.Parent = svSquare

        local whiteGradient =
            Instance.new("UIGradient")

        whiteGradient.Transparency =
            NumberSequence.new({

                NumberSequenceKeypoint.new(
                    0,
                    0
                ),

                NumberSequenceKeypoint.new(
                    1,
                    1
                )

            })

        whiteGradient.Rotation = 0
        whiteGradient.Parent = whiteOverlay

        -- Чёрный -> прозрачный сверху вниз
        local blackOverlay =
            Instance.new("Frame")

        blackOverlay.Name =
            "BlackOverlay"

        blackOverlay.Size =
            UDim2.new(1, 0, 1, 0)

        blackOverlay.BackgroundColor3 =
            Color3.fromRGB(
                0,
                0,
                0
            )

        blackOverlay.BorderSizePixel = 0
        blackOverlay.ZIndex = 103
        blackOverlay.Parent = svSquare

        local blackGradient =
            Instance.new("UIGradient")

        blackGradient.Transparency =
            NumberSequence.new({

                NumberSequenceKeypoint.new(
                    0,
                    1
                ),

                NumberSequenceKeypoint.new(
                    1,
                    0
                )

            })

        blackGradient.Rotation = 90
        blackGradient.Parent = blackOverlay

        -- =====================================================
        -- SV SELECTOR
        -- =====================================================

        local svSelector =
            Instance.new("Frame")

        svSelector.Name =
            "SVSelector"

        svSelector.Size =
            UDim2.new(0, 10, 0, 10)

        svSelector.AnchorPoint =
            Vector2.new(0.5, 0.5)

        svSelector.BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            )

        svSelector.BorderSizePixel = 2

        svSelector.BorderColor3 =
            Color3.fromRGB(
                0,
                0,
                0
            )

        svSelector.ZIndex = 110
        svSelector.Parent = svSquare

        local svSelectorCorner =
            Instance.new("UICorner")

        svSelectorCorner.CornerRadius =
            UDim.new(1, 0)

        svSelectorCorner.Parent =
            svSelector

        -- =====================================================
        -- PREVIEW
        -- =====================================================

        local preview =
            Instance.new("Frame")

        preview.Name = "Preview"

        preview.Size =
            UDim2.new(0, 35, 0, 20)

        preview.Position =
            UDim2.new(0, 10, 0, 157)

        preview.BackgroundColor3 =
            initialColor

        preview.BorderSizePixel = 0
        preview.ZIndex = 110
        preview.Parent = picker

        local previewCorner =
            Instance.new("UICorner")

        previewCorner.CornerRadius =
            UDim.new(0, 3)

        previewCorner.Parent = preview

        -- =====================================================
        -- OK
        -- =====================================================

        local closePicker =
            Instance.new("TextButton")

        closePicker.Name =
            "ClosePicker"

        closePicker.Size =
            UDim2.new(0, 60, 0, 20)

        closePicker.Position =
            UDim2.new(1, -70, 0, 157)

        closePicker.BackgroundColor3 =
            Color3.fromRGB(
                55,
                55,
                55
            )

        closePicker.BorderSizePixel = 0
        closePicker.Text = "OK"

        closePicker.TextColor3 =
            Color3.fromRGB(
                220,
                220,
                220
            )

        closePicker.TextSize = 10
        closePicker.Font =
            Enum.Font.SourceSans

        closePicker.ZIndex = 110
        closePicker.Parent = picker

        local closeCorner =
            Instance.new("UICorner")

        closeCorner.CornerRadius =
            UDim.new(0, 3)

        closeCorner.Parent =
            closePicker

        -- =====================================================
        -- UPDATE
        -- =====================================================

        local function updateHueSelector()

            local angle =
                hueValue *
                math.pi *
                2

            hueSelector.Position =
                UDim2.new(
                    0,

                    hueCenter +
                        math.cos(angle) *
                        hueRadius,

                    0,

                    hueCenter +
                        math.sin(angle) *
                        hueRadius
                )

        end

        local function updateSVSelector()

            svSelector.Position =
                UDim2.new(
                    saturationValue,
                    0,

                    1 - valueValue,
                    0
                )

        end

        local function updateColor()

            local color =
                Color3.fromHSV(
                    hueValue,
                    saturationValue,
                    valueValue
                )

            svSquare.BackgroundColor3 =
                Color3.fromHSV(
                    hueValue,
                    1,
                    1
                )

            preview.BackgroundColor3 =
                color

            callback(color)

            updateHueSelector()
            updateSVSelector()

        end

        updateColor()

        -- =====================================================
        -- SV INPUT
        -- =====================================================

        local svDragging = false

        local function updateSV(x, y)

            local px =
                (
                    x -
                    svSquare.AbsolutePosition.X
                )
                /
                svSquare.AbsoluteSize.X

            local py =
                (
                    y -
                    svSquare.AbsolutePosition.Y
                )
                /
                svSquare.AbsoluteSize.Y

            saturationValue =
                math.clamp(
                    px,
                    0,
                    1
                )

            valueValue =
                1 -
                math.clamp(
                    py,
                    0,
                    1
                )

            updateColor()

        end

        svSquare.InputBegan:Connect(
            function(input)

                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                then

                    svDragging = true

                    updateSV(
                        input.Position.X,
                        input.Position.Y
                    )

                end

            end
        )

        local svChanged =
            UserInputService.InputChanged:Connect(
                function(input)

                    if svDragging and
                        input.UserInputType ==
                        Enum.UserInputType.MouseMovement
                    then

                        updateSV(
                            input.Position.X,
                            input.Position.Y
                        )

                    end

                end
            )

        local svEnded =
            UserInputService.InputEnded:Connect(
                function(input)

                    if input.UserInputType ==
                        Enum.UserInputType.MouseButton1
                    then

                        svDragging = false

                    end

                end
            )

        -- =====================================================
        -- HUE INPUT
        -- =====================================================

        local hueDragging = false

        local function updateHue(x, y)

            local centerPosition =
                hueWheel.AbsolutePosition
                +
                hueWheel.AbsoluteSize / 2

            local dx =
                x -
                centerPosition.X

            local dy =
                y -
                centerPosition.Y

            local distance =
                math.sqrt(
                    dx * dx +
                    dy * dy
                )

            if distance < 53 or
                distance > 77
            then

                return

            end

            local angle =
                math.atan2(
                    dy,
                    dx
                )

            if angle < 0 then

                angle =
                    angle +
                    math.pi * 2

            end

            hueValue =
                angle /
                (math.pi * 2)

            updateColor()

        end

        hueWheel.InputBegan:Connect(
            function(input)

                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                then

                    hueDragging = true

                    updateHue(
                        input.Position.X,
                        input.Position.Y
                    )

                end

            end
        )

        local hueChanged =
            UserInputService.InputChanged:Connect(
                function(input)

                    if hueDragging and
                        input.UserInputType ==
                        Enum.UserInputType.MouseMovement
                    then

                        updateHue(
                            input.Position.X,
                            input.Position.Y
                        )

                    end

                end
            )

        local hueEnded =
            UserInputService.InputEnded:Connect(
                function(input)

                    if input.UserInputType ==
                        Enum.UserInputType.MouseButton1
                    then

                        hueDragging = false

                    end

                end
            )

        -- =====================================================
        -- OPEN / CLOSE
        -- =====================================================

        closePicker.MouseButton1Click:Connect(
            function()

                picker.Visible = false

            end
        )

        button.MouseButton1Click:Connect(
            function()

                for _, otherPicker
                    in ipairs(espPickerFrames)
                do

                    if otherPicker ~= picker then
                        otherPicker.Visible = false
                    end

                end

                picker.Visible =
                    not picker.Visible

            end
        )

        table.insert(
            espPickerConnections,
            svChanged
        )

        table.insert(
            espPickerConnections,
            svEnded
        )

        table.insert(
            espPickerConnections,
            hueChanged
        )

        table.insert(
            espPickerConnections,
            hueEnded
        )

        table.insert(
            espPickerFrames,
            picker
        )

        return picker

    end

    -- =========================================================
    -- ESP PLAYERS GUI
    -- =========================================================

    local espLabel =
        Instance.new("TextLabel")

    espLabel.Name =
        "ESPPlayersLabel"

    espLabel.Size =
        UDim2.new(0, 110, 0, 25)

    espLabel.Position =
        UDim2.new(0, 10, 0, 108)

    espLabel.BackgroundTransparency = 1

    espLabel.Text =
        "ESP Players"

    espLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    espLabel.TextSize = 12
    espLabel.Font =
        Enum.Font.SourceSans

    espLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    espLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    espLabel.Parent = visPage

    local espToggle, espKnob =
        createToggle(
            visPage,
            114
        )

    setToggleVisual(
        espToggle,
        espKnob,
        false
    )

    espToggle.MouseButton1Click:Connect(
        function()

            if espPlayersEnabled then
                disableESPPlayers()
            else
                enableESPPlayers()
            end

            setToggleVisual(
                espToggle,
                espKnob,
                espPlayersEnabled
            )

        end
    )

    -- =========================================================
    -- ESP FILL
    -- =========================================================

    local espFillLabel =
        Instance.new("TextLabel")

    espFillLabel.Name =
        "ESPFillLabel"

    espFillLabel.Size =
        UDim2.new(0, 110, 0, 25)

    espFillLabel.Position =
        UDim2.new(0, 10, 0, 139)

    espFillLabel.BackgroundTransparency = 1

    espFillLabel.Text =
        "ESP Fill"

    espFillLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    espFillLabel.TextSize = 12
    espFillLabel.Font =
        Enum.Font.SourceSans

    espFillLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    espFillLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    espFillLabel.Parent = visPage

    local espFillToggle, espFillKnob =
        createToggle(
            visPage,
            145
        )

    setToggleVisual(
        espFillToggle,
        espFillKnob,
        true
    )

    espFillToggle.MouseButton1Click:Connect(
        function()

            espFillEnabled =
                not espFillEnabled

            updateESP()

            setToggleVisual(
                espFillToggle,
                espFillKnob,
                espFillEnabled
            )

        end
    )

    -- =========================================================
    -- FILL COLOR
    -- =========================================================

    local espFillColorLabel =
        Instance.new("TextLabel")

    espFillColorLabel.Name =
        "ESPFillColorLabel"

    espFillColorLabel.Size =
        UDim2.new(0, 110, 0, 25)

    espFillColorLabel.Position =
        UDim2.new(0, 10, 0, 170)

    espFillColorLabel.BackgroundTransparency = 1

    espFillColorLabel.Text =
        "Fill Color"

    espFillColorLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    espFillColorLabel.TextSize = 12
    espFillColorLabel.Font =
        Enum.Font.SourceSans

    espFillColorLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    espFillColorLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    espFillColorLabel.Parent = visPage

    local espFillColorButton =
        Instance.new("TextButton")

    espFillColorButton.Name =
        "ESPFillColorButton"

    espFillColorButton.Size =
        UDim2.new(0, 32, 0, 18)

    espFillColorButton.Position =
        UDim2.new(1, -88, 0, 176)

    espFillColorButton.BackgroundColor3 =
        espFillColor

    espFillColorButton.BorderSizePixel = 0
    espFillColorButton.Text = ""
    espFillColorButton.AutoButtonColor = false
    espFillColorButton.Parent = visPage

    local espFillColorCorner =
        Instance.new("UICorner")

    espFillColorCorner.CornerRadius =
        UDim.new(0, 3)

    espFillColorCorner.Parent =
        espFillColorButton

    createColorPicker(
        visPage,
        espFillColorButton,
        espFillColor,
        function(color)

            espFillColor = color

            espFillColorButton.BackgroundColor3 =
                color

            updateESP()

        end
    )

    -- =========================================================
    -- OUTLINE COLOR
    -- =========================================================

    local espOutlineColorLabel =
        Instance.new("TextLabel")

    espOutlineColorLabel.Name =
        "ESPOutlineColorLabel"

    espOutlineColorLabel.Size =
        UDim2.new(0, 110, 0, 25)

    espOutlineColorLabel.Position =
        UDim2.new(0, 10, 0, 201)

    espOutlineColorLabel.BackgroundTransparency = 1

    espOutlineColorLabel.Text =
        "Outline Color"

    espOutlineColorLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    espOutlineColorLabel.TextSize = 12
    espOutlineColorLabel.Font =
        Enum.Font.SourceSans

    espOutlineColorLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    espOutlineColorLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    espOutlineColorLabel.Parent = visPage

    local espOutlineColorButton =
        Instance.new("TextButton")

    espOutlineColorButton.Name =
        "ESPOutlineColorButton"

    espOutlineColorButton.Size =
        UDim2.new(0, 32, 0, 18)

    espOutlineColorButton.Position =
        UDim2.new(1, -88, 0, 207)

    espOutlineColorButton.BackgroundColor3 =
        espOutlineColor

    espOutlineColorButton.BorderSizePixel = 0
    espOutlineColorButton.Text = ""
    espOutlineColorButton.AutoButtonColor = false
    espOutlineColorButton.Parent = visPage

    local espOutlineColorCorner =
        Instance.new("UICorner")

    espOutlineColorCorner.CornerRadius =
        UDim.new(0, 3)

    espOutlineColorCorner.Parent =
        espOutlineColorButton

    createColorPicker(
        visPage,
        espOutlineColorButton,
        espOutlineColor,
        function(color)

            espOutlineColor = color

            espOutlineColorButton.BackgroundColor3 =
                color

            updateESP()

        end
    )

    -- =========================================================
    -- ESP KILLERS
    -- =========================================================

    local espKillerLabel =
        Instance.new("TextLabel")

    espKillerLabel.Name =
        "ESPKillerLabel"

    espKillerLabel.Size =
        UDim2.new(0, 110, 0, 25)

    espKillerLabel.Position =
        UDim2.new(0, 10, 0, 232)

    espKillerLabel.BackgroundTransparency = 1

    espKillerLabel.Text =
        "ESP Killers"

    espKillerLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    espKillerLabel.TextSize = 12
    espKillerLabel.Font =
        Enum.Font.SourceSans

    espKillerLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    espKillerLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    espKillerLabel.Parent = visPage

    local espKillerToggle, espKillerKnob =
        createToggle(
            visPage,
            238
        )

    setToggleVisual(
        espKillerToggle,
        espKillerKnob,
        false
    )

    espKillerToggle.MouseButton1Click:Connect(
        function()

            if espKillerEnabled then
                disableESPKillers()
            else
                enableESPKillers()
            end

            setToggleVisual(
                espKillerToggle,
                espKillerKnob,
                espKillerEnabled
            )

        end
    )

    -- =========================================================
    -- KILLER FILL
    -- =========================================================

    local espKillerFillLabel =
        Instance.new("TextLabel")

    espKillerFillLabel.Name =
        "ESPKillerFillLabel"

    espKillerFillLabel.Size =
        UDim2.new(0, 110, 0, 25)

    espKillerFillLabel.Position =
        UDim2.new(0, 10, 0, 263)

    espKillerFillLabel.BackgroundTransparency = 1

    espKillerFillLabel.Text =
        "Killer Fill"

    espKillerFillLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    espKillerFillLabel.TextSize = 12
    espKillerFillLabel.Font =
        Enum.Font.SourceSans

    espKillerFillLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    espKillerFillLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    espKillerFillLabel.Parent = visPage

    local espKillerFillToggle,
        espKillerFillKnob =
        createToggle(
            visPage,
            269
        )

    setToggleVisual(
        espKillerFillToggle,
        espKillerFillKnob,
        true
    )

    espKillerFillToggle.MouseButton1Click:Connect(
        function()

            espKillerFillEnabled =
                not espKillerFillEnabled

            updateKillerESP()

            setToggleVisual(
                espKillerFillToggle,
                espKillerFillKnob,
                espKillerFillEnabled
            )

        end
    )

    -- =========================================================
    -- KILLER FILL COLOR
    -- =========================================================

    local espKillerFillColorLabel =
        Instance.new("TextLabel")

    espKillerFillColorLabel.Name =
        "ESPKillerFillColorLabel"

    espKillerFillColorLabel.Size =
        UDim2.new(0, 110, 0, 25)

    espKillerFillColorLabel.Position =
        UDim2.new(0, 10, 0, 294)

    espKillerFillColorLabel.BackgroundTransparency = 1

    espKillerFillColorLabel.Text =
        "Killer Fill Color"

    espKillerFillColorLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    espKillerFillColorLabel.TextSize = 12
    espKillerFillColorLabel.Font =
        Enum.Font.SourceSans

    espKillerFillColorLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    espKillerFillColorLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    espKillerFillColorLabel.Parent = visPage

    local espKillerFillColorButton =
        Instance.new("TextButton")

    espKillerFillColorButton.Name =
        "ESPKillerFillColorButton"

    espKillerFillColorButton.Size =
        UDim2.new(0, 32, 0, 18)

    espKillerFillColorButton.Position =
        UDim2.new(
            1,
            -88,
            0,
            300
        )

    espKillerFillColorButton.BackgroundColor3 =
        espKillerFillColor

    espKillerFillColorButton.BorderSizePixel = 0
    espKillerFillColorButton.Text = ""
    espKillerFillColorButton.AutoButtonColor = false
    espKillerFillColorButton.Parent = visPage

    local espKillerFillColorCorner =
        Instance.new("UICorner")

    espKillerFillColorCorner.CornerRadius =
        UDim.new(0, 3)

    espKillerFillColorCorner.Parent =
        espKillerFillColorButton

    createColorPicker(
        visPage,
        espKillerFillColorButton,
        espKillerFillColor,
        function(color)

            espKillerFillColor = color

            espKillerFillColorButton.BackgroundColor3 =
                color

            updateKillerESP()

        end
    )

    -- =========================================================
    -- KILLER OUTLINE COLOR
    -- =========================================================

    local espKillerOutlineColorLabel =
        Instance.new("TextLabel")

    espKillerOutlineColorLabel.Name =
        "ESPKillerOutlineColorLabel"

    espKillerOutlineColorLabel.Size =
        UDim2.new(0, 110, 0, 25)

    espKillerOutlineColorLabel.Position =
        UDim2.new(0, 10, 0, 325)

    espKillerOutlineColorLabel.BackgroundTransparency = 1

    espKillerOutlineColorLabel.Text =
        "Killer Outline"

    espKillerOutlineColorLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    espKillerOutlineColorLabel.TextSize = 12
    espKillerOutlineColorLabel.Font =
        Enum.Font.SourceSans

    espKillerOutlineColorLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    espKillerOutlineColorLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    espKillerOutlineColorLabel.Parent = visPage

    local espKillerOutlineColorButton =
        Instance.new("TextButton")

    espKillerOutlineColorButton.Name =
        "ESPKillerOutlineColorButton"

    espKillerOutlineColorButton.Size =
        UDim2.new(0, 32, 0, 18)

    espKillerOutlineColorButton.Position =
        UDim2.new(
            1,
            -88,
            0,
            331
        )

    espKillerOutlineColorButton.BackgroundColor3 =
        espKillerOutlineColor

    espKillerOutlineColorButton.BorderSizePixel = 0
    espKillerOutlineColorButton.Text = ""
    espKillerOutlineColorButton.AutoButtonColor = false
    espKillerOutlineColorButton.Parent = visPage

    local espKillerOutlineColorCorner =
        Instance.new("UICorner")

    espKillerOutlineColorCorner.CornerRadius =
        UDim.new(0, 3)

    espKillerOutlineColorCorner.Parent =
        espKillerOutlineColorButton

    createColorPicker(
        visPage,
        espKillerOutlineColorButton,
        espKillerOutlineColor,
        function(color)

            espKillerOutlineColor = color

            espKillerOutlineColorButton.BackgroundColor3 =
                color

            updateKillerESP()

        end
    )

    -- =========================================================
    -- ESP CLEANUP
    -- =========================================================

    function cleanupESP()

        disableESPPlayers()
        disableESPKillers()

        if espPlayerAddedConnection then

            espPlayerAddedConnection:Disconnect()
            espPlayerAddedConnection = nil

        end

        if espPlayerRemovingConnection then

            espPlayerRemovingConnection:Disconnect()
            espPlayerRemovingConnection = nil

        end

        -- =====================================================
        -- CLEANUP CHARACTER CONNECTIONS
        -- =====================================================

        for plr, connections
            in pairs(espCharacterConnections)
        do

            for _, connection
                in pairs(connections)
            do

                if connection then
                    connection:Disconnect()
                end

            end

            espCharacterConnections[plr] = nil

        end

        for _, connection
            in ipairs(espPickerConnections)
        do

            if connection then
                connection:Disconnect()
            end

        end

        table.clear(
            espPickerConnections
        )

        for _, picker
            in ipairs(espPickerFrames)
        do

            if picker then
                picker:Destroy()
            end

        end

        table.clear(
            espPickerFrames
        )

        for plr, highlight
            in pairs(espHighlights)
        do

            if highlight then
                highlight:Destroy()
            end

            espHighlights[plr] = nil

        end

    end
end
end

trajectoryToggle.MouseButton1Click:Connect(function()
    Vis.toggleTrajectory()
end)
trajectoryPlusToggle.MouseButton1Click:Connect(function()
    Vis.toggleTrajectoryPlus()
end)
trajectoryKeyButton.MouseButton1Click:Connect(function()
    Vis.beginHotkey("Trajectory")
end)
trajectoryPlusKeyButton.MouseButton1Click:Connect(function()
    Vis.beginHotkey("TrajectoryPlus")
end)

function Vis.render()
    if currentMode == "Trajectory" then
        updateTrajectory()
    elseif currentMode == "TrajectoryPlus" then
        updateTrajectoryPlus()
    end
end

function Vis.toggleTrajectory()
    if trajectoryEnabled then
        trajectoryEnabled = false
        if currentMode == "Trajectory" then currentMode = nil end
        hideTrajectory()
        setToggleVisual(trajectoryToggle, trajectoryKnob, false)
    else
        trajectoryPlusEnabled = false
        hideTrajectoryPlus()
        setToggleVisual(trajectoryPlusToggle, trajectoryPlusKnob, false)
        trajectoryEnabled = true
        currentMode = "Trajectory"
        setToggleVisual(trajectoryToggle, trajectoryKnob, true)
    end
end

function Vis.toggleTrajectoryPlus()
    if trajectoryPlusEnabled then
        trajectoryPlusEnabled = false
        if currentMode == "TrajectoryPlus" then currentMode = nil end
        hideTrajectoryPlus()
        setToggleVisual(trajectoryPlusToggle, trajectoryPlusKnob, false)
    else
        trajectoryEnabled = false
        hideTrajectory()
        setToggleVisual(trajectoryToggle, trajectoryKnob, false)
        trajectoryPlusEnabled = true
        currentMode = "TrajectoryPlus"
        setToggleVisual(trajectoryPlusToggle, trajectoryPlusKnob, true)
    end
end

function Vis.handleKey(key)
    if key == trajectoryHotkey then Vis.toggleTrajectory(); return true end
    if key == trajectoryPlusHotkey then Vis.toggleTrajectoryPlus(); return true end
    return false
end

function Vis.beginHotkey(feature)
    waitingForHotkey = feature
    if feature == "Trajectory" then trajectoryKeyButton.Text = "..." end
    if feature == "TrajectoryPlus" then trajectoryPlusKeyButton.Text = "..." end
end

function Vis.assignHotkey(key)
    if not waitingForHotkey then return false end
    if key == Enum.KeyCode.Escape then
        trajectoryKeyButton.Text = trajectoryHotkey.Name
        trajectoryPlusKeyButton.Text = trajectoryPlusHotkey.Name
    elseif waitingForHotkey == "Trajectory" then
        trajectoryHotkey = key
        trajectoryKeyButton.Text = key.Name
    else
        trajectoryPlusHotkey = key
        trajectoryPlusKeyButton.Text = key.Name
    end
    waitingForHotkey = nil
    return true
end

function Vis.destroy()
    cleanupESP()
    hideTrajectory()
    hideTrajectoryPlus()
    if fovConnection then fovConnection:Disconnect(); fovConnection = nil end
    if trajectoryFolder then trajectoryFolder:Destroy() end
end

return Vis
