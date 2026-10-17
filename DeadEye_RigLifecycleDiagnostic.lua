-- DeadEye Rig Lifecycle Diagnostic v1.00
-- Purpose: identify which character Model instance is present in menu vs round.
-- Read-only diagnostic: does not clone, move, hide, or modify game Instances.
-- F6 = FULL STOP + COPY LOG
-- External stop: getgenv().DeadEyeRigLifecycleDiagStop = true

local SCRIPT_VERSION = "1.00"
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local GENV = _G
pcall(function()
    if type(getgenv) == "function" then
        GENV = getgenv()
    end
end)

local LOG = {}
local CONNECTIONS = {}
local ACTIVE = true
local STOPPING = false
local NEXT_INSTANCE_ID = 0
local INSTANCE_IDS = setmetatable({}, { __mode = "k" })
local LAST_SNAPSHOT = nil
local startedAt = os.clock()

GENV.DeadEyeRigLifecycleDiagStop = false
GENV.DEADEYE_RIG_LIFECYCLE_LOG = ""

local function safeFullName(instance)
    if not instance then
        return "<nil>"
    end
    local name = "<unavailable>"
    pcall(function()
        name = instance:GetFullName()
    end)
    return name
end

local function instanceId(instance)
    if not instance then
        return "-"
    end
    local id = INSTANCE_IDS[instance]
    if not id then
        NEXT_INSTANCE_ID += 1
        id = NEXT_INSTANCE_ID
        INSTANCE_IDS[instance] = id
    end
    return tostring(id)
end

local function log(message)
    if not ACTIVE then
        return
    end
    local line = string.format(
        "[RigLife %s +%.3fs] %s",
        SCRIPT_VERSION,
        os.clock() - startedAt,
        tostring(message)
    )
    table.insert(LOG, line)
    GENV.DEADEYE_RIG_LIFECYCLE_LOG = table.concat(LOG, "\n")
    pcall(print, line)
end

local function addConnection(connection)
    if connection then
        table.insert(CONNECTIONS, connection)
    end
    return connection
end

local function isDescendantOf(instance, ancestor)
    if not instance or not ancestor then
        return false
    end
    local ok, result = pcall(function()
        return instance == ancestor or instance:IsDescendantOf(ancestor)
    end)
    return ok and result
end

local function getRoot(name)
    return Workspace:FindFirstChild(name)
end

local function getNamedChild(parent, name)
    if not parent then
        return nil
    end
    return parent:FindFirstChild(name)
end

local function summarizeModel(model, label)
    if not model then
        return label .. "=<nil>"
    end

    local descendants = {}
    local ok = pcall(function()
        descendants = model:GetDescendants()
    end)

    local humanoid = false
    local rootPart = false
    local baseParts = 0
    local attachments = 0
    local emitters = 0

    pcall(function()
        humanoid = model:FindFirstChildOfClass("Humanoid") ~= nil
        rootPart = model:FindFirstChild("HumanoidRootPart", true) ~= nil
        for _, item in ipairs(descendants) do
            if item:IsA("BasePart") then
                baseParts += 1
            elseif item:IsA("Attachment") then
                attachments += 1
            elseif item:IsA("ParticleEmitter") then
                emitters += 1
            end
        end
    end)

    return string.format(
        "%s=#%s:%s{class=%s,d=%s,bp=%s,att=%s,pe=%s,humanoid=%s,hrp=%s,parent=%s}",
        label,
        instanceId(model),
        safeFullName(model),
        model.ClassName,
        ok and tostring(#descendants) or "?",
        tostring(baseParts),
        tostring(attachments),
        tostring(emitters),
        tostring(humanoid),
        tostring(rootPart),
        safeFullName(model.Parent)
    )
end

local function addUniqueCandidate(list, seen, model, label)
    if not model or not model:IsA("Model") or seen[model] then
        return
    end
    seen[model] = true
    table.insert(list, { model = model, label = label })
end

local function collectCandidates()
    local candidates = {}
    local seen = {}
    local rigRoot = getRoot("Rigs")
    local playersRoot = getRoot("Players")
    local menuView = getRoot("MenuView")

    local rigModel = getNamedChild(rigRoot, LocalPlayer.Name)
    local playerModel = getNamedChild(playersRoot, LocalPlayer.Name)

    addUniqueCandidate(candidates, seen, rigModel, "RIGS_LOCAL")
    addUniqueCandidate(candidates, seen, playerModel, "PLAYERS_LOCAL")
    addUniqueCandidate(candidates, seen, LocalPlayer.Character, "LOCAL_PLAYER_CHARACTER")

    if menuView then
        addUniqueCandidate(candidates, seen, menuView:IsA("Model") and menuView or nil, "MENU_VIEW_MODEL")

        local visualModel = menuView:FindFirstChild("VisualModel")
        addUniqueCandidate(candidates, seen, visualModel, "MENU_VISUALMODEL")

        local ok, descendants = pcall(function()
            return menuView:GetDescendants()
        end)
        if ok then
            for _, item in ipairs(descendants) do
                if item:IsA("Model") and item.Name == LocalPlayer.Name then
                    addUniqueCandidate(candidates, seen, item, "MENU_PLAYER_NAMED_MODEL")
                elseif item:IsA("Model") and item:FindFirstChildOfClass("Humanoid") then
                    addUniqueCandidate(candidates, seen, item, "MENU_MODEL_WITH_HUMANOID")
                end
            end
        end
    end

    -- Catch player-named models placed somewhere other than the known folders.
    local ok, descendants = pcall(function()
        return Workspace:GetDescendants()
    end)
    if ok then
        for _, item in ipairs(descendants) do
            if item:IsA("Model") and item.Name == LocalPlayer.Name then
                local label = "OTHER_WORKSPACE_PLAYER_MODEL"
                if isDescendantOf(item, rigRoot) then
                    label = "WORKSPACE_RIGS_MATCH"
                elseif isDescendantOf(item, playersRoot) then
                    label = "WORKSPACE_PLAYERS_MATCH"
                elseif isDescendantOf(item, menuView) then
                    label = "MENU_PLAYER_MATCH"
                end
                addUniqueCandidate(candidates, seen, item, label)
            end
        end
    end

    return candidates, rigRoot, playersRoot, menuView, rigModel, playerModel
end

local function buildSnapshot()
    local candidates, rigRoot, playersRoot, menuView, rigModel, playerModel = collectCandidates()
    local pieces = {
        "roots={Rigs=" .. tostring(rigRoot ~= nil)
            .. ",Players=" .. tostring(playersRoot ~= nil)
            .. ",MenuView=" .. tostring(menuView ~= nil)
            .. ",PlayersLocal=" .. tostring(playerModel ~= nil)
            .. ",RigsLocal=" .. tostring(rigModel ~= nil) .. "}"
    }

    for _, entry in ipairs(candidates) do
        table.insert(pieces, summarizeModel(entry.model, entry.label))
    end

    if #candidates == 0 then
        table.insert(pieces, "NO_CANDIDATE_MODELS_FOUND")
    end

    return table.concat(pieces, " || ")
end

local function safeTraceObject(kind, object)
    if not ACTIVE or not object then
        return
    end

    local localName = LocalPlayer.Name
    local relevant = false
    local label = ""

    pcall(function()
        local rigs = getRoot("Rigs")
        local playersRoot = getRoot("Players")
        local menuView = getRoot("MenuView")

        if object == rigs or object == playersRoot or object == menuView then
            relevant = true
            label = "ROOT"
        elseif object:IsA("Model") and object.Name == localName then
            relevant = true
            label = "PLAYER_NAMED_MODEL"
        elseif object:IsA("Model") and object.Name == "VisualModel" and isDescendantOf(object, menuView) then
            relevant = true
            label = "MENU_VISUALMODEL"
        elseif object.Parent == rigs or object.Parent == playersRoot then
            relevant = true
            label = "DIRECT_CHILD_OF_RIGS_OR_PLAYERS"
        elseif object.Parent == menuView then
            relevant = true
            label = "DIRECT_CHILD_OF_MENUVIEW"
        elseif object:IsA("Humanoid") or object.Name == "HumanoidRootPart" then
            local ancestor = object.Parent
            while ancestor and ancestor ~= Workspace do
                if ancestor:IsA("Model") and (
                    ancestor.Name == localName
                    or ancestor.Name == "VisualModel"
                    or isDescendantOf(ancestor, menuView)
                ) then
                    relevant = true
                    label = object:IsA("Humanoid") and "HUMANOID_INSIDE_CANDIDATE" or "HRP_INSIDE_CANDIDATE"
                    break
                end
                ancestor = ancestor.Parent
            end
        end
    end)

    if relevant then
        log("INSTANCE_" .. kind
            .. "|tag=" .. label
            .. "|id=" .. instanceId(object)
            .. "|class=" .. tostring(object.ClassName)
            .. "|name=" .. tostring(object.Name)
            .. "|path=" .. safeFullName(object)
            .. "|parent=" .. safeFullName(object.Parent))
    end
end

log("BOOT|version=" .. SCRIPT_VERSION .. "|player=" .. LocalPlayer.Name .. "|readOnly=true")
log("INITIAL|" .. buildSnapshot())

addConnection(Workspace.DescendantAdded:Connect(function(object)
    safeTraceObject("ADDED", object)
end))

addConnection(Workspace.DescendantRemoving:Connect(function(object)
    safeTraceObject("REMOVING", object)
end))

addConnection(Workspace.ChildAdded:Connect(function(object)
    log("WORKSPACE_CHILD_ADDED|id=" .. instanceId(object)
        .. "|class=" .. tostring(object.ClassName)
        .. "|name=" .. tostring(object.Name)
        .. "|path=" .. safeFullName(object))
end))

addConnection(Workspace.ChildRemoved:Connect(function(object)
    log("WORKSPACE_CHILD_REMOVED|id=" .. instanceId(object)
        .. "|class=" .. tostring(object.ClassName)
        .. "|name=" .. tostring(object.Name)
        .. "|oldPath=" .. safeFullName(object))
end))

addConnection(LocalPlayer.CharacterAdded:Connect(function(character)
    log("LOCAL_CHARACTER_ADDED|" .. summarizeModel(character, "Character"))
end))

addConnection(LocalPlayer.CharacterRemoving:Connect(function(character)
    log("LOCAL_CHARACTER_REMOVING|" .. summarizeModel(character, "Character"))
end))

addConnection(UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.F6 then
        if STOPPING then
            return
        end
        STOPPING = true
        log("F6|FULL_STOP_AND_COPY")
        for _, connection in ipairs(CONNECTIONS) do
            pcall(function()
                connection:Disconnect()
            end)
        end

        local output = table.concat(LOG, "\n")
        GENV.DEADEYE_RIG_LIFECYCLE_LOG = output

        local clipboard = nil
        pcall(function()
            clipboard = GENV.setclipboard or GENV.toclipboard or GENV.writeclipboard
        end)
        if type(clipboard) ~= "function" then
            pcall(function()
                clipboard = setclipboard or toclipboard or writeclipboard
            end)
        end

        local copied = false
        if type(clipboard) == "function" then
            copied = pcall(clipboard, output)
        end
        if copied then
            pcall(print, "[RigLife " .. SCRIPT_VERSION .. "] Copied log to clipboard.")
        else
            pcall(warn, "[RigLife " .. SCRIPT_VERSION .. "] Clipboard unavailable; log saved in getgenv().DEADEYE_RIG_LIFECYCLE_LOG")
        end

        ACTIVE = false
    end
end))

-- A low-frequency state snapshot catches changes even if an engine event was missed.
task.spawn(function()
    while ACTIVE and not STOPPING do
        task.wait(0.75)

        if GENV.DeadEyeRigLifecycleDiagStop == true then
            if not STOPPING then
                STOPPING = true
                log("EXTERNAL_STOP|DeadEyeRigLifecycleDiagStop=true")
                local output = table.concat(LOG, "\n")
                GENV.DEADEYE_RIG_LIFECYCLE_LOG = output

                local clipboard = nil
                pcall(function()
                    clipboard = GENV.setclipboard or GENV.toclipboard or GENV.writeclipboard
                end)
                if type(clipboard) == "function" then
                    pcall(clipboard, output)
                end

                for _, connection in ipairs(CONNECTIONS) do
                    pcall(function()
                        connection:Disconnect()
                    end)
                end
                ACTIVE = false
            end
            break
        end

        local snapshot = buildSnapshot()
        if snapshot ~= LAST_SNAPSHOT then
            log("SNAPSHOT_CHANGE|" .. snapshot)
            LAST_SNAPSHOT = snapshot
        end
    end
end)
