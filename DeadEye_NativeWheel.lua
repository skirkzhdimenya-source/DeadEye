--// DeadEye NativeWheel module

return function(__ctx)
    local SLOT_COUNT = __ctx.SLOT_COUNT
    local slots = __ctx.slots
    local genv = __ctx.genv
    local LocalPlayer = __ctx.LocalPlayer
    local prepareOriginalModule = __ctx.prepareOriginalModule
    local prepareReplaceModule = __ctx.prepareReplaceModule
    local getEmoteName = __ctx.getEmoteName
    local createEmotePreview = __ctx.createEmotePreview

    local nativeWheelStates = {}
    local nativeWheelRestoreDone = false

--// NATIVE EMOTE WHEEL VISUAL SWAP
--//
--// The game has two native wheels:
--//   Wheel  = first/default six emotes
--//   Wheel2 = second six emotes shown with Q
--//
--// IMPORTANT:
--// The native UI can recreate Emote1..Emote6. Therefore state
--// is stored by logical position (Wheel:1 / Wheel2:4), while
--// the current GUI Instance is tracked separately.
local function getNativeEmoteWheels()
    local playerGui =
        __ctx.LocalPlayer:FindFirstChild(
            "PlayerGui"
        )

    if not playerGui then
        return {}
    end

    local gameGui =
        playerGui:FindFirstChild(
            "Game"
        )

    local hud =
        gameGui
        and gameGui:FindFirstChild(
            "HUD"
        )

    local interactors =
        hud
        and hud:FindFirstChild(
            "Interactors"
        )

    local popups =
        interactors
        and interactors:FindFirstChild(
            "Popups"
        )

    local emote =
        popups
        and popups:FindFirstChild(
            "Emote"
        )

    if not emote then
        return {}
    end

    local wheels = {}

    for _, wheelName in ipairs({
        "Wheel",
        "Wheel2"
    }) do
        local wheel =
            emote:FindFirstChild(
                wheelName
            )

        if wheel
            and wheel:IsA("GuiObject")
        then
            table.insert(
                wheels,
                wheel
            )
        end
    end

    return wheels
end

local function normalizeEmoteName(
    name
)
    name =
        tostring(
            name or ""
        )

    if name == "" then
        return ""
    end

    -- Native display names can contain spaces while module
    -- names may not (Bold March / BoldMarch).
    return string.lower(
        (
            name
                :gsub(
                    "[%s_%-%'%.]",
                    ""
                )
        )
    )
end

local function getNativeEmoteStateKey(
    wheel,
    index
)
    return tostring(
        wheel.Name
    )
        .. ":"
        .. tostring(index)
end

local function getConfiguredSlotByOriginalName(
    name
)
    local normalizedName =
        normalizeEmoteName(
            name
        )

    if normalizedName == "" then
        return nil
    end

    for i = 1, __ctx.SLOT_COUNT do
        local slot =
            __ctx.slots[i]

        if slot
            and slot.originalId
            and slot.replaceId
            and normalizeEmoteName(
                slot.originalName
                    or __ctx.getEmoteName(
                        slot.originalId
                    )
            ) == normalizedName
        then
            return slot, i
        end
    end

    return nil
end

local function restoreNativeEmoteSlot(
    nativeSlot,
    state
)
    if not nativeSlot
        or not state
    then
        return
    end

    local textLabel =
        nativeSlot:FindFirstChild(
            "TextLabel"
        )

    local viewport =
        nativeSlot:FindFirstChild(
            "ViewportFrame"
        )

    -- Always restore from the persistent logical snapshot.
    -- Do not care what TextLabel currently says: native UI may
    -- already have redrawn/reused this slot.
    local originalModule =
        __ctx.prepareOriginalModule(
            state.originalId
        )

    if viewport
        and originalModule
    then
        pcall(function()
            __ctx.createEmotePreview(
                originalModule,
                viewport
            )
        end)
    end

    if textLabel then
        pcall(function()
            textLabel.Text =
                state.originalName
                or __ctx.getEmoteName(
                    state.originalId
                )
                or textLabel.Text
        end)
    end

    -- Remember the current GUI Instance for the next ON cycle.
    state.instance =
        nativeSlot
end

local function restoreNativeEmoteWheel(
    force
)
    if nativeWheelRestoreDone
        and not force
    then
        return
    end

    local wheels =
        getNativeEmoteWheels()

    for _, wheel in ipairs(
        wheels
    ) do
        for i = 1, 6 do
            local key =
                getNativeEmoteStateKey(
                    wheel,
                    i
                )

            local state =
                nativeWheelStates[
                    key
                ]

            local nativeSlot =
                wheel:FindFirstChild(
                    "Emote"
                    .. tostring(i)
                )

            if state
                and nativeSlot
            then
                pcall(function()
                    restoreNativeEmoteSlot(
                        nativeSlot,
                        state
                    )
                end)
            end
        end
    end

    nativeWheelRestoreDone = true
end


local function applyNativeEmoteSlot(
    nativeSlot,
    slot
)
    nativeWheelRestoreDone = false

    if not nativeSlot
        or not slot
        or not slot.originalId
        or not slot.replaceId
    then
        return false
    end

    local textLabel =
        nativeSlot:FindFirstChild(
            "TextLabel"
        )

    local viewport =
        nativeSlot:FindFirstChild(
            "ViewportFrame"
        )

    if not textLabel
        or not viewport
    then
        return false
    end

    local replaceModule =
        __ctx.prepareReplaceModule(
            slot.replaceId
        )

    if not replaceModule then
        return false
    end

    local replacementName =
        slot.replaceName
        or replaceModule.Name
        or __ctx.getEmoteName(
            slot.replaceId
        )

    if not replacementName then
        return false
    end

    local previewOk = false

    local success =
        pcall(function()
            previewOk =
                __ctx.createEmotePreview(
                    replaceModule,
                    viewport
                )
        end)

    if not success
        or not previewOk
    then
        return false
    end

    pcall(function()
        textLabel.Text =
            replacementName
    end)

    return true
end

local function syncNativeEmoteWheel()
    local wheels =
        getNativeEmoteWheels()

    if #wheels == 0 then
        return
    end

    -- OFF = restore from the persistent logical snapshots.
    if not __ctx.genv.EMOTE_SWAPPER_RUNNING
        or not enabled
    then
        restoreNativeEmoteWheel()
        return
    end

    -- ON = keep both wheels synchronized. State is keyed by
    -- Wheel/EmoteN, while state.instance detects GUI recreation.
    for _, wheel in ipairs(
        wheels
    ) do
        for i = 1, 6 do
            local nativeSlot =
                wheel:FindFirstChild(
                    "Emote"
                    .. tostring(i)
                )

            if not nativeSlot then
                continue
            end

            local textLabel =
                nativeSlot:FindFirstChild(
                    "TextLabel"
                )

            if not textLabel
                or tostring(
                    textLabel.Text
                        or ""
                ) == ""
            then
                continue
            end

            local key =
                getNativeEmoteStateKey(
                    wheel,
                    i
                )

            local state =
                nativeWheelStates[
                    key
                ]

            local configuredSlot =
                nil

            -- Existing logical snapshot tells us exactly which
            -- original belongs to this position.
            if state then
                for slotIndex = 1, __ctx.SLOT_COUNT do
                    local configured =
                        __ctx.slots[slotIndex]

                    if configured
                        and configured.originalId
                            == state.originalId
                    then
                        configuredSlot =
                            configured
                        break
                    end
                end
            end

            -- First sight of a logical position: capture its
            -- current original only when it matches a configured
            -- original emote.
            if not state then
                configuredSlot =
                    getConfiguredSlotByOriginalName(
                        textLabel.Text
                    )

                if configuredSlot then
                    state = {
                        originalId =
                            configuredSlot.originalId,
                        originalName =
                            tostring(
                                textLabel.Text
                                    or ""
                            ),
                        instance =
                            nil
                    }

                    nativeWheelStates[
                        key
                    ] = state
                end
            end

            -- If this position was rebuilt and currently shows a
            -- configured original that is different from the old
            -- snapshot, refresh the logical snapshot.
            if state then
                local currentConfigured =
                    getConfiguredSlotByOriginalName(
                        textLabel.Text
                    )

                if currentConfigured
                    and currentConfigured.originalId
                        ~= state.originalId
                then
                    state.originalId =
                        currentConfigured.originalId
                    state.originalName =
                        tostring(
                            textLabel.Text
                                or ""
                        )
                    state.instance =
                        nil

                    configuredSlot =
                        currentConfigured
                end
            end

            if state
                and not configuredSlot
            then
                for slotIndex = 1, __ctx.SLOT_COUNT do
                    local configured =
                        __ctx.slots[slotIndex]

                    if configured
                        and configured.originalId
                            == state.originalId
                    then
                        configuredSlot =
                            configured
                        break
                    end
                end
            end

            if state
                and configuredSlot
                and configuredSlot.replaceId
            then
                local replacementName =
                    configuredSlot.replaceName
                    or __ctx.getEmoteName(
                        configuredSlot.replaceId
                    )

                if replacementName then
                    local instanceChanged =
                        state.instance
                            ~= nativeSlot

                    local nameChanged =
                        normalizeEmoteName(
                            textLabel.Text
                        )
                        ~= normalizeEmoteName(
                            replacementName
                        )

                    -- Re-apply on a NEW GUI Instance even when its
                    -- TextLabel already contains the replacement name.
                    if instanceChanged
                        or nameChanged
                    then
                        local applied =
                            applyNativeEmoteSlot(
                                nativeSlot,
                                configuredSlot
                            )

                        if applied then
                            state.instance =
                                nativeSlot
                        end
                    end
                end
            elseif state
            then
                -- Configuration was removed/changed.
                restoreNativeEmoteSlot(
                    nativeSlot,
                    state
                )
            end
        end
    end
end

--// =========================================================

    return {
        sync = syncNativeEmoteWheel,
        restore = restoreNativeEmoteWheel,
        reset = function()
            nativeWheelRestoreDone = false
        end
    }
end
