--// =========================================================
--// EMOTE SWAPPER - 12 SLOTS + SEARCH
--//
--// Каждый слот:
--//   ORIGINAL -> REPLACE
--//
--// По умолчанию:
--//   Slot 1 = Banger (1631) -> RockinStride (51)
--//
--// Основная логика:
--//   1. Нажимаешь оригинальную эмоцию в обычном колесе.
--//   2. Игра сама обрабатывает DataRegistry.Emote.
--//   3. Игра сама включает штатный State/Inert/Weaponless.
--//   4. Скрипт гасит локальную оригинальную анимацию.
--//   5. Локально запускает выбранную эмоцию.
--//   6. Когда оригинальная заканчивается -
--//      replacement тоже заканчивается.
--//
--// GUI:
--//   12 слотов
--//   3 эмоции в ряд в picker
--//   поиск по названию
--//   вертикальный scroll
--//   drag
--//   close button
--// =========================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local __UI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local genv = getgenv and getgenv() or _G
--// =========================================================
--// PREVIOUS INSTANCE CLEANUP
--// =========================================================
if genv.UNUSUAL_SWAPPER_CLEANUP then
    pcall(function()
        genv.UNUSUAL_SWAPPER_CLEANUP()
    end)
end
if genv.DEADEYE_PORTRAIT_CLEANUP then
    pcall(function()
        genv.DEADEYE_PORTRAIT_CLEANUP()
    end)
end
if genv.EMOTE_SWAPPER_CLEANUP then
    pcall(function()
        genv.EMOTE_SWAPPER_CLEANUP()
    end)
end
genv.DEADEYE_MAIN_RUNNING = true
genv.EMOTE_SWAPPER_RUNNING = true
genv.DEADEYE_PORTRAIT_RUNNING = true
--// =========================================================
--// SERVICES
--// =========================================================
__UI.CharacterService = require(
    ReplicatedStorage.Services.Asset.CharacterService
)
__UI.ClientItemService = require(
    ReplicatedStorage.Services.Items.ClientItemService
)
__UI.EmoteService = require(
    ReplicatedStorage.Services.Items.EmoteService
)
local Registry = require(
    ReplicatedStorage.Items.Registry
)
local HttpService = game:GetService("HttpService")
--// =========================================================
--// SETTINGS
--// =========================================================
local SLOT_COUNT = 12
local CONFIG_FILE = "DeadEye_Config.json"
local savedConfig = {
    version = 1,
    emotes = {},
    unusual = {},
    others = {},
    main = {
        jumpDelay = 0.01,
        hotkey = "Z",
        hideUIHotkey = "H"
    },
    gui = {
        x = 35,
        y = 80,
        width = 455,
        height = 320
    }
}
local function loadSavedConfig()
    if type(readfile) ~= "function" then
        return
    end
    local success, raw
    if type(isfile) == "function" then
        local exists = false
        pcall(function()
            exists = isfile(CONFIG_FILE)
        end)
        if not exists then
            return
        end
    end
    success, raw =
        pcall(function()
            return readfile(
                CONFIG_FILE
            )
        end)
    if not success
        or type(raw) ~= "string"
        or raw == ""
    then
        return
    end
    local decodeSuccess, decoded =
        pcall(function()
            return HttpService:JSONDecode(
                raw
            )
        end)
    if not decodeSuccess
        or type(decoded) ~= "table"
    then
        warn(
            "[DeadEye] Invalid config file, using defaults"
        )
        return
    end
    if type(decoded.emotes) == "table" then
        savedConfig.emotes =
            decoded.emotes
    end
    if type(decoded.unusual) == "table" then
        savedConfig.unusual =
            decoded.unusual
    end
    if type(decoded.others) == "table" then
        savedConfig.others =
            decoded.others
    end
    if type(decoded.main) == "table" then
        savedConfig.main =
            decoded.main
    end
    savedConfig.main.hideUIHotkey =
        savedConfig.main.hideUIHotkey
        or "H"

    if type(decoded.gui) == "table" then
        savedConfig.gui = savedConfig.gui or {}

        savedConfig.gui.x =
            tonumber(decoded.gui.x)
            or savedConfig.gui.x
            or 35

        savedConfig.gui.y =
            tonumber(decoded.gui.y)
            or savedConfig.gui.y
            or 80

        savedConfig.gui.width =
            tonumber(decoded.gui.width)
            or savedConfig.gui.width
            or 455

        savedConfig.gui.height =
            tonumber(decoded.gui.height)
            or savedConfig.gui.height
            or 320
    end

    savedConfig.gui.x =
        tonumber(savedConfig.gui.x) or 35
    savedConfig.gui.y =
        tonumber(savedConfig.gui.y) or 80
    savedConfig.gui.width =
        tonumber(savedConfig.gui.width) or 455
    savedConfig.gui.height =
        tonumber(savedConfig.gui.height) or 320

    savedConfig.version =
        tonumber(decoded.version)
        or 1
end
local function saveSavedConfig()
    if type(writefile) ~= "function" then
        return false
    end
    local success, raw =
        pcall(function()
            return HttpService:JSONEncode(
                savedConfig
            )
        end)
    if not success
        or type(raw) ~= "string"
    then
        warn(
            "[DeadEye] Config encode failed:",
            raw
        )
        return false
    end
    local writeSuccess, writeError =
        pcall(function()
            writefile(
                CONFIG_FILE,
                raw
            )
        end)
    if not writeSuccess then
        warn(
            "[DeadEye] Config save failed:",
            writeError
        )
        return false
    end
    return true
end
loadSavedConfig()
--// =========================================================
--// LOCAL PORTRAIT OVERRIDE
--// =========================================================

local portrait = {
    state = {},
    connections = {},
    watched = {},
    rigSignature = "",
    refreshQueued = false
}

function portrait.getRig()

    local rigs = workspace:FindFirstChild("Rigs")

    if rigs then
        local rig = rigs:FindFirstChild(LocalPlayer.Name)

        if rig and rig:IsA("Model") then
            return rig
        end
    end

    local character = LocalPlayer.Character

    if character and character:IsA("Model") then
        return character
    end

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

    pcall(function()
        clone:PivotTo(
            clone:GetPivot() *
            CFrame.new(-head.Position)
        )
    end)

    local distance = math.max(3, head.Size.Y * 4)

    camera.CFrame = CFrame.lookAt(
        Vector3.new(0, 0.15, distance),
        Vector3.new(0, 0.15, 0)
    )

    return viewport

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
        state.viewport.Visible = state.visible and portrait.visible(source)
        state.viewport.Size = source.Size
        state.viewport.Position = source.Position
        state.viewport.AnchorPoint = source.AnchorPoint
        state.viewport.Rotation = source.Rotation
        state.viewport.ZIndex = source.ZIndex + 1
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

    state.viewport = viewport
    portrait.state[source] = state

    viewport.Parent = source.Parent
    source.Visible = false
    source.ImageTransparency = 1

    if source:IsA("ImageButton") then
        source.HoverImage = ""
        source.PressedImage = ""
        source.DisabledImage = ""
    end

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
                state.viewport.Visible = state.visible and portrait.visible(source)
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

    for _, obj in ipairs(playerGui:GetDescendants()) do
        portrait.watch(obj)
    end

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

end

genv.DEADEYE_PORTRAIT_CLEANUP = portrait.cleanup

--// =========================================================
--// SLOTS
--// =========================================================
local slots = {}
for i = 1, SLOT_COUNT do
    slots[i] = {
        originalId = nil,
        replaceId = nil,
        originalName = nil,
        replaceName = nil
    }
end
--// DEFAULT SLOT
slots[1].originalId = 1631
slots[1].replaceId = 51
slots[1].originalName = "Banger"
slots[1].replaceName = "RockinStride"
--// Load saved Emote mappings.
for i = 1, SLOT_COUNT do
    local saved =
        savedConfig.emotes[i]
    if type(saved) == "table" then
        local originalId =
            tonumber(saved.originalId)
        local replaceId =
            tonumber(saved.replaceId)
        if originalId then
            slots[i].originalId =
                originalId
        end
        if replaceId then
            slots[i].replaceId =
                replaceId
        end
    end
end
--// =========================================================
--// RUNTIME STATE
--// =========================================================
local enabled = false
local currentCustomEmote = nil
local currentOriginalId = nil
local currentReplaceId = nil
local replacementRunning = false
local replacementGeneration = 0
local lastRegistryEmote = 0
local cleaned = false
local connections = {}

--// Native wheel visual state.
--// Keys are logical wheel positions ("Wheel:1", "Wheel2:4"),
--// not GUI Instances. The game can recreate Emote1..Emote6;
--// logical state survives those recreations and repeated ON/OFF.
local nativeWheelStates = {}
--// =========================================================
--// CACHE
--// =========================================================
local originalModules = {}
local replaceModules = {}
-- [originalId] = { [animationId] = true }
local originalAnimationIds = {}
local emoteList = {}
--// =========================================================
--// GUI STATE
--// =========================================================
local ScreenGui
local Main
local SlotsScroll
local Picker
local PickerScroll
local PickerSearch
local PickerTitle
local PickerClose
local Status
local Toggle
local activePickerSlot = nil
local activePickerSide = nil
local slotOriginalButtons = {}
local slotReplaceButtons = {}
local pickerButtons = {}
--// =========================================================
--// CONNECTION HELPER
--// =========================================================
local function addConnection(connection)
    table.insert(connections, connection)
end
local function disconnectAll()
    for _, connection in ipairs(connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(connections)
end
--// =========================================================
--// NORMALIZE ANIMATION ID
--// =========================================================
local function normalizeAnimationId(id)
    if not id then
        return nil
    end
    local text = tostring(id)
    local number = string.match(
        text,
        "%d+"
    )
    return number or text
end
--// =========================================================
--// GET ITEM MODULE
--// =========================================================
local function getItemModule(id)
    id = tonumber(id)
    if not id then
        return nil
    end
    local success, result = pcall(function()
        return __UI.ClientItemService:GetItemFromID(id)
    end)
    if success then
        return result
    end
    return nil
end
--// =========================================================
--// BUILD EMOTE LIST
--// =========================================================
local function buildEmoteList()
    table.clear(emoteList)
    local all
    local success, result = pcall(function()
        return Registry.GetAll()
    end)
    if not success then
        warn(
            "[EmoteSwapper] Registry.GetAll error:",
            result
        )
        return
    end
    all = result
    for id, data in pairs(all) do
        if data
            and data.Module
            and data.Categories then
            local isEmote = false
            for _, category in ipairs(
                data.Categories
            ) do
                if category == "Emotes" then
                    isEmote = true
                    break
                end
            end
            if isEmote then
                local numericId =
                    tonumber(id)
                if numericId then
                    table.insert(
                        emoteList,
                        {
                            id = numericId,
                            name = data.Module.Name,
                            module = data.Module
                        }
                    )
                end
            end
        end
    end
    table.sort(
        emoteList,
        function(a, b)
            return a.id < b.id
        end
    )
    end
buildEmoteList()
--// =========================================================
--// PREPARE ORIGINAL MODULE
--// =========================================================
local function prepareOriginalModule(id)
    id = tonumber(id)
    if not id then
        return nil
    end
    if originalModules[id] then
        return originalModules[id]
    end
    local module =
        getItemModule(id)
    if not module then
        return nil
    end
    originalModules[id] =
        module
    local animationSet = {}
    for _, object in ipairs(
        module:GetDescendants()
    ) do
        if object:IsA("Animation") then
            local animationId =
                normalizeAnimationId(
                    object.AnimationId
                )
            if animationId then
                animationSet[animationId] = true
            end
        end
    end
    originalAnimationIds[id] =
        animationSet
    return module
end
--// =========================================================
--// PREPARE REPLACE MODULE
--// =========================================================
local function prepareReplaceModule(id)
    id = tonumber(id)
    if not id then
        return nil
    end
    if replaceModules[id] then
        return replaceModules[id]
    end
    local module =
        getItemModule(id)
    if not module then
        return nil
    end
    replaceModules[id] =
        module
    return module
end
--// =========================================================
--// FIND EMOTE NAME
--// =========================================================
local function getEmoteName(id)
    id = tonumber(id)
    if not id then
        return nil
    end
    for _, data in ipairs(
        emoteList
    ) do
        if data.id == id then
            return data.name
        end
    end
    local module =
        getItemModule(id)
    if module then
        return module.Name
    end
    return nil
end
--// =========================================================
--// PREPARE ALL CONFIGURED SLOTS
--// =========================================================
local function prepareSlots()
    for i = 1, SLOT_COUNT do
        local slot =
            slots[i]
        if slot.originalId then
            local module =
                prepareOriginalModule(
                    slot.originalId
                )
            if module then
                slot.originalName =
                    module.Name
            end
        end
        if slot.replaceId then
            local module =
                prepareReplaceModule(
                    slot.replaceId
                )
            if module then
                slot.replaceName =
                    module.Name
            end
        end
    end
end
prepareSlots()
--// =========================================================
--// CHARACTER OBJECT
--// =========================================================
local function getCharacterObject()
    local object
    local success = pcall(function()
        object =
            __UI.CharacterService:GetLocalCharacter()
    end)
    if not success or not object then
        return nil
    end
    if not object.Model then
        return nil
    end
    if not object.Rig then
        return nil
    end
    return object
end
--// =========================================================
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
            return __UI.EmoteService:SetEmote(
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
--// HELPER: SLOT BY ORIGINAL ID
--// =========================================================
function getSlotByOriginalId(id)
    id = tonumber(id)
    if not id then
        return nil
    end
    for i = 1, SLOT_COUNT do
        local slot =
            slots[i]
        if slot.originalId == id
            and slot.replaceId then
            return slot, i
        end
    end
    return nil
end
--// =========================================================
--// GUI PARENT
--// =========================================================
local guiParent
pcall(function()
    guiParent = gethui()
end)
if not guiParent then
    guiParent =
        game:GetService("CoreGui")
end
--// =========================================================
--// SCREEN GUI
--// =========================================================
ScreenGui =
    Instance.new("ScreenGui")
ScreenGui.Name =
    "EmoteSwapperGUI"
ScreenGui.ResetOnSpawn =
    false
ScreenGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling
ScreenGui.Parent =
    guiParent
--// =========================================================
--// MAIN
--// =========================================================
Main =
    Instance.new("Frame")
Main.Size =
    UDim2.new(
        0,
        math.max(
            455,
            savedConfig.gui.width
        ),
        0,
        math.max(
            285,
            savedConfig.gui.height
        )
    )
Main.Position =
    UDim2.new(
        0,
        savedConfig.gui.x,
        0,
        savedConfig.gui.y
    )
Main.BackgroundColor3 =
    Color3.fromRGB(
        18,
        20,
        24
    )
Main.BackgroundTransparency =
    1
Main.BorderSizePixel =
    0
Main.ClipsDescendants =
    true
Main.Parent =
    ScreenGui

local MainSurface =
    Instance.new("Frame")

MainSurface.Name =
    "MainSurface"

MainSurface.Size =
    UDim2.new(
        1,
        -2,
        1,
        -2
    )

MainSurface.Position =
    UDim2.new(
        0,
        1,
        0,
        1
    )

MainSurface.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )

MainSurface.BackgroundTransparency =
    0.10

MainSurface.BorderSizePixel =
    0

MainSurface.ZIndex =
    0

MainSurface.ClipsDescendants =
    true

MainSurface.Parent =
    Main

local MainSurfaceCorner =
    Instance.new("UICorner")

MainSurfaceCorner.CornerRadius =
    UDim.new(
        0,
        12
    )

MainSurfaceCorner.Parent =
    MainSurface

local MainSurfaceStroke =
    Instance.new("UIStroke")

MainSurfaceStroke.Thickness =
    1

MainSurfaceStroke.Transparency =
    0.66

MainSurfaceStroke.Parent =
    MainSurface

__UI.MainGradient =
    Instance.new("UIGradient")
__UI.MainGradient.Rotation =
    115
__UI.MainGradient.Color =
    ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(
                55,
                61,
                72
            )
        ),
        ColorSequenceKeypoint.new(
            0.42,
            Color3.fromRGB(
                38,
                43,
                51
            )
        ),
        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(
                24,
                28,
                34
            )
        )
    })
__UI.MainGradient.Transparency =
    NumberSequence.new(0.20)
__UI.MainGradient.Parent =
    MainSurface

--// MainSurface owns the outer rounded shell; keep Main itself fully transparent.

local MainHeader =
    Instance.new("Frame")
MainHeader.Name =
    "MainHeader"
MainHeader.Size =
    UDim2.new(
        1,
        -2,
        0,
        39
    )
MainHeader.Position =
    UDim2.new(
        0,
        1,
        0,
        1
    )
MainHeader.BackgroundColor3 =
    Color3.fromRGB(
        40,
        45,
        53
    )
MainHeader.BackgroundTransparency =
    0.20
MainHeader.BorderSizePixel =
    0
MainHeader.ZIndex =
    1
MainHeader.Parent =
    Main

local MainHeaderCorner =
    Instance.new("UICorner")

MainHeaderCorner.CornerRadius =
    UDim.new(
        0,
        11
    )

MainHeaderCorner.Parent =
    MainHeader

__UI.MainHeaderGradient =
    Instance.new("UIGradient")
__UI.MainHeaderGradient.Rotation =
    90
__UI.MainHeaderGradient.Color =
    ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(
                52,
                57,
                67
            )
        ),
        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(
                34,
                39,
                47
            )
        )
    })
__UI.MainHeaderGradient.Transparency =
    NumberSequence.new(0.18)
__UI.MainHeaderGradient.Parent =
    MainHeader

__UI.MainHeaderLine =
    Instance.new("Frame")
__UI.MainHeaderLine.Name =
    "HeaderAccent"
__UI.MainHeaderLine.Size =
    UDim2.new(
        1,
        -24,
        0,
        1
    )
__UI.MainHeaderLine.Position =
    UDim2.new(
        0,
        12,
        1,
        -1
    )
__UI.MainHeaderLine.BackgroundTransparency =
    1
__UI.MainHeaderLine.Visible =
    false
__UI.MainHeaderLine.BorderSizePixel =
    0
__UI.MainHeaderLine.ZIndex =
    1
__UI.MainHeaderLine.Parent =
    Main

--// =========================================================
--// TITLE
--// =========================================================
local MainTitle =
    Instance.new("TextLabel")
MainTitle.Size =
    UDim2.new(
        1,
        -105,
        0,
        36
    )
MainTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        2
    )
MainTitle.BackgroundTransparency =
    1
MainTitle.Text =
    "DeadEyes v1"
MainTitle.TextSize =
    18
MainTitle.Font =
    Enum.Font.GothamBold
MainTitle.ZIndex =
    2
MainTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
MainTitle.TextXAlignment =
    Enum.TextXAlignment.Left
MainTitle.Parent =
    Main
--// =========================================================
--// MINIMIZE
--// =========================================================
local Minimize =
    Instance.new("TextButton")
Minimize.Size =
    UDim2.new(
        0,
        27,
        0,
        27
    )
Minimize.Position =
    UDim2.new(
        1,
        -65,
        0,
        6
    )
Minimize.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
Minimize.BorderSizePixel =
    0
Minimize.Text =
    "−"
Minimize.TextSize =
    20
Minimize.AutoButtonColor =
    true
Minimize.ZIndex =
    5
Minimize.BackgroundTransparency =
    0.05
Minimize.Font =
    Enum.Font.GothamBold
Minimize.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
Minimize.Parent =
    Main
__UI.MinimizeCorner =
    Instance.new("UICorner")
__UI.MinimizeCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.MinimizeCorner.Parent =
    Minimize
--// =========================================================
--// CLOSE
--// =========================================================
local Close =
    Instance.new("TextButton")
Close.Size =
    UDim2.new(
        0,
        27,
        0,
        27
    )
Close.Position =
    UDim2.new(
        1,
        -32,
        0,
        6
    )
Close.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        50
    )
Close.BackgroundTransparency =
    0.05
Close.BorderSizePixel =
    0
Close.ZIndex =
    5
Close.Text =
    "×"
Close.TextSize =
    27
Close.Font =
    Enum.Font.GothamBold
Close.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
Close.Parent =
    Main

__UI.CloseCorner =
    Instance.new("UICorner")
__UI.CloseCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.CloseCorner.Parent =
    Close

__UI.CloseStroke =
    Instance.new("UIStroke")
__UI.CloseStroke.Thickness =
    1
__UI.CloseStroke.Transparency =
    0.65
__UI.CloseStroke.Parent =
    Close

--// =========================================================
--// STATUS
--// =========================================================
Status =
    Instance.new("TextLabel")
Status.Size =
    UDim2.new(
        0,
        190,
        0,
        20
    )
Status.Position =
    UDim2.new(
        0,
        10,
        0,
        43
    )
Status.BackgroundTransparency =
    1
Status.Text =
    ""
Status.TextSize =
    12
Status.Font =
    Enum.Font.Gotham
Status.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
Status.TextXAlignment =
    Enum.TextXAlignment.Left
Status.Parent =
    Main
--// =========================================================
--// UNUSUAL CATEGORY
--// ONE SLOT
--//
--// [Original] -> [Replace]
--//
--// FX-only local replacement.
--// =========================================================
local unusualSlot = {
    originalId = nil,
    replaceId = 200,
    originalName = nil,
    replaceName = nil
}
local unusualList = {}
local unusualEnabled = false
local unusualActive = false
local unusualPicker
local unusualPickerScroll
local unusualPickerSearch
local unusualPickerTitle
local unusualPickerClose
local unusualPickerButtons = {}
local unusualPickerSide = nil
local unusualIconCache = {}
local unusualIconIdCache = {}

local function normalizeUnusualIconKey(value)
    value = tostring(value or "")
    value = string.lower(value)
    value = string.gsub(value, "[^%w]", "")
    return value
end

local function isLikelyImageKey(key)
    key = string.lower(
        tostring(key or "")
    )

    return string.find(key, "icon", 1, true)
        or string.find(key, "image", 1, true)
        or string.find(key, "thumbnail", 1, true)
        or string.find(key, "thumb", 1, true)
        or string.find(key, "preview", 1, true)
        or string.find(key, "sprite", 1, true)end

local function extractAssetId(value)
    if type(value) == "number" then
        if value ~= 0 then
            return "rbxassetid://" .. tostring(math.floor(value))
        end
        return nil
    end

    if type(value) ~= "string" then
        return nil
    end

    local text = value

    if string.find(
        text,
        "rbxassetid://",
        1,
        true
    )
    or string.find(
        text,
        "rbxthumb://",
        1,
        true
    )
    then
        return text
    end

    local id =
        string.match(
            text,
            "^%s*(%d+)%s*$"
        )

    if id and id ~= "0" then
        return "rbxassetid://" .. id
    end

    return nil
end

local function scanIconValue(
    value,
    preferred,
    depth,
    seen
)
    if depth > 5 then
        return nil
    end

    local direct =
        extractAssetId(
            value
        )

    if direct then
        return direct
    end

    if type(value) ~= "table" then
        return nil
    end

    if seen[value] then
        return nil
    end

    seen[value] = true

    local fallback = nil

    for key, child in pairs(value) do
        local keyString =
            tostring(key)

        if isLikelyImageKey(
            keyString
        )
        then
            local found =
                scanIconValue(
                    child,
                    true,
                    depth + 1,
                    seen
                )

            if found then
                return found
            end
        elseif not preferred then
            local found =
                scanIconValue(
                    child,
                    false,
                    depth + 1,
                    seen
                )

            if found
                and not fallback
            then
                fallback = found
            end
        end
    end

    return fallback
end

local function getUnusualIconFromData(
    numericId,
    registryData,
    module
)
    local candidates = {}

    local config
    pcall(function()
        config =
            Registry.GetConfig(
                numericId
            )
    end)

    if config then
        table.insert(
            candidates,
            config
        )
    end

    if registryData then
        table.insert(
            candidates,
            registryData
        )
    end

    if module then
        pcall(function()
            local attributes =
                module:GetAttributes()

            if type(attributes) == "table" then
                table.insert(
                    candidates,
                    attributes
                )
            end
        end)

        -- Some item ModuleScripts return a metadata table.
        pcall(function()
            local required =
                require(module)

            if type(required) == "table" then
                table.insert(
                    candidates,
                    required
                )
            end
        end)
    end

    for _, candidate in ipairs(
        candidates
    ) do
        local found =
            scanIconValue(
                candidate,
                false,
                0,
                {}
            )

        if found then
            return found
        end
    end

    -- Last direct-object fallback: attributes / StringValue descendants.
    if module then
        for _, obj in ipairs(
            module:GetDescendants()
        ) do
            if obj:IsA("StringValue") then
                local key =
                    obj.Name

                if isLikelyImageKey(
                    key
                )
                then
                    local found =
                        extractAssetId(
                            obj.Value
                        )

                    if found then
                        return found
                    end
                end
            end

            if obj:IsA("IntValue")
                or obj:IsA("NumberValue")
            then
                if isLikelyImageKey(
                    obj.Name
                )
                then
                    local found =
                        extractAssetId(
                            tostring(
                                obj.Value
                            )
                        )

                    if found then
                        return found
                    end
                end
            end
        end
    end

    return nil
end

local function cacheUnusualIconFromObject(icon)
    if not icon
        or not icon:IsA("ImageLabel")
        or icon.Name ~= "IconIMG"
    then
        return
    end

    local image = icon.Image

    if type(image) ~= "string"
        or image == ""
    then
        return
    end

    local node = icon
    local depth = 0
    local names = {}

    while node
        and depth < 10
    do
        if node.Name == "Slot"
            or node.Name == "Button"
            or node.Name == "Slots"
        then
            for _, child in ipairs(
                node:GetDescendants()
            ) do
                if child:IsA("TextLabel")
                    or child:IsA("TextButton")
                then
                    local text =
                        tostring(
                            child.Text
                                or ""
                        )

                    if text ~= "" then
                        table.insert(
                            names,
                            text
                        )
                    end
                end
            end
        end

        node = node.Parent
        depth += 1
    end

    for _, name in ipairs(names) do
        local key =
            normalizeUnusualIconKey(
                name
            )

        if key ~= ""
            and #key >= 3
        then
            unusualIconCache[key] = image
        end
    end
end

local function collectCurrentUnusualIcons(playerGui)
    if not playerGui then
        return
    end

    for _, obj in ipairs(
        playerGui:GetDescendants()
    ) do
        if obj:IsA("ImageLabel")
            and obj.Name == "IconIMG"
        then
            cacheUnusualIconFromObject(obj)
        end
    end
end

local function findNativeUnusualScroll(playerGui)
    local menu =
        playerGui
        and playerGui:FindFirstChild(
            "Menu"
        )

    local views =
        menu
        and menu:FindFirstChild(
            "Views"
        )

    local inventory =
        views
        and views:FindFirstChild(
            "Inventory"
        )

    local selectView =
        inventory
        and inventory:FindFirstChild(
            "Select"
        )

    local center =
        selectView
        and selectView:FindFirstChild(
            "Center"
        )

    local frame =
        center
        and center:FindFirstChild(
            "Frame"
        )

    local list =
        frame
        and frame:FindFirstChild(
            "List"
        )

    local scroll =
        list
        and list:FindFirstChild(
            "ScrollingFrame"
        )

    if scroll
        and scroll:IsA("ScrollingFrame")
    then
        return scroll
    end

    return nil
end

local function preloadNativeUnusualIcons()
    local playerGui =
        LocalPlayer:FindFirstChild(
            "PlayerGui"
        )

    if not playerGui then
        return
    end

    collectCurrentUnusualIcons(
        playerGui
    )

    local scroll =
        findNativeUnusualScroll(
            playerGui
        )

    if not scroll then
        return
    end

    local restoreStates = {}
    local node = scroll

    -- The inventory selector may be completely hidden when the
    -- player's normal menu is closed. Temporarily reveal only
    -- the existing UI hierarchy so its virtualized slots can load.
    while node
        and node ~= playerGui
    do
        if node:IsA("GuiObject") then
            table.insert(
                restoreStates,
                {
                    object = node,
                    kind = "Visible",
                    value = node.Visible
                }
            )
            node.Visible = true
        elseif node:IsA("LayerCollector") then
            table.insert(
                restoreStates,
                {
                    object = node,
                    kind = "Enabled",
                    value = node.Enabled
                }
            )
            node.Enabled = true
        end

        node = node.Parent
    end

    task.wait(0.10)

    local oldPosition =
        scroll.CanvasPosition

    local steps = 48

    -- The native list is virtualized/recycled.
    -- Walk through the whole canvas so every batch of slots
    -- gets instantiated and its IconIMG enters our cache.
    for i = 0, steps do
        local maxY =
            math.max(
                0,
                scroll.AbsoluteCanvasSize.Y
                    - scroll.AbsoluteWindowSize.Y
            )

        pcall(function()
            scroll.CanvasPosition =
                Vector2.new(
                    oldPosition.X,
                    maxY * (i / steps)
                )
        end)

        RunService.Heartbeat:Wait()
        RunService.Heartbeat:Wait()

        collectCurrentUnusualIcons(
            playerGui
        )
    end

    pcall(function()
        scroll.CanvasPosition =
            oldPosition
    end)

    for i = #restoreStates, 1, -1 do
        local state =
            restoreStates[i]

        pcall(function()
            if state.kind == "Visible" then
                state.object.Visible =
                    state.value
            elseif state.kind == "Enabled" then
                state.object.Enabled =
                    state.value
            end
        end)
    end

    collectCurrentUnusualIcons(
        playerGui
    )
end
local unusualPage
local unusualStatus
local categoryBar
local mainCategoryButton
local emoteCategoryButton
local unusualCategoryButton
local othersCategoryButton
local currentCategory = "Emotes"
local mainPage
local others = {}
local mainMinimized = false
local setMainMinimized
local updateUnusualToggle
others.originalDescription = nil
others.targetHumanoid = nil
others.page = nil
others.status = nil
others.fieldButtons = {}
others.fieldBoxes = {}
local unusualConnections = {}
local unusualDestroyed = false
local unusualReapplyBusy = false
local unusualRuntime = {
    appliedRig = nil,
    reapplyGeneration = 0,
    animationSource = nil,
    animationLinks = {},
    visualMirrors = {},
    specialCircling = nil,
    animatedNestedVisuals = {}
}
--// =========================================================
--// UNUSUAL CONNECTION HELPER
--// =========================================================
local function addUnusualConnection(connection)
    table.insert(
        unusualConnections,
        connection
    )
end
local function disconnectUnusualConnections()
    for _, connection in ipairs(
        unusualConnections
    ) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(
        unusualConnections
    )

    unusualReapplyBusy = false
end
--// =========================================================
--// UNUSUAL LIST
--// =========================================================
local function buildUnusualList()
    table.clear(
        unusualList
    )
    local success, all = pcall(function()
        return Registry.GetAll()
    end)
    if not success
        or not all
    then
        warn(
            "[UnusualSwapper] Registry.GetAll error:",
            all
        )
        return
    end
    local seen = {}
    for id, data in pairs(all) do
        local numericId =
            tonumber(id)
        if numericId
            and not seen[numericId]
        then
            local config
            pcall(function()
                config =
                    Registry.GetConfig(
                        numericId
                    )
            end)
            local equipInfo =
                type(config) == "table"
                and config.EquipInfo
                or nil
            if type(equipInfo) == "table"
                and equipInfo.SlotType == "Unusual"
            then
                local module =
                    data
                    and data.Module
                if not module then
                    pcall(function()
                        local entry =
                            Registry.GetById(
                                numericId
                            )
                        if entry then
                            module =
                                entry.Module
                        end
                    end)
                end
                if module then
                    seen[numericId] = true
                    local icon =
                        getUnusualIconFromData(
                            numericId,
                            data,
                            module
                        )

                    if icon then
                        unusualIconIdCache[
                            numericId
                        ] = icon
                    end

                    table.insert(
                        unusualList,
                        {
                            id = numericId,
                            name = module.Name,
                            module = module,
                            icon = icon
                        }
                    )
                end
            end
        end
    end
    table.sort(
        unusualList,
        function(a, b)
            return a.id < b.id
        end
    )

    local iconCount = 0

    for _, data in ipairs(
        unusualList
    ) do
        if data.icon then
            iconCount += 1
        end
    end

    warn(
        "[DeadEye] Native Unusual icons:",
        tostring(iconCount),
        "/",
        tostring(#unusualList)
    )
    end
buildUnusualList()
--// =========================================================
--// GET UNUSUAL NAME
--// =========================================================
local function getUnusualName(id)
    id =
        tonumber(id)
    if not id then
        return nil
    end
    for _, data in ipairs(
        unusualList
    ) do
        if data.id == id then
            return data.name
        end
    end
    local module =
        getItemModule(id)
    if module then
        return module.Name
    end
    return nil
end
--// =========================================================
--// CURRENT EQUIPPED UNUSUAL
--// =========================================================
local function getEquippedUnusualId()
    local value = 0
    pcall(function()
        value =
            require(
                ReplicatedStorage.Shared.UserData.ClientHooks:WaitForChild("useLoadout")
            ).GetEquippedFromSlot(
                "UnusualSlot"
            )
    end)
    return tonumber(value) or 0
end
--// First run: original = actual equipped Unusual.
do
    local equipped =
        getEquippedUnusualId()
    if equipped ~= 0 then
        unusualSlot.originalId =
            equipped
        unusualSlot.originalName =
            getUnusualName(
                equipped
            )
    end
    local savedUnusual =
        savedConfig.unusual
    if type(savedUnusual) == "table" then
        local savedOriginal =
            tonumber(
                savedUnusual.originalId
            )
        local savedReplace =
            tonumber(
                savedUnusual.replaceId
            )
        if savedOriginal then
            unusualSlot.originalId =
                savedOriginal
            unusualSlot.originalName =
                getUnusualName(
                    savedOriginal
                )
        end
        if savedReplace then
            unusualSlot.replaceId =
                savedReplace
        end
    end
    unusualSlot.replaceName =
        getUnusualName(
            unusualSlot.replaceId
        )
end
--// =========================================================
--// GET REAL PLAYER CHARACTER
--// =========================================================
local function getUnusualPlayerCharacter()
    local folder =
        workspace:FindFirstChild(
            "Players"
        )
    if folder then
        local character =
            folder:FindFirstChild(
                LocalPlayer.Name
            )
        if character then
            return character
        end
    end
    return LocalPlayer.Character
end
--// =========================================================
--// GET VISUAL RIG
--// =========================================================
local function getUnusualVisualRig()
    local folder =
        workspace:FindFirstChild(
            "Rigs"
        )

    if folder then
        local rig =
            folder:FindFirstChild(
                LocalPlayer.Name
            )

        if rig then
            return rig
        end
    end

    local playersFolder =
        workspace:FindFirstChild(
            "Players"
        )

    if playersFolder then
        local character =
            playersFolder:FindFirstChild(
                LocalPlayer.Name
            )

        if character then
            return character
        end
    end

    local menuView =
        workspace:FindFirstChild(
            "MenuView"
        )

    if menuView then
        local visualModel =
            menuView:FindFirstChild(
                "VisualModel"
            )

        if visualModel
            and visualModel:IsA("Model")
            and visualModel:FindFirstChildOfClass(
                "Humanoid"
            )
        then
            return visualModel
        end
    end

    local character =
        LocalPlayer.Character

    if character
        and character:IsA("Model")
    then
        return character
    end

    return nil
end
--// =========================================================
--// GET COSMETIC RIG
--// =========================================================
local function getUnusualCosmeticRig(
    id,
    visualRig
)
    local module =
        getItemModule(id)
    if not module
        or not visualRig
    then
        return nil
    end
    local humanoid =
        visualRig:FindFirstChildOfClass(
            "Humanoid"
        )
    if not humanoid then
        return nil
    end
    if humanoid.RigType
        == Enum.HumanoidRigType.R6
    then
        return module:FindFirstChild(
            "CharacterClassic"
        )
        or module:FindFirstChild(
            "Character"
        )
    end
    return module:FindFirstChild(
        "Character"
    )
    or module:FindFirstChild(
        "CharacterClassic"
    )
end
--// =========================================================
--// FX CLASSES
--// =========================================================
local UNUSUAL_FX_CLASSES = {
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
    BillboardGui = true
}
local function isUnusualFX(object)
    return UNUSUAL_FX_CLASSES[
        object.ClassName
    ] == true
end
local function unusualAttachmentHasFX(
    attachment
)
    for _, descendant in ipairs(
        attachment:GetDescendants()
    ) do
        if isUnusualFX(descendant) then
            return true
        end
    end
    return false
end

--// =========================================================
--// TAG OUR FX
--// =========================================================
local function tagUnusualFX(
    object,
    id
)
    pcall(function()
        object:SetAttribute(
            "DeadEyeUnusualFX",
            true
        )
        object:SetAttribute(
            "DeadEyeUnusualFXID",
            id
        )
    end)
    for _, descendant in ipairs(
        object:GetDescendants()
    ) do
        pcall(function()
            descendant:SetAttribute(
                "DeadEyeUnusualFX",
                true
            )
            descendant:SetAttribute(
                "DeadEyeUnusualFXID",
                id
            )
        end)
    end
end
--// =========================================================
--// MAP ATTACHMENTS
--// =========================================================

local function mapUnusualAttachments(
    source,
    clone,
    map
)

    if source:IsA("Attachment")
        and clone:IsA("Attachment")
    then

        map[source] =
            clone

    end

    for _, sourceChild in ipairs(
        source:GetChildren()
    ) do

        local cloneChild =
            clone:FindFirstChild(
                sourceChild.Name
            )

        if sourceChild:IsA("Attachment")
            and cloneChild
            and cloneChild:IsA("Attachment")
        then

            mapUnusualAttachments(
                sourceChild,
                cloneChild,
                map
            )

        end

    end

end

--// =========================================================
--// NEEDED ATTACHMENTS
--// =========================================================

local function unusualObjectBelongsToPart(
    object,
    sourcePart
)

    local parent =
        object.Parent

    while parent
        and parent ~= sourcePart
    do

        if parent:IsA("BasePart") then
            return false
        end

        parent =
            parent.Parent

    end

    return parent == sourcePart

end

local function getNeededUnusualAttachments(
    sourcePart)

    local needed = {}

    for _, object in ipairs(
        sourcePart:GetDescendants()
    ) do

        if unusualObjectBelongsToPart(
            object,
            sourcePart
        ) then

            if object:IsA("Trail")
                or object:IsA("Beam")
            then

                if object.Attachment0
                    and unusualObjectBelongsToPart(
                        object.Attachment0,
                        sourcePart
                    )
                then

                    needed[
                        object.Attachment0
                    ] = true

                end

                if object.Attachment1
                    and unusualObjectBelongsToPart(
                        object.Attachment1,
                        sourcePart
                    )
                then

                    needed[
                        object.Attachment1
                    ] = true

                end

            end

        end

    end

    for _, object in ipairs(
        sourcePart:GetDescendants()
    ) do

        if object:IsA("Attachment")
            and unusualObjectBelongsToPart(
                object,
                sourcePart
            )
            and unusualAttachmentHasFX(
                object
            )
        then

            needed[object] =
                true

        end

    end

    local changed = true

    while changed do

        changed = false

        for attachment in pairs(
            needed
        ) do

            local parent =
                attachment.Parent

            if parent
                and parent:IsA("Attachment")
                and not needed[parent]
            then

                needed[parent] =
                    true

                changed = true

            end

        end

    end

    return needed

end

--// =========================================================
--// SOURCE ATTACHMENT WORLD CFRAME
--// =========================================================

local function getUnusualAttachmentWorldCFrame(
    attachment
)

    if not attachment
        or not attachment:IsA("Attachment")
    then

        return nil

    end

    local success, result = pcall(function()
        return attachment.WorldCFrame
    end)

    if success and result then
        return result
    end

    local parent = attachment.Parent

    if parent and parent:IsA("BasePart") then
        return parent.CFrame * attachment.CFrame
    end

    if parent and parent:IsA("Attachment") then

        local parentWorld =
            getUnusualAttachmentWorldCFrame(
                parent
            )

        if parentWorld then
            return parentWorld * attachment.CFrame
        end

    end

    return attachment.CFrame

end

--// =========================================================
--// HAS UNUSUAL CONTENT
--// =========================================================

local function unusualBasePartHasContent(
    sourcePart
)

    for _, object in ipairs(
        sourcePart:GetDescendants()
    ) do

        if unusualObjectBelongsToPart(
            object,
            sourcePart
        ) then

            if isUnusualFX(object) then
                return true
            end

            if object:IsA("Attachment")
                and unusualAttachmentHasFX(
                    object
                )
            then
                return true
            end

        end

    end

    return false

end

--// =========================================================
--// UNUSUAL ANIMATION SOURCE
--// =========================================================
unusualRuntime.destroyAnimationSource = function()
    if unusualRuntime.animationSource then
        pcall(function()
            unusualRuntime.animationSource:Destroy()
        end)
    end

    unusualRuntime.animationSource = nil
    table.clear(
        unusualRuntime.animationLinks
    )

    for _, mirror in ipairs(
        unusualRuntime.visualMirrors
    ) do
        if mirror.model then
            pcall(function()
                mirror.model:Destroy()
            end)
        end
    end

    table.clear(
        unusualRuntime.visualMirrors
    )

    if unusualRuntime.specialCircling
        and unusualRuntime.specialCircling.model
    then
        pcall(function()
            unusualRuntime.specialCircling.model:Destroy()
        end)
    end

    unusualRuntime.specialCircling = nil

    for _, item in ipairs(
        unusualRuntime.animatedNestedVisuals
    ) do
        if item.model then
            pcall(function()
                item.model:Destroy()
            end)
        end
    end

    table.clear(
        unusualRuntime.animatedNestedVisuals
    )
end

unusualRuntime.findRelative = function(
    root,
    object
)
    if not root
        or not object
    then
        return nil
    end

    local names = {}
    local node = object

    while node
        and node ~= root
    do
        table.insert(
            names,
            1,
            node.Name
        )
        node = node.Parent
    end

    if node ~= root then
        return nil
    end

    local current = root

    for _, name in ipairs(
        names
    ) do
        current =
            current:FindFirstChild(
                name
            )

        if not current then
            return nil
        end
    end

    return current
end

unusualRuntime.startAnimations = function(
    root
)
    if not root then
        return false
    end

    local started = false
    local controllers = {}

    for _, object in ipairs(
        root:GetDescendants()
    ) do

        if object:IsA(
            "AnimationController"
        ) then

            local animator =
                object:FindFirstChildOfClass(
                    "Animator"
                )

            if not animator then
                pcall(function()
                    animator =
                        Instance.new(
                            "Animator"
                        )
                    animator.Parent =
                        object
                end)
            end

            if animator then
                controllers[object] =
                    animator
            end

        end

    end

    for _, animation in ipairs(
        root:GetDescendants()
    ) do

        if animation:IsA(
            "Animation"
        ) then

            local controller
            local current =
                animation.Parent

            --// First prefer an AnimationController
            --// directly above this Animation.
            while current
                and current ~= root.Parent
            do

                if current:IsA(
                    "AnimationController"
                ) then

                    controller =
                        current
                    break

                end

                local sibling =
                    current:FindFirstChildOfClass(
                        "AnimationController"
                    )

                if sibling then
                    controller =
                        sibling
                    break
                end

                current =
                    current.Parent

            end

            if controller then

                local animator =
                    controllers[
                        controller
                    ]

                if animator then

                    pcall(function()
                        local track =
                            animator:LoadAnimation(
                                animation
                            )

                        if track then
                            track:Play(0)
                            started = true
                        end

                    end)

                end

            end

        end

    end

    return started
end

unusualRuntime.installAnimatedNestedModels = function(
    cosmeticRig,
    id,
    targetRig,
    playerCharacter
)
    if not cosmeticRig then
        return 0
    end

    local targetRoot

    if targetRig then
        targetRoot =
            targetRig:FindFirstChild(
                "HumanoidRootPart"
            )
    end

    if not targetRoot
        and playerCharacter
    then
        targetRoot =
            playerCharacter:FindFirstChild(
                "HumanoidRootPart"
            )
    end

    if not targetRoot
        or not targetRoot:IsA("BasePart")
    then
        return 0
    end

    local foundModels = {}
    local seen = {}

    for _, object in ipairs(
        cosmeticRig:GetDescendants()
    ) do

        if object:IsA("Model")
            and not seen[object]
        then

            local hasController = false
            local hasAnimation = false
            local hasPart = false

            for _, child in ipairs(
                object:GetDescendants()
            ) do

                if child:IsA(
                    "AnimationController"
                ) then
                    hasController = true
                elseif child:IsA("Animation") then
                    hasAnimation = true
                elseif child:IsA("BasePart") then
                    hasPart = true
                end

            end

            if hasController
                and hasAnimation
                and hasPart
            then

                --// Prefer the smallest animated Model.
                --// If this Model is inside another matching
                --// Model, the inner one is sufficient.
                local parent =
                    object.Parent

                local nestedInside =
                    false

                while parent
                    and parent ~= cosmeticRig
                do

                    if parent:IsA("Model")
                        and table.find(
                            foundModels,
                            parent
                        )
                    then
                        nestedInside = true
                        break
                    end

                    parent =
                        parent.Parent

                end

                if not nestedInside then
                    table.insert(
                        foundModels,
                        object
                    )

                    seen[object] = true
                end

            end

        end

    end

    --// The loop above may encounter outer models before
    --// inner models. Remove any selected model which contains
    --// another selected animated model.
    local selected = {}

    for _, model in ipairs(
        foundModels
    ) do

        local containsSelected =
            false

        for _, other in ipairs(
            foundModels
        ) do

            if model ~= other
                and other:IsDescendantOf(
                    model
                )
            then
                containsSelected = true
                break
            end

        end

        if not containsSelected then
            table.insert(
                selected,
                model
            )
        end

    end

    local installed = 0

    for _, sourceModel in ipairs(
        selected
    ) do

        local clone
        local ok =
            pcall(function()
                clone =
                    sourceModel:Clone()
            end)

        if ok
            and clone
        then

            local root

            for _, name in ipairs({
                "HRP",
                "HumanoidRootPart",
                "Root",
                "RootPart"
            }) do

                local candidate =
                    clone:FindFirstChild(
                        name,
                        true
                    )

                if candidate
                    and candidate:IsA("BasePart")
                then
                    root = candidate
                    break
                end

            end

            if not root then
                root =
                    clone:FindFirstChildWhichIsA(
                        "BasePart",
                        true
                    )
            end

            if root then

                for _, object in ipairs(
                    clone:GetDescendants()
                ) do

                    if object:IsA("BasePart") then

                        pcall(function()
                            object.Anchored = false
                            object.CanCollide = false
                            object.CanTouch = false
                            object.CanQuery = false
                            object.Massless = true
                            object.CastShadow = false

                            --// Registry mini-rigs may inherit a local
                            --// transparency flag from another visual
                            --// context. The cloned animated visual must
                            --// be actually renderable.
                            object.LocalTransparencyModifier = 0
                        end)

                    elseif object:IsA("Script")
                        or object:IsA("LocalScript")
                    then

                        pcall(function()
                            object.Disabled = true
                        end)

                    end

                end

                local hostPart
                local ancestor = sourceModel.Parent

                while ancestor
                    and ancestor ~= cosmeticRig
                do
                    if ancestor:IsA("BasePart") then
                        hostPart = ancestor
                        break
                    end

                    ancestor = ancestor.Parent
                end

                if not hostPart then
                    hostPart =
                        cosmeticRig:FindFirstChild(
                            "HumanoidRootPart"
                        )
                end

                local targetHost

                if hostPart
                    and hostPart:IsA("BasePart")
                then
                    if targetRig then
                        targetHost =
                            targetRig:FindFirstChild(
                                hostPart.Name
                            )
                    end

                    if not targetHost
                        and playerCharacter
                    then
                        targetHost =
                            playerCharacter:FindFirstChild(
                                hostPart.Name
                            )
                    end
                end

                if not targetHost
                    or not targetHost:IsA("BasePart")
                then
                    targetHost = targetRoot
                end

                local sourceRoot =
                    sourceModel:FindFirstChild(
                        root.Name,
                        true
                    )

                local relative = CFrame.new()

                if sourceRoot
                    and sourceRoot:IsA("BasePart")
                    and hostPart
                    and hostPart:IsA("BasePart")
                then
                    relative =
                        hostPart.CFrame:ToObjectSpace(
                            sourceRoot.CFrame
                        )
                end

                --// Move the complete Model, not only its helper
                --// root. This preserves every internal offset exactly
                --// as authored in the registry.
                local modelRelative =
                    hostPart
                    and hostPart:IsA("BasePart")
                    and hostPart.CFrame:ToObjectSpace(
                        sourceModel:GetPivot()
                    )
                    or relative

                pcall(function()
                    clone:PivotTo(
                        targetHost.CFrame *
                        modelRelative
                    )
                end)

                local folder =
                    workspace:FindFirstChild(
                        "DeadEyeUnusualAnimatedVisuals"
                    )

                if not folder then
                    folder =
                        Instance.new("Folder")

                    folder.Name =
                        "DeadEyeUnusualAnimatedVisuals"

                    folder.Parent =
                        workspace
                end

                clone.Name =
                    "DeadEyeAnimated_" ..
                    tostring(id) ..
                    "_" ..
                    tostring(
                        installed + 1
                    )

                clone.Parent =
                    folder

                local weld =
                    Instance.new(
                        "WeldConstraint"
                    )

                weld.Name =
                    "DeadEyeAnimatedRootWeld"

                weld.Part0 =
                    targetHost

                weld.Part1 =
                    root

                weld.Parent =
                    root

                tagUnusualFX(
                    clone,
                    id
                )

                --// Start the same AnimationController
                --// animation that the source effect uses.
                unusualRuntime.startAnimations(
                    clone
                )

                table.insert(
                    unusualRuntime.animatedNestedVisuals,
                    {
                        model = clone,
                        root = root
                    }
                )

                installed += 1

            else

                pcall(function()
                    clone:Destroy()
                end)

            end

        end

    end

    return installed
end


unusualRuntime.createAnimationSource = function(
    cosmeticRig,
    id,
    playerCharacter
)
    unusualRuntime.destroyAnimationSource()

    if not cosmeticRig then
        return nil
    end

    local source
    local ok =
        pcall(function()
            source =
                cosmeticRig:Clone()
        end)

    if not ok
        or not source
    then
        return nil
    end

    source.Name =
        "DeadEyeUnusualRuntime_" ..
        tostring(id)

    local hasClientDriver = false
    local hasLocalScriptDriver = false
    local hasClientScriptDriver = false
    local controllerCount = 0

    for _, object in ipairs(
        source:GetDescendants()
    ) do

        if object:IsA("LocalScript")
            or object:IsA("Script")
        then

            local isClientDriver =
                object:IsA("LocalScript")

            if object:IsA("Script") then
                pcall(function()
                    isClientDriver =
                        object.RunContext ==
                        Enum.RunContext.Client
                end)
            end

            if isClientDriver then
                hasClientDriver = true

                if object:IsA("LocalScript") then
                    hasLocalScriptDriver = true
                else
                    hasClientScriptDriver = true
                end

                pcall(function()
                    object.Disabled = true
                end)

            else
                pcall(function()
                    object:Destroy()
                end)
            end

        elseif object:IsA("AnimationController") then

            controllerCount += 1

        elseif object:IsA("BasePart") then

            --// Runtime source is animation-only. Never render
            --// any geometry from the copied cosmetic rig.
            --// The visible FX/geometry is installed separately
            --// onto the real visual rig.
            pcall(function()
                object.CanCollide = false
                object.CanTouch = false
                object.CanQuery = false
                object.Massless = true
                object.CastShadow = false
                object.Transparency = 1
                object.LocalTransparencyModifier = 1
            end)

        end

    end

    if not hasClientDriver
        and controllerCount == 0
    then
        pcall(function()
            source:Destroy()
        end)
        return nil
    end

    --// Safety pass: the runtime clone must never produce
    --// a second visible Unusual, even for nested geometry.
    for _, object in ipairs(
        source:GetDescendants()
    ) do
        if object:IsA("BasePart") then
            pcall(function()
                object.Transparency = 1
                object.LocalTransparencyModifier = 1
                object.CastShadow = false
                object.CanCollide = false
                object.CanTouch = false
                object.CanQuery = false
            end)
        elseif object:IsA("Decal")
            or object:IsA("Texture")
        then
            pcall(function()
                object.Transparency = 1
            end)
        elseif object:IsA("ParticleEmitter")
            or object:IsA("Trail")
            or object:IsA("Beam")
            or object:IsA("Fire")
            or object:IsA("Smoke")
            or object:IsA("Sparkles")
            or object:IsA("Highlight")
            or object:IsA("BillboardGui")
            or object:IsA("PointLight")
            or object:IsA("SpotLight")
            or object:IsA("SurfaceLight")
        then
            pcall(function()
                object.Enabled = false
            end)
        end
    end

    local root =
        source:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root
        or not root:IsA("BasePart")
    then
        pcall(function()
            source:Destroy()
        end)
        return nil
    end

    local targetRoot

    if playerCharacter then
        targetRoot =
            playerCharacter:FindFirstChild(
                "HumanoidRootPart"
            )
    end

    if not targetRoot then
        local rig =
            getUnusualVisualRig()

        if rig then
            targetRoot =
                rig:FindFirstChild(
                    "HumanoidRootPart"
                )
        end
    end

    if not targetRoot
        or not targetRoot:IsA("BasePart")
    then
        pcall(function()
            source:Destroy()
        end)
        return nil
    end

    local pivotOffset =
        root.CFrame:ToObjectSpace(
            source:GetPivot()
        )

    local runtimeParent
    if hasLocalScriptDriver
        and not hasClientScriptDriver
    then

        local playerGui =
            LocalPlayer:FindFirstChildOfClass(
                "PlayerGui"
            )

        if not playerGui then
            pcall(function()
                playerGui =
                    LocalPlayer:WaitForChild(
                        "PlayerGui",
                        5
                    )
            end)
        end

        if playerGui then

            local folder =
                playerGui:FindFirstChild(
                    "DeadEyeUnusualRuntime"
                )

            if not folder then
                folder =
                    Instance.new("Folder")

                folder.Name =
                    "DeadEyeUnusualRuntime"

                folder.Parent =
                    playerGui
            end

            runtimeParent =
                folder

        end

    else

        local folder =
            workspace:FindFirstChild(
                "DeadEyeUnusualRuntime"
            )

        if not folder then
            folder =
                Instance.new("Folder")

            folder.Name =
                "DeadEyeUnusualRuntime"

            folder.Parent =
                workspace
        end

        runtimeParent =
            folder

    end

    if not runtimeParent then
        pcall(function()
            source:Destroy()
        end)
        return nil
    end

    source.Parent =
        runtimeParent

    pcall(function()
        source:PivotTo(
            targetRoot.CFrame *
            pivotOffset
        )
    end)

    if not hasClientDriver then
        root.Anchored = true

        unusualRuntime.startAnimations(
            source
        )
    end

    if hasClientDriver then

        for _, object in ipairs(
            source:GetDescendants()
        ) do

            if object:IsA("LocalScript")
                or object:IsA("Script")
            then

                pcall(function()
                    object.Disabled = false
                end)

            end

        end

    end

    unusualRuntime.animationSource =
        source

    return source
end

unusualRuntime.createVisualMirror = function(
    sourceModel,
    id
)
    if not sourceModel
        or not sourceModel:IsA("Model")
    then
        return false
    end

    local sourceParts = {}

    for _, object in ipairs(
        sourceModel:GetDescendants()
    ) do
        if object:IsA("BasePart") then
            table.insert(
                sourceParts,
                object
            )
        end
    end

    if #sourceParts == 0 then
        return false
    end

    local clone
    local ok =
        pcall(function()
            clone =
                sourceModel:Clone()
        end)

    if not ok
        or not clone
    then
        return false
    end

    clone.Name =
        "DeadEyeUnusualMirror_" ..
        tostring(id) ..
        "_" ..
        tostring(
            #unusualRuntime.visualMirrors + 1
        )

    for _, object in ipairs(
        clone:GetDescendants()
    ) do

        if object:IsA("Script")
            or object:IsA("LocalScript")
            or object:IsA("ModuleScript")
            or object:IsA("AnimationController")
            or object:IsA("Animator")
            or object:IsA("Humanoid")
            or object:IsA("Weld")
            or object:IsA("WeldConstraint")
            or object:IsA("Motor6D")
            or object:IsA("Motor")
        then

            pcall(function()
                object:Destroy()
            end)

        elseif object:IsA("BasePart") then

            pcall(function()
                object.CanCollide = false
                object.CanTouch = false
                object.CanQuery = false
                object.Massless = true
                object.CastShadow = false
            end)

        end

    end

    local folder =
        workspace:FindFirstChild(
            "DeadEyeUnusualVisuals"
        )

    if not folder then
        folder =
            Instance.new("Folder")

        folder.Name =
            "DeadEyeUnusualVisuals"

        folder.Parent =
            workspace
    end

    clone.Parent =
        folder

    local links = {}

    for _, sourcePart in ipairs(
        sourceParts
    ) do

        local names = {}
        local current =
            sourcePart

        while current
            and current ~= sourceModel
        do

            table.insert(
                names,
                1,
                current.Name
            )

            current =
                current.Parent

        end

        local target =
            clone

        for _, name in ipairs(
            names
        ) do

            target =
                target:FindFirstChild(
                    name
                )

            if not target then
                break
            end

        end

        if target
            and target:IsA("BasePart")
        then

            table.insert(
                links,
                {
                    source = sourcePart,
                    target = target
                }
            )

        end

    end

    table.insert(
        unusualRuntime.visualMirrors,
        {
            model = clone,
            links = links
        }
    )

    return true
end

unusualRuntime.addAnimationLink = function(
    sourcePart,
    nested,
    targetPart,
    animatedSource
)
    if not animatedSource then
        return false
    end

    local animatedPart =
        unusualRuntime.findRelative(
            animatedSource,
            nested
        )

    local animatedRoot =
        unusualRuntime.findRelative(
            animatedSource,
            sourcePart
        )

    if not animatedPart
        or not animatedRoot
        or not animatedPart:IsA("BasePart")
        or not animatedRoot:IsA("BasePart")
    then
        return false
    end

    if not targetPart
        or not targetPart:IsA("BasePart")
    then
        return false
    end

    table.insert(
        unusualRuntime.animationLinks,
        {
            sourceRoot = animatedRoot,
            sourcePart = animatedPart,
            targetPart = targetPart,
            anchor = nil
        }
    )

    return true
end

unusualRuntime.updateAnimatedParts = function()
    local source =
        unusualRuntime.animationSource

    if not source
        or not source.Parent
    then
        return
    end

    local targetRig =
        getUnusualVisualRig()

    local targetRoot

    if targetRig then
        targetRoot =
            targetRig:FindFirstChild(
                "HumanoidRootPart"
            )
    end

    if not targetRoot then
        local character =
            getUnusualPlayerCharacter()

        if character then
            targetRoot =
                character:FindFirstChild(
                    "HumanoidRootPart"
                )
        end
    end

    if unusualRuntime.specialCircling
        and unusualRuntime.specialCircling.root
        and unusualRuntime.specialCircling.root.Parent
        and targetRoot
    then

        pcall(function()
            unusualRuntime.specialCircling.root.CFrame =
                targetRoot.CFrame *
                unusualRuntime.specialCircling.offset
        end)

    end

    if not source
        or not source.Parent
    then
        return
    end

    local sourceRoot =
        source:FindFirstChild(
            "HumanoidRootPart"
        )

    if targetRoot
        and sourceRoot
        and targetRoot:IsA("BasePart")
        and sourceRoot:IsA("BasePart")
    then

        local delta =
            targetRoot.CFrame *
            sourceRoot.CFrame:Inverse()

        pcall(function()
            source:PivotTo(
                delta *
                source:GetPivot()
            )
        end)

    end

    for _, mirror in ipairs(
        unusualRuntime.visualMirrors
    ) do

        if mirror.model
            and mirror.model.Parent
        then

            for _, link in ipairs(
                mirror.links
