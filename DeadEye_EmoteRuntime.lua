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
--// =========================================================
--// STOP CUSTOM
-- =========================================================
local function stopCustomEmote()
    replacementGeneration =
        replacementGeneration + 1
    replacementRunning = false

    local object =
        getCharacterObject()

    if currentCustomEmote then
        if object
            and object.Emote
            == currentCustomEmote
        then
            object.Emote = nil
        end

        stopEmoteObject(
            currentCustomEmote
        )

        currentCustomEmote =
            nil
    end

    currentOriginalId = nil
    currentReplaceId = nil
end
--// =========================================================
--// CREATE REPLACEMENT
--// =========================================================
local function createReplacement(
    object,
    replaceId
)
    local replaceModule =
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
    local character =
        object.Model
    local rigModel =
        getRigModel(object)
    if not character
        or not rigModel then
        return nil
    end
    local success, result =
        pcall(function()
            return EmoteService:SetEmote(
                character,
                replaceModule,
                false,
                object,
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
            or not enabled then
            replacementRunning = false
            return
        end
        if myGeneration ~=
            replacementGeneration then
            replacementRunning = false
            return
        end
        if getCurrentEmoteId(object)
            ~= originalId then
            replacementRunning = false
            return
        end
        --// =================================================
        --// ГАСИМ ОРИГИНАЛ
        --// =================================================
        if object.Emote
            and object.Emote ~= currentCustomEmote then
            stopEmoteObject(
                object.Emote
            )
            object.Emote = nil
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
                replaceId
            )
        if not replacement then
            replacementRunning = false
            return
        end
        if myGeneration ~=
            replacementGeneration
            or not enabled then
            stopEmoteObject(
                replacement
            )
            replacementRunning = false
            return
        end
        currentCustomEmote =
            replacement
        currentOriginalId =
            originalId
        currentReplaceId =
            replaceId
        object.Emote =
            replacement
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
    local object =
        getCharacterObject()
    if not object then
        return
    end
    local emoteId =
        getCurrentEmoteId(object)
    --// =====================================================
    --// NO EMOTE
    --// =====================================================
    if not emoteId
        or emoteId == 0 then
        if currentCustomEmote then
                    end
        stopCustomEmote()
        lastRegistryEmote = 0
        return
    end
    --// =====================================================
    --// FIND SLOT
    --// =====================================================
    local slot =
        getSlotByOriginalId(
            emoteId
        )
    --// =====================================================
    --// NO SLOT
    --// =====================================================
    if not slot then
        if currentCustomEmote then
            stopCustomEmote()
        end
        lastRegistryEmote =
            emoteId
        return
    end
    --// =====================================================
    --// IMPORTANT FIX:
    --// ЕСЛИ ORIGINAL АКТИВНА, НО REPLACEMENT ПОЧЕМУ-ТО
    --// ПРОПАЛ - ЗАПУСКАЕМ ЕГО СНОВА.
    --// =====================================================
    if not currentCustomEmote
        and not replacementRunning then
        startReplacement(
            object,
            slot
        )
        lastRegistryEmote =
            emoteId
        return
    end
    --// =====================================================
    --// WHILE ACTIVE:
    --// CONTINUOUSLY SUPPRESS ORIGINAL
    --// =====================================================
    if currentCustomEmote then
        stopOriginalTracks(
            object,
            emoteId
        )
        stopOriginalSounds(
            object
        )
        --// Если штатная система снова создала
        --// оригинальный Emote object.
        if object.Emote
            and object.Emote ~= currentCustomEmote then
            stopEmoteObject(
                object.Emote
            )
            object.Emote =
                currentCustomEmote
        end
    end
    lastRegistryEmote =
        emoteId
end
--// =========================================================

    return {
        checkState = checkState,
        stopCustomEmote = stopCustomEmote,
        stopForCleanup = function()
            replacementGeneration =
                replacementGeneration + 1
            replacementRunning = false

            local activeObject =
                getCharacterObject()

            if activeObject
                and currentCustomEmote
                and activeObject.Emote
                    == currentCustomEmote
            then
                pcall(function()
                    activeObject.Emote = nil
                end)
            end

            local emoteToStop =
                currentCustomEmote

            currentCustomEmote = nil
            currentOriginalId = nil
            currentReplaceId = nil

            if emoteToStop then
                task.spawn(function()
                    stopEmoteObject(
                        emoteToStop
                    )
                end)
            end
        end,
        getCurrentOriginalId = function()
            return currentOriginalId
        end,
        reset = function()
            lastRegistryEmote = 0
        end
    }
end
