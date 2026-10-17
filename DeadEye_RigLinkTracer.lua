-- DeadEye Rig Link Tracer v1.00
-- Standalone, READ-ONLY diagnostic. Does not modify game Instances or call game remotes.
-- F6 = FULL STOP + COPY LOG
-- F7 = PAUSE / RESUME CAPTURE
-- External stop: getgenv().DeadEyeRigLinkTracerStop = true
-- Version rule for completed revisions: increment only digits after the dot; keep major v1.

local SCRIPT_VERSION = "1.00"
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Env = _G
pcall(function()
    if type(getgenv) == "function" then
        Env = getgenv()
    end
end)

-- Stop a previous copy of this standalone tracer before installing a new one.
pcall(function()
    if type(Env.DeadEyeRigLinkTracerStopNow) == "function" then
        Env.DeadEyeRigLinkTracerStopNow("restarted")
    end
end)

local ACTIVE = true
local CAPTURE_ENABLED = true
local STOPPING = false
local START_TIME = os.clock()
local MAX_LOG_LINES = 9000
local LOG = {}
local CONNECTIONS = {}
local INSTANCE_IDS = setmetatable({}, {__mode = "k"})
local MODEL_STATE = setmetatable({}, {__mode = "k"})
local DESCRIPTION_STATE = setmetatable({}, {__mode = "k"})
local DESCRIPTION_ERROR_LOGGED = setmetatable({}, {__mode = "k"})
local BOUND_MODELS = setmetatable({}, {__mode = "k"})
local BOUND_INSTANCES = setmetatable({}, {__mode = "k"})
local BOUND_OBJECT_VALUES = setmetatable({}, {__mode = "k"})
local BOUND_ANIMATORS = setmetatable({}, {__mode = "k"})
local NEXT_INSTANCE_ID = 0
local LOG_LIMIT_REACHED = false

Env.DeadEyeRigLinkTracerStop = false
Env.DEADEYE_RIG_LINK_TRACE_LOG = ""
Env.DEADEYE_RIG_LINK_TRACE_VERSION = SCRIPT_VERSION

local function clean(value)
    local s = tostring(value)
    s = string.gsub(s, "[\r\n\t]", " ")
    s = string.gsub(s, "|", "/")
    if #s > 420 then
        s = string.sub(s, 1, 417) .. "..."
    end
    return s
end

local function pathOf(instance)
    if not instance then
        return "<nil>"
    end
    local ok, result = pcall(function()
        return instance:GetFullName()
    end)
    if ok and result then
        return result
    end
    return "<unavailable:" .. clean(instance.Name) .. ">"
end

local function idOf(instance)
    if not instance then
        return "-"
    end
    local id = INSTANCE_IDS[instance]
    if not id then
        NEXT_INSTANCE_ID += 1
        id = NEXT_INSTANCE_ID
        INSTANCE_IDS[instance] = id
    end
    return "I" .. tostring(id)
end

local function appendLine(line, force)
    if not ACTIVE and not force then
        return
    end
    if not CAPTURE_ENABLED and not force then
        return
    end

    if #LOG >= MAX_LOG_LINES then
        if not LOG_LIMIT_REACHED then
            LOG_LIMIT_REACHED = true
            table.insert(LOG, "[RigTrace " .. SCRIPT_VERSION .. "] LOG_LIMIT_REACHED|max=" .. tostring(MAX_LOG_LINES))
            Env.DEADEYE_RIG_LINK_TRACE_LOG = table.concat(LOG, "\n")
        end
        return
    end

    table.insert(LOG, line)
    Env.DEADEYE_RIG_LINK_TRACE_LOG = table.concat(LOG, "\n")
end

local function cleanLogDetail(value)
    local s = tostring(value or "")
    s = string.gsub(s, "[\\r\\n\\t]", " ")
    s = string.gsub(s, "|", "/")
    if #s > 12000 then
        s = string.sub(s, 1, 11970) .. "...[DETAIL_TRUNCATED]"
    end
    return s
end

local function log(eventName, detail, force)
    local line = string.format(
        "[RigTrace %s +%.3fs] %s|%s",
        SCRIPT_VERSION,
        os.clock() - START_TIME,
        clean(eventName),
        cleanLogDetail(detail or "")
    )
    appendLine(line, force)
end

local function connect(signal, callback)
    local ok, connection = pcall(function()
        return signal:Connect(callback)
    end)
    if ok and connection then
        table.insert(CONNECTIONS, connection)
        return connection
    end
    return nil
end

local function under(instance, root)
    if not instance or not root then
        return false
    end
    if instance == root then
        return true
    end
    local ok, result = pcall(function()
        return instance:IsDescendantOf(root)
    end)
    return ok and result == true
end

local function getWorkspaceRoot(name)
    return Workspace:FindFirstChild(name)
end

local function localCacheFolder()
    local cache = getWorkspaceRoot("PlayerCache")
    return cache and cache:FindFirstChild(LocalPlayer.Name) or nil
end

local function getDomain(instance)
    if not instance then
        return "Outside"
    end

    local rigs = getWorkspaceRoot("Rigs")
    if under(instance, rigs) then
        return "Workspace.Rigs"
    end

    local players = getWorkspaceRoot("Players")
    if under(instance, players) then
        return "Workspace.Players"
    end

    local cache = getWorkspaceRoot("PlayerCache")
    if under(instance, cache) then
        if under(instance, localCacheFolder()) then
            return "Workspace.PlayerCache.LOCAL"
        end
        return "Workspace.PlayerCache.OTHER"
    end

    local menu = getWorkspaceRoot("MenuScene")
    if under(instance, menu) then
        return "Workspace.MenuScene"
    end

    if instance == LocalPlayer.Character
        or (instance:IsA("Model") and instance.Name == LocalPlayer.Name and instance.Parent == Workspace)
    then
        return "Workspace.LocalCharacter"
    end

    if under(instance, Workspace) then
        return "Workspace.OTHER"
    end

    return "Outside"
end

local function isTraceModel(model)
    if not model or not model:IsA("Model") or not model.Parent then
        return false
    end
    local domain = getDomain(model)
    return domain == "Workspace.Rigs"
        or domain == "Workspace.Players"
        or domain == "Workspace.PlayerCache.LOCAL"
        or domain == "Workspace.MenuScene"
        or domain == "Workspace.LocalCharacter"
end

local function isDetailedModel(model)
    if not model then
        return false
    end
    if model.Name == LocalPlayer.Name then
        return true
    end
    if model.Name == "VisualModel" and getDomain(model) == "Workspace.MenuScene" then
        return true
    end
    if getDomain(model) == "Workspace.PlayerCache.LOCAL" then
        return true
    end
    return false
end

local function detailedModelFor(instance)
    local node = instance
    while node and node ~= game do
        if node:IsA("Model") and isDetailedModel(node) then
            return node
        end
        node = node.Parent
    end
    return nil
end

local function modelFor(instance)
    local node = instance
    while node and node ~= game do
        if node:IsA("Model") and isTraceModel(node) then
            return node
        end
        node = node.Parent
    end
    return nil
end

local function classCounts(model)
    local counts = {
        descendants = 0,
        parts = 0,
        meshParts = 0,
        humanoids = 0,
        animationControllers = 0,
        animators = 0,
        accessories = 0,
        attachments = 0,
        joints = 0,
        motor6d = 0,
        welds = 0,
        constraints = 0,
        objectValues = 0,
        particleEmitters = 0,
        beams = 0,
        trails = 0,
        lights = 0,
        highlights = 0,
        decalsTextures = 0,
        sounds = 0,
        scripts = 0
    }

    local ok, descendants = pcall(function()
        return model:GetDescendants()
    end)
    if not ok or not descendants then
        return counts
    end

    counts.descendants = #descendants
    for _, object in ipairs(descendants) do
        if object:IsA("BasePart") then counts.parts += 1 end
        if object:IsA("MeshPart") then counts.meshParts += 1 end
        if object:IsA("Humanoid") then counts.humanoids += 1 end
        if object:IsA("AnimationController") then counts.animationControllers += 1 end
        if object:IsA("Animator") then counts.animators += 1 end
        if object:IsA("Accessory") then counts.accessories += 1 end
        if object:IsA("Attachment") then counts.attachments += 1 end
        if object:IsA("JointInstance") then counts.joints += 1 end
        if object:IsA("Motor6D") then counts.motor6d += 1 end
        if object:IsA("Weld") or object:IsA("WeldConstraint") then counts.welds += 1 end
        if object:IsA("Constraint") then counts.constraints += 1 end
        if object:IsA("ObjectValue") then counts.objectValues += 1 end
        if object:IsA("ParticleEmitter") then counts.particleEmitters += 1 end
        if object:IsA("Beam") then counts.beams += 1 end
        if object:IsA("Trail") then counts.trails += 1 end
        if object:IsA("PointLight") or object:IsA("SpotLight") or object:IsA("SurfaceLight") then counts.lights += 1 end
        if object:IsA("Highlight") then counts.highlights += 1 end
        if object:IsA("Decal") or object:IsA("Texture") then counts.decalsTextures += 1 end
        if object:IsA("Sound") then counts.sounds += 1 end
        if object:IsA("Script") or object:IsA("LocalScript") or object:IsA("ModuleScript") then counts.scripts += 1 end
    end
    return counts
end

local function attributesOf(instance)
    local ok, attributes = pcall(function()
        return instance:GetAttributes()
    end)
    if not ok or type(attributes) ~= "table" then
        return "{}"
    end

    local keys = {}
    for key in pairs(attributes) do
        table.insert(keys, tostring(key))
    end
    table.sort(keys)

    local parts = {}
    for i, key in ipairs(keys) do
        if i > 24 then
            table.insert(parts, "...")
            break
        end
        table.insert(parts, clean(key) .. "=" .. clean(attributes[key]))
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

local function directChildrenOf(model)
    local names = {}
    for _, child in ipairs(model:GetChildren()) do
        table.insert(names, child.Name .. ":" .. child.ClassName)
    end
    table.sort(names)
    if #names > 45 then
        local trimmed = {}
        for i = 1, 45 do trimmed[i] = names[i] end
        table.insert(trimmed, "...")
        names = trimmed
    end
    return table.concat(names, ",")
end

local function referenceLabel(instance)
    if not instance then
        return "<nil>"
    end
    return idOf(instance) .. ":" .. pathOf(instance)
end

local function linkSummary(model)
    local links = {}
    local ok, descendants = pcall(function()
        return model:GetDescendants()
    end)
    if not ok or not descendants then
        return "unavailable"
    end

    for _, object in ipairs(descendants) do
        local line
        if object:IsA("JointInstance") then
            line = object.ClassName .. ":" .. object.Name
                .. "|P0=" .. referenceLabel(object.Part0)
                .. "|P1=" .. referenceLabel(object.Part1)
        elseif object:IsA("WeldConstraint") then
            line = "WeldConstraint:" .. object.Name
                .. "|P0=" .. referenceLabel(object.Part0)
                .. "|P1=" .. referenceLabel(object.Part1)
        elseif object:IsA("Constraint") then
            local a0, a1
            pcall(function() a0 = object.Attachment0 end)
            pcall(function() a1 = object.Attachment1 end)
            if a0 or a1 then
                line = object.ClassName .. ":" .. object.Name
                    .. "|A0=" .. referenceLabel(a0)
                    .. "|A1=" .. referenceLabel(a1)
            end
        end

        if line then
            table.insert(links, line)
            if #links >= 55 then
                table.insert(links, "...TRUNCATED")
                break
            end
        end
    end
    if #links == 0 then
        return "none"
    end
    return table.concat(links, " ; ")
end

local DESCRIPTION_FIELDS = {
    "Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "Face",
    "Shirt", "Pants", "GraphicTShirt",
    "HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory",
    "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory",
    "BodyTypeScale", "DepthScale", "HeadScale", "HeightScale", "ProportionScale", "WidthScale",
    "HeadColor", "TorsoColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor",
    "IdleAnimation", "WalkAnimation", "RunAnimation", "JumpAnimation", "FallAnimation",
    "ClimbAnimation", "SwimAnimation", "MoodAnimation"
}

local function readDescription(humanoid)
    local ok, description = pcall(function()
        return humanoid:GetAppliedDescription()
    end)
    if not ok or not description then
        return nil, "GetAppliedDescription failed: " .. clean(description)
    end

    local values = {}
    for _, property in ipairs(DESCRIPTION_FIELDS) do
        local readOK, value = pcall(function()
            return description[property]
        end)
        if readOK and value ~= nil then
            values[property] = tostring(value)
        end
    end
    pcall(function() description:Destroy() end)
    return values, nil
end

local function descriptionSignature(values)
    if not values then
        return "<nil>"
    end
    local keys = {}
    for key in pairs(values) do table.insert(keys, key) end
    table.sort(keys)
    local pieces = {}
    for _, key in ipairs(keys) do
        table.insert(pieces, key .. "=" .. values[key])
    end
    return table.concat(pieces, ";")
end

local function changedDescriptionFields(oldValues, newValues)
    local changed = {}
    oldValues = oldValues or {}
    newValues = newValues or {}
    for _, property in ipairs(DESCRIPTION_FIELDS) do
        if oldValues[property] ~= newValues[property] then
            table.insert(changed, property .. ":" .. clean(oldValues[property]) .. "->" .. clean(newValues[property]))
        end
    end
    return #changed > 0 and table.concat(changed, ",") or "none"
end

local function snapshotModel(model, reason)
    if not model or not model.Parent then
        return
    end

    local counts = classCounts(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local primaryPart = model.PrimaryPart
    local rigType = "-"
    local displayName = "-"
    local hipHeight = "-"
    if humanoid then
        pcall(function() rigType = tostring(humanoid.RigType) end)
        pcall(function() displayName = humanoid.DisplayName end)
        pcall(function() hipHeight = tostring(humanoid.HipHeight) end)
    end

    local countText = string.format(
        "desc=%d|parts=%d|mesh=%d|hum=%d|animator=%d|accessories=%d|attachments=%d|joints=%d|motor6d=%d|welds=%d|constraints=%d|objectValues=%d|emitters=%d|beams=%d|trails=%d|lights=%d|highlights=%d|decalsTextures=%d|sounds=%d|scripts=%d",
        counts.descendants, counts.parts, counts.meshParts, counts.humanoids,
        counts.animators, counts.accessories, counts.attachments, counts.joints,
        counts.motor6d, counts.welds, counts.constraints, counts.objectValues,
        counts.particleEmitters, counts.beams, counts.trails, counts.lights,
        counts.highlights, counts.decalsTextures, counts.sounds, counts.scripts
    )

    log("MODEL_SNAPSHOT",
        "event=" .. clean(reason)
        .. "|id=" .. idOf(model)
        .. "|name=" .. clean(model.Name)
        .. "|domain=" .. getDomain(model)
        .. "|path=" .. pathOf(model)
        .. "|parent=" .. pathOf(model.Parent)
        .. "|primary=" .. referenceLabel(primaryPart)
        .. "|rigType=" .. clean(rigType)
        .. "|displayName=" .. clean(displayName)
        .. "|hipHeight=" .. clean(hipHeight)
        .. "|attributes=" .. attributesOf(model)
        .. "|" .. countText
        .. "|directChildren={" .. directChildrenOf(model) .. "}"
    )

    if isDetailedModel(model) then
        log("MODEL_LINK_GRAPH", "id=" .. idOf(model) .. "|path=" .. pathOf(model) .. "|links={" .. linkSummary(model) .. "}")
    end
end

local function modelStateSignature(model)
    local counts = classCounts(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local rigType, displayName, hipHeight = "-", "-", "-"
    if humanoid then
        pcall(function() rigType = tostring(humanoid.RigType) end)
        pcall(function() displayName = humanoid.DisplayName end)
        pcall(function() hipHeight = tostring(humanoid.HipHeight) end)
    end
    return table.concat({
        tostring(counts.descendants), tostring(counts.parts), tostring(counts.meshParts),
        tostring(counts.humanoids), tostring(counts.accessories), tostring(counts.attachments),
        tostring(counts.joints), tostring(counts.motor6d), tostring(counts.welds),
        tostring(counts.particleEmitters), tostring(counts.beams), tostring(counts.trails),
        tostring(counts.lights), tostring(counts.highlights), tostring(counts.decalsTextures),
        tostring(model.PrimaryPart), rigType, displayName, hipHeight, directChildrenOf(model)
    }, "|")
end

local function isEffectObject(object)
    return object:IsA("Accessory")
        or object:IsA("Attachment")
        or object:IsA("ParticleEmitter")
        or object:IsA("Beam")
        or object:IsA("Trail")
        or object:IsA("PointLight")
        or object:IsA("SpotLight")
        or object:IsA("SurfaceLight")
        or object:IsA("Highlight")
        or object:IsA("Decal")
        or object:IsA("Texture")
        or object:IsA("SpecialMesh")
        or object:IsA("Motor6D")
        or object:IsA("Weld")
        or object:IsA("WeldConstraint")
        or object:IsA("Humanoid")
        or object:IsA("Animator")
        or object:IsA("AnimationController")
        or object:IsA("ObjectValue")
end

local function isBodyPart(object, model)
    if not object:IsA("BasePart") then
        return false
    end
    local name = object.Name
    return name == "HumanoidRootPart" or name == "Head" or name == "Torso"
        or name == "Left Arm" or name == "Right Arm" or name == "Left Leg" or name == "Right Leg"
        or name == "UpperTorso" or name == "LowerTorso"
        or name == "LeftUpperArm" or name == "LeftLowerArm" or name == "LeftHand"
        or name == "RightUpperArm" or name == "RightLowerArm" or name == "RightHand"
        or name == "LeftUpperLeg" or name == "LeftLowerLeg" or name == "LeftFoot"
        or name == "RightUpperLeg" or name == "RightLowerLeg" or name == "RightFoot"
end

local function objectPayload(object)
    local extras = ""
    if object:IsA("MeshPart") then
        extras = "|meshId=" .. clean(object.MeshId)
            .. "|textureId=" .. clean(object.TextureID)
            .. "|size=" .. clean(object.Size)
            .. "|transparency=" .. clean(object.Transparency)
            .. "|localTransparency=" .. clean(object.LocalTransparencyModifier)
            .. "|anchored=" .. tostring(object.Anchored)
    elseif object:IsA("BasePart") then
        extras = "|size=" .. clean(object.Size)
            .. "|transparency=" .. clean(object.Transparency)
            .. "|localTransparency=" .. clean(object.LocalTransparencyModifier)
            .. "|anchored=" .. tostring(object.Anchored)
    elseif object:IsA("ParticleEmitter") then
        extras = "|enabled=" .. tostring(object.Enabled)
            .. "|rate=" .. clean(object.Rate)
            .. "|texture=" .. clean(object.Texture)
    elseif object:IsA("Beam") or object:IsA("Trail") then
        extras = "|enabled=" .. tostring(object.Enabled)
            .. "|texture=" .. clean(object.Texture)
            .. "|a0=" .. referenceLabel(object.Attachment0)
            .. "|a1=" .. referenceLabel(object.Attachment1)
    elseif object:IsA("Decal") or object:IsA("Texture") then
        extras = "|texture=" .. clean(object.Texture)
            .. "|transparency=" .. clean(object.Transparency)
    elseif object:IsA("PointLight") or object:IsA("SpotLight") or object:IsA("SurfaceLight") then
        extras = "|enabled=" .. tostring(object.Enabled)
            .. "|brightness=" .. clean(object.Brightness)
    elseif object:IsA("Highlight") then
        extras = "|enabled=" .. tostring(object.Enabled)
            .. "|depthMode=" .. clean(object.DepthMode)
    elseif object:IsA("Animation") then
        extras = "|animationId=" .. clean(object.AnimationId)
    elseif object:IsA("SpecialMesh") then
        extras = "|meshId=" .. clean(object.MeshId)
            .. "|textureId=" .. clean(object.TextureId)
    elseif object:IsA("Accessory") then
        extras = "|handle=" .. referenceLabel(object:FindFirstChild("Handle"))
    elseif object:IsA("Humanoid") then
        extras = "|rigType=" .. clean(object.RigType)
            .. "|health=" .. clean(object.Health)
            .. "|walkSpeed=" .. clean(object.WalkSpeed)
            .. "|hipHeight=" .. clean(object.HipHeight)
    elseif object:IsA("ObjectValue") then
        extras = "|value=" .. referenceLabel(object.Value)
    end
    return extras
end

local function watchObjectValue(object)
    if BOUND_OBJECT_VALUES[object] then
        return
    end
    BOUND_OBJECT_VALUES[object] = true
    local lastValue = object.Value

    local function shouldReport(value)
        if value == nil then return false end
        return modelFor(value) ~= nil
            or (value:IsA("Model") and (value.Name == LocalPlayer.Name or value.Name == "VisualModel"))
    end

    if shouldReport(lastValue) then
        log("OBJECT_VALUE_BASELINE",
            "object=" .. pathOf(object) .. "|id=" .. idOf(object)
            .. "|value=" .. referenceLabel(lastValue)
        )
    end

    pcall(function()
        connect(object:GetPropertyChangedSignal("Value"), function()
            if not ACTIVE then return end
            local newValue = object.Value
            if shouldReport(lastValue) or shouldReport(newValue) then
                log("OBJECT_VALUE_CHANGED",
                    "object=" .. pathOf(object) .. "|id=" .. idOf(object)
                    .. "|old=" .. referenceLabel(lastValue)
                    .. "|new=" .. referenceLabel(newValue)
                )
            end
            lastValue = newValue
        end)
    end)
end

local function watchAnimator(animator)
    if BOUND_ANIMATORS[animator] then
        return
    end
    local owner = modelFor(animator)
    if not owner then
        return
    end
    BOUND_ANIMATORS[animator] = true

    local function describeTrack(track)
        local animationId, animationName = "<none>", "<none>"
        pcall(function()
            if track.Animation then
                animationId = track.Animation.AnimationId
                animationName = track.Animation.Name
            end
        end)
        local priority, looped, timePosition = "-", "-", "-"
        pcall(function() priority = tostring(track.Priority) end)
        pcall(function() looped = tostring(track.Looped) end)
        pcall(function() timePosition = tostring(track.TimePosition) end)
        return "track=" .. idOf(track)
            .. "|animationName=" .. clean(animationName)
            .. "|animationId=" .. clean(animationId)
            .. "|priority=" .. clean(priority)
            .. "|looped=" .. clean(looped)
            .. "|timePosition=" .. clean(timePosition)
    end

    log("ANIMATOR_FOUND", "animator=" .. pathOf(animator) .. "|id=" .. idOf(animator)
        .. "|owner=" .. idOf(owner) .. ":" .. pathOf(owner))

    local ok, tracks = pcall(function()
        return animator:GetPlayingAnimationTracks()
    end)
    if ok and tracks then
        for _, track in ipairs(tracks) do
            log("ANIMATION_ALREADY_PLAYING", "owner=" .. pathOf(owner) .. "|" .. describeTrack(track))
        end
    end

    connect(animator.AnimationPlayed, function(track)
        if not ACTIVE then return end
        log("ANIMATION_PLAYED", "owner=" .. pathOf(owner) .. "|animator=" .. pathOf(animator) .. "|" .. describeTrack(track))
        connect(track.Stopped, function()
            if ACTIVE then
                log("ANIMATION_STOPPED", "owner=" .. pathOf(owner) .. "|animator=" .. pathOf(animator) .. "|" .. describeTrack(track))
            end
        end)
    end)
end

local function watchInstance(object, ownerModel)
    if not object or BOUND_INSTANCES[object] then
        if object and object:IsA("ObjectValue") then watchObjectValue(object) end
        if object and object:IsA("Animator") then watchAnimator(object) end
        return
    end

    ownerModel = ownerModel or modelFor(object)
    if not ownerModel then
        if object:IsA("ObjectValue") then watchObjectValue(object) end
        return
    end

    BOUND_INSTANCES[object] = true
    if object:IsA("ObjectValue") then watchObjectValue(object) end
    if object:IsA("Animator") then watchAnimator(object) end

    if isDetailedModel(ownerModel) and isEffectObject(object) then
        log("INSTANCE_PRESENT",
            "owner=" .. idOf(ownerModel) .. ":" .. pathOf(ownerModel)
            .. "|object=" .. idOf(object) .. ":" .. pathOf(object)
            .. "|class=" .. object.ClassName .. objectPayload(object)
        )
    end

    local refProperties = {}
    if object:IsA("JointInstance") or object:IsA("WeldConstraint") then
        refProperties = {"Part0", "Part1"}
    elseif object:IsA("Constraint") then
        refProperties = {"Attachment0", "Attachment1"}
    elseif object:IsA("Beam") or object:IsA("Trail") then
        refProperties = {"Attachment0", "Attachment1"}
    elseif object:IsA("ObjectValue") then
        refProperties = {"Value"}
    elseif object:IsA("BillboardGui") or object:IsA("SurfaceGui") then
        refProperties = {"Adornee"}
    end

    for _, property in ipairs(refProperties) do
        local oldValue
        pcall(function() oldValue = object[property] end)
        pcall(function()
            connect(object:GetPropertyChangedSignal(property), function()
                if not ACTIVE then return end
                local newValue
                pcall(function() newValue = object[property] end)
                log("INSTANCE_REFERENCE_CHANGED",
                    "owner=" .. idOf(ownerModel) .. ":" .. pathOf(ownerModel)
                    .. "|object=" .. idOf(object) .. ":" .. pathOf(object)
                    .. "|class=" .. object.ClassName .. "|property=" .. property
                    .. "|old=" .. referenceLabel(oldValue)
                    .. "|new=" .. referenceLabel(newValue)
                )
                oldValue = newValue
            end)
        end)
    end

    local watchedProperties = {}
    if object:IsA("ParticleEmitter") then
        watchedProperties = {"Enabled", "Texture", "Rate"}
    elseif object:IsA("Beam") or object:IsA("Trail") then
        watchedProperties = {"Enabled", "Texture"}
    elseif object:IsA("PointLight") or object:IsA("SpotLight") or object:IsA("SurfaceLight") then
        watchedProperties = {"Enabled", "Brightness"}
    elseif object:IsA("Highlight") then
        watchedProperties = {"Enabled", "DepthMode"}
    elseif object:IsA("Decal") or object:IsA("Texture") then
        watchedProperties = {"Texture", "Transparency"}
    elseif object:IsA("BasePart") and isDetailedModel(ownerModel) and isBodyPart(object, ownerModel) then
        watchedProperties = {"Transparency", "LocalTransparencyModifier", "Size"}
    elseif object:IsA("Humanoid") then
        watchedProperties = {"RigType", "DisplayName", "HipHeight", "WalkSpeed", "JumpHeight", "JumpPower"}
    elseif object:IsA("Animation") then
        watchedProperties = {"AnimationId"}
    end

    for _, property in ipairs(watchedProperties) do
        local oldValue
        pcall(function() oldValue = object[property] end)
        pcall(function()
            connect(object:GetPropertyChangedSignal(property), function()
                if not ACTIVE then return end
                local newValue
                pcall(function() newValue = object[property] end)
                log("INSTANCE_PROPERTY_CHANGED",
                    "owner=" .. idOf(ownerModel) .. ":" .. pathOf(ownerModel)
                    .. "|object=" .. idOf(object) .. ":" .. pathOf(object)
                    .. "|class=" .. object.ClassName
                    .. "|property=" .. property
                    .. "|old=" .. clean(oldValue)
                    .. "|new=" .. clean(newValue)
                )
                oldValue = newValue
            end)
        end)
    end
end

local function bindModel(model, reason)
    if not isTraceModel(model) or BOUND_MODELS[model] then
        return
    end

    BOUND_MODELS[model] = true
    do
        connect(model.AncestryChanged, function(_, newParent)
            if ACTIVE then
                log("MODEL_ANCESTRY_CHANGED",
                    "id=" .. idOf(model) .. "|name=" .. clean(model.Name)
                    .. "|newParent=" .. pathOf(newParent)
                    .. "|pathNow=" .. pathOf(model)
                    .. "|domainNow=" .. getDomain(model)
                )
            end
        end)
        connect(model:GetPropertyChangedSignal("Name"), function()
            if ACTIVE then
                log("MODEL_NAME_CHANGED", "id=" .. idOf(model) .. "|nameNow=" .. clean(model.Name) .. "|pathNow=" .. pathOf(model))
            end
        end)
        connect(model:GetPropertyChangedSignal("PrimaryPart"), function()
            if ACTIVE then
                log("MODEL_PRIMARY_PART_CHANGED", "id=" .. idOf(model) .. "|primaryNow=" .. referenceLabel(model.PrimaryPart) .. "|path=" .. pathOf(model))
            end
        end)
        connect(model.AttributeChanged, function(attributeName)
            if ACTIVE then
                log("MODEL_ATTRIBUTE_CHANGED", "id=" .. idOf(model) .. "|path=" .. pathOf(model)
                    .. "|attribute=" .. clean(attributeName) .. "|value=" .. clean(model:GetAttribute(attributeName)))
            end
        end)
    end

    local state = modelStateSignature(model)
    MODEL_STATE[model] = state
    snapshotModel(model, reason or "first-seen")

    local descendants = {}
    pcall(function() descendants = model:GetDescendants() end)
    for _, object in ipairs(descendants) do
        watchInstance(object, detailedModelFor(object) or modelFor(object) or model)
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid and DESCRIPTION_STATE[humanoid] == nil then
        local values, err = readDescription(humanoid)
        if values then
            DESCRIPTION_STATE[humanoid] = values
            log("DESCRIPTION_BASELINE", "model=" .. idOf(model) .. ":" .. pathOf(model)
                .. "|humanoid=" .. pathOf(humanoid) .. "|fields={" .. descriptionSignature(values) .. "}")
        else
            log("DESCRIPTION_READ_ERROR", "model=" .. pathOf(model) .. "|humanoid=" .. pathOf(humanoid) .. "|error=" .. clean(err))
        end
    end
end

local function logInstanceAdded(object)
    local owner = modelFor(object)
    local detailOwner = detailedModelFor(object)
    if not owner and not detailOwner then
        if object:IsA("ObjectValue") then watchObjectValue(object) end
        return
    end

    watchInstance(object, detailOwner or owner)
    if object:IsA("Model") and isTraceModel(object) then
        bindModel(object, "DescendantAdded")
        if detailOwner and detailOwner ~= object then
            log("MODEL_NESTED_ADDED", "owner=" .. idOf(detailOwner) .. ":" .. pathOf(detailOwner)
                .. "|nested=" .. idOf(object) .. ":" .. pathOf(object) .. "|domain=" .. getDomain(object))
        end
    elseif detailOwner then
        log("INSTANCE_ADDED",
            "owner=" .. idOf(detailOwner) .. ":" .. pathOf(detailOwner)
            .. "|object=" .. idOf(object) .. ":" .. pathOf(object)
            .. "|class=" .. object.ClassName
            .. objectPayload(object)
        )
    elseif owner and isEffectObject(object) then
        log("INSTANCE_ADDED", "owner=" .. idOf(owner) .. ":" .. pathOf(owner)
            .. "|object=" .. idOf(object) .. ":" .. pathOf(object)
            .. "|class=" .. object.ClassName .. objectPayload(object))
    end
end

local function logInstanceRemoving(object)
    local owner = modelFor(object)
    local detailOwner = detailedModelFor(object)
    if not owner and not detailOwner then return end
    if object:IsA("Model") and isTraceModel(object) then
        snapshotModel(object, "before-remove")
        log("MODEL_REMOVING", "id=" .. idOf(object) .. "|name=" .. clean(object.Name)
            .. "|oldPath=" .. pathOf(object) .. "|oldDomain=" .. getDomain(object))
    elseif detailOwner then
        log("INSTANCE_REMOVING",
            "owner=" .. idOf(detailOwner) .. ":" .. pathOf(detailOwner)
            .. "|object=" .. idOf(object) .. ":" .. pathOf(object)
            .. "|class=" .. object.ClassName
            .. objectPayload(object)
        )
    elseif owner and isEffectObject(object) then
        log("INSTANCE_REMOVING", "owner=" .. idOf(owner) .. ":" .. pathOf(owner)
            .. "|object=" .. idOf(object) .. ":" .. pathOf(object)
            .. "|class=" .. object.ClassName .. objectPayload(object))
    end
end

local function countModels(root)
    if not root then return 0, {} end
    local count = 0
    local names = {}
    if root:IsA("Model") then
        count += 1
        table.insert(names, idOf(root) .. ":" .. root.Name)
    end
    local ok, descendants = pcall(function() return root:GetDescendants() end)
    if ok and descendants then
        for _, object in ipairs(descendants) do
            if object:IsA("Model") then
                count += 1
                table.insert(names, idOf(object) .. ":" .. object.Name)
            end
        end
    end
    table.sort(names)
    return count, names
end

local function directModelCount(root)
    if not root then return 0, {} end
    local count = 0
    local names = {}
    for _, child in ipairs(root:GetChildren()) do
        if child:IsA("Model") then
            count += 1
            table.insert(names, idOf(child) .. ":" .. child.Name)
        end
    end
    table.sort(names)
    return count, names
end

local function compactNames(names, limit)
    local out = {}
    for i = 1, math.min(#names, limit or 35) do
        out[i] = names[i]
    end
    if #names > (limit or 35) then
        table.insert(out, "...+" .. tostring(#names - (limit or 35)))
    end
    return table.concat(out, ",")
end

local function worldSnapshot(reason)
    local totalModels, allNames = countModels(Workspace)
    local rigs = getWorkspaceRoot("Rigs")
    local players = getWorkspaceRoot("Players")
    local cache = getWorkspaceRoot("PlayerCache")
    local menu = getWorkspaceRoot("MenuScene")
    local localCache = localCacheFolder()
    local visual = menu and menu:FindFirstChild("VisualModel")
    local localCharacter = LocalPlayer.Character

    local rigsDirect, rigsNames = directModelCount(rigs)
    local rigsAll, rigsAllNames = countModels(rigs)
    local playersDirect, playersNames = directModelCount(players)
    local playersAll, playersAllNames = countModels(players)
    local cacheAll, cacheNames = countModels(cache)
    local localCacheAll, localCacheNames = countModels(localCache)
    local menuAll, menuNames = countModels(menu)

    local signature = table.concat({
        tostring(totalModels), tostring(rigsDirect), compactNames(rigsNames, 100),
        tostring(playersDirect), compactNames(playersNames, 100),
        tostring(cacheAll), compactNames(localCacheNames, 100),
        tostring(menuAll), compactNames(menuNames, 100),
        pathOf(localCharacter), pathOf(visual)
    }, "|")

    log("WORLD_SNAPSHOT",
        "reason=" .. clean(reason)
        .. "|workspaceModels=" .. totalModels
        .. "|workspaceModelIds={" .. compactNames(allNames, 60) .. "}"
        .. "|RigsDirect=" .. rigsDirect .. "|RigsAll=" .. rigsAll
        .. "|RigsDirectModels={" .. compactNames(rigsNames, 80) .. "}"
        .. "|RigsAllModels={" .. compactNames(rigsAllNames, 80) .. "}"
        .. "|PlayersDirect=" .. playersDirect .. "|PlayersAll=" .. playersAll
        .. "|PlayersDirectModels={" .. compactNames(playersNames, 80) .. "}"
        .. "|PlayersAllModels={" .. compactNames(playersAllNames, 80) .. "}"
        .. "|PlayerCacheAllModels=" .. cacheAll
        .. "|PlayerCacheModelPaths={" .. compactNames(cacheNames, 50) .. "}"
        .. "|LocalCacheModels=" .. localCacheAll
        .. "|LocalCacheModelPaths={" .. compactNames(localCacheNames, 50) .. "}"
        .. "|MenuSceneModels=" .. menuAll
        .. "|MenuSceneModelPaths={" .. compactNames(menuNames, 60) .. "}"
        .. "|LocalCharacter=" .. referenceLabel(localCharacter)
        .. "|MenuVisualModel=" .. referenceLabel(visual)
    )

    if signature ~= worldSnapshot.lastSignature then
        worldSnapshot.lastSignature = signature
        log("WORLD_TOPOLOGY_CHANGED", "reason=" .. clean(reason) .. "|signature=" .. signature)
    end
end

local function scanWorkspace(reason)
    local ok, descendants = pcall(function()
        return Workspace:GetDescendants()
    end)
    if not ok or not descendants then
        log("SCAN_ERROR", "Workspace:GetDescendants failed|reason=" .. clean(reason))
        return
    end

    for _, object in ipairs(descendants) do
        if object:IsA("Model") and isTraceModel(object) then
            bindModel(object, reason)
        elseif object:IsA("ObjectValue") then
            watchObjectValue(object)
        else
            local owner = modelFor(object)
            if owner then
                watchInstance(object, owner)
            end
        end
    end

    if LocalPlayer.Character and isTraceModel(LocalPlayer.Character) then
        bindModel(LocalPlayer.Character, "LocalPlayer.Character")
    end

    local menu = getWorkspaceRoot("MenuScene")
    local visual = menu and menu:FindFirstChild("VisualModel")
    if visual and visual:IsA("Model") then
        bindModel(visual, "MenuScene.VisualModel")
    end
end

local function pollDescriptions()
    local toPoll = {}
    local seen = {}

    local function addHumanoid(model)
        if not model or not model.Parent or not isTraceModel(model) then
            return
        end
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Parent and not seen[humanoid] then
            seen[humanoid] = true
            table.insert(toPoll, {model = model, humanoid = humanoid})
        end
    end

    -- Poll local models in every known live representation; other players are only counted.
    local rigs = getWorkspaceRoot("Rigs")
    local players = getWorkspaceRoot("Players")
    local cache = localCacheFolder()
    local menu = getWorkspaceRoot("MenuScene")

    if rigs then
        for _, model in ipairs(rigs:GetChildren()) do
            if model:IsA("Model") and model.Name == LocalPlayer.Name then addHumanoid(model) end
        end
    end
    if players then
        for _, model in ipairs(players:GetChildren()) do
            if model:IsA("Model") and model.Name == LocalPlayer.Name then addHumanoid(model) end
        end
    end
    if cache then
        for _, model in ipairs(cache:GetDescendants()) do
            if model:IsA("Model") then addHumanoid(model) end
        end
    end
    if menu then
        for _, model in ipairs(menu:GetDescendants()) do
            if model:IsA("Model") and (model.Name == "VisualModel" or model.Name == LocalPlayer.Name) then
                addHumanoid(model)
            end
        end
    end
    addHumanoid(LocalPlayer.Character)

    for _, entry in ipairs(toPoll) do
        local values, err = readDescription(entry.humanoid)
        if values then
            local oldValues = DESCRIPTION_STATE[entry.humanoid]
            if oldValues == nil then
                DESCRIPTION_STATE[entry.humanoid] = values
                log("DESCRIPTION_BASELINE", "model=" .. idOf(entry.model) .. ":" .. pathOf(entry.model)
                    .. "|humanoid=" .. pathOf(entry.humanoid) .. "|fields={" .. descriptionSignature(values) .. "}")
            elseif descriptionSignature(oldValues) ~= descriptionSignature(values) then
                log("DESCRIPTION_CHANGED",
                    "model=" .. idOf(entry.model) .. ":" .. pathOf(entry.model)
                    .. "|humanoid=" .. pathOf(entry.humanoid)
                    .. "|changed={" .. changedDescriptionFields(oldValues, values) .. "}"
                    .. "|newFields={" .. descriptionSignature(values) .. "}"
                )
                DESCRIPTION_STATE[entry.humanoid] = values
                DESCRIPTION_ERROR_LOGGED[entry.humanoid] = nil
            end
        elseif not DESCRIPTION_ERROR_LOGGED[entry.humanoid] then
            DESCRIPTION_ERROR_LOGGED[entry.humanoid] = true
            log("DESCRIPTION_READ_ERROR", "model=" .. pathOf(entry.model) .. "|error=" .. clean(err))
        end
    end
end

local function stopTracer(reason)
    if STOPPING then return end
    STOPPING = true

    log("STOP_REQUESTED", "reason=" .. clean(reason), true)
    ACTIVE = false
    CAPTURE_ENABLED = false
    Env.DeadEyeRigLinkTracerStop = true

    for _, connection in ipairs(CONNECTIONS) do
        pcall(function() connection:Disconnect() end)
    end
    CONNECTIONS = {}

    local finalText = table.concat(LOG, "\n")
    Env.DEADEYE_RIG_LINK_TRACE_LOG = finalText
    Env.DeadEyeRigLinkTracerStopNow = nil

    local copied = false
    pcall(function()
        if type(setclipboard) == "function" then
            setclipboard(finalText)
            copied = true
        end
    end)
    if copied then
        print("[RigTrace " .. SCRIPT_VERSION .. "] STOPPED; full log copied to clipboard. Lines=" .. tostring(#LOG))
    else
        print("[RigTrace " .. SCRIPT_VERSION .. "] STOPPED; clipboard API unavailable. Read getgenv().DEADEYE_RIG_LINK_TRACE_LOG. Lines=" .. tostring(#LOG))
    end
end

Env.DeadEyeRigLinkTracerStopNow = stopTracer

log("BOOT", "version=" .. SCRIPT_VERSION
    .. "|mode=READ_ONLY"
    .. "|player=" .. LocalPlayer.Name
    .. "|controls=F6 stop+copy; F7 pause/resume"
    .. "|observedRoots=Workspace.Rigs,Workspace.Players,Workspace.PlayerCache.LOCAL,Workspace.MenuScene,LocalPlayer.Character")
log("LIMITATION", "This traces live Instance relationships/properties/animations. It cannot introspect arbitrary Lua closure tables or private local variables; no functions/remotes are hooked.")

-- Initial index before connecting future events.
scanWorkspace("initial-scan")
worldSnapshot("initial")
local gameDescendantsOK, gameDescendants = pcall(function()
    return game:GetDescendants()
end)
if gameDescendantsOK and gameDescendants then
    local objectValueCount = 0
    for _, object in ipairs(gameDescendants) do
        if object:IsA("ObjectValue") then
            watchObjectValue(object)
            objectValueCount += 1
        end
    end
    log("INITIAL_REFERENCE_SCAN", "gameDescendants=" .. #gameDescendants .. "|ObjectValuesWatched=" .. objectValueCount)
else
    log("INITIAL_REFERENCE_SCAN_ERROR", "game:GetDescendants failed")
end

connect(game.DescendantAdded, function(object)
    if not ACTIVE then return end
    if object:IsA("ObjectValue") then
        watchObjectValue(object)
    end
    if object:IsA("Model") and isTraceModel(object) then
        bindModel(object, "global DescendantAdded")
        log("MODEL_CREATED_OR_ENTERED", "id=" .. idOf(object) .. "|name=" .. clean(object.Name)
            .. "|domain=" .. getDomain(object) .. "|path=" .. pathOf(object)
            .. "|parent=" .. pathOf(object.Parent))
        return
    end
    logInstanceAdded(object)
end)

connect(game.DescendantRemoving, function(object)
    if not ACTIVE then return end
    logInstanceRemoving(object)
end)

connect(LocalPlayer:GetPropertyChangedSignal("Character"), function()
    if ACTIVE then
        log("LOCALPLAYER_CHARACTER_PROPERTY",
            "newCharacter=" .. referenceLabel(LocalPlayer.Character)
            .. "|path=" .. pathOf(LocalPlayer.Character))
        if LocalPlayer.Character then
            task.defer(function()
                if ACTIVE then bindModel(LocalPlayer.Character, "LocalPlayer.Character property changed") end
            end)
        end
    end
end)

connect(LocalPlayer.CharacterAdded, function(character)
    log("LOCAL_CHARACTER_ADDED", "id=" .. idOf(character) .. "|path=" .. pathOf(character) .. "|parent=" .. pathOf(character.Parent))
    task.defer(function()
        if ACTIVE then bindModel(character, "CharacterAdded") end
    end)
end)

connect(LocalPlayer.CharacterRemoving, function(character)
    log("LOCAL_CHARACTER_REMOVING", "id=" .. idOf(character) .. "|path=" .. pathOf(character) .. "|parent=" .. pathOf(character.Parent))
end)

connect(UserInputService.InputBegan, function(input)
    if input.KeyCode == Enum.KeyCode.F6 then
        stopTracer("F6")
    elseif input.KeyCode == Enum.KeyCode.F7 and ACTIVE then
        CAPTURE_ENABLED = not CAPTURE_ENABLED
        if CAPTURE_ENABLED then
            log("CAPTURE_RESUMED", "F7")
            scanWorkspace("resume")
            worldSnapshot("resume")
        else
            log("CAPTURE_PAUSED", "F7", true)
        end
    end
end)

task.spawn(function()
    local lastWorldSnapshot = 0
    local lastDescriptionPoll = 0
    local lastWorkspaceScan = 0

    while ACTIVE do
        if Env.DeadEyeRigLinkTracerStop == true then
            stopTracer("external flag DeadEyeRigLinkTracerStop=true")
            break
        end

        local now = os.clock()
        if now - lastWorkspaceScan >= 4.0 then
            lastWorkspaceScan = now
            scanWorkspace("periodic")
        end
        if now - lastDescriptionPoll >= 1.25 then
            lastDescriptionPoll = now
            pollDescriptions()
        end
        if now - lastWorldSnapshot >= 2.5 then
            lastWorldSnapshot = now
            worldSnapshot("periodic")
        end
        task.wait(0.25)
    end
end)

print("[RigTrace " .. SCRIPT_VERSION .. "] ACTIVE: read-only model/link/description/animation tracing")
print("[RigTrace " .. SCRIPT_VERSION .. "] F6 = FULL STOP + COPY LOG | F7 = PAUSE/RESUME")
print("[RigTrace " .. SCRIPT_VERSION .. "] External stop: getgenv().DeadEyeRigLinkTracerStop = true")
