--// DEADEYE UNUSUAL SNAPSHOT FORENSICS v1.01
--// READ-ONLY diagnostic for the post-update Unusual swap failure.
--// Does not equip/unequip items, destroy FX, or change visual properties.
--//
--// F9  = mark phase MENU/ROUND and take a forensic snapshot
--// F10 = FULL STOP + COPY LOG
--// Main DeadEye_Diagnostic.lua keeps its F6 stop key.
--//
--// This traces the exact gate that currently fails:
--// captureNativeUnusualSnapshot -> buildOriginalUnusualSignature
--// compares source Character/CharacterClassic children against live rig children
--// by class/name (and MeshId/TextureID for MeshParts).
--//
--// Version reminder: after a completed script change, increment only the number
--// after the dot (v1.00 -> v1.01). Keep the major version at v1.

local ENV = _G
pcall(function()
    if type(getgenv) == "function" then
        ENV = getgenv()
    end
end)

local old = ENV.DEADEYE_UNUSUAL_SNAPSHOT_FORENSICS_STATE
if type(old) == "table" and type(old.Stop) == "function" then
    pcall(old.Stop, "replaced by new run")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogService = game:GetService("LogService")
local Workspace = workspace
local LocalPlayer = Players.LocalPlayer

local State = {
    active = true,
    stopping = false,
    startedAt = os.clock(),
    phase = "MENU",
    log = {},
    connections = {},
    cleanupCallbacks = {},
    uiRoots = setmetatable({}, { __mode = "k" }),
    watchedButtons = setmetatable({}, { __mode = "k" }),
    watchedModels = setmetatable({}, { __mode = "k" }),
    lastEquipped = nil,
    lastBurstAt = 0,
    lastEngineMessage = nil,
    lastEngineRepeat = 0,
}
ENV.DEADEYE_UNUSUAL_SNAPSHOT_FORENSICS_STATE = State
ENV.DEADEYE_UNUSUAL_SNAPSHOT_FORENSICS_LOG = State.log

local function log(message)
    if not State.active and not State.stopping then
        return
    end
    local line = string.format(
        "[UnusualSnapshotForensics v1.01 +%.3fs] %s",
        os.clock() - State.startedAt,
        tostring(message)
    )
    table.insert(State.log, line)
    pcall(print, line)
    if #State.log > 6000 then
        table.remove(State.log, 1)
    end
end

local function safePath(object)
    if not object then
        return "<nil>"
    end
    local ok, result = pcall(function()
        return object:GetFullName()
    end)
    return ok and result or tostring(object)
end

local function connect(signal, callback, label)
    local ok, result = pcall(function()
        return signal:Connect(callback)
    end)
    if ok and result then
        table.insert(State.connections, result)
        return result
    end
    log("CONNECT FAILED " .. tostring(label) .. ": " .. tostring(result))
    return nil
end

local function childPath(parent, names)
    local current = parent
    for _, name in ipairs(names) do
        if not current then
            return nil
        end
        current = current:FindFirstChild(name)
    end
    return current
end

local function safeRequire(module, label)
    if not module or not module:IsA("ModuleScript") then
        return nil, "module missing: " .. tostring(label)
    end
    local ok, result = pcall(require, module)
    if not ok then
        return nil, "require failed " .. tostring(label) .. ": " .. tostring(result)
    end
    return result, nil
end

local function getVisualRig()
    local rigs = Workspace:FindFirstChild("Rigs")
    local rig = rigs and rigs:FindFirstChild(LocalPlayer.Name)
    if rig then
        return rig, "Workspace.Rigs"
    end

    local playersFolder = Workspace:FindFirstChild("Players")
    local playerCharacter = playersFolder and playersFolder:FindFirstChild(LocalPlayer.Name)
    if playerCharacter then
        return playerCharacter, "Workspace.Players fallback"
    end

    local menuView = Workspace:FindFirstChild("MenuView")
    local visualModel = menuView and menuView:FindFirstChild("VisualModel")
    if visualModel and visualModel:IsA("Model") then
        return visualModel, "Workspace.MenuView.VisualModel fallback"
    end

    if LocalPlayer.Character and LocalPlayer.Character:IsA("Model") then
        return LocalPlayer.Character, "LocalPlayer.Character fallback"
    end
    return nil, "no visual rig found"
end

local function getPlayerCharacter()
    local playersFolder = Workspace:FindFirstChild("Players")
    local model = playersFolder and playersFolder:FindFirstChild(LocalPlayer.Name)
    return model or LocalPlayer.Character
end

local function loadoutAPIs()
    local newModule = childPath(ReplicatedStorage, {
        "Client", "Services", "UserData", "Inventory", "Loadout"
    })
    local newApi, newErr = safeRequire(newModule, "Client.Services.UserData.Inventory.Loadout")

    local oldModule = childPath(ReplicatedStorage, {
        "Shared", "UserData", "ClientHooks", "useLoadout"
    })
    local oldApi, oldErr = safeRequire(oldModule, "Shared.UserData.ClientHooks.useLoadout")
    return newApi, newErr, oldApi, oldErr
end

local function getEquippedId()
    local newApi, newErr, oldApi, oldErr = loadoutAPIs()
    local newId
    if type(newApi) == "table" and type(newApi.GetEquipped) == "function" then
        local ok, result = pcall(newApi.GetEquipped, "UnusualSlot")
        if ok then
            newId = tonumber(result) or 0
        else
            newErr = "GetEquipped failed: " .. tostring(result)
        end
    else
        newErr = newErr or "new Inventory.Loadout API unavailable"
    end

    local oldId
    if type(oldApi) == "table" and type(oldApi.GetEquippedFromSlot) == "function" then
        local ok, result = pcall(oldApi.GetEquippedFromSlot, "UnusualSlot")
        if ok then
            oldId = tonumber(result) or 0
        else
            oldErr = "GetEquippedFromSlot failed: " .. tostring(result)
        end
    else
        oldErr = oldErr or "legacy useLoadout API unavailable"
    end

    return newId, newErr, oldId, oldErr
end

local function getItemModule(id)
    id = tonumber(id)
    if not id then
        return nil, "no numeric item ID", false, "no numeric item ID"
    end

    --// This is the exact resolver used by DeadEye_Diagnostic.lua.
    --// Keep its result separate from the Registry fallback so a fallback
    --// cannot hide a broken production resolver.
    local clientModule = childPath(ReplicatedStorage, {
        "Services", "Items", "ClientItemService"
    })
    local clientApi, clientErr = safeRequire(clientModule, "Services.Items.ClientItemService")
    if type(clientApi) == "table" and type(clientApi.GetItemFromID) == "function" then
        local ok, result = pcall(function()
            return clientApi:GetItemFromID(id)
        end)
        if ok and result then
            return result, "ClientItemService:GetItemFromID", true,
                "ClientItemService returned " .. safePath(result)
        end
        if ok then
            clientErr = "ClientItemService:GetItemFromID returned nil for ID " .. tostring(id)
        else
            clientErr = "ClientItemService:GetItemFromID threw: " .. tostring(result)
        end
    end

    local registryModule = childPath(ReplicatedStorage, { "Items", "Registry" })
    local registry, registryErr = safeRequire(registryModule, "Items.Registry")
    if type(registry) == "table" then
        local getter = registry.TryGetById or registry.GetById
        if type(getter) == "function" then
            local ok, entry = pcall(getter, id)
            if ok and type(entry) == "table" and entry.Module then
                return entry.Module, "Items.Registry fallback", false,
                    tostring(clientErr or "ClientItemService did not resolve ID")
            end
            registryErr = "Registry lookup failed: " .. tostring(entry)
        end
    end

    local reason = tostring(clientErr or "") .. " | " .. tostring(registryErr or "")
    return nil, reason, false, reason
end
local FX_CLASSES = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Sparkles = true,
    Fire = true,
    Smoke = true,
    Highlight = true,
    PointLight = true,
    SpotLight = true,
    SurfaceLight = true,
    BillboardGui = true,
}
local JOINT_CLASSES = {
    Weld = true,
    WeldConstraint = true,
    Motor6D = true,
    Motor = true,
}

local function isFx(object)
    return object and FX_CLASSES[object.ClassName] == true
end

local function hasEffectContent(object)
    if isFx(object) then
        return true
    end
    if object:IsA("BasePart") then
        return true
    end
    for _, descendant in ipairs(object:GetDescendants()) do
        if isFx(descendant) or descendant:IsA("BasePart") then
            return true
        end
    end
    return false
end

local function jointHasNestedBasePart(joint)
    for _, descendant in ipairs(joint:GetDescendants()) do
        if descendant:IsA("BasePart") then
            return true
        end
    end
    return false
end

local function jointReferencesPart(joint, sourcePart)
    for _, property in ipairs({ "Part0", "Part1" }) do
        local referencedPart
        pcall(function()
            referencedPart = joint[property]
        end)
        if referencedPart and referencedPart:IsA("BasePart") and referencedPart ~= sourcePart then
            local ok, result = pcall(function()
                return referencedPart:IsDescendantOf(sourcePart)
            end)
            if ok and result then
                return true
            end
        end
    end
    return false
end

local function matchesSignatureObject(existing, info)
    if existing.ClassName ~= info.Class or existing.Name ~= info.Name then
        return false
    end
    if existing:IsA("MeshPart") and info.MeshId then
        return tostring(existing.MeshId) == info.MeshId
            and tostring(existing.TextureID) == info.TextureId
    end
    return true
end

local function chooseCosmeticRig(module, visualRig)
    if not module or not visualRig then
        return nil, "module or visualRig missing"
    end
    local humanoid = visualRig:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return nil, "live visual rig has no Humanoid"
    end
    local firstName, secondName
    if humanoid.RigType == Enum.HumanoidRigType.R6 then
        firstName, secondName = "CharacterClassic", "Character"
    else
        firstName, secondName = "Character", "CharacterClassic"
    end
    return module:FindFirstChild(firstName) or module:FindFirstChild(secondName),
        "rigType=" .. tostring(humanoid.RigType) .. ", preferred=" .. firstName
end

local function countFx(model)
    local count, classes = 0, {}
    if not model then
        return 0, classes
    end
    local function add(object)
        if isFx(object) then
            count += 1
            classes[object.ClassName] = (classes[object.ClassName] or 0) + 1
        end
    end
    add(model)
    for _, object in ipairs(model:GetDescendants()) do
        add(object)
    end
    return count, classes
end

local function classCounts(model)
    local counts = {}
    if not model then
        return counts
    end
    for _, object in ipairs(model:GetDescendants()) do
        counts[object.ClassName] = (counts[object.ClassName] or 0) + 1
    end
    return counts
end

local function directChildSummary(part, limit)
    if not part then
        return "<missing part>"
    end
    local out = {}
    for _, child in ipairs(part:GetChildren()) do
        table.insert(out, child.Name .. ":" .. child.ClassName)
        if #out >= limit then
            table.insert(out, "...+" .. tostring(#part:GetChildren() - limit))
            break
        end
    end
    return table.concat(out, ",")
end

local function snapshot(reason)
    if not State.active then
        return
    end

    local newId, newErr, oldId, oldErr = getEquippedId()
    local sourceId = newId
    local override = tonumber(ENV.DEADEYE_UNUSUAL_SNAPSHOT_ID_OVERRIDE)
    if override then
        sourceId = override
    end

    local visualRig, rigSource = getVisualRig()
    local playerCharacter = getPlayerCharacter()
    log("========== SNAPSHOT BEGIN reason=" .. tostring(reason)
        .. " phase=" .. State.phase .. " ==========")
    log("LOADOUT new.Inventory.Loadout.UnusualSlot=" .. tostring(newId)
        .. " source=Inventory.Loadout.GetEquipped")
    if newErr then
        log("LOADOUT NEW API NOTE: " .. tostring(newErr))
    end
    log("LOADOUT old.useLoadout.UnusualSlot=" .. tostring(oldId)
        .. " source=GetEquippedFromSlot (comparison only)")
    if oldErr then
        log("LOADOUT OLD API NOTE: " .. tostring(oldErr))
    end
    if newId ~= nil and oldId ~= nil and newId ~= oldId then
        log("LOADOUT MISMATCH: current API=" .. tostring(newId)
            .. " legacy cache=" .. tostring(oldId)
            .. " (the main script should trust the current Inventory.Loadout API)")
    end
    if override then
        log("ID OVERRIDE active: diagnostic source ID=" .. tostring(sourceId)
            .. " (getgenv().DEADEYE_UNUSUAL_SNAPSHOT_ID_OVERRIDE)")
    end

    log("RIGS visual=" .. safePath(visualRig) .. " chosenBy=" .. tostring(rigSource)
        .. " descendants=" .. tostring(visualRig and #visualRig:GetDescendants() or 0)
        .. " HRP=" .. tostring(visualRig and visualRig:FindFirstChild("HumanoidRootPart") ~= nil))
    log("PLAYER character=" .. safePath(playerCharacter)
        .. " descendants=" .. tostring(playerCharacter and #playerCharacter:GetDescendants() or 0)
        .. " HRP=" .. tostring(playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") ~= nil))

    if not sourceId or sourceId == 0 then
        log("PREDICTION: STOP HERE — no equipped Unusual ID from the current API.")
        log("========== SNAPSHOT END ==========")
        return
    end

    local module, moduleSource, mainResolverOK, mainResolverStatus = getItemModule(sourceId)
    if not module then
        log("ITEM MODULE MISSING id=" .. tostring(sourceId) .. " reason=" .. tostring(moduleSource))
        log("PREDICTION: getUnusualCosmeticRig/buildOriginalUnusualSignature would return nil.")
        log("========== SNAPSHOT END ==========")
        return
    end
    log("ITEM MODULE id=" .. tostring(sourceId) .. " name=" .. tostring(module.Name)
        .. " path=" .. safePath(module) .. " resolver=" .. tostring(moduleSource)
        .. " mainResolverOK=" .. tostring(mainResolverOK)
        .. " Character=" .. tostring(module:FindFirstChild("Character") ~= nil)
        .. " CharacterClassic=" .. tostring(module:FindFirstChild("CharacterClassic") ~= nil))
    log("MAIN getItemModule() result: " .. tostring(mainResolverStatus))
    if not mainResolverOK then
        log("CRITICAL MAIN-PATH MISMATCH: DeadEye_Diagnostic.lua uses ClientItemService:GetItemFromID only; this analyzer needed Registry fallback. The main script would get no item module here, so getUnusualCosmeticRig/buildOriginalUnusualSignature would return nil before comparing live rig children.")
    end

    local config
    local okConfig, configResult = pcall(require, module)
    if okConfig then
        config = configResult
    else
        log("ITEM CONFIG REQUIRE FAILED: " .. tostring(configResult))
    end
    if type(config) == "table" then
        local ci = config.CosmeticInfo
        local ai = config.AppearanceInfo
        log("ITEM CONFIG CosmeticInfo.Unusual=" .. tostring(type(ci) == "table" and ci.Unusual or nil)
            .. " AppearanceInfo.Name=" .. tostring(type(ai) == "table" and ai.Name or nil))
    end

    local sourceRig, sourceRigWhy = chooseCosmeticRig(module, visualRig)
    if not sourceRig then
        log("SOURCE COSMETIC RIG MISSING reason=" .. tostring(sourceRigWhy))
        log("PREDICTION: buildOriginalUnusualSignature returns nil.")
        log("========== SNAPSHOT END ==========")
        return
    end

    local liveHumanoid = visualRig and visualRig:FindFirstChildOfClass("Humanoid")
    local sourceFx, sourceClasses = countFx(sourceRig)
    local liveFx, liveClasses = countFx(visualRig)
    local sourceCounts = classCounts(sourceRig)
    local liveCounts = classCounts(visualRig)

    log("SOURCE COSMETIC RIG path=" .. safePath(sourceRig) .. " reason=" .. tostring(sourceRigWhy)
        .. " directChildren=" .. tostring(#sourceRig:GetChildren())
        .. " descendants=" .. tostring(#sourceRig:GetDescendants())
        .. " FX=" .. tostring(sourceFx) .. " FXClasses=" .. tostring(sourceClasses))
    log("LIVE RIG FX count=" .. tostring(liveFx) .. " FXClasses=" .. tostring(liveClasses))
    log("LIVE RIG classCounts relevant: Attachments=" .. tostring(liveCounts.Attachment or 0)
        .. " BaseParts=" .. tostring((liveCounts.Part or 0) + (liveCounts.MeshPart or 0))
        .. " Beams=" .. tostring(liveCounts.Beam or 0)
        .. " ParticleEmitters=" .. tostring(liveCounts.ParticleEmitter or 0)
        .. " Trails=" .. tostring(liveCounts.Trail or 0))
    log("SOURCE RIG classCounts relevant: Attachments=" .. tostring(sourceCounts.Attachment or 0)
        .. " BaseParts=" .. tostring((sourceCounts.Part or 0) + (sourceCounts.MeshPart or 0))
        .. " Beams=" .. tostring(sourceCounts.Beam or 0)
        .. " ParticleEmitters=" .. tostring(sourceCounts.ParticleEmitter or 0)
        .. " Trails=" .. tostring(sourceCounts.Trail or 0))

    local candidates, candidateCount, matchedCount, missedCount = {}, 0, 0, 0
    local sourcePartsCount, missingLiveParts = 0, 0
    local partSummaries, mismatchDetails = {}, {}
    for _, sourcePart in ipairs(sourceRig:GetChildren()) do
        if sourcePart:IsA("BasePart") then
            sourcePartsCount += 1
            local livePart = visualRig and visualRig:FindFirstChild(sourcePart.Name)
            local partCandidates, partMatches, partMisses = 0, 0, 0

            for _, object in ipairs(sourcePart:GetChildren()) do
                local info = nil
                if JOINT_CLASSES[object.ClassName] or object:IsA("CFrameValue") then
                    if JOINT_CLASSES[object.ClassName]
                        and (jointHasNestedBasePart(object) or jointReferencesPart(object, sourcePart))
                    then
                        info = {
                            Class = object.ClassName,
                            Name = object.Name,
                            WholeTree = true,
                            source = object,
                        }
                    end
                elseif hasEffectContent(object) then
                    info = {
                        Class = object.ClassName,
                        Name = object.Name,
                        source = object,
                    }
                    if object:IsA("MeshPart") then
                        info.MeshId = tostring(object.MeshId)
                        info.TextureId = tostring(object.TextureID)
                    end
                    if object:IsA("BasePart") then
                        for _, sibling in ipairs(sourcePart:GetChildren()) do
                            if JOINT_CLASSES[sibling.ClassName] then
                                local part0, part1
                                pcall(function()
                                    part0, part1 = sibling.Part0, sibling.Part1
                                end)
                                if part0 == object or part1 == object then
                                    info.WholeTree = true
                                    break
                                end
                            end
                        end
                    end
                end

                if info then
                    candidateCount += 1
                    partCandidates += 1
                    local found = false
                    if livePart and livePart:IsA("BasePart") then
                        for _, existing in ipairs(livePart:GetChildren()) do
                            if matchesSignatureObject(existing, info) then
                                found = true
                                break
                            end
                        end
                    end

                    if found then
                        matchedCount += 1
                        partMatches += 1
                        table.insert(candidates, {
                            part = sourcePart.Name,
                            info = info,
                            match = true,
                        })
                    else
                        missedCount += 1
                        partMisses += 1
                        table.insert(candidates, {
                            part = sourcePart.Name,
                            info = info,
                            match = false,
                        })
                        if #mismatchDetails < 55 then
                            table.insert(mismatchDetails,
                                sourcePart.Name .. "/" .. info.Class .. "/" .. info.Name
                                .. " source=" .. safePath(object)
                                .. " livePart=" .. safePath(livePart)
                                .. " liveChildren={" .. directChildSummary(livePart, 18) .. "}")
                        end
                    end
                end
            end

            if partCandidates > 0 then
                table.insert(partSummaries, sourcePart.Name
                    .. ": candidates=" .. tostring(partCandidates)
                    .. ", exactMatch=" .. tostring(partMatches)
                    .. ", miss=" .. tostring(partMisses)
                    .. ", livePart=" .. safePath(livePart))
            end
            if partCandidates > 0 and not livePart then
                missingLiveParts += 1
            end
        end
    end

    log("SIGNATURE REPLAY: sourceBaseParts=" .. tostring(sourcePartsCount)
        .. " candidateObjects=" .. tostring(candidateCount)
        .. " exactMatches=" .. tostring(matchedCount)
        .. " misses=" .. tostring(missedCount)
        .. " sourcePartsMissingFromLiveRig=" .. tostring(missingLiveParts))
    log("SIGNATURE PARTS: " .. table.concat(partSummaries, " | "))
    local printed = 0
    for _, item in ipairs(candidates) do
        if item.match and printed < 30 then
            log("MATCH " .. item.part .. "/" .. item.info.Class .. "/" .. item.info.Name
                .. (item.info.WholeTree and " WholeTree=true" or ""))
            printed += 1
        end
    end
    for _, detail in ipairs(mismatchDetails) do
        log("MISS " .. detail)
    end

    if not mainResolverOK then
        log("PREDICTION: main failure is already explained by ClientItemService:GetItemFromID returning nil/throwing; Registry fallback matches do not help the unmodified main resolver.")
    elseif candidateCount == 0 then
        log("PREDICTION: source signature contains no candidate children; check the chosen item model/rig variant.")
    elseif matchedCount == 0 then
        log("PREDICTION: EXACT FAILURE MATCHES s — no source signature object matches a direct child of its live body part.")
        log("Therefore captureNativeUnusualSnapshot reaches #snapshot.parts == 0 and returns nil before replacing any effect.")
    elseif matchedCount > 0 then
        log("PREDICTION: this sampled rig has " .. tostring(matchedCount)
            .. " direct-child signature matches; capture may pass the empty-snapshot gate in this phase.")
        log("If main log still reports snapshot=nil, compare the phase/rig object identity and re-run immediately after the failed click.")
    end

    local cache = ReplicatedStorage:FindFirstChild("RigCache")
    if cache then
        local related = {}
        for _, object in ipairs(cache:GetChildren()) do
            if string.find(object.Name, LocalPlayer.Name, 1, true) then
                table.insert(related, object.Name .. ":" .. object.ClassName)
            end
        end
        log("RIGCACHE matching player entries={" .. table.concat(related, ",") .. "}")
    else
        log("RIGCACHE folder missing")
    end

    log("========== SNAPSHOT END reason=" .. tostring(reason) .. " ==========")
end

local function captureBurst(reason)
    if not State.active then
        return
    end
    local now = os.clock()
    if now - State.lastBurstAt < 0.3 then
        log("BURST THROTTLED reason=" .. tostring(reason) .. " (repeated click within 0.3s)")
        return
    end
    State.lastBurstAt = now
    snapshot(reason .. " immediate")
    for _, delaySeconds in ipairs({ 0.15, 0.45, 1.0, 2.0 }) do
        task.delay(delaySeconds, function()
            if State.active then
                snapshot(reason .. " +" .. tostring(delaySeconds) .. "s")
            end
        end)
    end
end

local function underSwapGui(object)
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
    if not underSwapGui(object) then
        return
    end
    State.watchedButtons[object] = true
    connect(object.MouseButton1Click, function()
        if not State.active then
            return
        end
        local text = string.gsub(tostring(object.Text), "[\r\n]", " ")
        if string.find(string.upper(text), "SWAP:", 1, true) then
            log("SWAP BUTTON CLICK path=" .. safePath(object) .. " text=" .. text)
            captureBurst("SWAP BUTTON CLICK text=" .. text)
        end
    end, "swap button click")
    connect(object:GetPropertyChangedSignal("Text"), function()
        if State.active and string.find(string.upper(tostring(object.Text)), "SWAP:", 1, true) then
            log("SWAP BUTTON TEXT path=" .. safePath(object)
                .. " text=" .. string.gsub(tostring(object.Text), "[\r\n]", " "))
        end
    end, "swap button text")
end

local function bindGui(root)
    if not root or State.uiRoots[root] then
        return
    end
    State.uiRoots[root] = true
    log("WATCH GUI " .. safePath(root))
    connect(root.DescendantAdded, function(object)
        if object:IsA("TextButton") then
            task.defer(function()
                bindButton(object)
            end)
        end
    end, "GUI descendants")
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
    local gui = coreGui and coreGui:FindFirstChild("EmoteSwapperGUI", true)
    if not gui then
        local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
        gui = playerGui and playerGui:FindFirstChild("EmoteSwapperGUI", true)
    end
    if gui then
        bindGui(gui)
    end
end

local function relevantMutation(object)
    if not object then
        return false
    end
    if isFx(object) or object:IsA("BasePart") or JOINT_CLASSES[object.ClassName] then
        return true
    end
    if object:IsA("Attachment") then
        for _, descendant in ipairs(object:GetDescendants()) do
            if isFx(descendant) or descendant:IsA("BasePart") then
                return true
            end
        end
    end
    return false
end

local function watchModel(model, role)
    if not model or State.watchedModels[model] then
        return
    end
    State.watchedModels[model] = true
    log("WATCH MODEL role=" .. tostring(role) .. " path=" .. safePath(model)
        .. " descendants=" .. tostring(#model:GetDescendants()))
    connect(model.DescendantAdded, function(object)
        if State.active and relevantMutation(object) then
            log("RIG ADD role=" .. tostring(role) .. " class=" .. object.ClassName
                .. " name=" .. object.Name .. " parent=" .. safePath(object.Parent))
        end
    end, "rig descendants added")
    connect(model.DescendantRemoving, function(object)
        if State.active and relevantMutation(object) then
            log("RIG REMOVE role=" .. tostring(role) .. " class=" .. object.ClassName
                .. " name=" .. object.Name .. " parent=" .. safePath(object.Parent))
        end
    end, "rig descendants removing")
end

local function stop(reason)
    if State.stopping or not State.active then
        return
    end
    State.stopping = true
    log("F10 FULL STOP requested; disconnecting read-only listeners; reason=" .. tostring(reason))
    for _, connection in ipairs(State.connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(State.connections)
    for _, cleanup in ipairs(State.cleanupCallbacks) do
        pcall(cleanup)
    end
    table.clear(State.cleanupCallbacks)
    State.active = false
    log("STOP COMPLETE: no game effects or equipped slots were modified")

    local payload = table.concat(State.log, "\n")
    local copied, chosen = false, nil
    for _, name in ipairs({ "setclipboard", "toclipboard", "writeclipboard" }) do
        local callback = ENV[name]
        if type(callback) ~= "function" then
            callback = _G[name]
        end
        if type(callback) == "function" then
            local ok = pcall(callback, payload)
            if ok then
                copied, chosen = true, name
                break
            end
        end
    end
    if copied then
        table.insert(State.log, "[UnusualSnapshotForensics v1.01] Clipboard copy succeeded via " .. tostring(chosen))
        local callback = ENV[chosen]
        if type(callback) ~= "function" then
            callback = _G[chosen]
        end
        if type(callback) == "function" then
            pcall(callback, table.concat(State.log, "\n"))
        end
        pcall(print, "[UnusualSnapshotForensics v1.01] F10 copied full log")
    else
        table.insert(State.log, "[UnusualSnapshotForensics v1.01] Clipboard API unavailable; log remains in getgenv().DEADEYE_UNUSUAL_SNAPSHOT_FORENSICS_LOG")
        pcall(print, "[UnusualSnapshotForensics v1.01] Clipboard API unavailable; log remains in getgenv().DEADEYE_UNUSUAL_SNAPSHOT_FORENSICS_LOG")
    end
    State.stopping = false
end

State.Stop = stop
ENV.DEADEYE_UNUSUAL_SNAPSHOT_FORENSICS_STOP = stop

log("START v1.00 player=" .. tostring(LocalPlayer)
    .. " F9=phase marker+snapshot F10=full stop+copy")
log("READ-ONLY: no Equip remote, no FX deletion, no property writes")
log("SOURCES: current Inventory.Loadout API is compared against legacy useLoadout cache.")
log("SOURCES: item model is resolved through ClientItemService:GetItemFromID, then Character/CharacterClassic is compared against live Workspace.Rigs children.")

local newId, newErr, oldId, oldErr = getEquippedId()
State.lastEquipped = newId
log("BOOT LOADOUT current=" .. tostring(newId) .. " legacy=" .. tostring(oldId)
    .. " currentError=" .. tostring(newErr) .. " legacyError=" .. tostring(oldErr))

snapshot("startup")
discoverGui()
watchModel(select(1, getVisualRig()), "visual rig")
watchModel(getPlayerCharacter(), "player character")

connect(UserInputService.InputBegan, function(input, processed)
    if not State.active then
        return
    end
    if input.KeyCode == Enum.KeyCode.F10 then
        stop("F10 FULL STOP + COPY LOG")
    elseif input.KeyCode == Enum.KeyCode.F9 then
        State.phase = State.phase == "MENU" and "ROUND" or "MENU"
        log("F9 PHASE MARK: now=" .. State.phase .. " processed=" .. tostring(processed))
        captureBurst("F9 phase=" .. State.phase)
    end
end, "keyboard")

local api = select(1, loadoutAPIs())
if type(api) == "table" and type(api.Observe) == "function" then
    local ok, cleanup = pcall(function()
        return api.Observe("UnusualSlot", function(value)
            local id = tonumber(value) or 0
            if State.lastEquipped ~= id then
                log("LOADOUT CHANGE via current Observe: " .. tostring(State.lastEquipped)
                    .. " -> " .. tostring(id))
                State.lastEquipped = id
                captureBurst("current Inventory.Loadout Observe id=" .. tostring(id))
            end
        end)
    end)
    if ok and type(cleanup) == "function" then
        table.insert(State.cleanupCallbacks, cleanup)
        log("LOADOUT OBSERVER attached via Inventory.Loadout.Observe")
    else
        log("LOADOUT OBSERVER unavailable: " .. tostring(cleanup))
    end
else
    log("LOADOUT OBSERVER unavailable; polling current GetEquipped every 0.35s")
end

connect(LogService.MessageOut, function(message, messageType)
    if not State.active then
        return
    end
    local kind = tostring(messageType)
    if not string.find(kind, "Error", 1, true) and not string.find(kind, "Warning", 1, true) then
        return
    end
    local text = tostring(message)
    if text == State.lastEngineMessage then
        State.lastEngineRepeat += 1
        if State.lastEngineRepeat == 1 or State.lastEngineRepeat == 5 or State.lastEngineRepeat % 25 == 0 then
            log("ENGINE " .. kind .. " repeated x" .. tostring(State.lastEngineRepeat + 1) .. ": " .. text)
        end
        return
    end
    State.lastEngineMessage = text
    State.lastEngineRepeat = 0
    log("ENGINE " .. kind .. ": " .. text)
end, "LogService errors")

task.spawn(function()
    while State.active do
        pcall(function()
            discoverGui()
            local rig, role = getVisualRig()
            local character = getPlayerCharacter()
            watchModel(rig, "visual rig " .. tostring(role))
            watchModel(character, "player character")

            local id = select(1, getEquippedId())
            if id ~= State.lastEquipped then
                log("LOADOUT POLL CHANGE: " .. tostring(State.lastEquipped) .. " -> " .. tostring(id))
                State.lastEquipped = id
                captureBurst("loadout poll id=" .. tostring(id))
            end
        end)
        task.wait(0.35)
    end
end)

log("READY: reproduce once in the round; F9 marks phase, F10 stops and copies.")
