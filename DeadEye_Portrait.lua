--// DeadEye Portrait module
--// Standalone chunk. Same implementation as the original in DeadEye.lua.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local genv = getgenv and getgenv() or _G

--// LOCAL PORTRAIT OVERRIDE
--// =========================================================

local portrait = {
    state = {},
    connections = {},
    watched = {},
    rigSignature = "",
    refreshQueued = false,
    cachedRig = nil,
    cachedCharacter = nil
}

function portrait.getRig()

    local character = LocalPlayer.Character
    local rigs = workspace:FindFirstChild("Rigs")
    local namedRig = rigs and rigs:FindFirstChild(LocalPlayer.Name)

    if portrait.cachedRig
        and portrait.cachedCharacter == character
        and portrait.cachedRig.Parent
        and (not namedRig or namedRig == portrait.cachedRig)
    then
        return portrait.cachedRig
    end

    local serviceRig

    local serviceOK, characterObject = pcall(function()
        local characterService = require(
            game:GetService("ReplicatedStorage")
                :WaitForChild("Services")
                :WaitForChild("Asset")
                :WaitForChild("CharacterService")
        )

        return characterService:GetLocalCharacter()
    end)

    if serviceOK and characterObject and characterObject.Rig then
        local rigOK, result = pcall(function()
            return characterObject.Rig:GetRigModel()
        end)

        if rigOK
            and result
            and result:IsA("Model")
        then
            serviceRig = result
        end
    end

    local selected = serviceRig or namedRig

    if not selected
        and character
        and character:IsA("Model")
    then
        selected = character
    end

    if selected and selected:IsA("Model") then
        portrait.cachedRig = selected
        portrait.cachedCharacter = character
        return selected
    end

    portrait.cachedRig = nil
    portrait.cachedCharacter = character
    return nil

end

function portrait.isOwn(image)

    if type(image) ~= "string" then
        return false
    end

    if not string.find(string.lower(image), "avatarheadshot", 1, true) then
        return false
    end

    local id = string.match(image, "id=(%d+)")

    return id == tostring(LocalPlayer.UserId)

end

function portrait.visible(source)

    local p = source

    while p do

        if p:IsA("GuiObject") and not p.Visible then
            return false
        end

        if p:IsA("LayerCollector") and not p.Enabled then
            return false
        end

        p = p.Parent

    end

    return true

end

function portrait.cloneRig(source)

    local viewport = Instance.new("ViewportFrame")

    viewport.Name = "DeadEyePortraitViewport"
    viewport.BackgroundTransparency = 1
    viewport.BorderSizePixel = 0
    viewport.Size = source.Size
    viewport.Position = source.Position
    viewport.AnchorPoint = source.AnchorPoint
    viewport.Rotation = source.Rotation
    viewport.ZIndex = source.ZIndex + 1
    viewport.Visible = source.Visible

    local camera = Instance.new("Camera")
    camera.Name = "DeadEyePortraitCamera"
    camera.FieldOfView = 18
    camera.Parent = viewport
    viewport.CurrentCamera = camera

    local world = Instance.new("WorldModel")
    world.Name = "DeadEyePortraitWorld"
    world.Parent = viewport

    local rig = portrait.getRig()

    if not rig then
        viewport:Destroy()
        return nil
    end

    local clone

    if not pcall(function()
        clone = rig:Clone()
    end) or not clone then
        viewport:Destroy()
        return nil
    end

    clone.Name = "DeadEyePortraitRig"
    clone.Parent = world

    for _, obj in ipairs(clone:GetDescendants()) do

        if obj:IsA("Script")
            or obj:IsA("LocalScript")
            or obj:IsA("ModuleScript")
        then
            pcall(function()
                obj:Destroy()
            end)
        elseif obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")
            or obj:IsA("Smoke")
            or obj:IsA("Fire")
            or obj:IsA("Sparkles")
            or obj:IsA("PointLight")
            or obj:IsA("SpotLight")
            or obj:IsA("SurfaceLight")
        then
            pcall(function()
                obj.Enabled = false
            end)
        elseif obj:IsA("BasePart") then
            obj.Anchored = true
            obj.CanCollide = false
            obj.CanTouch = false
            obj.CanQuery = false
        end

    end

    local head = clone:FindFirstChild("Head", true)

    if not head or not head:IsA("BasePart") then
        viewport:Destroy()
        return nil
    end

    local pivotOK, pivotError = pcall(function()
        clone:PivotTo(
            CFrame.new(-head.Position) * clone:GetPivot()
        )
    end)

    if not pivotOK then
        warn("[DeadEye Portrait] Rig pivot failed: " .. tostring(pivotError))
        viewport:Destroy()
        return nil
    end

    local headPosition = head.Position
    local headForward = head.CFrame.LookVector
    local focus = headPosition + Vector3.new(0, head.Size.Y * 0.08, 0)
    local distance = math.max(3, head.Size.Y * 4)

    viewport.Ambient = Color3.fromRGB(200, 200, 200)
    viewport.LightColor = Color3.fromRGB(255, 255, 255)
    viewport.LightDirection = Vector3.new(-1, -1, -1)

    camera.CFrame = CFrame.lookAt(
        focus + headForward * distance,
        focus
    )

    return viewport

end

function portrait.sync(source)

    local state = portrait.state[source]

    if not state or not state.viewport or not state.viewport.Parent or not source.Parent then
        return
    end

    local viewport = state.viewport

    viewport.Size = source.Size
    viewport.Position = source.Position
    viewport.AnchorPoint = source.AnchorPoint
    viewport.Rotation = source.Rotation
    viewport.ZIndex = source.ZIndex + 1
    viewport.Visible = source.Visible and portrait.visible(source)

    if source.ImageTransparency ~= 1 then
        source.ImageTransparency = 1
    end

    if source:IsA("ImageButton") then
        if source.HoverImage ~= "" then source.HoverImage = "" end
        if source.PressedImage ~= "" then source.PressedImage = "" end
        if source.DisabledImage ~= "" then source.DisabledImage = "" end
    end

end

function portrait.remove(source)

    local state = portrait.state[source]

    if not state then
        return
    end

    if state.viewport then
        pcall(function()
            state.viewport:Destroy()
        end)
    end

    pcall(function()
        if source.Parent then
            source.Visible = state.visible
            source.ImageTransparency = state.transparency

            if source:IsA("ImageButton") then
                source.HoverImage = state.hover
                source.PressedImage = state.pressed
                source.DisabledImage = state.disabled
            end
        end
    end)

    portrait.state[source] = nil

end

function portrait.apply(source)

    if not source or not source.Parent then
        return
    end

    if not portrait.isOwn(source.Image) then
        portrait.remove(source)
        return
    end

    local state = portrait.state[source]

    if state and state.viewport and state.viewport.Parent then
        state.visible = source.Visible
        portrait.sync(source)
        return
    end

    local viewport = portrait.cloneRig(source)

    if not viewport then
        return
    end

    state = state or {
        transparency = source.ImageTransparency,
        hover = source:IsA("ImageButton") and source.HoverImage or "",
        pressed = source:IsA("ImageButton") and source.PressedImage or "",
        disabled = source:IsA("ImageButton") and source.DisabledImage or "",
        visible = source.Visible
    }

    state.visible = source.Visible
    state.viewport = viewport
    portrait.state[source] = state

    viewport.Parent = source.Parent
    portrait.sync(source)

end

function portrait.watch(source)

    if not (
        source:IsA("ImageLabel")
        or source:IsA("ImageButton")
    ) then
        return
    end

    if portrait.watched[source] then
        return
    end

    portrait.watched[source] = true

    table.insert(
        portrait.connections,
        source:GetPropertyChangedSignal("Image"):Connect(function()
            if genv.DEADEYE_PORTRAIT_RUNNING then
                portrait.apply(source)
            end
        end)
    )

    table.insert(
        portrait.connections,
        source:GetPropertyChangedSignal("Visible"):Connect(function()
            local state = portrait.state[source]

            if state and state.viewport then
                state.visible = source.Visible
                portrait.sync(source)
            end
        end)
    )

    for _, property in ipairs({
        "ImageTransparency",
        "ZIndex",
        "Size",
        "Position",
        "AnchorPoint",
        "Rotation"
    }) do
        table.insert(
            portrait.connections,
            source:GetPropertyChangedSignal(property):Connect(function()
                if genv.DEADEYE_PORTRAIT_RUNNING then
                    portrait.sync(source)
                end
            end)
        )
    end

    if source:IsA("ImageButton") then
        for _, property in ipairs({"HoverImage", "PressedImage", "DisabledImage"}) do
            table.insert(
                portrait.connections,
                source:GetPropertyChangedSignal(property):Connect(function()
                    if genv.DEADEYE_PORTRAIT_RUNNING then
                        portrait.sync(source)
                    end
                end)
            )
        end
    end

    table.insert(
        portrait.connections,
        source.AncestryChanged:Connect(function(_, parent)
            local state = portrait.state[source]
            if state and state.viewport and parent then
                state.viewport.Parent = parent
                portrait.sync(source)
            end
        end)
    )

    portrait.apply(source)

end

function portrait.signature()

    local rig = portrait.getRig()

    if not rig then
        return ""
    end

    local s = ""

    for _, obj in ipairs(rig:GetDescendants()) do

        if obj:IsA("Shirt") then
            s = s .. "S" .. obj.ShirtTemplate
        elseif obj:IsA("Pants") then
            s = s .. "P" .. obj.PantsTemplate
        elseif obj:IsA("BodyColors") then
            s = s
                .. "B"
                .. tostring(obj.HeadColor3)
                .. tostring(obj.LeftArmColor3)
                .. tostring(obj.RightArmColor3)
                .. tostring(obj.LeftLegColor3)
                .. tostring(obj.RightLegColor3)
                .. tostring(obj.TorsoColor3)
        elseif obj:IsA("MeshPart") then
            s = s
                .. "M"
                .. obj.Name
                .. tostring(obj.MeshId)
                .. tostring(obj.TextureID)
        elseif obj:IsA("SpecialMesh") then
            s = s
                .. "X"
                .. obj.Name
                .. tostring(obj.MeshId)
                .. tostring(obj.TextureId)
        elseif obj:IsA("Accessory") then
            s = s .. "A" .. obj.Name
        end

    end

    return s

end

function portrait.refresh()

    for source, state in pairs(portrait.state) do

        if source.Parent and state.viewport then
            pcall(function()
                state.viewport:Destroy()
            end)
            state.viewport = nil
        end

    end

    for _, obj in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do

        if obj:IsA("ImageLabel")
            or obj:IsA("ImageButton")
        then

            if portrait.isOwn(obj.Image) then
                portrait.apply(obj)
            end

        end

    end

end

function portrait.start()

    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local matched = 0
    local visibleMatches = 0

    for _, obj in ipairs(playerGui:GetDescendants()) do
        if (obj:IsA("ImageLabel") or obj:IsA("ImageButton"))
            and portrait.isOwn(obj.Image)
        then
            matched += 1
            if obj.Visible then
                visibleMatches += 1
            end
        end

        portrait.watch(obj)
    end

    local rig = portrait.getRig()
    print(
        "[DeadEye Portrait] Started | own thumbnails="
        .. tostring(matched)
        .. " | visible="
        .. tostring(visibleMatches)
        .. " | rig="
        .. tostring(rig and rig:GetFullName() or "NOT FOUND")
    )

    table.insert(
        portrait.connections,
        playerGui.DescendantAdded:Connect(function(obj)
            if genv.DEADEYE_PORTRAIT_RUNNING then
                portrait.watch(obj)
            end
        end)
    )

    table.insert(
        portrait.connections,
        RunService.Heartbeat:Connect(function()

            if not genv.DEADEYE_PORTRAIT_RUNNING then
                return
            end

            local signature = portrait.signature()

            if signature ~= portrait.rigSignature then
                portrait.rigSignature = signature

                if not portrait.refreshQueued then
                    portrait.refreshQueued = true

                    task.defer(function()
                        portrait.refreshQueued = false

                        if genv.DEADEYE_PORTRAIT_RUNNING then
                            portrait.refresh()
                        end
                    end)
                end
            end

        end)
    )

    portrait.rigSignature =
        portrait.signature()

end

function portrait.cleanup()

    genv.DEADEYE_PORTRAIT_RUNNING = false

    for _, connection in ipairs(portrait.connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(portrait.connections)
    table.clear(portrait.watched)

    for source, _ in pairs(portrait.state) do
        portrait.remove(source)
    end

    table.clear(portrait.state)

    portrait.rigSignature = ""
    portrait.refreshQueued = false
    portrait.cachedRig = nil
    portrait.cachedCharacter = nil

end

genv.DEADEYE_PORTRAIT_CLEANUP = portrait.cleanup

portrait.start()

return portrait
