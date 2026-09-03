local Vis = {}

-- =========================================================
-- SERVICES
-- =========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- =========================================================
-- UI
-- =========================================================

local visPage = nil
local createToggle = nil
local setToggleVisual = nil

local trajectoryKeyButton = nil
local trajectoryPlusKeyButton = nil

local trajectoryToggle = nil
local trajectoryPlusToggle = nil

local trajectoryKnob = nil
local trajectoryPlusKnob = nil

-- =========================================================
-- HOTKEYS
-- =========================================================

local trajectoryHotkey = Enum.KeyCode.G
local trajectoryPlusHotkey = Enum.KeyCode.Y

local waitingForHotkey = nil

-- =========================================================
-- STATES
-- =========================================================

local trajectoryEnabled = false
local trajectoryPlusEnabled = false

local currentMode = nil

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
-- CAMERA
-- =========================================================

local function getCamera()

    camera = Workspace.CurrentCamera

    return camera
end

-- =========================================================
-- TRAJECTORY SETTINGS
-- =========================================================

local MIN_THICKNESS = 0.05
local MAX_THICKNESS = 0.4

local GRAVITY_DEFAULT = 126
local GRAVITY_ALT = 96

local SPEED = 165

local NUM_POINTS = 40
local TIME_STEP = 0.08

local LINE_THICKNESS = 0.4

local FADE_START_DIST = 30
local FADE_END_DIST = 7

local IMPACT_SPHERE_RADIUS = 0.6
local IMPACT_SPHERE_TRANSPARENCY = 0.5

local Y_HIT_COLOR =
    Color3.fromRGB(
        255,
        40,
        40
    )

local Y_NORMAL_COLOR =
    Color3.new(
        1,
        0.6,
        0
    )

-- =========================================================
-- WALL NAMES
-- =========================================================

local WALL_NAMES = {}

local function updateWallNames()

    table.clear(WALL_NAMES)

    for _, plr in ipairs(
        Players:GetPlayers()
    ) do

        WALL_NAMES[plr.Name] = true

    end

end

addConnection(
    Players.PlayerAdded:Connect(
        updateWallNames
    )
)

addConnection(
    Players.PlayerRemoving:Connect(
        updateWallNames
    )
)

updateWallNames()

local function findWallInstance(hitInstance)

    local instance = hitInstance

    while instance
        and instance ~= Workspace
    do

        if WALL_NAMES[instance.Name] then
            return instance
        end

        instance = instance.Parent

    end

    return nil
end

-- =========================================================
-- FADE
-- =========================================================

local function fadeTransparency(
    camPos,
    segmentPos
)

    local distance =
        (
            segmentPos
            - camPos
        ).Magnitude

    if distance >= FADE_START_DIST then
        return 0
    end

    if distance <= FADE_END_DIST then
        return 1
    end

    local t =
        (
            distance
            - FADE_END_DIST
        )
        /
        (
            FADE_START_DIST
            - FADE_END_DIST
        )

    return 1 - t
end

-- =========================================================
-- POINTS
-- =========================================================

local points = {}

for i = 1, NUM_POINTS do

    points[i] =
        Vector3.new(
            0,
            0,
            0
        )

end

-- =========================================================
-- FOLDER
-- =========================================================

local trajectoryFolder =
    Instance.new("Folder")

trajectoryFolder.Name =
    "TrajectoryVisuals"

trajectoryFolder.Parent =
    Workspace

-- =========================================================
-- TRAJECTORY
-- =========================================================

local segmentsTrajectory = {}
local impactSphereTrajectory = nil

local rayParamsTrajectory =
    RaycastParams.new()

rayParamsTrajectory.FilterType =
    Enum.RaycastFilterType.Exclude

rayParamsTrajectory.FilterDescendantsInstances = {
    trajectoryFolder
}

rayParamsTrajectory.IgnoreWater = true

for i = 1, NUM_POINTS - 1 do

    local segment =
        Instance.new("Part")

    segment.Name =
        "TrajectorySegment" .. i

    segment.Anchored = true

    segment.CanCollide = false
    segment.CanQuery = false
    segment.CanTouch = false

    segment.Massless = true

    segment.Material =
        Enum.Material.Neon

    segment.Color =
        Color3.new(
            1,
            0.6,
            0
        )

    segment.Transparency = 1

    segment.Size =
        Vector3.new(
            LINE_THICKNESS,
            LINE_THICKNESS,
            0.1
        )

    segment.Parent =
        trajectoryFolder

    segmentsTrajectory[i] =
        segment

end

impactSphereTrajectory =
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

local function placeSegment(
    segment,
    p0,
    p1
)

    local distance =
        (
            p1 - p0
        ).Magnitude

    local midpoint =
        (
            p0 + p1
        ) / 2

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
            midpoint,
            p1
        )

end

local function updateTrajectory()

    local cam =
        getCamera()

    if not cam then
        return
    end

    local startPos =
        cam.CFrame.Position

    local direction =
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
            + direction
                * SPEED
                * t
            + 0.5
                * gravity
                * t
                * t

    end

    local hitWallPos = nil

    for i = 1, NUM_POINTS - 1 do

        local p0 =
            (
                i == 1
                and startPos
                or points[i - 1]
            )

        local p1 =
            points[i]

        if hitWallPos then

            segmentsTrajectory[i].Transparency =
                1

        else

            local result =
                Workspace:Raycast(
                    p0,
                    p1 - p0,
                    rayParamsTrajectory
                )

            if result
                and findWallInstance(
                    result.Instance
                )
            then

                hitWallPos =
                    result.Position

                placeSegment(
                    segmentsTrajectory[i],
                    p0,
                    hitWallPos
                )

                segmentsTrajectory[i].Transparency =
                    fadeTransparency(
                        startPos,
                        (
                            p0
                            + hitWallPos
                        ) / 2
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
                        (
                            p0
                            + p1
                        ) / 2
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

        impactSphereTrajectory.Transparency =
            1

    end

end

local function hideTrajectory()

    for _, segment in ipairs(
        segmentsTrajectory
    ) do

        segment.Transparency = 1

    end

    impactSphereTrajectory.Transparency = 1

end

-- =========================================================
-- TRAJECTORY PLUS
-- =========================================================

local anchorPart =
    Instance.new("Part")

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
    CFrame.new(
        0,
        0,
        0
    )

anchorPart.Parent =
    trajectoryFolder

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

impactSphereTrajectoryPlus.Transparency =
    1

impactSphereTrajectoryPlus.AlwaysOnTop =
    true

impactSphereTrajectoryPlus.ZIndex =
    10

impactSphereTrajectoryPlus.CFrame =
    CFrame.new(
        0,
        0,
        0
    )

impactSphereTrajectoryPlus.Parent =
    anchorPart

local rayParamsTrajectoryPlus =
    RaycastParams.new()

rayParamsTrajectoryPlus.FilterType =
    Enum.RaycastFilterType.Exclude

rayParamsTrajectoryPlus.FilterDescendantsInstances = {
    anchorPart
}

rayParamsTrajectoryPlus.IgnoreWater = true

local MIN_SEGMENT_LENGTH = 0.2

local function placeAdornment(
    adorn,
    p0,
    p1,
    thickness
)

    local distance =
        (
            p1 - p0
        ).Magnitude

    if distance <
        MIN_SEGMENT_LENGTH
    then

        adorn.Transparency = 1

        return

    end

    local midpoint =
        (
            p0 + p1
        ) / 2

    adorn.Size =
        Vector3.new(
            thickness,
            thickness,
            distance
        )

    adorn.CFrame =
        CFrame.new(
            midpoint,
            p1
        )

    adorn.Transparency = 0

end

local function updateTrajectoryPlus()

    local cam =
        getCamera()

    if not cam then
        return
    end

    local startPos =
        cam.CFrame.Position

    local direction =
        cam.CFrame.LookVector

    local gravity =
        Vector3.new(
            0,
            -GRAVITY_ALT,
            0
        )

    for i = 1, NUM_POINTS do

        local t =
            i * TIME_STEP

        points[i] =
            startPos
            + direction
                * SPEED
                * t
            + 0.5
                * gravity
                * t
                * t

    end

    local hitFound = false
    local hitPos = nil

    for i = 1, NUM_POINTS - 1 do

        local p0 =
            (
                i == 1
                and startPos
                or points[i - 1]
            )

        local p1 =
            points[i]

        local midpoint =
            (
                p0 + p1
            ) / 2

        local distanceToCam =
            (
                midpoint
                - startPos
            ).Magnitude

        local fade =
            1 -
            (
                distanceToCam
                - FADE_END_DIST
            )
            /
            (
                FADE_START_DIST
                - FADE_END_DIST
            )

        fade =
            math.clamp(
                fade,
                0,
                1
            )

        local thickness =
            MIN_THICKNESS
            + (
                MAX_THICKNESS
                - MIN_THICKNESS
            )
            * (
                1 - fade
            )

        if hitFound then

            segmentsTrajectoryPlus[i].Transparency =
                1

            segmentsTrajectoryPlus[i].Color3 =
                Y_NORMAL_COLOR

            continue
        end

        local result =
            Workspace:Raycast(
                p0,
                p1 - p0,
                rayParamsTrajectoryPlus
            )

        if result
            and findWallInstance(
                result.Instance
            )
        then

            hitFound = true

            hitPos =
                result.Position

            placeAdornment(
                segmentsTrajectoryPlus[i],
                p0,
                hitPos,
                thickness
            )

            local midHit =
                (
                    p0
                    + hitPos
                ) / 2

            segmentsTrajectoryPlus[i].Transparency =
                fadeTransparency(
                    startPos,
                    midHit
                )

            segmentsTrajectoryPlus[i].Color3 =
                Y_HIT_COLOR

        else

            placeAdornment(
                segmentsTrajectoryPlus[i],
                p0,
                p1,
                thickness
            )

            segmentsTrajectoryPlus[i].Transparency =
                fadeTransparency(
                    startPos,
                    midpoint
                )

            segmentsTrajectoryPlus[i].Color3 =
                Y_NORMAL_COLOR

        end
    end

    if hitFound then

        impactSphereTrajectoryPlus.CFrame =
            CFrame.new(
                hitPos
            )

        impactSphereTrajectoryPlus.Transparency =
            IMPACT_SPHERE_TRANSPARENCY

    else

        impactSphereTrajectoryPlus.Transparency =
            1

    end

end

local function hideTrajectoryPlus()

    for _, segment in ipairs(
        segmentsTrajectoryPlus
    ) do

        segment.Transparency = 1

    end

    impactSphereTrajectoryPlus.Transparency =
        1

end

-- =========================================================
-- FOV
-- =========================================================

local fovValue = 70

local fovConnection = nil

local function updateFOV()

    local cam =
        getCamera()

    if cam then
        cam.FieldOfView =
            fovValue
    end

end

fovConnection =
    addConnection(
        RunService.RenderStepped:Connect(
            updateFOV
        )
    )

-- =========================================================
-- ESP
-- =========================================================

local espPlayersEnabled = false
local espKillerEnabled = false

local espFillEnabled = true
local espKillerFillEnabled = true

local espFillColor =
    Color3.fromRGB(
        255,
        0,
        0
    )

local espOutlineColor =
    Color3.fromRGB(
        255,
        255,
        255
    )

local espKillerFillColor =
    Color3.fromRGB(
        255,
        0,
        0
    )

local espKillerOutlineColor =
    Color3.fromRGB(
        255,
        255,
        255
    )

local espHighlights = {}
local espKillerHighlights = {}

local espCharacterConnections = {}

local espPlayerAddedConnection = nil
local espPlayerRemovingConnection = nil

-- =========================================================
-- ESP HELPERS
-- =========================================================

local function isKiller(plr)

    if plr == player then
        return false
    end

    local character =
        plr.Character

    if not character then
        return false
    end

    return
        character:FindFirstChild(
            "Weapon",
            true
        ) ~= nil

end

local function removeESP(plr)

    local highlight =
        espHighlights[plr]

    if highlight then

        pcall(function()
            highlight:Destroy()
        end)

        espHighlights[plr] = nil
    end

end

local function removeKillerESP(plr)

    local highlight =
        espKillerHighlights[plr]

    if highlight then

        pcall(function()
            highlight:Destroy()
        end)

        espKillerHighlights[plr] = nil
    end

end

local function createESP(plr)

    if plr == player then
        return
    end

    if not espPlayersEnabled then
        return
    end

    if isKiller(plr) then

        removeESP(plr)

        return
    end

    local character =
        plr.Character

    if not character then
        return
    end

    removeESP(plr)

    local highlight =
        Instance.new("Highlight")

    highlight.Name =
        "ESPPlayers"

    highlight.Adornee =
        character

    highlight.FillColor =
        espFillColor

    highlight.FillTransparency =
        espFillEnabled
        and 0.5
        or 1

    highlight.OutlineColor =
        espOutlineColor

    highlight.OutlineTransparency = 0

    highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    highlight.Parent =
        character

    espHighlights[plr] =
        highlight

end

local function createKillerESP(plr)

    if plr == player then
        return
    end

    if not espKillerEnabled then
        return
    end

    if not isKiller(plr) then

        removeKillerESP(plr)

        return
    end

    local character =
        plr.Character

    if not character then
        return
    end

    removeKillerESP(plr)

    local highlight =
        Instance.new("Highlight")

    highlight.Name =
        "ESPKiller"

    highlight.Adornee =
        character

    highlight.FillColor =
        espKillerFillColor

    highlight.FillTransparency =
        espKillerFillEnabled
        and 0.5
        or 1

    highlight.OutlineColor =
        espKillerOutlineColor

    highlight.OutlineTransparency =
        0

    highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    highlight.Parent =
        character

    espKillerHighlights[plr] =
        highlight

end

local function refreshESP(plr)

    if plr == player then
        return
    end

    if isKiller(plr) then

        removeESP(plr)

        if espKillerEnabled then
            createKillerESP(plr)
        end

    else

        removeKillerESP(plr)

        if espPlayersEnabled then
            createESP(plr)
        end

    end

end

-- =========================================================
-- ESP ENABLE / DISABLE
-- =========================================================

local function enableESPPlayers()

    espPlayersEnabled = true

    for _, plr in ipairs(
        Players:GetPlayers()
    ) do

        if plr ~= player then
            refreshESP(plr)
        end

    end
end

local function disableESPPlayers()

    espPlayersEnabled = false

    for plr, highlight in pairs(
        espHighlights
    ) do

        if highlight then

            pcall(function()
                highlight:Destroy()
            end)

        end

        espHighlights[plr] = nil

    end
end

local function enableESPKillers()

    espKillerEnabled = true

    for _, plr in ipairs(
        Players:GetPlayers()
    ) do

        if plr ~= player then
            refreshESP(plr)
        end

    end
end

local function disableESPKillers()

    espKillerEnabled = false

    for plr, highlight in pairs(
        espKillerHighlights
    ) do

        if highlight then

            pcall(function()
                highlight:Destroy()
            end)

        end

        espKillerHighlights[plr] = nil

    end
end

local function updateESP()

    for plr, highlight in pairs(
        espHighlights
    ) do

        if highlight
            and plr ~= player
        then

            highlight.FillColor =
                espFillColor

            highlight.FillTransparency =
                espFillEnabled
                and 0.5
                or 1

            highlight.OutlineColor =
                espOutlineColor

            highlight.OutlineTransparency =
                0

        end
    end
end

local function updateKillerESP()

    for plr, highlight in pairs(
        espKillerHighlights
    ) do

        if highlight
            and plr ~= player
        then

            highlight.FillColor =
                espKillerFillColor

            highlight.FillTransparency =
                espKillerFillEnabled
                and 0.5
                or 1

            highlight.OutlineColor =
                espKillerOutlineColor

            highlight.OutlineTransparency =
                0

        end
    end
end

-- =========================================================
-- CHARACTER MONITORING
-- =========================================================

local function cleanupCharacterMonitoring(plr)

    local playerConnections =
        espCharacterConnections[plr]

    if not playerConnections then
        return
    end

    for _, connection in pairs(
        playerConnections
    ) do

        disconnectConnection(
            connection
        )

    end

    espCharacterConnections[plr] =
        nil
end

local function setupCharacterMonitoring(plr)

    if plr == player then
        return
    end

    cleanupCharacterMonitoring(
        plr
    )

    espCharacterConnections[plr] = {}

    local function monitorCharacter(
        character
    )

        table.insert(
            espCharacterConnections[plr],

            character.ChildAdded:Connect(
                function(child)

                    if child.Name ==
                        "Weapon"
                    then

                        refreshESP(plr)

                    end

                end
            )
        )

        table.insert(
            espCharacterConnections[plr],

            character.ChildRemoved:Connect(
                function(child)

                    if child.Name ==
                        "Weapon"
                    then

                        refreshESP(plr)

                    end

                end
            )
        )

        task.defer(function()

            refreshESP(plr)

        end)

    end

    if plr.Character then
        monitorCharacter(
            plr.Character
        )
    end

    table.insert(
        espCharacterConnections[plr],

        plr.CharacterAdded:Connect(
            function(character)

                task.wait(0.1)

                if character
                    and character.Parent
                then

                    monitorCharacter(
                        character
                    )

                end

            end
        )
    )

end

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

    cleanupCharacterMonitoring(
        plr
    )

end

-- =========================================================
-- INITIAL ESP PLAYER CONNECTIONS
-- =========================================================

for _, plr in ipairs(
    Players:GetPlayers()
) do

    setupESPPlayer(plr)

end

espPlayerAddedConnection =
    addConnection(
        Players.PlayerAdded:Connect(
            function(plr)

                if plr ~= player then
                    setupESPPlayer(plr)
                end

            end
        )
    )

espPlayerRemovingConnection =
    addConnection(
        Players.PlayerRemoving:Connect(
            function(plr)

                removeESPPlayer(plr)

            end
        )
    )

-- =========================================================
-- COLOR PICKER
-- =========================================================

local espPickerFrames = {}
local espPickerConnections = {}

local function createColorPicker(
    parent,
    button,
    initialColor,
    callback
)

    local picker =
        Instance.new("Frame")

    picker.Name =
        "ColorPicker"

    picker.Size =
        UDim2.new(
            0,
            315,
            0,
            185
        )

    picker.Position =
        UDim2.new(
            1,
            -325,
            0,
            button.Position.Y.Offset - 5
        )

    picker.BackgroundColor3 =
        Color3.fromRGB(
            30,
            30,
            30
        )

    picker.BorderSizePixel = 0
    picker.Visible = false
    picker.ZIndex = 100
    picker.Parent = parent

    local pickerCorner =
        Instance.new("UICorner")

    pickerCorner.CornerRadius =
        UDim.new(
            0,
            6
        )

    pickerCorner.Parent =
        picker

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

    hueWheel.Name =
        "HueWheel"

    hueWheel.Size =
        UDim2.new(
            0,
            150,
            0,
            150
        )

    hueWheel.Position =
        UDim2.new(
            0,
            10,
            0,
            12
        )

    hueWheel.BackgroundTransparency = 1
    hueWheel.BorderSizePixel = 0
    hueWheel.ZIndex = 101
    hueWheel.Parent = picker

    local hueCenter = 75
    local hueRadius = 64

    local hueSegmentCount = 360

    for i = 0,
        hueSegmentCount - 1
    do

        local segment =
            Instance.new("Frame")

        local angle =
            (
                i
                / hueSegmentCount
            )
            * math.pi
            * 2

        segment.Size =
            UDim2.new(
                0,
                4,
                0,
                19
            )

        segment.AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            )

        segment.Position =
            UDim2.new(
                0,
                hueCenter
                    + math.cos(angle)
                    * hueRadius,

                0,
                hueCenter
                    + math.sin(angle)
                    * hueRadius
            )

        segment.Rotation =
            math.deg(angle)
            + 90

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

    hueSelector.Name =
        "HueSelector"

    hueSelector.Size =
        UDim2.new(
            0,
            12,
            0,
            12
        )

    hueSelector.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    hueSelector.BackgroundColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )

    hueSelector.BorderSizePixel = 2

    hueSelector.BorderColor3 =
        Color3.fromRGB(
            0,
            0,
            0
        )

    hueSelector.ZIndex = 110
    hueSelector.Parent = hueWheel

    local hueSelectorCorner =
        Instance.new("UICorner")

    hueSelectorCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    hueSelectorCorner.Parent =
        hueSelector

    -- =====================================================
    -- SV SQUARE
    -- =====================================================

    local svSquare =
        Instance.new("Frame")

    svSquare.Name =
        "SVSquare"

    svSquare.Size =
        UDim2.new(
            0,
            145,
            0,
            145
        )

    svSquare.Position =
        UDim2.new(
            0,
            170,
            0,
            12
        )

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
        UDim.new(
            0,
            3
        )

    svCorner.Parent =
        svSquare

    -- =====================================================
    -- WHITE OVERLAY
    -- =====================================================

    local whiteOverlay =
        Instance.new("Frame")

    whiteOverlay.Name =
        "WhiteOverlay"

    whiteOverlay.Size =
        UDim2.new(
            1,
            0,
            1,
            0
        )

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
    whiteGradient.Parent =
        whiteOverlay

    -- =====================================================
    -- BLACK OVERLAY
    -- =====================================================

    local blackOverlay =
        Instance.new("Frame")

    blackOverlay.Name =
        "BlackOverlay"

    blackOverlay.Size =
        UDim2.new(
            1,
            0,
            1,
            0
        )

    blackOverlay.BackgroundColor3 =
        Color3.fromRGB(
            0,
            0,
            0
        )

    blackOverlay.BorderSizePixel = 0
    blackOverlay.ZIndex = 103
    blackOverlay.Parent =
        svSquare

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
    blackGradient.Parent =
        blackOverlay

    -- =====================================================
    -- SV SELECTOR
    -- =====================================================

    local svSelector =
        Instance.new("Frame")

    svSelector.Name =
        "SVSelector"

    svSelector.Size =
        UDim2.new(
            0,
            10,
            0,
            10
        )

    svSelector.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

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
    svSelector.Parent =
        svSquare

    local svSelectorCorner =
        Instance.new("UICorner")

    svSelectorCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    svSelectorCorner.Parent =
        svSelector

    -- =====================================================
    -- PREVIEW
    -- =====================================================

    local preview =
        Instance.new("Frame")

    preview.Name =
        "Preview"

    preview.Size =
        UDim2.new(
            0,
            35,
            0,
            20
        )

    preview.Position =
        UDim2.new(
            0,
            10,
            0,
            157
        )

    preview.BackgroundColor3 =
        initialColor

    preview.BorderSizePixel = 0
    preview.ZIndex = 110
    preview.Parent =
        picker

    local previewCorner =
        Instance.new("UICorner")

    previewCorner.CornerRadius =
        UDim.new(
            0,
            3
        )

    previewCorner.Parent =
        preview

    -- =====================================================
    -- OK
    -- =====================================================

    local closePicker =
        Instance.new("TextButton")

    closePicker.Name =
        "ClosePicker"

    closePicker.Size =
        UDim2.new(
            0,
            60,
            0,
            20
        )

    closePicker.Position =
        UDim2.new(
            1,
            -70,
            0,
            157
        )

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
    closePicker.Parent =
        picker

    local closeCorner =
        Instance.new("UICorner")

    closeCorner.CornerRadius =
        UDim.new(
            0,
            3
        )

    closeCorner.Parent =
        closePicker

    -- =====================================================
    -- UPDATE
    -- =====================================================

    local function updateHueSelector()

        local angle =
            hueValue
            * math.pi
            * 2

        hueSelector.Position =
            UDim2.new(
                0,
                hueCenter
                    + math.cos(angle)
                    * hueRadius,

                0,
                hueCenter
                    + math.sin(angle)
                    * hueRadius
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

    local function updateSV(
        x,
        y
    )

        local px =
            (
                x
                - svSquare.AbsolutePosition.X
            )
            /
            svSquare.AbsoluteSize.X

        local py =
            (
                y
                - svSquare.AbsolutePosition.Y
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

    addConnection(
        svSquare.InputBegan:Connect(
            function(input)

                if input.UserInputType
                    == Enum.UserInputType.MouseButton1
                then

                    svDragging = true

                    updateSV(
                        input.Position.X,
                        input.Position.Y
                    )

                end

            end
        )
    )

    addConnection(
        UserInputService.InputChanged:Connect(
            function(input)

                if svDragging
                    and input.UserInputType
                    == Enum.UserInputType.MouseMovement
                then

                    updateSV(
                        input.Position.X,
                        input.Position.Y
                    )

                end

            end
        )
    )

    addConnection(
        UserInputService.InputEnded:Connect(
            function(input)

                if input.UserInputType
                    == Enum.UserInputType.MouseButton1
                then

                    svDragging = false

                end

            end
        )
    )

    -- =====================================================
    -- HUE INPUT
    -- =====================================================

    local hueDragging = false

    local function updateHue(
        x,
        y
    )

        local center =
            hueWheel.AbsolutePosition
            + hueWheel.AbsoluteSize / 2

        local dx =
            x - center.X

        local dy =
            y - center.Y

        local distance =
            math.sqrt(
                dx * dx
                + dy * dy
            )

        if distance < 53
            or distance > 77
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
                angle
                + math.pi * 2

        end

        hueValue =
            angle
            / (
                math.pi * 2
            )

        updateColor()

    end

    addConnection(
        hueWheel.InputBegan:Connect(
            function(input)

                if input.UserInputType
                    == Enum.UserInputType.MouseButton1
                then

                    hueDragging = true

                    updateHue(
                        input.Position.X,
                        input.Position.Y
                    )

                end

            end
        )
    )

    addConnection(
        UserInputService.InputChanged:Connect(
            function(input)

                if hueDragging
                    and input.UserInputType
                    == Enum.UserInputType.MouseMovement
                then

                    updateHue(
                        input.Position.X,
                        input.Position.Y
                    )

                end

            end
        )
    )

    addConnection(
        UserInputService.InputEnded:Connect(
            function(input)

                if input.UserInputType
                    == Enum.UserInputType.MouseButton1
                then

                    hueDragging = false

                end

            end
        )
    )

    -- =====================================================
    -- OPEN / CLOSE
    -- =====================================================

    addConnection(
        closePicker.MouseButton1Click:Connect(
            function()

                picker.Visible = false

            end
        )
    )

    addConnection(
        button.MouseButton1Click:Connect(
            function()

                for _, otherPicker in ipairs(
                    espPickerFrames
                ) do

                    if otherPicker ~= picker then

                        otherPicker.Visible =
                            false

                    end

                end

                picker.Visible =
                    not picker.Visible

            end
        )
    )

    table.insert(
        espPickerFrames,
        picker
    )

    return picker
end

-- =========================================================
-- VIS MOUNT
-- =========================================================

function Vis.mount(ui)

    if not ui then
        error("Vis.mount: ui is required")
    end

    visPage =
        assert(
            ui.visPage,
            "Vis.mount: visPage is missing"
        )

    createToggle =
        assert(
            ui.createToggle,
            "Vis.mount: createToggle is missing"
        )

    setToggleVisual =
        assert(
            ui.setToggleVisual,
            "Vis.mount: setToggleVisual is missing"
        )

    -- =====================================================
    -- TRAJECTORY ROW
    -- =====================================================

    local function createFeatureRow(
        parent,
        labelText,
        y,
        defaultKey
    )

        local label =
            Instance.new("TextLabel")

        label.Size =
            UDim2.new(
                0,
                110,
                0,
                25
            )

        label.Position =
            UDim2.new(
                0,
                10,
                0,
                y
            )

        label.BackgroundTransparency = 1

        label.Text =
            labelText

        label.TextColor3 =
            Color3.fromRGB(
                242,
                242,
                242
            )

        label.TextSize = 12
        label.Font =
            Enum.Font.SourceSans

        label.TextXAlignment =
            Enum.TextXAlignment.Left

        label.TextYAlignment =
            Enum.TextYAlignment.Center

        label.Parent =
            parent

        local keyButton =
            Instance.new("TextButton")

        keyButton.Size =
            UDim2.new(
                0,
                32,
                0,
                18
            )

        keyButton.Position =
            UDim2.new(
                1,
                -88,
                0,
                y + 6
            )

        keyButton.BackgroundColor3 =
            Color3.fromRGB(
                55,
                55,
                55
            )

        keyButton.TextColor3 =
            Color3.fromRGB(
                200,
                200,
                200
            )

        keyButton.Text =
            defaultKey.Name

        keyButton.TextSize = 10
        keyButton.Font =
            Enum.Font.SourceSans

        keyButton.BorderSizePixel = 0
        keyButton.AutoButtonColor = false

        keyButton.Parent =
            parent

        local keyCorner =
            Instance.new("UICorner")

        keyCorner.CornerRadius =
            UDim.new(
                0,
                3
            )

        keyCorner.Parent =
            keyButton

        local toggleButton,
            toggleKnob =
            createToggle(
                parent,
                y + 6
            )

        return
            keyButton,
            toggleButton,
            toggleKnob
    end

    trajectoryKeyButton,
    trajectoryToggle,
    trajectoryKnob =
        createFeatureRow(
            visPage,
            "Trajectory",
            5,
            trajectoryHotkey
        )

    trajectoryPlusKeyButton,
    trajectoryPlusToggle,
    trajectoryPlusKnob =
        createFeatureRow(
            visPage,
            "TrajectoryPlus",
            36,
            trajectoryPlusHotkey
        )

    setToggleVisual(
        trajectoryToggle,
        trajectoryKnob,
        trajectoryEnabled
    )

    setToggleVisual(
        trajectoryPlusToggle,
        trajectoryPlusKnob,
        trajectoryPlusEnabled
    )

    -- =====================================================
    -- FOV GUI
    -- =====================================================

    local fovLabel =
        Instance.new("TextLabel")

    fovLabel.Name =
        "FovLabel"

    fovLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    fovLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            67
        )

    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "FOV"

    fovLabel.TextColor3 =
        Color3.fromRGB(
            242,
            242,
            242
        )

    fovLabel.TextSize = 12
    fovLabel.Font =
        Enum.Font.SourceSans

    fovLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    fovLabel.TextYAlignment =
        Enum.TextYAlignment.Center

    fovLabel.Parent =
        visPage

    local fovValueLabel =
        Instance.new("TextLabel")

    fovValueLabel.Name =
        "FovValue"

    fovValueLabel.Size =
        UDim2.new(
            0,
            35,
            0,
            18
        )

    fovValueLabel.Position =
        UDim2.new(
            1,
            -43,
            0,
            70
        )

    fovValueLabel.BackgroundTransparency = 1

    fovValueLabel.Text =
        tostring(fovValue)

    fovValueLabel.TextColor3 =
        Color3.fromRGB(
            200,
            200,
            200
        )

    fovValueLabel.TextSize = 10
    fovValueLabel.Font =
        Enum.Font.SourceSans

    fovValueLabel.TextXAlignment =
        Enum.TextXAlignment.Right

    fovValueLabel.Parent =
        visPage

    local fovSlider =
        Instance.new("TextButton")

    fovSlider.Name =
        "FovSlider"

    fovSlider.Size =
        UDim2.new(
            0,
            120,
            0,
            6
        )

    fovSlider.Position =
        UDim2.new(
            0,
            10,
            0,
            94
        )

    fovSlider.BackgroundColor3 =
        Color3.fromRGB(
            70,
            70,
            70
        )

    fovSlider.BorderSizePixel = 0
    fovSlider.Text = ""
    fovSlider.AutoButtonColor = false
    fovSlider.Parent =
        visPage

    local fovSliderCorner =
        Instance.new("UICorner")

    fovSliderCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    fovSliderCorner.Parent =
        fovSlider

    local fovFill =
        Instance.new("Frame")

    fovFill.Name =
        "Fill"

    local initialPercent =
        (
            fovValue - 10
        )
        /
        (
            120 - 10
        )

    fovFill.Size =
        UDim2.new(
            initialPercent,
            0,
            1,
            0
        )

    fovFill.BackgroundColor3 =
        Color3.fromRGB(
            100,
            160,
            220
        )

    fovFill.BorderSizePixel = 0
    fovFill.Parent =
        fovSlider

    local fovFillCorner =
        Instance.new("UICorner")

    fovFillCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    fovFillCorner.Parent =
        fovFill

    local fovKnob =
        Instance.new("Frame")

    fovKnob.Name =
        "Knob"

    fovKnob.Size =
        UDim2.new(
            0,
            12,
            0,
            12
        )

    fovKnob.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    fovKnob.Position =
        UDim2.new(
            initialPercent,
            0,
            0.5,
            0
        )

    fovKnob.BackgroundColor3 =
        Color3.fromRGB(
            220,
            220,
            220
        )

    fovKnob.BorderSizePixel = 0
    fovKnob.Parent =
        fovSlider

    local fovKnobCorner =
        Instance.new("UICorner")

    fovKnobCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    fovKnobCorner.Parent =
        fovKnob

    local fovDragging = false

    local function updateFov(
        inputX
    )

        local sliderX =
            fovSlider.AbsolutePosition.X

        local sliderWidth =
            fovSlider.AbsoluteSize.X

        local percent =
            (
                inputX
                - sliderX
            )
            /
            sliderWidth

        percent =
            math.clamp(
                percent,
                0,
                1
            )

        fovValue =
            math.floor(
                10
                + percent
                    * (
                        120 - 10
                    )
                + 0.5
            )

        fovValueLabel.Text =
            tostring(
                fovValue
            )

        fovFill.Size =
            UDim2.new(
                percent,
                0,
                1,
                0
            )

        fovKnob.Position =
            UDim2.new(
                percent,
                0,
                0.5,
                0
            )
    end

    addConnection(
        fovSlider.MouseButton1Down:Connect(
            function()

                fovDragging = true

                updateFov(
                    UserInputService:GetMouseLocation().X
                )

            end
        )
    )

    addConnection(
        UserInputService.InputChanged:Connect(
            function(input)

                if fovDragging
                    and input.UserInputType
                    == Enum.UserInputType.MouseMovement
                then

                    updateFov(
                        input.Position.X
                    )

                end

            end
        )
    )

    addConnection(
        UserInputService.InputEnded:Connect(
            function(input)

                if input.UserInputType
                    == Enum.UserInputType.MouseButton1
                then

                    fovDragging = false

                end

            end
        )
    )

    -- =====================================================
    -- ESP PLAYERS
    -- =====================================================

    local espLabel =
        Instance.new("TextLabel")

    espLabel.Name =
        "ESPPlayersLabel"

    espLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    espLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            108
        )

    espLabel.BackgroundTransparency = 1
    espLabel.Text = "ESP Players"

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

    espLabel.Parent =
        visPage

    local espToggle,
        espKnob =
        createToggle(
            visPage,
            114
        )

    setToggleVisual(
        espToggle,
        espKnob,
        espPlayersEnabled
    )

    addConnection(
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
    )

    -- =====================================================
    -- ESP FILL
    -- =====================================================

    local espFillLabel =
        Instance.new("TextLabel")

    espFillLabel.Name =
        "ESPFillLabel"

    espFillLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    espFillLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            139
        )

    espFillLabel.BackgroundTransparency = 1
    espFillLabel.Text = "ESP Fill"

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

    espFillLabel.Parent =
        visPage

    local espFillToggle,
        espFillKnob =
        createToggle(
            visPage,
            145
        )

    setToggleVisual(
        espFillToggle,
        espFillKnob,
        espFillEnabled
    )

    addConnection(
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
    )

    -- =====================================================
    -- ESP FILL COLOR
    -- =====================================================

    local espFillColorLabel =
        Instance.new("TextLabel")

    espFillColorLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    espFillColorLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            170
        )

    espFillColorLabel.BackgroundTransparency = 1
    espFillColorLabel.Text = "Fill Color"

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

    espFillColorLabel.Parent =
        visPage

    local espFillColorButton =
        Instance.new("TextButton")

    espFillColorButton.Name =
        "ESPFillColorButton"

    espFillColorButton.Size =
        UDim2.new(
            0,
            32,
            0,
            18
        )

    espFillColorButton.Position =
        UDim2.new(
            1,
            -88,
            0,
            176
        )

    espFillColorButton.BackgroundColor3 =
        espFillColor

    espFillColorButton.BorderSizePixel = 0
    espFillColorButton.Text = ""
    espFillColorButton.AutoButtonColor = false
    espFillColorButton.Parent =
        visPage

    local espFillColorCorner =
        Instance.new("UICorner")

    espFillColorCorner.CornerRadius =
        UDim.new(
            0,
            3
        )

    espFillColorCorner.Parent =
        espFillColorButton

    createColorPicker(
        visPage,
        espFillColorButton,
        espFillColor,
        function(color)

            espFillColor =
                color

            espFillColorButton.BackgroundColor3 =
                color

            updateESP()

        end
    )

    -- =====================================================
    -- ESP OUTLINE COLOR
    -- =====================================================

    local espOutlineColorLabel =
        Instance.new("TextLabel")

    espOutlineColorLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    espOutlineColorLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            201
        )

    espOutlineColorLabel.BackgroundTransparency = 1
    espOutlineColorLabel.Text = "Outline Color"

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

    espOutlineColorLabel.Parent =
        visPage

    local espOutlineColorButton =
        Instance.new("TextButton")

    espOutlineColorButton.Name =
        "ESPOutlineColorButton"

    espOutlineColorButton.Size =
        UDim2.new(
            0,
            32,
            0,
            18
        )

    espOutlineColorButton.Position =
        UDim2.new(
            1,
            -88,
            0,
            207
        )

    espOutlineColorButton.BackgroundColor3 =
        espOutlineColor

    espOutlineColorButton.BorderSizePixel = 0
    espOutlineColorButton.Text = ""
    espOutlineColorButton.AutoButtonColor = false
    espOutlineColorButton.Parent =
        visPage

    local espOutlineColorCorner =
        Instance.new("UICorner")

    espOutlineColorCorner.CornerRadius =
        UDim.new(
            0,
            3
        )

    espOutlineColorCorner.Parent =
        espOutlineColorButton

    createColorPicker(
        visPage,
        espOutlineColorButton,
        espOutlineColor,
        function(color)

            espOutlineColor =
                color

            espOutlineColorButton.BackgroundColor3 =
                color

            updateESP()

        end
    )

    -- =====================================================
    -- ESP KILLERS
    -- =====================================================

    local espKillerLabel =
        Instance.new("TextLabel")

    espKillerLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    espKillerLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            232
        )

    espKillerLabel.BackgroundTransparency = 1
    espKillerLabel.Text = "ESP Killers"

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

    espKillerLabel.Parent =
        visPage

    local espKillerToggle,
        espKillerKnob =
        createToggle(
            visPage,
            238
        )

    setToggleVisual(
        espKillerToggle,
        espKillerKnob,
        espKillerEnabled
    )

    addConnection(
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
    )

    -- =====================================================
    -- KILLER FILL
    -- =====================================================

    local espKillerFillLabel =
        Instance.new("TextLabel")

    espKillerFillLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    espKillerFillLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            263
        )

    espKillerFillLabel.BackgroundTransparency = 1
    espKillerFillLabel.Text = "Killer Fill"

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

    espKillerFillLabel.Parent =
        visPage

    local espKillerFillToggle,
        espKillerFillKnob =
        createToggle(
            visPage,
            269
        )

    setToggleVisual(
        espKillerFillToggle,
        espKillerFillKnob,
        espKillerFillEnabled
    )

    addConnection(
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
    )

    -- =====================================================
    -- KILLER FILL COLOR
    -- =====================================================

    local espKillerFillColorLabel =
        Instance.new("TextLabel")

    espKillerFillColorLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    espKillerFillColorLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            294
        )

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

    espKillerFillColorLabel.Parent =
        visPage

    local espKillerFillColorButton =
        Instance.new("TextButton")

    espKillerFillColorButton.Name =
        "ESPKillerFillColorButton"

    espKillerFillColorButton.Size =
        UDim2.new(
            0,
            32,
            0,
            18
        )

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
    espKillerFillColorButton.Parent =
        visPage

    local espKillerFillColorCorner =
        Instance.new("UICorner")

    espKillerFillColorCorner.CornerRadius =
        UDim.new(
            0,
            3
        )

    espKillerFillColorCorner.Parent =
        espKillerFillColorButton

    createColorPicker(
        visPage,
        espKillerFillColorButton,
        espKillerFillColor,
        function(color)

            espKillerFillColor =
                color

            espKillerFillColorButton.BackgroundColor3 =
                color

            updateKillerESP()

        end
    )

    -- =====================================================
    -- KILLER OUTLINE
    -- =====================================================

    local espKillerOutlineColorLabel =
        Instance.new("TextLabel")

    espKillerOutlineColorLabel.Size =
        UDim2.new(
            0,
            110,
            0,
            25
        )

    espKillerOutlineColorLabel.Position =
        UDim2.new(
            0,
            10,
            0,
            325
        )

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

    espKillerOutlineColorLabel.Parent =
        visPage

    local espKillerOutlineColorButton =
        Instance.new("TextButton")

    espKillerOutlineColorButton.Name =
        "ESPKillerOutlineColorButton"

    espKillerOutlineColorButton.Size =
        UDim2.new(
            0,
            32,
            0,
            18
        )

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
    espKillerOutlineColorButton.Parent =
        visPage

    local espKillerOutlineColorCorner =
        Instance.new("UICorner")

    espKillerOutlineColorCorner.CornerRadius =
        UDim.new(
            0,
            3
        )

    espKillerOutlineColorCorner.Parent =
        espKillerOutlineColorButton

    createColorPicker(
        visPage,
        espKillerOutlineColorButton,
        espKillerOutlineColor,
        function(color)

            espKillerOutlineColor =
                color

            espKillerOutlineColorButton.BackgroundColor3 =
                color

            updateKillerESP()

        end
    )

    -- =====================================================
    -- TRAJECTORY TOGGLE HANDLERS
    -- =====================================================

    addConnection(
        trajectoryToggle.MouseButton1Click:Connect(
            function()

                Vis.toggleTrajectory()

            end
        )
    )

    addConnection(
        trajectoryPlusToggle.MouseButton1Click:Connect(
            function()

                Vis.toggleTrajectoryPlus()

            end
        )
    )

    -- =====================================================
    -- HOTKEY BUTTON HANDLERS
    -- =====================================================

    addConnection(
        trajectoryKeyButton.MouseButton1Click:Connect(
            function()

                Vis.beginHotkey(
                    "Trajectory"
                )

            end
        )
    )

    addConnection(
        trajectoryPlusKeyButton.MouseButton1Click:Connect(
            function()

                Vis.beginHotkey(
                    "TrajectoryPlus"
                )

            end
        )
    )

end

-- =========================================================
-- TOGGLE FUNCTIONS
-- =========================================================

function Vis.setTrajectoryEnabled(
    enabled
)

    trajectoryEnabled =
        enabled

    if enabled then

        trajectoryPlusEnabled =
            false

        currentMode =
            "Trajectory"

        hideTrajectoryPlus()

    else

        if currentMode ==
            "Trajectory"
        then

            currentMode = nil

        end

        hideTrajectory()

    end

    if trajectoryToggle
        and trajectoryKnob
    then

        setToggleVisual(
            trajectoryToggle,
            trajectoryKnob,
            trajectoryEnabled
        )

    end

    if trajectoryPlusToggle
        and trajectoryPlusKnob
    then

        setToggleVisual(
            trajectoryPlusToggle,
            trajectoryPlusKnob,
            trajectoryPlusEnabled
        )

    end
end

function Vis.setTrajectoryPlusEnabled(
    enabled
)

    trajectoryPlusEnabled =
        enabled

    if enabled then

        trajectoryEnabled =
            false

        currentMode =
            "TrajectoryPlus"

        hideTrajectory()

    else

        if currentMode ==
            "TrajectoryPlus"
        then

            currentMode = nil

        end

        hideTrajectoryPlus()

    end

    if trajectoryToggle
        and trajectoryKnob
    then

        setToggleVisual(
            trajectoryToggle,
            trajectoryKnob,
            trajectoryEnabled
        )

    end

    if trajectoryPlusToggle
        and trajectoryPlusKnob
    then

        setToggleVisual(
            trajectoryPlusToggle,
            trajectoryPlusKnob,
            trajectoryPlusEnabled
        )

    end
end

function Vis.toggleTrajectory()

    Vis.setTrajectoryEnabled(
        not trajectoryEnabled
    )
end

function Vis.toggleTrajectoryPlus()

    Vis.setTrajectoryPlusEnabled(
        not trajectoryPlusEnabled
    )
end

-- =========================================================
-- HOTKEY API
-- =========================================================

function Vis.beginHotkey(
    feature
)

    waitingForHotkey =
        feature

    if feature ==
        "Trajectory"
    then

        if trajectoryKeyButton then
            trajectoryKeyButton.Text =
                "..."
        end

    elseif feature ==
        "TrajectoryPlus"
    then

        if trajectoryPlusKeyButton then
            trajectoryPlusKeyButton.Text =
                "..."
        end

    end
end

function Vis.assignHotkey(key)

    if not waitingForHotkey then
        return false
    end

    if key ==
        Enum.KeyCode.Escape
    then

        if waitingForHotkey ==
            "Trajectory"
        then

            if trajectoryKeyButton then
                trajectoryKeyButton.Text =
                    trajectoryHotkey.Name
            end

        elseif waitingForHotkey ==
            "TrajectoryPlus"
        then

            if trajectoryPlusKeyButton then
                trajectoryPlusKeyButton.Text =
                    trajectoryPlusHotkey.Name
            end

        end

        waitingForHotkey = nil

        return true
    end

    if waitingForHotkey ==
        "Trajectory"
    then

        trajectoryHotkey =
            key

        if trajectoryKeyButton then

            trajectoryKeyButton.Text =
                key.Name

        end

    elseif waitingForHotkey ==
        "TrajectoryPlus"
    then

        trajectoryPlusHotkey =
            key

        if trajectoryPlusKeyButton then

            trajectoryPlusKeyButton.Text =
                key.Name

        end

    end

    waitingForHotkey = nil

    return true
end

function Vis.handleKey(key)

    if waitingForHotkey then
        return false
    end

    if key ==
        trajectoryHotkey
    then

        Vis.toggleTrajectory()

        return true
    end

    if key ==
        trajectoryPlusHotkey
    then

        Vis.toggleTrajectoryPlus()

        return true
    end

    return false
end

-- =========================================================
-- RENDER
-- =========================================================

function Vis.render()

    if currentMode ==
        "Trajectory"
    then

        updateTrajectory()

    elseif currentMode ==
        "TrajectoryPlus"
    then

        updateTrajectoryPlus()

    end

end

-- =========================================================
-- DESTROY
-- =========================================================

function Vis.destroy()

    waitingForHotkey = nil

    trajectoryEnabled = false
    trajectoryPlusEnabled = false
    currentMode = nil

    hideTrajectory()
    hideTrajectoryPlus()

    disableESPPlayers()
    disableESPKillers()

    for plr in pairs(
        espCharacterConnections
    ) do

        cleanupCharacterMonitoring(
            plr
        )

    end

    for _, picker in ipairs(
        espPickerFrames
    ) do

        if picker then

            pcall(function()
                picker:Destroy()
            end)

        end

    end

    table.clear(
        espPickerFrames
    )

    table.clear(
        espPickerConnections
    )

    if fovConnection then

        disconnectConnection(
            fovConnection
        )

        fovConnection = nil

    end

    if espPlayerAddedConnection then

        disconnectConnection(
            espPlayerAddedConnection
        )

        espPlayerAddedConnection = nil

    end

    if espPlayerRemovingConnection then

        disconnectConnection(
            espPlayerRemovingConnection
        )

        espPlayerRemovingConnection = nil

    end

    for _, segment in ipairs(
        segmentsTrajectory
    ) do

        pcall(function()
            segment:Destroy()
        end)

    end

    table.clear(
        segmentsTrajectory
    )

    for _, segment in ipairs(
        segmentsTrajectoryPlus
    ) do

        pcall(function()
            segment:Destroy()
        end)

    end

    table.clear(
        segmentsTrajectoryPlus
    )

    pcall(function()
        impactSphereTrajectory:Destroy()
    end)

    pcall(function()
        impactSphereTrajectoryPlus:Destroy()
    end)

    pcall(function()
        anchorPart:Destroy()
    end)

    if trajectoryFolder then

        pcall(function()
            trajectoryFolder:Destroy()
        end)

    end

    disconnectAll()

    visPage = nil
    createToggle = nil
    setToggleVisual = nil

    trajectoryKeyButton = nil
    trajectoryPlusKeyButton = nil

    trajectoryToggle = nil
    trajectoryPlusToggle = nil

    trajectoryKnob = nil
    trajectoryPlusKnob = nil
end

return Vis
