--// DEADEYE UNUSUAL TARGET TRACE v1.00
--// Read-only diagnostic. Does not change, remove, or equip any game effects.
--//
--// F7 = mark test phase (MENU <-> ROUND) and capture a snapshot.
--// F6 = stop this diagnostic, disconnect its listeners, and copy the full log.
--// Suggested test:
--//   1. Start in the menu. Click SWAP ON once, wait 2 seconds, click OFF.
--//   2. Enter a round and press F7 once (phase becomes ROUND).
--//   3. Repeat SWAP ON -> wait 2 seconds -> OFF.
--//   4. Return to the menu, press F7 (phase becomes MENU), repeat once.
--//   5. Press F6 and send the copied log.
--//
--// Version reminder: after a completed change, increment only the number after
--// the dot (v1.00 -> v1.01); keep the major version at v1.

local ENV = _G
pcall(function()
    if type(getgenv) == "function" then
        ENV = getgenv()
    end
end)

local oldState = ENV.DEADEYE_UNUSUAL_TARGET_TRACE_STATE
if type(oldState) == "table" and type(oldState.Stop) == "function" then
    pcall(oldState.Stop, "replaced by new run")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Workspace = workspace

local State = {
    active = true,
    stopping = false,
    startedAt = os.clock(),
    phase = "MENU",
    log = {},
    connections = {},
    watchedModels = {},
    watchedButtons = setmetatable({}, { __mode = "k" }),
    objectIds = setmetatable({}, { __mode = "k" }),
    nextObjectId = 0,
    fingerprints = setmetatable({}, { __mode = "k" }),
    mutationBatches = setmetatable({}, { __mode = "k" }),
    uiRoots = setmetatable({}, { __mode = "k" }),
    lastServiceState = nil,
    lastAutoPhase = nil,
    repeatEngineMessage = nil,
    repeatEngineCount = 0
}
ENV.DEADEYE_UNUSUAL_TARGET_TRACE_STATE = State
ENV.DEADEYE_UNUSUAL_TARGET_TRACE_LOG = State.log

local function log(message)
    if not State.active and not State.stopping then
        return
    end
    local elapsed = os.clock() - State.startedAt
    local line = string.format("[UnusualTargetTrace v1.00 +%.3fs] %s", elapsed, tostring(message))
    table.insert(State.log, line)
    pcall(print, line)
end

local function safePath(object)
    if not object then
        return "<nil>"
    end
    local ok, result = pcall(function()
        return object:GetFullName()
    end)
    if ok then
        return result
    end
    return tostring(object)
end

local function objectId(object)
    if not object then
        return "-"
    end
    local id = State.objectIds[object]
    if not id then
        State.nextObjectId += 1
        id = State.nextObjectId
        State.objectIds[object] = id
    end
    return "M" .. tostring(id)
end

local function connect(signal, callback, label)
    local ok, connection = pcall(function()
        return signal:Connect(callback)
    end)
    if ok and connection then
        table.insert(State.connections, connection)
        return connection
    end
    log("CONNECT FAILED " .. tostring(label) .. ": " .. tostring(connection))
    return nil
end

local function addTarget(targetMap, role, model)
    if typeof(model) ~= "Instance" or not model:IsA("Model") then
        return
    end
    local entry = targetMap[model]
    if not entry then
        entry = { model = model, roles = {} }
        targetMap[model] = entry
    end
    if not table.find(entry.roles, role) then
        table.insert(entry.roles, role)
    end
end

local function tryModelField(targetMap, characterObject, fieldName)
    local ok, value = pcall(function()
        return characterObject[fieldName]
    end)
    if ok and typeof(value) == "Instance" and value:IsA("Model") then
        addTarget(targetMap, "CharacterService." .. fieldName, value)
    end
end

local function collectTargets()
    local targets = {}
    local rigsFolder = Workspace:FindFirstChild("Rigs")
    local playersFolder = Workspace:FindFirstChild("Players")
    local menuView = Workspace:FindFirstChild("MenuView")
    local menuModel = menuView and menuView:FindFirstChild("VisualModel")

    local rigModel = rigsFolder and rigsFolder:FindFirstChild(LocalPlayer.Name)
    local playerModel = playersFolder and playersFolder:FindFirstChild(LocalPlayer.Name)

    -- Preserve the lookup order used by DeadEye's getUnusualVisualRig().
    local scriptPrimary = rigModel or playerModel
    if not scriptPrimary and menuModel and menuModel:IsA("Model")
        and menuModel:FindFirstChildOfClass("Humanoid") then
        scriptPrimary = menuModel
    end
    if not scriptPrimary and LocalPlayer.Character then
        scriptPrimary = LocalPlayer.Character
    end

    addTarget(targets, "workspace.Rigs/" .. LocalPlayer.Name, rigModel)
    addTarget(targets, "workspace.Players/" .. LocalPlayer.Name, playerModel)
    addTarget(targets, "workspace.MenuView/VisualModel", menuModel)
    addTarget(targets, "LocalPlayer.Character", LocalPlayer.Character)

    local characterObject
    local characterService
    local serviceRequireError
    local serviceGetError
    local requireOK, service = pcall(function()
        return require(ReplicatedStorage.Services.Asset.CharacterService)
    end)
    if requireOK then
        characterService = service
        local getOK, result = pcall(function()
            return characterService:GetLocalCharacter()
        end)
        if getOK then
            characterObject = result
        else
            serviceGetError = result
        end
    else
        serviceRequireError = service
    end

    if characterObject then
        tryModelField(targets, characterObject, "Model")
        tryModelField(targets, characterObject, "Character")
        tryModelField(targets, characterObject, "CharacterModel")
        tryModelField(targets, characterObject, "Rig")
        tryModelField(targets, characterObject, "PlayerCharacter")
        pcall(function()
            local rig = characterObject.Rig
            if type(rig) == "table" then
                tryModelField(targets, rig, "Model")
                tryModelField(targets, rig, "Character")
            end
        end)
    end

    if scriptPrimary then
        addTarget(targets, "DEADEYE_LOOKUP_PRIMARY", scriptPrimary)
    end

    local entries = {}
    for model, entry in pairs(targets) do
        entry.id = objectId(model)
        entry.path = safePath(model)
        entry.isPrimary = model == scriptPrimary
        entry.hasHumanoid = model:FindFirstChildOfClass("Humanoid") ~= nil
        entry.hasRoot = model:FindFirstChild("HumanoidRootPart") ~= nil
        table.sort(entry.roles)
        entries[#entries + 1] = entry
    end
    table.sort(entries, function(a, b)
        if a.isPrimary ~= b.isPrimary then
            return a.isPrimary
        end
        return a.path < b.path
    end)

    local serviceState = table.concat({
        "present=" .. tostring(characterObject ~= nil),
        "type=" .. type(characterObject),
        "value=" .. tostring(characterObject),
        "primary=" .. (scriptPrimary and objectId(scriptPrimary) or "-"),
        "requireError=" .. (serviceRequireError and tostring(serviceRequireError) or "-"),
        "getError=" .. (serviceGetError and tostring(serviceGetError) or "-")
    }, "|")
    if serviceState ~= State.lastServiceState then
        State.lastServiceState = serviceState
        log("CHARACTERSERVICE state: " .. serviceState)
        if characterObject then
            local keys = {}
            if type(characterObject) == "table" then
                pcall(function()
                    for key, value in pairs(characterObject) do
                        if #keys < 35 then
                            local valueType = type(value)
                            if typeof(value) == "Instance" then
                                valueType = "Instance<" .. value.ClassName .. ">"
                            end
                            table.insert(keys, tostring(key) .. ":" .. valueType)
                        end
                    end
                end)
            end
            log("CHARACTERSERVICE fields: " .. (#keys > 0 and table.concat(keys, ", ") or "<not a plain table / no enumerable fields>"))
        end
    end

    local isGameplay = characterObject ~= nil
    if State.lastAutoPhase ~= isGameplay then
        State.lastAutoPhase = isGameplay
        log("AUTO GAMEPLAY STATE: CharacterService:GetLocalCharacter() ~= nil -> " .. tostring(isGameplay)
            .. " (manual phase=" .. State.phase .. ")")
    end

    return entries
end

local fxClasses = {
    ParticleEmitter = true, Trail = true, Beam = true, Fire = true, Smoke = true,
    Sparkles = true, Highlight = true, BillboardGui = true, PointLight = true,
    SpotLight = true, SurfaceLight = true, Explosion = true
}
local jointClasses = {
    Weld = true, WeldConstraint = true, Motor6D = true, Motor = true
}

local function safeAttribute(object, name)
    local ok, value = pcall(function()
        return object:GetAttribute(name)
    end)
    if ok then
        return value
    end
    return nil
end

local function objectEnabledText(object)
    local ok, value = pcall(function()
        return object.Enabled
    end)
    if ok and type(value) == "boolean" then
        return " Enabled=" .. tostring(value)
    end
    if object:IsA("BasePart") then
        local transparency = ""
        pcall(function()
            transparency = " LTM=" .. tostring(object.LocalTransparencyModifier)
                .. " T=" .. tostring(object.Transparency)
        end)
        return transparency
    end
    return ""
end

local function summarizeModel(entry)
    local model = entry.model
    local descendants = {}
    local ok, result = pcall(function()
        return model:GetDescendants()
    end)
    if ok then
        descendants = result
    end

    local classCounts = {}
    local tagCounts = {}
    local fxSamples = {}
    local taggedSamples = {}
    local allParts = 0
    local aliveFx = 0

    for _, object in ipairs(descendants) do
        if object:IsA("BasePart") then
            allParts += 1
        end

        if fxClasses[object.ClassName] then
            classCounts[object.ClassName] = (classCounts[object.ClassName] or 0) + 1
            aliveFx += 1
            if #fxSamples < 8 then
                local itemId = safeAttribute(object, "DeadEyeUnusualFXID")
                table.insert(fxSamples, object.Name .. "<" .. object.ClassName .. ">"
                    .. (itemId and " id=" .. tostring(itemId) or "")
                    .. objectEnabledText(object))
            end
        end

        local itemId = safeAttribute(object, "DeadEyeUnusualFXID")
        local owned = safeAttribute(object, "DeadEyeUnusualFX")
        if itemId ~= nil then
            local key = tostring(itemId)
            tagCounts[key] = (tagCounts[key] or 0) + 1
            if #taggedSamples < 5 and (object:IsA("BasePart") or jointClasses[object.ClassName]) then
                table.insert(taggedSamples, object.Name .. "<" .. object.ClassName .. "> id=" .. key)
            end
        elseif owned == true and #taggedSamples < 5 then
            table.insert(taggedSamples, object.Name .. "<" .. object.ClassName .. "> id=<nil>")
        end
    end

    local function countsToString(counts)
        local keys = {}
        for key in pairs(counts) do
            keys[#keys + 1] = key
        end
        table.sort(keys)
        local result = {}
        for _, key in ipairs(keys) do
            result[#result + 1] = key .. "=" .. tostring(counts[key])
        end
        return #result > 0 and table.concat(result, ",") or "none"
    end

    local roles = table.concat(entry.roles, ";")
    local signature = table.concat({
        entry.path, tostring(#descendants), tostring(allParts),
        countsToString(classCounts), countsToString(tagCounts),
        table.concat(fxSamples, "|"), table.concat(taggedSamples, "|"),
        tostring(entry.hasHumanoid), tostring(entry.hasRoot)
    }, "||")

    local text = entry.id .. " path=" .. entry.path
        .. " roles={" .. roles .. "}"
        .. " SCRIPT_PRIMARY=" .. tostring(entry.isPrimary)
        .. " Parent=" .. safePath(model.Parent)
        .. " descendants=" .. tostring(#descendants)
        .. " parts=" .. tostring(allParts)
        .. " Humanoid=" .. tostring(entry.hasHumanoid)
        .. " HRP=" .. tostring(entry.hasRoot)
        .. " taggedIDs={" .. countsToString(tagCounts) .. "}"
        .. " FXClasses={" .. countsToString(classCounts) .. "}"
        .. " FXsamples={" .. (#fxSamples > 0 and table.concat(fxSamples, "; ") or "none") .. "}"
        .. " taggedSamples={" .. (#taggedSamples > 0 and table.concat(taggedSamples, "; ") or "none") .. "}"
    return signature, text
end

local function isInterestingMutation(object)
    if not object then
        return false
    end
    if fxClasses[object.ClassName] or jointClasses[object.ClassName] then
        return true
    end
    if safeAttribute(object, "DeadEyeUnusualFXID") ~= nil
        or safeAttribute(object, "DeadEyeUnusualFX") == true then
        return true
    end
    local name = string.lower(tostring(object.Name))
    return string.find(name, "unusual", 1, true) ~= nil
        or string.find(name, "aura", 1, true) ~= nil
        or string.find(name, "effect", 1, true) ~= nil
end

local function queueMutation(model, operation, object)
    if not State.active or not isInterestingMutation(object) then
        return
    end
    local batch = State.mutationBatches[model]
    if not batch then
        batch = { added = 0, removed = 0, classes = {}, ids = {}, samples = {}, scheduled = false }
        State.mutationBatches[model] = batch
    end
    if operation == "ADD" then
        batch.added += 1
    else
        batch.removed += 1
    end
    batch.classes[object.ClassName] = (batch.classes[object.ClassName] or 0) + 1
    local id = safeAttribute(object, "DeadEyeUnusualFXID")
    local idText = tostring(id or "-")
    batch.ids[idText] = (batch.ids[idText] or 0) + 1
    if #batch.samples < 6 then
        table.insert(batch.samples, operation .. ":" .. tostring(object.Name) .. "<" .. tostring(object.ClassName) .. "> id=" .. idText)
    end
    if batch.scheduled then
        return
    end
    batch.scheduled = true
    task.delay(0.12, function()
        if not State.active then
            return
        end
        local function toText(counts)
            local keys = {}
            for key in pairs(counts) do keys[#keys + 1] = key end
            table.sort(keys)
            local parts = {}
            for _, key in ipairs(keys) do parts[#parts + 1] = key .. "=" .. tostring(counts[key]) end
            return #parts > 0 and table.concat(parts, ",") or "none"
        end
        log("MODEL MUTATION: model=" .. objectId(model) .. " path=" .. safePath(model)
            .. " added=" .. tostring(batch.added) .. " removed=" .. tostring(batch.removed)
            .. " classes={" .. toText(batch.classes) .. "}"
            .. " taggedIDs={" .. toText(batch.ids) .. "}"
            .. " samples={" .. table.concat(batch.samples, "; ") .. "}")
        State.mutationBatches[model] = nil
    end)
end

local function syncModelWatchers(entries)
    local current = setmetatable({}, { __mode = "k" })
    for _, entry in ipairs(entries) do
        current[entry.model] = true
        if not State.watchedModels[entry.model] then
            local model = entry.model
            local added = model.DescendantAdded:Connect(function(object)
                queueMutation(model, "ADD", object)
            end)
            local removing = model.DescendantRemoving:Connect(function(object)
                queueMutation(model, "REMOVE", object)
            end)
            State.watchedModels[model] = { added = added, removing = removing }
            log("WATCH MODEL: " .. entry.id .. " path=" .. entry.path .. " roles={" .. table.concat(entry.roles, ";") .. "}")
        end
    end
    for model, connections in pairs(State.watchedModels) do
        if not current[model] then
            pcall(function() connections.added:Disconnect() end)
            pcall(function() connections.removing:Disconnect() end)
            State.watchedModels[model] = nil
            State.fingerprints[model] = nil
            log("UNWATCH MODEL: " .. objectId(model) .. " path=" .. safePath(model))
        end
    end
end

local function cameraState()
    local camera = Workspace.CurrentCamera
    if not camera then
        return "camera=nil"
    end
    local ok, distance = pcall(function()
        return (camera.Focus.Position - camera.CFrame.Position).Magnitude
    end)
    if not ok then
        return "camera=" .. safePath(camera) .. " focusDistance=<read failed>"
    end
    return "camera=" .. safePath(camera) .. " focusDistance=" .. string.format("%.3f", distance)
        .. " firstPersonByDistance=" .. tostring(distance < 2)
end

local function snapshot(reason, force)
    if not State.active then
        return
    end
    local entries = collectTargets()
    syncModelWatchers(entries)
    log("SNAPSHOT BEGIN reason=" .. tostring(reason)
        .. " phase=" .. State.phase
        .. " targets=" .. tostring(#entries)
        .. " " .. cameraState())
    if #entries == 0 then
        log("SNAPSHOT: no candidate character Models found in known locations")
    end
    for _, entry in ipairs(entries) do
        local signature, summary = summarizeModel(entry)
        if force or State.fingerprints[entry.model] ~= signature then
            State.fingerprints[entry.model] = signature
            log("RIG STATE: " .. summary)
        end
    end
    log("SNAPSHOT END reason=" .. tostring(reason))
end

local function captureBurst(reason)
    if not State.active then
        return
    end
    snapshot(reason .. " immediate", true)
    for _, delaySeconds in ipairs({ 0.15, 0.45, 1.0, 2.0 }) do
        task.delay(delaySeconds, function()
            if State.active then
                snapshot(reason .. " +" .. tostring(delaySeconds) .. "s", true)
            end
        end)
    end
end

local function underDeadEyeGUI(object)
    local node = object
    for _ = 1, 12 do
        if not node then
            return false
        end
        if node.Name == "EmoteSwapperGUI" then
            return true
        end
        node = node.Parent
    end
    return false
end

local function bindButton(object)
    if not State.active or not object:IsA("TextButton") or State.watchedButtons[object] then
        return
    end
    if not underDeadEyeGUI(object) then
        return
    end
    State.watchedButtons[object] = true
    connect(object.MouseButton1Click, function()
        if not State.active then
            return
        end
        local text = tostring(object.Text)
        log("GUI CLICK: path=" .. safePath(object) .. " text=" .. string.gsub(text, "[\r\n]", " "))
        if string.find(string.upper(text), "SWAP:", 1, true) then
            captureBurst("SWAP CLICK text=" .. text)
        end
    end, "button click " .. safePath(object))
    connect(object:GetPropertyChangedSignal("Text"), function()
        if State.active then
            local text = tostring(object.Text)
            if string.find(string.upper(text), "SWAP:", 1, true) then
                log("GUI BUTTON TEXT: path=" .. safePath(object) .. " text=" .. text)
            end
        end
    end, "button text " .. safePath(object))
end

local function bindGuiRoot(root)
    if not root or State.uiRoots[root] then
        return
    end
    State.uiRoots[root] = true
    log("WATCH GUI: " .. safePath(root))
    connect(root.DescendantAdded, function(object)
        if object:IsA("TextButton") then
            task.defer(function()
                bindButton(object)
            end)
        end
    end, "GUI descendants " .. safePath(root))
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextButton") then
            bindButton(object)
        end
    end
end

local function discoverGui()
    local coreGui
    pcall(function()
        coreGui = game:GetService("CoreGui")
    end)
    if coreGui then
        local gui = coreGui:FindFirstChild("EmoteSwapperGUI", true)
        if gui then
            bindGuiRoot(gui)
        end
    end
    local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        local gui = playerGui:FindFirstChild("EmoteSwapperGUI", true)
        if gui then
            bindGuiRoot(gui)
        end
    end
end

local function stop(reason)
    if State.stopping or not State.active then
        return
    end
    State.stopping = true
    log("F6: stopping diagnostic; reason=" .. tostring(reason or "hotkey"))
    for _, connection in ipairs(State.connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(State.connections)
    for model, connections in pairs(State.watchedModels) do
        pcall(function() connections.added:Disconnect() end)
        pcall(function() connections.removing:Disconnect() end)
        State.watchedModels[model] = nil
    end
    log("F6: all diagnostic listeners disconnected; DeadEye itself was not changed")
    State.active = false

    local clipboardNames = { "setclipboard", "toclipboard", "writeclipboard" }
    local copied, chosen = false, nil
    for _, name in ipairs(clipboardNames) do
        local callback = ENV[name]
        if type(callback) ~= "function" then callback = _G[name] end
        if type(callback) == "function" then
            local ok = pcall(callback, table.concat(State.log, "\n"))
            if ok then
                copied, chosen = true, name
                break
            end
        end
    end
    if copied then
        table.insert(State.log, "[UnusualTargetTrace v1.00] F6 clipboard copy succeeded via " .. tostring(chosen))
        local callback = ENV[chosen]
        if type(callback) ~= "function" then callback = _G[chosen] end
        if type(callback) == "function" then
            pcall(callback, table.concat(State.log, "\n"))
        end
        pcall(print, "[UnusualTargetTrace v1.00] F6 clipboard copy succeeded via " .. tostring(chosen))
    else
        table.insert(State.log, "[UnusualTargetTrace v1.00] Clipboard API unavailable; log remains in getgenv().DEADEYE_UNUSUAL_TARGET_TRACE_LOG")
        pcall(print, "[UnusualTargetTrace v1.00] Clipboard API unavailable; log remains in getgenv().DEADEYE_UNUSUAL_TARGET_TRACE_LOG")
    end
    State.stopping = false
end

State.Stop = stop
ENV.DEADEYE_UNUSUAL_TARGET_TRACE_STOP = stop

log("START: version=v1.00, player=" .. tostring(LocalPlayer)
    .. ", F7=phase marker MENU/ROUND, F6=stop+copy log")
log("SAFETY: read-only; no effect instances/properties/loadout are modified")
log("TEST: click SWAP ON once, wait 2 seconds, click OFF; press F7 at each MENU/ROUND boundary")
log("START LOCATIONS: Workspace.Rigs/" .. tostring(LocalPlayer and LocalPlayer.Name)
    .. " | Workspace.Players/" .. tostring(LocalPlayer and LocalPlayer.Name)
    .. " | Workspace.MenuView/VisualModel | LocalPlayer.Character")
captureBurst("startup")
discoverGui()

connect(UserInputService.InputBegan, function(input, processed)
    if tostring(input.KeyCode) == "Enum.KeyCode.F6" then
        stop("F6 full stop + copy")
    elseif tostring(input.KeyCode) == "Enum.KeyCode.F7" then
        if not State.active then
            return
        end
        State.phase = State.phase == "MENU" and "ROUND" or "MENU"
        log("F7 PHASE MARK: manual phase now " .. State.phase .. " (processed=" .. tostring(processed) .. ")")
        captureBurst("F7 phase=" .. State.phase)
    end
end, "keyboard")

connect(game:GetService("LogService").MessageOut, function(message, messageType)
    if not State.active then
        return
    end
    local kind = tostring(messageType)
    if not string.find(kind, "Error", 1, true) and not string.find(kind, "Warning", 1, true) then
        return
    end
    local text = tostring(message)
    if text == State.repeatEngineMessage then
        State.repeatEngineCount += 1
        if State.repeatEngineCount == 1 or State.repeatEngineCount == 5 or State.repeatEngineCount % 25 == 0 then
            log("ENGINE " .. kind .. " repeated x" .. tostring(State.repeatEngineCount + 1) .. ": " .. text)
        end
        return
    end
    if State.repeatEngineCount > 0 then
        log("ENGINE previous message repeated x" .. tostring(State.repeatEngineCount + 1))
    end
    State.repeatEngineMessage = text
    State.repeatEngineCount = 0
    log("ENGINE " .. kind .. ": " .. text)
end, "LogService")

task.spawn(function()
    while State.active do
        local ok, err = xpcall(function()
            discoverGui()
            local entries = collectTargets()
            syncModelWatchers(entries)
            for _, entry in ipairs(entries) do
                local signature, summary = summarizeModel(entry)
                if State.fingerprints[entry.model] ~= signature then
                    State.fingerprints[entry.model] = signature
                    log("RIG STATE CHANGE: " .. summary)
                end
            end
        end, function(message)
            local trace = tostring(message)
            pcall(function()
                if debug and type(debug.traceback) == "function" then
                    trace = debug.traceback(trace, 2)
                end
            end)
            return trace
        end)
        if not ok then
            log("SCAN ERROR: " .. tostring(err))
        end
        task.wait(0.35)
    end
end)

log("READY: wait for startup snapshots, then run the MENU/ROUND test.")
