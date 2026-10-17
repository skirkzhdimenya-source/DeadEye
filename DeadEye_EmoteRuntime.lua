--// DeadEye EmoteRuntime module
--// Runtime replacement state + checkState in an independent chunk.

return function(ctx)
    local genv = ctx.genv
    local isEnabled = ctx.isEnabled
    local EmoteService = ctx.EmoteService
    local originalAnimationIds = ctx.originalAnimationIds

    local currentCustomEmote = nil
    local currentOriginalId = nil
    local currentReplaceId = nil
    local replacementRunning = false
    local replacementGeneration = 0
    local lastRegistryEmote = 0
    local failedOriginalId = nil
    local failedReplaceId = nil

--// CURRENT EMOTE
--// =========================================================
local function getCurrentEmoteId(object)
    if not object then
        return 0
    end
    local value = 0
    pcall(function()
        value =
            object.DataRegistry:Get(
                "Emote"
            )
    end)
    return value or 0
end

-- The game owns its active emote on Character.Animations, not on the
-- top-level Character object. Keep all replacement lifecycle operations there.
local function getAnimationsController(object)
    if not object then
        return nil
    end
    local success, controller = pcall(function()
        return object.Animations
    end)
    if success and type(controller) == "table" then
        return controller
    end
    return nil
end

--// =========================================================
--// GET RIG MODEL
--// =========================================================
local function getRigModel(object)
    if not object
        or not object.Rig then
        return nil
    end
    local success, result =
        pcall(function()
            return object.Rig:GetRigModel()
        end)
    if success then        return result
    end
    return nil
end
--// =========================================================
--// LOCK NATIVE SELECTION VARIANT
--// =========================================================
local function resolveReplacementSelectionIndex(object, replaceModule)
    -- Custom EmoteModule scripts may implement their own selection rules.
    if replaceModule:FindFirstChild("EmoteModule") then
        return nil
    end

    local selection = replaceModule:FindFirstChild("Selection")
    if not selection then
        return nil
    end

    local selectionCount = #selection:GetChildren()
    if selectionCount < 1 then
        return nil
    end

    local dataRegistry = object and object.DataRegistry
    if not dataRegistry then
        return 1
    end

    -- Native Emote.GetSelection waits up to three seconds for EmoteNum and
    -- then falls back to Selection:GetChildren()[1]. Resolve that value once
    -- before stopping the native emote so this wait cannot freeze playback.
    local startedAt = tick()
    local emoteNum = 0

    repeat
        local readOK, value = pcall(function()
            return dataRegistry:Get("EmoteNum")
        end)
        emoteNum = readOK and (tonumber(value) or 0) or 0

        if emoteNum ~= 0 then
            -- The native method checks the timeout after observing a value,
            -- so a value arriving at/after the deadline still falls back to 1.
            if tick() - startedAt >= 3 then
                return 1
            end

            if emoteNum >= 1
                and emoteNum <= selectionCount
                and emoteNum % 1 == 0 then
                return emoteNum
            end

            -- The original index does not exist on the replacement.
            return 1
        end

        if tick() - startedAt >= 3 then
            return 1
        end

        task.wait()
    until false
end

local function getEmoteInitController(object, replaceModule, controller, selectedIndex)
    -- Custom EmoteModule implementations and non-Selection emotes receive
    -- the original controller, exactly as before.
    if replaceModule:FindFirstChild("EmoteModule") then
        return controller
    end

    local selection = replaceModule:FindFirstChild("Selection")
    if not selection then
        return controller
    end

    local selectionCount = #selection:GetChildren()
    local dataRegistry = object and object.DataRegistry
    if not dataRegistry or selectionCount < 1 or not selectedIndex then
        return controller
    end

    -- GetAnimations() and SetModel() each call GetSelection(). Give both
    -- calls one immutable EmoteNum snapshot, rather than rereading a mutable
    -- character registry and potentially selecting different children.
    local lockedIndex = selectedIndex
    local registryProxy = {}
    setmetatable(registryProxy, {
        __index = function(_, key)
            if key == "Get" then
                return function(_, term)
                    if term == "EmoteNum" then
                        return lockedIndex
                    end
                    return dataRegistry:Get(term)
                end
            end

            local value = dataRegistry[key]
            if type(value) == "function" then
                return function(_, ...)
                    return value(dataRegistry, ...)
                end
            end
            return value
        end
    })

    return setmetatable({
        DataRegistry = registryProxy
    }, {
        __index = controller
    })
end

--// =========================================================
--// GET CONTROLLERS
-- =========================================================
local function getControllers(object)
    local result = {}
    local seen = {}
    if not object then
        return result
    end
    local function addController(controller)
        if controller
            and not seen[controller] then
            seen[controller] = true
            table.insert(
                result,
                controller
            )
        end
    end
    local character =
        object.Model
    local rig =
        getRigModel(object)
    for _, root in ipairs({
        character,
        rig
    }) do
        if root then
            addController(
                root:FindFirstChildOfClass(
                    "Humanoid"
                )
            )
            addController(
                root:FindFirstChildOfClass(
                    "AnimationController"
                )
            )
            for _, descendant in ipairs(
                root:GetDescendants()
            ) do
                if descendant:IsA("Humanoid")
                    or descendant:IsA(
                        "AnimationController"
                    ) then
                    addController(
                        descendant
                    )
                end
            end
        end
    end
    return result
end
--// =========================================================
--// GET CURRENT PLAYING TRACKS
-- =========================================================
local function getPlayingTracks(object)
    local result = {}
    for _, controller in ipairs(
        getControllers(object)
    ) do
        local success, tracks =
            pcall(function()
                return controller:
                    GetPlayingAnimationTracks()
            end)
        if success and tracks then
            for _, track in ipairs(
                tracks
            ) do
                table.insert(
                    result,
                    track
                )
            end
        end
    end
    return result
end
--// =========================================================
--// STOP ORIGINAL TRACKS
-- =========================================================
local function stopOriginalTracks(
    object,
    originalId
)
    if not object then
        return
    end
    local animationSet =
        originalAnimationIds[
            originalId
        ]
    local replacementAnimationIds = {}
    --// Не убивать наши replacement tracks.
    if currentCustomEmote
        and currentCustomEmote.Animations then
        for _, track in pairs(
            currentCustomEmote.Animations
        ) do
            if typeof(track) == "Instance"
                and track:IsA(
                    "AnimationTrack"
                ) then
                local animation =
                    track.Animation
                if animation then
                    local id =
                        normalizeAnimationId(
                            animation.AnimationId
                        )
                    if id then
                        replacementAnimationIds[id] =
                            true
                    end
                end
            end
        end
    end
    for _, track in ipairs(
        getPlayingTracks(object)
    ) do
        local animation =
            track.Animation
        if animation then
            local animationId =
                normalizeAnimationId(
                    animation.AnimationId
                )
            local isOriginal =
                false
            if animationId
                and animationSet
                and animationSet[
                    animationId
                ] then
                isOriginal = true
            end
            if isOriginal
                and not replacementAnimationIds[
                    animationId
                ] then
                pcall(function()
                    track:Stop(0)
                end)
            end
        end
    end
end
--// =========================================================
--// =========================================================
--// STOP ORIGINAL EMOTE SOUNDS
--// =========================================================
local function stopOriginalSounds(object)
    if not object then
        return
    end
    local keepSound = nil
    if currentCustomEmote
        and currentCustomEmote.EmoteSound then
        keepSound =
            currentCustomEmote.EmoteSound
    end
    local seen = {}
    local roots = {
        object.Model,
        getRigModel(object)
    }
    for _, root in ipairs(roots) do
        if root and not seen[root] then
            seen[root] = true
            for _, descendant in ipairs(
                root:GetDescendants()
            ) do
                if descendant:IsA("Sound")
                    and descendant.Name == "EmoteSound"
                    and descendant ~= keepSound then
                    pcall(function()
                        descendant:Stop()
                    end)
                    pcall(function()
                        descendant:Destroy()
                    end)
                end
            end
        end
    end
end
--// STOP EMOTE OBJECT
--// =========================================================
local function stopEmoteObject(emote)
    if not emote then
        return
    end
    pcall(function()
        emote:Deactivate()
    end)
end

local function restoreNativeEmote(object, expectedOriginalId)
    if not object or not expectedOriginalId
        or tonumber(getCurrentEmoteId(object)) ~= tonumber(expectedOriginalId) then
        return
    end

    local controller = getAnimationsController(object)
    -- Do not overwrite a different emote already installed by the game.
    if not controller or controller.Emote ~= nil then
        return
    end

    -- Re-enter the same native path that handles DataRegistry.Emote updates.
    pcall(function()
        object:RegistryTermUpdated("Emote")
    end)
end

--// =========================================================
--// STOP CUSTOM
-- =========================================================
local function stopCustomEmote(restoreNative)
    replacementGeneration = replacementGeneration + 1
    replacementRunning = false

    local object = getCharacterObject()
    local controller = getAnimationsController(object)
    local emoteToStop = currentCustomEmote
    local originalId = currentOriginalId

    if controller and emoteToStop and controller.Emote == emoteToStop then
        controller.Emote = nil
    end

    if emoteToStop then
        stopEmoteObject(emoteToStop)
    end

    currentCustomEmote = nil
    currentOriginalId = nil
    currentReplaceId = nil

    failedOriginalId = nil
    failedReplaceId = nil

    -- When the same original emote is still selected (toggle OFF, mapping
    -- removed, or cleanup), rebuild it through the native Character path.
    -- Do not do this when the registry already moved to a different emote.
    if restoreNative ~= false then
        restoreNativeEmote(object, originalId)
    end
end
--// CREATE REPLACEMENT
--// =========================================================
local function createReplacement(
    object,
    replaceId,
    selectedIndex,
    preparedModule
)
    local replaceModule = preparedModule or
        prepareReplaceModule(
            replaceId
        )
    if not replaceModule then
        warn(
            "[EmoteSwapper] Replace not found:",
            replaceId
        )
        return nil
    end
    local character = object.Model
    local rigModel = getRigModel(object)
    local animationsController = getAnimationsController(object)
    if not character or not rigModel or not animationsController then
        return nil
    end
    local emoteInitController = getEmoteInitController(
        object,
        replaceModule,
        animationsController,
        selectedIndex
    )
    local success, result =
        pcall(function()
            return EmoteService:SetEmote(
                character,
                replaceModule,
                false,
                emoteInitController,
                nil,
                rigModel
            )
        end)
    if not success then
        warn(
            "[EmoteSwapper] SetEmote error:",
            result
        )
        return nil
    end
    return result
end
--// =========================================================
--// START REPLACEMENT
-- =========================================================
local function startReplacement(
    object,
    slot
)
    if replacementRunning then
        return
    end
    if not slot then
        return
    end
    if not slot.originalId
        or not slot.replaceId then
        return
    end
    replacementRunning = true
    replacementGeneration =
        replacementGeneration + 1
    local myGeneration =
        replacementGeneration
    local originalId =
        slot.originalId
    local replaceId =
        slot.replaceId
    task.spawn(function()
        --// Даём штатному коду игры создать оригинал
        task.wait()
        if not genv.EMOTE_SWAPPER_RUNNING
            or not isEnabled() then
            replacementRunning = false
            return
        end
        if myGeneration ~=
            replacementGeneration then
            replacementRunning = false
            return
        end
        local liveSlot = getSlotByOriginalId(originalId)
        if tonumber(getCurrentEmoteId(object)) ~= tonumber(originalId)
            or getCharacterObject() ~= object
            or not liveSlot
            or tonumber(liveSlot.replaceId) ~= tonumber(replaceId) then
            replacementRunning = false
            return
        end

        local replaceModule = prepareReplaceModule(replaceId)
        if not replaceModule then
            failedOriginalId = originalId
            failedReplaceId = replaceId
            replacementRunning = false
            return
        end

        -- Resolve the replacement's variant while the native emote is still
        -- alive. The value is then reused for both animation and visual model.
        local selectedIndex = resolveReplacementSelectionIndex(object, replaceModule)

        local liveSlotAfterResolve = getSlotByOriginalId(originalId)
        if myGeneration ~= replacementGeneration
            or not isEnabled()
            or tonumber(getCurrentEmoteId(object)) ~= tonumber(originalId)
            or getCharacterObject() ~= object
            or not liveSlotAfterResolve
            or tonumber(liveSlotAfterResolve.replaceId) ~= tonumber(replaceId) then
            replacementRunning = false
            return
        end

        local animationsController = getAnimationsController(object)
        if not animationsController then
            replacementRunning = false
            return
        end

        --// =================================================
        --// STOP THE NATIVE CONTROLLER'S CURRENT EMOTE
        --// =================================================
        local nativeEmote = animationsController.Emote
        if nativeEmote and nativeEmote ~= currentCustomEmote then
            stopEmoteObject(nativeEmote)
            animationsController.Emote = nil
        end
        --// =================================================
        --// ГАСИМ ОРИГИНАЛЬНЫЕ TRACKS
        --// =================================================
        stopOriginalTracks(
            object,
            originalId
        )
        stopOriginalSounds(
            object
        )
        --// =================================================
        --// СОЗДАЁМ REPLACEMENT
        --// =================================================
        local replacement =
            createReplacement(
                object,
                replaceId,
                selectedIndex,
                replaceModule
            )
        if not replacement then
            failedOriginalId = originalId
            failedReplaceId = replaceId
            restoreNativeEmote(object, originalId)
            replacementRunning = false
            return
        end
        local liveSlot = getSlotByOriginalId(originalId)
        if myGeneration ~= replacementGeneration
            or not isEnabled()
            or tonumber(getCurrentEmoteId(object)) ~= tonumber(originalId)
            or getCharacterObject() ~= object
            or not liveSlot
            or tonumber(liveSlot.replaceId) ~= tonumber(replaceId) then
            stopEmoteObject(replacement)
            restoreNativeEmote(object, originalId)
            replacementRunning = false
            return
        end

        -- A native RegistryTermUpdated("Emote") may have run while SetEmote
        -- was creating the replacement. Deactivate that instance before
        -- installing ours, otherwise its sound/tracks can remain alive.
        local currentControllerEmote = animationsController.Emote
        if currentControllerEmote and currentControllerEmote ~= replacement then
            stopEmoteObject(currentControllerEmote)
        end

        currentCustomEmote = replacement
        currentOriginalId = originalId
        currentReplaceId = replaceId
        failedOriginalId = nil
        failedReplaceId = nil
        animationsController.Emote = replacement
        stopOriginalSounds(
            object
        )
        --// Сохраняем штатное состояние
        pcall(function()
            object:RegistryTermUpdated(
                "State"
            )
        end)
                replacementRunning = false
    end)
end
--// =========================================================
--// MAIN STATE WATCHER
-- =========================================================
local function checkState()
    if not genv.EMOTE_SWAPPER_RUNNING then
        return
    end

    local object = getCharacterObject()
    if not object then
        if currentCustomEmote then
            stopCustomEmote(false)
        end
        return
    end

    local emoteId = tonumber(getCurrentEmoteId(object)) or 0
    if emoteId == 0 then
        if currentCustomEmote then
            stopCustomEmote(false)
        end
        failedOriginalId = nil
        failedReplaceId = nil
        lastRegistryEmote = 0
        return
    end

    -- A stopped swap must leave the native emote alone and must not restart
    -- a replacement merely because the original ID remains in DataRegistry.
    if not isEnabled() then
        if currentCustomEmote then
            stopCustomEmote(true)
        end
        return
    end

    -- A new registry ID means the previous custom emote belongs to an old
    -- selection. Stop it without rebuilding that old ID over the new one.
    if currentCustomEmote
        and tonumber(currentOriginalId) ~= emoteId then
        stopCustomEmote(false)
    end

    local slot = getSlotByOriginalId(emoteId)
    if not slot then
        if currentCustomEmote then
            stopCustomEmote(true)
        end
        failedOriginalId = nil
        failedReplaceId = nil
        lastRegistryEmote = emoteId
        return
    end

    if failedOriginalId
        and (failedOriginalId ~= emoteId or failedReplaceId ~= slot.replaceId) then
        failedOriginalId = nil
        failedReplaceId = nil
    end

    if failedOriginalId == emoteId and failedReplaceId == slot.replaceId then
        local controller = getAnimationsController(object)
        if controller and controller.Emote == nil then
            restoreNativeEmote(object, emoteId)
        end
        lastRegistryEmote = emoteId
        return
    end

    -- If the configured replacement failed to resolve/create, leave the
    -- native emote playing until the ID/mapping changes or the user resets.
    if not currentCustomEmote and not replacementRunning then
        startReplacement(object, slot)
        lastRegistryEmote = emoteId
        return
    end

    if currentCustomEmote then
        local controller = getAnimationsController(object)
        if controller then
            local activeEmote = controller.Emote
            if activeEmote ~= currentCustomEmote then
                if activeEmote then
                    stopEmoteObject(activeEmote)
                end

                if currentCustomEmote.Active == false then
                    stopCustomEmote(false)
                    startReplacement(object, slot)
                    lastRegistryEmote = emoteId
                    return
                end

                controller.Emote = currentCustomEmote
            end
        end

        -- Suppress any original tracks/sound reintroduced by a native refresh,
        -- while leaving the replacement object's own tracks and sound intact.
        stopOriginalTracks(object, emoteId)
        stopOriginalSounds(object)
    end

    lastRegistryEmote = emoteId
end

    return {
        checkState = checkState,
        stopCustomEmote = stopCustomEmote,
        stopForCleanup = function()
            stopCustomEmote(true)
            lastRegistryEmote = 0
        end,
        getCurrentOriginalId = function()
            return currentOriginalId
        end,
        reset = function()
            lastRegistryEmote = 0
            failedOriginalId = nil
            failedReplaceId = nil
        end
    }
end
