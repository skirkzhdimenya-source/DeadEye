--// =========================================================
--// DEADEYE VERSION
--// ТЕКУЩАЯ ВЕРСИЯ: 1.222
--//
--// ВАЖНО:
--// После каждого полностью завершённого изменения скрипта
--// обязательно повышать версию на 0.01.
--// Пример: v1.80 -> v1.81 -> v1.82 -> v1.83 -> v1.84 -> v1.85 -> v1.86 -> v1.87 -> v1.88 -> v1.89 -> v1.90 -> v1.91 -> v1.92 -> v1.93 -> v1.94 -> v1.95 -> v1.96 -> v1.97 -> v1.98 -> v1.99 -> v1.100 -> v1.101 -> v1.102 -> v1.103 -> v1.104 -> v1.105. -> v1.106 -> v1.107. -> v1.108. -> v1.109. -> v1.110. -> v1.111. -> v1.112 -> v1.113 -> v1.114 -> v1.115 -> v1.116 -> v1.117 -> v1.118.
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
local SCRIPT_VERSION = "1.222"
--// Others settings are persisted on edit/unfocus and again during cleanup.
--// Reverse Look WITH mode also reinstalls its hook when Crouch Spam is enabled.
--// These reminders must stay near script start.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local __UI = {}
__UI.__L = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local genv = getgenv and getgenv() or _G

--// =========================================================
--// PURGE STALE AUTOJUMP / LOOK SENSORS
--// =========================================================
--// Previous DeadEye instances could leave Touched/TouchEnded
--// connections alive because their sensor Parts were not destroyed
--// during cleanup. Destroying the named sensor Parts disconnects
--// those old callbacks and prevents stale arithmetic errors.
__UI.__L.purgeStaleMainJumpSensors = function()
    local character =
        LocalPlayer
        and LocalPlayer.Character

    if not character then
        return
    end

    for _, object in ipairs(
        character:GetDescendants()
    ) do
        if object:IsA("BasePart")
            and (
                object.Name == "FootJumpSensor"
                or object.Name == "FrontJumpSensor"
                or object.Name == "RearJumpSensor"
                or object.Name == "LookFootJumpSensor"
                or object.Name == "LookFrontJumpSensor"
                or object.Name == "JumpForwardSensorExtra"
                or object.Name == "LookForwardSensorExtra"
            )
        then
            pcall(function()
                object:Destroy()
            end)
        end
    end
end

__UI.__L.purgeStaleMainJumpSensors()

pcall(function()
    if genv.DEADEYE_MAIN_SENSORS_CLEANUP then
        genv.DEADEYE_MAIN_SENSORS_CLEANUP()
    end
end)

if genv.DEADEYE_UNUSUAL_POV_TRANSPARENCY_CLEANUP then
    pcall(function()
        genv.DEADEYE_UNUSUAL_POV_TRANSPARENCY_CLEANUP()
    end)
end
if genv.DEADEYE_FIRSTPERSON_HEAD_FIX_CLEANUP then
    pcall(function()
        genv.DEADEYE_FIRSTPERSON_HEAD_FIX_CLEANUP()
    end)
end
if genv.DEADEYE_MAIN_AIR_TURN_CLEANUP then
    pcall(function()
        genv.DEADEYE_MAIN_AIR_TURN_CLEANUP()
    end)
end
if genv.DEADEYE_REVERSE_LOOK_CLEANUP then
    pcall(function()
        genv.DEADEYE_REVERSE_LOOK_CLEANUP()
    end)
end
if genv.DEADEYE_RAGE_LOOK_CLEANUP then
    pcall(function()
        genv.DEADEYE_RAGE_LOOK_CLEANUP()
    end)
end
--// =========================================================
--// CROUCH SPAM uses its own PreSimulation landing signal.
--// It is completely independent from AutoJump mode and JumpReact.
--// When Humanoid reaches Landed while DataRegistry.Grounded is still false,
--// Crouch Spam turns ON before the normal Grounded -> Jump transition.
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
if genv.DEADEYE_COSMETIC_CLEANUP then
    pcall(function()
        genv.DEADEYE_COSMETIC_CLEANUP()
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
__UI.__L.Registry = require(
    ReplicatedStorage.Items.Registry
)
__UI.__L.HttpService = game:GetService("HttpService")
--// =========================================================
--// SETTINGS
--// =========================================================
__UI.__L.SLOT_COUNT = 12
__UI.__L.CONFIG_FILE = "DeadEye_Config.json"
__UI.__L.savedConfig = {
    version = 1,
    emotes = {},
    unusual = {},
    cosmetic = {
        slot1 = {},
        slot2 = {}
    },
    others = {},
    main = {
        jumpDelay = 0.01,
        autoJumpMode = "rage",
        hotkey = "Z",
        hideUIHotkey = "H",
        look = false,
        rageLook = false,
        airTurn = false,
        airTurnSpeed = 180,
        smartAirTurn = false,
        airTurnHotkey = "O",
        crouchSpamDelay = 0.03,
        crouchSpamHotkey = "I",
        reverseLookMode = "without",
        reverseLookEnabled = false,
        benchTrimpHotkey = "P",
        benchTrimpEnabled = false
    },
    gui = {
        x = 35,
        y = 80,
        width = 455,
        height = 320
    }
}
function loadSavedConfig()
    if type(readfile) ~= "function" then
        return
    end
    local success, raw
    if type(isfile) == "function" then
        local exists = false
        pcall(function()
            exists = isfile(__UI.__L.CONFIG_FILE)
        end)
        if not exists then
            return
        end
    end
    success, raw =
        pcall(function()
            return readfile(
                __UI.__L.CONFIG_FILE
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
            return __UI.__L.HttpService:JSONDecode(
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
        __UI.__L.savedConfig.emotes =
            decoded.emotes
    end
    if type(decoded.unusual) == "table" then
        __UI.__L.savedConfig.unusual =
            decoded.unusual
    end
    if type(decoded.cosmetic) == "table" then
        __UI.__L.savedConfig.cosmetic =
            decoded.cosmetic
    end
    if type(decoded.others) == "table" then
        __UI.__L.savedConfig.others =
            decoded.others
    end
    if type(decoded.main) == "table" then
        __UI.__L.savedConfig.main =
            decoded.main
    end
    __UI.__L.savedConfig.main.hideUIHotkey =
        __UI.__L.savedConfig.main.hideUIHotkey
        or "H"

    if __UI.__L.savedConfig.main.rageLook ~= true then
        __UI.__L.savedConfig.main.rageLook = false
    else
        __UI.__L.savedConfig.main.rageLook = true
    end

    if __UI.__L.savedConfig.main.benchTrimpEnabled ~= true then
        __UI.__L.savedConfig.main.benchTrimpEnabled = false
    else
        __UI.__L.savedConfig.main.benchTrimpEnabled = true
    end

    if __UI.__L.savedConfig.main.reverseLookMode ~= "with"
        and __UI.__L.savedConfig.main.reverseLookMode ~= "without"
    then
        __UI.__L.savedConfig.main.reverseLookMode = "without"
    end

    if __UI.__L.savedConfig.main.reverseLookEnabled ~= true then
        __UI.__L.savedConfig.main.reverseLookEnabled = false
    end

    if type(decoded.gui) == "table" then
        __UI.__L.savedConfig.gui = __UI.__L.savedConfig.gui or {}

        __UI.__L.savedConfig.gui.x =
            tonumber(decoded.gui.x)
            or __UI.__L.savedConfig.gui.x
            or 35

        __UI.__L.savedConfig.gui.y =
            tonumber(decoded.gui.y)
            or __UI.__L.savedConfig.gui.y
            or 80

        __UI.__L.savedConfig.gui.width =
            tonumber(decoded.gui.width)
            or __UI.__L.savedConfig.gui.width
            or 455

        __UI.__L.savedConfig.gui.height =
            tonumber(decoded.gui.height)
            or __UI.__L.savedConfig.gui.height
            or 320
    end

    __UI.__L.savedConfig.gui.x =
        tonumber(__UI.__L.savedConfig.gui.x) or 35
    __UI.__L.savedConfig.gui.y =
        tonumber(__UI.__L.savedConfig.gui.y) or 80
    __UI.__L.savedConfig.gui.width =
        tonumber(__UI.__L.savedConfig.gui.width) or 455
    __UI.__L.savedConfig.gui.height =
        tonumber(__UI.__L.savedConfig.gui.height) or 320

    __UI.__L.savedConfig.version =
        tonumber(decoded.version)
        or 1
end
function saveSavedConfig()
    if type(writefile) ~= "function" then
        return false
    end
    local success, raw =
        pcall(function()
            return __UI.__L.HttpService:JSONEncode(
                __UI.__L.savedConfig
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
                __UI.__L.CONFIG_FILE,
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
--// =========================================================
--// LOCAL PORTRAIT OVERRIDE MODULE
--// =========================================================
--// Portrait module is loaded at the original final initialization point.

--// =========================================================
--// SLOTS
--// =========================================================
__UI.__L.slots = {}
for i = 1, __UI.__L.SLOT_COUNT do
    __UI.__L.slots[i] = {
        originalId = nil,
        replaceId = nil,
        originalName = nil,
        replaceName = nil
    }
end
--// DEFAULT SLOT
__UI.__L.slots[1].originalId = 1631
__UI.__L.slots[1].replaceId = 51
__UI.__L.slots[1].originalName = "Banger"
__UI.__L.slots[1].replaceName = "RockinStride"
--// Load saved Emote mappings.
for i = 1, __UI.__L.SLOT_COUNT do
    local saved =
        __UI.__L.savedConfig.emotes[i]
    if type(saved) == "table" then
        local originalId =
            tonumber(saved.originalId)
        local replaceId =
            tonumber(saved.replaceId)
        if originalId then
            __UI.__L.slots[i].originalId =
                originalId
        end
        if replaceId then
            __UI.__L.slots[i].replaceId =
                replaceId
        end
    end
end
--// =========================================================
--// RUNTIME STATE
--// =========================================================
local enabled = false
__UI.__L.cleaned = false
__UI.__L.connections = {}

--// Native wheel visual state.
--// Keys are logical wheel positions ("Wheel:1", "Wheel2:4"),
--// not GUI Instances. The game can recreate Emote1..Emote6;
--// logical state survives those recreations and repeated ON/OFF.

--// =========================================================
--// CACHE
--// =========================================================
__UI.__L.originalModules = {}
__UI.__L.replaceModules = {}
-- [originalId] = { [animationId] = true }
__UI.__L.originalAnimationIds = {}
__UI.__L.emoteList = {}
--// =========================================================
--// GUI STATE
--// =========================================================
__UI.__L.ScreenGui
__UI.__L.Main
__UI.__L.SlotsScroll
__UI.__L.Picker
__UI.__L.PickerScroll
__UI.__L.PickerSearch
__UI.__L.PickerTitle
__UI.__L.PickerClose
__UI.__L.Status
__UI.__L.Toggle
__UI.__L.activePickerSlot = nil
__UI.__L.activePickerSide = nil
__UI.__L.slotOriginalButtons = {}
__UI.__L.slotReplaceButtons = {}
__UI.__L.pickerButtons = {}
__UI.__L.emotePreviewCache = {}
__UI.__L.cosmeticPreviewCache = {}
__UI.__L.emotePreviewCacheHolder
__UI.__L.cosmeticPreviewCacheHolder
__UI.__L.emotePickerPreloaded = false
__UI.__L.cosmeticPickerPreloaded = false
--// =========================================================
--// CONNECTION HELPER
--// =========================================================
__UI.__L.addConnection = function(connection)
    table.insert(__UI.__L.connections, connection)
end
__UI.__L.disconnectAll = function()
    for _, connection in ipairs(__UI.__L.connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(__UI.__L.connections)
end
--// =========================================================
--// NORMALIZE ANIMATION ID
--// =========================================================
function normalizeAnimationId(id)
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
function getItemModule(id)
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
function buildEmoteList()
    table.clear(__UI.__L.emoteList)
    local all
    local success, result = pcall(function()
        return __UI.__L.Registry.GetAll()
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
                        __UI.__L.emoteList,
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
        __UI.__L.emoteList,
        function(a, b)
            return a.id < b.id
        end
    )
    end
buildEmoteList()
--// =========================================================
--// PREPARE ORIGINAL MODULE
--// =========================================================
function prepareOriginalModule(id)
    id = tonumber(id)
    if not id then
        return nil
    end
    if __UI.__L.originalModules[id] then
        return __UI.__L.originalModules[id]
    end
    local module =
        getItemModule(id)
    if not module then
        return nil
    end
    __UI.__L.originalModules[id] =
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
    __UI.__L.originalAnimationIds[id] =
        animationSet
    return module
end
--// =========================================================
--// PREPARE REPLACE MODULE
--// =========================================================
function prepareReplaceModule(id)
    id = tonumber(id)
    if not id then
        return nil
    end
    if __UI.__L.replaceModules[id] then
        return __UI.__L.replaceModules[id]
    end
    local module =
        getItemModule(id)
    if not module then
        return nil
    end
    __UI.__L.replaceModules[id] =
        module
    return module
end
--// =========================================================
--// FIND EMOTE NAME
--// =========================================================
function getEmoteName(id)
    id = tonumber(id)
    if not id then
        return nil
    end
    for _, data in ipairs(
        __UI.__L.emoteList
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
function prepareSlots()
    for i = 1, __UI.__L.SLOT_COUNT do
        local slot =
            __UI.__L.slots[i]
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
function getCharacterObject()
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
--// REFRESH NATIVE VISIBILITY AFTER FINAL UNUSUAL RESTORE
--// =========================================================
--// Character.Client.Visibility stores each limb's descendant list
--// inside Rig.Limbs. AddCosmetics() can add the final Unusual FX
--// after those lists were originally built, so native Visibility
--// may never see the new ParticleEmitter/Trail objects.
--// Rebuild only the cached descendant lists, then call the game's
--// own Visibility.UpdateVisibility() once. After this point DeadEye
--// does not keep a custom POV loop for the restored native effect.
__UI.__L.refreshNativeVisibilityAfterUnusualRestore = function()
    local characterObject =
        getCharacterObject()

    if not characterObject then
        return false
    end

    --// CharacterObject.Rig is the outer Character.Rig component.
    --// The actual RigService rig that owns Limbs/Model is:
    --// CharacterObject.Rig.Rig
    local rigComponent =
        characterObject.Rig

    local nativeRig =
        rigComponent
        and rigComponent.Rig

    local visibility =
        characterObject.Visibility

    if not rigComponent
        or not nativeRig
        or not visibility
    then
        return false
    end

    local rigModel =
        nativeRig.Model

    if not rigModel
        or not rigModel.Parent
    then
        return false
    end

    --// Visibility:GetLimbs() returns this exact table:
    --// CharacterObject.Rig.Rig.Limbs
    --//
    --// AddCosmetics() can create the final Unusual after those
    --// descendant arrays were built. Refresh every limb's
    --// descendant cache so native SetVisibility() sees the
    --// restored ParticleEmitter/Trail/Beam objects.
    local limbs =
        nativeRig.Limbs

    if type(limbs) == "table" then
        for _, limb in pairs(limbs) do
            if type(limb) == "table" then
                local root =
                    limb[1]

                if typeof(root) == "Instance"
                    and root.Parent
                then
                    limb[2] =
                        root:GetDescendants()
                end
            end
        end
    end

    local currentType

    pcall(function()
        currentType =
            visibility:GetType()
    end)

    if currentType then
        visibility.Type =
            currentType
    end

    return pcall(function()
        visibility:UpdateVisibility()
    end)
end
--// =========================================================
--// HELPER: SLOT BY ORIGINAL ID
--// =========================================================
function getSlotByOriginalId(id)
    id = tonumber(id)
    if not id then
        return nil
    end
    for i = 1, __UI.__L.SLOT_COUNT do
        local slot =
            __UI.__L.slots[i]
        if slot.originalId == id
            and slot.replaceId then
            return slot, i
        end
    end
    return nil
end
--// =========================================================
--// =========================================================
--// EMOTE RUNTIME MODULE
--// =========================================================
__UI.__L.EmoteRuntime =
    loadstring(
        game:HttpGet(
            "https://raw.githubusercontent.com/skirkzhdimenya-source/DeadEye/a424881ee7e4e542b46a543aaf489734afd102ea/DeadEye_EmoteRuntime.lua"
        )
    )()

if type(__UI.__L.EmoteRuntime) == "function" then
    __UI.__L.EmoteRuntime = __UI.__L.EmoteRuntime(
        {
            genv = genv,
            isEnabled = function()
                return enabled
            end,
            EmoteService = __UI.EmoteService,
            __UI.__L.originalAnimationIds = __UI.__L.originalAnimationIds
        }
    )
end

if type(__UI.__L.EmoteRuntime) ~= "table" then
    error(
        "[DeadEye] EmoteRuntime module did not return an API table"
    )
end
--// GUI PARENT
--// =========================================================
__UI.__L.guiParent
pcall(function()
    __UI.__L.guiParent = gethui()
end)
if not __UI.__L.guiParent then
    __UI.__L.guiParent =
        game:GetService("CoreGui")
end
--// =========================================================
--// WINDOW SIZE LIMITS
--// =========================================================
__UI.__L.MIN_WINDOW_WIDTH = 500
__UI.__L.MIN_WINDOW_HEIGHT = 295
__UI.__L.RESIZE_EDGE = 8
--// =========================================================
--// SCREEN GUI
--// =========================================================
__UI.__L.ScreenGui =
    Instance.new("ScreenGui")
__UI.__L.ScreenGui.Name =
    "EmoteSwapperGUI"
__UI.__L.ScreenGui.ResetOnSpawn =
    false
__UI.__L.ScreenGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling
__UI.__L.ScreenGui.Parent =
    __UI.__L.guiParent

__UI.__L.emotePreviewCacheHolder =
    Instance.new("Frame")
__UI.__L.emotePreviewCacheHolder.Name = "DeadEyeEmotePreviewCache"
__UI.__L.emotePreviewCacheHolder.Size = UDim2.new(0, 1, 0, 1)
__UI.__L.emotePreviewCacheHolder.Position = UDim2.new(0, -10000, 0, -10000)
__UI.__L.emotePreviewCacheHolder.BackgroundTransparency = 1
__UI.__L.emotePreviewCacheHolder.BorderSizePixel = 0
__UI.__L.emotePreviewCacheHolder.Visible = false
__UI.__L.emotePreviewCacheHolder.Parent = __UI.__L.ScreenGui

__UI.__L.cosmeticPreviewCacheHolder =
    Instance.new("Frame")
__UI.__L.cosmeticPreviewCacheHolder.Name = "DeadEyeCosmeticPreviewCache"
__UI.__L.cosmeticPreviewCacheHolder.Size = UDim2.new(0, 1, 0, 1)
__UI.__L.cosmeticPreviewCacheHolder.Position = UDim2.new(0, -10000, 0, -10000)
__UI.__L.cosmeticPreviewCacheHolder.BackgroundTransparency = 1
__UI.__L.cosmeticPreviewCacheHolder.BorderSizePixel = 0
__UI.__L.cosmeticPreviewCacheHolder.Visible = false
__UI.__L.cosmeticPreviewCacheHolder.Parent = __UI.__L.ScreenGui

--// =========================================================
--// MAIN
--// =========================================================
__UI.__L.Main =
    Instance.new("Frame")
__UI.__L.Main.Size =
    UDim2.new(
        0,
        math.max(
            __UI.__L.MIN_WINDOW_WIDTH,
            __UI.__L.savedConfig.gui.width
        ),
        0,
        math.max(
            __UI.__L.MIN_WINDOW_HEIGHT,
            __UI.__L.savedConfig.gui.height
        )
    )
__UI.__L.Main.Position =
    UDim2.new(
        0,
        __UI.__L.savedConfig.gui.x,
        0,
        __UI.__L.savedConfig.gui.y
    )
__UI.__L.Main.BackgroundColor3 =
    Color3.fromRGB(
        18,
        20,
        24
    )
__UI.__L.Main.BackgroundTransparency =
    1
__UI.__L.Main.BorderSizePixel =
    0

__UI.__L.Main.ClipsDescendants =
    false
__UI.__L.Main.ClipsDescendants =
    true
__UI.__L.Main.Parent =
    __UI.__L.ScreenGui

__UI.__L.MainSurface =
    Instance.new("Frame")

__UI.__L.MainSurface.Name =
    "MainSurface"

__UI.__L.MainSurface.Size =
    UDim2.new(
        1,
        -2,
        1,
        -2
    )

__UI.__L.MainSurface.Position =
    UDim2.new(
        0,
        1,
        0,
        1
    )

__UI.__L.MainSurface.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )

__UI.__L.MainSurface.BackgroundTransparency =
    0.10

__UI.__L.MainSurface.BorderSizePixel =
    0

__UI.__L.MainSurface.ZIndex =
    0

__UI.__L.MainSurface.ClipsDescendants =
    true

__UI.__L.MainSurface.Parent =
    __UI.__L.Main

__UI.__L.MainSurfaceCorner =
    Instance.new("UICorner")

__UI.__L.MainSurfaceCorner.CornerRadius =
    UDim.new(
        0,
        12
    )

__UI.__L.MainSurfaceCorner.Parent =
    __UI.__L.MainSurface

__UI.__L.MainSurfaceStroke =
    Instance.new("UIStroke")

__UI.__L.MainSurfaceStroke.Thickness =
    1

__UI.__L.MainSurfaceStroke.Transparency =
    0.66

__UI.__L.MainSurfaceStroke.Parent =
    __UI.__L.MainSurface

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
    __UI.__L.MainSurface

--// MainSurface owns the outer rounded shell; keep Main itself fully transparent.

__UI.__L.MainHeader =
    Instance.new("Frame")
__UI.__L.MainHeader.Name =
    "MainHeader"
__UI.__L.MainHeader.Size =
    UDim2.new(
        1,
        -2,
        0,
        39
    )
__UI.__L.MainHeader.Position =
    UDim2.new(
        0,
        1,
        0,
        1
    )
__UI.__L.MainHeader.BackgroundColor3 =
    Color3.fromRGB(
        40,
        45,
        53
    )
__UI.__L.MainHeader.BackgroundTransparency =
    0.20
__UI.__L.MainHeader.BorderSizePixel =
    0
__UI.__L.MainHeader.ZIndex =
    1
__UI.__L.MainHeader.Parent =
    __UI.__L.Main

__UI.__L.MainHeaderCorner =
    Instance.new("UICorner")

__UI.__L.MainHeaderCorner.CornerRadius =
    UDim.new(
        0,
        11
    )

__UI.__L.MainHeaderCorner.Parent =
    __UI.__L.MainHeader

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
    __UI.__L.MainHeader

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
    __UI.__L.Main

--// =========================================================
--// TITLE
--// =========================================================
__UI.__L.MainTitle =
    Instance.new("TextLabel")
__UI.__L.MainTitle.Size =
    UDim2.new(
        1,
        -105,
        0,
        36
    )
__UI.__L.MainTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        2
    )
__UI.__L.MainTitle.BackgroundTransparency =
    1
__UI.__L.MainTitle.Text =
    "DeadEyes v" .. SCRIPT_VERSION
__UI.__L.MainTitle.TextSize =
    18
__UI.__L.MainTitle.Font =
    Enum.Font.GothamBold
__UI.__L.MainTitle.ZIndex =
    2
__UI.__L.MainTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.MainTitle.TextXAlignment =
    Enum.TextXAlignment.Left
__UI.__L.MainTitle.Parent =
    __UI.__L.Main
--// =========================================================
--// MINIMIZE
--// =========================================================
__UI.__L.Minimize =
    Instance.new("TextButton")
__UI.__L.Minimize.Size =
    UDim2.new(
        0,
        27,
        0,
        27
    )
__UI.__L.Minimize.Position =
    UDim2.new(
        1,
        -65,
        0,
        6
    )
__UI.__L.Minimize.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
__UI.__L.Minimize.BorderSizePixel =
    0
__UI.__L.Minimize.Text =
    "−"
__UI.__L.Minimize.TextSize =
    20
__UI.__L.Minimize.AutoButtonColor =
    true
__UI.__L.Minimize.ZIndex =
    5
__UI.__L.Minimize.BackgroundTransparency =
    0.05
__UI.__L.Minimize.Font =
    Enum.Font.GothamBold
__UI.__L.Minimize.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.Minimize.Parent =
    __UI.__L.Main
__UI.MinimizeCorner =
    Instance.new("UICorner")
__UI.MinimizeCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.MinimizeCorner.Parent =
    __UI.__L.Minimize
--// =========================================================
--// CLOSE
--// =========================================================
__UI.__L.Close =
    Instance.new("TextButton")
__UI.__L.Close.Size =
    UDim2.new(
        0,
        27,
        0,
        27
    )
__UI.__L.Close.Position =
    UDim2.new(
        1,
        -32,
        0,
        6
    )
__UI.__L.Close.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        50
    )
__UI.__L.Close.BackgroundTransparency =
    0.05
__UI.__L.Close.BorderSizePixel =
    0
__UI.__L.Close.ZIndex =
    5
__UI.__L.Close.Text =
    "×"
__UI.__L.Close.TextSize =
    27
__UI.__L.Close.Font =
    Enum.Font.GothamBold
__UI.__L.Close.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.Close.Parent =
    __UI.__L.Main

__UI.CloseCorner =
    Instance.new("UICorner")
__UI.CloseCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.CloseCorner.Parent =
    __UI.__L.Close

__UI.CloseStroke =
    Instance.new("UIStroke")
__UI.CloseStroke.Thickness =
    1
__UI.CloseStroke.Transparency =
    0.65
__UI.CloseStroke.Parent =
    __UI.__L.Close

--// Header button surfaces stay solid.
--// Their hover light is the centered UIShadow created below.
--// =========================================================
--// STATUS
--// =========================================================
__UI.__L.Status =
    Instance.new("TextLabel")
__UI.__L.Status.Size =
    UDim2.new(
        0,
        190,
        0,
        20
    )
__UI.__L.Status.Position =
    UDim2.new(
        0,
        10,
        0,
        43
    )
__UI.__L.Status.BackgroundTransparency =
    1
__UI.__L.Status.Text =
    ""
__UI.__L.Status.TextSize =
    12
__UI.__L.Status.Font =
    Enum.Font.Gotham
__UI.__L.Status.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
__UI.__L.Status.TextXAlignment =
    Enum.TextXAlignment.Left
__UI.__L.Status.Parent =
    __UI.__L.Main
--// =========================================================
--// UNUSUAL CATEGORY
--// ONE SLOT
--//
--// [Original] -> [Replace]
--//
--// FX-only local replacement.
--// =========================================================
__UI.__L.UnusualFns = {}
__UI.__L.unusualSlot = {
    originalId = nil,
    replaceId = 200,
    originalName = nil,
    replaceName = nil
}
__UI.__L.unusualList = {}
__UI.__L.unusualEnabled = false
__UI.__L.unusualActive = false
__UI.__L.unusualPicker
__UI.__L.unusualPickerScroll
__UI.__L.unusualPickerSearch
__UI.__L.unusualPickerTitle
__UI.__L.unusualPickerClose
__UI.__L.unusualPickerButtons = {}
__UI.__L.unusualPickerSide = nil
__UI.__L.unusualIconCache = {}
__UI.__L.unusualIconIdCache = {}

--// =========================================================
--// COSMETIC CATEGORY
--// TWO LOCAL REPLACEMENT SLOTS
--// [Original] -> [Replace]
--// =========================================================
__UI.__L.cosmetic = {
    slots = {
        [1] = {
            originalId = nil,
            replaceId = nil,
            originalName = nil,
            replaceName = nil
        },
        [2] = {
            originalId = nil,
            replaceId = nil,
            originalName = nil,
            replaceName = nil
        }
    },
    list = {},
    enabled = false,
    hooked = false,
    targetSetRig = nil,
    originalSetRig = nil,
    lastSetRigArgs = nil,
    page = nil,
    pageStatus = nil,
    picking = false,
    pickerSide = nil,
    categoryButton = nil,
    skinDescription = nil,
    skinCharacter = nil,
    refreshBusy = false,
    directAction = {
        [1] = nil,
        [2] = nil
    }
}

__UI.__L.normalizeUnusualIconKey = function(value)
    value = tostring(value or "")
    value = string.lower(value)
    value = string.gsub(value, "[^%w]", "")
    return value
end

__UI.__L.isLikelyImageKey = function(key)
    key = string.lower(
        tostring(key or "")
    )

    return string.find(key, "icon", 1, true)
        or string.find(key, "image", 1, true)
        or string.find(key, "thumbnail", 1, true)
        or string.find(key, "thumb", 1, true)
        or string.find(key, "preview", 1, true)
        or string.find(key, "sprite", 1, true)end

__UI.__L.extractAssetId = function(value)
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

__UI.__L.scanIconValue = function(
    value,
    preferred,
    depth,
    seen
)
    if depth > 5 then
        return nil
    end

    local direct =
        __UI.__L.extractAssetId(
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

        if __UI.__L.isLikelyImageKey(
            keyString
        )
        then
            local found =
                __UI.__L.scanIconValue(
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
                __UI.__L.scanIconValue(
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

__UI.__L.getUnusualIconFromData = function(
    numericId,
    registryData,
    module
)
    local candidates = {}

    local config
    pcall(function()
        config =
            __UI.__L.Registry.GetConfig(
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
            __UI.__L.scanIconValue(
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

                if __UI.__L.isLikelyImageKey(
                    key
                )
                then
                    local found =
                        __UI.__L.extractAssetId(
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
                if __UI.__L.isLikelyImageKey(
                    obj.Name
                )
                then
                    local found =
                        __UI.__L.extractAssetId(
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

__UI.__L.cacheUnusualIconFromObject = function(icon)
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
            __UI.__L.normalizeUnusualIconKey(
                name
            )

        if key ~= ""
            and #key >= 3
        then
            __UI.__L.unusualIconCache[key] = image
        end
    end
end

__UI.__L.collectCurrentUnusualIcons = function(playerGui)
    if not playerGui then
        return
    end

    for _, obj in ipairs(
        playerGui:GetDescendants()
    ) do
        if obj:IsA("ImageLabel")
            and obj.Name == "IconIMG"
        then
            __UI.__L.cacheUnusualIconFromObject(obj)
        end
    end
end

__UI.__L.findNativeUnusualScroll = function(playerGui)
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

__UI.__L.preloadNativeUnusualIcons = function()
    local playerGui =
        LocalPlayer:FindFirstChild(
            "PlayerGui"
        )

    if not playerGui then
        return
    end

    __UI.__L.collectCurrentUnusualIcons(
        playerGui
    )

    local scroll =
        __UI.__L.findNativeUnusualScroll(
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

        __UI.__L.collectCurrentUnusualIcons(
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

    __UI.__L.collectCurrentUnusualIcons(
        playerGui
    )
end
__UI.__L.unusualPage
__UI.__L.unusualStatus
__UI.__L.categoryBar
__UI.__L.mainCategoryButton
__UI.__L.emoteCategoryButton
__UI.__L.unusualCategoryButton
__UI.__L.othersCategoryButton
__UI.__L.currentCategory = "Emotes"
__UI.__L.mainPage
__UI.__L.others = {}
__UI.__L.mainMinimized = false
__UI.__L.setMainMinimized
__UI.__L.updateUnusualToggle
__UI.__L.others.originalDescription = nil
__UI.__L.others.targetHumanoid = nil
__UI.__L.others.page = nil
__UI.__L.others.status = nil
__UI.__L.others.fieldButtons = {}
__UI.__L.others.fieldBoxes = {}
__UI.__L.others.firstPersonTransparency = {}

__UI.__L.unusualConnections = {}
__UI.__L.unusualDestroyed = false
__UI.__L.unusualReapplyBusy = false
__UI.__L.unusualRuntime = {
    appliedRig = nil,
    originalId = nil,
    replacementId = nil,
    --// Rule state:
    --// originalId/replacementId describe the configured swap only.
    --// currentEquippedId describes what the player actually has equipped.
    currentEquippedId = nil,
    nativeSnapshot = nil,
    --// Native P1 particle state for the LIVE visual rig.
    --// The clean-game test showed active Unusual ParticleEmitters
    --// switching true -> false in P1. Preserve each emitter's
    --// exact 3P Enabled value so P3 restores only what was there.
    nativeParticleStates = {},
    nativeParticleRig = nil,
    nativeParticleConnection = nil,
    nativeParticleLastFirstPerson = nil,
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
function __UI.__L.UnusualFns.addUnusualConnection(connection)
    table.insert(
        __UI.__L.unusualConnections,
        connection
    )
end
function __UI.__L.UnusualFns.disconnectUnusualConnections()
    for _, connection in ipairs(
        __UI.__L.unusualConnections
    ) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(
        __UI.__L.unusualConnections
    )

    __UI.__L.unusualReapplyBusy = false
end
--// =========================================================
--// UNUSUAL LIST
--// =========================================================
function __UI.__L.UnusualFns.buildUnusualList()
    table.clear(
        __UI.__L.unusualList
    )
    local success, all = pcall(function()
        return __UI.__L.Registry.GetAll()
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
                    __UI.__L.Registry.GetConfig(
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
                            __UI.__L.Registry.GetById(
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
                        __UI.__L.getUnusualIconFromData(
                            numericId,
                            data,
                            module
                        )

                    if icon then
                        __UI.__L.unusualIconIdCache[
                            numericId
                        ] = icon
                    end

                    table.insert(
                        __UI.__L.unusualList,
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
        __UI.__L.unusualList,
        function(a, b)
            return a.id < b.id
        end
    )

    local iconCount = 0

    for _, data in ipairs(
        __UI.__L.unusualList
    ) do
        if data.icon then
            iconCount += 1
        end
    end

    warn(
        "[DeadEye] Native Unusual icons:",
        tostring(iconCount),
        "/",
        tostring(#__UI.__L.unusualList)
    )
    end
__UI.__L.UnusualFns.buildUnusualList()
--// =========================================================
--// GET UNUSUAL NAME
--// =========================================================
--// =========================================================
--// COSMETIC HELPERS
--// =========================================================
function __UI.__L.cosmetic.getName(id)
    id = tonumber(id)
    if not id then
        return nil
    end

    local name
    pcall(function()
        local entry = __UI.__L.Registry.GetById(id)
        local module =
            entry
            and entry.Module
        if module then
            name = module.Name
        end
    end)
    return name
end

function __UI.__L.cosmetic.getEquippedId(slot)
    local value = 0
    pcall(function()
        value =
            require(
                ReplicatedStorage.Shared.UserData.ClientHooks:WaitForChild("useLoadout")
            ).GetEquippedFromSlot(
                "CosmeticSlot_"
                    .. tostring(slot)
            )
    end)
    return tonumber(value) or 0
end

function __UI.__L.cosmetic.updateRow(slotIndex)
    local state =
        __UI.__L.cosmetic.slots[slotIndex]

    if not state then
        return
    end

    local row =
        __UI.__L.cosmetic.page
        and __UI.__L.cosmetic.page:FindFirstChild(
            "CosmeticRow_"
                .. tostring(slotIndex)
        )

    if not row then
        return
    end

    local original =
        row:FindFirstChild("OriginalButton")
    local replace =
        row:FindFirstChild("ReplaceButton")

    if original then
        original.Text =
            state.originalName
            or "Select"
    end

    if replace then
        replace.Text =
            state.replaceName
            or "NONE"
    end
end

function __UI.__L.cosmetic.setInitialOriginal(
    slotIndex,
    id
)
    id = tonumber(id)

    if not id
        or id == 0
    then
        return
    end

    local state =
        __UI.__L.cosmetic.slots[slotIndex]

    if not state
        or state.originalId
    then
        return
    end

    state.originalId =
        id
    state.originalName =
        __UI.__L.cosmetic.getName(id)

    __UI.__L.cosmetic.saveState()
    __UI.__L.cosmetic.updateRow(slotIndex)
end

function __UI.__L.cosmetic.loadState()
    local saved =
        type(__UI.__L.savedConfig.cosmetic) == "table"
        and __UI.__L.savedConfig.cosmetic
        or {}

    for index = 1, 2 do
        local state =
            __UI.__L.cosmetic.slots[index]

        local savedSlot =
            saved[
                "slot"
                    .. tostring(index)
            ]

        if type(savedSlot) == "table" then
            local savedOriginal =
                tonumber(
                    savedSlot.originalId
                )
            local savedReplace =
                tonumber(
                    savedSlot.replaceId
                )

            if savedOriginal
                and savedOriginal ~= 0
            then
                state.originalId =
                    savedOriginal
                state.originalName =
                    __UI.__L.cosmetic.getName(
                        savedOriginal
                    )
            end

            if savedReplace
                and savedReplace ~= 0
            then
                state.replaceId =
                    savedReplace
                state.replaceName =
                    __UI.__L.cosmetic.getName(
                        savedReplace
                    )
            end
        end

        -- Only auto-detect the currently equipped item when
        -- this slot has no saved Original mapping.
        if not state.originalId then
            local equipped =
                __UI.__L.cosmetic.getEquippedId(index)

            if equipped ~= 0 then
                state.originalId =
                    equipped
                state.originalName =
                    __UI.__L.cosmetic.getName(
                        equipped
                    )
            end
        end
    end
end

function __UI.__L.cosmetic.saveState()
    __UI.__L.savedConfig.cosmetic = {
        slot1 = {
            originalId =
                __UI.__L.cosmetic.slots[1].originalId,
            replaceId =
                __UI.__L.cosmetic.slots[1].replaceId
        },
        slot2 = {
            originalId =
                __UI.__L.cosmetic.slots[2].originalId,
            replaceId =
                __UI.__L.cosmetic.slots[2].replaceId
        }
    }
end

function __UI.__L.cosmetic.buildList()
    table.clear(
        __UI.__L.cosmetic.list
    )

    local success, all =
        pcall(function()
            return __UI.__L.Registry.GetAll()
        end)

    if not success
        or type(all) ~= "table"
    then
        warn(
            "[DeadEye] Cosmetic Registry.GetAll error:",
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
                    __UI.__L.Registry.GetConfig(
                        numericId
                    )
            end)

            local equipInfo =
                type(config) == "table"
                and config.EquipInfo
                or nil

            if type(equipInfo) == "table"
                and equipInfo.SlotType == "Cosmetic"
            then
                local module =
                    data
                    and data.Module

                if not module then
                    pcall(function()
                        local entry =
                            __UI.__L.Registry.GetById(
                                numericId
                            )
                        module =
                            entry
                            and entry.Module
                    end)
                end

                if module then
                    seen[numericId] = true

                    local icon
                    pcall(function()
                        icon =
                            __UI.__L.getUnusualIconFromData(
                                numericId,
                                data,
                                module
                            )
                    end)

                    table.insert(
                        __UI.__L.cosmetic.list,
                        {
                            id = numericId,
                            name = module.Name,
                            icon = icon
                        }
                    )
                end
            end
        end
    end

    table.sort(
        __UI.__L.cosmetic.list,
        function(a, b)
            return a.id < b.id
        end
    )

    warn(
        "[DeadEye] Cosmetics:",
        tostring(
            #__UI.__L.cosmetic.list
        )
    )
end

function __UI.__L.cosmetic.replaceArray(cosmetics)
    if not __UI.__L.cosmetic.enabled
        or type(cosmetics) ~= "table"
    then
        return cosmetics
    end

    local result
    local replaced = {}

    for index, id in ipairs(cosmetics) do
        local numericId =
            tonumber(id)

        if numericId then
            for slotIndex = 1, 2 do
                if not replaced[slotIndex] then
                    local state =
                        __UI.__L.cosmetic.slots[slotIndex]

                    if state
                        and state.originalId
                        and state.replaceId
                        and tonumber(
                            state.originalId
                        ) ~= tonumber(
                            state.replaceId
                        )
                        and numericId
                            == tonumber(
                                state.originalId
                            )
                    then
                        if not result then
                            result =
                                table.clone(
                                    cosmetics
                                )
                        end

                        result[index] =
                            tonumber(
                                state.replaceId
                            )

                        replaced[slotIndex] = true
                        break
                    end
                end
            end
        end
    end

    return result or cosmetics
end

function __UI.__L.cosmetic.getLiveRig()
    local characterObject
    local model

    pcall(function()
        characterObject =
            __UI.CharacterService:GetLocalCharacter()
    end)

    if not characterObject
        or not characterObject.Rig
    then
        return nil
    end

    model =
        characterObject.Model

    if not model
        or not model.Parent
    then
        return nil
    end

    local rigs =
        workspace:FindFirstChild("Rigs")

    if rigs
        and not model:IsDescendantOf(rigs)
    then
        return nil
    end

    return characterObject.Rig
end

function __UI.__L.cosmetic.refreshRig()
    if __UI.__L.cosmetic.refreshBusy then
        return false
    end

    local live =
        workspace:FindFirstChild("Rigs")
        and workspace.Rigs:FindFirstChild(
            LocalPlayer.Name
        )

    if not live
        or not live:IsA("Model")
    then
        return false
    end

    local humanoid =
        live:FindFirstChildOfClass(
            "Humanoid"
        )

    if not humanoid then
        return false
    end

    --// The live rig can have a custom skin applied locally.
    --// PlayerCache is only the game's clean base and must not
    --// be treated as the player's actual visual skin.
    --// Preserve the current custom skin on the same live rig.
    --// When a new rig appears, keep the saved description instead
    --// of replacing it with the game's default cache description.
    if not __UI.__L.cosmetic.skinDescription
        or __UI.__L.cosmetic.skinCharacter == live
    then
        local description

        local descriptionOK =
            pcall(function()
                description =
                    humanoid:GetAppliedDescription()
            end)

        if not descriptionOK
            or not description
        then
            return false
        end

        local clone

        local cloneOK =
            pcall(function()
                clone =
                    description:Clone()
            end)

        if not cloneOK
            or not clone
        then
            return false
        end

        __UI.__L.cosmetic.skinDescription =
            clone
        __UI.__L.cosmetic.skinCharacter =
            live
    end

    local cache =
        workspace:FindFirstChild(
            "PlayerCache"
        )

    local playerCache =
        cache
        and cache:FindFirstChild(
            LocalPlayer.Name
        )

    local baseName =
        humanoid.RigType
        == Enum.HumanoidRigType.R6
        and "R6"
        or "Player"

    local base =
        playerCache
        and playerCache:FindFirstChild(
            baseName
        )

    if not base then
        return false
    end

    local equippedUnusualId =
        __UI.__L.UnusualFns.getEquippedUnusualId()

    local restoreUnusualSwap =
        __UI.__L.unusualEnabled
        and __UI.__L.unusualActive
        and __UI.__L.unusualRuntime.originalId
        and tonumber(
            __UI.__L.unusualRuntime.originalId
        ) == tonumber(
            equippedUnusualId
        )

    local restoreNativeUnusualId =
        nil

    local cosmeticUnusualSnapshot =
        nil

    if restoreUnusualSwap then
        cosmeticUnusualSnapshot =
            __UI.__L.unusualRuntime.nativeSnapshot
    elseif equippedUnusualId
        and equippedUnusualId ~= 0
    then
        restoreNativeUnusualId =
            tonumber(equippedUnusualId)

        cosmeticUnusualSnapshot =
            __UI.__L.UnusualFns.captureNativeUnusualSnapshot(
                equippedUnusualId,
                __UI.__L.UnusualFns.getUnusualVisualRig(),
                __UI.__L.UnusualFns.getUnusualPlayerCharacter()
            )
    end

    if restoreUnusualSwap then
        pcall(function()
            __UI.__L.UnusualFns.removeOurUnusualFX()
        end)
        __UI.__L.unusualActive = false
    end

    __UI.__L.cosmetic.refreshBusy = true

    local success =
        pcall(function()

            --// Strip only the visual contents of the body parts
            --// back to the game's clean merge base.
            for _, basePart in ipairs(
                base:GetChildren()
            ) do

                if basePart:IsA("BasePart")
                    and basePart.Name
                        ~= "HumanoidRootPart"
                then

                    local livePart =
                        live:FindFirstChild(
                            basePart.Name
                        )

                    if livePart
                        and livePart:IsA("BasePart")
                    then

                        for _, child in ipairs(
                            livePart:GetChildren()
                        ) do
                            pcall(function()
                                child:Destroy()
                            end)
                        end

                        for _, child in ipairs(
                            basePart:GetChildren()
                        ) do
                            pcall(function()
                                child:Clone().Parent =
                                    livePart
                            end)
                        end
                    end
                end
            end

            --// Restore the actual skin captured from the live
            --// Humanoid, instead of leaving the PlayerCache skin.
            local restoredSkin = false

            pcall(function()
                humanoid:ApplyDescriptionResetAsync(
                    __UI.__L.cosmetic.skinDescription
                )

                restoredSkin = true
            end)

            if not restoredSkin then
                pcall(function()
                    humanoid:ApplyDescriptionReset(
                        __UI.__L.cosmetic.skinDescription
                    )

                    restoredSkin = true
                end)
            end

            if not restoredSkin then
                pcall(function()
                    humanoid:ApplyDescriptionAsync(
                        __UI.__L.cosmetic.skinDescription
                    )

                    restoredSkin = true
                end)
            end

            if not restoredSkin then
                error(
                    "Failed to restore saved skin"
                )
            end

            local useLoadout =
                require(
                    ReplicatedStorage.Shared.UserData.ClientHooks:WaitForChild(
                        "useLoadout"
                    )
                )

            local equipped = {}

            local function containsCosmetic(id)
                id = tonumber(id)

                if not id then
                    return false
                end

                for _, existing in ipairs(equipped) do
                    if tonumber(existing) == id then
                        return true
                    end
                end

                return false
            end

            for slotIndex = 1, 2 do
                local id =
                    tonumber(
                        useLoadout.GetEquippedFromSlot(
                            "CosmeticSlot_"
                                .. tostring(slotIndex)
                        )
                    )

                local state =
                    __UI.__L.cosmetic.slots[
                        slotIndex
                    ]

                local directAction =
                    __UI.__L.cosmetic.directAction[
                        slotIndex
                    ]

                if directAction == "remove" then
                elseif id
                    and id ~= 0
                then
                    local effectiveId =
                        id

                    if __UI.__L.cosmetic.enabled then
                        if state
                            and state.originalId
                            and state.replaceId
                            and tonumber(
                                state.originalId
                            ) == id
                            and tonumber(
                                state.originalId
                            )
                                ~= tonumber(
                                    state.replaceId
                                )
                        then
                            effectiveId =
                                tonumber(
                                    state.replaceId
                                )
                        end
                    end

                    table.insert(
                        equipped,
                        effectiveId
                    )
                end

                if directAction == "add" then
                    local replaceId =
                        state
                        and tonumber(
                            state.replaceId
                        )

                    if replaceId
                        and replaceId ~= 0
                        and not containsCosmetic(
                            replaceId
                        )
                    then
                        table.insert(
                            equipped,
                            replaceId
                        )
                    end
                end
            end
            --// Remember everything that exists before AddCosmetics.
            --// Direct ADD works even when SWAP is OFF, so first-person
            --// handling must not depend on cosmetic.enabled.
            local cosmeticObjectsBeforeAdd = {}

            for _, object in ipairs(
                live:GetDescendants()
            ) do
                cosmeticObjectsBeforeAdd[object] = true

                if object:IsA("BasePart") then
                    pcall(function()
                        object:SetAttribute(
                            "DeadEyeFirstPersonCosmetic",
                            nil
                        )
                    end)
                end
            end

            local AddCosmetics =
                require(
                    ReplicatedStorage.Services.Asset.RigService:WaitForChild(
                        "AddCosmetics"
                    )
                )

            --// RigService:AddCosmetics() can emit a harmless warning when
            --// a cosmetic contains CharacterClassic without the expected
            --// HumanoidRootPart limb. The cosmetic still applies correctly.
            --// Suppress ONLY this exact AddCosmetics warning; preserve every
            --// other warn() message.
            local previousWarn =
                warn

            warn =
                function(...)
                    local args = {
                        ...
                    }

                    local first =
                        tostring(
                            args[1]
                        )

                    if first
                        :find(
                            '^%[AddCosmetics%] Rig has no limb named "HumanoidRootPart" for cosmetic "CharacterClassic"$'
                        )
                    then
                        return
                    end

                    previousWarn(
                        table.unpack(
                            args
                        )
                    )
                end

            local addCosmeticsOK,
                addCosmeticsError =
                pcall(function()
                    AddCosmetics(
                        live,
                        equipped
                    )
                end)

            warn =
                previousWarn

            if not addCosmeticsOK then
                error(
                    addCosmeticsError
                )
            end

            --// Mark every newly-created cosmetic visual, regardless
            --// whether SWAP is ON. Tag the Accessory itself and
            --// supported visual descendants for native Visibility.
            for _, object in ipairs(
                live:GetDescendants()
            ) do
                if not cosmeticObjectsBeforeAdd[object]
                    and (
                        object:IsA("Accessory")
                        or object:IsA("BasePart")
                        or object:IsA("Decal")
                        or object:IsA("Texture")
                        or object:IsA("ParticleEmitter")
                        or object:IsA("Trail")
                        or object:IsA("Beam")
                        or object:IsA("BillboardGui")
                        or object:IsA("SurfaceGui")
                        or object:IsA("Sparkles")
                        or object:IsA("Fire")
                        or object:IsA("Smoke")
                        or object:IsA("Highlight")
                    )
                then
                    pcall(function()
                        object:SetAttribute(
                            "DeadEyeFirstPersonCosmetic",
                            true
                        )
                    end)
                end
            end

            if restoreUnusualSwap then
                pcall(function()
                    if __UI.__L.UnusualFns.activateUnusual() then
                        __UI.__L.unusualEnabled = true
                        __UI.__L.unusualActive = true
                        __UI.__L.unusualRuntime.appliedRig =
                            __UI.__L.UnusualFns.getUnusualVisualRig()
                    end
                end)
            elseif restoreNativeUnusualId then
                if cosmeticUnusualSnapshot then
                    pcall(function()
                        __UI.__L.UnusualFns.restoreNativeUnusualSnapshot(
                            cosmeticUnusualSnapshot,
                            __UI.__L.UnusualFns.getUnusualVisualRig(),
                            __UI.__L.UnusualFns.getUnusualPlayerCharacter()
                        )
                    end)
                else
                    pcall(function()
                        applyUnusualFX(
                            restoreNativeUnusualId,
                            __UI.__L.UnusualFns.getUnusualVisualRig(),
                            __UI.__L.UnusualFns.getUnusualPlayerCharacter()
                        )
                    end)
                end
            end
        end)

    __UI.__L.cosmetic.skinCharacter =
        live

    __UI.__L.cosmetic.refreshBusy = false

    return success
end

function __UI.__L.cosmetic.installHook()
    if __UI.__L.cosmetic.hooked
        or type(hookfunction) ~= "function"
    then
        return false
    end

    local rigService
    pcall(function()
        rigService =
            require(
                ReplicatedStorage.Services.Asset.RigService
            )
    end)

    local target =
        rigService
        and rigService.SetRig

    if type(target) ~= "function" then
        return false
    end

    local original
    local ok =
        pcall(function()
            original =
                hookfunction(
                    target,
                    function(
                        self,
                        character,
                        rigType,
                        cosmetics,
                        gear,
                        boombox
                    )
                        __UI.__L.cosmetic.lastSetRigArgs = {
                            self = self,
                            character = character,
                            rigType = rigType,
                            cosmetics = cosmetics,
                            gear = gear,
                            boombox = boombox
                        }

                        local liveBefore =
                            workspace:FindFirstChild("Rigs")
                            and workspace.Rigs:FindFirstChild(
                                LocalPlayer.Name
                            )

                        if liveBefore
                            and liveBefore:IsA("Model")
                            and (
                                not __UI.__L.cosmetic.skinDescription
                                or __UI.__L.cosmetic.skinCharacter == liveBefore
                            )
                        then
                            local beforeHumanoid =
                                liveBefore:FindFirstChildOfClass(
                                    "Humanoid"
                                )

                            if beforeHumanoid then
                                pcall(function()
                                    local description =
                                        beforeHumanoid:GetAppliedDescription()

                                    local clone =
                                        description:Clone()

                                    __UI.__L.cosmetic.skinDescription =
                                        clone
                                    __UI.__L.cosmetic.skinCharacter =
                                        liveBefore
                                end)
                            end
                        end

                        -- SetRig receives the game's character wrapper
                        -- (a table), not necessarily a Roblox Model.
                        -- Never call Instance methods on it here.
                        local result =
                            original(
                                self,
                                character,
                                rigType,
                                __UI.__L.cosmetic.replaceArray(
                                    cosmetics
                                ),
                                gear,
                                boombox
                            )

                        if __UI.__L.cosmetic.skinDescription
                            and type(result) == "table"
                            and result.Model
                            and result.Model:IsA("Model")
                            and result.Model.Parent
                                == workspace:FindFirstChild("Rigs")
                            and result.Model.Name
                                == LocalPlayer.Name
                        then
                            task.defer(function()
                                if genv.DEADEYE_MAIN_RUNNING
                                    and not __UI.__L.cosmetic.refreshBusy
                                then
                                    pcall(
                                        __UI.__L.cosmetic.refreshRig
                                    )
                                end
                            end)
                        end

                        return result
                    end
                )
        end)

    if not ok
        or type(original) ~= "function"
    then
        return false
    end

    __UI.__L.cosmetic.targetSetRig =
        target
    __UI.__L.cosmetic.originalSetRig =
        original
    __UI.__L.cosmetic.hooked = true

    return true
end

function __UI.__L.cosmetic.removeHook()
    if not __UI.__L.cosmetic.hooked
        or type(hookfunction) ~= "function"
    then
        return
    end

    pcall(function()
        if __UI.__L.cosmetic.targetSetRig
            and __UI.__L.cosmetic.originalSetRig
        then
            hookfunction(
                __UI.__L.cosmetic.targetSetRig,
                __UI.__L.cosmetic.originalSetRig
            )
        end
    end)

    __UI.__L.cosmetic.hooked = false
    __UI.__L.cosmetic.targetSetRig = nil
    __UI.__L.cosmetic.originalSetRig = nil
    __UI.__L.cosmetic.lastSetRigArgs = nil
end

function __UI.__L.cosmetic.updateToggle()
    pcall(function()
        if __UI.__L.cosmetic.enabled then
            __UI.__L.Toggle.Text =
                "SWAP: ON"
            __UI.__L.Toggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            __UI.__L.Toggle.Text =
                "SWAP: OFF"
            __UI.__L.Toggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end)
end

function __UI.__L.cosmetic.closePicker()
    __UI.__L.cosmetic.picking = false
    __UI.__L.cosmetic.pickerSide = nil
    if __UI.__L.unusualPicker then
        __UI.__L.unusualPicker.Visible = false
    end
end

function __UI.__L.cosmetic.select(
    slotIndex,
    side,
    id,
    name
)
    local state =
        __UI.__L.cosmetic.slots[slotIndex]

    if not state then
        return
    end

    if side == "Original" then
        state.originalId = id
        state.originalName = name
    elseif side == "Replace" then
        state.replaceId = id
        state.replaceName = name
    else
        return
    end

    __UI.__L.cosmetic.directAction[slotIndex] = nil

    __UI.__L.cosmetic.saveState()
    pcall(saveSavedConfig)

    if __UI.__L.cosmetic.enabled then
        __UI.__L.cosmetic.enabled = false
        pcall(__UI.__L.cosmetic.updateToggle)

        task.spawn(function()
            pcall(__UI.__L.cosmetic.refreshRig)
        end)
    end

    -- The executor may invoke this picker callback from a
    -- thread without Instance access. Never let GUI access
    -- prevent the actual selection from being saved.
    pcall(function()
        __UI.__L.cosmetic.closePicker()
    end)

    pcall(function()
        local row =
            __UI.__L.cosmetic.page
            and __UI.__L.cosmetic.page:FindFirstChild(
                "CosmeticRow_"
                    .. tostring(slotIndex)
            )

        if row then
            local a =
                row:FindFirstChild(
                    "OriginalButton"
                )
            local b =
                row:FindFirstChild(
                    "ReplaceButton"
                )

            if a then
                a.Text =
                    state.originalName
                    or "Select"
            end

            if b then
                b.Text =
                    state.replaceName
                    or "NONE"
            end
        end
    end)

    -- The new mapping is kept disabled until the user
    -- explicitly turns Cosmetic Swap back on.
end

--// =========================================================
--// COSMETIC NATIVE VIEWPORT PREVIEW
--// Mirrors ClientItemService:GetVisualModel/CreateViewport.
--// =========================================================
function __UI.__L.cosmetic.createPreview(
    id,
    viewport
)
    if not viewport then
        return false
    end

    local module
    local moduleOK =
        pcall(function()
            local entry =
                __UI.__L.Registry.GetById(
                    tonumber(id)
                )
            module =
                entry
                and entry.Module
        end)

    if not moduleOK
        or not module
    then
        return false
    end

    local data
    local dataOK =
        pcall(function()
            data = require(module)
        end)

    if not dataOK
        or type(data) ~= "table"
    then
        return false
    end

    local appearance =
        type(data.AppearanceInfo) == "table"
        and data.AppearanceInfo
        or {}

    local isR15 = false

    pcall(function()
        local character =
            LocalPlayer.Character

        local humanoid =
            character
            and character:FindFirstChildOfClass(
                "Humanoid"
            )

        if humanoid then
            isR15 =
                humanoid.RigType
                == Enum.HumanoidRigType.R15
        end
    end)

    local source

    if isR15
        and module:FindFirstChild("Character")
    then
        source =
            module:FindFirstChild(
                "Character"
            )
    elseif not module:FindFirstChild(
        "CharacterClassic"
    )
        and module:FindFirstChild(
            "Character"
        )
    then
        source =
            module:FindFirstChild(
                "Character"
            )
    else
        source =
            module:FindFirstChild(
                "CharacterClassic"
            )
    end

    if not source
        or not source:IsA("Model")
    then
        return false
    end

    local visual

    local cloneOK =
        pcall(function()
            visual =
                source:Clone()
        end)

    if not cloneOK
        or not visual
    then
        return false
    end

    if appearance.CameraType == "Back" then
        pcall(function()
            if isR15 then
                local lowerTorso =
                    visual:FindFirstChild(
                        "LowerTorso"
                    )

                local root =
                    lowerTorso
                    and lowerTorso:FindFirstChild(
                        "Root"
                    )

                if root
                    and root:IsA("Motor6D")
                then
                    root.C0 =
                        CFrame.Angles(
                            0,
                            math.pi,
                            0
                        )
                        * root.C0
                end
            else
                local humanoidRootPart =
                    visual:FindFirstChild(
                        "HumanoidRootPart"
                    )

                local torsoRot =
                    humanoidRootPart
                    and humanoidRootPart:FindFirstChild(
                        "TorsoRot"
                    )

                if torsoRot
                    and torsoRot:IsA("Motor6D")
                then
                    torsoRot.C0 =
                        CFrame.Angles(
                            0,
                            math.pi,
                            0
                        )
                        * torsoRot.C0
                end
            end
        end)
    end

    if not visual.PrimaryPart then
        visual.PrimaryPart =
            visual:FindFirstChild(
                "HumanoidRootPart"
            )
    end

    if not visual.PrimaryPart then
        visual:Destroy()
        return false
    end

    for _, child in ipairs(
        viewport:GetChildren()
    ) do
        pcall(function()
            child:Destroy()
        end)
    end

    local worldModel =
        Instance.new(
            "WorldModel"
        )

    local camera =
        Instance.new(
            "Camera"
        )

    local rootCFrame =
        visual.PrimaryPart.CFrame

    local cameraCFrame

    if appearance.CameraType == "Head" then
        cameraCFrame =
            CFrame.new(
                0,
                1.65,
                0
            )
            * CFrame.new(
                (
                    rootCFrame
                    * CFrame.new(
                        0.85,
                        -0.51,
                        -5.1
                    )
                ).Position,
                rootCFrame.Position
            )
    elseif appearance.CameraType == "Back" then
        cameraCFrame =
            CFrame.new(
                0,
                0.34,
                0
            )
            * CFrame.new(
                (
                    rootCFrame
                    * CFrame.new(
                        4.25,
                        1.7,
                        8.5
                    )
                ).Position,
                rootCFrame.Position
            )
    else
        cameraCFrame =
            CFrame.new(
                0,
                0.34,
                0
            )
            * CFrame.new(
                (
                    rootCFrame
                    * CFrame.new(
                        4.25,
                        1.7,
                        -8.5
                    )
                ).Position,
                rootCFrame.Position
            )
    end

    visual.Parent =
        worldModel

    camera.CFrame =
        cameraCFrame

    camera.FieldOfView =
        30

    worldModel.Parent =
        viewport

    camera.Parent =
        worldModel

    viewport.CurrentCamera =
        camera

    return true
end

function __UI.__L.cosmetic.rebuildPicker()
    for _, button in ipairs(
        __UI.__L.unusualPickerButtons
    ) do
        pcall(function()
            local preview =
                button:FindFirstChild(
                    "CosmeticPreview",
                    true
                )

            if preview
                and preview.Parent
            then
                local id =
                    tonumber(
                        string.match(
                            button.Name,
                            "^Cosmetic_(%d+)$"
                        )
                    )

                if id then
                    __UI.__L.cosmeticPreviewCache[id] =
                        preview

                    preview.Parent =
                        __UI.__L.cosmeticPreviewCacheHolder
                end
            end
        end)

        pcall(function()
            button:Destroy()
        end)
    end
    table.clear(
        __UI.__L.unusualPickerButtons
    )

    local query =
        string.lower(
            __UI.__L.unusualPickerSearch.Text
            or ""
        )
    local shown = 0

    do
        local button =
            Instance.new(
                "TextButton"
            )
        button.Name =
            "Cosmetic_None"
        button:SetAttribute("DeadEyePickerSearch", "none")
        button.BackgroundColor3 =
            Color3.fromRGB(
                55,
                58,
                68
            )
        button.BackgroundTransparency = 0.12
        button.BorderSizePixel = 0
        button.ClipsDescendants = true
        button.Text = "NONE"
        button.TextSize = 11
        button.Font =
            Enum.Font.GothamBold
        button.TextColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            )
        button.TextTruncate =
            Enum.TextTruncate.AtEnd
        button.LayoutOrder = 0
        button.ZIndex = 32
        button.Parent =
            __UI.__L.unusualPickerScroll

        local corner =
            Instance.new(
                "UICorner"
            )
        corner.CornerRadius =
            UDim.new(0, 5)
        corner.Parent =
            button

        table.insert(
            __UI.__L.unusualPickerButtons,
            button
        )

        __UI.__L.UnusualFns.addUnusualConnection(
            button.MouseButton1Click:Connect(
                function()
                    local slotIndex =
                        tonumber(
                            string.match(
                                __UI.__L.cosmetic.pickerSide
                                    or "",
                                "^(%d+):"
                            )
                        )
                    local side =
                        string.match(
                            __UI.__L.cosmetic.pickerSide
                                or "",
                            "^%d+:(.+)$"
                        )

                    if slotIndex and side then
                        __UI.__L.cosmetic.select(
                            slotIndex,
                            side,
                            nil,
                            nil
                        )
                    end
                end
            )
        )
        shown += 1
    end

    for index, data in ipairs(
        __UI.__L.cosmetic.list
    ) do
        local name =
            tostring(
                data.name
                or data.id
            )
        local lower =
            string.lower(name)
        local idText =
            tostring(data.id)

        if query == ""
            or string.find(
                lower,
                query,
                1,
                true
            )
            or string.find(
                idText,
                query,
                1,
                true
            )
        then
            shown += 1

            local button =
                Instance.new(
                    "TextButton"
                )
            button.Name =
                "Cosmetic_"
                    .. tostring(
                        data.id
                    )
            button:SetAttribute(
                "DeadEyePickerSearch",
                lower
            )
            button.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            button.BackgroundColor3 =
                Color3.fromRGB(
                    31,
                    35,
                    42
                )
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            --// Match the working Emote/Unusual cards.
            --// The rounded outer button clips the full-size card contents.
            button.ClipsDescendants = true
            button.Text = ""
            button.ZIndex = 32
            button.LayoutOrder = index

            --// Match the actual visible Cosmetic card layers.
            --// The preview/overlay are rounded to 10 px, so the outer
            --// button must use the same radius for UIShadow to follow
            --// the real card silhouette instead of appearing square.
            local buttonCorner =
                Instance.new(
                    "UICorner"
                )
            buttonCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            buttonCorner.Parent =
                button

            button.Parent =
                __UI.__L.unusualPickerScroll

            --// UICorner does not clip descendants. The cosmetic preview
            --// contains a WorldModel, so use CanvasGroup as the rounded
            --// render mask for the entire card.
            local cardGroup =
                Instance.new(
                    "CanvasGroup"
                )
            cardGroup.Name =
                "CosmeticCard"
            cardGroup.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            cardGroup.BackgroundTransparency =
                1
            cardGroup.BorderSizePixel =
                0
            cardGroup.ZIndex =
                33
            cardGroup.Parent =
                button

            local cardGroupCorner =
                Instance.new(
                    "UICorner"
                )
            cardGroupCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            cardGroupCorner.Parent =
                cardGroup

            local preview =
                Instance.new(
                    "ViewportFrame"
                )
            preview.Name =
                "CosmeticPreview"
            preview.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            preview.BackgroundColor3 =
                Color3.fromRGB(
                    31,
                    35,
                    42
                )
            preview.BackgroundTransparency =
                0
            preview.BorderSizePixel =
                0
            preview.ClipsDescendants =
                true
            preview.Active =
                false
            preview.ZIndex =
                33
            preview.Parent =
                cardGroup

            local previewCorner =
                Instance.new(
                    "UICorner"
                )
            previewCorner.CornerRadius =
                UDim.new(0, 10)
            previewCorner.Parent =
                preview

            local cachedPreview =
                __UI.__L.cosmeticPreviewCache[data.id]

            if cachedPreview
                and cachedPreview.Parent
            then
                pcall(function()
                    preview:Destroy()
                end)

                local reparentOK =
                    pcall(function()
                        cachedPreview.Parent =
                            cardGroup
                    end)

                if reparentOK then
                    preview =
                        cachedPreview
                else
                    __UI.__L.cosmeticPreviewCache[data.id] =
                        nil

                    preview =
                        Instance.new(
                            "ViewportFrame"
                        )

                    preview.Name =
                        "CosmeticPreview"

                    preview.Size =
                        UDim2.new(
                            1,
                            0,
                            1,
                            0
                        )

                    preview.BackgroundColor3 =
                        Color3.fromRGB(
                            31,
                            35,
                            42
                        )

                    preview.BackgroundTransparency =
                        0

                    preview.BorderSizePixel =
                        0

                    preview.ClipsDescendants =
                        true

                    preview.Active =
                        false

                    preview.ZIndex =
                        33

                    preview.Parent =
                        cardGroup

                    pcall(function()
                        __UI.__L.cosmetic.createPreview(
                            data.id,
                            preview
                        )
                    end)

                    __UI.__L.cosmeticPreviewCache[
                        data.id
                    ] = preview
                end
            else
                if cachedPreview then
                    __UI.__L.cosmeticPreviewCache[
                        data.id
                    ] = nil
                end

                pcall(function()
                    __UI.__L.cosmetic.createPreview(
                        data.id,
                        preview
                    )
                end)

                __UI.__L.cosmeticPreviewCache[data.id] =
                    preview
            end

            local glass =
                Instance.new(
                    "Frame"
                )
            glass.Name =
                "GlassOverlay"
            glass.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            glass.BackgroundColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            glass.BackgroundTransparency = 0.95
            glass.BorderSizePixel = 0
            glass.ZIndex = 34
            glass.Parent =
                cardGroup

            local glassCorner =
                Instance.new(
                    "UICorner"
                )
            glassCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            glassCorner.Parent =
                glass

            local shade =
                Instance.new(
                    "Frame"
                )
            shade.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    36
                )
            shade.Position =
                UDim2.new(
                    0,
                    0,
                    1,
                    -36
                )
            shade.BackgroundColor3 =
                Color3.fromRGB(
                    0,
                    0,
                    0
                )
            shade.BackgroundTransparency = 0.42
            shade.BorderSizePixel = 0
            shade.ZIndex = 35
            shade.Parent =
                cardGroup

            local shadeCorner =
                Instance.new(
                    "UICorner"
                )
            shadeCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            shadeCorner.Parent =
                shade

            local nameLabel =
                Instance.new(
                    "TextLabel"
                )
            nameLabel.Size =
                UDim2.new(
                    1,
                    -12,
                    0,
                    30
                )
            nameLabel.Position =
                UDim2.new(
                    0,
                    6,
                    1,
                    -33
                )
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = name
            nameLabel.TextSize = 11
            nameLabel.Font =
                Enum.Font.GothamMedium
            nameLabel.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            nameLabel.TextXAlignment =
                Enum.TextXAlignment.Left
            nameLabel.TextYAlignment =
                Enum.TextYAlignment.Center
            nameLabel.TextTruncate =
                Enum.TextTruncate.AtEnd
            nameLabel.ZIndex = 36
            nameLabel.Parent =
                cardGroup

            table.insert(
                __UI.__L.unusualPickerButtons,
                button
            )

            __UI.__L.UnusualFns.addUnusualConnection(
                button.MouseButton1Click:Connect(
                    function()
                        local slotIndex =
                            tonumber(
                                string.match(
                                    __UI.__L.cosmetic.pickerSide
                                        or "",
                                    "^(%d+):"
                                )
                            )
                        local side =
                            string.match(
                                __UI.__L.cosmetic.pickerSide
                                    or "",
                                "^%d+:(.+)$"
                            )

                        if slotIndex and side then
                            __UI.__L.cosmetic.select(
                                slotIndex,
                                side,
                                data.id,
                                data.name
                            )
                        end
                    end
                )
            )
        end
    end

    __UI.__L.unusualPickerScroll.CanvasPosition =
        Vector2.new(
            0,
            0
        )

    if __UI.__L.unusualStatus then
        __UI.__L.unusualStatus.Text =
            "Cosmetics: "
                .. tostring(
                    #__UI.__L.cosmetic.list
                )
                .. " • "
                .. tostring(
                    shown
                )
                .. " found"
    end
    __UI.__L.cosmeticPickerPreloaded = true
end

function __UI.__L.cosmetic.openPicker(
    slotIndex,
    side
)
    __UI.__L.cosmetic.picking = true
    __UI.__L.cosmetic.pickerSide =
        tostring(slotIndex)
        .. ":"
        .. side

    __UI.__L.unusualPickerTitle.Text =
        side == "Original"
        and "Select Original"
        or "Select Replacement"
    __UI.__L.unusualPickerSearch.Text = ""
    if not __UI.__L.cosmeticPickerPreloaded then
        __UI.__L.cosmetic.rebuildPicker()
    end

    __UI.animatePickerAppear(
        __UI.__L.unusualPicker
    )
end

function __UI.__L.cosmetic.buildUI()
    __UI.__L.cosmetic.page =
        Instance.new(
            "ScrollingFrame"
        )
    __UI.__L.cosmetic.page.Name =
        "CosmeticPage"
    __UI.__L.cosmetic.page.Size =
        UDim2.new(
            1,
            -92,
            1,
            -56
        )
    __UI.__L.cosmetic.page.Position =
        UDim2.new(
            0,
            82,
            0,
            48
        )
    __UI.__L.cosmetic.page.BackgroundColor3 =
        Color3.fromRGB(
            32,
            32,
            32
        )
    __UI.__L.cosmetic.page.BorderSizePixel = 0
    __UI.__L.cosmetic.page.ScrollBarThickness = 6
    __UI.__L.cosmetic.page.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            0
        )
    __UI.__L.cosmetic.page.AutomaticCanvasSize =
        Enum.AutomaticSize.Y
    __UI.__L.cosmetic.page.Visible = false
    __UI.__L.cosmetic.page.Parent =
        __UI.__L.Main

    local corner =
        Instance.new(
            "UICorner"
        )
    corner.CornerRadius =
        UDim.new(
            0,
            9
        )
    corner.Parent =
        __UI.__L.cosmetic.page

    local padding =
        Instance.new(
            "UIPadding"
        )
    padding.PaddingTop =
        UDim.new(
            0,
            8
        )
    padding.PaddingBottom =
        UDim.new(
            0,
            8
        )
    padding.PaddingLeft =
        UDim.new(
            0,
            8
        )
    padding.PaddingRight =
        UDim.new(
            0,
            8
        )
    padding.Parent =
        __UI.__L.cosmetic.page

    local layout =
        Instance.new(
            "UIListLayout"
        )
    layout.Padding =
        UDim.new(
            0,
            7
        )
    layout.SortOrder =
        Enum.SortOrder.LayoutOrder
    layout.Parent =
        __UI.__L.cosmetic.page

    __UI.__L.cosmetic.pageStatus =
        Instance.new(
            "TextLabel"
        )
    __UI.__L.cosmetic.pageStatus.Name =
        "CosmeticStatus"
    __UI.__L.cosmetic.pageStatus.Size =
        UDim2.new(
            1,
            -4,
            0,
            18
        )
    __UI.__L.cosmetic.pageStatus.BackgroundTransparency = 1
    __UI.__L.cosmetic.pageStatus.Text =
        "Cosmetics: "
            .. tostring(
                #__UI.__L.cosmetic.list
            )
    __UI.__L.cosmetic.pageStatus.TextSize = 11
    __UI.__L.cosmetic.pageStatus.Font =
        Enum.Font.Gotham
    __UI.__L.cosmetic.pageStatus.TextColor3 =
        Color3.fromRGB(
            145,
            145,
            145
        )
    __UI.__L.cosmetic.pageStatus.TextXAlignment =
        Enum.TextXAlignment.Left
    __UI.__L.cosmetic.pageStatus.LayoutOrder = 1
    __UI.__L.cosmetic.pageStatus.Parent =
        __UI.__L.cosmetic.page

    __UI.__L.Toggle.Parent =
        __UI.__L.cosmetic.page
    __UI.__L.Toggle.LayoutOrder = 0

    for slotIndex = 1, 2 do
        local state =
            __UI.__L.cosmetic.slots[slotIndex]

        local row =
            Instance.new(
                "Frame"
            )
        row.Name =
            "CosmeticRow_"
                .. tostring(
                    slotIndex
                )
        row.Size =
            UDim2.new(
                1,
                -4,
                0,
                48
            )
        row.BackgroundColor3 =
            Color3.fromRGB(
                40,
                40,
                40
            )
        row.BorderSizePixel = 0
        row.LayoutOrder =
            slotIndex + 1
        row.Parent =
            __UI.__L.cosmetic.page

        local rowCorner =
            Instance.new(
                "UICorner"
            )
        rowCorner.CornerRadius =
            UDim.new(
                0,
                7
            )
        rowCorner.Parent =
            row

        local label =
            Instance.new(
                "TextLabel"
            )
        label.Size =
            UDim2.new(
                0,
                64,
                1,
                0
            )
        label.Position =
            UDim2.new(
                0,
                8,
                0,
                0
            )
        label.BackgroundTransparency = 1
        label.Text =
            "COSMETIC "
                .. tostring(
                    slotIndex
                )
        label.TextSize = 11
        label.Font =
            Enum.Font.GothamBold
        label.TextColor3 =
            Color3.fromRGB(
                210,
                210,
                210
            )
        label.TextXAlignment =
            Enum.TextXAlignment.Left
        label.Parent =
            row

        local a =
            Instance.new(
                "TextButton"
            )
        a.Name =
            "OriginalButton"
        a.Size =
            UDim2.new(
                0,
                80,
                0,
                32
            )
        a.Position =
            UDim2.new(
                0,
                78,
                0.5,
                -16
            )
        a.BackgroundColor3 =
            Color3.fromRGB(
                52,
                52,
                52
            )
        a.BorderSizePixel = 0
        a.Text =
            state.originalName
            or "Select"
        a.TextSize = 10
        a.Font =
            Enum.Font.GothamBold
        a.TextColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            )
        a.TextTruncate =
            Enum.TextTruncate.AtEnd
        a.Parent =
            row

        local ac =
            Instance.new(
                "UICorner"
            )
        ac.CornerRadius =
            UDim.new(
                0,
                7
            )
        ac.Parent =
            a

        local arrow =
            Instance.new(
                "TextLabel"
            )
        arrow.Size =
            UDim2.new(
                0,
                12,
                0,
                32
            )
        arrow.Position =
            UDim2.new(
                0,
                164,
                0.5,
                -16
            )
        arrow.BackgroundTransparency = 1
        arrow.Text = "→"
        arrow.TextSize = 17
        arrow.Font =
            Enum.Font.GothamBold
        arrow.TextColor3 =
            Color3.fromRGB(
                180,
                180,
                180
            )
        arrow.Parent =
            row

        local b =
            Instance.new(
                "TextButton"
            )
        b.Name =
            "ReplaceButton"
        b.Size =
            UDim2.new(
                0,
                82,
                0,
                32
            )
        b.Position =
            UDim2.new(
                0,
                182,
                0.5,
                -16
            )
        b.BackgroundColor3 =
            Color3.fromRGB(
                52,
                52,
                52
            )
        b.BorderSizePixel = 0
        b.Text =
            state.replaceName
            or "NONE"
        b.TextSize = 10
        b.Font =
            Enum.Font.GothamBold
        b.TextColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            )
        b.TextTruncate =
            Enum.TextTruncate.AtEnd
        b.Parent =
            row

        local bc =
            Instance.new(
                "UICorner"
            )
        bc.CornerRadius =
            UDim.new(
                0,
                7
            )
        bc.Parent =
            b

        local addButton =
            Instance.new(
                "TextButton"
            )
        addButton.Name =
            "ApplyButton"
        addButton.Size =
            UDim2.new(
                0,
                48,
                0,
                32
            )
        addButton.Position =
            UDim2.new(
                0,
                270,
                0.5,
                -16
            )
        addButton.BackgroundColor3 =
            Color3.fromRGB(
                52,
                52,
                52
            )
        addButton.BorderSizePixel = 0
        addButton.Text =
            "ADD"
        addButton.TextSize = 10
        addButton.Font =
            Enum.Font.GothamBold
        addButton.TextColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            )
        addButton.Parent =
            row

        local addCorner =
            Instance.new(
                "UICorner"
            )
        addCorner.CornerRadius =
            UDim.new(
                0,
                7
            )
        addCorner.Parent =
            addButton

        local removeButton =
            Instance.new(
                "TextButton"
            )
        removeButton.Name =
            "RemoveButton"
        removeButton.Size =
            UDim2.new(
                0,
                42,
                0,
                32
            )
        removeButton.Position =
            UDim2.new(
                0,
                326,
                0.5,
                -16
            )
        removeButton.BackgroundColor3 =
            Color3.fromRGB(
                52,
                52,
                52
            )
        removeButton.BorderSizePixel = 0
        removeButton.Text =
            "DEL"
        removeButton.TextSize = 10
        removeButton.Font =
            Enum.Font.GothamBold
        removeButton.TextColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            )
        removeButton.Parent =
            row

        local removeCorner =
            Instance.new(
                "UICorner"
            )
        removeCorner.CornerRadius =
            UDim.new(
                0,
                7
            )
        removeCorner.Parent =
            removeButton

        __UI.__L.UnusualFns.addUnusualConnection(
            a.MouseButton1Click:Connect(
                function()
                    __UI.__L.cosmetic.openPicker(
                        slotIndex,
                        "Original"
                    )
                end
            )
        )

        __UI.__L.UnusualFns.addUnusualConnection(
            b.MouseButton1Click:Connect(
                function()
                    __UI.__L.cosmetic.openPicker(
                        slotIndex,
                        "Replace"
                    )
                end
            )
        )

        __UI.__L.UnusualFns.addUnusualConnection(
            addButton.MouseButton1Click:Connect(
                function()
                    local current =
                        __UI.__L.cosmetic.slots[
                            slotIndex
                        ]

                    if not current
                        or not current.replaceId
                        or tonumber(
                            current.replaceId
                        ) == 0
                    then
                        return
                    end

                    __UI.__L.cosmetic.directAction[
                        slotIndex
                    ] = "add"

                    task.spawn(function()
                        pcall(
                            __UI.__L.cosmetic.refreshRig
                        )
                    end)
                end
            )
        )

        __UI.__L.UnusualFns.addUnusualConnection(
            removeButton.MouseButton1Click:Connect(
                function()
                    local current =
                        __UI.__L.cosmetic.slots[
                            slotIndex
                        ]

                    if not current then
                        return
                    end

                    local originalId =
                        tonumber(
                            current.originalId
                        )

                    local replaceId =
                        tonumber(
                            current.replaceId
                        )

                    --// If Original exists, remove it.
                    --// If only Replace exists, remove the
                    --// directly-added cosmetic instead.
                    if (
                        not originalId
                        or originalId == 0
                    )
                        and (
                            not replaceId
                            or replaceId == 0
                        )
                    then
                        return
                    end

                    __UI.__L.cosmetic.directAction[
                        slotIndex
                    ] = "remove"

                    task.spawn(function()
                        pcall(
                            __UI.__L.cosmetic.refreshRig
                        )
                    end)
                end
            )
        )
    end
end

function __UI.__L.cosmetic.cleanup()
    local wasEnabled =
        __UI.__L.cosmetic.enabled

    local hadDirectAdd = false

    for slotIndex = 1, 2 do
        if __UI.__L.cosmetic.directAction[slotIndex] == "add" then
            hadDirectAdd = true
            __UI.__L.cosmetic.directAction[slotIndex] = "remove"
        end
    end

    __UI.__L.cosmetic.enabled = false

    --// A previous refresh can still be rebuilding the live rig.
    --// Wait for it to finish so cleanup cannot leave the replacement
    --// cosmetics behind.
    local deadline =
        tick() + 1

    while __UI.__L.cosmetic.refreshBusy
        and tick() < deadline
    do
        task.wait()
    end

    if __UI.__L.cosmetic.refreshBusy then
        __UI.__L.cosmetic.refreshBusy = false
    end

    --// Always refresh while a live skin snapshot exists. This makes
    --// cleanup idempotent even when the swap was already disabled but
    --// its visual result is still present on the rig.
    if wasEnabled
        or hadDirectAdd
        or __UI.__L.cosmetic.skinDescription
    then
        pcall(function()
            __UI.__L.cosmetic.refreshRig()
        end)
    end

    __UI.__L.cosmetic.directAction[1] = nil
    __UI.__L.cosmetic.directAction[2] = nil

    __UI.__L.cosmetic.closePicker()
    __UI.__L.cosmetic.refreshBusy = false
    __UI.__L.cosmetic.removeHook()

    __UI.__L.cosmetic.skinDescription = nil
    __UI.__L.cosmetic.skinCharacter = nil

    pcall(function()
        if __UI.__L.cosmetic.page then
            __UI.__L.cosmetic.page:Destroy()
        end
    end)

    __UI.__L.cosmetic.page = nil
    __UI.__L.cosmetic.pageStatus = nil
end

function __UI.__L.UnusualFns.getUnusualName(id)
    id =
        tonumber(id)
    if not id then
        return nil
    end
    for _, data in ipairs(
        __UI.__L.unusualList
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
function __UI.__L.UnusualFns.getEquippedUnusualId()
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
        __UI.__L.UnusualFns.getEquippedUnusualId()
    if equipped ~= 0 then
        __UI.__L.unusualSlot.originalId =
            equipped
        __UI.__L.unusualSlot.originalName =
            __UI.__L.UnusualFns.getUnusualName(
                equipped
            )
    end
    local savedUnusual =
        __UI.__L.savedConfig.unusual
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
            __UI.__L.unusualSlot.originalId =
                savedOriginal
            __UI.__L.unusualSlot.originalName =
                __UI.__L.UnusualFns.getUnusualName(
                    savedOriginal
                )
        end
        if savedReplace then
            __UI.__L.unusualSlot.replaceId =
                savedReplace
        end
    end
    __UI.__L.unusualSlot.replaceName =
        __UI.__L.UnusualFns.getUnusualName(
            __UI.__L.unusualSlot.replaceId
        )
end
--// =========================================================
--// GET REAL PLAYER CHARACTER
--// =========================================================
function __UI.__L.UnusualFns.getUnusualPlayerCharacter()
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
function __UI.__L.UnusualFns.getUnusualVisualRig()
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
function __UI.__L.UnusualFns.getUnusualCosmeticRig(
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
__UI.__L.UNUSUAL_FX_CLASSES = {
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
function __UI.__L.UnusualFns.isUnusualFX(object)
    return __UI.__L.UNUSUAL_FX_CLASSES[
        object.ClassName
    ] == true
end
function __UI.__L.UnusualFns.unusualAttachmentHasFX(
    attachment
)
    for _, descendant in ipairs(
        attachment:GetDescendants()
    ) do
        if __UI.__L.UnusualFns.isUnusualFX(descendant) then
            return true
        end
    end
    return false
end

--// =========================================================
--// TAG OUR FX
--// =========================================================
function __UI.__L.UnusualFns.tagUnusualFX(
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

__UI.__L.mapUnusualAttachments = function(
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

            __UI.__L.mapUnusualAttachments(
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

__UI.__L.isUnusualJointObject = function(object)

    return object:IsA("Weld")
        or object:IsA("WeldConstraint")
        or object:IsA("Motor6D")
        or object:IsA("Motor")

end

__UI.__L.unusualNestedJointCache = setmetatable(
    {},
    { __mode = "k" }
)

__UI.__L.unusualJointHasNestedBasePart = function(joint)

    local cached =
        __UI.__L.unusualNestedJointCache[joint]

    if cached ~= nil then
        return cached
    end

    local found = false

    for _, descendant in ipairs(
        joint:GetDescendants()
    ) do

        if descendant:IsA("BasePart") then
            found = true
            break
        end

    end

    __UI.__L.unusualNestedJointCache[joint] =
        found

    return found

end

__UI.__L.unusualObjectBelongsToPart = function(
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

        --// A joint subtree containing nested BaseParts is installed whole.
        --// Do not separately clone FX carried inside that same subtree.
        if parent.Parent == sourcePart
            and __UI.__L.isUnusualJointObject(parent)
            and __UI.__L.unusualJointHasNestedBasePart(parent)
        then
            return false
        end

        parent =
            parent.Parent

    end

    return parent == sourcePart

end

__UI.__L.getNeededUnusualAttachments = function(
    sourcePart)

    local needed = {}

    for _, object in ipairs(
        sourcePart:GetDescendants()
    ) do

        if __UI.__L.unusualObjectBelongsToPart(
            object,
            sourcePart
        ) then

            if object:IsA("Trail")
                or object:IsA("Beam")
            then

                if object.Attachment0
                    and __UI.__L.unusualObjectBelongsToPart(
                        object.Attachment0,
                        sourcePart
                    )
                then

                    needed[
                        object.Attachment0
                    ] = true

                end

                if object.Attachment1
                    and __UI.__L.unusualObjectBelongsToPart(
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
            and __UI.__L.unusualObjectBelongsToPart(
                object,
                sourcePart
            )
            and __UI.__L.UnusualFns.unusualAttachmentHasFX(
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

__UI.__L.getUnusualAttachmentWorldCFrame = function(
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
            __UI.__L.getUnusualAttachmentWorldCFrame(
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

__UI.__L.unusualBasePartHasContent = function(
    sourcePart
)

    for _, object in ipairs(
        sourcePart:GetDescendants()
    ) do

        if __UI.__L.unusualObjectBelongsToPart(
            object,
            sourcePart
        ) then

            if __UI.__L.UnusualFns.isUnusualFX(object) then
                return true
            end

            if object:IsA("Attachment")
                and __UI.__L.UnusualFns.unusualAttachmentHasFX(
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
__UI.__L.unusualRuntime.destroyAnimationSource = function()
    if __UI.__L.unusualRuntime.animationSource then
        pcall(function()
            __UI.__L.unusualRuntime.animationSource:Destroy()
        end)
    end

    __UI.__L.unusualRuntime.animationSource = nil
    table.clear(
        __UI.__L.unusualRuntime.animationLinks
    )

    for _, mirror in ipairs(
        __UI.__L.unusualRuntime.visualMirrors
    ) do
        if mirror.model then
            pcall(function()
                mirror.model:Destroy()
            end)
        end
    end

    table.clear(
        __UI.__L.unusualRuntime.visualMirrors
    )

    if __UI.__L.unusualRuntime.specialCircling
        and __UI.__L.unusualRuntime.specialCircling.model
    then
        pcall(function()
            __UI.__L.unusualRuntime.specialCircling.model:Destroy()
        end)
    end

    __UI.__L.unusualRuntime.specialCircling = nil

    for _, item in ipairs(
        __UI.__L.unusualRuntime.animatedNestedVisuals
    ) do
        if item.model then
            pcall(function()
                item.model:Destroy()
            end)
        end
    end

    table.clear(
        __UI.__L.unusualRuntime.animatedNestedVisuals
    )
end

__UI.__L.unusualRuntime.findRelative = function(
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

__UI.__L.unusualRuntime.startAnimations = function(
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

__UI.__L.unusualRuntime.installAnimatedNestedModels = function(
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

                __UI.__L.UnusualFns.tagUnusualFX(
                    clone,
                    id
                )

                --// Start the same AnimationController
                --// animation that the source effect uses.
                __UI.__L.unusualRuntime.startAnimations(
                    clone
                )

                table.insert(
                    __UI.__L.unusualRuntime.animatedNestedVisuals,
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


__UI.__L.unusualRuntime.createAnimationSource = function(
    cosmeticRig,
    id,
    playerCharacter
)
    __UI.__L.unusualRuntime.destroyAnimationSource()

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
            __UI.__L.UnusualFns.getUnusualVisualRig()

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

        __UI.__L.unusualRuntime.startAnimations(
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

    __UI.__L.unusualRuntime.animationSource =
        source

    return source
end

__UI.__L.unusualRuntime.createVisualMirror = function(
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
            #__UI.__L.unusualRuntime.visualMirrors + 1
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

    --// The mirrored nested visual is another visible copy of the
    --// Unusual effect. Tag the whole clone so first-person handling
    --// also reaches its Trail/Beam/ParticleEmitter descendants.
    __UI.__L.UnusualFns.tagUnusualFX(
        clone,
        id
    )

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
        __UI.__L.unusualRuntime.visualMirrors,
        {
            model = clone,
            links = links
        }
    )

    return true
end

__UI.__L.unusualRuntime.addAnimationLink = function(
    sourcePart,
    nested,
    targetPart,
    animatedSource
)
    if not animatedSource then
        return false
    end

    local animatedPart =
        __UI.__L.unusualRuntime.findRelative(
            animatedSource,
            nested
        )

    local animatedRoot =
        __UI.__L.unusualRuntime.findRelative(
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
        __UI.__L.unusualRuntime.animationLinks,
        {
            sourceRoot = animatedRoot,
            sourcePart = animatedPart,
            targetPart = targetPart,
            anchor = nil
        }
    )

    return true
end

__UI.__L.unusualRuntime.updateAnimatedParts = function()
    local source =
        __UI.__L.unusualRuntime.animationSource

    if not source
        or not source.Parent
    then
        return
    end

    local targetRig =
        __UI.__L.UnusualFns.getUnusualVisualRig()

    local targetRoot

    if targetRig then
        targetRoot =
            targetRig:FindFirstChild(
                "HumanoidRootPart"
            )
    end

    if not targetRoot then
        local character =
            __UI.__L.UnusualFns.getUnusualPlayerCharacter()

        if character then
            targetRoot =
                character:FindFirstChild(
                    "HumanoidRootPart"
                )
        end
    end

    if __UI.__L.unusualRuntime.specialCircling
        and __UI.__L.unusualRuntime.specialCircling.root
        and __UI.__L.unusualRuntime.specialCircling.root.Parent
        and targetRoot
    then

        pcall(function()
            __UI.__L.unusualRuntime.specialCircling.root.CFrame =
                targetRoot.CFrame *
                __UI.__L.unusualRuntime.specialCircling.offset
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
        __UI.__L.unusualRuntime.visualMirrors
    ) do

        if mirror.model
            and mirror.model.Parent
        then

            for _, link in ipairs(
                mirror.links
            ) do

                if link.source
                    and link.source.Parent
                    and link.target
                    and link.target.Parent
                then

                    pcall(function()
                        link.target.CFrame =
                            link.source.CFrame
                    end)

                end

            end

        end

    end

    for _, link in ipairs(
        __UI.__L.unusualRuntime.animationLinks
    ) do

        local sourceRootPart =
            link.sourceRoot

        local sourcePart =
            link.sourcePart

        local targetPart =
            link.targetPart

        if sourceRootPart
            and sourceRootPart.Parent
            and sourcePart
            and sourcePart.Parent
            and targetPart
            and targetPart.Parent
        then

            pcall(function()
                sourceRootPart.Transparency = 1
                sourceRootPart.LocalTransparencyModifier = 1
                sourcePart.Transparency = 1
                sourcePart.LocalTransparencyModifier = 1
            end)

            local relative =
                sourceRootPart.CFrame:ToObjectSpace(
                    sourcePart.CFrame
                )

            local anchor =
                link.anchor

            if anchor
                and anchor.Parent
                and anchor:IsA("BasePart")
            then
                pcall(function()
                    anchor.CFrame =
                        targetPart.CFrame *
                        relative
                end)
            end

        end

    end
end


--// =========================================================
--// CREATE LOCAL ANCHOR FOR NESTED BASEPART
--// =========================================================

__UI.__L.createUnusualAnchor = function(
    sourceRoot,
    sourcePart,
    targetPart,
    id,
    index
)
    local anchor

    if sourcePart:IsA("MeshPart")
        or sourcePart:IsA("Part")
        or sourcePart:IsA("UnionOperation")
        or sourcePart:IsA("TrussPart")
    then

        local success =
            pcall(function()
                anchor =
                    sourcePart:Clone()
            end)

        if not success
            or not anchor
        then
            return nil
        end

        anchor.Name =
            "DeadEyeUnusualGeometry_" ..
            tostring(id) ..
            "_" ..
            tostring(index)

        for _, joint in ipairs(
            anchor:GetDescendants()
        ) do

            if joint:IsA("Weld")
                or joint:IsA("WeldConstraint")
                or joint:IsA("Motor6D")
                or joint:IsA("Motor")
                or joint:IsA("Script")
                or joint:IsA("LocalScript")
                or joint:IsA("ModuleScript")
            then

                pcall(function()
                    joint:Destroy()
                end)

            end

        end

        pcall(function()
            anchor.Anchored = false
            anchor.CanCollide = false
            anchor.CanTouch = false
            anchor.CanQuery = false
            anchor.Massless = true
            anchor.CastShadow = false
        end)

    else

        anchor =
            Instance.new("Part")

        anchor.Name =
            "DeadEyeUnusualAnchor_" ..
            tostring(id) ..
            "_" ..
            tostring(index)

        anchor.Size =
            Vector3.new(
                math.max(
                    sourcePart.Size.X,
                    0.05
                ),
                math.max(
                    sourcePart.Size.Y,
                    0.05
                ),
                math.max(
                    sourcePart.Size.Z,
                    0.05
                )
            )

        anchor.Transparency = 1
        anchor.CanCollide = false
        anchor.CanTouch = false
        anchor.CanQuery = false
        anchor.CastShadow = false
        anchor.Massless = true
        anchor.Anchored = false

    end

    local relative =
        sourceRoot.CFrame:ToObjectSpace(
            sourcePart.CFrame
        )

    anchor.CFrame =
        targetPart.CFrame *
        relative

    local parent =
        targetPart.Parent

    if not parent then
        pcall(function()
            anchor:Destroy()
        end)
        return nil
    end

    anchor.Parent =
        parent

    local weld =
        Instance.new("WeldConstraint")

    weld.Name =
        "DeadEyeUnusualWeld"

    weld.Part0 =
        targetPart

    weld.Part1 =
        anchor

    weld.Parent =
        anchor

    __UI.__L.UnusualFns.tagUnusualFX(
        anchor,
        id
    )

    return anchor
end

--// =========================================================
--// INSTALL ONE SOURCE PART
--// =========================================================

--// =========================================================
--// CLONE / REBIND COMPLETE WELDED COSMETIC TREES
--// =========================================================

__UI.__L.mapUnusualCloneTree = function(
    sourceRoot,
    cloneRoot,
    map
)

    map[sourceRoot] = cloneRoot

    local sourceChildren = sourceRoot:GetChildren()
    local cloneChildren = cloneRoot:GetChildren()
    local used = {}

    for _, sourceChild in ipairs(sourceChildren) do
        for _, cloneChild in ipairs(cloneChildren) do
            if not used[cloneChild]
                and cloneChild.Name == sourceChild.Name
                and cloneChild.ClassName == sourceChild.ClassName
            then
                used[cloneChild] = true
                __UI.__L.mapUnusualCloneTree(sourceChild, cloneChild, map)
                break
            end
        end
    end
end

__UI.__L.rebindUnusualCloneTree = function(
    sourceRoot,
    cloneRoot,
    map,
    sourcePart,
    targetPart
)

    local sourceObjects = { sourceRoot }

    for _, descendant in ipairs(sourceRoot:GetDescendants()) do
        table.insert(sourceObjects, descendant)
    end

    for _, sourceObject in ipairs(sourceObjects) do
        local cloneObject = map[sourceObject]

        if cloneObject then
            if __UI.__L.isUnusualJointObject(sourceObject) then
                for _, property in ipairs({ "Part0", "Part1" }) do
                    local originalPart

                    pcall(function()
                        originalPart = sourceObject[property]
                    end)

                    if originalPart then
                        local reboundPart

                        if sourcePart and originalPart == sourcePart then
                            reboundPart = targetPart
                        elseif originalPart == targetPart then
                            reboundPart = targetPart
                        else
                            reboundPart = map[originalPart]
                        end

                        --// Resolve references to sibling body parts on the live rig.
                        if not reboundPart and targetPart and targetPart.Parent then
                            local candidate =
                                targetPart.Parent:FindFirstChild(originalPart.Name)

                            if candidate and candidate:IsA("BasePart") then
                                reboundPart = candidate
                            end
                        end

                        if reboundPart then
                            pcall(function()
                                cloneObject[property] = reboundPart
                            end)
                        elseif sourcePart
                            and sourcePart.Parent
                            and originalPart:IsDescendantOf(sourcePart.Parent)
                        then
                            --// Do not leave the clone connected to a template limb.
                            pcall(function()
                                cloneObject[property] = nil
                            end)
                        end
                    end
                end
            elseif sourceObject:IsA("Beam") or sourceObject:IsA("Trail") then
                for _, property in ipairs({ "Attachment0", "Attachment1" }) do
                    local originalAttachment

                    pcall(function()
                        originalAttachment = sourceObject[property]
                    end)

                    local reboundAttachment =
                        originalAttachment and map[originalAttachment]

                    if reboundAttachment then
                        pcall(function()
                            cloneObject[property] = reboundAttachment
                        end)
                    end
                end
            end
        end
    end
end

__UI.__L.installUnusualWeldedTree = function(
    sourcePart,
    targetPart,
    rootJoint,
    id
)

    if not __UI.__L.isUnusualJointObject(rootJoint)
        or not __UI.__L.unusualJointHasNestedBasePart(rootJoint)
    then
        return false
    end

    local clone
    local ok = pcall(function()
        clone = rootJoint:Clone()
    end)

    if not ok or not clone then
        warn(
            "[UnusualSwapper] Failed to clone welded tree:",
            rootJoint:GetFullName()
        )
        return false
    end

    local cloneMap = {}
    __UI.__L.mapUnusualCloneTree(rootJoint, clone, cloneMap)

    --// Keep the Weld and its nested MeshParts/FX hierarchy together.
    clone.Parent = targetPart

    __UI.__L.rebindUnusualCloneTree(
        rootJoint,
        clone,
        cloneMap,
        sourcePart,
        targetPart
    )

    for _, object in ipairs(clone:GetDescendants()) do
        if object:IsA("BasePart") then
            pcall(function()
                object.Anchored = false
                object.Massless = true
                object.CanCollide = false
                object.CanTouch = false
                object.CanQuery = false
            end)
        elseif object:IsA("Script") then
            --// Match the native AddCosmetics behavior for scripts in cosmetics.
            pcall(function()
                object.Enabled = true
            end)
        end
    end

    __UI.__L.UnusualFns.tagUnusualFX(clone, id)
    return true
end

__UI.__L.installUnusualPartFX = function(
    sourcePart,
    targetPart,
    id,
    animatedSource
)

    local targetMap = {}
    local sourceNodes = {}

    --// Root source part uses the real visual part.
    targetMap[sourcePart] =
        targetPart

    table.insert(
        sourceNodes,
        sourcePart
    )

    --// Complete nested visual models (for example
    --// CirclingEclipseCola.spins) are mirrored as a
    --// self-contained mini-rig. Their internal Motor6D/Weld
    --// chain remains on the hidden animated source.
    for _, child in ipairs(
        sourcePart:GetChildren()
    ) do

        if child:IsA("Model") then

            local hasNestedPart = false
            local hasAnimationDriver = false

            for _, object in ipairs(
                child:GetDescendants()
            ) do

                if object:IsA("BasePart") then
                    hasNestedPart = true
                end

                if object:IsA("Motor6D")
                    or object:IsA("AnimationController")
                    or object:IsA("Animator")
                    or object:IsA("Script")
                    or object:IsA("LocalScript")
                then
                    hasAnimationDriver = true
                end

            end

            local hasAnimationController = false
            local hasAnimation = false

            for _, object in ipairs(
                child:GetDescendants()
            ) do
                if object:IsA("AnimationController") then
                    hasAnimationController = true
                elseif object:IsA("Animation") then
                    hasAnimation = true
                end
            end

            if hasNestedPart
                and hasAnimationDriver
                and not (
                    hasAnimationController
                    and hasAnimation
                )
            then
                __UI.__L.unusualRuntime.createVisualMirror(
                    child,
                    id
                )
            end

        end

    end

    --// Some Unusuals store geometry under direct Weld children of a body part
    --// (for example, Horns Of Toxicity). Clone the whole subtree so nested
    --// MeshParts, SurfaceAppearance, Attachments and FX stay connected.
    for _, child in ipairs(sourcePart:GetChildren()) do
        if __UI.__L.isUnusualJointObject(child)
            and __UI.__L.unusualJointHasNestedBasePart(child)
        then
            __UI.__L.installUnusualWeldedTree(
                sourcePart,
                targetPart,
                child,
                id
            )
        end
    end

    --// Direct extra BaseParts are handled by the
    --// existing anchor path.
    local anchorIndex = 0

    for _, nested in ipairs(
        sourcePart:GetChildren()
    ) do

        if nested:IsA("BasePart")
        then

            anchorIndex += 1

            local anchor =
                __UI.__L.createUnusualAnchor(
                    sourcePart,
                    nested,
                    targetPart,
                    id,
                    anchorIndex
                )

            if anchor then

                targetMap[nested] =
                    anchor

                local animated =
                    __UI.__L.unusualRuntime.addAnimationLink(
                        sourcePart,
                        nested,
                        targetPart,
                        animatedSource
                    )

                if animated then
                    for _, child in ipairs(
                        anchor:GetChildren()
                    ) do
                        if child:IsA(
                            "WeldConstraint"
                        )
                        or child:IsA(
                            "Weld"
                        )
                        or child:IsA(
                            "Motor6D"
                        )
                        then
                            pcall(function()
                                child:Destroy()
                            end)
                        end
                    end

                    anchor.Anchored = true

                    __UI.__L.unusualRuntime.animationLinks[
                        #__UI.__L.unusualRuntime.animationLinks
                    ].anchor =
                        anchor
                end

                table.insert(
                    sourceNodes,
                    nested
                )

            end

        end

    end

    local attachmentMap = {}

    --// -----------------------------------------------------
    --// PASS 1:
    --// Clone all needed attachments and remember their mapping.
    --// -----------------------------------------------------

    for _, currentSourcePart in ipairs(
        sourceNodes
    ) do

        local currentTargetPart =
            targetMap[currentSourcePart]

        if currentTargetPart then

            local needed =
                __UI.__L.getNeededUnusualAttachments(
                    currentSourcePart
                )

            for attachment in pairs(
                needed
            ) do

                local parent =
                    attachment.Parent

                if not (
                    parent
                    and parent:IsA("Attachment")
                    and needed[parent]
                ) then

                    local clone =
                        attachment:Clone()

                    --// Direct clone keeps the same local
                    --// CFrame because the parent type is identical.
                    clone.CFrame =
                        attachment.CFrame

                    clone.Parent =
                        currentTargetPart

                    __UI.__L.UnusualFns.tagUnusualFX(
                        clone,
                        id
                    )

                    __UI.__L.mapUnusualAttachments(
                        attachment,
                        clone,
                        attachmentMap
                    )

                end

            end

        end

    end

    --// -----------------------------------------------------
    --// PASS 2:
    --// Clone FX in the correct nested-part space.
    --// -----------------------------------------------------

    for _, currentSourcePart in ipairs(
        sourceNodes
    ) do

        local currentTargetPart =
            targetMap[currentSourcePart]

        if currentTargetPart then

            for _, sourceObject in ipairs(
                currentSourcePart:GetDescendants()
            ) do

                if __UI.__L.UnusualFns.isUnusualFX(
                    sourceObject
                )
                and __UI.__L.unusualObjectBelongsToPart(
                    sourceObject,
                    currentSourcePart
                )
                then

                    local insideAttachment =
                        false

                    local parent =
                        sourceObject.Parent

                    while parent
                        and parent ~= currentSourcePart
                    do

                        if parent:IsA(
                            "Attachment"
                        ) then

                            insideAttachment =
                                true

                            break

                        end

                        parent =
                            parent.Parent

                    end

                    if not insideAttachment then

                        local clone =
                            sourceObject:Clone()

                        if clone:IsA("Trail")
                            or clone:IsA("Beam")
                        then

                            if sourceObject.Attachment0 then

                                local newA0 =
                                    attachmentMap[
                                        sourceObject.Attachment0
                                    ]

                                if newA0 then
                                    clone.Attachment0 =
                                        newA0
                                end

                            end

                            if sourceObject.Attachment1 then

                                local newA1 =
                                    attachmentMap[
                                        sourceObject.Attachment1
                                    ]

                                if newA1 then
                                    clone.Attachment1 =
                                        newA1
                                end

                            end

                        end

                        clone.Parent =
                            currentTargetPart

                        __UI.__L.UnusualFns.tagUnusualFX(
                            clone,
                            id
                        )

                    end

                end

            end

        end

    end

end

--// =========================================================
--// APPLY UNUSUAL FX ONLY
--// =========================================================

local function applyUnusualFX(
    id,
    visualRig,
    playerCharacter
)

    local cosmeticRig =
        __UI.__L.UnusualFns.getUnusualCosmeticRig(
            id,
            visualRig
        )

    if not cosmeticRig then

        warn(            "[UnusualSwapper] Cosmetic rig not found:",
            id
        )

        return false

    end

    --// Build the hidden animation source first. This cleanup
    --// routine destroys previous runtime/animated visuals,
    --// so the visible animated mini-rig must be installed after it.
    local animatedSource =
        __UI.__L.unusualRuntime.createAnimationSource(
            cosmeticRig,
            id,
            playerCharacter
        )

    local animatedNestedInstalled =
        __UI.__L.unusualRuntime.installAnimatedNestedModels(
            cosmeticRig,
            id,
            visualRig,
            playerCharacter
        )

    local installed =
        0

    if animatedNestedInstalled > 0 then
        installed += animatedNestedInstalled
        print(
            "[UnusualSwapper] Animated nested models:",
            animatedNestedInstalled,
            "ID:",
            id
        )
    end

    for _, sourcePart in ipairs(
        cosmeticRig:GetChildren()
    ) do

        if sourcePart:IsA(
            "BasePart"
        ) then

            local targetPart

            if sourcePart.Name
                == "HumanoidRootPart"
            then

                if playerCharacter then

                    targetPart =
                        playerCharacter:FindFirstChild(
                            "HumanoidRootPart"
                        )

                end

                if not targetPart then

                    targetPart =
                        visualRig:FindFirstChild(
                            "HumanoidRootPart"
                        )

                end

            else

                targetPart =
                    visualRig:FindFirstChild(
                        sourcePart.Name
                    )

            end

            if targetPart
                and targetPart:IsA(
                    "BasePart"
                )
            then

                __UI.__L.installUnusualPartFX(
                    sourcePart,
                    targetPart,
                    id,
                    animatedSource
                )

                installed += 1

            end

        end

    end

    print(
        "[UnusualSwapper] Installed FX on",
        installed,
        "parts"
    )

    return installed > 0

end

--// =========================================================
--// REMOVE OUR FX
-- =========================================================
function __UI.__L.UnusualFns.removeOurUnusualFX()
    __UI.__L.unusualRuntime.destroyAnimationSource()

    local removed = 0
    local roots = {
        __UI.__L.UnusualFns.getUnusualVisualRig(),
        __UI.__L.UnusualFns.getUnusualPlayerCharacter()
    }
    local seen = {}
    for _, root in ipairs(
        roots
    ) do
        if root
            and not seen[root]
        then
            seen[root] =
                true
            for _, object in ipairs(
                root:GetDescendants()
            ) do
                local marked =
                    false
                pcall(function()
                    marked =
                        object:GetAttribute(
                            "DeadEyeUnusualFX"
                        ) == true
                end)
                if marked then
                    pcall(function()
                        object:Destroy()
                        removed += 1
                    end)
                end
            end
        end
    end
    if removed > 0 then
            end
end
--// =========================================================
--// CHECK OUR INSTALLED FX
--// =========================================================
function __UI.__L.UnusualFns.hasOurUnusualFX(
    root,
    id
)
    if not root then
        return false
    end

    local wanted =
        tonumber(id)

    for _, object in ipairs(
        root:GetDescendants()
    ) do
        local marked = false
        local fxId = nil

        pcall(function()
            marked =
                object:GetAttribute(
                    "DeadEyeUnusualFX"
                ) == true

            fxId =
                tonumber(
                    object:GetAttribute(
                        "DeadEyeUnusualFXID"
                    )
                )
        end)

        if marked
            and fxId
            and wanted
            and fxId == wanted
        then
            return true
        end
    end

    return false
end

--// =========================================================
--// ORIGINAL SIGNATURE
-- =========================================================
function __UI.__L.UnusualFns.buildOriginalUnusualSignature(
    id,
    visualRig
)
    local cosmeticRig =
        __UI.__L.UnusualFns.getUnusualCosmeticRig(
            id,
            visualRig
        )

    if not cosmeticRig then
        return nil
    end

    local signature = {}

    local function hasEffectContent(
        object
    )
        if __UI.__L.UnusualFns.isUnusualFX(object) then
            return true
        end

        if object:IsA("BasePart") then
            return true
        end

        for _, descendant in ipairs(
            object:GetDescendants()
        ) do
            if __UI.__L.UnusualFns.isUnusualFX(descendant)
                or descendant:IsA("BasePart")
            then
                return true
            end
        end

        return false
    end

    for _, sourcePart in ipairs(
        cosmeticRig:GetChildren()
    ) do

        if sourcePart:IsA("BasePart") then

            local objects = {}

            for _, object in ipairs(
                sourcePart:GetChildren()
            ) do

                if __UI.__L.isUnusualJointObject(object)
                    or object:IsA("CFrameValue")
                then

                    --// Record joint roots that contain actual nested geometry.
                    if __UI.__L.isUnusualJointObject(object)
                        and __UI.__L.unusualJointHasNestedBasePart(object)
                    then
                        table.insert(
                            objects,
                            {
                                Class = object.ClassName,
                                Name = object.Name,
                                WholeTree = true
                            }
                        )
                    end

                    continue
                end

                if hasEffectContent(object) then

                    local info = {
                        Class =
                            object.ClassName,
                        Name =
                            object.Name
                    }

                    if object:IsA("MeshPart") then
                        info.MeshId =
                            tostring(object.MeshId)
                        info.TextureId =
                            tostring(object.TextureID)
                    end

                    table.insert(
                        objects,
                        info
                    )

                end

            end

            signature[
                sourcePart.Name
            ] = objects

        end

    end

    return signature
end

--// =========================================================
--// REMOVE ORIGINAL FX
-- =========================================================
function __UI.__L.UnusualFns.removeOriginalUnusualFX(
    id,
    visualRig,
    playerCharacter
)
    local signature =
        __UI.__L.UnusualFns.buildOriginalUnusualSignature(
            id,
            visualRig
        )

    if not signature then
        return
    end

    for partName, objects in pairs(
        signature
    ) do

        local targetPart

        if partName
            == "HumanoidRootPart"
        then

            if playerCharacter then
                targetPart =
                    playerCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )
            end

        else

            targetPart =
                visualRig:FindFirstChild(
                    partName
                )

        end

        if targetPart
            and targetPart:IsA("BasePart")
        then

            for _, existing in ipairs(
                targetPart:GetChildren()
            ) do

                for _, info in ipairs(
                    objects
                ) do

                    local match = false

                    if existing.ClassName ==
                        info.Class
                    then

                        if existing:IsA("MeshPart")
                            and info.MeshId
                        then

                            match =
                                existing.Name ==
                                info.Name
                                and tostring(existing.MeshId)
                                    == info.MeshId
                                and tostring(existing.TextureID)
                                    == info.TextureId

                        else

                            match =
                                existing.Name ==
                                info.Name

                        end

                    end

                    if match then

                        pcall(function()
                            existing:Destroy()
                        end)

                        for _, joint in ipairs(
                            targetPart:GetChildren()
                        ) do

                            if (
                                joint:IsA("Weld")
                                or joint:IsA("WeldConstraint")
                                or joint:IsA("Motor6D")
                                or joint:IsA("Motor")
                            )
                            and joint.Name ==
                                info.Name
                            then

                                pcall(function()
                                    joint:Destroy()
                                end)

                            end

                        end

                        break

                    end

                end

            end

            --// Remove matching original joints such as
            --// CatRadiance Head.Ears / Head.Bigotes.
            for _, joint in ipairs(
                targetPart:GetChildren()
            ) do

                if joint:IsA("Weld")
                    or joint:IsA("WeldConstraint")
                    or joint:IsA("Motor6D")
                    or joint:IsA("Motor")
                then

                    for _, info in ipairs(
                        objects
                    ) do

                        if joint.Name ==
                            info.Name
                        then

                            pcall(function()
                                joint:Destroy()
                            end)

                            break

                        end

                    end

                end

            end

        end

    end

    --// Non-body-root original effect objects.
    for _, child in ipairs(
        visualRig:GetChildren()
    ) do

        local matched =
            false

        for partName in pairs(signature) do
            if child.Name ==
                partName
            then
                matched = true
                break
            end
        end

        if not matched then
            --// Do not touch the player's actual body parts.
            if child:GetAttribute(
                "DeadEyeUnusualFXID"
            ) then

                pcall(function()
                    child:Destroy()
                end)

            end

        end

    end

end

--// =========================================================
--// RESTORE UNUSUAL
-- =========================================================
function __UI.__L.UnusualFns.captureNativeUnusualSnapshot(
    id,
    visualRig,
    playerCharacter
)
    local signature =
        __UI.__L.UnusualFns.buildOriginalUnusualSignature(
            id,
            visualRig
        )

    if not signature then
        return nil
    end

    local snapshot = {
        parts = {}
    }

    local function getTargetPart(partName)
        if partName == "HumanoidRootPart" then
            return playerCharacter
                and playerCharacter:FindFirstChild(
                    "HumanoidRootPart"
                )
        end

        return visualRig
            and visualRig:FindFirstChild(
                partName
            )
    end

    local function matchesObject(object, info)
        if object.ClassName ~= info.Class
            or object.Name ~= info.Name
        then
            return false
        end

        if object:IsA("MeshPart")
            and info.MeshId
        then
            return tostring(object.MeshId) == info.MeshId
                and tostring(object.TextureID)
                    == info.TextureId
        end

        return true
    end

    for partName, objects in pairs(signature) do
        local targetPart =
            getTargetPart(partName)

        if targetPart
            and targetPart:IsA("BasePart")
        then
            local partSnapshot = {
                partName = partName,
                objects = {},
                joints = {}
            }

            for _, existing in ipairs(targetPart:GetChildren()) do
                local matchedInfo = nil

                for _, info in ipairs(objects) do
                    if matchesObject(existing, info) then
                        matchedInfo = info
                        break
                    end
                end

                if matchedInfo then
                    local clone
                    pcall(function()
                        clone = existing:Clone()
                    end)

                    if clone then
                        if matchedInfo.WholeTree then
                            local cloneMap = {}
                            __UI.__L.mapUnusualCloneTree(existing, clone, cloneMap)
                            __UI.__L.rebindUnusualCloneTree(
                                existing,
                                clone,
                                cloneMap,
                                nil,
                                targetPart
                            )
                        end

                        table.insert(partSnapshot.objects, clone)
                    end
                end
            end

            for _, joint in ipairs(
                targetPart:GetChildren()
            ) do
                if joint:IsA("Weld")
                    or joint:IsA("WeldConstraint")
                    or joint:IsA("Motor6D")
                    or joint:IsA("Motor")
                then
                    for _, info in ipairs(objects) do
                        if joint.Name == info.Name
                            and not info.WholeTree
                        then
                            local clone
                            pcall(function()
                                clone = joint:Clone()
                            end)

                            if clone then
                                table.insert(
                                    partSnapshot.joints,
                                    clone
                                )
                            end

                            break
                        end
                    end
                end
            end

            if #partSnapshot.objects > 0
                or #partSnapshot.joints > 0
            then
                table.insert(
                    snapshot.parts,
                    partSnapshot
                )
            end
        end
    end

    if #snapshot.parts == 0 then
        return nil
    end

    return snapshot
end

function __UI.__L.UnusualFns.restoreNativeUnusualSnapshot(
    snapshot,
    visualRig,
    playerCharacter
)
    if not snapshot then
        return false
    end

    local restored = false

    for _, partSnapshot in ipairs(snapshot.parts) do
        local targetPart

        if partSnapshot.partName
            == "HumanoidRootPart"
        then
            targetPart =
                playerCharacter
                and playerCharacter:FindFirstChild(
                    "HumanoidRootPart"
                )
        else
            targetPart =
                visualRig
                and visualRig:FindFirstChild(
                    partSnapshot.partName
                )
        end

        if targetPart
            and targetPart:IsA("BasePart")
        then
            for _, savedObject in ipairs(
                partSnapshot.objects
            ) do
                local exists = false

                for _, current in ipairs(
                    targetPart:GetChildren()
                ) do
                    if current.Name
                        == savedObject.Name
                        and current.ClassName
                            == savedObject.ClassName
                    then
                        exists = true
                        break
                    end
                end

                if not exists then
                    local clone

                    pcall(function()
                        clone =
                            savedObject:Clone()
                    end)

                    if clone then
                        local cloneMap = {}

                        __UI.__L.mapUnusualCloneTree(
                            savedObject,
                            clone,
                            cloneMap
                        )

                        __UI.__L.rebindUnusualCloneTree(
                            savedObject,
                            clone,
                            cloneMap,
                            nil,
                            targetPart
                        )

                        clone.Parent =
                            targetPart
                        restored = true
                    end
                end
            end

            for _, savedJoint in ipairs(
                partSnapshot.joints
            ) do
                local exists = false

                for _, current in ipairs(
                    targetPart:GetChildren()
                ) do
                    if current.Name
                        == savedJoint.Name
                        and current.ClassName
                            == savedJoint.ClassName
                    then
                        exists = true
                        break
                    end
                end

                if not exists then
                    local clone

                    pcall(function()
                        clone =
                            savedJoint:Clone()
                    end)

                    if clone then
                        clone.Parent =
                            targetPart
                        restored = true
                    end
                end
            end
        end
    end

    return restored
end

function __UI.__L.UnusualFns.restoreUnusual()
    if not __UI.__L.unusualActive
        and not __UI.__L.unusualRuntime.originalId
    then
        return
    end

    local visualRig =
        __UI.__L.UnusualFns.getUnusualVisualRig()
    local playerCharacter =
        __UI.__L.UnusualFns.getUnusualPlayerCharacter()

    --// Always inspect the real current loadout before restoring.
    --// unusualRuntime.originalId is the configured swap source only.
    local currentEquippedId =
        tonumber(
            __UI.__L.UnusualFns.getEquippedUnusualId()
        )

    local originalId =
        tonumber(
            __UI.__L.unusualRuntime.originalId
        )

    __UI.__L.unusualRuntime.currentEquippedId =
        currentEquippedId

    --// If the player manually equipped another Unusual while the
    --// swap was active (for example 1 -> 2, then equip 3), never
    --// restore the old snapshot of 1. Remove only DeadEye's own FX
    --// and leave the game's native effect 3 untouched.
    local manuallyChanged =
        currentEquippedId
        and currentEquippedId ~= 0
        and originalId
        and currentEquippedId ~= originalId

    if manuallyChanged then
        --// The equipped Unusual changed. Do not restore the old
        --// replacement's particle state onto the new native effect.
        __UI.__L.UnusualFns.clearNativeParticlePOV(
            false
        )

        if visualRig then
            __UI.__L.UnusualFns.removeOurUnusualFX()

            pcall(function()
                __UI.__L.UnusualFns.removeOriginalUnusualFX(
                    originalId,
                    visualRig,
                    playerCharacter
                )
            end)

            --// Keep P1 handling on the currently native Unusual.
            __UI.__L.UnusualFns.bindNativeParticlePOV(
                visualRig
            )
        end

        __UI.__L.unusualActive =
            false
        __UI.__L.unusualRuntime.appliedRig =
            visualRig
        __UI.__L.unusualRuntime.originalId =
            nil
        __UI.__L.unusualRuntime.replacementId =
            nil
        __UI.__L.unusualRuntime.nativeSnapshot =
            nil
        return
    end

    --// Normal case: the player still has the configured original
    --// equipped, so restoring the saved native snapshot is correct.
    if (
        not currentEquippedId
        or currentEquippedId == 0
    )
    then
        currentEquippedId =
            originalId
    end

    if visualRig
        and currentEquippedId
        and currentEquippedId ~= 0
    then
        --// Put the LIVE visual rig back to its exact 3P particle
        --// states before removing the replacement and restoring
        --// the native Unusual snapshot.
        __UI.__L.UnusualFns.clearNativeParticlePOV(
            true
        )

        __UI.__L.UnusualFns.removeOurUnusualFX()
        task.wait()

        local restored =
            __UI.__L.UnusualFns.restoreNativeUnusualSnapshot(
                __UI.__L.unusualRuntime.nativeSnapshot,
                visualRig,
                playerCharacter
            )

        if not restored
            and originalId
            and tonumber(currentEquippedId)
                == tonumber(originalId)
        then
            __UI.__L.UnusualFns.removeOriginalUnusualFX(
                originalId,
                visualRig,
                playerCharacter
            )
            task.wait()

            applyUnusualFX(
                originalId,
                visualRig,
                playerCharacter
            )
        end

        --// The original effect is now the live effect again.
        --// Keep the same instant P1/P3 behavior on it.
        __UI.__L.UnusualFns.bindNativeParticlePOV(
            visualRig
        )
    end

    __UI.__L.unusualActive =
        false
    __UI.__L.unusualRuntime.appliedRig =
        nil
    __UI.__L.unusualRuntime.originalId =
        nil
    __UI.__L.unusualRuntime.currentEquippedId =
        currentEquippedId
    __UI.__L.unusualRuntime.replacementId =
        nil
    __UI.__L.unusualRuntime.nativeSnapshot =
        nil
end
--// =========================================================
--// ACTIVATE UNUSUAL
-- =========================================================
function __UI.__L.UnusualFns.activateUnusual()
    if not __UI.__L.unusualSlot.originalId
        or not __UI.__L.unusualSlot.replaceId
    then
        return false
    end
    if __UI.__L.unusualSlot.originalId
        == __UI.__L.unusualSlot.replaceId
    then
        return false
    end

    local equippedId =
        __UI.__L.UnusualFns.getEquippedUnusualId()

    if equippedId == 0
        or tonumber(equippedId)
            ~= tonumber(__UI.__L.unusualSlot.originalId)
    then
        return false
    end

    local visualRig =
        __UI.__L.UnusualFns.getUnusualVisualRig()
    local playerCharacter =
        __UI.__L.UnusualFns.getUnusualPlayerCharacter()
    if not visualRig then
        return false
    end

    if not __UI.__L.unusualRuntime.nativeSnapshot
        or tonumber(
            __UI.__L.unusualRuntime.originalId
        ) ~= tonumber(equippedId)
        or __UI.__L.unusualRuntime.appliedRig ~= visualRig
    then
        __UI.__L.unusualRuntime.nativeSnapshot =
            __UI.__L.UnusualFns.captureNativeUnusualSnapshot(
                equippedId,
                visualRig,
                playerCharacter
            )
    end

    if not __UI.__L.unusualRuntime.nativeSnapshot then
        return false
    end

    --// Reset the previous replacement's POV state.
    __UI.__L.UnusualFns.clearNativeParticlePOV(
        true
    )

    __UI.__L.UnusualFns.removeOurUnusualFX()
    task.wait()
    __UI.__L.UnusualFns.removeOriginalUnusualFX(
        __UI.__L.unusualSlot.originalId,
        visualRig,
        playerCharacter
    )
    task.wait()
    if not applyUnusualFX(
        __UI.__L.unusualSlot.replaceId,
        visualRig,
        playerCharacter
    ) then
        task.wait()
        applyUnusualFX(
            __UI.__L.unusualSlot.originalId,
            visualRig,
            playerCharacter
        )
        return false
    end
    __UI.__L.unusualActive =
        true
    __UI.__L.unusualRuntime.appliedRig =
        visualRig
    __UI.__L.unusualRuntime.originalId =
        equippedId
    __UI.__L.unusualRuntime.currentEquippedId =
        equippedId
    __UI.__L.unusualRuntime.replacementId =
        tonumber(__UI.__L.unusualSlot.replaceId)

    --// The replacement is now live in Rigs.<player>.
    --// Track all of its current ParticleEmitters and any that
    --// its client driver creates later.
    __UI.__L.UnusualFns.bindNativeParticlePOV(
        visualRig
    )

    return true
end
function __UI.__L.UnusualFns.reapplyUnusual()
    if not __UI.__L.unusualEnabled
        or __UI.__L.unusualReapplyBusy
    then
        return
    end

    __UI.__L.unusualReapplyBusy = true
    __UI.__L.unusualRuntime.reapplyGeneration += 1

    local generation =
        __UI.__L.unusualRuntime.reapplyGeneration

    task.spawn(function()

        for attempt = 1, 20 do

            if not __UI.__L.unusualEnabled
                or genv.DEADEYE_UNUSUAL_POV_RUNNING == false
                or generation ~= __UI.__L.unusualRuntime.reapplyGeneration
            then
                break
            end

            local visualRig =
                __UI.__L.UnusualFns.getUnusualVisualRig()

            local playerCharacter =
                __UI.__L.UnusualFns.getUnusualPlayerCharacter()

            local root =
                visualRig
                and visualRig:FindFirstChild(
                    "HumanoidRootPart"
                )

            local humanoid =
                visualRig
                and visualRig:FindFirstChildOfClass(
                    "Humanoid"
                )

            if visualRig
                and root
                and humanoid
            then

                task.wait(0.2)

                if not __UI.__L.unusualEnabled
                    or genv.DEADEYE_UNUSUAL_POV_RUNNING == false
                    or generation ~= __UI.__L.unusualRuntime.reapplyGeneration
                then
                    break
                end

                local equippedId =
                    __UI.__L.UnusualFns.getEquippedUnusualId()

                if equippedId == 0
                    or tonumber(equippedId)
                        ~= tonumber(
                            __UI.__L.unusualSlot.originalId
                        )
                then
                    --// The player changed the actually equipped Unusual.
                    --// Do NOT restore unusualRuntime.originalId here:
                    --// that is only the configured swap rule (for example 1 -> 2).
                    --// The new equipped effect is now the real current state.
                    __UI.__L.unusualRuntime.currentEquippedId =
                        tonumber(equippedId)

                    --// The game already handles the newly equipped
                    --// Unusual. DeadEye must only remove its own
                    --// replacement FX and any leftover old original FX.
                    --// Do NOT call applyUnusualFX here: that would mark
                    --// the user's real effect as DeadEye-owned and cleanup
                    --// would delete it.
                    __UI.__L.UnusualFns.removeOurUnusualFX()
                    task.wait()

                    pcall(function()
                        __UI.__L.UnusualFns.removeOriginalUnusualFX(
                            __UI.__L.unusualRuntime.originalId
                                or __UI.__L.unusualSlot.originalId,
                            visualRig,
                            playerCharacter
                        )
                    end)

                    __UI.__L.unusualActive = false
                    __UI.__L.unusualEnabled = false
                    __UI.__L.unusualRuntime.appliedRig = visualRig
                    __UI.__L.unusualRuntime.originalId = nil
                    __UI.__L.unusualRuntime.replacementId = nil
                    __UI.__L.unusualRuntime.nativeSnapshot = nil
                    genv.UNUSUAL_SWAPPER_ENABLED =
                        false
                    break
                end

                __UI.__L.unusualActive = false
                __UI.__L.UnusualFns.removeOurUnusualFX()

                local ok, result =
                    pcall(function()
                        return __UI.__L.UnusualFns.activateUnusual()
                    end)

                if ok
                    and result == true
                then

                    local expected =
                        (
                            #__UI.__L.unusualRuntime.animatedNestedVisuals > 0
                        )
                        or __UI.__L.UnusualFns.hasOurUnusualFX(
                            visualRig,
                            __UI.__L.unusualSlot.replaceId
                        )
                        or __UI.__L.UnusualFns.hasOurUnusualFX(
                            playerCharacter,
                            __UI.__L.unusualSlot.replaceId
                        )

                    if expected then
                        __UI.__L.unusualRuntime.appliedRig =
                            visualRig
                        break
                    end

                end

            end

            task.wait(0.25)

        end

        __UI.__L.unusualReapplyBusy = false

    end)
end
--// =========================================================
--// =========================================================
--// FIRST PERSON / VIEWMODEL SYNC
--//
--// 3P uses workspace.Rigs.<name>.
--// 1P uses workspace.Camera.Viewmodel.Clothing.
--//
--// Viewmodel appearance is copied from the real visual rig.
--// Unusual FX visibility mirrors the native Unusual behavior
--// observed on a completely clean server.
--// =========================================================
__UI.__L.lastUnusualPOVState = nil

function __UI.__L.UnusualFns.getUnusualViewmodel()
    local camera =
        workspace.CurrentCamera

    if not camera then
        return nil
    end

    local viewmodel =
        camera:FindFirstChild(
            "Viewmodel"
        )

    if not viewmodel then
        return nil
    end

    return viewmodel
end

function __UI.__L.UnusualFns.isUnusualPOVRuntimeActive()
    --// CharacterService:GetLocalCharacter() is the game's actual
    --// gameplay lifecycle signal.
    --
    --// In the menu the service returns nil even though:
    --//   workspace.Rigs.<LocalPlayer> still exists
    --//   MenuView.VisualModel exists
    --//   Camera.Focus distance is 0
    --
    --// Once gameplay starts, the service returns the live character
    --// object and its Model becomes workspace.Players.<LocalPlayer>.
    --// Therefore ONLY this signal decides whether the gameplay-only
    --// Unusual POV controller may run.
    local characterObject =
        getCharacterObject()

    return characterObject ~= nil
end

function __UI.__L.UnusualFns.isUnusualFirstPerson()
    --// Use the game's exact first-person measurement.
    --// Native TransparencyController:
    --//     (Camera.Focus.Position - Camera.CFrame.Position).Magnitude < 2
    --
    --// Do NOT use the visual rig Head position here.
    --// The visual rig can be offset/rebuilt while DeadEye is active,
    --// which made the previous detector miss the real P3 -> P1 transition.
    local camera =
        workspace.CurrentCamera

    if not camera then
        return false
    end

    local focus =
        camera.Focus

    if not focus then
        return false
    end

    local distance =
        (
            focus.Position
            - camera.CFrame.Position
        ).Magnitude

    return distance < 2
end

function __UI.__L.UnusualFns.syncUnusualViewmodelAppearance()
    local visualRig =
        __UI.__L.UnusualFns.getUnusualVisualRig()

    if not visualRig then
        return
    end

    local viewmodel =
        __UI.__L.UnusualFns.getUnusualViewmodel()

    if not viewmodel then
        return
    end

    local clothing =
        viewmodel:FindFirstChild(
            "Clothing"
        )

    if not clothing then
        return
    end

    local sourceShirt =
        visualRig:FindFirstChildOfClass(
            "Shirt"
        )

    local targetShirt =
        clothing:FindFirstChildOfClass(
            "Shirt"
        )

    if sourceShirt
        and targetShirt
    then
        pcall(function()
            if targetShirt.ShirtTemplate
                ~= sourceShirt.ShirtTemplate
            then
                targetShirt.ShirtTemplate =
                    sourceShirt.ShirtTemplate
            end
        end)
    end

    local sourceColors =
        visualRig:FindFirstChildOfClass(
            "BodyColors"
        )

    local targetColors =
        clothing:FindFirstChildOfClass(
            "BodyColors"
        )

    if sourceColors
        and targetColors
    then
        local properties = {
            "HeadColor3",
            "TorsoColor3",
            "LeftArmColor3",
            "RightArmColor3",
            "LeftLegColor3",
            "RightLegColor3"
        }

        for _, property in ipairs(
            properties
        ) do
            pcall(function()
                targetColors[property] =
                    sourceColors[property]
            end)
        end
    end
end

--// =========================================================
--// DEAD EYE UNUSUAL POV VISIBILITY
--//
--// Native clean-server observation:
--//
--// ORIGINAL UNUSUAL:
--//   3P:
--//     ParticleEmitter Enabled = true
--//     ParticleEmitter LTM = 0
--//     PointLight Enabled = true
--//
--//   1P:
--//     ParticleEmitter Enabled = false
--//     ParticleEmitter LTM = 0
--//     PointLight Enabled = true
--//
--// The native result did NOT use the SOURCE #6 transparency
--// formula for these Unusual ParticleEmitters.
--//
--// Therefore DeadEye mirrors the native 1P disappearance across
--// the WHOLE replacement visual layer:
--//
--//   ParticleEmitter:
--//      3P -> Enabled = true,  LTM = 0
--//      1P -> Enabled = false, LTM = 0
--//
--//   Trail / Beam / Fire / Smoke / Sparkles / Highlight / BillboardGui:
--//      3P -> Enabled = true
--//      1P -> Enabled = false
--//
--//   BasePart / Decal:
--//      3P -> LTM = 0
--//      1P -> LTM = 1
--//
--// This last group is important for custom "fake trails" that are
--// actually animated geometry/parts rather than Roblox Trail objects.
--//
--// PointLight / SpotLight / SurfaceLight are deliberately NOT
--// disabled here. The clean native test showed PointLight remaining
--// Enabled=true in 1P.
--//
--// No camera-distance transparency is applied to DeadEye Unusual FX.
--// No Transparency property is changed.
--// No Trail:Clear() is used.
--//
--// SOURCE #6 remains relevant for native character transparency,
--// but its LTM formula must NOT be applied to these replacement FX.
--// =========================================================
__UI.__L.unusualPovTransparencyClasses = {
    BasePart = true,
    Decal = true,
    Beam = true,
    ParticleEmitter = true,
    Trail = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
    Explosion = true,
    Highlight = true,
    BillboardGui = true
}

__UI.__L.isStockUnusualPOVTransparencyObject = function(
    object
)
    if not object then
        return false
    end

    return __UI.__L.unusualPovTransparencyClasses[
        object.ClassName
    ] == true
end

__UI.__L.forEachDeadEyeUnusualVisualObject = function(
    callback
)
    local roots = {
        __UI.__L.UnusualFns.getUnusualVisualRig(),
        __UI.__L.UnusualFns.getUnusualPlayerCharacter(),
        workspace:FindFirstChild(
            "DeadEyeUnusualAnimatedVisuals"
        ),
        workspace:FindFirstChild(
            "DeadEyeUnusualVisuals"
        )
    }

    local seenRoots = {}

    for _, root in ipairs(
        roots
    ) do
        if root
            and not seenRoots[root]
        then
            seenRoots[root] = true

            for _, object in ipairs(
                root:GetDescendants()
            ) do
                local tagged = false

                pcall(function()
                    tagged =
                        object:GetAttribute(
                            "DeadEyeUnusualFX"
                        ) == true

                    if not tagged
                        and object:IsA("BasePart")
                    then
                        tagged =
                            object:GetAttribute(
                                "DeadEyeFirstPersonCosmetic"
                            ) == true
                    end
                end)

                if tagged
                    and not object:FindFirstAncestorOfClass(
                        "Tool"
                    )
                    and __UI.__L.isStockUnusualPOVTransparencyObject(
                        object
                    )
                then
                    callback(object)
                end
            end
        end
    end
end

__UI.__L.hideUnusualAnimationSourceVisuals = function()
    local source =
        __UI.__L.unusualRuntime.animationSource

    if not source
        or not source.Parent
    then
        return
    end

    --// This clone is animation-only and is never part of the visible
    --// Unusual. Keep it invisible without affecting the visible copies.
    for _, object in ipairs(
        source:GetDescendants()
    ) do
        if object:IsA("BasePart") then
            pcall(function()
                object.Transparency = 1
                object.LocalTransparencyModifier = 1
                object.CastShadow = false
            end)
        elseif object:IsA("Decal")
            or object:IsA("Texture")
        then
            pcall(function()
                object.Transparency = 1
            end)
        end
    end
end

--// =========================================================
--// NATIVE P1 PARTICLEEMITTER MIRROR
--//
--// Clean-game observation:
--//   Workspace.Rigs.<player> ParticleEmitter
--//       P1: Enabled true -> false
--//       P3: restored to the previous state
--//
--// The previous DeadEye implementation only touched objects
--// carrying DeadEyeUnusualFX. That misses ParticleEmitters
--// spawned later by an Unusual's client driver.
--//
--// Fix:
--//   1. After the replacement is installed, remember every
--//      ParticleEmitter Enabled value in the live visual rig.
--//   2. Watch for new ParticleEmitters added to that rig.
--//   3. In P1, force those emitters Enabled=false.
--//   4. In P3, restore their exact remembered Enabled value.
--//
--// This deliberately does NOT set everything to true on P3.
--// Existing disabled emitters remain disabled.
--// =========================================================
function __UI.__L.UnusualFns.clearNativeParticlePOV(
    restore
)
    if __UI.__L.unusualRuntime.nativeParticleConnection then
        pcall(function()
            __UI.__L.unusualRuntime.nativeParticleConnection:Disconnect()
        end)
    end

    __UI.__L.unusualRuntime.nativeParticleConnection = nil

    if restore then
        for object, enabled in pairs(
            __UI.__L.unusualRuntime.nativeParticleStates
        ) do
            if object and object.Parent then
                pcall(function()
                    object.Enabled = enabled
                end)
            end
        end
    end

    table.clear(
        __UI.__L.unusualRuntime.nativeParticleStates
    )

    __UI.__L.unusualRuntime.nativeParticleRig = nil
    __UI.__L.unusualRuntime.nativeParticleLastFirstPerson = nil
end

function __UI.__L.UnusualFns.bindNativeParticlePOV(
    visualRig
)
    __UI.__L.UnusualFns.clearNativeParticlePOV(
        true
    )

    if not visualRig then
        return
    end

    __UI.__L.unusualRuntime.nativeParticleRig =
        visualRig

    for _, object in ipairs(
        visualRig:GetDescendants()
    ) do
        if object:IsA("ParticleEmitter") then
            __UI.__L.unusualRuntime.nativeParticleStates[
                object
            ] = object.Enabled
        end
    end

    __UI.__L.unusualRuntime.nativeParticleConnection =
        visualRig.DescendantAdded:Connect(
            function(object)
                if __UI.__L.unusualRuntime.nativeParticleRig
                    ~= visualRig
                then
                    return
                end

                local firstPerson = false

                pcall(function()
                    firstPerson =
                        __UI.__L.UnusualFns.isUnusualFirstPerson()
                end)

                if object:IsA("ParticleEmitter") then
                    if __UI.__L.unusualRuntime.nativeParticleStates[
                        object
                    ] == nil
                    then
                        __UI.__L.unusualRuntime.nativeParticleStates[
                            object
                        ] = object.Enabled
                    end

                    if firstPerson then
                        pcall(function()
                            object.Enabled = false
                            object:Clear()
                        end)
                    end

                elseif object:IsA("Trail") then
                    if firstPerson then
                        pcall(function()
                            object.Enabled = false
                            object:Clear()
                        end)
                    end
                end
            end
        )
end

function __UI.__L.UnusualFns.syncNativeParticlePOV(
    visualRig,
    firstPerson
)
    if not visualRig
        or __UI.__L.unusualRuntime.nativeParticleRig
            ~= visualRig
    then
        return
    end

    --// Register newly-created ParticleEmitters.
    for _, object in ipairs(
        visualRig:GetDescendants()
    ) do
        if object:IsA("ParticleEmitter")
            and __UI.__L.unusualRuntime.nativeParticleStates[
                object
            ] == nil
        then
            __UI.__L.unusualRuntime.nativeParticleStates[
                object
            ] = object.Enabled
        end
    end

    local enteredFirstPerson =
        firstPerson
        and __UI.__L.unusualRuntime.nativeParticleLastFirstPerson
            ~= true

    local leftFirstPerson =
        not firstPerson
        and __UI.__L.unusualRuntime.nativeParticleLastFirstPerson
            == true

    --// Returning to 3P restores the exact saved enabled state.
    if leftFirstPerson then
        for object, enabled in pairs(
            __UI.__L.unusualRuntime.nativeParticleStates
        ) do
            if object and object.Parent then
                pcall(function()
                    object.Enabled = enabled
                end)
            else
                __UI.__L.unusualRuntime.nativeParticleStates[
                    object
                ] = nil
            end
        end
    end

    for object, enabled in pairs(
        __UI.__L.unusualRuntime.nativeParticleStates
    ) do
        if object and object.Parent then
            pcall(function()
                if firstPerson then
                    local wasEnabled =
                        object.Enabled

                    object.Enabled = false

                    if enteredFirstPerson
                        or wasEnabled == true
                    then
                        object:Clear()
                    end
                else
                    object.Enabled = enabled
                end
            end)
        else
            __UI.__L.unusualRuntime.nativeParticleStates[
                object
            ] = nil
        end
    end

    if firstPerson then
        for _, object in ipairs(
            visualRig:GetDescendants()
        ) do
            if object:IsA("Trail") then
                pcall(function()
                    local wasEnabled =
                        object.Enabled

                    object.Enabled = false

                    if enteredFirstPerson
                        or wasEnabled == true
                    then
                        object:Clear()
                    end
                end)
            end
        end
    end

    __UI.__L.unusualRuntime.nativeParticleLastFirstPerson =
        firstPerson
end

--// =========================================================
--// =========================================================
--// DEADEYE COSMETICS -> NATIVE VISIBILITY
--//
--// DeadEye-created cosmetics are added after the game's
--// original Visibility limb cache is built. Feed only those
--// objects back through the game's own SetVisibility() path.
--//
--// Stock avatar head/hair/accessories are never tagged and
--// therefore never enter this path.
--// =========================================================
__UI.__L.getDeadEyeAccessoryHostPart = function(accessory, nativeModel)
    if not accessory or not nativeModel then
        return nil
    end

    local handle = accessory:FindFirstChild("Handle")
    if not handle then
        return nil
    end

    --// Match Accessory attachments to native rig attachments.
    for _, object in ipairs(handle:GetDescendants()) do
        if object:IsA("Attachment") then
            local nativeAttachment =
                nativeModel:FindFirstChild(
                    object.Name,
                    true
                )

            if nativeAttachment
                and nativeAttachment:IsA("Attachment")
                and not nativeAttachment:IsDescendantOf(accessory)
                and nativeAttachment.Parent
                and nativeAttachment.Parent:IsA("BasePart")
            then
                return nativeAttachment.Parent
            end
        end
    end

    --// Match weld/motor/constraint connections.
    for _, object in ipairs(handle:GetDescendants()) do
        if object:IsA("Weld")
            or object:IsA("Motor6D")
            or object:IsA("WeldConstraint")
        then
            local part0
            local part1

            pcall(function()
                part0 = object.Part0
            end)

            pcall(function()
                part1 = object.Part1
            end)

            if part0 and part0:IsDescendantOf(nativeModel) then
                return part0
            end

            if part1 and part1:IsDescendantOf(nativeModel) then
                return part1
            end
        end
    end

    return nativeModel:FindFirstChild(
        "Head",
        true
    )
end

__UI.__L.syncDeadEyeCosmeticsWithNativeVisibility = function()
    local characterObject =
        getCharacterObject()

    if not characterObject
        or not characterObject.Rig
        or not characterObject.Rig.Rig
    then
        return
    end

    local visibility =
        characterObject.Visibility

    local nativeModel =
        characterObject.Rig.Rig.Model

    if not visibility
        or not nativeModel
        or not nativeModel.Parent
    then
        return
    end

    local entries = {}
    local grouped = {}
    local seen = {}

    for _, object in ipairs(
        nativeModel:GetDescendants()
    ) do
        local tagged = false

        if object:IsA("Accessory") then
            pcall(function()
                tagged =
                    object:GetAttribute(
                        "DeadEyeFirstPersonCosmetic"
                    ) == true
            end)
        end

        if tagged then
                object:FindFirstChild("Handle")

            local host =
                __UI.__L.getDeadEyeAccessoryHostPart(
                    object,
                    nativeModel
                )

            if host
                and handle
                and not seen[handle]
            then
                seen[handle] = true

                local group =
                    grouped[host]

                if not group then
                    group = {}
                    grouped[host] = group
                end

                table.insert(
                    group,
                    handle
                )

                for _, child in ipairs(
                    handle:GetDescendants()
                ) do
                    if __UI.__L.isStockUnusualPOVTransparencyObject(
                        child
                    )
                    and not seen[child]
                    then
                        seen[child] = true

                        table.insert(
                            group,
                            child
                        )
                    end
                end
            end
        end
    end

    for host, objects in pairs(grouped) do
        if host
            and host.Parent
            and #objects > 0
        then
            table.insert(
                entries,
                {
                    host,
                    objects
                }
            )
        end
    end

    if #entries == 0 then
        return
    end

    --// This is the game's actual Visibility implementation:
    --// Visibility.UpdateVisibility() -> SetVisibility().
    pcall(function()
        visibility:UpdateVisibility(entries)
    end)
end

pcall(function()
    RunService:UnbindFromRenderStep(
        "DeadEyeFirstPersonCosmeticVisibility"
    )
end)

RunService:BindToRenderStep(
    "DeadEyeFirstPersonCosmeticVisibility",
    Enum.RenderPriority.Camera.Value + 2,
    function()
        __UI.__L.syncDeadEyeCosmeticsWithNativeVisibility()
    end
)

function __UI.__L.UnusualFns.setUnusualFXForPOV(
    firstPerson,
    _deltaTime
)
    if not __UI.__L.UnusualFns.isUnusualPOVRuntimeActive() then
        return
    end

    --// Mirror the native live-rig ParticleEmitter behavior first.
    __UI.__L.UnusualFns.syncNativeParticlePOV(
        __UI.__L.UnusualFns.getUnusualVisualRig(),
        firstPerson
    )

    --// Native clean-server observation:
    --// ParticleEmitters are disabled in 1P.
    --
    --// DeadEye's replacement visual can contain more than
    --// ParticleEmitters. Some Unusuals build "custom trails"
    --// from Trail/Beam objects or animated BaseParts.
    --
    --// Because these objects are outside the native character
    --// hierarchy, Roblox will not hide them automatically.
    --// Mirror the native 1P disappearance onto every tagged
    --// replacement visual object.

    __UI.__L.forEachDeadEyeUnusualVisualObject(
        function(object)
            pcall(function()
                if firstPerson then

                    if object:IsA("ParticleEmitter")
                        or object:IsA("Trail")
                        or object:IsA("Beam")
                        or object:IsA("Fire")
                        or object:IsA("Smoke")
                        or object:IsA("Sparkles")
                        or object:IsA("Highlight")
                        or object:IsA("BillboardGui")
                    then
                        --// Disable emission/rendering immediately.
                        object.Enabled = false

                        if object:IsA("ParticleEmitter") then
                            --// Native ParticleEmitter LTM remains 0.
                            object.LocalTransparencyModifier = 0
                        end

                    elseif object:IsA("BasePart")
                        or object:IsA("Decal")
                    then
                        --// Hide custom geometry-based visuals,
                        --// including fake/custom trail segments.
                        object.LocalTransparencyModifier = 1
                    end

                    --// Do NOT disable PointLight/SpotLight/SurfaceLight.
                    --// Native observation showed PointLight staying enabled.

                else

                    if object:IsA("ParticleEmitter")
                        or object:IsA("Trail")
                        or object:IsA("Beam")
                        or object:IsA("Fire")
                        or object:IsA("Smoke")
                        or object:IsA("Sparkles")
                        or object:IsA("Highlight")
                        or object:IsA("BillboardGui")
                    then
                        object.Enabled = true

                    elseif object:IsA("BasePart")
                        or object:IsA("Decal")
                    then
                        object.LocalTransparencyModifier = 0
                    end

                end
            end)
        end
    )

    --// The animation-only runtime clone must remain invisible.
    __UI.__L.hideUnusualAnimationSourceVisuals()
end

function __UI.__L.UnusualFns.updateUnusualPOV()
    if not genv.DEADEYE_UNUSUAL_POV_RUNNING then
        return
    end

    if not __UI.__L.UnusualFns.isUnusualPOVRuntimeActive() then
        __UI.__L.lastUnusualPOVState = false
        __UI.__L.UnusualFns.clearNativeParticlePOV(
            true
        )
        return
    end

    __UI.__L.UnusualFns.syncUnusualViewmodelAppearance()

    __UI.__L.lastUnusualPOVState =
        __UI.__L.UnusualFns.isUnusualFirstPerson()
end

genv.DEADEYE_UNUSUAL_POV_RUNNING = true

genv.DEADEYE_UNUSUAL_POV_TRANSPARENCY_CLEANUP = function()
    pcall(function()
        RunService:UnbindFromRenderStep(
            "DeadEyeUnusualPOVTransparency"
        )
    end)

    --// Restore the exact 3P ParticleEmitter Enabled states.
    pcall(function()
        __UI.__L.UnusualFns.clearNativeParticlePOV(
            true
        )
    end)

    --// Return DeadEye's Unusual layer to the native 3P state.
    pcall(function()
        __UI.__L.forEachDeadEyeUnusualVisualObject(
            function(object)
                if object:IsA("ParticleEmitter")
                    or object:IsA("Trail")
                    or object:IsA("Beam")
                    or object:IsA("Fire")
                    or object:IsA("Smoke")
                    or object:IsA("Sparkles")
                    or object:IsA("Highlight")
                    or object:IsA("BillboardGui")
                then
                    object.Enabled = true
                elseif object:IsA("BasePart")
                    or object:IsA("Decal")
                then
                    object.LocalTransparencyModifier = 0
                elseif __UI.__L.isStockUnusualPOVTransparencyObject(object) then
                    object.LocalTransparencyModifier = 0
                end
            end
        )
    end)

    pcall(function()
        __UI.__L.hideUnusualAnimationSourceVisuals()
    end)
end

pcall(function()
    RunService:UnbindFromRenderStep(
        "DeadEyeUnusualPOVTransparency"
    )
end)

RunService:BindToRenderStep(
    "DeadEyeUnusualPOVTransparency",
    Enum.RenderPriority.Camera.Value + 1,
    function(deltaTime)
        if not genv.DEADEYE_UNUSUAL_POV_RUNNING then
            return
        end

        --// CameraModule writes CurrentCamera.CFrame and Focus at
        --// Enum.RenderPriority.Camera. Run after that, like the native
        --// transparency calculation uses the current frame's camera.
        if not __UI.__L.UnusualFns.isUnusualPOVRuntimeActive() then
            __UI.__L.UnusualFns.clearNativeParticlePOV(
                true
            )
            return
        end

        local gameplayRig =
            __UI.__L.UnusualFns.getUnusualVisualRig()

        if gameplayRig
            and __UI.__L.unusualRuntime.nativeParticleRig
                ~= gameplayRig
        then
            __UI.__L.UnusualFns.bindNativeParticlePOV(
                gameplayRig
            )
        end

        local firstPerson =
            __UI.__L.UnusualFns.isUnusualFirstPerson()

        __UI.__L.UnusualFns.setUnusualFXForPOV(
            firstPerson,
            deltaTime
        )
    end
)

--// Keep the native equipped Unusual covered before replacement,
--// but only after CharacterService reports a real gameplay character.
--// MenuView.VisualModel / menu Rigs must never be put under the
--// gameplay POV controller.
pcall(function()
    if __UI.__L.UnusualFns.isUnusualPOVRuntimeActive() then
        __UI.__L.UnusualFns.bindNativeParticlePOV(
            __UI.__L.UnusualFns.getUnusualVisualRig()
        )
    end
end)

__UI.__L.UnusualFns.addUnusualConnection(
    RunService.Heartbeat:Connect(
        function(deltaTime)

            if not genv.DEADEYE_UNUSUAL_POV_RUNNING then
                return
            end

            __UI.__L.unusualRuntime.updateAnimatedParts()
            __UI.__L.UnusualFns.updateUnusualPOV()

            if __UI.__L.unusualEnabled
                and not __UI.__L.unusualReapplyBusy
            then

                local rig =
                    __UI.__L.UnusualFns.getUnusualVisualRig()

                if rig then

                    local expected =
                        (
                            #__UI.__L.unusualRuntime.animatedNestedVisuals > 0
                        )
                        or __UI.__L.UnusualFns.hasOurUnusualFX(
                            rig,
                            __UI.__L.unusualSlot.replaceId
                        )
                        or __UI.__L.UnusualFns.hasOurUnusualFX(
                            __UI.__L.UnusualFns.getUnusualPlayerCharacter(),
                            __UI.__L.unusualSlot.replaceId
                        )

                    if __UI.__L.unusualRuntime.appliedRig ~= rig
                        or not expected
                    then
                        __UI.__L.UnusualFns.reapplyUnusual()
                    end

                end

            end

        end
    )
)
--// =========================================================
--// UNUSUAL PAGE
--// =========================================================
__UI.__L.unusualPage =
    Instance.new("ScrollingFrame")
__UI.__L.unusualPage.Name =
    "UnusualPage"
__UI.__L.unusualPage.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
__UI.__L.unusualPage.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
__UI.__L.unusualPage.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.unusualPage.BorderSizePixel =
    0
__UI.__L.unusualPage.ScrollBarThickness =
    6
__UI.__L.unusualPage.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
__UI.__L.unusualPage.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
__UI.__L.unusualPage.ScrollingDirection =
    Enum.ScrollingDirection.Y
__UI.__L.unusualPage.Visible =
    false
__UI.__L.unusualPage.Parent =
    __UI.__L.Main
__UI.unusualPageCorner =
    Instance.new("UICorner")
__UI.unusualPageCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
__UI.unusualPageCorner.Parent =
    unusualPagelocal unusualPadding =
    Instance.new("UIPadding")
unusualPadding.PaddingTop =
    UDim.new(
        0,
        8
    )
unusualPadding.PaddingBottom =
    UDim.new(
        0,
        8
    )
unusualPadding.PaddingLeft =
    UDim.new(
        0,
        8
    )
unusualPadding.PaddingRight =
    UDim.new(
        0,
        8
    )
unusualPadding.Parent =
    __UI.__L.unusualPage
__UI.__L.unusualLayout =
    Instance.new("UIListLayout")
__UI.__L.unusualLayout.Padding =
    UDim.new(
        0,
        7
    )
__UI.__L.unusualLayout.SortOrder =
    Enum.SortOrder.LayoutOrder
__UI.__L.unusualLayout.Parent =
    __UI.__L.unusualPage
__UI.__L.unusualRow =
    Instance.new("Frame")
__UI.__L.unusualRow.Size =
    UDim2.new(
        1,
        -4,
        0,
        48
    )
__UI.__L.unusualRow.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
__UI.__L.unusualRow.BorderSizePixel =
    0
__UI.__L.unusualRow.LayoutOrder =
    1
__UI.__L.unusualRow.Parent =
    __UI.__L.unusualPage
__UI.unusualRowCorner =
    Instance.new("UICorner")
__UI.unusualRowCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualRowCorner.Parent =
    __UI.__L.unusualRow
__UI.__L.unusualRowLabel =
    Instance.new("TextLabel")
__UI.__L.unusualRowLabel.Size =
    UDim2.new(
        0,
        60,
        1,
        0
    )
__UI.__L.unusualRowLabel.Position =
    UDim2.new(
        0,
        8,
        0,
        0
    )
__UI.__L.unusualRowLabel.BackgroundTransparency =
    1
__UI.__L.unusualRowLabel.Text =
    "UNUSUAL"
__UI.__L.unusualRowLabel.TextSize =
    10
__UI.__L.unusualRowLabel.Font =
    Enum.Font.GothamBold
__UI.__L.unusualRowLabel.TextColor3 =
    Color3.fromRGB(
        210,
        210,
        210
    )
__UI.__L.unusualRowLabel.TextXAlignment =
    Enum.TextXAlignment.Left
__UI.__L.unusualRowLabel.Parent =
    __UI.__L.unusualRow
--// ORIGINAL
unusualOriginalButton =
    Instance.new("TextButton")
unusualOriginalButton.Size =
    UDim2.new(
        0,
        125,
        0,
        32
    )
unusualOriginalButton.Position =
    UDim2.new(
        0,
        72,
        0.5,
        -16
    )
unusualOriginalButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
unusualOriginalButton.BorderSizePixel =
    0
unusualOriginalButton.Text =
    __UI.__L.unusualSlot.originalName
    or "Select"
unusualOriginalButton.TextSize =
    11
unusualOriginalButton.Font =
            Enum.Font.GothamBold
unusualOriginalButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualOriginalButton.TextTruncate =
    Enum.TextTruncate.AtEnd
unusualOriginalButton.Parent =
    __UI.__L.unusualRow
__UI.unusualOriginalCorner =
    Instance.new("UICorner")
__UI.unusualOriginalCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualOriginalCorner.Parent =
    unusualOriginalButton
--// ARROW
__UI.__L.unusualArrow =
    Instance.new("TextLabel")
__UI.__L.unusualArrow.Size =
    UDim2.new(
        0,
        24,
        0,
        32
    )
__UI.__L.unusualArrow.Position =
    UDim2.new(
        0,
        202,
        0.5,
        -16
    )
__UI.__L.unusualArrow.BackgroundTransparency =
    1
__UI.__L.unusualArrow.Text =
    "→"
__UI.__L.unusualArrow.TextSize =
    22
__UI.__L.unusualArrow.Font =
    Enum.Font.GothamBold
__UI.__L.unusualArrow.TextColor3 =
    Color3.fromRGB(
        180,
        180,
        180
    )
__UI.__L.unusualArrow.Parent =
    __UI.__L.unusualRow
--// REPLACE
__UI.__L.unusualReplaceButton =
    Instance.new("TextButton")
__UI.__L.unusualReplaceButton.Size =
    UDim2.new(
        0,
        125,
        0,
        32
    )
__UI.__L.unusualReplaceButton.Position =
    UDim2.new(
        0,
        226,
        0.5,
        -16
    )
__UI.__L.unusualReplaceButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
__UI.__L.unusualReplaceButton.BorderSizePixel =
    0
__UI.__L.unusualReplaceButton.Text =
    __UI.__L.unusualSlot.replaceName
    or "NONE"
__UI.__L.unusualReplaceButton.TextSize =
    11
__UI.__L.unusualReplaceButton.Font =
            Enum.Font.GothamBold
__UI.__L.unusualReplaceButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.unusualReplaceButton.TextTruncate =
    Enum.TextTruncate.AtEnd
__UI.__L.unusualReplaceButton.Parent =
    __UI.__L.unusualRow
__UI.unusualReplaceCorner =
    Instance.new("UICorner")
__UI.unusualReplaceCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualReplaceCorner.Parent =
    __UI.__L.unusualReplaceButton
--// =========================================================
--// UNUSUAL PICKER
-- =========================================================
__UI.__L.unusualPicker =
    Instance.new("Frame")
__UI.__L.unusualPicker.Size =
    UDim2.new(
        0,
        560,
        0,
        450
    )
__UI.__L.unusualPicker.Position =
    UDim2.new(
        0.5,
        -280,
        0.5,
        -225
    )
__UI.__L.unusualPicker.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )
__UI.__L.unusualPicker.BackgroundTransparency =
    0.10
__UI.__L.unusualPicker.BorderSizePixel =
    0
__UI.__L.unusualPicker.ClipsDescendants =
    true
__UI.__L.unusualPicker.Visible =
    false
__UI.__L.unusualPicker.ZIndex =
    30
__UI.__L.unusualPicker.Parent =
    __UI.__L.ScreenGui
__UI.unusualPickerCorner =
    Instance.new("UICorner")
__UI.unusualPickerCorner.CornerRadius =
    UDim.new(
        0,
        8
    )
__UI.unusualPickerCorner.Parent =
    __UI.__L.unusualPicker
__UI.unusualPickerStroke =
    Instance.new("UIStroke")
__UI.unusualPickerStroke.Thickness =
    1
__UI.unusualPickerStroke.Transparency =
    0.66
__UI.unusualPickerStroke.Parent =
    __UI.__L.unusualPicker

__UI.unusualPickerGlass =
    Instance.new("UIGradient")
__UI.unusualPickerGlass.Rotation =
    115
__UI.unusualPickerGlass.Color =
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
__UI.unusualPickerGlass.Transparency =
    NumberSequence.new(0.20)
__UI.unusualPickerGlass.Parent =
    __UI.__L.unusualPicker

__UI.__L.unusualPickerTitle =
    Instance.new("TextLabel")
__UI.__L.unusualPickerTitle.Size =
    UDim2.new(
        1,
        -45,
        0,
        32
    )
__UI.__L.unusualPickerTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        2
    )
__UI.__L.unusualPickerTitle.BackgroundTransparency =
    1
__UI.__L.unusualPickerTitle.Text =
    "Unusual Selector"
__UI.__L.unusualPickerTitle.TextSize =
    16
__UI.__L.unusualPickerTitle.Font =
    Enum.Font.GothamBold
__UI.__L.unusualPickerTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.unusualPickerTitle.TextXAlignment =
    Enum.TextXAlignment.Left
__UI.__L.unusualPickerTitle.ZIndex =
    31
__UI.__L.unusualPickerTitle.Parent =
    __UI.__L.unusualPicker
__UI.__L.unusualPickerClose =
    Instance.new("TextButton")
__UI.__L.unusualPickerClose.Size =
    UDim2.new(
        0,
        27,
        0,
        27
    )
__UI.__L.unusualPickerClose.Position =
    UDim2.new(
        1,
        -32,
        0,
        6
    )
__UI.__L.unusualPickerClose.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        50
    )
__UI.__L.unusualPickerClose.BackgroundTransparency =
    0.05
__UI.__L.unusualPickerClose.BorderSizePixel =
    0
__UI.__L.unusualPickerClose.ZIndex =
    31
__UI.__L.unusualPickerClose.Text =
    "×"
__UI.__L.unusualPickerClose.TextSize =
    27
__UI.__L.unusualPickerClose.Font =
    Enum.Font.GothamBold
__UI.__L.unusualPickerClose.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.unusualPickerClose.AutoButtonColor =
    false
__UI.__L.unusualPickerClose.Active =
    true
__UI.__L.unusualPickerClose.Selectable =
    false
__UI.__L.unusualPickerClose.Parent =
    __UI.__L.unusualPicker

__UI.UnusualPickerCloseCorner =
    Instance.new("UICorner")
__UI.UnusualPickerCloseCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.UnusualPickerCloseCorner.Parent =
    __UI.__L.unusualPickerClose

__UI.UnusualPickerCloseStroke =
    Instance.new("UIStroke")
__UI.UnusualPickerCloseStroke.Thickness =
    1
__UI.UnusualPickerCloseStroke.Transparency =
    0.65
__UI.UnusualPickerCloseStroke.Parent =
    __UI.__L.unusualPickerClose
__UI.__L.unusualPickerSearch =
    Instance.new("TextBox")
__UI.__L.unusualPickerSearch.Size =
    UDim2.new(
        1,
        -20,
        0,
        30
    )
__UI.__L.unusualPickerSearch.Position =
    UDim2.new(
        0,
        10,
        0,
        36
    )
__UI.__L.unusualPickerSearch.BackgroundColor3 =
    Color3.fromRGB(
        40,
        45,
        53
    )
__UI.__L.unusualPickerSearch.BackgroundTransparency =
    0.20
__UI.__L.unusualPickerSearch.BorderSizePixel =
    0
__UI.__L.unusualPickerSearch.ClearTextOnFocus =
    false
__UI.__L.unusualPickerSearch.PlaceholderText =
    "Search by name or ID..."
__UI.__L.unusualPickerSearch.PlaceholderColor3 =
    Color3.fromRGB(
        120,
        120,
        120
    )
__UI.__L.unusualPickerSearch.Text =
    ""
__UI.__L.unusualPickerSearch.TextSize =
    12
__UI.__L.unusualPickerSearch.Font =
            Enum.Font.GothamBold
__UI.__L.unusualPickerSearch.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.unusualPickerSearch.ZIndex =
    32
__UI.__L.unusualPickerSearch.Parent =
    __UI.__L.unusualPicker
__UI.unusualSearchCorner =
    Instance.new("UICorner")
__UI.unusualSearchCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.unusualSearchCorner.Parent =
    __UI.__L.unusualPickerSearch
__UI.__L.unusualPickerScroll =
    Instance.new("ScrollingFrame")
__UI.__L.unusualPickerScroll.Size =
    UDim2.new(
        1,
        -16,
        1,
        -74
    )
__UI.__L.unusualPickerScroll.Position =
    UDim2.new(
        0,
        8,
        0,
        70
    )
__UI.__L.unusualPickerScroll.BackgroundColor3 =
    Color3.fromRGB(
        32,
        35,
        42
    )
__UI.__L.unusualPickerScroll.BackgroundTransparency =
    0.20
__UI.__L.unusualPickerScroll.BorderSizePixel =
    0
__UI.__L.unusualPickerScroll.ScrollBarThickness =
    6
__UI.__L.unusualPickerScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
__UI.__L.unusualPickerScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
__UI.__L.unusualPickerScroll.ZIndex =
    31
__UI.__L.unusualPickerScroll.Parent =
    __UI.__L.unusualPicker
__UI.unusualPickerScrollCorner =
    Instance.new("UICorner")
__UI.unusualPickerScrollCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualPickerScrollCorner.Parent =
    __UI.__L.unusualPickerScroll
__UI.__L.unusualPickerPadding =
    Instance.new("UIPadding")
__UI.__L.unusualPickerPadding.PaddingTop =
    UDim.new(0, 8)
__UI.__L.unusualPickerPadding.PaddingBottom =
    UDim.new(0, 8)
__UI.__L.unusualPickerPadding.PaddingLeft =
    UDim.new(0, 8)
__UI.__L.unusualPickerPadding.PaddingRight =
    UDim.new(0, 8)
__UI.__L.unusualPickerPadding.Parent =
    __UI.__L.unusualPickerScroll
__UI.__L.unusualPickerGrid =
    Instance.new("UIGridLayout")
__UI.__L.unusualPickerGrid.CellSize =
    UDim2.new(
        1 / 3,
        -6,
        0,
        92
    )
__UI.__L.unusualPickerGrid.CellPadding =
    UDim2.new(
        0,
        6,
        0,
        8
    )
__UI.__L.unusualPickerGrid.SortOrder =
    Enum.SortOrder.LayoutOrder
__UI.__L.unusualPickerGrid.Parent =
    __UI.__L.unusualPickerScroll
--// =========================================================
--// REBUILD UNUSUAL PICKER
--// =========================================================
function __UI.__L.UnusualFns.rebuildUnusualPicker()

    pcall(function()
        __UI.__L.collectCurrentUnusualIcons(
            LocalPlayer:FindFirstChild(
                "PlayerGui"
            )
        )
    end)

    local cosmeticButtonsWereRemoved = false

    for _, button in ipairs(
        __UI.__L.unusualPickerButtons
    ) do
        pcall(function()
            if string.sub(
                tostring(button.Name),
                1,
                9
            ) == "Cosmetic_"
            then
                local preview =
                    button:FindFirstChild(
                        "CosmeticPreview"
                    )

                if preview then
                    local id =
                        tonumber(
                            string.match(
                                button.Name,
                                "^Cosmetic_(%d+)$"
                            )
                        )

                    if id then
                        __UI.__L.cosmeticPreviewCache[id] =
                            preview
                        preview.Parent =
                            __UI.__L.cosmeticPreviewCacheHolder
                    end
                end

                cosmeticButtonsWereRemoved = true
            end
        end)

        pcall(function()
            button:Destroy()
        end)
    end

    if cosmeticButtonsWereRemoved then
        __UI.__L.cosmeticPickerPreloaded = false
    end

    table.clear(
        __UI.__L.unusualPickerButtons
    )
    local query =
        string.lower(
            __UI.__L.unusualPickerSearch.Text
                or ""
        )
    local shown = 0

    do
        local button =
            Instance.new("TextButton")

        button.Name = "Unusual_None"
        button.BackgroundColor3 = Color3.fromRGB(55, 58, 68)
        button.BackgroundTransparency = 0.12
        button.BorderSizePixel = 0
        button.ClipsDescendants = true
        button.Text = "NONE"
        button.TextSize = 11
        button.Font = Enum.Font.GothamBold
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextTruncate = Enum.TextTruncate.AtEnd
        button.LayoutOrder = 0
        button.ZIndex = 32
        button.Parent = __UI.__L.unusualPickerScroll

        local corner =
            Instance.new("UICorner")

        corner.CornerRadius =
            UDim.new(0, 5)
        corner.Parent = button

        table.insert(
            __UI.__L.unusualPickerButtons,
            button
        )

        __UI.__L.UnusualFns.addUnusualConnection(
            button.MouseButton1Click:Connect(
                function()
                    if __UI.__L.unusualPickerSide == "Original" then
                        __UI.__L.unusualSlot.originalId = nil
                        __UI.__L.unusualSlot.originalName = nil
                        unusualOriginalButton.Text = "Select"
                    elseif __UI.__L.unusualPickerSide == "Replace" then
                        __UI.__L.unusualSlot.replaceId = nil
                        __UI.__L.unusualSlot.replaceName = nil
                        __UI.__L.unusualReplaceButton.Text = "Select"
                    else
                        return
                    end

                    __UI.__L.savedConfig.unusual = {
                        originalId = __UI.__L.unusualSlot.originalId,
                        replaceId = __UI.__L.unusualSlot.replaceId
                    }

                    saveSavedConfig()

                    if __UI.__L.unusualEnabled then
                        __UI.__L.unusualEnabled = false
                        genv.UNUSUAL_SWAPPER_ENABLED = false
                        __UI.__L.UnusualFns.restoreUnusual()
                        __UI.__L.updateUnusualToggle()
                    end

                    __UI.__L.unusualPicker.Visible = false
                    __UI.__L.unusualPickerSide = nil
                end
            )
        )

        shown += 1
    end

    for index, data in ipairs(
        __UI.__L.unusualList
    ) do
        local nameLower =
            string.lower(
                data.name
            )
        local idText =
            tostring(
                data.id
            )
        if query == ""
            or string.find(
                nameLower,
                query,
                1,
                true
            )
            or string.find(
                idText,
                query,
                1,
                true
            )
        then
            shown += 1
            local button =
                Instance.new(
                    "TextButton"
                )
            button.Name =
                "Unusual_"
                .. tostring(
                    data.id
                )
            button.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    50
                )
            button.BackgroundTransparency =
                0.05
            button.BorderSizePixel =
                0
            button.ClipsDescendants =
                true
            button.Text =
                ""
            button.TextSize =
                11
            button.Font =
        Enum.Font.GothamBold
            button.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            button.TextTruncate =
                Enum.TextTruncate.AtEnd
            button.LayoutOrder =
                index
            button.ZIndex =
                32
            button.Parent =
                __UI.__L.unusualPickerScroll

            local icon =
                Instance.new("ImageLabel")
            icon.Name =
                "EffectIcon"
            icon.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            icon.Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                )
            icon.BackgroundTransparency =
                1
            icon.BorderSizePixel =
                0
            icon.Visible =
                true
            icon.ImageTransparency =
                0
            icon.Active =
                false
            icon.Image =
                data.icon
                or __UI.__L.unusualIconIdCache[
                    data.id
                ]
                or __UI.__L.unusualIconCache[
                    __UI.__L.normalizeUnusualIconKey(
                        data.name
                    )
                ]
                or ""
            icon.ScaleType =
                Enum.ScaleType.Crop
            icon.ZIndex =
                33
            icon.Parent =
                button

            local iconCorner =
                Instance.new("UICorner")
            iconCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            iconCorner.Parent =
                icon

            local glass =
                Instance.new("Frame")
            glass.Name =
                "GlassOverlay"
            glass.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            glass.Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                )
            glass.BackgroundColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            glass.BackgroundTransparency =
                0.95
            glass.BorderSizePixel =
                0
            glass.ZIndex =
                34
            glass.Parent =
                button

            local glassCorner =
                Instance.new("UICorner")
            glassCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            glassCorner.Parent =
                glass

            local shade =
                Instance.new("Frame")
            shade.Name =
                "NameShade"
            shade.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    36
                )
            shade.Position =
                UDim2.new(
                    0,
                    0,
                    1,
                    -36
                )
            shade.BackgroundColor3 =
                Color3.fromRGB(
                    0,
                    0,
                    0
                )
            shade.BackgroundTransparency =
                0.42
            shade.BorderSizePixel =
                0
            shade.ZIndex =
                35
            shade.Parent =
                button

            local nameCorner =
                Instance.new("UICorner")
            nameCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            nameCorner.Parent =
                shade

            local nameLabel =
                Instance.new("TextLabel")
            nameLabel.Name =
                "EffectName"
            nameLabel.Size =
                UDim2.new(
                    1,
                    -12,
                    0,
                    30
                )
            nameLabel.Position =
                UDim2.new(
                    0,
                    6,
                    1,
                    -33
                )
            nameLabel.BackgroundTransparency =
                1
            nameLabel.BorderSizePixel =
                0
            nameLabel.Text =
                data.name
            nameLabel.TextSize =
                11
            nameLabel.Font =
                Enum.Font.GothamMedium
            nameLabel.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            nameLabel.TextXAlignment =
                Enum.TextXAlignment.Left
            nameLabel.TextYAlignment =
                Enum.TextYAlignment.Center
            nameLabel.TextTruncate =
                Enum.TextTruncate.AtEnd
            nameLabel.ZIndex =
                36
            nameLabel.Parent =
                button

            local corner =
                Instance.new(
                    "UICorner"
                )
            corner.CornerRadius =
                UDim.new(
                    0,
                    7
                )
            corner.Parent =
                button
            table.insert(
                __UI.__L.unusualPickerButtons,
                button
            )
            __UI.__L.UnusualFns.addUnusualConnection(
                button.MouseButton1Click:Connect(
                    function()
                        if __UI.__L.unusualPickerSide
                            == "Original"
                        then
                            __UI.__L.unusualSlot.originalId =
                                data.id
                            __UI.__L.unusualSlot.originalName =
                                data.name
                            unusualOriginalButton.Text =
                                data.name
                        elseif __UI.__L.unusualPickerSide
                            == "Replace"
                        then
                            __UI.__L.unusualSlot.replaceId =
                                data.id
                            __UI.__L.unusualSlot.replaceName =
                                data.name
                            __UI.__L.unusualReplaceButton.Text =
                                data.name
                        end
                        __UI.__L.savedConfig.unusual = {
                            originalId =
                                __UI.__L.unusualSlot.originalId,
                            replaceId =
                                __UI.__L.unusualSlot.replaceId
                        }
                        saveSavedConfig()
                        __UI.__L.unusualPicker.Visible =
                            false
                        __UI.__L.unusualPickerSide =
                            nil
                        if __UI.__L.unusualEnabled then
                            task.spawn(
                                __UI.__L.UnusualFns.reapplyUnusual
                            )
                        end
                    end
                )
            )
        end
    end
    pcall(function()
        if __UI.__L.unusualStatus then
            __UI.__L.unusualStatus.Text =
                "Unusuals: "
                .. tostring(
                    #__UI.__L.unusualList
                )
                .. " • "
                .. tostring(
                    shown
                )
                .. " found"
        end
    end)
    __UI.__L.unusualPickerScroll.CanvasPosition =
        Vector2.new(
            0,
            0
        )
end
--// =========================================================
--// OPEN / CLOSE PICKER
-- =========================================================
function __UI.__L.UnusualFns.openUnusualPicker(
    side
)
    __UI.__L.unusualPickerSide =
        side

    if side == "Original" then
        __UI.__L.unusualPickerTitle.Text =
            "Select Original"
    else
        __UI.__L.unusualPickerTitle.Text =
            "Select Replacement"
    end

    __UI.__L.unusualPickerSearch.Text =
        ""

    __UI.__L.UnusualFns.rebuildUnusualPicker()

    __UI.animatePickerAppear(
        __UI.__L.unusualPicker
    )
end
function __UI.__L.UnusualFns.closeUnusualPicker()
    __UI.__L.unusualPicker.Visible =
        false
    __UI.__L.unusualPickerSide =
        nil
    __UI.__L.cosmetic.picking = false
    __UI.__L.cosmetic.pickerSide = nil
end
__UI.__L.UnusualFns.addUnusualConnection(    unusualOriginalButton.MouseButton1Click:Connect(
        function()
            __UI.__L.UnusualFns.openUnusualPicker(
                "Original"
            )
        end
    )
)
__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.unusualReplaceButton.MouseButton1Click:Connect(
        function()
            __UI.__L.UnusualFns.openUnusualPicker(
                "Replace"
            )
        end
    )
)
__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.unusualPickerClose.MouseButton1Click:Connect(
        function()
            __UI.__L.UnusualFns.closeUnusualPicker()
        end
    )
)
__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.unusualPickerSearch:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()
            if __UI.__L.unusualPicker.Visible then
                if __UI.__L.cosmetic.picking then
                    __UI.__L.cosmetic.rebuildPicker()
                else
                    __UI.__L.UnusualFns.rebuildUnusualPicker()
                end
            end
        end
    )
)

__UI.__L.UnusualFns.addUnusualConnection(
    LocalPlayer:WaitForChild(
        "PlayerGui"
    ).DescendantAdded:Connect(
        function(obj)
            if obj:IsA("ImageLabel")
                and obj.Name == "IconIMG"
            then
                __UI.__L.cacheUnusualIconFromObject(
                    obj
                )

                __UI.__L.UnusualFns.addUnusualConnection(
                    obj:GetPropertyChangedSignal(
                        "Image"
                    ):Connect(
                        function()
                            __UI.__L.cacheUnusualIconFromObject(
                                obj
                            )
                        end
                    )
                )
            end
        end
    )
)

--// =========================================================
--// UNUSUAL STATUS + TOGGLE USE EXISTING GUI
-- =================================================
__UI.__L.unusualStatusText =
    Instance.new("TextLabel")
__UI.__L.unusualStatusText.Name =
    "UnusualStatus"
__UI.__L.unusualStatusText.Size =
    UDim2.new(
        0,
        260,
        0,
        20
    )
__UI.__L.unusualStatusText.Position =
    UDim2.new(
        0,
        82,
        0,
        43
    )
__UI.__L.unusualStatusText.BackgroundTransparency =
    1
__UI.__L.unusualStatusText.Text =
    ""
__UI.__L.unusualStatusText.TextSize =
    12
__UI.__L.unusualStatusText.Font =
    Enum.Font.Gotham
__UI.__L.unusualStatusText.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
__UI.__L.unusualStatusText.TextXAlignment =
    Enum.TextXAlignment.Left
__UI.__L.unusualStatusText.Visible =
    false
__UI.__L.unusualStatusText.Parent =
    __UI.__L.Main
__UI.__L.unusualStatus =
    __UI.__L.unusualStatusText
__UI.__L.updateUnusualToggle = function()
    pcall(function()
        if __UI.__L.unusualEnabled then
            __UI.__L.Toggle.Text =
                "SWAP: ON"
            __UI.__L.Toggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            __UI.__L.Toggle.Text =
                "SWAP: OFF"
            __UI.__L.Toggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end)
end
--// =========================================================
--// OTHERS
--// R6 AVATAR SCANNER / EDITOR
--// =========================================================
function __UI.__L.others.saveConfig()
    __UI.__L.savedConfig.others =
        __UI.__L.savedConfig.others
        or {}
    for _, slot in ipairs(
        __UI.__L.others.ACCESSORY_SLOTS or {}
    ) do
        local box =
            __UI.__L.others.fieldBoxes[
                slot.property
            ]
        if box then
            __UI.__L.savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    for _, slot in ipairs(
        __UI.__L.others.CLOTHING_SLOTS or {}
    ) do
        local box =
            __UI.__L.others.fieldBoxes[
                slot.property
            ]
        if box then
            __UI.__L.savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    for _, slot in ipairs(
        __UI.__L.others.BODY_SLOTS or {}
    ) do
        local box =
            __UI.__L.others.fieldBoxes[
                slot.property
            ]
        if box then
            __UI.__L.savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    __UI.__L.savedConfig.others._Headless =
        tostring(
            __UI.__L.savedConfig.others._Headless
            or ""
        )
    __UI.__L.savedConfig.others._Korblox =
        tostring(
            __UI.__L.savedConfig.others._Korblox
            or ""
        )
    if __UI.__L.others.avatarImportBox then
        __UI.__L.savedConfig.others._AvatarImport =
            tostring(
                __UI.__L.others.avatarImportBox.Text
                or ""
            )
    end
    pcall(function()
        saveSavedConfig()
    end)
end
function __UI.__L.others.loadConfig()
    local saved =
        __UI.__L.savedConfig.others
    if type(saved) ~= "table" then
        return
    end
    for _, group in ipairs({
        __UI.__L.others.ACCESSORY_SLOTS,
        __UI.__L.others.CLOTHING_SLOTS,
        __UI.__L.others.BODY_SLOTS
    }) do
        for _, slot in ipairs(
            group
        ) do
            local box =
                __UI.__L.others.fieldBoxes[
                    slot.property
                ]
            local value =
                saved[
                    slot.property
                ]
            if box
                and value ~= nil
            then
                box.Text =
                    tostring(
                        value
                    )
            end
        end
    end
end
__UI.__L.others.HEADLESS_ID = 134082579
__UI.__L.others.KORBLOX_ID = 139607718
__UI.__L.others.ACCESSORY_SLOTS = {
    {label = "Hats", property = "HatAccessory", multi = true},
    {label = "Hair", property = "HairAccessory", multi = true},
    {label = "Face Accessory", property = "FaceAccessory", multi = true},
    {label = "Neck", property = "NeckAccessory", multi = true},
    {label = "Shoulder", property = "ShouldersAccessory", multi = true},
    {label = "Front", property = "FrontAccessory", multi = true},
    {label = "Back", property = "BackAccessory", multi = true},
    {label = "Waist", property = "WaistAccessory", multi = true}
}
__UI.__L.others.CLOTHING_SLOTS = {
    {label = "Shirt", property = "Shirt"},
    {label = "Pants", property = "Pants"},
    {label = "T-Shirt", property = "GraphicTShirt"}
}
__UI.__L.others.BODY_SLOTS = {
    {label = "Head", property = "Head"},
    {label = "Torso", property = "Torso"},
    {label = "Left Arm", property = "LeftArm"},
    {label = "Right Arm", property = "RightArm"},
    {label = "Left Leg", property = "LeftLeg"},
    {label = "Right Leg", property = "RightLeg"}
}
__UI.__L.others.ACCESSORY_PROPERTIES = {
    "HatAccessory",
    "HairAccessory",
    "FaceAccessory",
    "NeckAccessory",
    "ShouldersAccessory",
    "FrontAccessory",
    "BackAccessory",
    "WaistAccessory"
}
__UI.__L.others.page = nil
__UI.__L.others.status = nil
__UI.__L.others.originalDescription = nil
__UI.__L.others.targetHumanoid = nil
__UI.__L.others.fieldBoxes = {}
function __UI.__L.others.getHumanoids()
    local result = {}
    local seen = {}
    local function add(h)
        if h
            and h:IsA("Humanoid")
            and not seen[h]
        then
            seen[h] = true
            table.insert(result, h)
        end
    end
    local rig =
        __UI.__L.UnusualFns.getUnusualVisualRig()
    if rig then
        add(
            rig:FindFirstChildOfClass(
                "Humanoid"
            )
        )
    end
    local character =
        __UI.__L.UnusualFns.getUnusualPlayerCharacter()
    if character then
        add(
            character:FindFirstChildOfClass(
                "Humanoid"
            )
        )
    end
    return result
end
function __UI.__L.others.getHumanoid()
    return __UI.__L.others.getHumanoids()[1]
end

--// =========================================================
--// OTHERS -> NATIVE GAME VISIBILITY BRIDGE
--//
--// Others uses Humanoid:ApplyDescription*() and can replace the
--// complete visual hierarchy: body parts, Head, hair, every
--// Accessory/Handle, Decals, Textures and effect descendants.
--//
--// IMPORTANT:
--// Do NOT calculate first-person transparency here.
--// The game already has the exact handler we need:
--// Character.Client.Visibility:UpdateVisibility(entries)
--// -> Visibility:SetVisibility()
--//
--// We feed the complete Others hierarchy directly into that
--// native handler. This gives Others the same P1/P3 behavior as
--// the game's own character visibility system.
--// =========================================================

__UI.__L.othersBuildNativeVisibilityEntries = function()
    local entries = {}

    local function isVisibilityRoot(object)
        if not object or not object:IsA("BasePart") then
            return false
        end

        local name = object.Name

        return name == "Head"
            or name == "Torso"
            or name == "Left Arm"
            or name == "Right Arm"
            or name == "Left Leg"
            or name == "Right Leg"
            or name == "UpperTorso"
            or name == "LowerTorso"
            or name == "LeftUpperArm"
            or name == "LeftLowerArm"
            or name == "LeftHand"
            or name == "RightUpperArm"
            or name == "RightLowerArm"
            or name == "RightHand"
            or name == "LeftUpperLeg"
            or name == "LeftLowerLeg"
            or name == "LeftFoot"
            or name == "RightUpperLeg"
            or name == "RightLowerLeg"
            or name == "RightFoot"
            or name == "HumanoidRootPart"
        end

    local function addEntry(root)
        if not root or not root.Parent or not root:IsA("BasePart") then
            return nil
        end

        for _, entry in ipairs(entries) do
            if entry[1] == root then
                return entry
            end
        end

        local entry = {
            root,
            root:GetDescendants()
        }

        table.insert(entries, entry)

        return entry
    end

    local function getAttachmentHost(accessory, model)
        local handle =
            accessory:FindFirstChild("Handle")

        if not handle or not handle:IsA("BasePart") then
            return nil
        end

        --// Accessories have body-attachment objects inside Handle.
        --// Resolve the destination limb from the attachment name first.
        local attachmentNames = {}

        for _, object in ipairs(handle:GetDescendants()) do
            if object:IsA("Attachment") then
                table.insert(
                    attachmentNames,
                    object.Name
                )
            end
        end

        local candidates = {}

        for _, part in ipairs(model:GetChildren()) do
            if part:IsA("BasePart")
                and isVisibilityRoot(part)
            then
                table.insert(candidates, part)
            end
        end

        local preferredNames = {
            HatAttachment = {"Head"},
            HairAttachment = {"Head"},
            FaceFrontAttachment = {"Head"},
            FaceCenterAttachment = {"Head"},
            NeckAttachment = {"Torso", "UpperTorso"},
            WaistFrontAttachment = {"Torso", "LowerTorso"},
            WaistCenterAttachment = {"Torso", "LowerTorso"},
            WaistBackAttachment = {"Torso", "LowerTorso"},
            BodyFrontAttachment = {"Torso", "UpperTorso"},
            BodyBackAttachment = {"Torso", "UpperTorso"},
            LeftShoulderAttachment = {"Left Arm", "LeftUpperArm"},
            RightShoulderAttachment = {"Right Arm", "RightUpperArm"}
        }

        for _, attachmentName in ipairs(attachmentNames) do
            local preferred = preferredNames[attachmentName]

            if preferred then
                for _, candidateName in ipairs(preferred) do
                    for _, candidate in ipairs(candidates) do
                        if candidate.Name == candidateName then
                            return candidate
                        end
                    end
                end
            end
        end

        --// Fallback: head-worn accessories (hair/hat/face/etc.)
        --// belong to Head. This is also the important case for P1:
        --// the native Visibility handler then applies Head's visibility
        --// state to the complete accessory tree.
        local head =
            model:FindFirstChild("Head")

        if head and head:IsA("BasePart") then
            return head
        end

        return nil
    end

    local function addAccessoryToHost(accessory, model)
        local host =
            getAttachmentHost(
                accessory,
                model
            )

        if not host then
            return
        end

        local entry =
            addEntry(host)

        if not entry then
            return
        end

        local seen = {}

        for _, object in ipairs(entry[2]) do
            seen[object] = true
        end

        local handle =
            accessory:FindFirstChild("Handle")

        if handle and not seen[handle] then
            table.insert(entry[2], handle)
            seen[handle] = true

            for _, object in ipairs(handle:GetDescendants()) do
                if not seen[object] then
                    table.insert(
                        entry[2],
                        object
                    )
                    seen[object] = true
                end
            end
        end
    end

    for _, humanoid in ipairs(
        __UI.__L.others.getHumanoids()
    ) do
        local model =
            humanoid.Parent

        if model and model.Parent then
            --// Only canonical character BaseParts are used as Visibility
            --// roots. This is critical: an Accessory Handle named "Handle"
            --// must NEVER become the root, because native SetVisibility()
            --// decides visibility from the root's name.
            for _, child in ipairs(
                model:GetChildren()
            ) do
                if child:IsA("BasePart")
                    and isVisibilityRoot(child)
                then
                    addEntry(child)
                elseif child:IsA("Accessory") then
                    addAccessoryToHost(
                        child,
                        model
                    )
                end
            end

            --// Some accessory systems nest Accessories deeper than the
            --// direct model children, so catch every remaining one.
            for _, object in ipairs(
                model:GetDescendants()
            ) do
                if object:IsA("Accessory") then
                    addAccessoryToHost(
                        object,
                        model
                    )
                end
            end
        end
    end

    return entries
end

__UI.__L.othersSyncWithNativeVisibility = function()
    local characterObject =
        getCharacterObject()

    if not characterObject
        or not characterObject.Visibility
    then
        return
    end

    local visibility =
        characterObject.Visibility

    local entries =
        __UI.__L.othersBuildNativeVisibilityEntries()

    if #entries == 0 then
        return
    end

    --// Refresh the Type immediately from the game's own Visibility
    --// logic so camera distance / first-person state is current before
    --// SetVisibility() processes the Others hierarchy.
    local currentType

    pcall(function()
        currentType =
            visibility:GetType()
    end)

    if currentType then
        visibility.Type =
            currentType
    end

    --// Directly invoke the game's own handler.
    pcall(function()
        visibility:UpdateVisibility(
            entries
        )
    end)
end

--// A previous DeadEye version used a custom Others first-person
--// renderer. Remove that RenderStep as well as our new one so a
--// previous script instance can never fight the native handler.
pcall(function()
    RunService:UnbindFromRenderStep(
        "DeadEyeOthersFirstPersonVisibility"
    )

    RunService:UnbindFromRenderStep(
        "DeadEyeOthersNativeVisibility"
    )
end)

RunService:BindToRenderStep(
    "DeadEyeOthersNativeVisibility",
    Enum.RenderPriority.Camera.Value + 2,
    function()
        __UI.__L.othersSyncWithNativeVisibility()
    end
)

function __UI.__L.others.ensureSnapshot()

    if __UI.__L.others.originalDescription then
        return true
    end
    local humanoid =
        __UI.__L.others.getHumanoid()
    if not humanoid then
        return false
    end
    local ok, description =
        pcall(function()
            return humanoid:GetAppliedDescription()
        end)
    if not ok or not description then
        return false
    end
    local cloneOk, clone =
        pcall(function()
            return description:Clone()
        end)
    if not cloneOk or not clone then
        return false
    end
    __UI.__L.others.targetHumanoid =
        humanoid
    __UI.__L.others.originalDescription =
        clone
    return true
end
function __UI.__L.others.isR6()
    local humanoid =
        __UI.__L.others.getHumanoid()
    return humanoid
        and humanoid.RigType
            == Enum.HumanoidRigType.R6
end
function __UI.__L.others.getDescription()
    if not __UI.__L.others.isR6() then
        if __UI.__L.others.status then
            __UI.__L.others.status.Text =
                "R6 only"
        end
        return nil
    end
    if not __UI.__L.others.ensureSnapshot() then
        return nil
    end
    local humanoid =
        __UI.__L.others.getHumanoid()
    if not humanoid then
        return nil
    end
    local ok, description =
        pcall(function()
            return humanoid:GetAppliedDescription()
        end)
    if ok and description then
        return description
    end
    return nil
end
function __UI.__L.others.propertyText(
    description,
    slot
)
    local ok, value =
        pcall(function()
            return description[
                slot.property
            ]
        end)
    if not ok or value == nil then
        return ""
    end
    if slot.multi then
        return tostring(value or "")
    end
    local number =
        tonumber(value)
    if not number or number == 0 then
        return ""
    end
    return tostring(number)
end
function __UI.__L.others.refresh()
    local description =
        __UI.__L.others.getDescription()
    if not description then
        return
    end
    local groups = {
        __UI.__L.others.ACCESSORY_SLOTS,
        __UI.__L.others.CLOTHING_SLOTS,
        __UI.__L.others.BODY_SLOTS
    }
    for _, group in ipairs(groups) do
        for _, slot in ipairs(group) do
            local box =
                __UI.__L.others.fieldBoxes[
                    slot.property
                ]
            if box then
                box.Text =
                    __UI.__L.others.propertyText(
                        description,
                        slot
                    )
            end
        end
    end
end
function __UI.__L.others.applyDescription(
    description
)
    if not __UI.__L.others.isR6() then
        if __UI.__L.others.status then
            __UI.__L.others.status.Text =
                "R6 only"
        end
        return false
    end
    local applied = 0
    local lastError

    for _, humanoid in ipairs(
        __UI.__L.others.getHumanoids()
    ) do
        local ok, err =
            pcall(function()
                humanoid:ApplyDescriptionResetAsync(
                    description
                )
            end)
        if not ok then
            lastError =
                err
            local legacyOk, legacyErr =
                pcall(function()
                    humanoid:ApplyDescriptionReset(
                        description
                    )
                end)
            if legacyOk then
                ok = true
            else
                lastError = legacyErr
            end
        end
        if ok then
            applied += 1
        end
    end
    if applied == 0 then
        --// Last compatibility fallback.
        for _, humanoid in ipairs(
            __UI.__L.others.getHumanoids()
        ) do
            local ok =
                pcall(function()
                    humanoid:ApplyDescriptionAsync(
                        description
                    )
                end)
            if ok then
                applied += 1
            end
        end
    end
    if applied == 0 then
        warn(
            "[Others] Apply failed:",
            lastError
        )
        if __UI.__L.others.status then
            __UI.__L.others.status.Text =
                "Apply Error"
        end
        return false
    end

    pcall(function()
        if __UI.__L.others.status then
            __UI.__L.others.status.Text =
                "Applied"
        end
    end)
    return true
end
function __UI.__L.others.applyField(
    slot,
    textValue
)
    local description =
        __UI.__L.others.getDescription()
    if not description then
        return false
    end
    local value
    if slot.multi then
        value =
            tostring(
                textValue or ""
            )
        value =
            string.gsub(
                value,
                "%s+",
                ""
            )
        value =
            string.gsub(
                value,
                "[^%d,]",
                ""
            )
        value =
            string.gsub(
                value,
                ",+",
                ","
            )
        value =
            string.gsub(
                value,
                "^,",
                ""
            )
        value =
            string.gsub(
                value,
                ",$",
                ""
            )
    else
        value =
            tonumber(
                string.match(
                    tostring(textValue or ""),
                    "%d+"
                )
            )
            or 0
    end
    local ok =
        pcall(function()
            description[
                slot.property
            ] = value
        end)
    if not ok then
        return false
    end
    return __UI.__L.others.applyDescription(
        description
    )
end
function __UI.__L.others.scan()
    local description =
        __UI.__L.others.getDescription()
    if not description then
        return false
    end
    __UI.__L.others.refresh()
    if __UI.__L.others.status then
        __UI.__L.others.status.Text =
            "Scanned • R6"
    end
    return true
end
function __UI.__L.others.clearAccessories()
    local description =
        __UI.__L.others.getDescription()
    if not description then
        return false
    end
    for _, property in ipairs(
        __UI.__L.others.ACCESSORY_PROPERTIES
    ) do
        pcall(function()
            description[property] = ""
        end)
    end
    pcall(function()
        description.Face = 0
    end)
    return __UI.__L.others.applyDescription(
        description
    )
end
function __UI.__L.others.restore(
    keepSnapshot
)
    if not __UI.__L.others.originalDescription then
        return false
    end
    local result =
        __UI.__L.others.applyDescription(
            __UI.__L.others.originalDescription
        )
    if not keepSnapshot then
        __UI.__L.others.originalDescription =
            nil
        __UI.__L.others.targetHumanoid =
            nil
    end
    return result
end

--// =========================================================
--// =========================================================
--// FIRST-PERSON HEAD/CAMERA VISIBILITY
--// =========================================================
--// Do NOT run a custom head/accessory transparency loop here.
--// Native game CameraModule/TransparencyController owns the
--// first-person visibility of the avatar head and stock Roblox
--// hair/accessories. DeadEye must not override that behavior.
--// =========================================================
--// MAIN / AUTOJUMP
--// =========================================================
__UI.__L.mainJump = {
    enabled = false,
    autoJumpMode = "rage",
    lookEnabled = false,
    airTurnEnabled = false,
    airTurnSpeed = 180,
    jumpDelay = 0.01,
    hotkeyName = "Z",
    hideUIHotkeyName = "H",
    crouchSpamEnabled = false,
    crouchSpamDelay = 0.03,
    crouchSpamHotkeyName = "I",
    reverseLookMode = "without",
    reverseLookEnabled = false,
    benchTrimpEnabled = false,
    benchTrimpHotkeyName = "P",
    benchTrimpStateConnection = nil,
    smartAirTurnEnabled = false,
    airTurnHotkeyName = "O",
    crouchSpamConnection = nil,
    crouchSpamMovement = nil,
    crouchSpamState = false,
    crouchSpamElapsed = 0,
    crouchSpamDelayBox = nil,
    crouchSpamHotkeyBox = nil,
    crouchSpamToggle = nil,
    lastJump = 0,
    capturing = nil,
    needsInputRearm = false,
    character = nil,
    humanoid = nil,
    root = nil,
    sensorPart = nil,
    frontSensorPart = nil,
    rearSensorPart = nil,
    lookSensorPart = nil,
    lookFrontSensorPart = nil,
    jumpForwardSensorPart = nil,
    lookForwardSensorPart = nil,
    sensorTouchConnection = nil,
    frontSensorTouchConnection = nil,
    rearSensorTouchConnection = nil,
    jumpForwardSensorTouchConnection = nil,
    lookAutoJumpCycle = false,
    lookWatcherConnection = nil,
    lookTriggeredThisAir = false,
    manualJumpActive = false,
    rageLookEnabled = false,
    rageLookHookInstalled = false,
    rageLookAirFunction = nil,
    rageLookOriginalAir = nil,
    rageLookFallbackPreConnection = nil,
    rageLookFallbackPostConnection = nil,
    rageLookFallbackHeartbeatConnection = nil,
    rageLookFallbackRenderConnection = nil,
    rageLookSavedCFrame = nil,
    rageLookCameraSpoofed = false,
    rageLookMode = nil,
    reverseLookHookInstalled = false,
    reverseLookSetFunction = nil,
    reverseLookOriginalSet = nil,
    reverseLookGetFunction = nil,
    reverseLookOriginalGet = nil,
    reverseLookModeButton = nil,
    reverseLookModeKnob = nil,
    reverseLookModeWithLabel = nil,
    reverseLookModeSoloLabel = nil,
    reverseLookToggle = nil,
    frontSensorTouchConnection = nil,
    legitJumpConnection = nil,
    --// LEGIT AutoJump v1.20 runtime state.
    legitMovement = nil,
    legitHumanoid = nil,
    legitRoot = nil,
    legitActiveJumpReact = false,
    legitJumpSequence = 0,
    legitActiveJumpStartedAt = 0,
    legitGroundJumpUsed = false,
    legitGroundJumpCount = 0,
    legitClimbJumpUsed = false,
    legitClimbJumpCount = 0,
    legitPreviousHumanoidState = nil,
    legitBlockClimbEnd = false,
    crouchSpamPreJump = false,
    crouchSpamPreJumpStartedAt = 0,
    autoJumpModeButton = nil,
    autoJumpModePicker = nil,
    __UI.__L.connections = {}
}
__UI.__L.mainJump.jumpDelay =
    math.clamp(
        tonumber(
            __UI.__L.savedConfig.main
            and __UI.__L.savedConfig.main.jumpDelay
        ) or 0.01,
        0,
        5
    )
__UI.__L.mainJump.autoJumpMode =
    tostring(
        __UI.__L.savedConfig.main
        and __UI.__L.savedConfig.main.autoJumpMode
        or "rage"
    ):lower()

if __UI.__L.mainJump.autoJumpMode ~= "legit"
    and __UI.__L.mainJump.autoJumpMode ~= "rage"
then
    __UI.__L.mainJump.autoJumpMode = "rage"
end

__UI.__L.mainJump.hotkeyName =
    tostring(
        __UI.__L.savedConfig.main
        and __UI.__L.savedConfig.main.hotkey
        or "Z"
    )
__UI.__L.mainJump.hideUIHotkeyName =
    tostring(
        __UI.__L.savedConfig.main
        and __UI.__L.savedConfig.main.hideUIHotkey
        or "H"
    )
__UI.__L.mainJump.crouchSpamDelay =
    math.clamp(
        tonumber(
            __UI.__L.savedConfig.main
            and __UI.__L.savedConfig.main.crouchSpamDelay
        ) or 0.03,
        0.001,
        5
    )
__UI.__L.mainJump.crouchSpamHotkeyName =
    tostring(
        __UI.__L.savedConfig.main
        and __UI.__L.savedConfig.main.crouchSpamHotkey
        or "I"
    )
__UI.__L.mainJump.benchTrimpHotkeyName =
    tostring(
        __UI.__L.savedConfig.main
        and __UI.__L.savedConfig.main.benchTrimpHotkey
        or "P"
    )
__UI.__L.mainJump.benchTrimpEnabled =
    __UI.__L.savedConfig.main
    and __UI.__L.savedConfig.main.benchTrimpEnabled == true
    or false
__UI.__L.mainJump.smartAirTurnEnabled =
    __UI.__L.savedConfig.main
    and __UI.__L.savedConfig.main.smartAirTurn == true
    or false
__UI.__L.mainJump.airTurnHotkeyName =
    tostring(
        __UI.__L.savedConfig.main
        and (
            __UI.__L.savedConfig.main.airTurnHotkey
            or __UI.__L.savedConfig.main.smartAirTurnHotkey
        )
        or "O"
    )
__UI.__L.mainJump.lookEnabled =
    __UI.__L.savedConfig.main
    and __UI.__L.savedConfig.main.look == true
    or false
__UI.__L.mainJump.rageLookEnabled =
    __UI.__L.savedConfig.main
    and __UI.__L.savedConfig.main.rageLook == true
    or false
__UI.__L.mainJump.reverseLookMode =
    __UI.__L.savedConfig.main
    and __UI.__L.savedConfig.main.reverseLookMode
        == "with"
    and "with"
    or "without"
__UI.__L.mainJump.reverseLookEnabled =
    __UI.__L.savedConfig.main
    and __UI.__L.savedConfig.main.reverseLookEnabled == true
    or false
__UI.__L.mainJump.airTurnEnabled =
    __UI.__L.savedConfig.main
    and __UI.__L.savedConfig.main.airTurn == true
    or false
__UI.__L.mainJump.airTurnSpeed =
    math.clamp(
        tonumber(
            __UI.__L.savedConfig.main
            and __UI.__L.savedConfig.main.airTurnSpeed
        ) or 180,
        30,
        480
    )
__UI.__L.mainConnect = function(connection)
    table.insert(
        __UI.__L.mainJump.connections,
        connection
    )
end
__UI.__L.mainDisconnect = function()
    for _, connection in ipairs(
        __UI.__L.mainJump.connections
    ) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(
        __UI.__L.mainJump.connections
    )
end
function __UI.__L.mainJump.saveConfig()
    __UI.__L.savedConfig.main = {
        jumpDelay = __UI.__L.mainJump.jumpDelay,
        autoJumpMode = __UI.__L.mainJump.autoJumpMode,
        hotkey = __UI.__L.mainJump.hotkeyName,
        hideUIHotkey =
            __UI.__L.mainJump.hideUIHotkeyName,
        look = __UI.__L.mainJump.lookEnabled,
        rageLook = __UI.__L.mainJump.rageLookEnabled,
        airTurn = __UI.__L.mainJump.airTurnEnabled,
        airTurnSpeed = __UI.__L.mainJump.airTurnSpeed,
        smartAirTurn = __UI.__L.mainJump.smartAirTurnEnabled,
        airTurnHotkey = __UI.__L.mainJump.airTurnHotkeyName,
        crouchSpamDelay = __UI.__L.mainJump.crouchSpamDelay,
        crouchSpamHotkey = __UI.__L.mainJump.crouchSpamHotkeyName,
        reverseLookMode = __UI.__L.mainJump.reverseLookMode,
        reverseLookEnabled = __UI.__L.mainJump.reverseLookEnabled,
        benchTrimpHotkey = __UI.__L.mainJump.benchTrimpHotkeyName,
        benchTrimpEnabled = __UI.__L.mainJump.benchTrimpEnabled
    }
    pcall(function()
        saveSavedConfig()
    end)
end


--// Persist only the two toggle states directly into DeadEye_Config.json.
--// This does not rebuild or replace savedConfig.main.
function __UI.__L.mainJump.saveEnabledStates()
    __UI.__L.savedConfig.main =
        __UI.__L.savedConfig.main
        or {}

    __UI.__L.savedConfig.main.rageLook =
        __UI.__L.mainJump.rageLookEnabled == true

    __UI.__L.savedConfig.main.benchTrimpEnabled =
        __UI.__L.mainJump.benchTrimpEnabled == true

    pcall(function()
        saveSavedConfig()
    end)
end

--// =========================================================
--// CAMERA LOOK / JUMP
--// =========================================================
--// LOOK is deliberately tied to the AUTOJUMP sensor cycle.
--// Manual/native jumps never call beginLook().
__UI.__L.LOOK_RENDER_NAME = "DeadEyeMainLook"
__UI.__L.LOOK_INPUT_RADIANS = 0.00575958658
__UI.__L.LOOK_TARGET_PITCH = -math.rad(89)
__UI.__L.LOOK_MAX_INPUT = 12
__UI.__L.LOOK_PITCH_GAIN = 0.32
__UI.__L.LOOK_RESTORE_EPSILON = math.rad(0.75)
__UI.__L.LOOK_MIN_ACTIVE = 0.10
__UI.__L.LOOK_MAX_AFTER_JUMP = 0.30

__UI.__L.mainJump.lookRenderBound = false
__UI.__L.mainJump.lookRestoreDeadline = 0
__UI.__L.mainJump.lookMinActiveDeadline = 0

__UI.__L.mainLookAngleDelta = function(target, current)
    return math.atan2(
        math.sin(target - current),
        math.cos(target - current)
    )
end

function __UI.__L.mainJump.findLookMovementState()
    if type(__UI.__L.mainJump.lookMovementState) == "table" then
        local valid = false
        pcall(function()
            valid =
                typeof(
                    __UI.__L.mainJump.lookMovementState.Movement
                ) == "Vector2"
        end)
        if valid then
            return __UI.__L.mainJump.lookMovementState
        end
    end

    if type(getgc) ~= "function"
        or type(debug) ~= "table"
        or type(debug.getinfo) ~= "function"
        or type(debug.getupvalues) ~= "function"
    then
        return nil
    end

    local objects
    local ok = pcall(function()
        objects = getgc(true)
    end)

    if not ok
        or type(objects) ~= "table"
    then
        return nil
    end

    for _, value in ipairs(objects) do
        if type(value) == "function" then
            local info
            pcall(function()
                info = debug.getinfo(value)
            end)

            local source =
                info
                and tostring(info.source or "")
                or ""

            if string.find(
                source,
                "PlayerModule.CameraModule.ClassicCamera",
                1,
                true
            ) then
                local upvalues
                local upOk = pcall(function()
                    upvalues = debug.getupvalues(value)
                end)

                if upOk
                    and type(upvalues) == "table"
                then
                    local cameraInput = upvalues[4]

                    if type(cameraInput) == "table"
                        and type(cameraInput.getRotation) == "function"
                    then
                        local rotationUpvalues
                        local rotationOk = pcall(function()
                            rotationUpvalues =
                                debug.getupvalues(
                                    cameraInput.getRotation
                                )
                        end)

                        if rotationOk
                            and type(rotationUpvalues) == "table"
                        then
                            local movementState =
                                rotationUpvalues[4]

                            if type(movementState) == "table"
                                and typeof(
                                    movementState.Movement
                                ) == "Vector2"
                            then
                                __UI.__L.mainJump.lookMovementState =
                                    movementState

                                return movementState
                            end
                        end
                    end
                end
            end
        end
    end

    return nil
end

function __UI.__L.mainJump.unbindLookRender()
    pcall(function()
        RunService:UnbindFromRenderStep(
            __UI.__L.LOOK_RENDER_NAME
        )
    end)

    __UI.__L.mainJump.lookRenderBound = false
end

function __UI.__L.mainJump.finishLookRestore()
    __UI.__L.mainJump.lookActive = false
    __UI.__L.mainJump.lookRestoring = false
    __UI.__L.mainJump.lookRestoreDeadline = 0
    __UI.__L.mainJump.lookMinActiveDeadline = 0
    __UI.__L.mainJump.lookAutoJumpCycle = false

    __UI.__L.mainJump.unbindLookRender()
end

function __UI.__L.mainJump.restoreLookNow()
    local camera =
        workspace.CurrentCamera

    if __UI.__L.mainJump.lookSavedPitch
        and camera
    then
        pcall(function()
            local position =
                camera.CFrame.Position

            local _, currentYaw, _ =
                camera.CFrame:ToOrientation()

            camera.CFrame =
                CFrame.new(position)
                * CFrame.fromOrientation(
                    __UI.__L.mainJump.lookSavedPitch,
                    currentYaw,
                    0
                )
        end)
    end

    __UI.__L.mainJump.finishLookRestore()
end

function __UI.__L.mainJump.bindLookRender()
    if __UI.__L.mainJump.lookRenderBound then
        return
    end

    pcall(function()
        RunService:UnbindFromRenderStep(
            __UI.__L.LOOK_RENDER_NAME
        )
    end)

    __UI.__L.mainJump.lookRenderBound = true

    RunService:BindToRenderStep(
        __UI.__L.LOOK_RENDER_NAME,
        Enum.RenderPriority.Camera.Value - 1,
        function()
            if not genv.DEADEYE_MAIN_RUNNING
                or __UI.__L.cleaned
            then
                if __UI.__L.mainJump.lookRestoring then
                    __UI.__L.mainJump.restoreLookNow()
                else
                    __UI.__L.mainJump.unbindLookRender()
                end
                return
            end

            if not __UI.__L.mainJump.lookActive
                and not __UI.__L.mainJump.lookRestoring
            then
                __UI.__L.mainJump.unbindLookRender()
                return
            end

            local camera =
                workspace.CurrentCamera

            if not camera then
                return
            end

            --// LOOK changes pitch only. X is copied from the native
            --// camera input state, so mouse/controller left-right
            --// camera movement stays fully usable.
            local pitch

            local cameraOk = pcall(function()
                pitch = select(
                    1,
                    camera.CFrame:ToOrientation()
                )
            end)

            if not cameraOk
                or not pitch
            then
                return
            end

            local targetPitch =
                __UI.__L.mainJump.lookActive
                and __UI.__L.LOOK_TARGET_PITCH
                or __UI.__L.mainJump.lookSavedPitch

            if not targetPitch then
                return
            end

            local pitchDelta =
                targetPitch - pitch

            if __UI.__L.mainJump.lookRestoring
                and math.abs(pitchDelta)
                    <= __UI.__L.LOOK_RESTORE_EPSILON
            then
                __UI.__L.mainJump.finishLookRestore()
                return
            end

            if __UI.__L.mainJump.lookActive then
                local now =
                    tick()

                if __UI.__L.mainJump.lookRestoreDeadline > 0
                    and now
                        >= __UI.__L.mainJump.lookRestoreDeadline
                then
                    __UI.__L.mainJump.endLook()
                    return
                end

                if __UI.__L.mainJump.lookMinActiveDeadline > 0
                    and now
                        >= __UI.__L.mainJump.lookMinActiveDeadline
                    and not __UI.__L.mainJump.lookScannerSeesSurface()
                then
                    __UI.__L.mainJump.endLook()
                    return
                end
            end

            local movementState =
                __UI.__L.mainJump.findLookMovementState()

            if not movementState then
                return
            end

            local currentMovement =
                Vector2.zero

            pcall(function()
                if typeof(
                    movementState.Movement
                ) == "Vector2"
                then
                    currentMovement =
                        movementState.Movement
                end
            end)

            local moveY =
                math.clamp(
                    -pitchDelta
                        / __UI.__L.LOOK_INPUT_RADIANS
                        * __UI.__L.LOOK_PITCH_GAIN,
                    -__UI.__L.LOOK_MAX_INPUT,
                    __UI.__L.LOOK_MAX_INPUT
                )

            pcall(function()
                movementState.Movement =
                    Vector2.new(
                        currentMovement.X,
                        moveY
                    )
            end)
        end
    )
end

function __UI.__L.mainJump.beginLook()
    if not __UI.__L.mainJump.lookEnabled
        or __UI.__L.mainJump.rageLookEnabled
        or not __UI.__L.mainJump.enabled
        or not __UI.__L.mainJump.lookAutoJumpCycle
        or __UI.__L.cleaned
    then
        return
    end

    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    local pitch
    local ok = pcall(function()
        pitch = select(
            1,
            camera.CFrame:ToOrientation()
        )
    end)

    if not ok
        or not pitch
    then
        return
    end

    if not __UI.__L.mainJump.lookActive
        and not __UI.__L.mainJump.lookRestoring
    then
        __UI.__L.mainJump.lookSavedPitch =
            pitch
    end

    __UI.__L.mainJump.lookActive = true
    __UI.__L.mainJump.lookRestoring = false
    __UI.__L.mainJump.lookRestoreDeadline =
        tick()
        + __UI.__L.LOOK_MAX_AFTER_JUMP
    __UI.__L.mainJump.lookMinActiveDeadline =
        tick()
        + __UI.__L.LOOK_MIN_ACTIVE

    __UI.__L.mainJump.findLookMovementState()
    __UI.__L.mainJump.bindLookRender()
end

function __UI.__L.mainJump.endLook()
    if not __UI.__L.mainJump.lookActive
        and not __UI.__L.mainJump.lookRestoring
    then
        return
    end

    __UI.__L.mainJump.lookActive = false
    __UI.__L.mainJump.lookRestoring = true
    __UI.__L.mainJump.lookRestoreDeadline = 0

    __UI.__L.mainJump.findLookMovementState()
    __UI.__L.mainJump.bindLookRender()
end


__UI.__L.AIR_TURN_RENDER_NAME =
    "DeadEyeMainAirTurn"

__UI.__L.AIR_TURN_MIN_SPEED = 30
__UI.__L.AIR_TURN_MAX_SPEED = 600

__UI.__L.SMART_AIR_TURN_INPUT_RADIANS = 0.00575958658
__UI.__L.SMART_AIR_TURN_MAX_PIXELS = 12
__UI.__L.SMART_AIR_TURN_GAIN = 1

__UI.__L.mainJump.airTurnRenderBound = false

function __UI.__L.mainJump.unbindAirTurnRender()
    if not __UI.__L.mainJump.airTurnRenderBound then
        return
    end

    pcall(function()
        RunService:UnbindFromRenderStep(
            __UI.__L.AIR_TURN_RENDER_NAME
        )
    end)

    __UI.__L.mainJump.airTurnRenderBound = false
end

function __UI.__L.mainJump.bindAirTurnRender()
    if __UI.__L.mainJump.airTurnRenderBound then
        return
    end

    pcall(function()
        RunService:UnbindFromRenderStep(
            __UI.__L.AIR_TURN_RENDER_NAME
        )
    end)

    __UI.__L.mainJump.airTurnRenderBound = true

    RunService:BindToRenderStep(
        __UI.__L.AIR_TURN_RENDER_NAME,
        Enum.RenderPriority.Camera.Value - 2,
        function(deltaTime)
            if not genv.DEADEYE_MAIN_RUNNING
                or __UI.__L.cleaned
                or not __UI.__L.mainJump.airTurnEnabled
                or not __UI.__L.mainJump.enabled
            then
                __UI.__L.mainJump.unbindAirTurnRender()
                return
            end

            local turning =
                0

            local aDown =
                false
            local dDown =
                false

            pcall(function()
                aDown =
                    UserInputService:IsKeyDown(
                        Enum.KeyCode.A
                    )
                dDown =
                    UserInputService:IsKeyDown(
                        Enum.KeyCode.D
                    )
            end)

            if aDown
                and not dDown
            then
                turning = -1
            elseif dDown
                and not aDown
            then
                turning = 1
            end

            if turning == 0 then
                return
            end

            --// Original Air Turn inversion:
            --// compare the camera's horizontal look with the ACTUAL
            --// horizontal movement direction. This is intentionally
            --// not based on HumanoidRootPart / character facing.
            local camera =
                workspace.CurrentCamera

            local horizontalLook
            local horizontalVelocity

            if camera then
                pcall(function()
                    local look =
                        camera.CFrame.LookVector

                    horizontalLook =
                        Vector3.new(
                            look.X,
                            0,
                            look.Z
                        )
                end)
            end

            pcall(function()
                local velocity

                local object =
                    getCharacterObject()

                local registry =
                    object
                    and object.DataRegistry

                if registry then
                    velocity =
                        registry:Get("Velocity")
                end

                if typeof(velocity) == "Vector3" then
                    horizontalVelocity =
                        Vector3.new(
                            velocity.X,
                            0,
                            velocity.Z
                        )
                end
            end)

            if not horizontalVelocity
                or horizontalVelocity.Magnitude
                    < 0.001
            then
                pcall(function()
                    local velocity =
                        __UI.__L.mainJump.root
                        and __UI.__L.mainJump.root.AssemblyLinearVelocity

                    if typeof(velocity) == "Vector3" then
                        horizontalVelocity =
                            Vector3.new(
                                velocity.X,
                                0,
                                velocity.Z
                            )
                    end
                end)
            end

            if horizontalLook
                and horizontalVelocity
                and horizontalLook.Magnitude
                    > 0.001
                and horizontalVelocity.Magnitude
                    > 0.001
            then
                horizontalLook =
                    horizontalLook.Unit

                horizontalVelocity =
                    horizontalVelocity.Unit

                if horizontalLook:Dot(
                    horizontalVelocity
                ) < 0
                then
                    turning =
                        -turning
                end
            end

            local movementState =
                __UI.__L.mainJump.findLookMovementState()

            if not movementState then
                return
            end

            local currentMovement =
                Vector2.zero

            pcall(function()
                if typeof(
                    movementState.Movement
                ) == "Vector2"
                then
                    currentMovement =
                        movementState.Movement
                end
            end)

            local dt =
                tonumber(deltaTime)
                or 1 / 60

            dt =
                math.clamp(
                    dt,
                    1 / 240,
                    1 / 30
                )

            --// SMART AIR TURN:
            --// Camera follows the actual horizontal DataRegistry Velocity.
            --// Manual mouse movement remains intact; only the correction
            --// is added to the native CameraInput movement state.
            if __UI.__L.mainJump.smartAirTurnEnabled then
                local object =
                    getCharacterObject()

                local registry =
                    object
                    and object.DataRegistry

                local horizontalVelocity

                if registry then
                    pcall(function()
                        local velocity =
                            registry:Get("Velocity")

                        if typeof(velocity) == "Vector3" then
                            horizontalVelocity =
                                Vector3.new(
                                    velocity.X,
                                    0,
                                    velocity.Z
                                )
                        end
                    end)
                end

                local humanoid =
                    __UI.__L.mainJump.humanoid

                local airborne =
                    true

                if humanoid
                    and humanoid.Parent
                then
                    local state =
                        humanoid:GetState()

                    airborne =
                        state
                            == Enum.HumanoidStateType.Jumping
                        or state
                            == Enum.HumanoidStateType.Freefall
                        or state
                            == Enum.HumanoidStateType.FallingDown
                end

                if registry then
                    pcall(function()
                        local grounded =
                            registry:Get("Grounded")

                        if grounded == false then
                            airborne = true
                        elseif grounded == true
                            and (
                                not humanoid
                                or humanoid:GetState()
                                    ~= Enum.HumanoidStateType.Jumping
                            )
                        then
                            airborne = false
                        end
                    end)
                end

                if not airborne
                    or not horizontalVelocity
                    or horizontalVelocity.Magnitude
                        < 0.001
                then
                    return
                end

                local camera =
                    workspace.CurrentCamera

                if not camera then
                    return
                end

                local look =
                    camera.CFrame.LookVector

                local cameraFlat =
                    Vector3.new(
                        look.X,
                        0,
                        look.Z
                    )

                if cameraFlat.Magnitude < 0.001 then
                    return
                end

                local velocityFlat =
                    horizontalVelocity.Unit

                cameraFlat =
                    cameraFlat.Unit

                local velocityYaw =
                    math.atan2(
                        -velocityFlat.X,
                        -velocityFlat.Z
                    )

                local cameraYaw =
                    math.atan2(
                        -cameraFlat.X,
                        -cameraFlat.Z
                    )

                local error =
                    math.atan2(
                        math.sin(
                            velocityYaw - cameraYaw
                        ),
                        math.cos(
                            velocityYaw - cameraYaw
                        )
                    )

                local correctionPixels =
                    error
                    * __UI.__L.SMART_AIR_TURN_GAIN
                    / __UI.__L.SMART_AIR_TURN_INPUT_RADIANS
                    * -1

                --// Use the exact same backward-inversion rule as
                --// the normal Air Turn: camera vs actual velocity.
                if cameraFlat:Dot(
                    velocityFlat
                ) < 0
                then
                    correctionPixels =
                        -correctionPixels
                end

                correctionPixels =
                    math.clamp(
                        correctionPixels,
                        -__UI.__L.SMART_AIR_TURN_MAX_PIXELS,
                        __UI.__L.SMART_AIR_TURN_MAX_PIXELS
                    )

                pcall(function()
                    movementState.Movement =
                        Vector2.new(
                            currentMovement.X
                                + correctionPixels,
                            currentMovement.Y
                        )
                end)

                return
            end

            --// NORMAL AIR TURN:
            --// Fixed turn rate from the TURN SPEED slider.
            local radiansPerFrame =
                math.rad(
                    __UI.__L.mainJump.airTurnSpeed
                )
                * dt

            local moveX =
                radiansPerFrame
                / __UI.__L.LOOK_INPUT_RADIANS
                * turning

            pcall(function()
                movementState.Movement =
                    Vector2.new(
                        moveX,
                        currentMovement.Y
                    )
            end)
        end
    )
end

function __UI.__L.mainJump.setAirTurnEnabled(state)
    __UI.__L.mainJump.airTurnEnabled =
        state and true or false

    if __UI.__L.mainJump.airTurnEnabled
        and __UI.__L.mainJump.enabled
    then
        __UI.__L.mainJump.findLookMovementState()
        __UI.__L.mainJump.bindAirTurnRender()
    else
        __UI.__L.mainJump.unbindAirTurnRender()
    end

    __UI.__L.mainJump.saveConfig()
    __UI.__L.mainJump.update()
end

function __UI.__L.mainJump.setSmartAirTurnEnabled(state)
    __UI.__L.mainJump.smartAirTurnEnabled =
        state and true or false

    if __UI.__L.mainJump.smartAirTurnEnabled
        and __UI.__L.mainJump.airTurnEnabled
        and __UI.__L.mainJump.enabled
    then
        __UI.__L.mainJump.findLookMovementState()
        __UI.__L.mainJump.bindAirTurnRender()
    end

    __UI.__L.mainJump.saveConfig()
    __UI.__L.mainJump.update()
end

function __UI.__L.mainJump.setAirTurnSpeed(value, persist)
    local number =
        tonumber(value)

    if not number then
        number =
            __UI.__L.mainJump.airTurnSpeed
    end

    __UI.__L.mainJump.airTurnSpeed =
        math.clamp(
            math.floor(
                number
                + 0.5
            ),
            __UI.__L.AIR_TURN_MIN_SPEED,
            __UI.__L.AIR_TURN_MAX_SPEED
        )

    if __UI.__L.mainJump.airTurnSpeedValue then
        __UI.__L.mainJump.airTurnSpeedValue.Text =
            tostring(
                __UI.__L.mainJump.airTurnSpeed
            )
            .. "°/s"
    end

    if __UI.__L.mainJump.airTurnSliderFill
        and __UI.__L.mainJump.airTurnSliderTrack
    then
        local alpha =
            (
                __UI.__L.mainJump.airTurnSpeed
                - __UI.__L.AIR_TURN_MIN_SPEED
            )
            / (
                __UI.__L.AIR_TURN_MAX_SPEED
                - __UI.__L.AIR_TURN_MIN_SPEED
            )

        __UI.__L.mainJump.airTurnSliderFill.Size =
            UDim2.new(
                alpha,
                0,
                1,
                0
            )
    end

    if __UI.__L.mainJump.airTurnSliderKnob
        and __UI.__L.mainJump.airTurnSliderTrack
    then
        local alpha =
            (
                __UI.__L.mainJump.airTurnSpeed
                - __UI.__L.AIR_TURN_MIN_SPEED
            )
            / (
                __UI.__L.AIR_TURN_MAX_SPEED
                - __UI.__L.AIR_TURN_MIN_SPEED
            )

        __UI.__L.mainJump.airTurnSliderKnob.Position =
            UDim2.new(
                alpha,
                -5,
                0.5,
                -5
            )
    end

    if persist then
        __UI.__L.mainJump.saveConfig()
    end
end

--// =========================================================
--// =========================================================
--// RAGE LOOK
--//
--// RAGE LOOK keeps the real camera and HumanoidRootPart
--// physically untouched while making the game's own LookY
--// calculation return a forced downward pitch.
--//
--// Replication path:
--//     Movement.Terms.LookY.CalculateFunction()
--//     -> DataRegistry:Set("LookY", value)
--//     -> Serializer / ToSend
--//     -> UpdateCharacterDataRegistryUnreliable
--//     -> other clients
--//
--// Physical movement path:
--//     DataRegistry:Get("LookCFrame")
--//     -> fake downward-pitched CFrame
--//
--// Visual path:
--//     LookY -> Joints.RegistryTermUpdated()
--//           -> InterpolateLimbs
--//           -> Motor6D.C1
--//
--// NEVER modifies:
--//     Camera.CFrame
--//     HumanoidRootPart.CFrame
--//     RootPartOrienter
--//     Head.Transform
--//     Head.C0
--// =========================================================

__UI.__L.RAGE_LOOK_PITCH =
    -math.rad(70)

-- The game quantizes LookY to 1/40 radian:
-- floor(angle * 40 + 0.5) / 40
__UI.__L.RAGE_LOOK_Y =
    math.floor(
        __UI.__L.RAGE_LOOK_PITCH * 40
        + 0.5
    ) / 40

__UI.__L.mainJump.rageLookHookInstalled =
    false

__UI.__L.mainJump.rageLookDataRegistryGet =
    nil

__UI.__L.mainJump.rageLookOriginalDataRegistryGet =
    nil

__UI.__L.mainJump.rageLookLookYEntry =
    nil

__UI.__L.mainJump.rageLookOriginalLookYCalculate =
    nil

__UI.__L.mainJump.rageLookTerms =
    nil

__UI.__L.mainJump.rageLookMode =
    nil

function __UI.__L.mainJump.getRageLookFakeCFrame(
    realCFrame
)

    if typeof(realCFrame) ~= "CFrame" then
        return nil
    end

    local lookVector =
        realCFrame.LookVector

    local flatLook =
        Vector3.new(
            lookVector.X,
            0,
            lookVector.Z
        )

    if flatLook.Magnitude < 0.000001 then
        flatLook =
            Vector3.new(
                0,
                0,
                -1
            )
    else
        flatLook =
            flatLook.Unit
    end

    local baseCFrame =
        CFrame.lookAt(
            realCFrame.Position,
            realCFrame.Position + flatLook,
            Vector3.yAxis
        )

    return
        baseCFrame
        * CFrame.Angles(
            __UI.__L.RAGE_LOOK_PITCH,
            0,
            0
        )
end

function __UI.__L.mainJump.findRageLookDataRegistryGet()

    local object =
        getCharacterObject()

    if not object
        or not object.DataRegistry
    then
        return nil
    end

    local getFunction

    pcall(function()
        getFunction =
            object.DataRegistry.Get
    end)

    if type(getFunction) ~= "function" then
        return nil
    end

    return getFunction
end

function __UI.__L.mainJump.findRageLookTerms()

    local movementModule =
        ReplicatedStorage
            :WaitForChild("Objects")
            :WaitForChild("Game")
            :WaitForChild("Character")
            :WaitForChild("Client")
            :WaitForChild("Movement")

    local termsModule =
        movementModule:WaitForChild(
            "Terms"
        )

    local terms

    local success =
        pcall(function()
            terms =
                require(
                    termsModule
                )
        end)

    if not success
        or type(terms) ~= "table"
    then
        return nil, nil
    end

    for _, entry in ipairs(
        terms.Children or {}
    ) do
        if entry.Term == "LookY" then
            return terms, entry
        end
    end

    return terms, nil
end

function __UI.__L.mainJump.installRageLookHook()

    if __UI.__L.mainJump.rageLookHookInstalled then
        return true
    end

    local terms, lookYEntry =
        __UI.__L.mainJump.findRageLookTerms()

    if not terms
        or not lookYEntry
        or type(lookYEntry.CalculateFunction)
            ~= "function"
    then

        warn(
            "[DeadEye] Rage Look: Movement.Terms LookY not found"
        )

        return false
    end

    local registryGet =
        __UI.__L.mainJump.findRageLookDataRegistryGet()

    if type(registryGet) ~= "function" then

        warn(
            "[DeadEye] Rage Look: DataRegistry.Get not found"
        )

        return false
    end

    if type(hookfunction) ~= "function" then

        warn(
            "[DeadEye] Rage Look: hookfunction unavailable"
        )

        return false
    end

    local originalGet
    local hookOK =
        pcall(function()

            originalGet =
                hookfunction(
                    registryGet,
                    function(
                        self,
                        key,
                        ...
                    )

                        local results =
                            table.pack(
                                originalGet(
                                    self,
                                    key,
                                    ...
                                )
                            )

                        if __UI.__L.mainJump.rageLookEnabled
                            and not __UI.__L.cleaned
                            and key == "LookCFrame"
                            and typeof(results[1]) == "CFrame"
                        then

                            local fakeCFrame =
                                __UI.__L.mainJump.getRageLookFakeCFrame(
                                    results[1]
                                )

                            if fakeCFrame then
                                results[1] =
                                    fakeCFrame
                            end
                        end

                        return table.unpack(
                            results,
                            1,
                            results.n
                        )
                    end
                )

        end)

    if not hookOK
        or type(originalGet) ~= "function"
    then

        warn(
            "[DeadEye] Rage Look: failed to hook DataRegistry.Get"
        )

        return false
    end

    __UI.__L.mainJump.rageLookDataRegistryGet =
        registryGet

    __UI.__L.mainJump.rageLookOriginalDataRegistryGet =
        originalGet

    __UI.__L.mainJump.rageLookTerms =
        terms

    __UI.__L.mainJump.rageLookLookYEntry =
        lookYEntry

    __UI.__L.mainJump.rageLookOriginalLookYCalculate =
        lookYEntry.CalculateFunction

    -- The game's Movement.UpdateTerms() will now call this
    -- function itself and then DataRegistry:Set("LookY", ...).
    lookYEntry.CalculateFunction =
        function(_)
            return __UI.__L.RAGE_LOOK_Y
        end

    __UI.__L.mainJump.rageLookHookInstalled =
        true

    __UI.__L.mainJump.rageLookMode =
        "Movement Terms LookY + DataRegistry LookCFrame"

    return true
end

function __UI.__L.mainJump.uninstallRageLookHook()

    local terms =
        __UI.__L.mainJump.rageLookTerms

    local lookYEntry =
        __UI.__L.mainJump.rageLookLookYEntry

    local originalLookYCalculate =
        __UI.__L.mainJump.rageLookOriginalLookYCalculate

    if lookYEntry
        and type(originalLookYCalculate)
            == "function"
    then

        pcall(function()
            lookYEntry.CalculateFunction =
                originalLookYCalculate
        end)
    end

    local registryGet =
        __UI.__L.mainJump.rageLookDataRegistryGet

    local originalGet =
        __UI.__L.mainJump.rageLookOriginalDataRegistryGet

    if registryGet
        and originalGet
        and type(hookfunction) == "function"
    then

        pcall(function()
            hookfunction(
                registryGet,
                originalGet
            )
        end)
    end

    __UI.__L.mainJump.rageLookHookInstalled =
        false

    __UI.__L.mainJump.rageLookDataRegistryGet =
        nil

    __UI.__L.mainJump.rageLookOriginalDataRegistryGet =
        nil

    __UI.__L.mainJump.rageLookLookYEntry =
        nil

    __UI.__L.mainJump.rageLookOriginalLookYCalculate =
        nil

    __UI.__L.mainJump.rageLookTerms =
        nil

    __UI.__L.mainJump.rageLookMode =
        nil
end

function __UI.__L.mainJump.setRageLookEnabled(
    state,
    persist
)

    state =
        state and true or false

    if state then

        if __UI.__L.mainJump.rageLookEnabled then

            __UI.__L.mainJump.saveConfig()
            __UI.__L.mainJump.update()

            return true
        end

        --// Normal visual LOOK must not fight Rage Look.
        if __UI.__L.mainJump.lookActive
            or __UI.__L.mainJump.lookRestoring
        then

            __UI.__L.mainJump.endLook()

        end

        local hooked =
            __UI.__L.mainJump.installRageLookHook()

        if not hooked then

            __UI.__L.mainJump.rageLookEnabled =
                false

            __UI.__L.mainJump.update()

            return false
        end

        __UI.__L.mainJump.rageLookEnabled =
            true

    else

        __UI.__L.mainJump.rageLookEnabled =
            false

        __UI.__L.mainJump.uninstallRageLookHook()

    end

    if __UI.__L.mainJump.rageLookMode then

        print(
            "[DeadEye] Rage Look mode =",
            __UI.__L.mainJump.rageLookMode
        )

    end

    if persist ~= false then
        __UI.__L.mainJump.saveConfig()
        __UI.__L.mainJump.saveEnabledStates()
    end

    __UI.__L.mainJump.update()

    return true
end

function __UI.__L.mainJump.setLookEnabled(state)
    __UI.__L.mainJump.lookEnabled =
        state and true or false

    if not __UI.__L.mainJump.lookEnabled then
        __UI.__L.mainJump.endLook()
    end

    __UI.__L.mainJump.saveConfig()
    __UI.__L.mainJump.update()
end

--// =========================================================
--// REVERSE GAME LOOK
--//
--// Integrated version of the confirmed standalone v1.04 test.
--//
--// WITH:
--//   Reverse Look is active only while CROUCH SPAM is active.
--//
--// WITHOUT / SOLO:
--//   Reverse Look has its own ON/OFF button.
--//
--// REVERSE LOOK:
--//   DataRegistry.Set("LookCFrame", value)
--//   -> yaw +180°
--//
--// A/D COMPENSATION:
--//   DataRegistry.Get("MoveDirection")
--//   -> X *= -1
--//
--// IMPORTANT:
--//   CameraInput is NOT modified.
--//   workspace.CurrentCamera.CFrame is NOT modified.
--//   HumanoidRootPart.CFrame is NOT modified directly.
--//   LookY is NOT modified.
--// =========================================================

__UI.__L.REVERSE_LOOK_YAW =
    math.rad(180)

__UI.__L.ReverseLookTweenService =
    game:GetService("TweenService")

__UI.__L.reverseLookUITweens = {}

__UI.__L.reverseLookTween = function(
    object,
    properties
)
    if not object then
        return
    end

    local oldTween =
        __UI.__L.reverseLookUITweens[object]

    if oldTween then
        pcall(function()
            oldTween:Cancel()
        end)
    end

    local tween

    local success =
        pcall(function()
            tween =
                __UI.__L.ReverseLookTweenService:Create(
                    object,
                    TweenInfo.new(
                        0.18,
                        Enum.EasingStyle.Quart,
                        Enum.EasingDirection.Out
                    ),
                    properties
                )
        end)

    if not success
        or not tween
    then
        return
    end

    __UI.__L.reverseLookUITweens[object] =
        tween

    tween:Play()
end

function __UI.__L.mainJump.isReverseLookActive()

    if __UI.__L.cleaned then
        return false
    end

    if __UI.__L.mainJump.reverseLookMode
        == "with"
    then
        return __UI.__L.mainJump.crouchSpamEnabled == true
    end

    return __UI.__L.mainJump.reverseLookEnabled == true
end

function __UI.__L.mainJump.getReverseLookCFrame(
    realCFrame
)

    if typeof(realCFrame) ~= "CFrame" then
        return nil
    end

    local lookVector =
        realCFrame.LookVector

    local flatLook =
        Vector3.new(
            lookVector.X,
            0,
            lookVector.Z
        )

    if flatLook.Magnitude < 0.000001 then
        return realCFrame
    end

    flatLook =
        flatLook.Unit

    local pitch =
        math.asin(
            math.clamp(
                lookVector.Y,
                -1,
                1
            )
        )

    local baseCFrame =
        CFrame.lookAt(
            realCFrame.Position,
            realCFrame.Position + flatLook,
            Vector3.yAxis
        )

    return
        baseCFrame
        * CFrame.Angles(
            0,
            __UI.__L.REVERSE_LOOK_YAW,
            0
        )
        * CFrame.Angles(
            pitch,
            0,
            0
        )
end

function __UI.__L.mainJump.findReverseLookRegistry()

    local object =
        getCharacterObject()

    if not object
        or not object.DataRegistry
    then
        return nil
    end

    return object.DataRegistry
end

function __UI.__L.mainJump.installReverseLookHooks()

    if __UI.__L.mainJump.reverseLookHookInstalled then
        return true
    end

    if type(hookfunction) ~= "function" then
        warn(
            "[DeadEye] Reverse Look: hookfunction unavailable"
        )
        return false
    end

    local registry =
        __UI.__L.mainJump.findReverseLookRegistry()

    if not registry then
        warn(
            "[DeadEye] Reverse Look: DataRegistry not found"
        )
        return false
    end

    local setTarget
    local getTarget

    pcall(function()
        setTarget =
            registry.Set

        getTarget =
            registry.Get
    end)

    if type(setTarget) ~= "function" then
        warn(
            "[DeadEye] Reverse Look: DataRegistry.Set not found"
        )
        return false
    end

    if type(getTarget) ~= "function" then
        warn(
            "[DeadEye] Reverse Look: DataRegistry.Get not found"
        )
        return false
    end

    local savedSet
    local savedGet

    local setSuccess =
        pcall(function()

            savedSet =
                hookfunction(
                    setTarget,
                    function(
                        self,
                        key,
                        value,
                        ...
                    )

                        if key == "LookCFrame"
                            and typeof(value)
                                == "CFrame"
                            and __UI.__L.mainJump.isReverseLookActive()
                        then

                            local fakeCFrame =
                                __UI.__L.mainJump.getReverseLookCFrame(
                                    value
                                )

                            if fakeCFrame then
                                return savedSet(
                                    self,
                                    key,
                                    fakeCFrame,
                                    ...
                                )
                            end
                        end

                        return savedSet(
                            self,
                            key,
                            value,
                            ...
                        )
                    end
                )

        end)

    if not setSuccess
        or type(savedSet) ~= "function"
    then

        warn(
            "[DeadEye] Reverse Look: failed to hook DataRegistry.Set"
        )

        return false
    end

    __UI.__L.mainJump.reverseLookSetFunction =
        setTarget

    __UI.__L.mainJump.reverseLookOriginalSet =
        savedSet

    local getSuccess =
        pcall(function()

            savedGet =
                hookfunction(
                    getTarget,
                    function(
                        self,
                        key,
                        ...
                    )

                        local results =
                            table.pack(
                                savedGet(
                                    self,
                                    key,
                                    ...
                                )
                            )

                        if key == "MoveDirection"
                            and typeof(results[1])
                                == "Vector3"
                            and __UI.__L.mainJump.isReverseLookActive()
                        then

                            local value =
                                results[1]

                            results[1] =
                                Vector3.new(
                                    -value.X,
                                    value.Y,
                                    value.Z
                                )

                        end

                        return table.unpack(
                            results,
                            1,
                            results.n
                        )
                    end
                )

        end)

    if not getSuccess
        or type(savedGet) ~= "function"
    then

        pcall(function()
            hookfunction(
                setTarget,
                savedSet
            )
        end)

        __UI.__L.mainJump.reverseLookSetFunction =
            nil

        __UI.__L.mainJump.reverseLookOriginalSet =
            nil

        warn(
            "[DeadEye] Reverse Look: failed to hook DataRegistry.Get"
        )

        return false
    end

    __UI.__L.mainJump.reverseLookGetFunction =
        getTarget

    __UI.__L.mainJump.reverseLookOriginalGet =
        savedGet

    __UI.__L.mainJump.reverseLookHookInstalled =
        true

    return true
end

function __UI.__L.mainJump.uninstallReverseLookHooks()

    local setTarget =
        __UI.__L.mainJump.reverseLookSetFunction

    local savedSet =
        __UI.__L.mainJump.reverseLookOriginalSet

    local getTarget =
        __UI.__L.mainJump.reverseLookGetFunction

    local savedGet =
        __UI.__L.mainJump.reverseLookOriginalGet

    if setTarget
        and savedSet
        and type(hookfunction) == "function"
    then
        pcall(function()
            hookfunction(
                setTarget,
                savedSet
            )
        end)
    end

    if getTarget
        and savedGet
        and type(hookfunction) == "function"
    then
        pcall(function()
            hookfunction(
                getTarget,
                savedGet
            )
        end)
    end

    __UI.__L.mainJump.reverseLookSetFunction =
        nil

    __UI.__L.mainJump.reverseLookOriginalSet =
        nil

    __UI.__L.mainJump.reverseLookGetFunction =
        nil

    __UI.__L.mainJump.reverseLookOriginalGet =
        nil

    __UI.__L.mainJump.reverseLookHookInstalled =
        false
end

function __UI.__L.mainJump.setReverseLookEnabled(
    state,
    persist
)

    __UI.__L.mainJump.reverseLookEnabled =
        state and true or false

    if not __UI.__L.mainJump.reverseLookHookInstalled then
        __UI.__L.mainJump.installReverseLookHooks()
    end

    if persist ~= false then
        __UI.__L.mainJump.saveConfig()
    end

    __UI.__L.mainJump.update()
end

function __UI.__L.mainJump.setReverseLookMode(
    mode
)

    if mode ~= "with"
        and mode ~= "without"
    then
        mode = "without"
    end

    __UI.__L.mainJump.reverseLookMode =
        mode

    if not __UI.__L.mainJump.reverseLookHookInstalled then
        __UI.__L.mainJump.installReverseLookHooks()
    end

    __UI.__L.mainJump.saveConfig()
    __UI.__L.mainJump.update()
end

function __UI.__L.mainJump.updateReverseLookUI(
    animated
)

    local mode =
        __UI.__L.mainJump.reverseLookMode
        == "with"
        and "with"
        or "without"

    if __UI.__L.mainJump.reverseLookModeButton
        and __UI.__L.mainJump.reverseLookModeKnob
        and __UI.__L.mainJump.reverseLookModeWithLabel
        and __UI.__L.mainJump.reverseLookModeSoloLabel
    then

        local knobPosition

        if mode == "with" then
            knobPosition =
                UDim2.new(
                    0,
                    2,
                    0.5,
                    -12
                )
        else
            knobPosition =
                UDim2.new(
                    0,
                    36,
                    0.5,
                    -12
                )
        end

        if animated then
            __UI.__L.reverseLookTween(
                __UI.__L.mainJump.reverseLookModeKnob,
                {
                    Position = knobPosition
                }
            )

            __UI.__L.reverseLookTween(
                __UI.__L.mainJump.reverseLookModeWithLabel,
                {
                    TextColor3 =
                        mode == "with"
                        and Color3.fromRGB(
                            255,
                            255,
                            255
                        )
                        or Color3.fromRGB(
                            145,
                            145,
                            145
                        )
                }
            )

            __UI.__L.reverseLookTween(
                __UI.__L.mainJump.reverseLookModeSoloLabel,
                {
                    TextColor3 =
                        mode == "without"
                        and Color3.fromRGB(
                            255,
                            255,
                            255
                        )
                        or Color3.fromRGB(
                            145,
                            145,
                            145
                        )
                }
            )

            __UI.__L.reverseLookTween(
                __UI.__L.mainJump.reverseLookModeButton,
                {
                    BackgroundColor3 =
                        mode == "with"
                        and Color3.fromRGB(
                            34,
                            34,
                            34
                        )
                        or Color3.fromRGB(
                            34,
                            34,
                            34
                        )
                }
            )
        else
            __UI.__L.mainJump.reverseLookModeKnob.Position =
                knobPosition

            __UI.__L.mainJump.reverseLookModeWithLabel.TextColor3 =
                mode == "with"
                and Color3.fromRGB(
                    255,
                    255,
                    255
                )
                or Color3.fromRGB(
                    145,
                    145,
                    145
                )

            __UI.__L.mainJump.reverseLookModeSoloLabel.TextColor3 =
                mode == "without"
                and Color3.fromRGB(
                    255,
                    255,
                    255
                )
                or Color3.fromRGB(
                    145,
                    145,
                    145
                )
        end

    end

    if __UI.__L.mainJump.reverseLookToggle then

        if mode == "with" then

            __UI.__L.mainJump.reverseLookToggle.Text =
                "AUTO"

            __UI.__L.mainJump.reverseLookToggle.Active =
                false

            if animated then
                __UI.__L.reverseLookTween(
                    __UI.__L.mainJump.reverseLookToggle,
                    {
                        BackgroundColor3 =
                            Color3.fromRGB(
                                47,
                                52,
                                61
                            )
                    }
                )
            else
                __UI.__L.mainJump.reverseLookToggle.BackgroundColor3 =
                    Color3.fromRGB(
                        47,
                        52,
                        61
                    )
            end

        else

            __UI.__L.mainJump.reverseLookToggle.Active =
                true

            __UI.__L.mainJump.reverseLookToggle.Text =
                __UI.__L.mainJump.reverseLookEnabled
                and "ON"
                or "OFF"

            local targetColor =
                __UI.__L.mainJump.reverseLookEnabled
                and Color3.fromRGB(
                    68,
                    74,
                    84
                )
                or Color3.fromRGB(
                    47,
                    52,
                    61
                )

            if animated then
                __UI.__L.reverseLookTween(
                    __UI.__L.mainJump.reverseLookToggle,
                    {
                        BackgroundColor3 =
                            targetColor
                    }
                )
            else
                __UI.__L.mainJump.reverseLookToggle.BackgroundColor3 =
                    targetColor
            end

        end

    end
end

function __UI.__L.mainJump.syncAutoJumpModePickerVisual()
    local source =
        __UI.__L.mainJump.autoJumpModeButton

    if not source
        or not __UI.__L.ScreenGui
    then
        return
    end

    for _, object in ipairs(
        __UI.__L.ScreenGui:GetDescendants()
    ) do
        if object:IsA("TextButton")
            and string.sub(
                tostring(object.Name),
                1,
                13
            ) == "AutoJumpMode_"
        then
            pcall(function()
                object.BackgroundColor3 =
                    source.BackgroundColor3

                object.BackgroundTransparency =
                    source.BackgroundTransparency

                object.BorderSizePixel =
                    source.BorderSizePixel

                object.AutoButtonColor =
                    source.AutoButtonColor

                object.TextSize =
                    source.TextSize

                object.Font =
                    source.Font

                object.TextColor3 =
                    source.TextColor3

                object.TextStrokeColor3 =
                    source.TextStrokeColor3

                object.TextStrokeTransparency =
                    source.TextStrokeTransparency

                object.Size =
                    source.Size
            end)
        end
    end
end

function __UI.__L.mainJump.update()
    if not __UI.__L.mainJump.toggle then
        return
    end
    if __UI.__L.mainJump.enabled then
        __UI.__L.mainJump.toggle.Text =
            "ON"
        __UI.__L.mainJump.toggle.BackgroundColor3 =
            Color3.fromRGB(
                68,
                74,
                84
            )
    else
        __UI.__L.mainJump.toggle.Text =
            "OFF"
        __UI.__L.mainJump.toggle.BackgroundColor3 =
            Color3.fromRGB(
                47,
                52,
                61
            )
    end

    if __UI.__L.mainJump.autoJumpModeButton then
        __UI.__L.mainJump.autoJumpModeButton.Text =
            __UI.__L.mainJump.autoJumpMode == "legit"
            and "LEGIT"
            or "RAGE"

        --// Mode selection changes the label only.
        --// The button itself keeps the same normal DeadEye color.
        __UI.__L.mainJump.autoJumpModeButton.BackgroundColor3 =
            Color3.fromRGB(
                47,
                52,
                61
            )
    end

    if __UI.__L.mainJump.lookToggle then
        if __UI.__L.mainJump.lookEnabled then
            __UI.__L.mainJump.lookToggle.Text =
                "ON"
            __UI.__L.mainJump.lookToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            __UI.__L.mainJump.lookToggle.Text =
                "OFF"
            __UI.__L.mainJump.lookToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end

    if __UI.__L.mainJump.rageLookToggle then
        if __UI.__L.mainJump.rageLookEnabled then
            __UI.__L.mainJump.rageLookToggle.Text =
                "ON"
            __UI.__L.mainJump.rageLookToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            __UI.__L.mainJump.rageLookToggle.Text =
                "OFF"
            __UI.__L.mainJump.rageLookToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end

    if __UI.__L.mainJump.smartAirTurnToggle then
        if __UI.__L.mainJump.smartAirTurnEnabled then
            __UI.__L.mainJump.smartAirTurnToggle.Text =
                "ON"
            __UI.__L.mainJump.smartAirTurnToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            __UI.__L.mainJump.smartAirTurnToggle.Text =
                "OFF"
            __UI.__L.mainJump.smartAirTurnToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end

    if __UI.__L.mainJump.crouchSpamToggle then
        if __UI.__L.mainJump.crouchSpamEnabled then
            __UI.__L.mainJump.crouchSpamToggle.Text =
                "ON"
            __UI.__L.mainJump.crouchSpamToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            __UI.__L.mainJump.crouchSpamToggle.Text =
                "OFF"
            __UI.__L.mainJump.crouchSpamToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end

    __UI.__L.mainJump.updateReverseLookUI(
        true
    )

    if __UI.__L.mainJump.benchTrimpToggle then
        if __UI.__L.mainJump.benchTrimpEnabled then
            __UI.__L.mainJump.benchTrimpToggle.Text =
                "ON"
            __UI.__L.mainJump.benchTrimpToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            __UI.__L.mainJump.benchTrimpToggle.Text =
                "OFF"
            __UI.__L.mainJump.benchTrimpToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end

    pcall(function()
        __UI.__L.mainJump.syncAutoJumpModePickerVisual()
    end)

    if __UI.__L.mainJump.airTurnToggle then
        if __UI.__L.mainJump.airTurnEnabled then
            __UI.__L.mainJump.airTurnToggle.Text =
                "ON"
            __UI.__L.mainJump.airTurnToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            __UI.__L.mainJump.airTurnToggle.Text =
                "OFF"
            __UI.__L.mainJump.airTurnToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end
end
function __UI.__L.mainJump.setEnabled(state)
    __UI.__L.mainJump.enabled =
        state and true or false

    if __UI.__L.mainJump.enabled then
        __UI.__L.mainJump.needsInputRearm = false

        if __UI.__L.mainJump.airTurnEnabled then
            __UI.__L.mainJump.findLookMovementState()
            __UI.__L.mainJump.bindAirTurnRender()
        end

        if __UI.__L.mainJump.character
            and __UI.__L.mainJump.humanoid
            and __UI.__L.mainJump.humanoid.Parent
        then
            if __UI.__L.mainJump.autoJumpMode == "legit" then
                __UI.__L.mainJump.destroySensors()
                __UI.__L.mainJump.bindLegitJumpLoop()
            else
                pcall(function()
                    __UI.__L.mainJump.createSensors(
                        __UI.__L.mainJump.character
                    )
                end)

                task.defer(function()
                    if not genv.DEADEYE_MAIN_RUNNING
                        or not __UI.__L.mainJump.enabled
                        or __UI.__L.mainJump.autoJumpMode ~= "rage"
                        or not __UI.__L.mainJump.humanoid
                        or not __UI.__L.mainJump.humanoid.Parent
                    then
                        return
                    end

                    if __UI.__L.mainJump.canJump() then
                        __UI.__L.mainJump.lookAutoJumpCycle = true
                        __UI.__L.mainJump.jump()
                    end
                end)
            end
        end
    else
        __UI.__L.mainJump.needsInputRearm = true
        __UI.__L.mainJump.destroySensors()

        __UI.__L.mainJump.lookAutoJumpCycle = false
        __UI.__L.mainJump.lookTriggeredThisAir = false
        __UI.__L.mainJump.manualJumpActive = false
        __UI.__L.mainJump.unbindAirTurnRender()

        if __UI.__L.mainJump.lookWatcherConnection then
            pcall(function()
                __UI.__L.mainJump.lookWatcherConnection:Disconnect()
            end)
            __UI.__L.mainJump.lookWatcherConnection = nil
        end

        __UI.__L.mainJump.endLook()

        if __UI.__L.mainJump.humanoid
            and __UI.__L.mainJump.humanoid.Parent
        then
            pcall(function()
                __UI.__L.mainJump.humanoid.Jump = false
            end)

            task.defer(function()
                if __UI.__L.mainJump.humanoid
                    and __UI.__L.mainJump.humanoid.Parent
                then
                    pcall(function()
                        __UI.__L.mainJump.humanoid.Jump = false
                    end)
                end
            end)
        end
    end

    __UI.__L.mainJump.update()
end

function __UI.__L.mainJump.setAutoJumpMode(mode, persist)
    mode =
        tostring(
            mode or ""
        ):lower()

    if mode ~= "legit"
        and mode ~= "rage"
    then
        mode = "rage"
    end

    __UI.__L.mainJump.autoJumpMode = mode

    if __UI.__L.mainJump.enabled
        and __UI.__L.mainJump.character
        and __UI.__L.mainJump.humanoid
        and __UI.__L.mainJump.humanoid.Parent
    then
        if mode == "legit" then
            __UI.__L.mainJump.destroySensors()
            __UI.__L.mainJump.lookAutoJumpCycle = false
            __UI.__L.mainJump.lookTriggeredThisAir = false
            __UI.__L.mainJump.bindLegitJumpLoop()
        else
            __UI.__L.mainJump.stopLegitJumpLoop()

            pcall(function()
                __UI.__L.mainJump.createSensors(
                    __UI.__L.mainJump.character
                )
            end)

            task.defer(function()
                if not genv.DEADEYE_MAIN_RUNNING
                    or not __UI.__L.mainJump.enabled
                    or __UI.__L.mainJump.autoJumpMode ~= "rage"
                    or not __UI.__L.mainJump.humanoid
                    or not __UI.__L.mainJump.humanoid.Parent
                then
                    return
                end

                if __UI.__L.mainJump.canJump() then
                    __UI.__L.mainJump.lookAutoJumpCycle = true
                    __UI.__L.mainJump.jump()
                end
            end)
        end
    end

    if persist ~= false then
        __UI.__L.mainJump.saveConfig()
    end

    __UI.__L.mainJump.update()
end

function __UI.__L.mainJump.setupAutoJumpCharacter(char)
    if not char
        or not char:IsA("Model")
    then
        return
    end

    __UI.__L.mainJump.stopLegitJumpLoop()
    __UI.__L.mainJump.destroySensors()

    __UI.__L.mainJump.character =
        char

    __UI.__L.mainJump.humanoid =
        char:WaitForChild(
            "Humanoid"
        )

    __UI.__L.mainJump.root =
        char:WaitForChild(
            "HumanoidRootPart"
        )

    if __UI.__L.mainJump.autoJumpMode == "legit" then
        if __UI.__L.mainJump.enabled then
            __UI.__L.mainJump.bindLegitJumpLoop()
        end
    else
        pcall(function()
            __UI.__L.mainJump.createSensors(
                char
            )
        end)
    end
end

function __UI.__L.mainJump.setDelay(value)
    value =
        tonumber(
            tostring(value or "")
        )
    if not value then
        return
    end
    __UI.__L.mainJump.jumpDelay =
        math.clamp(
            value,
            0,
            5
        )
    __UI.__L.mainJump.delayBox.Text =
        tostring(
            __UI.__L.mainJump.jumpDelay
        )
    __UI.__L.mainJump.saveConfig()
end

function __UI.__L.mainJump.getCrouchMovement()
    local object =
        getCharacterObject()

    if not object then
        return nil
    end

    local movement

    pcall(function()
        movement = object.Movement
    end)

    if type(movement) ~= "table" then
        return nil
    end

    if type(movement.KeyUsed) ~= "function" then
        return nil
    end

    return movement
end

function __UI.__L.mainJump.getCrouchMovement()
    local object =
        getCharacterObject()

    if not object then
        return nil
    end

    local movement

    pcall(function()
        movement = object.Movement
    end)

    if type(movement) ~= "table" then
        return nil
    end

    if type(movement.KeyUsed) ~= "function" then
        return nil
    end

    return movement
end

function __UI.__L.mainJump.setCrouching(
    state,
    movementOverride
)
    local movement =
        movementOverride
        or __UI.__L.mainJump.getCrouchMovement()

    if not movement then
        return false
    end

    __UI.__L.mainJump.crouchSpamMovement =
        movement

    local ok, err =
        pcall(function()
            movement:KeyUsed({
                Key = "Crouching",
                Down = state and true or false
            })
        end)

    if not ok then
        warn(
            "[DeadEye] Crouch Spam KeyUsed error:",
            err
        )
        return false
    end

    return true
end

--// Crouch Spam is driven by its own PreSimulation loop.
--// It is completely independent from AutoJump mode and JumpReact.
--// Normal cycle: ON -> OFF -> ON -> OFF.
--//
--// IMPORTANT:
--// The previous raycast/time-of-flight predictor was removed.
--// The analyzer showed that the game's actual useful early signal is:
--//
--//     HumanoidStateType.Landed
--//             ->
--//     DataRegistry.Grounded = true
--//             ->
--//     AutoJump immediately sets Jump / runs JumpReact
--//
--// In the observed game this gives a real early window before Grounded
--// becomes true. Crouch Spam uses that window by itself.
__UI.__L.CROUCH_SPAM_PREJUMP_MAX_HOLD = 0.35

function __UI.__L.mainJump.armCrouchSpamPreJump()
    if not __UI.__L.mainJump.crouchSpamEnabled
        or __UI.__L.mainJump.crouchSpamPreJump
        or __UI.__L.mainJump.crouchSpamState
    then
        return false
    end

    local humanoid =
        __UI.__L.mainJump.humanoid

    if not humanoid
        or not humanoid.Parent
    then
        return false
    end

    if humanoid:GetState()
        ~= Enum.HumanoidStateType.Landed
    then
        return false
    end

    local object =
        getCharacterObject()

    local registry =
        object
        and object.DataRegistry

    local grounded

    if registry then
        pcall(function()
            grounded =
                registry:Get(
                    "Grounded"
                )
        end)
    end

    --// We only want the pre-Grounded window.
    if grounded == true then
        return false
    end

    __UI.__L.mainJump.crouchSpamPreJump =
        true

    __UI.__L.mainJump.crouchSpamPreJumpStartedAt =
        os.clock()

    __UI.__L.mainJump.crouchSpamState =
        true

    __UI.__L.mainJump.crouchSpamElapsed =
        0

    __UI.__L.mainJump.setCrouching(true)

    return true
end

function __UI.__L.mainJump.startCrouchSpam()
    if __UI.__L.mainJump.crouchSpamConnection then
        return
    end

    __UI.__L.mainJump.crouchSpamState =
        true

    __UI.__L.mainJump.crouchSpamElapsed =
        0

    __UI.__L.mainJump.crouchSpamPreJump =
        false

    __UI.__L.mainJump.crouchSpamPreJumpStartedAt =
        0

    if not __UI.__L.mainJump.setCrouching(true) then
        return
    end

    __UI.__L.mainJump.crouchSpamConnection =
        RunService.PreSimulation:Connect(
            function(deltaTime)
                if not genv.DEADEYE_MAIN_RUNNING
                    or __UI.__L.cleaned
                    or not __UI.__L.mainJump.crouchSpamEnabled
                then
                    return
                end

                if __UI.__L.mainJump.crouchSpamPreJump then
                    local object =
                        getCharacterObject()

                    local registry =
                        object
                        and object.DataRegistry

                    local grounded

                    if registry then
                        pcall(function()
                            grounded =
                                registry:Get(
                                    "Grounded"
                                )
                        end)
                    end

                    if grounded == true then
                        --// Grounded has arrived. Keep Crouch ON for this
                        --// exact transition so AutoJump sees no delay.
                        __UI.__L.mainJump.crouchSpamPreJump =
                            false

                        __UI.__L.mainJump.crouchSpamPreJumpStartedAt =
                            0

                        __UI.__L.mainJump.crouchSpamState =
                            true

                        __UI.__L.mainJump.crouchSpamElapsed =
                            0

                        __UI.__L.mainJump.setCrouching(true)

                        return

                    elseif __UI.__L.mainJump.crouchSpamPreJumpStartedAt > 0
                        and os.clock()
                            - __UI.__L.mainJump.crouchSpamPreJumpStartedAt
                            > __UI.__L.CROUCH_SPAM_PREJUMP_MAX_HOLD
                    then
                        --// Safety timeout. Resume normal ON/OFF spam.
                        __UI.__L.mainJump.crouchSpamPreJump =
                            false

                        __UI.__L.mainJump.crouchSpamPreJumpStartedAt =
                            0

                        __UI.__L.mainJump.crouchSpamElapsed =
                            0

                    else
                        --// Still inside the real pre-Grounded window.
                        __UI.__L.mainJump.crouchSpamState =
                            true

                        __UI.__L.mainJump.crouchSpamElapsed =
                            0

                        __UI.__L.mainJump.setCrouching(true)

                        return
                    end
                end

                --// Arm ONLY from Crouch Spam's own landing signal.
                --// No AutoJump mode / Legit / JumpReact dependency.
                if __UI.__L.mainJump.armCrouchSpamPreJump() then
                    return
                end

                local delay =
                    math.max(
                        tonumber(
                            __UI.__L.mainJump.crouchSpamDelay
                        ) or 0.03,
                        0.001
                    )

                __UI.__L.mainJump.crouchSpamElapsed =
                    __UI.__L.mainJump.crouchSpamElapsed
                    + math.max(
                        tonumber(deltaTime) or 0,
                        0
                    )

                while __UI.__L.mainJump.crouchSpamElapsed >= delay do
                    __UI.__L.mainJump.crouchSpamElapsed =
                        __UI.__L.mainJump.crouchSpamElapsed
                        - delay

                    __UI.__L.mainJump.crouchSpamState =
                        not __UI.__L.mainJump.crouchSpamState

                    if not __UI.__L.mainJump.setCrouching(
                        __UI.__L.mainJump.crouchSpamState
                    )
                    then
                        return
                    end
                end
            end
        )
end

function __UI.__L.mainJump.stopCrouchSpam()
    if __UI.__L.mainJump.crouchSpamConnection then
        pcall(function()
            __UI.__L.mainJump.crouchSpamConnection:Disconnect()
        end)

        __UI.__L.mainJump.crouchSpamConnection =
            nil
    end

    __UI.__L.mainJump.crouchSpamEnabled =
        false

    __UI.__L.mainJump.crouchSpamState =
        false

    __UI.__L.mainJump.crouchSpamElapsed =
        0

    __UI.__L.mainJump.crouchSpamPreJump =
        false

    __UI.__L.mainJump.crouchSpamPreJumpStartedAt =
        0

    -- Always finish standing.
    __UI.__L.mainJump.setCrouching(false)
end

function __UI.__L.mainJump.setCrouchSpamEnabled(state)
    state =
        state and true or false

    if not state then
        __UI.__L.mainJump.stopCrouchSpam()
        __UI.__L.mainJump.update()
        __UI.__L.mainJump.saveConfig()
        return
    end

    if __UI.__L.cleaned then
        return
    end

    --// WITH mode depends on the Reverse Look hook intercepting
    --// DataRegistry.LookCFrame. After a script restart the saved
    --// mode is restored, but the hook itself is not, so install it
    --// when CROUCH SPAM is enabled as well.
    if state
        and __UI.__L.mainJump.reverseLookMode == "with"
        and not __UI.__L.mainJump.reverseLookHookInstalled
    then
        pcall(function()
            __UI.__L.mainJump.installReverseLookHooks()
        end)
    end

    if __UI.__L.mainJump.crouchSpamEnabled
        and __UI.__L.mainJump.crouchSpamConnection
    then
        return
    end

    __UI.__L.mainJump.crouchSpamEnabled =
        true

    __UI.__L.mainJump.startCrouchSpam()

    __UI.__L.mainJump.update()
    __UI.__L.mainJump.saveConfig()
end

function __UI.__L.mainJump.setCrouchSpamDelay(value)
    local number =
        tonumber(
            tostring(value or "")
        )

    if not number then
        return
    end

    __UI.__L.mainJump.crouchSpamDelay =
        math.clamp(
            number,
            0.001,
            5
        )

    if __UI.__L.mainJump.crouchSpamDelayBox then
        __UI.__L.mainJump.crouchSpamDelayBox.Text =
            tostring(
                __UI.__L.mainJump.crouchSpamDelay
            )
    end

    __UI.__L.mainJump.saveConfig()
end

__UI.__L.mainFindKeyCode = function(value)
    local wanted =
        tostring(
            value or ""
        ):gsub(
            "%s+",
            ""
        ):lower()
    for _, keyCode in ipairs(
        Enum.KeyCode:GetEnumItems()
    ) do
        if keyCode.Name:lower() == wanted then
            return keyCode
        end
    end
    return nil
end
__UI.__L.airTurnHotkeyKey =
    __UI.__L.mainFindKeyCode(
        __UI.__L.mainJump.airTurnHotkeyName
    )
if __UI.__L.airTurnHotkeyKey then
    __UI.__L.mainJump.airTurnHotkeyName =
        __UI.__L.airTurnHotkeyKey.Name
else
    __UI.__L.mainJump.airTurnHotkeyName =
        "O"
end

function __UI.__L.mainJump.setAirTurnHotkey(value)
    local key =
        __UI.__L.mainFindKeyCode(
            value
        )

    if not key then
        return
    end

    __UI.__L.mainJump.airTurnHotkeyName =
        key.Name

    if __UI.__L.mainJump.airTurnHotkeyBox then
        __UI.__L.mainJump.airTurnHotkeyBox.Text =
            key.Name
    end

    __UI.__L.mainJump.capturing = nil
    __UI.__L.mainJump.saveConfig()
end

__UI.__L.crouchSpamKey =
    __UI.__L.mainFindKeyCode(
        __UI.__L.mainJump.crouchSpamHotkeyName
    )
if __UI.__L.crouchSpamKey then
    __UI.__L.mainJump.crouchSpamHotkeyName =
        __UI.__L.crouchSpamKey.Name
else
    __UI.__L.mainJump.crouchSpamHotkeyName =
        "I"
end

function __UI.__L.mainJump.setCrouchSpamHotkey(value)
    local key =
        __UI.__L.mainFindKeyCode(
            value
        )

    if not key then
        return
    end

    __UI.__L.mainJump.crouchSpamHotkeyName =
        key.Name

    if __UI.__L.mainJump.crouchSpamHotkeyBox then
        __UI.__L.mainJump.crouchSpamHotkeyBox.Text =
            key.Name
    end

    __UI.__L.mainJump.capturing = nil

    __UI.__L.mainJump.saveConfig()
end

__UI.__L.benchTrimpKey =
    __UI.__L.mainFindKeyCode(
        __UI.__L.mainJump.benchTrimpHotkeyName
    )
if __UI.__L.benchTrimpKey then
    __UI.__L.mainJump.benchTrimpHotkeyName =
        __UI.__L.benchTrimpKey.Name
else
    __UI.__L.mainJump.benchTrimpHotkeyName =
        "P"
end

function __UI.__L.mainJump.setBenchTrimpHotkey(value)
    local key =
        __UI.__L.mainFindKeyCode(
            value
        )

    if not key then
        return
    end

    __UI.__L.mainJump.benchTrimpHotkeyName =
        key.Name

    if __UI.__L.mainJump.benchTrimpHotkeyBox then
        __UI.__L.mainJump.benchTrimpHotkeyBox.Text =
            key.Name
    end

    __UI.__L.mainJump.capturing = nil

    __UI.__L.mainJump.saveConfig()
end

__UI.__L.jumpKey =
    __UI.__L.mainFindKeyCode(
        __UI.__L.mainJump.hotkeyName
    )
if __UI.__L.jumpKey then
    __UI.__L.mainJump.hotkeyName =
        __UI.__L.jumpKey.Name
else
    __UI.__L.mainJump.hotkeyName = "Z"
end
__UI.__L.hideKey =
    __UI.__L.mainFindKeyCode(
        __UI.__L.mainJump.hideUIHotkeyName
    )
if __UI.__L.hideKey then
    __UI.__L.mainJump.hideUIHotkeyName =
        __UI.__L.hideKey.Name
else
    __UI.__L.mainJump.hideUIHotkeyName = "H"
end
function __UI.__L.mainJump.setHotkey(value)
    local key =
        __UI.__L.mainFindKeyCode(
            value
        )
    if not key then
        return
    end
    __UI.__L.mainJump.hotkeyName =
        key.Name
    __UI.__L.mainJump.hotkeyBox.Text =
        key.Name
    __UI.__L.mainJump.saveConfig()
    __UI.__L.mainJump.capturing = nil
end
function __UI.__L.mainJump.setHideUIHotkey(value)
    local key =
        __UI.__L.mainFindKeyCode(
            value
        )
    if not key then
        return
    end
    __UI.__L.mainJump.hideUIHotkeyName =
        key.Name
    __UI.__L.mainJump.hideUIHotkeyBox.Text =
        key.Name
    __UI.__L.mainJump.saveConfig()
    __UI.__L.mainJump.capturing = nil
end
function __UI.__L.mainJump.startCapture(kind)
    __UI.__L.mainJump.capturing =
        kind

    if kind == "jump" then
        __UI.__L.mainJump.hotkeyBox.Text =
            "PRESS KEY..."
    elseif kind == "hide" then
        __UI.__L.mainJump.hideUIHotkeyBox.Text =
            "PRESS KEY..."
    elseif kind == "airTurn" then
        __UI.__L.mainJump.airTurnHotkeyBox.Text =
            "PRESS KEY..."
    elseif kind == "crouchSpam" then
        __UI.__L.mainJump.crouchSpamHotkeyBox.Text =
            "PRESS KEY..."
    elseif kind == "benchTrimp" then
        __UI.__L.mainJump.benchTrimpHotkeyBox.Text =
            "PRESS KEY..."
    end
end
function __UI.__L.mainJump.stopLegitJumpLoop()
    if __UI.__L.mainJump.legitJumpConnection then
        pcall(function()
            __UI.__L.mainJump.legitJumpConnection:Disconnect()
        end)

        __UI.__L.mainJump.legitJumpConnection = nil
    end

    __UI.__L.mainJump.legitMovement = nil
    __UI.__L.mainJump.legitHumanoid = nil
    __UI.__L.mainJump.legitRoot = nil
    __UI.__L.mainJump.legitActiveJumpReact = false
    __UI.__L.mainJump.legitActiveJumpStartedAt = 0
    __UI.__L.mainJump.legitGroundJumpUsed = false
    __UI.__L.mainJump.legitClimbJumpUsed = false
    __UI.__L.mainJump.legitPreviousHumanoidState = nil
end

function __UI.__L.mainJump.legitSetupCharacter(
    object,
    movement,
    humanoid,
    root
)
    if __UI.__L.mainJump.legitMovement == movement
        and __UI.__L.mainJump.legitHumanoid == humanoid
    then
        return
    end

    __UI.__L.mainJump.legitMovement =
        movement
    __UI.__L.mainJump.legitHumanoid =
        humanoid
    __UI.__L.mainJump.legitRoot =
        root

    __UI.__L.mainJump.legitGroundJumpUsed = false
    __UI.__L.mainJump.legitClimbJumpUsed = false
    __UI.__L.mainJump.legitJumpSequence =
        (tonumber(__UI.__L.mainJump.legitJumpSequence) or 0) + 1
    __UI.__L.mainJump.legitActiveJumpReact = false
    __UI.__L.mainJump.legitActiveJumpStartedAt = 0

    __UI.__L.mainJump.legitPreviousHumanoidState =
        humanoid:GetState()
end

function __UI.__L.mainJump.legitGetGrounded(
    movement
)
    local grounded = false

    pcall(function()
        grounded =
            movement.DataRegistry:Get(
                "Grounded"
            ) == true
    end)

    return grounded
end

function __UI.__L.mainJump.legitAutoRelease(
    movement,
    sequence
)
    RunService.Heartbeat:Wait()

    if not genv.DEADEYE_MAIN_RUNNING
        or __UI.__L.cleaned
        or not __UI.__L.mainJump.enabled
        or __UI.__L.mainJump.autoJumpMode ~= "legit"
        or sequence ~= __UI.__L.mainJump.legitJumpSequence
    then
        return
    end

    if not movement
        or type(movement.IsAlive) ~= "function"
        or not movement:IsAlive()
    then
        return
    end

    pcall(function()
        movement.JumpHeldDown = false
    end)
end

function __UI.__L.mainJump.legitExecuteOriginalJumpReact(
    movement,
    reason
)
    if not genv.DEADEYE_MAIN_RUNNING
        or __UI.__L.cleaned
        or not __UI.__L.mainJump.enabled
        or __UI.__L.mainJump.autoJumpMode ~= "legit"
        or __UI.__L.mainJump.legitActiveJumpReact
    then
        return false
    end

    if not movement
        or type(movement.IsAlive) ~= "function"
        or not movement:IsAlive()
    then
        return false
    end

    local humanoid =
        movement.Humanoid

    local character =
        movement.Character

    if not humanoid
        or not character
    then
        return false
    end

    local root =
        character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root then
        return false
    end

    __UI.__L.mainJump.legitActiveJumpReact = true
    __UI.__L.mainJump.legitActiveJumpStartedAt = os.clock()

    __UI.__L.mainJump.legitJumpSequence =
        (tonumber(__UI.__L.mainJump.legitJumpSequence) or 0) + 1

    local sequence =
        __UI.__L.mainJump.legitJumpSequence

    --// Force crouch ON immediately before the same-frame JumpReact.
    --// Prediction ends exactly here. The jump timing itself is unchanged.

    --// The game's real JumpReact is used.
    --// Humanoid.Jump is intentionally set BEFORE JumpReact.
    humanoid.Jump = true

    task.spawn(function()
        pcall(function()
            movement:JumpReact(
                false
            )
        end)

        if __UI.__L.mainJump.legitJumpSequence ~= sequence then
            return
        end

        __UI.__L.mainJump.legitActiveJumpReact = false
        __UI.__L.mainJump.legitActiveJumpStartedAt = 0
    end)

    task.spawn(function()
        __UI.__L.mainJump.legitAutoRelease(
            movement,
            sequence
        )
    end)

    return true
end

function __UI.__L.mainJump.legitTryGroundJump(
    movement
)
    if not genv.DEADEYE_MAIN_RUNNING
        or __UI.__L.cleaned
        or not __UI.__L.mainJump.enabled
        or __UI.__L.mainJump.autoJumpMode ~= "legit"
        or __UI.__L.mainJump.legitActiveJumpReact
        or __UI.__L.mainJump.legitGroundJumpUsed
    then
        return
    end

    local humanoid =
        movement.Humanoid

    if not humanoid then
        return
    end

    local state =
        humanoid:GetState()

    --// Climbing is always handled by its own path.
    if state == Enum.HumanoidStateType.Climbing then
        return
    end

    --// Ground Jump: only Running/Landed.
    if state ~= Enum.HumanoidStateType.Running
        and state ~= Enum.HumanoidStateType.Landed
    then
        return
    end

    --// Use the game's real DataRegistry.Grounded.
    if not __UI.__L.mainJump.legitGetGrounded(
        movement
    ) then
        return
    end

    __UI.__L.mainJump.legitGroundJumpCount =
        (tonumber(__UI.__L.mainJump.legitGroundJumpCount) or 0) + 1

    __UI.__L.mainJump.legitGroundJumpUsed =
        true

    __UI.__L.mainJump.legitExecuteOriginalJumpReact(
        movement,
        "GROUND"
    )
end

function __UI.__L.mainJump.legitTryClimbJump(
    movement
)
    if not genv.DEADEYE_MAIN_RUNNING
        or __UI.__L.cleaned
        or not __UI.__L.mainJump.enabled
        or __UI.__L.mainJump.autoJumpMode ~= "legit"
        or __UI.__L.mainJump.legitActiveJumpReact
        or __UI.__L.mainJump.legitClimbJumpUsed
    then
        return
    end

    local humanoid =
        movement.Humanoid

    if not humanoid then
        return
    end

    --// Detect the ACTUAL Humanoid Climbing state directly in
    --// PreSimulation. No Heartbeat/post-frame wait.
    if humanoid:GetState()
        ~= Enum.HumanoidStateType.Climbing
    then
        return
    end

    __UI.__L.mainJump.legitClimbJumpCount =
        (tonumber(__UI.__L.mainJump.legitClimbJumpCount) or 0) + 1

    __UI.__L.mainJump.legitClimbJumpUsed =
        true

    __UI.__L.mainJump.legitExecuteOriginalJumpReact(
        movement,
        "NATURAL CLIMBING"
    )
end

function __UI.__L.mainJump.bindLegitJumpLoop()
    __UI.__L.mainJump.stopLegitJumpLoop()

    if not genv.DEADEYE_MAIN_RUNNING
        or __UI.__L.cleaned
        or not __UI.__L.mainJump.enabled
        or __UI.__L.mainJump.autoJumpMode ~= "legit"
    then
        return
    end

    __UI.__L.mainJump.legitJumpConnection =
        RunService.PreSimulation:Connect(
            function()
                if not genv.DEADEYE_MAIN_RUNNING
                    or __UI.__L.cleaned
                    or not __UI.__L.mainJump.enabled
                    or __UI.__L.mainJump.autoJumpMode ~= "legit"
                then
                    __UI.__L.mainJump.stopLegitJumpLoop()
                    return
                end

                local object,
                    movement,
                    humanoid,
                    root =
                    (function()
                        local currentObject
                        local currentMovement
                        local currentHumanoid
                        local currentRoot

                        pcall(function()
                            currentObject =
                                getCharacterObject()

                            currentMovement =
                                currentObject
                                and currentObject.Movement

                            if currentMovement then
                                currentHumanoid =
                                    currentMovement.Humanoid

                                local character =
                                    currentMovement.Character

                                if character then
                                    currentRoot =
                                        character:FindFirstChild(
                                            "HumanoidRootPart"
                                        )
                                end
                            end
                        end)

                        return currentObject,
                            currentMovement,
                            currentHumanoid,
                            currentRoot
                    end)()

                if not object
                    or not movement
                    or not humanoid
                    or not root
                then
                    return
                end

                if __UI.__L.mainJump.legitMovement ~= movement
                    or __UI.__L.mainJump.legitHumanoid ~= humanoid
                then
                    __UI.__L.mainJump.legitSetupCharacter(
                        object,
                        movement,
                        humanoid,
                        root
                    )
                end

                local state =
                    humanoid:GetState()

                --// CLIMBING FIRST.
                if state == Enum.HumanoidStateType.Climbing then
                    __UI.__L.mainJump.legitTryClimbJump(
                        movement
                    )
                else
                    --// GROUND.
                    __UI.__L.mainJump.legitTryGroundJump(
                        movement
                    )
                end

                --// Re-arm one ground JumpReact on the next real Freefall.
                if state == Enum.HumanoidStateType.Freefall
                    and __UI.__L.mainJump.legitGroundJumpUsed
                then
                    __UI.__L.mainJump.legitGroundJumpUsed = false
                end

                --// Re-arm one Climbing JumpReact after leaving actual Climbing.
                if state ~= Enum.HumanoidStateType.Climbing
                    and __UI.__L.mainJump.legitClimbJumpUsed
                    and __UI.__L.mainJump.legitPreviousHumanoidState
                        == Enum.HumanoidStateType.Climbing
                then
                    __UI.__L.mainJump.legitClimbJumpUsed = false
                end

                --// Same watchdog window as the standalone test.
                if __UI.__L.mainJump.legitActiveJumpReact
                    and __UI.__L.mainJump.legitActiveJumpStartedAt > 0
                    and os.clock()
                        - __UI.__L.mainJump.legitActiveJumpStartedAt
                        > 0.35
                then
                    pcall(function()
                        movement.JumpHeldDown = false
                    end)

                    __UI.__L.mainJump.legitActiveJumpReact = false
                    __UI.__L.mainJump.legitActiveJumpStartedAt = 0
                end

                __UI.__L.mainJump.legitPreviousHumanoidState =
                    state
            end
        )
end

function __UI.__L.mainJump.destroySensors()
    __UI.__L.mainJump.stopLegitJumpLoop()

    if __UI.__L.mainJump.lookWatcherConnection then
        pcall(function()
            __UI.__L.mainJump.lookWatcherConnection:Disconnect()
        end)
        __UI.__L.mainJump.lookWatcherConnection = nil
    end

    __UI.__L.mainJump.manualJumpActive = false
    __UI.__L.mainJump.lookTriggeredThisAir = false

    if __UI.__L.mainJump.sensorTouchConnection then
        pcall(function()
            __UI.__L.mainJump.sensorTouchConnection:Disconnect()
        end)
        __UI.__L.mainJump.sensorTouchConnection = nil
    end

    if __UI.__L.mainJump.frontSensorTouchConnection then
        pcall(function()
            __UI.__L.mainJump.frontSensorTouchConnection:Disconnect()
        end)
        __UI.__L.mainJump.frontSensorTouchConnection = nil
    end

    if __UI.__L.mainJump.rearSensorTouchConnection then
        pcall(function()
            __UI.__L.mainJump.rearSensorTouchConnection:Disconnect()
        end)
        __UI.__L.mainJump.rearSensorTouchConnection = nil
    end

    if __UI.__L.mainJump.jumpForwardSensorTouchConnection then
        pcall(function()
            __UI.__L.mainJump.jumpForwardSensorTouchConnection:Disconnect()
        end)
        __UI.__L.mainJump.jumpForwardSensorTouchConnection = nil
    end

    for _, key in ipairs({
        "sensorPart",
        "frontSensorPart",
        "rearSensorPart",
        "jumpForwardSensorPart",
        "lookSensorPart",
        "lookFrontSensorPart",
        "lookForwardSensorPart"
    }) do
        local sensor =
            __UI.__L.mainJump[key]

        if sensor then
            pcall(function()
                sensor:Destroy()
            end)

            __UI.__L.mainJump[key] = nil
        end
    end

end

function __UI.__L.mainJump.isGameJumpBlocked()
    local object =
        getCharacterObject()

    local emoteActive =
        false

    if object
        and object.DataRegistry
    then
        local registry =
            object.DataRegistry

        local emoteOk, emoteId =
            pcall(function()
                return registry:Get(
                    "Emote"
                )
            end)

        emoteActive =
            emoteOk
            and tonumber(emoteId)
            and tonumber(emoteId) ~= 0

        if not emoteActive then
            for _, key in ipairs({
                "CanJump",
                "JumpAllowed",
                "JumpEnabled"
            }) do
                local ok, value =
                    pcall(function()
                        return registry:Get(
                            key
                        )
                    end)

                if ok
                    and value == false
                then
                    return true
                end
            end
        end

        for _, key in ipairs({
            "NoJump",
            "JumpDisabled",
            "IsCarried",
            "IsCarrying"
        }) do
            local ok, value =
                pcall(function()
                    return registry:Get(
                        key
                    )
                end)

            if ok
                and value == true
            then
                return true
            end
        end
    end

    for _, root in ipairs({
        __UI.__L.mainJump.character,
        LocalPlayer,
        workspace
    }) do
        if root then
            local attributes =
                root:GetAttributes()

            for name, value in pairs(
                attributes
            ) do
                local attributeName =
                    string.lower(
                        tostring(name)
                    )

                if not emoteActive
                    and value == false
                    and (
                        string.find(
                            attributeName,
                            "canjump",
                            1,
                            true
                        )
                        or string.find(
                            attributeName,
                            "jumpallowed",
                            1,
                            true
                        )
                        or string.find(
                            attributeName,
                            "jumpenabled",
                            1,
                            true
                        )
                    )
                then
                    return true
                end

                if value == true
                    and (
                        string.find(
                            attributeName,
                            "nojump",
                            1,
                            true
                        )
                        or string.find(
                            attributeName,
                            "jumpdisabled",
                            1,
                            true
                        )
                        or string.find(
                            attributeName,
                            "carried",
                            1,
                            true
                        )
                        or string.find(
                            attributeName,
                            "carrying",
                            1,
                            true
                        )
                    )
                then
                    return true
                end
            end
        end
    end

    --// Match Roblox's actual ContextActionService ordering.
    --// Same-priority actions are ordered by stackOrder, so an
    --// emote can block JumpAction without using a higher priority.
    local blockedByContext =
        false

    pcall(function()
        local ContextActionService =
            game:GetService(
                "ContextActionService"
            )

        local actions =
            ContextActionService:
                GetAllBoundActionInfo()

        local jumpPriority =
            2000
        local jumpStackOrder =
            -math.huge

        for name, info in pairs(
            actions
        ) do
            if type(info) == "table"
                and string.lower(
                    tostring(name)
                ) == "jumpaction"
            then
                jumpPriority =
                    tonumber(
                        info.priorityLevel
                    )
                    or jumpPriority

                jumpStackOrder =
                    tonumber(
                        info.stackOrder
                    )
                    or jumpStackOrder

                break
            end
        end

        for name, info in pairs(
            actions
        ) do
            if type(info) == "table"
                and string.lower(
                    tostring(name)
                ) ~= "jumpaction"
            then
                local priority =
                    tonumber(
                        info.priorityLevel
                    )
                    or 0

                local stackOrder =
                    tonumber(
                        info.stackOrder
                    )
                    or 0

                local takesJumpInput =
                    false

                for _, inputType in ipairs(
                    info.inputTypes
                        or {}
                ) do
                    if inputType
                            == Enum.PlayerActions.CharacterJump
                        or inputType
                            == Enum.KeyCode.Space
                    then
                        takesJumpInput = true
                        break
                    end
                end

                if takesJumpInput
                    and (
                        priority > jumpPriority
                        or (
                            priority == jumpPriority
                            and stackOrder > jumpStackOrder
                        )
                    )
                then
                    blockedByContext = true
                    break
                end
            end
        end
    end)

    return blockedByContext
end

function __UI.__L.mainJump.canJump(benchTrimp)
    if not genv.DEADEYE_MAIN_RUNNING
        or not __UI.__L.mainJump.humanoid
        or __UI.__L.mainJump.humanoid.Health <= 0
    then
        return false
    end

    if not benchTrimp
        and not __UI.__L.mainJump.enabled
    then
        return false
    end

    if not benchTrimp
        and __UI.__L.mainJump.humanoid.FloorMaterial
            == Enum.Material.Air
    then
        return false
    end

    local object =
        getCharacterObject()

    if object
        and object.DataRegistry
    then
        local registry =
            object.DataRegistry

        local emoteOk, emoteId =
            pcall(function()
                return registry:Get(
                    "Emote"
                )
            end)

        local emoteActive =
            emoteOk
            and tonumber(emoteId)
            and tonumber(emoteId) ~= 0

        --// Native Movement:Jump() blocks jumping when the current
        --// MoveStats speed is exactly 0. This is also what makes
        --// non-jumpable emotes such as DogParty refuse the jump.
        local speedOk, moveSpeed =
            pcall(function()
                return object.Movement
                    and object.Movement.MoveStats
                    and object.Movement.MoveStats.MoveStats
                    and object.Movement.MoveStats.MoveStats.Speed
            end)

        if speedOk
            and tonumber(moveSpeed) == 0
        then
            return false
        end

        --// Native Movement:Jump() restrictions independent of emotes.
        local downedOk, downed =
            pcall(function()
                return registry:Get("Downed")
            end)

        if downedOk
            and downed == true
        then
            return false
        end

        local carryingOk, carrying =
            pcall(function()
                return registry:Get("Carrying")
            end)

        if carryingOk
            and carrying
            and carrying ~= false
            and carrying ~= 0
        then
            return false
        end

        local carriedOk, carried =
            pcall(function()
                return registry:Get("Carried")
            end)

        if carriedOk
            and carried
            and carried ~= false
            and carried ~= 0
        then
            return false
        end

        if not emoteActive then
            --// Keep the existing generic game-level checks for
            --// non-emote states such as special-round restrictions.
            if __UI.__L.mainJump.isGameJumpBlocked() then
                return false
            end
        end
    else
        if __UI.__L.mainJump.isGameJumpBlocked() then
            return false
        end
    end

    if benchTrimp then
        --// Bench Trimp fires from Climbing, so do not require
        --// the grounded/airborne state rules used by AutoJump.
        return true
    end

    local state =
        __UI.__L.mainJump.humanoid:GetState()

    return state
        ~= Enum.HumanoidStateType.Jumping
        and state
            ~= Enum.HumanoidStateType.Freefall
        and state
            ~= Enum.HumanoidStateType.FallingDown
end

--// =========================================================
--// BENCH TRIMP
--// Force Climbing -> Jumping, gated by the same jump
--// restrictions used by AutoJump.
--// No independent cleanup: main GUI close owns cleanup.
--// =========================================================
function __UI.__L.mainJump.bindBenchTrimp(char)
    if __UI.__L.mainJump.benchTrimpStateConnection then
        pcall(function()
            __UI.__L.mainJump.benchTrimpStateConnection:Disconnect()
        end)
        __UI.__L.mainJump.benchTrimpStateConnection = nil
    end

    if not char
        or not char:IsA("Model")
    then
        return
    end

    local humanoid =
        char:FindFirstChildOfClass(
            "Humanoid"
        )

    if not humanoid then
        pcall(function()
            humanoid =
                char:WaitForChild(
                    "Humanoid",
                    5
                )
        end)
    end

    if not humanoid then
        return
    end

    local forcing = false

    __UI.__L.mainJump.benchTrimpStateConnection =
        humanoid.StateChanged:Connect(
            function(_, newState)
                if not genv.DEADEYE_MAIN_RUNNING
                    or __UI.__L.cleaned
                    or not __UI.__L.mainJump.benchTrimpEnabled
                    or __UI.__L.mainJump.character ~= char
                    or forcing
                then
                    return
                end

                if newState
                    ~= Enum.HumanoidStateType.Climbing
                then
                    return
                end

                if not __UI.__L.mainJump.canJump(true) then
                    return
                end

                forcing = true

                task.defer(function()
                    if not genv.DEADEYE_MAIN_RUNNING
                        or __UI.__L.cleaned
                        or not __UI.__L.mainJump.benchTrimpEnabled
                        or __UI.__L.mainJump.character ~= char
                        or not humanoid.Parent
                    then
                        forcing = false
                        return
                    end

                    if humanoid:GetState()
                        ~= Enum.HumanoidStateType.Climbing
                    then
                        forcing = false
                        return
                    end

                    if not __UI.__L.mainJump.canJump(true) then
                        forcing = false
                        return
                    end

                    pcall(function()
                        humanoid:ChangeState(
                            Enum.HumanoidStateType.Jumping
                        )
                    end)

                    forcing = false
                end)
            end
        )
end

function __UI.__L.mainJump.setBenchTrimpEnabled(state)
    __UI.__L.mainJump.benchTrimpEnabled =
        state and true or false

    if __UI.__L.mainJump.benchTrimpEnabled then
        local char =
            __UI.__L.mainJump.character
            or LocalPlayer.Character

        if char then
            pcall(function()
                __UI.__L.mainJump.bindBenchTrimp(
                    char
                )
            end)
        end
    end

    __UI.__L.mainJump.saveConfig()
    __UI.__L.mainJump.saveEnabledStates()
    __UI.__L.mainJump.update()
end

function __UI.__L.mainJump.lookScannerSeesSurface()
    --// Only accept an actual collidable landing surface directly below.
    --// The old overlap-box scanner could see arbitrary map geometry and
    --// re-trigger LOOK repeatedly on some maps.
    if not __UI.__L.mainJump.lookEnabled
        or not __UI.__L.mainJump.enabled
        or not __UI.__L.mainJump.root
        or not __UI.__L.mainJump.character
    then
        return false
    end

    local params =
        RaycastParams.new()

    params.FilterType =
        Enum.RaycastFilterType.Exclude

    params.FilterDescendantsInstances = {
        __UI.__L.mainJump.character
    }

    params.IgnoreWater = true

    local rayLength =
        7.5

    local origins = {
        __UI.__L.mainJump.root.Position
            + Vector3.new(
                0,
                -0.75,
                0
            )
    }

    if __UI.__L.mainJump.lookForwardSensorPart
        and __UI.__L.mainJump.lookForwardSensorPart.Parent
    then
        table.insert(
            origins,
            __UI.__L.mainJump.lookForwardSensorPart.Position
        )
    end

    for _, origin in ipairs(origins) do
        local result

        local ok =
            pcall(function()
                result =
                    workspace:Raycast(
                        origin,
                        Vector3.new(
                            0,
                            -rayLength,
                            0
                        ),
                        params
                    )
            end)

        if ok and result then
            local instance =
                result.Instance

            local validSurface =
                instance == workspace.Terrain
                or (
                    instance
                    and instance:IsA("BasePart")
                    and instance.CanCollide
                )

            if validSurface then
                local distance =
                    (
                        origin
                        - result.Position
                    ).Magnitude

                if distance >= 2.0
                    and distance <= rayLength
                then
                    return true
                end
            end
        end
    end

    return false
end

function __UI.__L.mainJump.jump(hit)
    if not __UI.__L.mainJump.canJump() then
        return
    end

    __UI.__L.mainJump.lastJump =
        tick()

    --// Starting an automatic jump begins a NEW airborne phase.
    --// LOOK is allowed to trigger once near the landing of this jump.

    if __UI.__L.mainJump.lookEnabled
        and __UI.__L.mainJump.enabled
        and __UI.__L.mainJump.lookActive
    then
        __UI.__L.mainJump.lookAutoJumpCycle = true
        __UI.__L.mainJump.lookRestoreDeadline =
            tick()
            + __UI.__L.LOOK_MAX_AFTER_JUMP
        __UI.__L.mainJump.lookMinActiveDeadline =
            tick()
            + __UI.__L.LOOK_MIN_ACTIVE
    end

    __UI.__L.mainJump.humanoid.Jump = true

    if __UI.__L.mainJump.lookActive then
        __UI.__L.mainJump.lookRestoreDeadline =
            tick()
            + __UI.__L.LOOK_MAX_AFTER_JUMP
    end

    pcall(function()
        __UI.__L.mainJump.humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end)
end

function __UI.__L.mainJump.isCameraLookingBackward()
    local camera =
        workspace.CurrentCamera

    local root =
        __UI.__L.mainJump.root

    if not camera
        or not root
    then
        return false
    end

    local cameraLook =
        camera.CFrame.LookVector

    local rootLook =
        root.CFrame.LookVector

    local cameraFlat =
        Vector3.new(
            cameraLook.X,
            0,
            cameraLook.Z
        )

    local rootFlat =
        Vector3.new(
            rootLook.X,
            0,
            rootLook.Z
        )

    if cameraFlat.Magnitude <= 0.001
        or rootFlat.Magnitude <= 0.001
    then
        return false
    end

    cameraFlat =
        cameraFlat.Unit

    rootFlat =
        rootFlat.Unit

    --// -1 = exactly backward, 0 = sideways.
    --// Require a clearly backward camera direction.
    return cameraFlat:Dot(rootFlat) <= -0.35
end

function __UI.__L.mainJump.contact(hit, requireCameraBackward)
    if not genv.DEADEYE_MAIN_RUNNING
        or not __UI.__L.mainJump.enabled
        or __UI.__L.mainJump.autoJumpMode ~= "rage"
        or not hit
    then
        return
    end

    if requireCameraBackward
        and not __UI.__L.mainJump.isCameraLookingBackward()
    then
        return
    end

    if __UI.__L.mainJump.character
        and hit:IsDescendantOf(
            __UI.__L.mainJump.character
        )
    then
        return
    end

    task.wait(
        __UI.__L.mainJump.jumpDelay
    )

    if not genv.DEADEYE_MAIN_RUNNING
        or not __UI.__L.mainJump.enabled
    then
        return
    end

    if requireCameraBackward
        and not __UI.__L.mainJump.isCameraLookingBackward()
    then
        return
    end

    __UI.__L.mainJump.jump(hit)
end

function __UI.__L.mainJump.createSensors(char)
    if not char
        or not char:IsA("Model")
    then
        return
    end

    __UI.__L.mainJump.destroySensors()

    __UI.__L.mainJump.character =
        char

    __UI.__L.mainJump.humanoid =
        char:WaitForChild(
            "Humanoid"
        )

    __UI.__L.mainJump.root =
        char:WaitForChild(
            "HumanoidRootPart"
        )

    __UI.__L.mainJump.lookTriggeredThisAir = false

    --// =====================================================
    --// AUTOJUMP SENSORS
    --// These remain independent from LOOK.
    --// =====================================================
    local sensor =
        Instance.new("Part")
    sensor.Name =
        "FootJumpSensor"
    sensor.Size =
        Vector3.new(
            2.6,
            0.15,
            2.6
        )
    sensor.Transparency = 1
    sensor.Anchored = false
    sensor.CanCollide = false
    sensor.CanTouch = true
    sensor.CanQuery = false
    sensor.Massless = true
    sensor.CastShadow = false
    sensor.CFrame =
        __UI.__L.mainJump.root.CFrame
        * CFrame.new(
            0,
            -3,
            0
        )
    sensor.Parent = char

    local weld =
        Instance.new(
            "WeldConstraint"
        )
    weld.Part0 =
        __UI.__L.mainJump.root
    weld.Part1 =
        sensor
    weld.Parent =
        sensor

    __UI.__L.mainJump.sensorPart =
        sensor

    __UI.__L.mainJump.sensorTouchConnection =
        sensor.Touched:Connect(
            function(hit)
                __UI.__L.mainJump.contact(hit)
            end
        )

    local front =
        Instance.new("Part")
    front.Name =
        "FrontJumpSensor"
    front.Size =
        Vector3.new(
            2,
            3,
            1
        )
    front.Transparency = 1
    front.Anchored = false
    front.CanCollide = false
    front.CanTouch = true
    front.CanQuery = false
    front.Massless = true
    front.CastShadow = false
    front.CFrame =
        __UI.__L.mainJump.root.CFrame
        * CFrame.new(
            0,
            -1,
            -0.8
        )
    front.Parent = char

    local frontWeld =
        Instance.new(
            "WeldConstraint"
        )
    frontWeld.Part0 =
        __UI.__L.mainJump.root
    frontWeld.Part1 =
        front
    frontWeld.Parent =
        front

    __UI.__L.mainJump.frontSensorPart =
        front

    __UI.__L.mainJump.frontSensorTouchConnection =
        front.Touched:Connect(
            function(hit)
                __UI.__L.mainJump.contact(hit)
            end
        )

    --// =====================================================
    --// REAR AUTOJUMP SENSOR
    --// Exact mirror of FrontJumpSensor.
    --// Works only while the camera is looking backward.
    --// =====================================================
    local rear =
        Instance.new("Part")

    rear.Name =
        "RearJumpSensor"

    rear.Size =
        Vector3.new(
            2,
            3,
            1
        )

    rear.Transparency = 1
    rear.Anchored = false
    rear.CanCollide = false
    rear.CanTouch = true
    rear.CanQuery = false
    rear.Massless = true
    rear.CastShadow = false

    rear.CFrame =
        __UI.__L.mainJump.root.CFrame
        * CFrame.new(
            0,
            -1,
            0.8
        )

    rear.Parent =
        char

    local rearWeld =
        Instance.new(
            "WeldConstraint"
        )

    rearWeld.Part0 =
        __UI.__L.mainJump.root

    rearWeld.Part1 =
        rear

    rearWeld.Parent =
        rear

    __UI.__L.mainJump.rearSensorPart =
        rear

    __UI.__L.mainJump.rearSensorTouchConnection =
        rear.Touched:Connect(
            function(hit)
                __UI.__L.mainJump.contact(
                    hit,
                    true
                )
            end
        )

    --// =====================================================
    --// EXTRA FORWARD JUMP SENSOR
    --// Same shape/offset as FrontJumpSensor.
    --// Kept as a separate physical sensor for map-dependent
    --// contact detection.
    --// =====================================================
    local jumpForwardExtra =
        Instance.new("Part")

    jumpForwardExtra.Name =
        "JumpForwardSensorExtra"

    jumpForwardExtra.Size =
        Vector3.new(
            2,
            3,
            1
        )

    jumpForwardExtra.Transparency = 1
    jumpForwardExtra.Anchored = false
    jumpForwardExtra.CanCollide = false
    jumpForwardExtra.CanTouch = true
    jumpForwardExtra.CanQuery = false
    jumpForwardExtra.Massless = true
    jumpForwardExtra.CastShadow = false

    jumpForwardExtra.CFrame =
        __UI.__L.mainJump.root.CFrame
        * CFrame.new(
            0,
            -1,
            -0.8
        )

    jumpForwardExtra.Parent =
        char

    local jumpForwardExtraWeld =
        Instance.new(
            "WeldConstraint"
        )

    jumpForwardExtraWeld.Part0 =
        __UI.__L.mainJump.root

    jumpForwardExtraWeld.Part1 =
        jumpForwardExtra

    jumpForwardExtraWeld.Parent =
        jumpForwardExtra

    __UI.__L.mainJump.jumpForwardSensorPart =
        jumpForwardExtra

    __UI.__L.mainJump.jumpForwardSensorTouchConnection =
        jumpForwardExtra.Touched:Connect(
            function(hit)
                __UI.__L.mainJump.contact(hit)
            end
        )

    --// =====================================================
    --// EXTRA FORWARD LOOK SENSOR
    --// Same shape/offset as FrontJumpSensor.
    --// It is used as an additional forward/downward probe.
    --// =====================================================
    local lookForwardExtra =
        Instance.new("Part")

    lookForwardExtra.Name =
        "LookForwardSensorExtra"

    lookForwardExtra.Size =
        Vector3.new(
            2,
            3,
            1
        )

    lookForwardExtra.Transparency = 1
    lookForwardExtra.Anchored = false
    lookForwardExtra.CanCollide = false
    lookForwardExtra.CanTouch = false
    lookForwardExtra.CanQuery = true
    lookForwardExtra.Massless = true
    lookForwardExtra.CastShadow = false

    lookForwardExtra.CFrame =
        __UI.__L.mainJump.root.CFrame
        * CFrame.new(
            0,
            -1,
            -0.8
        )

    lookForwardExtra.Parent =
        char

    local lookForwardExtraWeld =
        Instance.new(
            "WeldConstraint"
        )

    lookForwardExtraWeld.Part0 =
        __UI.__L.mainJump.root

    lookForwardExtraWeld.Part1 =
        lookForwardExtra

    lookForwardExtraWeld.Parent =
        lookForwardExtra

    __UI.__L.mainJump.lookForwardSensorPart =
        lookForwardExtra

    --// =====================================================
    --// LOOK-ONLY SENSORS
    --// Small pre-landing detection band.
    --// They never call AutoJump and have no touch counters.
    --// =====================================================
    local lookSensor =
        Instance.new("Part")
    lookSensor.Name =
        "LookFootJumpSensor"
    lookSensor.Size =
        Vector3.new(
            2.6,
            1.0,
            2.6
        )
    lookSensor.Transparency = 1
    lookSensor.Anchored = false
    lookSensor.CanCollide = false
    lookSensor.CanTouch = false
    lookSensor.CanQuery = true
    lookSensor.Massless = true
    lookSensor.CastShadow = false
    lookSensor.CFrame =
        __UI.__L.mainJump.root.CFrame
        * CFrame.new(
            0,
            -4.8,
            0
        )
    lookSensor.Parent = char

    local lookWeld =
        Instance.new(
            "WeldConstraint"
        )
    lookWeld.Part0 =
        __UI.__L.mainJump.root
    lookWeld.Part1 =
        lookSensor
    lookWeld.Parent =
        lookSensor

    __UI.__L.mainJump.lookSensorPart =
        lookSensor

    local lookFront =
        Instance.new("Part")
    lookFront.Name =
        "LookFrontJumpSensor"
    lookFront.Size =
        Vector3.new(
            2,
            1.0,
            1
        )
    lookFront.Transparency = 1
    lookFront.Anchored = false
    lookFront.CanCollide = false
    lookFront.CanTouch = false
    lookFront.CanQuery = true
    lookFront.Massless = true
    lookFront.CastShadow = false
    lookFront.CFrame =
        __UI.__L.mainJump.root.CFrame
        * CFrame.new(
            0,
            -4.8,
            -0.8
        )
    lookFront.Parent = char

    local lookFrontWeld =
        Instance.new(
            "WeldConstraint"
        )
    lookFrontWeld.Part0 =
        __UI.__L.mainJump.root
    lookFrontWeld.Part1 =
        lookFront
    lookFrontWeld.Parent =
        lookFront

    __UI.__L.mainJump.lookFrontSensorPart =
        lookFront

    --// =====================================================
    --// LOOK PRE-LANDING WATCHER
    --// =====================================================
    --// Runs only while AutoJump is enabled. It waits for the
    --// character to be descending and for the separate LOOK
    --// sensor to see the landing surface. This is deliberately
    --// earlier than the normal AutoJump Touched event.
    __UI.__L.mainJump.lookWatcherConnection =
        RunService.Heartbeat:Connect(
            function()
                if not genv.DEADEYE_MAIN_RUNNING
                    or __UI.__L.cleaned
                    or not __UI.__L.mainJump.enabled
                    or not __UI.__L.mainJump.lookEnabled
                    or __UI.__L.mainJump.rageLookEnabled
                    or not __UI.__L.mainJump.humanoid
                    or not __UI.__L.mainJump.root
                then
                    return
                end

                if __UI.__L.mainJump.manualJumpActive then
                    if __UI.__L.mainJump.humanoid.FloorMaterial
                        ~= Enum.Material.Air
                    then
                        __UI.__L.mainJump.manualJumpActive = false
                    else
                        return
                    end
                end

                local state
                local verticalVelocity = 0

                pcall(function()
                    state =
                        __UI.__L.mainJump.humanoid:GetState()
                    verticalVelocity =
                        __UI.__L.mainJump.root.AssemblyLinearVelocity.Y
                end)

                local grounded =
                    __UI.__L.mainJump.humanoid.FloorMaterial
                        ~= Enum.Material.Air
                    or state
                        == Enum.HumanoidStateType.Landed
                    or state
                        == Enum.HumanoidStateType.Running
                    or state
                        == Enum.HumanoidStateType.RunningNoPhysics

                if grounded then
                    __UI.__L.mainJump.lookTriggeredThisAir = false
                    __UI.__L.mainJump.lookAutoJumpCycle = false
                    return
                end

                if not state
                    or (
                        state
                            ~= Enum.HumanoidStateType.Freefall
                        and state
                            ~= Enum.HumanoidStateType.FallingDown
                    )
                    or verticalVelocity >= -0.05
                then
                    return
                end

                --// One LOOK activation per airborne phase.
                if not __UI.__L.mainJump.lookTriggeredThisAir
                    and not __UI.__L.mainJump.lookActive
                    and __UI.__L.mainJump.lookScannerSeesSurface()
                then
                    __UI.__L.mainJump.lookTriggeredThisAir = true
                    __UI.__L.mainJump.lookAutoJumpCycle = true
                    __UI.__L.mainJump.beginLook()
                end
            end
        )

end
genv.DEADEYE_MAIN_RUNNING = true
__UI.__L.mainPage =
    Instance.new("ScrollingFrame")
__UI.__L.mainPage.Name =
    "MainPage"
__UI.__L.mainPage.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
__UI.__L.mainPage.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
__UI.__L.mainPage.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.mainPage.BorderSizePixel = 0
__UI.__L.mainPage.ScrollBarThickness = 6
__UI.__L.mainPage.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
__UI.__L.mainPage.ScrollingDirection =
    Enum.ScrollingDirection.Y
__UI.__L.mainPage.Visible = false
__UI.__L.mainPage.Parent = __UI.__L.Main
__UI.mainCorner =
    Instance.new("UICorner")
__UI.mainCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
__UI.mainCorner.Parent =
    __UI.__L.mainPage
__UI.__L.mainPadding =
    Instance.new("UIPadding")
__UI.__L.mainPadding.PaddingTop =
    UDim.new(
        0,
        8
    )
__UI.__L.mainPadding.PaddingBottom =
    UDim.new(
        0,
        8
    )
__UI.__L.mainPadding.PaddingLeft =
    UDim.new(
        0,
        8
    )
__UI.__L.mainPadding.PaddingRight =
    UDim.new(
        0,
        8
    )
__UI.__L.mainPadding.Parent =
    __UI.__L.mainPage
__UI.mainLayout =
    Instance.new("UIListLayout")
__UI.mainLayout.Padding =
    UDim.new(
        0,
        6
    )
__UI.mainLayout.SortOrder =
    Enum.SortOrder.LayoutOrder
__UI.mainLayout.Parent =
    __UI.__L.mainPage
__UI.__L.mainRow = function(labelText, order)
    local row =
        Instance.new("Frame")
    row.Size =
        UDim2.new(
            1,
            -4,
            0,
            40
        )
    row.BackgroundColor3 =
        Color3.fromRGB(
            40,
            40,
            40
        )
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = __UI.__L.mainPage

    local rowStroke =
        Instance.new("UIStroke")
    rowStroke.Thickness =
        1
    rowStroke.Transparency =
        0.88
    rowStroke.Parent =
        row

    local rowCorner =
        Instance.new("UICorner")
    rowCorner.CornerRadius =
        UDim.new(
            0,
            7
        )
    rowCorner.Parent =
        row
    return row
end
__UI.autoRow =
    __UI.__L.mainRow(
        "AUTOJUMP",
        1
    )
__UI.__L.autoLabel =
    Instance.new("TextLabel")
__UI.__L.autoLabel.Size =
    UDim2.new(
        0.7,
        0,
        1,
        0
    )
__UI.__L.autoLabel.Position =
    UDim2.new(
        0,
        10,
        0,
        0
    )
__UI.__L.autoLabel.BackgroundTransparency = 1
__UI.__L.autoLabel.Text = "AUTOJUMP"
__UI.__L.autoLabel.TextSize = 11
__UI.__L.autoLabel.Font = Enum.Font.GothamBold
__UI.__L.autoLabel.TextColor3 =
    Color3.fromRGB(
        215,
        215,
        215
    )
__UI.__L.autoLabel.TextXAlignment =
    Enum.TextXAlignment.Left
__UI.__L.autoLabel.Parent = __UI.autoRow

__UI.__L.mainJump.hotkeyBox =
    Instance.new("TextButton")
__UI.__L.mainJump.hotkeyBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
__UI.__L.mainJump.hotkeyBox.Position =
    UDim2.new(
        1,
        -235,
        0.5,
        -14
    )
__UI.__L.mainJump.hotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.mainJump.hotkeyBox.BorderSizePixel = 0
__UI.__L.mainJump.hotkeyBox.Text =
    __UI.__L.mainJump.hotkeyName
__UI.__L.mainJump.hotkeyBox.TextSize = 10
__UI.__L.mainJump.hotkeyBox.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.hotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.hotkeyBox.Parent =
    __UI.autoRow

__UI.autoHotkeyCorner =
    Instance.new("UICorner")
__UI.autoHotkeyCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.autoHotkeyCorner.Parent =
    __UI.__L.mainJump.hotkeyBox

__UI.__L.mainConnect(
    __UI.__L.mainJump.hotkeyBox.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.startCapture(
                "jump"
            )
        end
    )
)

__UI.__L.mainJump.delayBox =
    Instance.new("TextBox")
__UI.__L.mainJump.delayBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
__UI.__L.mainJump.delayBox.Position =
    UDim2.new(
        1,
        -155,
        0.5,
        -14
    )
__UI.__L.mainJump.delayBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.mainJump.delayBox.BorderSizePixel = 0
__UI.__L.mainJump.delayBox.ClearTextOnFocus = false
__UI.__L.mainJump.delayBox.Text =
    tostring(
        __UI.__L.mainJump.jumpDelay
    )
__UI.__L.mainJump.delayBox.TextSize = 10
__UI.__L.mainJump.delayBox.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.delayBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.delayBox.Parent =
    __UI.autoRow

__UI.autoDelayCorner =
    Instance.new("UICorner")
__UI.autoDelayCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.autoDelayCorner.Parent =
    __UI.__L.mainJump.delayBox

__UI.__L.mainConnect(
    __UI.__L.mainJump.delayBox.FocusLost:Connect(
        function(enterPressed)
            if enterPressed then
                __UI.__L.mainJump.setDelay(
                    __UI.__L.mainJump.delayBox.Text
                )
            else
                __UI.__L.mainJump.delayBox.Text =
                    tostring(
                        __UI.__L.mainJump.jumpDelay
                    )
            end
        end
    )
)

__UI.__L.mainJump.toggle =
    Instance.new("TextButton")
__UI.__L.mainJump.toggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
__UI.__L.mainJump.toggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
__UI.__L.mainJump.toggle.BorderSizePixel = 0
__UI.__L.mainJump.toggle.TextSize = 10
__UI.__L.mainJump.toggle.Font = Enum.Font.GothamBold
__UI.__L.mainJump.toggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.toggle.Parent =
    __UI.autoRow
__UI.toggleCorner =
    Instance.new("UICorner")
__UI.toggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.toggleCorner.Parent =
    __UI.__L.mainJump.toggle
__UI.__L.mainConnect(
    __UI.__L.mainJump.toggle.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.setEnabled(
                not __UI.__L.mainJump.enabled
            )
        end
    )
)

--// =========================================================
--// AUTO JUMP MODE
--// LEGIT = v1.19 native JumpReact(false) on PreSimulation.
--//        Grounded is read from DataRegistry; Climbing is handled
--//        from the actual Humanoid state; no manual velocity.
--// RAGE = existing sensor-based DeadEye AutoJump.
--// =========================================================
__UI.autoJumpModeRow =
    __UI.__L.mainRow(
        "AUTO JUMP MODE",
        2
    )

__UI.__L.autoJumpModeLabel =
    __UI.__L.autoLabel:Clone()

__UI.__L.autoJumpModeLabel.Text =
    "AUTO JUMP MODE"

__UI.__L.autoJumpModeLabel.Parent =
    __UI.autoJumpModeRow

__UI.__L.mainJump.autoJumpModeButton =
    Instance.new("TextButton")

__UI.__L.mainJump.autoJumpModeButton.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )

__UI.__L.mainJump.autoJumpModeButton.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )

__UI.__L.mainJump.autoJumpModeButton.BorderSizePixel =
    0

__UI.__L.mainJump.autoJumpModeButton.TextSize =
    10

__UI.__L.mainJump.autoJumpModeButton.Font =
    Enum.Font.GothamBold

__UI.__L.mainJump.autoJumpModeButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

__UI.__L.mainJump.autoJumpModeButton.Parent =
    __UI.autoJumpModeRow

__UI.__L.autoJumpModeCorner =
    Instance.new("UICorner")

__UI.__L.autoJumpModeCorner.CornerRadius =
    UDim.new(
        0,
        5
    )

__UI.__L.autoJumpModeCorner.Parent =
    __UI.__L.mainJump.autoJumpModeButton

__UI.__L.mainJump.autoJumpModePicker =
    Instance.new("Frame")

__UI.__L.mainJump.autoJumpModePicker.Name =
    "AutoJumpModePicker"

__UI.__L.mainJump.autoJumpModePicker.Size =
    UDim2.new(
        0,
        88,
        0,
        94
    )

__UI.__L.mainJump.autoJumpModePicker.Position =
    UDim2.new(
        1,
        -102,
        1,
        5
    )

__UI.__L.mainJump.autoJumpModePicker.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )

__UI.__L.mainJump.autoJumpModePicker.BackgroundTransparency =
    0

__UI.__L.mainJump.autoJumpModePicker.BackgroundTransparency =
    0

__UI.__L.mainJump.autoJumpModePicker.ClipsDescendants =
    false

__UI.__L.mainJump.autoJumpModePicker.Active =
    true

__UI.__L.mainJump.autoJumpModePicker.BorderSizePixel =
    0

__UI.__L.mainJump.autoJumpModePicker.ZIndex =
    80

__UI.__L.mainJump.autoJumpModePicker.Visible =
    false

__UI.__L.mainJump.autoJumpModePicker.Parent =
    __UI.__L.Main

__UI.__L.autoJumpModePickerCorner =
    Instance.new("UICorner")

__UI.__L.autoJumpModePickerCorner.CornerRadius =
    UDim.new(
        0,
        7
    )

__UI.__L.autoJumpModePickerCorner.Parent =
    __UI.__L.mainJump.autoJumpModePicker

--// Reuse the existing local register for the picker outline.
__UI.__L.autoJumpModePickerCorner =
    Instance.new("UIStroke")

__UI.__L.autoJumpModePickerCorner.Color =
    Color3.fromRGB(
        20,
        22,
        26
    )

__UI.__L.autoJumpModePickerCorner.Thickness =
    1

__UI.__L.autoJumpModePickerCorner.Transparency =
    0

__UI.__L.autoJumpModePickerCorner.ApplyStrokeMode =
    Enum.ApplyStrokeMode.Border

__UI.__L.autoJumpModePickerCorner.Parent =
    __UI.__L.mainJump.autoJumpModePicker

__UI.__L.autoJumpModeScroll =
    Instance.new("ScrollingFrame")

__UI.__L.autoJumpModeScroll.Size =
    UDim2.new(
        1,
        -12,
        1,
        -12
    )

__UI.__L.autoJumpModeScroll.Position =
    UDim2.new(
        0,
        6,
        0,
        6
    )

__UI.__L.autoJumpModeScroll.BackgroundTransparency =
    1

__UI.__L.autoJumpModeScroll.BorderSizePixel =
    0

__UI.__L.autoJumpModeScroll.ScrollBarThickness =
    4

__UI.__L.autoJumpModeScroll.Active =
    true

__UI.__L.autoJumpModeScroll.ScrollingDirection =
    Enum.ScrollingDirection.Y

__UI.__L.autoJumpModeScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y

__UI.__L.autoJumpModeScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )

__UI.__L.autoJumpModeScroll.ZIndex =
    81

__UI.__L.autoJumpModeScroll.Parent =
    __UI.__L.mainJump.autoJumpModePicker

__UI.__L.autoJumpModeLayout =
    Instance.new("UIListLayout")

__UI.__L.autoJumpModeLayout.Padding =
    UDim.new(
        0,
        12
    )

__UI.__L.autoJumpModeLayout.HorizontalAlignment =
    Enum.HorizontalAlignment.Center

__UI.__L.autoJumpModeLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

__UI.__L.autoJumpModeLayout.Parent =
    __UI.__L.autoJumpModeScroll

__UI.__L.autoJumpModePadding =
    Instance.new("UIPadding")

__UI.__L.autoJumpModePadding.PaddingTop =
    UDim.new(
        0,
        6
    )

__UI.__L.autoJumpModePadding.PaddingBottom =
    UDim.new(
        0,
        6
    )

__UI.__L.autoJumpModePadding.Parent =
    __UI.__L.autoJumpModeScroll

__UI.__L.createAutoJumpModeOption = function(
    mode,
    text
)
    --// Clone the real Auto Jump Mode selector button so the picker
    --// buttons use the EXACT same visual base: size, background,
    --// transparency, font, text sizing and corner radius.
    local button =
        __UI.__L.mainJump.autoJumpModeButton:Clone()

    button.Name =
        "AutoJumpMode_" .. mode

    button.Position =
        UDim2.fromScale(
            0,
            0
        )

    button.Size =
        __UI.__L.mainJump.autoJumpModeButton.Size

    button.AnchorPoint =
        __UI.__L.mainJump.autoJumpModeButton.AnchorPoint

    button.Text =
        text

    local buttonHolder =
        Instance.new("Frame")

    buttonHolder.Name =
        "AutoJumpModeHolder_" .. mode

    buttonHolder.Size =
        button.Size

    buttonHolder.BackgroundTransparency =
        1

    buttonHolder.BorderSizePixel =
        0

    buttonHolder.LayoutOrder =
        mode == "legit"
        and 1
        or 2

    buttonHolder.ZIndex =
        82

    buttonHolder.Parent =
        __UI.__L.autoJumpModeScroll

    button.ZIndex =
        83

    button.Parent =
        buttonHolder

    __UI.__L.mainConnect(
        button.MouseButton1Click:Connect(
            function()
                __UI.__L.mainJump.setAutoJumpMode(
                    mode
                )

                __UI.__L.mainJump.autoJumpModePicker.Visible =
                    false

                pcall(function()
                    __UI.setAutoJumpModePickerHoverSuppressed(
                        false
                    )
                end)
            end
        )
    )

    return button
end

__UI.__L.createAutoJumpModeOption(
    "legit",
    "LEGIT"
)

__UI.__L.createAutoJumpModeOption(
    "rage",
    "RAGE"
)

__UI.__L.positionAutoJumpModePicker = function()
    local picker =
        __UI.__L.mainJump.autoJumpModePicker

    local button =
        __UI.__L.mainJump.autoJumpModeButton

    if not picker
        or not button
        or not button.Parent
        or not __UI.__L.Main
    then
        return
    end

    local mainPosition =
        __UI.__L.Main.AbsolutePosition

    local buttonPosition =
        button.AbsolutePosition

    local x =
        buttonPosition.X
        - mainPosition.X
        + (
            button.AbsoluteSize.X
            - picker.AbsoluteSize.X
        )
        / 2

    local y =
        buttonPosition.Y
        - mainPosition.Y
        + button.AbsoluteSize.Y
        + 5

    picker.Position =
        UDim2.fromOffset(
            x,
            y
        )
end

__UI.__L.mainConnect(
    __UI.__L.mainJump.autoJumpModeButton.MouseButton1Click:Connect(
        function()
            local picker =
                __UI.__L.mainJump.autoJumpModePicker

            if not picker then
                return
            end

            picker.Visible =
                not picker.Visible

            pcall(function()
                __UI.setAutoJumpModePickerHoverSuppressed(
                    picker.Visible
                )
            end)

            if picker.Visible then
                __UI.__L.positionAutoJumpModePicker()
            end
        end
    )
)

__UI.__L.mainConnect(
    UserInputService.InputBegan:Connect(
        function(input, gameProcessed)
            if gameProcessed then
                return
            end

            if input.UserInputType ~=
                    Enum.UserInputType.MouseButton1
                and input.UserInputType ~=
                    Enum.UserInputType.Touch
            then
                return
            end

            local picker =
                __UI.__L.mainJump.autoJumpModePicker

            local button =
                __UI.__L.mainJump.autoJumpModeButton

            if not picker
                or not picker.Visible
            then
                return
            end

            local inputPosition =
                input.Position

            local function inside(guiObject)
                if not guiObject
                    or not guiObject.Visible
                then
                    return false
                end

                local position =
                    guiObject.AbsolutePosition

                local size =
                    guiObject.AbsoluteSize

                return inputPosition.X >= position.X
                    and inputPosition.X <= position.X + size.X
                    and inputPosition.Y >= position.Y
                    and inputPosition.Y <= position.Y + size.Y
            end

            --// Clicking the selector itself is handled by its own
            --// MouseButton1Click connection; do not close it here.
            if inside(picker)
                or inside(button)
            then
                return
            end

            picker.Visible =
                false

            pcall(function()
                __UI.setAutoJumpModePickerHoverSuppressed(
                    false
                )
            end)
        end
    )
)

__UI.lookRow =
    __UI.__L.mainRow(
        "LOOK",
        3
    )
__UI.__L.lookLabel =
    __UI.__L.autoLabel:Clone()
__UI.__L.lookLabel.Text =
    "LOOK"
__UI.__L.lookLabel.Parent =
    __UI.lookRow
__UI.__L.mainJump.lookToggle =
    Instance.new("TextButton")
__UI.__L.mainJump.lookToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
__UI.__L.mainJump.lookToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
__UI.__L.mainJump.lookToggle.BorderSizePixel = 0
__UI.__L.mainJump.lookToggle.TextSize = 10
__UI.__L.mainJump.lookToggle.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.lookToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.lookToggle.Parent =
    __UI.lookRow
__UI.lookToggleCorner =
    Instance.new("UICorner")
__UI.lookToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.lookToggleCorner.Parent =
    __UI.__L.mainJump.lookToggle
__UI.__L.mainConnect(
    __UI.__L.mainJump.lookToggle.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.setLookEnabled(
                not __UI.__L.mainJump.lookEnabled
            )
        end
    )
)

__UI.rageLookRow =
    __UI.__L.mainRow(
        "RAGE LOOK",
        4
    )
__UI.__L.rageLookLabel =
    __UI.__L.autoLabel:Clone()
__UI.__L.rageLookLabel.Text =
    "RAGE LOOK"
__UI.__L.rageLookLabel.Parent =
    __UI.rageLookRow

__UI.__L.mainJump.rageLookToggle =
    Instance.new("TextButton")
__UI.__L.mainJump.rageLookToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
__UI.__L.mainJump.rageLookToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
__UI.__L.mainJump.rageLookToggle.BorderSizePixel = 0
__UI.__L.mainJump.rageLookToggle.TextSize = 10
__UI.__L.mainJump.rageLookToggle.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.rageLookToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.rageLookToggle.Parent =
    __UI.rageLookRow

__UI.rageLookToggleCorner =
    Instance.new("UICorner")
__UI.rageLookToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.rageLookToggleCorner.Parent =
    __UI.__L.mainJump.rageLookToggle

__UI.__L.mainConnect(
    __UI.__L.mainJump.rageLookToggle.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.setRageLookEnabled(
                not __UI.__L.mainJump.rageLookEnabled
            )
        end
    )
)

__UI.airTurnRow =
    __UI.__L.mainRow(
        "AIR TURN",
        5
    )
__UI.__L.airTurnLabel =
    __UI.__L.autoLabel:Clone()
__UI.__L.airTurnLabel.Text =
    "AIR TURN"
__UI.__L.airTurnLabel.Parent =
    __UI.airTurnRow

__UI.__L.mainJump.airTurnHotkeyBox =
    Instance.new("TextButton")
__UI.__L.mainJump.airTurnHotkeyBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
__UI.__L.mainJump.airTurnHotkeyBox.Position =
    UDim2.new(
        1,
        -155,
        0.5,
        -14
    )
__UI.__L.mainJump.airTurnHotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.mainJump.airTurnHotkeyBox.BorderSizePixel = 0
__UI.__L.mainJump.airTurnHotkeyBox.Text =
    __UI.__L.mainJump.airTurnHotkeyName
__UI.__L.mainJump.airTurnHotkeyBox.TextSize = 10
__UI.__L.mainJump.airTurnHotkeyBox.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.airTurnHotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.airTurnHotkeyBox.Parent =
    __UI.airTurnRow

__UI.__L.airTurnHotkeyCorner =
    Instance.new("UICorner")
__UI.__L.airTurnHotkeyCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.airTurnHotkeyCorner.Parent =
    __UI.__L.mainJump.airTurnHotkeyBox

__UI.__L.mainConnect(
    __UI.__L.mainJump.airTurnHotkeyBox.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.startCapture(
                "airTurn"
            )
        end
    )
)

__UI.__L.mainJump.airTurnToggle =
    Instance.new("TextButton")
__UI.__L.mainJump.airTurnToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
__UI.__L.mainJump.airTurnToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
__UI.__L.mainJump.airTurnToggle.BorderSizePixel =
    0
__UI.__L.mainJump.airTurnToggle.TextSize =
    10
__UI.__L.mainJump.airTurnToggle.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.airTurnToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.airTurnToggle.Parent =
    __UI.airTurnRow
__UI.airTurnToggleCorner =
    Instance.new("UICorner")
__UI.airTurnToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.airTurnToggleCorner.Parent =
    __UI.__L.mainJump.airTurnToggle
__UI.__L.mainConnect(
    __UI.__L.mainJump.airTurnToggle.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.setAirTurnEnabled(
                not __UI.__L.mainJump.airTurnEnabled
            )
        end
    )
)

__UI.smartAirTurnRow =
    __UI.__L.mainRow(
        "SMART AIR TURN",
        6
    )

__UI.__L.smartAirTurnLabel =
    __UI.__L.autoLabel:Clone()
__UI.__L.smartAirTurnLabel.Text =
    "SMART AIR TURN"
__UI.__L.smartAirTurnLabel.Parent =
    __UI.smartAirTurnRow

__UI.__L.mainJump.smartAirTurnToggle =
    Instance.new("TextButton")
__UI.__L.mainJump.smartAirTurnToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
__UI.__L.mainJump.smartAirTurnToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
__UI.__L.mainJump.smartAirTurnToggle.BorderSizePixel = 0
__UI.__L.mainJump.smartAirTurnToggle.TextSize = 10
__UI.__L.mainJump.smartAirTurnToggle.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.smartAirTurnToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.smartAirTurnToggle.Parent =
    __UI.smartAirTurnRow

__UI.__L.smartAirTurnToggleCorner =
    Instance.new("UICorner")
__UI.__L.smartAirTurnToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.smartAirTurnToggleCorner.Parent =
    __UI.__L.mainJump.smartAirTurnToggle

__UI.__L.mainConnect(
    __UI.__L.mainJump.smartAirTurnToggle.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.setSmartAirTurnEnabled(
                not __UI.__L.mainJump.smartAirTurnEnabled
            )
        end
    )
)

__UI.airTurnSpeedRow =
    __UI.__L.mainRow(
        "TURN SPEED",
        7
    )
__UI.__L.airTurnSpeedLabel =
    __UI.__L.autoLabel:Clone()
__UI.__L.airTurnSpeedLabel.Text =
    "TURN SPEED"
__UI.__L.airTurnSpeedLabel.Parent =
    __UI.airTurnSpeedRow

__UI.__L.mainJump.airTurnSliderTrack =
    Instance.new("Frame")
__UI.__L.mainJump.airTurnSliderTrack.Size =
    UDim2.new(
        1,
        -190,
        0,
        6
    )
__UI.__L.mainJump.airTurnSliderTrack.Position =
    UDim2.new(
        0,
        105,
        0.5,
        -3
    )
__UI.__L.mainJump.airTurnSliderTrack.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.mainJump.airTurnSliderTrack.BorderSizePixel =
    0
__UI.__L.mainJump.airTurnSliderTrack.Active =
    true
__UI.__L.mainJump.airTurnSliderTrack.Parent =
    __UI.airTurnSpeedRow

__UI.airTurnSliderTrackCorner =
    Instance.new("UICorner")
__UI.airTurnSliderTrackCorner.CornerRadius =
    UDim.new(
        1,
        0
    )
__UI.airTurnSliderTrackCorner.Parent =
    __UI.__L.mainJump.airTurnSliderTrack

__UI.__L.mainJump.airTurnSliderFill =
    Instance.new("Frame")
__UI.__L.mainJump.airTurnSliderFill.Size =
    UDim2.new(
        0,
        0,
        1,
        0
    )
__UI.__L.mainJump.airTurnSliderFill.BackgroundColor3 =
    Color3.fromRGB(
        82,
        88,
        100
    )
__UI.__L.mainJump.airTurnSliderFill.BorderSizePixel =
    0
__UI.__L.mainJump.airTurnSliderFill.Parent =
    __UI.__L.mainJump.airTurnSliderTrack

__UI.airTurnSliderFillCorner =
    Instance.new("UICorner")
__UI.airTurnSliderFillCorner.CornerRadius =
    UDim.new(
        1,
        0
    )
__UI.airTurnSliderFillCorner.Parent =
    __UI.__L.mainJump.airTurnSliderFill

__UI.__L.mainJump.airTurnSliderKnob =
    Instance.new("Frame")
__UI.__L.mainJump.airTurnSliderKnob.Size =
    UDim2.new(
        0,
        10,
        0,
        10
    )
__UI.__L.mainJump.airTurnSliderKnob.AnchorPoint =
    Vector2.new(
        0,
        0.5
    )
__UI.__L.mainJump.airTurnSliderKnob.BackgroundColor3 =
    Color3.fromRGB(
        205,
        205,
        205
    )
__UI.__L.mainJump.airTurnSliderKnob.BorderSizePixel =
    0
__UI.__L.mainJump.airTurnSliderKnob.Parent =
    __UI.__L.mainJump.airTurnSliderTrack

__UI.airTurnSliderKnobCorner =
    Instance.new("UICorner")
__UI.airTurnSliderKnobCorner.CornerRadius =
    UDim.new(
        1,
        0
    )
__UI.airTurnSliderKnobCorner.Parent =
    __UI.__L.mainJump.airTurnSliderKnob

__UI.__L.mainJump.airTurnSpeedValue =
    Instance.new("TextLabel")
__UI.__L.mainJump.airTurnSpeedValue.Size =
    UDim2.new(
        0,
        62,
        0,
        28
    )
__UI.__L.mainJump.airTurnSpeedValue.Position =
    UDim2.new(
        1,
        -74,
        0.5,
        -14
    )
__UI.__L.mainJump.airTurnSpeedValue.BackgroundTransparency =
    1
__UI.__L.mainJump.airTurnSpeedValue.TextSize =
    10
__UI.__L.mainJump.airTurnSpeedValue.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.airTurnSpeedValue.TextColor3 =
    Color3.fromRGB(
        215,
        215,
        215
    )
__UI.__L.mainJump.airTurnSpeedValue.TextXAlignment =
    Enum.TextXAlignment.Right
__UI.__L.mainJump.airTurnSpeedValue.Parent =
    __UI.airTurnSpeedRow

__UI.__L.airTurnSliderDragging =
    false

__UI.__L.updateAirTurnSliderFromX = function(x)
    if not __UI.__L.mainJump.airTurnSliderTrack then
        return
    end

    local position =
        __UI.__L.mainJump.airTurnSliderTrack.AbsolutePosition.X
    local size =
        __UI.__L.mainJump.airTurnSliderTrack.AbsoluteSize.X

    if size <= 0 then
        return
    end

    local alpha =
        math.clamp(
            (x - position)
            / size,
            0,
            1
        )

    local value =
        __UI.__L.AIR_TURN_MIN_SPEED
        + (
            __UI.__L.AIR_TURN_MAX_SPEED
            - __UI.__L.AIR_TURN_MIN_SPEED
        )
        * alpha

    __UI.__L.mainJump.setAirTurnSpeed(
        value,
        false
    )
end

__UI.__L.mainConnect(
    __UI.__L.mainJump.airTurnSliderTrack.InputBegan:Connect(
        function(input)
            if input.UserInputType
                == Enum.UserInputType.MouseButton1
            then
                __UI.__L.airTurnSliderDragging =
                    true

                __UI.__L.updateAirTurnSliderFromX(
                    input.Position.X
                )
            end
        end
    )
)

__UI.__L.mainConnect(
    UserInputService.InputChanged:Connect(
        function(input)
            if not __UI.__L.airTurnSliderDragging then
                return
            end

            if input.UserInputType
                == Enum.UserInputType.MouseMovement
            then
                __UI.__L.updateAirTurnSliderFromX(
                    input.Position.X
                )
            end
        end
    )
)

__UI.__L.mainConnect(
    UserInputService.InputEnded:Connect(
        function(input)
            if input.UserInputType
                == Enum.UserInputType.MouseButton1
                and __UI.__L.airTurnSliderDragging
            then
                __UI.__L.airTurnSliderDragging =
                    false
                __UI.__L.mainJump.saveConfig()
            end
        end
    )
)

__UI.crouchSpamRow =
    __UI.__L.mainRow(
        "CROUCH SPAM",
        8
    )

__UI.__L.crouchSpamLabel =
    __UI.__L.autoLabel:Clone()
__UI.__L.crouchSpamLabel.Text =
    "CROUCH SPAM"
__UI.__L.crouchSpamLabel.Parent =
    __UI.crouchSpamRow

__UI.__L.mainJump.crouchSpamHotkeyBox =
    Instance.new("TextButton")
__UI.__L.mainJump.crouchSpamHotkeyBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
__UI.__L.mainJump.crouchSpamHotkeyBox.Position =
    UDim2.new(
        1,
        -235,
        0.5,
        -14
    )
__UI.__L.mainJump.crouchSpamHotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.mainJump.crouchSpamHotkeyBox.BorderSizePixel = 0
__UI.__L.mainJump.crouchSpamHotkeyBox.Text =
    __UI.__L.mainJump.crouchSpamHotkeyName
__UI.__L.mainJump.crouchSpamHotkeyBox.TextSize = 10
__UI.__L.mainJump.crouchSpamHotkeyBox.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.crouchSpamHotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.crouchSpamHotkeyBox.Parent =
    __UI.crouchSpamRow

__UI.__L.crouchSpamHotkeyCorner =
    Instance.new("UICorner")
__UI.__L.crouchSpamHotkeyCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.crouchSpamHotkeyCorner.Parent =
    __UI.__L.mainJump.crouchSpamHotkeyBox

__UI.__L.mainConnect(
    __UI.__L.mainJump.crouchSpamHotkeyBox.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.startCapture(
                "crouchSpam"
            )
        end
    )
)

__UI.__L.mainJump.crouchSpamDelayBox =
    Instance.new("TextBox")
__UI.__L.mainJump.crouchSpamDelayBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
__UI.__L.mainJump.crouchSpamDelayBox.Position =
    UDim2.new(
        1,
        -155,
        0.5,
        -14
    )
__UI.__L.mainJump.crouchSpamDelayBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.mainJump.crouchSpamDelayBox.BorderSizePixel = 0
__UI.__L.mainJump.crouchSpamDelayBox.ClearTextOnFocus = false
__UI.__L.mainJump.crouchSpamDelayBox.Text =
    tostring(
        __UI.__L.mainJump.crouchSpamDelay
    )
__UI.__L.mainJump.crouchSpamDelayBox.TextSize = 10
__UI.__L.mainJump.crouchSpamDelayBox.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.crouchSpamDelayBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.crouchSpamDelayBox.Parent =
    __UI.crouchSpamRow

__UI.__L.crouchSpamDelayCorner =
    Instance.new("UICorner")
__UI.__L.crouchSpamDelayCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.crouchSpamDelayCorner.Parent =
    __UI.__L.mainJump.crouchSpamDelayBox

__UI.__L.mainConnect(
    __UI.__L.mainJump.crouchSpamDelayBox.FocusLost:Connect(
        function(enterPressed)
            if enterPressed then
                __UI.__L.mainJump.setCrouchSpamDelay(
                    __UI.__L.mainJump.crouchSpamDelayBox.Text
                )
            else
                __UI.__L.mainJump.crouchSpamDelayBox.Text =
                    tostring(
                        __UI.__L.mainJump.crouchSpamDelay
                    )
            end
        end
    )
)

__UI.__L.mainJump.crouchSpamToggle =
    Instance.new("TextButton")
__UI.__L.mainJump.crouchSpamToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
__UI.__L.mainJump.crouchSpamToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
__UI.__L.mainJump.crouchSpamToggle.BackgroundColor3 =
    Color3.fromRGB(
        47,
        52,
        61
    )
__UI.__L.mainJump.crouchSpamToggle.BorderSizePixel = 0
__UI.__L.mainJump.crouchSpamToggle.TextSize = 10
__UI.__L.mainJump.crouchSpamToggle.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.crouchSpamToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.crouchSpamToggle.Parent =
    __UI.crouchSpamRow

__UI.crouchSpamToggleCorner =
    Instance.new("UICorner")
__UI.crouchSpamToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.crouchSpamToggleCorner.Parent =
    __UI.__L.mainJump.crouchSpamToggle

__UI.__L.mainConnect(
    __UI.__L.mainJump.crouchSpamToggle.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.setCrouchSpamEnabled(
                not __UI.__L.mainJump.crouchSpamEnabled
            )
        end
    )
)

--// =========================================================
--// REVERSE LOOK GUI
--// Dedicated row directly below CROUCH SPAM.
--// WITH = Reverse Look follows CROUCH SPAM.
--// SOLO = Reverse Look has its own ON/OFF toggle.
--// =========================================================
__UI.reverseLookRow =
    __UI.__L.mainRow(
        "REVERSE LOOK",
        9
    )

__UI.__L.reverseLookLabel =
    __UI.__L.autoLabel:Clone()
__UI.__L.reverseLookLabel.Text =
    "REVERSE LOOK"
__UI.__L.reverseLookLabel.Parent =
    __UI.reverseLookRow

__UI.__L.mainJump.reverseLookModeButton =
    Instance.new("TextButton")

__UI.__L.mainJump.reverseLookModeButton.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )

__UI.__L.mainJump.reverseLookModeButton.Position =
    UDim2.new(
        1,
        -155,
        0.5,
        -14
    )

__UI.__L.mainJump.reverseLookModeButton.BackgroundColor3 =
    Color3.fromRGB(
        34,
        34,
        34
    )

__UI.__L.mainJump.reverseLookModeButton.BorderSizePixel =
    0

__UI.__L.mainJump.reverseLookModeButton.AutoButtonColor =
    false

__UI.__L.mainJump.reverseLookModeButton.Text =
    ""

__UI.__L.mainJump.reverseLookModeButton.Parent =
    __UI.reverseLookRow

__UI.__L.reverseLookModeCorner =
    Instance.new("UICorner")

__UI.__L.reverseLookModeCorner.CornerRadius =
    UDim.new(
        0,
        5
    )

__UI.__L.reverseLookModeCorner.Parent =
    __UI.__L.mainJump.reverseLookModeButton

__UI.__L.mainJump.reverseLookModeKnob =
    Instance.new("Frame")

__UI.__L.mainJump.reverseLookModeKnob.Size =
    UDim2.new(
        0,
        34,
        0,
        24
    )

__UI.__L.mainJump.reverseLookModeKnob.Position =
    UDim2.new(
        0,
        36,
        0.5,
        -12
    )

__UI.__L.mainJump.reverseLookModeKnob.BackgroundColor3 =
    Color3.fromRGB(
        68,
        74,
        84
    )

__UI.__L.mainJump.reverseLookModeKnob.BorderSizePixel =
    0

__UI.__L.mainJump.reverseLookModeKnob.Active =
    false

__UI.__L.mainJump.reverseLookModeKnob.Parent =
    __UI.__L.mainJump.reverseLookModeButton

__UI.__L.reverseLookModeKnobCorner =
    Instance.new("UICorner")

__UI.__L.reverseLookModeKnobCorner.CornerRadius =
    UDim.new(
        0,
        5
    )

__UI.__L.reverseLookModeKnobCorner.Parent =
    __UI.__L.mainJump.reverseLookModeKnob

__UI.__L.mainJump.reverseLookModeWithLabel =
    Instance.new("TextLabel")

__UI.__L.mainJump.reverseLookModeWithLabel.Size =
    UDim2.new(
        0,
        34,
        0,
        28
    )

__UI.__L.mainJump.reverseLookModeWithLabel.Position =
    UDim2.new(
        0,
        2,
        0,
        0
    )

__UI.__L.mainJump.reverseLookModeWithLabel.BackgroundTransparency =
    1

__UI.__L.mainJump.reverseLookModeWithLabel.Text =
    "WITH"

__UI.__L.mainJump.reverseLookModeWithLabel.TextSize =
    8

__UI.__L.mainJump.reverseLookModeWithLabel.Font =
    Enum.Font.GothamBold

__UI.__L.mainJump.reverseLookModeWithLabel.TextColor3 =
    Color3.fromRGB(
        145,
        145,
        145
    )

__UI.__L.mainJump.reverseLookModeWithLabel.TextXAlignment =
    Enum.TextXAlignment.Center

__UI.__L.mainJump.reverseLookModeWithLabel.Parent =
    __UI.__L.mainJump.reverseLookModeButton

__UI.__L.mainJump.reverseLookModeSoloLabel =
    Instance.new("TextLabel")

__UI.__L.mainJump.reverseLookModeSoloLabel.Size =
    UDim2.new(
        0,
        34,
        0,
        28
    )

__UI.__L.mainJump.reverseLookModeSoloLabel.Position =
    UDim2.new(
        0,
        37,
        0,
        0
    )

__UI.__L.mainJump.reverseLookModeSoloLabel.BackgroundTransparency =
    1

__UI.__L.mainJump.reverseLookModeSoloLabel.Text =
    "SOLO"

__UI.__L.mainJump.reverseLookModeSoloLabel.TextSize =
    8

__UI.__L.mainJump.reverseLookModeSoloLabel.Font =
    Enum.Font.GothamBold

__UI.__L.mainJump.reverseLookModeSoloLabel.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

__UI.__L.mainJump.reverseLookModeSoloLabel.TextXAlignment =
    Enum.TextXAlignment.Center

__UI.__L.mainJump.reverseLookModeSoloLabel.Parent =
    __UI.__L.mainJump.reverseLookModeButton

__UI.__L.mainConnect(
    __UI.__L.mainJump.reverseLookModeButton.MouseButton1Click:Connect(
        function()
            local newMode

            if __UI.__L.mainJump.reverseLookMode
                == "with"
            then
                newMode =
                    "without"
            else
                newMode =
                    "with"
            end

            __UI.__L.mainJump.setReverseLookMode(
                newMode
            )
        end
    )
)

--// Reverse Look standalone toggle.
__UI.__L.mainJump.reverseLookToggle =
    Instance.new("TextButton")

__UI.__L.mainJump.reverseLookToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )

__UI.__L.mainJump.reverseLookToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )

__UI.__L.mainJump.reverseLookToggle.BackgroundColor3 =
    Color3.fromRGB(
        47,
        52,
        61
    )

__UI.__L.mainJump.reverseLookToggle.BorderSizePixel =
    0

__UI.__L.mainJump.reverseLookToggle.TextSize =
    10

__UI.__L.mainJump.reverseLookToggle.Font =
    Enum.Font.GothamBold

__UI.__L.mainJump.reverseLookToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

__UI.__L.mainJump.reverseLookToggle.AutoButtonColor =
    false

__UI.__L.mainJump.reverseLookToggle.Parent =
    __UI.reverseLookRow

__UI.__L.reverseLookToggleCorner =
    Instance.new("UICorner")

__UI.__L.reverseLookToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )

__UI.__L.reverseLookToggleCorner.Parent =
    __UI.__L.mainJump.reverseLookToggle

__UI.__L.mainConnect(
    __UI.__L.mainJump.reverseLookToggle.MouseButton1Click:Connect(
        function()
            if __UI.__L.mainJump.reverseLookMode
                ~= "without"
            then
                return
            end

            __UI.__L.mainJump.setReverseLookEnabled(
                not __UI.__L.mainJump.reverseLookEnabled
            )
        end
    )
)

__UI.__L.mainJump.updateReverseLookUI(
    false
)

__UI.benchTrimpRow =
    __UI.__L.mainRow(
        "BENCH TRIMP",
        10
    )

__UI.__L.benchTrimpLabel =
    __UI.__L.autoLabel:Clone()
__UI.__L.benchTrimpLabel.Text =
    "BENCH TRIMP"
__UI.__L.benchTrimpLabel.Parent =
    __UI.benchTrimpRow

__UI.__L.mainJump.benchTrimpHotkeyBox =
    Instance.new("TextButton")
__UI.__L.mainJump.benchTrimpHotkeyBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
__UI.__L.mainJump.benchTrimpHotkeyBox.Position =
    UDim2.new(
        1,
        -155,
        0.5,
        -14
    )
__UI.__L.mainJump.benchTrimpHotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.mainJump.benchTrimpHotkeyBox.BorderSizePixel = 0
__UI.__L.mainJump.benchTrimpHotkeyBox.Text =
    __UI.__L.mainJump.benchTrimpHotkeyName
__UI.__L.mainJump.benchTrimpHotkeyBox.TextSize = 10
__UI.__L.mainJump.benchTrimpHotkeyBox.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.benchTrimpHotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.benchTrimpHotkeyBox.Parent =
    __UI.benchTrimpRow

__UI.__L.benchTrimpHotkeyCorner =
    Instance.new("UICorner")
__UI.__L.benchTrimpHotkeyCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.benchTrimpHotkeyCorner.Parent =
    __UI.__L.mainJump.benchTrimpHotkeyBox

__UI.__L.mainConnect(
    __UI.__L.mainJump.benchTrimpHotkeyBox.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.startCapture(
                "benchTrimp"
            )
        end
    )
)

__UI.__L.mainJump.benchTrimpToggle =
    Instance.new("TextButton")
__UI.__L.mainJump.benchTrimpToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
__UI.__L.mainJump.benchTrimpToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
__UI.__L.mainJump.benchTrimpToggle.BackgroundColor3 =
    Color3.fromRGB(
        47,
        52,
        61
    )
__UI.__L.mainJump.benchTrimpToggle.BorderSizePixel = 0
__UI.__L.mainJump.benchTrimpToggle.TextSize = 10
__UI.__L.mainJump.benchTrimpToggle.Font =
    Enum.Font.GothamBold
__UI.__L.mainJump.benchTrimpToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.benchTrimpToggle.Parent =
    __UI.benchTrimpRow

__UI.__L.benchTrimpToggleCorner =
    Instance.new("UICorner")
__UI.__L.benchTrimpToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.benchTrimpToggleCorner.Parent =
    __UI.__L.mainJump.benchTrimpToggle

__UI.__L.mainConnect(
    __UI.__L.mainJump.benchTrimpToggle.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.setBenchTrimpEnabled(
                not __UI.__L.mainJump.benchTrimpEnabled
            )
        end
    )
)


--// HIDE UI MUST ALWAYS BE THE LOWEST / LAST ROW IN MAIN.
__UI.hideRow =
    __UI.__L.mainRow(
        "HIDE UI",
        11
    )
__UI.hideLabel =
    __UI.__L.autoLabel:Clone()
__UI.hideLabel.Text =
    "HIDE UI"
__UI.hideLabel.Parent =
    __UI.hideRow
__UI.__L.mainJump.hideUIHotkeyBox =
    Instance.new("TextButton")
__UI.__L.mainJump.hideUIHotkeyBox.Size =
    UDim2.new(
        1,
        -120,
        0,
        28
    )
__UI.__L.mainJump.hideUIHotkeyBox.Position =
    UDim2.new(
        0,
        105,
        0.5,
        -14
    )
__UI.__L.mainJump.hideUIHotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.mainJump.hideUIHotkeyBox.BorderSizePixel = 0
__UI.__L.mainJump.hideUIHotkeyBox.Text =
    __UI.__L.mainJump.hideUIHotkeyName
__UI.__L.mainJump.hideUIHotkeyBox.TextSize = 11
__UI.__L.mainJump.hideUIHotkeyBox.Font =
            Enum.Font.GothamBold
__UI.__L.mainJump.hideUIHotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.mainJump.hideUIHotkeyBox.Parent =
    __UI.hideRow
__UI.hideCorner =
    Instance.new("UICorner")
__UI.hideCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.hideCorner.Parent =
    __UI.__L.mainJump.hideUIHotkeyBox
__UI.__L.mainConnect(
    __UI.__L.mainJump.hideUIHotkeyBox.MouseButton1Click:Connect(
        function()
            __UI.__L.mainJump.startCapture(
                "hide"
            )
        end
    )
)

__UI.__L.mainConnect(
    UserInputService.InputBegan:Connect(
        function(input)
            if __UI.__L.mainJump.capturing then
                local keyCode =
                    input.KeyCode
                if not keyCode
                    or keyCode
                        == Enum.KeyCode.Unknown
                then
                    return
                end
                if __UI.__L.mainJump.capturing
                    == "jump"
                then
                    __UI.__L.mainJump.setHotkey(
                        keyCode.Name
                    )
                elseif __UI.__L.mainJump.capturing
                    == "hide"
                then
                    __UI.__L.mainJump.setHideUIHotkey(
                        keyCode.Name
                    )
                elseif __UI.__L.mainJump.capturing
                    == "airTurn"
                then
                    __UI.__L.mainJump.setAirTurnHotkey(
                        keyCode.Name
                    )
                elseif __UI.__L.mainJump.capturing
                    == "crouchSpam"
                then
                    __UI.__L.mainJump.setCrouchSpamHotkey(
                        keyCode.Name
                    )
                elseif __UI.__L.mainJump.capturing
                    == "benchTrimp"
                then
                    __UI.__L.mainJump.setBenchTrimpHotkey(
                        keyCode.Name
                    )
                end
                return
            end

            if input.KeyCode
                == __UI.__L.mainFindKeyCode(
                    __UI.__L.mainJump.hotkeyName
                )
            then
                __UI.__L.mainJump.setEnabled(
                    not __UI.__L.mainJump.enabled
                )
            end
            if input.KeyCode
                == __UI.__L.mainFindKeyCode(
                    __UI.__L.mainJump.hideUIHotkeyName
                )
            then
                __UI.__L.ScreenGui.Enabled =
                    not __UI.__L.ScreenGui.Enabled
            end

            if input.KeyCode
                == __UI.__L.mainFindKeyCode(
                    __UI.__L.mainJump.airTurnHotkeyName
                )
            then
                __UI.__L.mainJump.setAirTurnEnabled(
                    not __UI.__L.mainJump.airTurnEnabled
                )
            end

            if input.KeyCode
                == __UI.__L.mainFindKeyCode(
                    __UI.__L.mainJump.crouchSpamHotkeyName
                )
            then
                __UI.__L.mainJump.setCrouchSpamEnabled(
                    not __UI.__L.mainJump.crouchSpamEnabled
                )
            end

            if input.KeyCode
                == __UI.__L.mainFindKeyCode(
                    __UI.__L.mainJump.benchTrimpHotkeyName
                )
            then
                __UI.__L.mainJump.setBenchTrimpEnabled(
                    not __UI.__L.mainJump.benchTrimpEnabled
                )
            end
        end
    )
)
__UI.__L.mainConnect(
    UserInputService.JumpRequest:Connect(
        function()
            if __UI.__L.mainJump.enabled
                and __UI.__L.mainJump.humanoid
                and __UI.__L.mainJump.humanoid.Parent
            then
                __UI.__L.mainJump.manualJumpActive = true
                __UI.__L.mainJump.lookAutoJumpCycle = false
                __UI.__L.mainJump.lookTriggeredThisAir = true

                if __UI.__L.mainJump.lookActive then
                    __UI.__L.mainJump.endLook()
                end
            end
        end
    )
)
__UI.__L.mainConnect(
    UserInputService.JumpRequest:Connect(
        function()
            if __UI.__L.mainJump.enabled
                or not genv.DEADEYE_MAIN_RUNNING
                or not __UI.__L.mainJump.needsInputRearm
                or not __UI.__L.mainJump.humanoid
                or not __UI.__L.mainJump.humanoid.Parent
            then
                return
            end

            local humanoid =
                __UI.__L.mainJump.humanoid

            if humanoid.Health <= 0
                or humanoid.FloorMaterial
                    == Enum.Material.Air
                or humanoid.PlatformStand
                or humanoid.Sit
                or humanoid.SeatPart
            then
                return
            end

            local state =
                humanoid:GetState()

            if state
                    ~= Enum.HumanoidStateType.Running
            then
                return
            end

            --// The first Space after AutoJump is disabled can be
            --// consumed by the game's jump-state transition.
            --// Re-arm it using the same mechanism that fixed the
            --// original first-jump loss. Game restrictions are
            --// checked above through the humanoid state.
            __UI.__L.mainJump.needsInputRearm = false

            pcall(function()
                humanoid:SetStateEnabled(
                    Enum.HumanoidStateType.Jumping,
                    true
                )
                humanoid.Jump = true
                humanoid:ChangeState(
                    Enum.HumanoidStateType.Jumping
                )
            end)

            task.defer(function()
                if not genv.DEADEYE_MAIN_RUNNING
                    or __UI.__L.mainJump.enabled
                    or not humanoid.Parent
                then
                    return
                end

                for _ = 1, 3 do
                    local canRearm =
                        true

                    pcall(function()
                        if humanoid.Health <= 0
                            or humanoid.PlatformStand
                            or humanoid.Sit
                            or humanoid.SeatPart
                            or humanoid.FloorMaterial
                                == Enum.Material.Air
                            or humanoid:GetState()
                                ~= Enum.HumanoidStateType.Running
                        then
                            canRearm = false
                        end
                    end)

                    if not canRearm then
                        return
                    end

                    pcall(function()
                        humanoid:SetStateEnabled(
                            Enum.HumanoidStateType.Jumping,
                            true
                        )
                        humanoid.Jump = true
                        humanoid:ChangeState(
                            Enum.HumanoidStateType.Jumping
                        )
                    end)

                    task.wait()
                end
            end)
        end
    )
)
__UI.__L.mainConnect(
    UserInputService.InputEnded:Connect(
        function(input)
            if input.KeyCode
                == Enum.KeyCode.Space
                and not __UI.__L.mainJump.enabled
                and __UI.__L.mainJump.humanoid
                and __UI.__L.mainJump.humanoid.Parent
            then
                pcall(function()
                    __UI.__L.mainJump.humanoid.Jump = false
                end)
            end
        end
    )
)
__UI.__L.mainConnect(
    LocalPlayer.CharacterAdded:Connect(
        function(char)
            task.wait(0.2)

            __UI.__L.mainJump.crouchSpamMovement =
                nil

            if genv.DEADEYE_MAIN_RUNNING then
                __UI.__L.mainJump.setupAutoJumpCharacter(
                    char
                )
                __UI.__L.mainJump.bindBenchTrimp(
                    char
                )
            end
        end
    )
)

if LocalPlayer.Character
    and genv.DEADEYE_MAIN_RUNNING
then
    task.spawn(
        function()
            if not genv.DEADEYE_MAIN_RUNNING then
                return
            end

            __UI.__L.mainJump.setupAutoJumpCharacter(
                LocalPlayer.Character
            )

            __UI.__L.mainJump.bindBenchTrimp(
                LocalPlayer.Character
            )
        end
    )
end
pcall(function()
    __UI.__L.mainJump.installReverseLookHooks()
end)

__UI.__L.mainJump.setAirTurnSpeed(
    __UI.__L.mainJump.airTurnSpeed,
    false
)
__UI.__L.mainJump.setCrouchSpamDelay(
    __UI.__L.mainJump.crouchSpamDelay
)

if __UI.__L.mainJump.benchTrimpEnabled then
    pcall(function()
        __UI.__L.mainJump.bindBenchTrimp(
            __UI.__L.mainJump.character
            or LocalPlayer.Character
        )
    end)
end

__UI.__L.mainJump.update()

if __UI.__L.mainJump.rageLookEnabled then
    __UI.__L.mainJump.rageLookEnabled =
        false

    __UI.__L.mainJump.setRageLookEnabled(
        true,
        true
    )
end

if __UI.__L.mainJump.airTurnEnabled
    and __UI.__L.mainJump.enabled
then
    __UI.__L.mainJump.findLookMovementState()
    __UI.__L.mainJump.bindAirTurnRender()
end

genv.DEADEYE_MAIN_AIR_TURN_CLEANUP =
    function()
        pcall(function()
            __UI.__L.mainJump.unbindAirTurnRender()
        end)
    end

genv.DEADEYE_REVERSE_LOOK =
    function(state)
        __UI.__L.mainJump.setReverseLookEnabled(
            state
        )
    end

genv.DEADEYE_REVERSE_LOOK_CLEANUP =
    function()
        pcall(function()
            __UI.__L.mainJump.setReverseLookEnabled(
                false,
                false
            )
        end)

        pcall(function()
            __UI.__L.mainJump.uninstallReverseLookHooks()
        end)
    end

genv.DEADEYE_RAGE_LOOK =
    function(state)
        __UI.__L.mainJump.setRageLookEnabled(
            state
        )
    end

genv.DEADEYE_RAGE_LOOK_CLEANUP =
    function()
        pcall(function()
            __UI.__L.mainJump.setRageLookEnabled(
                false,
                false
            )
        end)
    end

genv.DEADEYE_MAIN_SENSORS_CLEANUP =
    function()
        pcall(function()
            __UI.__L.mainJump.destroySensors()
        end)

        __UI.__L.purgeStaleMainJumpSensors()
    end
--// =========================================================
--// OTHERS PAGE
--// =========================================================
__UI.__L.others.page =
    Instance.new("ScrollingFrame")
__UI.__L.others.page.Name =
    "OthersPage"
__UI.__L.others.page.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
__UI.__L.others.page.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
__UI.__L.others.page.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.others.page.BorderSizePixel =
    0
__UI.__L.others.page.ScrollBarThickness =
    6
__UI.__L.others.page.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
__UI.__L.others.page.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
__UI.__L.others.page.ScrollingDirection =
    Enum.ScrollingDirection.Y
__UI.__L.others.page.Visible =
    false
__UI.__L.others.page.Parent =
    __UI.__L.Main
__UI.__L.others.pageCorner =
    Instance.new("UICorner")
__UI.__L.others.pageCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
__UI.__L.others.pageCorner.Parent =
    __UI.__L.others.page
__UI.__L.others.padding =
    Instance.new("UIPadding")
__UI.__L.others.padding.PaddingTop =
    UDim.new(
        0,
        8
    )
__UI.__L.others.padding.PaddingBottom =
    UDim.new(
        0,
        8
    )
__UI.__L.others.padding.PaddingLeft =
    UDim.new(
        0,
        8
    )
__UI.__L.others.padding.PaddingRight =
    UDim.new(
        0,
        8
    )
__UI.__L.others.padding.Parent =
    __UI.__L.others.page
__UI.__L.others.layout =
    Instance.new("UIListLayout")
__UI.__L.others.layout.Padding =
    UDim.new(
        0,
        6
    )
__UI.__L.others.layout.SortOrder =
    Enum.SortOrder.LayoutOrder
__UI.__L.others.layout.Parent =
    __UI.__L.others.page
function __UI.__L.others.header(
    textValue,
    orderValue
)
    local header =
        Instance.new("TextLabel")
    header.Size =
        UDim2.new(
            1,
            -4,
            0,
            24
        )
    header.BackgroundTransparency =
        1
    header.Text =
        textValue
    header.TextSize =
        10
    header.Font =
        Enum.Font.GothamBold
    header.TextColor3 =
        Color3.fromRGB(
            150,
            150,
            150
        )
    header.TextXAlignment =
        Enum.TextXAlignment.Left
    header.LayoutOrder =
        orderValue
    header.Parent =
        __UI.__L.others.page
end
function __UI.__L.others.row(
    slot,
    orderValue
)
    local row =
        Instance.new("Frame")
    row.Name =
        "Slot_" ..
        slot.property
    row.Size =
        UDim2.new(
            1,
            -4,
            0,
            40
        )
    row.BackgroundColor3 =
        Color3.fromRGB(
            40,
            40,
            40
        )
    row.BorderSizePixel =
        0
    row.LayoutOrder =
        orderValue
    row.Parent =
        __UI.__L.others.page
    local corner =
        Instance.new("UICorner")
    corner.CornerRadius =
        UDim.new(
            0,
            6
        )
    corner.Parent =
        row
    local label =
        Instance.new("TextLabel")
    label.Size =
        UDim2.new(
            0,
            105,
            1,
            0
        )
    label.Position =
        UDim2.new(
            0,
            10,
            0,
            0
        )
    label.BackgroundTransparency =
        1
    label.Text =
        slot.label
    label.TextSize =
        11
    label.Font =
        Enum.Font.GothamBold
    label.TextColor3 =
        Color3.fromRGB(
            215,
            215,
            215
        )
    label.TextXAlignment =
        Enum.TextXAlignment.Left
    label.Parent =
        row
    local box =
        Instance.new("TextBox")
    box.Size =
        UDim2.new(
            1,
            -190,
            0,
            28
        )
    box.Position =
        UDim2.new(
            0,
            105,
            0.5,
            -14
        )
    box.BackgroundColor3 =
        Color3.fromRGB(
            32,
            32,
            32
        )
    box.BorderSizePixel =
        0
    box.ClearTextOnFocus =
        false
    box.PlaceholderText =
        slot.multi
        and "ID or ID,ID"
        or "Empty"
    box.TextSize =
        11
    box.Font =
            Enum.Font.GothamBold
    box.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )
    box.PlaceholderColor3 =
        Color3.fromRGB(
            105,
            105,
            105
        )
    box.TextXAlignment =
        Enum.TextXAlignment.Left
    box.Parent =
        row
    local boxCorner =
        Instance.new("UICorner")
    boxCorner.CornerRadius =
        UDim.new(
            0,
            5
        )
    boxCorner.Parent =
        box
    local apply =
        Instance.new("TextButton")
    apply.Size =
        UDim2.new(
            0,
            65,
            0,
            28
        )
    apply.Position =
        UDim2.new(
            1,
            -75,
            0.5,
            -14
        )
    apply.BackgroundColor3 =
        Color3.fromRGB(
            52,
            52,
            52
        )
    apply.BorderSizePixel =
        0
    apply.Text =
        "APPLY"
    apply.TextSize =
        9
    apply.Font =
        Enum.Font.GothamBold
    apply.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )
    apply.Parent =
        row
    local applyCorner =
        Instance.new("UICorner")
    applyCorner.CornerRadius =
        UDim.new(
            0,
            5
        )
    applyCorner.Parent =
        apply
    __UI.__L.others.fieldBoxes[
        slot.property
    ] =
        box
    __UI.__L.UnusualFns.addUnusualConnection(
        apply.MouseButton1Click:Connect(
            function()
                if __UI.__L.others.applyField(
                    slot,
                    box.Text
                ) then
                    __UI.__L.others.saveConfig()
                    apply.Text =
                        "OK"
                    task.delay(
                        0.7,
                        function()
                            pcall(function()
                                if apply.Parent then
                                    apply.Text =
                                        "APPLY"
                                end
                            end)
                        end
                    )
                end
            end
        )
    )
    __UI.__L.UnusualFns.addUnusualConnection(
        box.FocusLost:Connect(
            function(enterPressed)
                if enterPressed then
                    __UI.__L.others.applyField(
                        slot,
                        box.Text
                    )
                end
                --// Persist the current Others field even when the
                --// user only edits it and closes/unfocuses the GUI.
                __UI.__L.others.saveConfig()
            end
        )
    )
end
function __UI.__L.others.quickRow(
    labelText,
    property,
    assetId,
    orderValue
)
    local row =
        Instance.new("Frame")
    row.Size =
        UDim2.new(
            1,
            -4,
            0,
            40
        )
    row.BackgroundColor3 =
        Color3.fromRGB(
            40,
            40,
            40
        )
    row.BorderSizePixel =
        0
    row.LayoutOrder =
        orderValue
    row.Parent =
        __UI.__L.others.page
    local corner =
        Instance.new("UICorner")
    corner.CornerRadius =
        UDim.new(
            0,
            6
        )
    corner.Parent =
        row
    local label =
        Instance.new("TextLabel")
    label.Size =
        UDim2.new(
            1,
            -100,
            1,
            0
        )
    label.Position =
        UDim2.new(        0,
        10,
        0,
        0
    )
    label.BackgroundTransparency =
        1
    label.Text =
        labelText
    label.TextSize =
        11
    label.Font =
        Enum.Font.GothamBold
    label.TextColor3 =
        Color3.fromRGB(
            215,
            215,
            215
        )
    label.TextXAlignment =
        Enum.TextXAlignment.Left
    label.Parent =
        row
    local apply =
        Instance.new("TextButton")
    apply.Size =
        UDim2.new(
            0,
            65,
            0,
            28
        )
    apply.Position =
        UDim2.new(
            1,
            -75,
            0.5,
            -14
        )
    apply.BackgroundColor3 =
        Color3.fromRGB(
            52,
            52,
            52
        )
    apply.BorderSizePixel =
        0
    apply.Text =
        "APPLY"
    apply.TextSize =
        9
    apply.Font =
        Enum.Font.GothamBold
    apply.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )
    apply.Parent =
        row
    local applyCorner =
        Instance.new("UICorner")
    applyCorner.CornerRadius =
        UDim.new(
            0,
            5
        )
    applyCorner.Parent =
        apply
    __UI.__L.UnusualFns.addUnusualConnection(
        apply.MouseButton1Click:Connect(
            function()
                if __UI.__L.others.applyBodyPart(
                    property,
                    assetId
                ) then
                    if property == "Head" then
                        __UI.__L.savedConfig.others._Headless =
                            tostring(
                                assetId
                            )
                    elseif property == "RightLeg" then
                        __UI.__L.savedConfig.others._Korblox =
                            tostring(
                                assetId
                            )
                    end
                    saveSavedConfig()
                    apply.Text =
                        "OK"
                    task.delay(
                        0.7,
                        function()
                            pcall(function()
                                if apply.Parent then
                                    apply.Text =
                                        "APPLY"
                                end
                            end)
                        end
                    )
                end
            end
        )
    )
end
function __UI.__L.others.applyBodyPart(
    property,
    assetId
)
    local description =
        __UI.__L.others.getDescription()
    if not description then
        return false
    end
    pcall(function()
        description[property] =
            assetId
    end)
    return __UI.__L.others.applyDescription(
        description
    )
end
--// =========================================================
--// APPLY ALL OTHERS
--// Applies every current field in one HumanoidDescription call.
--// =========================================================
--// =========================================================
--// AVATAR DUMP IMPORT
--// Accepts the JSON copied from the DeadEye avatar dumper.
--// Applies items, body colors, body scales and accessory
--// adjustment data through the existing HumanoidDescription
--// pipeline used by the Others tab.
--// =========================================================
function __UI.__L.others.avatarImportVector3(value)
    if type(value) ~= "table" then
        return nil
    end

    local x = tonumber(value[1])
    local y = tonumber(value[2])
    local z = tonumber(value[3])

    if not x or not y or not z then
        return nil
    end

    return Vector3.new(x, y, z)
end

function __UI.__L.others.avatarImportColor3(value)
    if type(value) ~= "table" then
        return nil
    end

    local r = tonumber(value[1])
    local g = tonumber(value[2])
    local b = tonumber(value[3])

    if not r or not g or not b then
        return nil
    end

    return Color3.new(
        math.clamp(r, 0, 1),
        math.clamp(g, 0, 1),
        math.clamp(b, 0, 1)
    )
end

function __UI.__L.others.avatarImportAccessoryType(name)
    if type(name) ~= "string" or name == "" then
        return nil
    end

    name = string.match(
        name,
        "([^%.]+)$"
    ) or name

    local result

    pcall(function()
        result = Enum.AccessoryType[name]
    end)

    return result
end

function __UI.__L.others.parseAvatarDump(raw)
    if type(raw) ~= "string" then
        return nil, "EMPTY"
    end

    raw =
        string.gsub(
            raw,
            "^%s+",
            ""
        )

    raw =
        string.gsub(
            raw,
            "%s+$",
            ""
        )

    if raw == "" then
        return nil, "EMPTY"
    end

    local decodeOK, data =
        pcall(function()
            return __UI.__L.HttpService:JSONDecode(raw)
        end)

    if not decodeOK
        or type(data) ~= "table"
    then
        return nil, "INVALID JSON"
    end

    if type(data.items) ~= "table" then
        return nil, "NO ITEMS"
    end

    local current =
        __UI.__L.others.getDescription()

    if not current then
        return nil, "NO HUMANOID"
    end

    local cloneOK, description =
        pcall(function()
            return current:Clone()
        end)

    if not cloneOK
        or not description
    then
        return nil, "DESCRIPTION CLONE FAILED"
    end

    local multiProperties = {
        HatAccessory = true,
        HairAccessory = true,
        FaceAccessory = true,
        NeckAccessory = true,
        ShouldersAccessory = true,
        FrontAccessory = true,
        BackAccessory = true,
        WaistAccessory = true
    }

    local singleProperties = {
        Shirt = true,
        Pants = true,
        GraphicTShirt = true,
        Face = true,
        Head = true,
        Torso = true,
        LeftArm = true,
        RightArm = true,
        LeftLeg = true,
        RightLeg = true
    }

    local appliedFields = 0

    for property, rawValue in pairs(data.items) do
        if multiProperties[property] then
            local value =
                tostring(
                    rawValue or ""
                )

            value =
                string.gsub(
                    value,
                    "%s+",
                    ""
                )

            value =
                string.gsub(
                    value,
                    "[^%d,]",
                    ""
                )

            value =
                string.gsub(
                    value,
                    ",+",
                    ","
                )

            value =
                string.gsub(
                    value,
                    "^,",
                    ""
                )

            value =
                string.gsub(
                    value,
                    ",$",
                    ""
                )

            local ok =
                pcall(function()
                    description[property] =
                        value
                end)

            if ok then
                appliedFields += 1
            end
        elseif singleProperties[property] then
            local value =
                tonumber(rawValue)

            if not value then
                value =
                    tonumber(
                        string.match(
                            tostring(
                                rawValue or ""
                            ),
                            "%d+"
                        )
                    )
            end

            if value then
                local ok =
                    pcall(function()
                        description[property] =
                            value
                    end)

                if ok then
                    appliedFields += 1
                end
            end
        end
    end

    local colorProperties = {
        HeadColor = true,
        TorsoColor = true,
        LeftArmColor = true,
        RightArmColor = true,
        LeftLegColor = true,
        RightLegColor = true
    }

    if type(data.colors) == "table" then
        for property, value in pairs(
            data.colors
        ) do
            if colorProperties[property] then
                local color =
                    __UI.__L.others.avatarImportColor3(
                        value
                    )

                if color then
                    local ok =
                        pcall(function()
                            description[property] =
                                color
                        end)

                    if ok then
                        appliedFields += 1
                    end
                end
            end
        end
    end

    local scaleProperties = {
        HeightScale = true,
        WidthScale = true,
        DepthScale = true,
        HeadScale = true,
        BodyTypeScale = true,
        ProportionScale = true
    }

    if type(data.scales) == "table" then
        for property, value in pairs(
            data.scales
        ) do
            if scaleProperties[property] then
                local number =
                    tonumber(value)

                if number then
                    local ok =
                        pcall(function()
                            description[property] =
                                number
                        end)

                    if ok then
                        appliedFields += 1
                    end
                end
            end
        end
    end

    local accessoryInfo = {}

    if type(data.accessories) == "table" then
        for _, source in ipairs(
            data.accessories
        ) do
            if type(source) == "table" then
                local assetId =
                    tonumber(
                        source.AssetId
                    )

                local accessoryType =
                    __UI.__L.others.avatarImportAccessoryType(
                        source.AccessoryType
                    )

                if assetId
                    and accessoryType
                then
                    local info = {
                        AssetId = assetId,
                        AccessoryType =
                            accessoryType
                    }

                    if source.IsLayered ~= nil then
                        info.IsLayered =
                            source.IsLayered == true
                            or tostring(
                                source.IsLayered
                            ) == "true"
                    end

                    if source.Order ~= nil then
                        local order =
                            tonumber(
                                source.Order
                            )

                        if order then
                            info.Order = order
                        end
                    end

                    if source.Puffiness ~= nil then
                        local puffiness =
                            tonumber(
                                source.Puffiness
                            )

                        if puffiness then
                            info.Puffiness =
                                puffiness
                        end
                    end

                    local position =
                        __UI.__L.others.avatarImportVector3(
                            source.Position
                        )

                    local rotation =
                        __UI.__L.others.avatarImportVector3(
                            source.Rotation
                        )

                    local scale =
                        __UI.__L.others.avatarImportVector3(
                            source.Scale
                        )

                    if position then
                        info.Position =
                            position
                    end

                    if rotation then
                        info.Rotation =
                            rotation
                    end

                    if scale then
                        info.Scale =
                            scale
                    end

                    table.insert(
                        accessoryInfo,
                        info
                    )
                end
            end
        end
    end

    if #accessoryInfo > 0 then
        local accessoriesOK =
            pcall(function()
                description:SetAccessories(
                    accessoryInfo,
                    true
                )
            end)

        if accessoriesOK then
            appliedFields +=
                #accessoryInfo
        else
            warn(
                "[Others] Avatar import: SetAccessories failed"
            )
        end
    end

    if appliedFields == 0 then
        return nil, "NOTHING TO APPLY"
    end

    return description, data
end

function __UI.__L.others.applyAvatarDump(raw)
    local description, data =
        __UI.__L.others.parseAvatarDump(raw)

    if not description then
        if __UI.__L.others.status then
            __UI.__L.others.status.Text =
                "Import failed"
        end
        return false
    end

    local ok =
        __UI.__L.others.applyDescription(
            description
        )

    if not ok then
        return false
    end

    __UI.__L.others.importedDescription =
        description:Clone()

    if __UI.__L.others.status then
        local version =
            tostring(
                data.version or "?"
            )

        __UI.__L.others.status.Text =
            "Avatar imported • v"
            .. version
    end

    return true
end

function __UI.__L.others.applyAll()
    local description =
        __UI.__L.others.getDescription()
    if not description then
        return false
    end
    local groups = {
        __UI.__L.others.ACCESSORY_SLOTS,
        __UI.__L.others.CLOTHING_SLOTS,
        __UI.__L.others.BODY_SLOTS
    }
    local changed = 0
    for _, group in ipairs(
        groups
    ) do
        for _, slot in ipairs(
            group
        ) do
            local box =
                __UI.__L.others.fieldBoxes[
                    slot.property
                ]
            if box then
                local value
                if slot.multi then
                    value =
                        tostring(
                            box.Text
                            or ""
                        )
                    value =
                        string.gsub(
                            value,
                            "%s+",
                            ""
                        )
                    value =
                        string.gsub(
                            value,
                            "[^%d,]",
                            ""
                        )
                    value =
                        string.gsub(
                            value,
                            ",+",
                            ","
                        )
                    value =
                        string.gsub(
                            value,
                            "^,",
                            ""
                        )
                    value =
                        string.gsub(
                            value,
                            ",$",
                            ""
                        )
                else
                    value =
                        tonumber(
                            string.match(
                                tostring(
                                    box.Text
                                    or ""
                                ),
                                "%d+"
                            )
                        )
                        or 0
                end
                local ok =
                    pcall(function()
                        description[
                            slot.property
                        ] =
                            value
                    end)
                if ok then
                    changed += 1
                end
            end
        end
    end
    if changed == 0 then
        return false
    end
    return __UI.__L.others.applyDescription(
        description
    )
end
__UI.__L.others.applyAllRow =
    Instance.new("Frame")
__UI.__L.others.applyAllRow.Size =
    UDim2.new(
        1,
        -4,
        0,
        42
    )
__UI.__L.others.applyAllRow.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
__UI.__L.others.applyAllRow.BorderSizePixel =
    0
__UI.__L.others.applyAllRow.LayoutOrder =
    0
__UI.__L.others.applyAllRow.Parent =
    __UI.__L.others.page
__UI.__L.others.applyAllCorner =
    Instance.new("UICorner")
__UI.__L.others.applyAllCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.__L.others.applyAllCorner.Parent =
    __UI.__L.others.applyAllRow
__UI.__L.others.applyAllButton =
    Instance.new("TextButton")
__UI.__L.others.applyAllButton.Size =
    UDim2.new(
        1,
        -12,
        0,
        30
    )
__UI.__L.others.applyAllButton.Position =
    UDim2.new(
        0,
        6,
        0.5,
        -15
    )
__UI.__L.others.applyAllButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
__UI.__L.others.applyAllButton.BorderSizePixel =
    0
__UI.__L.others.applyAllButton.Text =
    "APPLY ALL"
__UI.__L.others.applyAllButton.TextSize =
    10
__UI.__L.others.applyAllButton.Font =
    Enum.Font.GothamBold
__UI.__L.others.applyAllButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.others.applyAllButton.Parent =
    __UI.__L.others.applyAllRow
__UI.__L.others.applyAllButtonCorner =
    Instance.new("UICorner")
__UI.__L.others.applyAllButtonCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.others.applyAllButtonCorner.Parent =
    __UI.__L.others.applyAllButton
__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.others.applyAllButton.MouseButton1Click:Connect(
        function()
            if __UI.__L.others.applyAll() then
                __UI.__L.others.saveConfig()
                __UI.__L.others.applyAllButton.Text =
                    "APPLIED"
                task.delay(
                    0.8,
                    function()
                        pcall(function()
                            if __UI.__L.others.applyAllButton.Parent then
                                __UI.__L.others.applyAllButton.Text =
                                    "APPLY ALL"
                            end
                        end)
                    end
                )
            end
        end
    )
)
__UI.__L.others.header(
    "QUICK BODY",
    1
)
__UI.__L.others.quickRow(
    "HEADLESS",
    "Head",
    __UI.__L.others.HEADLESS_ID,
    2
)
__UI.__L.others.quickRow(
    "KORBLOX",
    "RightLeg",
    __UI.__L.others.KORBLOX_ID,
    3
)
__UI.__L.others.header(
    "ACCESSORIES",
    4
)
__UI.__L.nextOrder =
    5
for _, slot in ipairs(
    __UI.__L.others.ACCESSORY_SLOTS
) do
    __UI.__L.others.row(
        slot,
        __UI.__L.nextOrder
    )
    __UI.__L.nextOrder += 1
end
__UI.__L.others.header(
    "2D CLOTHING",
    __UI.__L.nextOrder
)
__UI.__L.nextOrder += 1
for _, slot in ipairs(
    __UI.__L.others.CLOTHING_SLOTS
) do
    __UI.__L.others.row(
        slot,
        __UI.__L.nextOrder
    )
    __UI.__L.nextOrder += 1
end
__UI.__L.others.header(
    "BODY BUNDLES",
    __UI.__L.nextOrder
)
__UI.__L.nextOrder += 1
for _, slot in ipairs(
    __UI.__L.others.BODY_SLOTS
) do
    __UI.__L.others.row(
        slot,
        __UI.__L.nextOrder
    )
    __UI.__L.nextOrder += 1
end
--// =========================================================
--// FULL SCAN / CLEAR / RESET
--// =========================================================
__UI.__L.others.scanRow =
    Instance.new("Frame")
__UI.__L.others.scanRow.Size =
    UDim2.new(
        1,
        -4,
        0,
        40
    )
__UI.__L.others.scanRow.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
__UI.__L.others.scanRow.BorderSizePixel =
    0
__UI.__L.others.scanRow.LayoutOrder =
    __UI.__L.nextOrder + 1
__UI.__L.others.scanRow.Parent =
    __UI.__L.others.page
__UI.__L.others.scanButton =
    Instance.new("TextButton")
__UI.__L.others.scanButton.Size =
    UDim2.new(
        0,
        100,
        0,
        28
    )
__UI.__L.others.scanButton.Position =
    UDim2.new(
        0,
        8,
        0.5,
        -14
    )
__UI.__L.others.scanButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
__UI.__L.others.scanButton.BorderSizePixel =
    0
__UI.__L.others.scanButton.Text =
    "FULL SCAN"
__UI.__L.others.scanButton.TextSize =
    9
__UI.__L.others.scanButton.Font =
    Enum.Font.GothamBold
__UI.__L.others.scanButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.others.scanButton.Parent =
    __UI.__L.others.scanRow
__UI.__L.others.scanButtonCorner =
    Instance.new("UICorner")
__UI.__L.others.scanButtonCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.others.scanButtonCorner.Parent =
    __UI.__L.others.scanButton
__UI.__L.others.status =
    Instance.new("TextLabel")
__UI.__L.others.status.Size =
    UDim2.new(
        1,
        -122,
        1,
        0
    )
__UI.__L.others.status.Position =
    UDim2.new(
        0,
        118,
        0,
        0
    )
__UI.__L.others.status.BackgroundTransparency =
    1
__UI.__L.others.status.Text =
    "Click FULL SCAN"
__UI.__L.others.status.TextSize =
    10
__UI.__L.others.status.Font =
    Enum.Font.Gotham
__UI.__L.others.status.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
__UI.__L.others.status.TextXAlignment =
    Enum.TextXAlignment.Left
__UI.__L.others.status.Parent =
    __UI.__L.others.scanRow
__UI.__L.others.header(
    "TOOLS",
    __UI.__L.nextOrder + 2
)
__UI.__L.others.toolsFrame =
    Instance.new("Frame")
__UI.__L.others.toolsFrame.Size =
    UDim2.new(
        1,
        -4,
        0,
        80
    )
__UI.__L.others.toolsFrame.BackgroundTransparency =
    1
__UI.__L.others.toolsFrame.LayoutOrder =
    __UI.__L.nextOrder + 3
__UI.__L.others.toolsFrame.Parent =
    __UI.__L.others.page
__UI.__L.others.clearButton =
    Instance.new("TextButton")
__UI.__L.others.clearButton.Size =
    UDim2.new(
        1,
        0,
        0,
        34
    )
__UI.__L.others.clearButton.Position =
    UDim2.new(
        0,
        0,
        0,
        0
    )
__UI.__L.others.clearButton.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
__UI.__L.others.clearButton.BorderSizePixel =
    0
__UI.__L.others.clearButton.Text =
    "REMOVE EVERYTHING EXCEPT 2D CLOTHES + BODY"
__UI.__L.others.clearButton.TextSize =
    9
__UI.__L.others.clearButton.Font =
    Enum.Font.GothamBold
__UI.__L.others.clearButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.others.clearButton.Parent =
    __UI.__L.others.toolsFrame
__UI.__L.others.clearCorner =
    Instance.new("UICorner")
__UI.__L.others.clearCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.__L.others.clearCorner.Parent =
    __UI.__L.others.clearButton
__UI.__L.others.resetButton =
    Instance.new("TextButton")
__UI.__L.others.resetButton.Size =
    UDim2.new(
        1,
        0,
        0,
        34
    )
__UI.__L.others.resetButton.Position =
    UDim2.new(
        0,
        0,
        0,
        40
    )
__UI.__L.others.resetButton.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
__UI.__L.others.resetButton.BorderSizePixel =
    0
__UI.__L.others.resetButton.Text =
    "RESET TO INITIAL AVATAR"
__UI.__L.others.resetButton.TextSize =
    9
__UI.__L.others.resetButton.Font =
    Enum.Font.GothamBold
__UI.__L.others.resetButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.others.resetButton.Parent =
    __UI.__L.others.toolsFrame
--// =========================================================
--// AVATAR IMPORT UI
--// =========================================================
__UI.__L.others.avatarImportHeader =
    Instance.new("TextLabel")
__UI.__L.others.avatarImportHeader.Size =
    UDim2.new(
        1,
        -4,
        0,
        24
    )
__UI.__L.others.avatarImportHeader.BackgroundTransparency =
    1
__UI.__L.others.avatarImportHeader.Text =
    "AVATAR IMPORT"
__UI.__L.others.avatarImportHeader.TextSize =
    10
__UI.__L.others.avatarImportHeader.Font =
    Enum.Font.GothamBold
__UI.__L.others.avatarImportHeader.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
__UI.__L.others.avatarImportHeader.TextXAlignment =
    Enum.TextXAlignment.Left
__UI.__L.others.avatarImportHeader.LayoutOrder =
    __UI.__L.nextOrder + 4
__UI.__L.others.avatarImportHeader.Parent =
    __UI.__L.others.page

__UI.__L.others.avatarImportFrame =
    Instance.new("Frame")
__UI.__L.others.avatarImportFrame.Size =
    UDim2.new(
        1,
        -4,
        0,
        118
    )
__UI.__L.others.avatarImportFrame.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
__UI.__L.others.avatarImportFrame.BorderSizePixel =
    0
__UI.__L.others.avatarImportFrame.LayoutOrder =
    __UI.__L.nextOrder + 5
__UI.__L.others.avatarImportFrame.Parent =
    __UI.__L.others.page

__UI.__L.avatarImportCorner =
    Instance.new("UICorner")
__UI.__L.avatarImportCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.__L.avatarImportCorner.Parent =
    __UI.__L.others.avatarImportFrame

__UI.__L.others.avatarImportBox =
    Instance.new("TextBox")
__UI.__L.others.avatarImportBox.Size =
    UDim2.new(
        1,
        -92,
        0,
        72
    )
__UI.__L.others.avatarImportBox.Position =
    UDim2.new(
        0,
        8,
        0,
        8
    )
__UI.__L.others.avatarImportBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.others.avatarImportBox.BorderSizePixel =
    0
__UI.__L.others.avatarImportBox.ClearTextOnFocus =
    false
__UI.__L.others.avatarImportBox.MultiLine =
    true
__UI.__L.others.avatarImportBox.TextWrapped =
    false
__UI.__L.others.avatarImportBox.PlaceholderText =
    "Paste avatar JSON here"
__UI.__L.others.avatarImportBox.TextSize =
    10
__UI.__L.others.avatarImportBox.Font =
    Enum.Font.Code
__UI.__L.others.avatarImportBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.others.avatarImportBox.PlaceholderColor3 =
    Color3.fromRGB(
        105,
        105,
        105
    )
__UI.__L.others.avatarImportBox.TextXAlignment =
    Enum.TextXAlignment.Left
__UI.__L.others.avatarImportBox.TextYAlignment =
    Enum.TextYAlignment.Top
__UI.__L.others.avatarImportBox.Parent =
    __UI.__L.others.avatarImportFrame

__UI.__L.avatarImportBoxCorner =
    Instance.new("UICorner")
__UI.__L.avatarImportBoxCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.avatarImportBoxCorner.Parent =
    __UI.__L.others.avatarImportBox

__UI.__L.others.avatarImportButton =
    Instance.new("TextButton")
__UI.__L.others.avatarImportButton.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
__UI.__L.others.avatarImportButton.Position =
    UDim2.new(
        1,
        -80,
        0,
        30
    )
__UI.__L.others.avatarImportButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
__UI.__L.others.avatarImportButton.BorderSizePixel =
    0
__UI.__L.others.avatarImportButton.Text =
    "IMPORT"
__UI.__L.others.avatarImportButton.TextSize =
    9
__UI.__L.others.avatarImportButton.Font =
    Enum.Font.GothamBold
__UI.__L.others.avatarImportButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.others.avatarImportButton.Parent =
    __UI.__L.others.avatarImportFrame

__UI.__L.avatarImportButtonCorner =
    Instance.new("UICorner")
__UI.__L.avatarImportButtonCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.avatarImportButtonCorner.Parent =
    __UI.__L.others.avatarImportButton

__UI.__L.others.avatarImportClear =
    Instance.new("TextButton")
__UI.__L.others.avatarImportClear.Size =
    UDim2.new(
        0,
        72,
        0,
        24
    )
__UI.__L.others.avatarImportClear.Position =
    UDim2.new(
        1,
        -80,
        0,
        62
    )
__UI.__L.others.avatarImportClear.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
__UI.__L.others.avatarImportClear.BorderSizePixel =
    0
__UI.__L.others.avatarImportClear.Text =
    "CLEAR"
__UI.__L.others.avatarImportClear.TextSize =
    8
__UI.__L.others.avatarImportClear.Font =
    Enum.Font.GothamBold
__UI.__L.others.avatarImportClear.TextColor3 =
    Color3.fromRGB(
        215,
        215,
        215
    )
__UI.__L.others.avatarImportClear.Parent =
    __UI.__L.others.avatarImportFrame

__UI.__L.avatarImportClearCorner =
    Instance.new("UICorner")
__UI.__L.avatarImportClearCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.__L.avatarImportClearCorner.Parent =
    __UI.__L.others.avatarImportClear

__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.others.avatarImportButton.MouseButton1Click:Connect(
        function()
            local imported =
                __UI.__L.others.applyAvatarDump(
                    __UI.__L.others.avatarImportBox.Text
                )

            if imported then
                __UI.__L.others.avatarImportButton.Text =
                    "APPLIED"
            else
                __UI.__L.others.avatarImportButton.Text =
                    "ERROR"
            end

            task.delay(
                0.8,
                function()
                    pcall(function()
                        if __UI.__L.others.avatarImportButton.Parent then
                            __UI.__L.others.avatarImportButton.Text =
                                "IMPORT"
                        end
                    end)
                end
            )
        end
    )
)

__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.others.avatarImportClear.MouseButton1Click:Connect(
        function()
            __UI.__L.others.avatarImportBox.Text =
                ""
        end
    )
)
__UI.__L.others.resetCorner =
    Instance.new("UICorner")
__UI.__L.others.resetCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.__L.others.resetCorner.Parent =
    __UI.__L.others.resetButton
__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.others.scanButton.MouseButton1Click:Connect(
        function()
            __UI.__L.others.scan()
        end
    )
)
__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.others.clearButton.MouseButton1Click:Connect(
        function()
            if __UI.__L.others.clearAccessories() then
                task.delay(
                    0.3,
                    function()
                        __UI.__L.others.saveConfig()
                    end
                )
            end
        end
    )
)
__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.others.resetButton.MouseButton1Click:Connect(
        function()
            __UI.__L.others.ensureSnapshot()
            if __UI.__L.others.restore(true) then
                __UI.__L.others.scan()
            end
        end
    )
)
task.defer(
    function()
        pcall(function()
            __UI.__L.others.loadConfig()
            if __UI.__L.others.avatarImportBox then
                __UI.__L.others.avatarImportBox.Text =
                    tostring(
                        __UI.__L.savedConfig.others._AvatarImport
                        or ""
                    )
            end
        end)
    end
)
--// CATEGORY BAR
-- =========================================================
__UI.__L.categoryBar =
    Instance.new("Frame")
__UI.__L.categoryBar.Name =
    "CategoryBar"
__UI.__L.categoryBar.Size =
    UDim2.new(
        0,
        66,
        1,
        -56
    )
__UI.__L.categoryBar.Position =
    UDim2.new(
        0,
        8,
        0,
        48
    )
__UI.__L.categoryBar.BackgroundColor3 =
    Color3.fromRGB(
        26,
        30,
        36
    )
__UI.__L.categoryBar.BorderSizePixel =
    0
__UI.__L.categoryBar.Parent =
    __UI.__L.Main

__UI.categoryGradient =
    Instance.new("UIGradient")
__UI.categoryGradient.Rotation =
    90
__UI.categoryGradient.Transparency =
    NumberSequence.new({
        NumberSequenceKeypoint.new(
            0,
            0.05
        ),
        NumberSequenceKeypoint.new(
            1,
            0.2
        )
    })
__UI.categoryGradient.Parent =
    __UI.__L.categoryBar

__UI.categoryStroke =
    Instance.new("UIStroke")
__UI.categoryStroke.Thickness =
    1
__UI.categoryStroke.Transparency =
    0.55
__UI.categoryStroke.Parent =
    __UI.__L.categoryBar

__UI.categoryCorner =
    Instance.new("UICorner")
__UI.categoryCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
__UI.categoryCorner.Parent =
    __UI.__L.categoryBar
__UI.__L.makeCategoryButton = function(
    text,
    y
)
    local button =
        Instance.new("TextButton")
    button.Size =
        UDim2.new(
            1,
            -10,
            0,
            30
        )
    button.Position =
        UDim2.new(
            0,
            5,
            0,
            y
        )
    button.BackgroundColor3 =
        Color3.fromRGB(
            31,
            35,
            41
        )
    button.BorderSizePixel =
        0
    button.Text =
        text
    button.TextSize =
        10
    button.Font =
        Enum.Font.GothamBold
    button.AutoButtonColor =
        true
    button.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )
    button.TextWrapped =
        true
    button.Parent =
        __UI.__L.categoryBar
    local corner =
        Instance.new("UICorner")
    corner.CornerRadius =
        UDim.new(
            0,
            6
        )
    corner.Parent =
        button

    local stroke =
        Instance.new("UIStroke")
    stroke.Thickness =
        1
    stroke.Transparency =
        0.9
    stroke.Parent =
        button

    return button
end
__UI.__L.mainCategoryButton =
    __UI.__L.makeCategoryButton(
        "MAIN",
        6
    )
__UI.__L.emoteCategoryButton =
    __UI.__L.makeCategoryButton(
        "EMOTES",
        41
    )
__UI.__L.unusualCategoryButton =
    __UI.__L.makeCategoryButton(
        "UNUSUAL",
        76
    )
__UI.__L.othersCategoryButton =
    __UI.__L.makeCategoryButton(
        "OTHERS",
        111
    )
__UI.__L.cosmetic.categoryButton =
    __UI.__L.makeCategoryButton(
        "COSMETIC",
        146
    )
--// =========================================================
--// CATEGORY SWITCH
--// =========================================================
__UI.__L.setCategory = function(
    category
)
    __UI.__L.currentCategory =
        category

    pcall(function()
        if category == "Main" then
            __UI.__L.MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION
            __UI.__L.Status.Visible = false
            __UI.__L.Toggle.Visible = false
            __UI.__L.SlotsScroll.Visible = false
            __UI.__L.mainPage.Visible = true
            __UI.__L.unusualPage.Visible = false
            __UI.__L.unusualStatus.Visible = false
            __UI.__L.unusualPicker.Visible = false
            __UI.__L.others.page.Visible = false
            __UI.__L.cosmetic.page.Visible = false
            __UI.__L.mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(65, 65, 65)
            __UI.__L.emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.cosmetic.categoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)

        elseif category == "Unusual" then
            __UI.__L.MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION
            __UI.__L.Status.Visible = false
            __UI.__L.Toggle.Visible = true
            __UI.__L.Toggle.Parent = __UI.__L.unusualPage
            __UI.__L.Toggle.LayoutOrder = 0
            __UI.__L.SlotsScroll.Visible = false
            __UI.__L.mainPage.Visible = false
            __UI.__L.unusualPage.Visible = true
            __UI.__L.unusualStatus.Visible = false
            __UI.__L.unusualPicker.Visible = false
            __UI.__L.others.page.Visible = false
            __UI.__L.cosmetic.page.Visible = false
            __UI.__L.mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(65, 65, 65)
            __UI.__L.othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.cosmetic.categoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.updateUnusualToggle()

        elseif category == "Others" then
            __UI.__L.MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION
            __UI.__L.Status.Visible = false
            __UI.__L.Toggle.Visible = false
            __UI.__L.SlotsScroll.Visible = false
            __UI.__L.unusualPage.Visible = false
            __UI.__L.unusualStatus.Visible = false
            __UI.__L.mainPage.Visible = false
            __UI.__L.unusualPicker.Visible = false
            __UI.__L.others.page.Visible = true
            __UI.__L.cosmetic.page.Visible = false
            __UI.__L.mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(65, 65, 65)
            __UI.__L.cosmetic.categoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)

        elseif category == "Cosmetic" then
            __UI.__L.MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION
            __UI.__L.Status.Visible = false
            __UI.__L.Toggle.Visible = true
            __UI.__L.Toggle.Parent = __UI.__L.cosmetic.page
            __UI.__L.Toggle.LayoutOrder = 0
            __UI.__L.SlotsScroll.Visible = false
            __UI.__L.mainPage.Visible = false
            __UI.__L.unusualPage.Visible = false
            __UI.__L.unusualStatus.Visible = false
            __UI.__L.unusualPicker.Visible = false
            __UI.__L.others.page.Visible = false
            __UI.__L.cosmetic.page.Visible = true
            __UI.__L.mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.cosmetic.categoryButton.BackgroundColor3 =
                Color3.fromRGB(65, 65, 65)
            __UI.__L.cosmetic.updateToggle()

        else
            __UI.__L.MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION
            __UI.__L.Status.Visible = false
            __UI.__L.Toggle.Visible = true
            __UI.__L.Toggle.Parent = __UI.__L.SlotsScroll
            __UI.__L.Toggle.LayoutOrder = 0
            __UI.__L.SlotsScroll.Visible = true
            __UI.__L.mainPage.Visible = false
            __UI.__L.unusualPage.Visible = false
            __UI.__L.unusualStatus.Visible = false
            __UI.__L.unusualPicker.Visible = false
            __UI.__L.others.page.Visible = false
            __UI.__L.cosmetic.page.Visible = false
            __UI.__L.mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.cosmetic.categoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            __UI.__L.emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(65, 65, 65)
            updateGUI()
        end
    end)
end

__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.mainCategoryButton.MouseButton1Click:Connect(
        function()
            if __UI.__L.mainMinimized then
                __UI.__L.setMainMinimized(false)
            end
            __UI.__L.setCategory(
                "Main"
            )
        end
    )
)
__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.emoteCategoryButton.MouseButton1Click:Connect(
        function()
            if __UI.__L.mainMinimized then
                __UI.__L.setMainMinimized(false)
            end
            __UI.__L.setCategory(
                "Emotes"
            )
        end
    )
)
__UI.__L.UnusualFns.addUnusualConnection(    __UI.__L.unusualCategoryButton.MouseButton1Click:Connect(
        function()
            if __UI.__L.mainMinimized then
                __UI.__L.setMainMinimized(false)
            end
            __UI.__L.setCategory(
                "Unusual"
            )
        end
    )
)
__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.othersCategoryButton.MouseButton1Click:Connect(
        function()
            if __UI.__L.mainMinimized then
                __UI.__L.setMainMinimized(false)
            end
            __UI.__L.setCategory(
                "Others"
            )
        end
    )
)
__UI.__L.UnusualFns.addUnusualConnection(
    __UI.__L.cosmetic.categoryButton.MouseButton1Click:Connect(
        function()
            if __UI.__L.mainMinimized then
                __UI.__L.setMainMinimized(false)
            end
            __UI.__L.setCategory(
                "Cosmetic"
            )
        end
    )
)
--// =========================================================
--// EXTERNAL CLEANUP
--// =========================================================
__UI.__L.cleanupUnusual = function()
    if __UI.__L.unusualDestroyed then
        return
    end
    __UI.__L.unusualDestroyed =
        true

    --// originalId is the configured swap source, not necessarily
    --// the effect the player currently has equipped.
    local runtimeCurrentEquippedId =
        tonumber(
            __UI.__L.UnusualFns.getEquippedUnusualId()
        )

    __UI.__L.unusualRuntime.currentEquippedId =
        runtimeCurrentEquippedId

    local runtimeOriginalId =
        tonumber(
            __UI.__L.unusualRuntime.originalId
        )

    --// Prefer the real current loadout. This is what must remain
    --// after DeadEye closes, even if the player changed Unusuals
    --// after enabling the swap.
    local runtimeRestoreId =
        runtimeCurrentEquippedId

    if not runtimeRestoreId
        or runtimeRestoreId == 0
    then
        runtimeRestoreId =
            runtimeOriginalId
    end

    local restoreNativeUnusual =
        __UI.__L.unusualActive
        or runtimeOriginalId

    local runtimeSnapshot =
        __UI.__L.unusualRuntime.nativeSnapshot

    --// A snapshot captured for the old mapped Unusual cannot be
    --// used after the player has manually equipped another one.
    if runtimeRestoreId
        and runtimeOriginalId
        and tonumber(runtimeRestoreId)
            ~= tonumber(runtimeOriginalId)
    then
        runtimeSnapshot = nil
    end

    local runtimeSnapshotRig =
        __UI.__L.unusualRuntime.appliedRig

    --// Invalidate reapply work BEFORE restoring the live effect.
    __UI.__L.unusualEnabled =
        false
    genv.UNUSUAL_SWAPPER_ENABLED =
        false
    __UI.__L.unusualRuntime.reapplyGeneration += 1

    --// Wait for a reapply already inside activation so it cannot write
    --// the replacement after cleanup has restored the native effect.
    local reapplyDeadline =
        tick() + 1

    while __UI.__L.unusualReapplyBusy
        and tick() < reapplyDeadline
    do
        task.wait()
    end

    local currentVisualRig =
        __UI.__L.UnusualFns.getUnusualVisualRig()

    local currentPlayerCharacter =
        __UI.__L.UnusualFns.getUnusualPlayerCharacter()

    --// Snapshot is only valid for the rig it was captured from.
    --// Prefer the snapshot from a completed reapply on this rig.
    --// Otherwise capture the native effect if the new rig still has it.
    if currentVisualRig
        and runtimeOriginalId
        and runtimeOriginalId ~= 0
        and runtimeCurrentEquippedId
        and runtimeCurrentEquippedId ~= 0
        and tonumber(runtimeCurrentEquippedId)
            == tonumber(runtimeOriginalId)
    then
        if __UI.__L.unusualRuntime.appliedRig == currentVisualRig
            and __UI.__L.unusualRuntime.nativeSnapshot
        then
            runtimeSnapshot =
                __UI.__L.unusualRuntime.nativeSnapshot
            runtimeSnapshotRig =
                currentVisualRig
        elseif runtimeSnapshotRig
            ~= currentVisualRig
        then
            local freshSnapshot =
                __UI.__L.UnusualFns.captureNativeUnusualSnapshot(
                    runtimeOriginalId,
                    currentVisualRig,
                    currentPlayerCharacter
                )

            if freshSnapshot then
                runtimeSnapshot =
                    freshSnapshot
                runtimeSnapshotRig =
                    currentVisualRig
            end
        end
    end

    if restoreNativeUnusual
        and runtimeRestoreId
        and runtimeRestoreId ~= 0
    then
        pcall(function()
            local visualRig =
                __UI.__L.UnusualFns.getUnusualVisualRig()
            local playerCharacter =
                __UI.__L.UnusualFns.getUnusualPlayerCharacter()

            if visualRig then
                __UI.__L.UnusualFns.removeOurUnusualFX()
                task.wait()

                if runtimeCurrentEquippedId
                    and runtimeOriginalId
                    and tonumber(runtimeCurrentEquippedId)
                        ~= tonumber(runtimeOriginalId)
                then
                    --// Player changed the equipped Unusual.
                    --// Keep the game's current native effect; remove only
                    --// the FX owned by DeadEye.
                    __UI.__L.UnusualFns.removeOurUnusualFX()
                    pcall(function()
                        __UI.__L.UnusualFns.removeOriginalUnusualFX(
                            runtimeOriginalId,
                            visualRig,
                            playerCharacter
                        )
                    end)
                elseif runtimeSnapshot
                    and runtimeSnapshotRig == visualRig
                then
                    __UI.__L.UnusualFns.restoreNativeUnusualSnapshot(
                        runtimeSnapshot,
                        visualRig,
                        playerCharacter
                    )
                else
                    __UI.__L.UnusualFns.removeOriginalUnusualFX(
                        runtimeRestoreId,
                        visualRig,
                        playerCharacter
                    )
                    task.wait()

                    applyUnusualFX(
                        runtimeRestoreId,
                        visualRig,
                        playerCharacter
                    )
                end
            end
        end)
    end

    __UI.__L.unusualActive =
        false

    pcall(function()
        __UI.__L.others.restore(false)
    end)

    pcall(function()
        __UI.__L.cosmetic.cleanup()
    end)

    --// Do not rebuild the native Unusual here.
    --// The game's AddCosmetics(CharacterClassic) path can receive a
    --// cosmetic rig that does not contain the expected HumanoidRootPart
    --// limb and produces repeated shutdown errors.
    --// The active/native snapshot is already handled above. Cleanup
    --// must not call AddCosmetics again.

    __UI.__L.unusualRuntime.originalId =
        nil
    __UI.__L.unusualRuntime.currentEquippedId =
        runtimeRestoreId
    __UI.__L.unusualRuntime.replacementId =
        nil
    __UI.__L.unusualRuntime.nativeSnapshot =
        nil

    genv.DEADEYE_COSMETIC_CLEANUP =
        nil
    __UI.__L.unusualEnabled =
        false
    __UI.__L.unusualActive =
        false
    __UI.__L.unusualRuntime.reapplyGeneration += 1
    __UI.__L.unusualRuntime.appliedRig = nil
    genv.UNUSUAL_SWAPPER_ENABLED =
        false
    __UI.__L.UnusualFns.disconnectUnusualConnections()
    if not preserveFinalRestoredUnusualFX then
        pcall(function()
            __UI.__L.UnusualFns.removeOurUnusualFX()
        end)
    end
    genv.DEADEYE_MAIN_RUNNING = false
    pcall(function()
        if __UI.__L.mainPage then
            __UI.__L.mainPage.Visible = false
        end
        __UI.__L.mainDisconnect()
        if __UI.__L.unusualPicker then
            __UI.__L.unusualPicker:Destroy()
        end
        if __UI.__L.unusualPage then
            __UI.__L.unusualPage:Destroy()
        end
        if __UI.__L.others.page then
            __UI.__L.others.page:Destroy()
        end
        if __UI.__L.unusualStatus then
            __UI.__L.unusualStatus:Destroy()
        end
        if __UI.__L.categoryBar then
            __UI.__L.categoryBar:Destroy()
        end
    end)
    genv.UNUSUAL_SWAPPER_CLEANUP =
        nil
    end
genv.UNUSUAL_SWAPPER_CLEANUP =
    __UI.__L.cleanupUnusual
--// =========================================================
--// REPLACE EXISTING TOGGLE BEHAVIOUR
--// =========================================================
--// =========================================================
--// TOGGLE
--// =========================================================
__UI.__L.Toggle =
    Instance.new("TextButton")
__UI.__L.Toggle.Size =
    UDim2.new(
        1,
        -12,
        0,
        36
    )
__UI.__L.Toggle.Position =
    UDim2.new(
        0,
        0,
        0,
        0
    )
__UI.__L.Toggle.LayoutOrder =
    0
__UI.__L.Toggle.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
__UI.__L.Toggle.BorderSizePixel =
    0
__UI.__L.Toggle.Text =
    "SWAP: OFF"
__UI.__L.Toggle.TextSize =
    11
__UI.__L.Toggle.Font =
    Enum.Font.GothamBold
__UI.__L.Toggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.Toggle.Parent =
    __UI.__L.SlotsScroll
__UI.ToggleCorner =
    Instance.new("UICorner")
__UI.ToggleCorner.CornerRadius =
    UDim.new(
        0,
        8
    )
__UI.ToggleCorner.Parent =
    __UI.__L.Toggle
--// =========================================================
--// SLOTS SCROLL
--// =========================================================
__UI.__L.SlotsScroll =
    Instance.new("ScrollingFrame")
__UI.__L.SlotsScroll.Name =
    "Slots"
__UI.__L.SlotsScroll.Size =
    UDim2.new(
        1,
        -16,
        1,
        -76
    )
__UI.__L.SlotsScroll.Position =
    UDim2.new(
        0,
        8,
        0,
        68
    )
__UI.__L.SlotsScroll.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
__UI.__L.SlotsScroll.BorderSizePixel =
    0
__UI.__L.SlotsScroll.ScrollBarThickness =
    6
__UI.__L.SlotsScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
__UI.__L.SlotsScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
__UI.__L.SlotsScroll.Parent =
    __UI.__L.Main
--// Existing Emote content moves right of the category rail.
__UI.__L.SlotsScroll.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
__UI.__L.SlotsScroll.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
__UI.SlotsCorner =
    Instance.new("UICorner")
__UI.SlotsCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
__UI.SlotsCorner.Parent =
    __UI.__L.SlotsScroll
__UI.SlotsPadding =
    Instance.new("UIPadding")
__UI.SlotsPadding.PaddingTop =
    UDim.new(
        0,
        8
    )
__UI.SlotsPadding.PaddingBottom =
    UDim.new(
        0,
        8
    )
__UI.SlotsPadding.PaddingLeft =
    UDim.new(
        0,
        8
    )
__UI.SlotsPadding.PaddingRight =
    UDim.new(
        0,
        8
    )
__UI.SlotsPadding.Parent =
    __UI.__L.SlotsScroll
__UI.SlotsLayout =
    Instance.new("UIListLayout")
__UI.SlotsLayout.Padding =
    UDim.new(
        0,
        7
    )
__UI.SlotsLayout.SortOrder =
    Enum.SortOrder.LayoutOrder
__UI.SlotsLayout.Parent =
    __UI.__L.SlotsScroll
--// =========================================================
--// CREATE SLOT ROWS
--// =========================================================
for slotIndex = 1, __UI.__L.SLOT_COUNT do
    local row =
        Instance.new("Frame")
    row.Name =
        "Slot" .. tostring(slotIndex)
    row.Size =
        UDim2.new(
            1,
            -12,
            0,
            48
        )
    row.BackgroundColor3 =
        Color3.fromRGB(
            40,
            40,
            40
        )
    row.BorderSizePixel =
        0
    row.LayoutOrder =
        slotIndex
    row.Parent =
        __UI.__L.SlotsScroll
    local rowCorner =
        Instance.new("UICorner")
    rowCorner.CornerRadius =
        UDim.new(
            0,
            7
        )
    rowCorner.Parent =
        row
    --// SLOT LABEL
    local slotLabel =
        Instance.new("TextLabel")
    slotLabel.Size =
        UDim2.new(
            0,
            76,
            1,
            0
        )
    slotLabel.Position =
        UDim2.new(
            0,
            6,
            0,
            0
        )
    slotLabel.BackgroundTransparency =
        1
    slotLabel.Text =
        "Emote Slot "
        .. tostring(slotIndex)
    slotLabel.TextSize =
        11
    slotLabel.Font =
        Enum.Font.GothamBold
    slotLabel.TextColor3 =
        Color3.fromRGB(
            210,
            210,
            210
        )
    slotLabel.TextXAlignment =
        Enum.TextXAlignment.Left
    slotLabel.Parent =
        row
    --// ORIGINAL
    local originalButton =
        Instance.new("TextButton")
    originalButton.Size =
        UDim2.new(
            0,
            108,
            0,
            32
        )
    originalButton.Position =
        UDim2.new(
            0,
            84,
            0.5,
            -16
        )
    originalButton.BackgroundColor3 =
        Color3.fromRGB(
            52,
            52,
            52
        )
    originalButton.BorderSizePixel =
        0
    originalButton.Text =
        __UI.__L.slots[slotIndex].originalName
        or "Select"
    originalButton.TextSize =
        11
    originalButton.Font =
            Enum.Font.GothamBold
    originalButton.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )
    originalButton.TextTruncate =
        Enum.TextTruncate.AtEnd
    originalButton.Parent =
        row
    local originalCorner =
        Instance.new("UICorner")
    originalCorner.CornerRadius =
        UDim.new(
            0,
            7
        )
    originalCorner.Parent =
        originalButton
    __UI.__L.slotOriginalButtons[
        slotIndex
    ] =
        originalButton
    --// ARROW
    local arrow =
        Instance.new("TextLabel")
    arrow.Size =
        UDim2.new(
            0,
            18,
            0,
            32
        )
    arrow.Position =
        UDim2.new(
            0,
            194,
            0.5,
            -16
        )
    arrow.BackgroundTransparency =
        1
    arrow.Text =
        "→"
    arrow.TextSize =
        20
    arrow.Font =
        Enum.Font.GothamBold
    arrow.TextColor3 =
        Color3.fromRGB(
            180,
            180,
            180
        )
    arrow.Parent =
        row
    --// REPLACE
    local replaceButton =
        Instance.new("TextButton")
    replaceButton.Size =
        UDim2.new(
            0,
            110,
            0,
            32
        )
    replaceButton.Position =
        UDim2.new(
            0,
            216,
            0.5,
            -16
        )
    replaceButton.BackgroundColor3 =
        Color3.fromRGB(
            52,
            52,
            52
        )
    replaceButton.BorderSizePixel =
        0
    replaceButton.Text =
        __UI.__L.slots[slotIndex].replaceName
        or "Select"
    replaceButton.TextSize =
        11
    replaceButton.Font =
            Enum.Font.GothamBold
    replaceButton.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )
    replaceButton.TextTruncate =
        Enum.TextTruncate.AtEnd
    replaceButton.Parent =
        row
    local replaceCorner =
        Instance.new("UICorner")
    replaceCorner.CornerRadius =
        UDim.new(
            0,
            7
        )
    replaceCorner.Parent =
        replaceButton
    __UI.__L.slotReplaceButtons[
        slotIndex
    ] =
        replaceButton
end
__UI.__L.cosmetic.loadState()
__UI.__L.cosmetic.buildList()
__UI.__L.cosmetic.installHook()
__UI.__L.cosmetic.buildUI()

pcall(function()
    local loadoutChannel =
        ReplicatedStorage.Shared.UserData.Events.Remotes.Channels.Loadout

    __UI.__L.UnusualFns.addUnusualConnection(
        loadoutChannel.OnClientEvent:Connect(
            function(kind, data)
                if kind == "sync"
                    and type(data) == "table"
                then
                    __UI.__L.cosmetic.setInitialOriginal(
                        1,
                        data.CosmeticSlot_1
                    )
                    __UI.__L.cosmetic.setInitialOriginal(
                        2,
                        data.CosmeticSlot_2
                    )
                elseif kind == "patch"
                    and type(data) == "table"
                then
                    __UI.__L.cosmetic.setInitialOriginal(
                        1,
                        data.CosmeticSlot_1
                    )
                    __UI.__L.cosmetic.setInitialOriginal(
                        2,
                        data.CosmeticSlot_2
                    )
                end
            end
        )
    )
end)

genv.DEADEYE_COSMETIC_CLEANUP =
    __UI.__L.cosmetic.cleanup

--// =========================================================
--// PICKER
--// =========================================================
__UI.__L.Picker =
    Instance.new("Frame")
__UI.__L.Picker.Size =
    UDim2.new(
        0,
        560,
        0,
        450
    )
__UI.__L.Picker.Position =
    UDim2.new(
        0.5,
        -280,
        0.5,
        -225
    )
__UI.__L.Picker.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )
__UI.__L.Picker.BackgroundTransparency =
    0.10
__UI.__L.Picker.BorderSizePixel =
    0
__UI.__L.Picker.ClipsDescendants =
    true
__UI.__L.Picker.Visible =
    false
__UI.__L.Picker.ZIndex =
    30
__UI.__L.Picker.Parent =
    __UI.__L.ScreenGui
__UI.PickerCorner =
    Instance.new("UICorner")
__UI.PickerCorner.CornerRadius =
    UDim.new(
        0,
        8
    )
__UI.PickerCorner.Parent =
    __UI.__L.Picker
__UI.PickerStroke =
    Instance.new("UIStroke")
__UI.PickerStroke.Thickness =
    1
__UI.PickerStroke.Transparency =
    0.66
__UI.PickerStroke.Parent =
    __UI.__L.Picker
__UI.PickerGlass =
    Instance.new("UIGradient")
__UI.PickerGlass.Rotation =
    115
__UI.PickerGlass.Color =
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
__UI.PickerGlass.Transparency =
    NumberSequence.new(0.20)
__UI.PickerGlass.Parent =
    __UI.__L.Picker
--// PICKER TITLE
__UI.__L.PickerTitle =
    Instance.new("TextLabel")
__UI.__L.PickerTitle.Size =
    UDim2.new(
        1,
        -45,
        0,
        32
    )
__UI.__L.PickerTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        2
    )
__UI.__L.PickerTitle.BackgroundTransparency =
    1
__UI.__L.PickerTitle.Text =
    "Select Emote"
__UI.__L.PickerTitle.TextSize =
    16
__UI.__L.PickerTitle.Font =
    Enum.Font.GothamBold
__UI.__L.PickerTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.PickerTitle.TextXAlignment =
    Enum.TextXAlignment.Left
__UI.__L.PickerTitle.ZIndex =
    31
__UI.__L.PickerTitle.Parent =
    __UI.__L.Picker
--// =========================================================
--// PICKER CLOSE
--// =========================================================
__UI.__L.PickerClose =
    Instance.new("TextButton")
__UI.__L.PickerClose.Size =
    UDim2.new(
        0,
        27,
        0,
        27
    )
__UI.__L.PickerClose.Position =
    UDim2.new(
        1,
        -32,
        0,
        6
    )
__UI.__L.PickerClose.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        50
    )
__UI.__L.PickerClose.BackgroundTransparency =
    0.05
__UI.__L.PickerClose.BorderSizePixel =
    0
__UI.__L.PickerClose.ZIndex =
    31
__UI.__L.PickerClose.Text =
    "×"
__UI.__L.PickerClose.TextSize =
    27
__UI.__L.PickerClose.Font =
    Enum.Font.GothamBold
__UI.__L.PickerClose.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.PickerClose.AutoButtonColor =
    false
__UI.__L.PickerClose.Active =
    true
__UI.__L.PickerClose.Selectable =
    false
__UI.__L.PickerClose.Parent =
    __UI.__L.Picker

__UI.PickerCloseCorner =
    Instance.new("UICorner")
__UI.PickerCloseCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.PickerCloseCorner.Parent =
    __UI.__L.PickerClose

__UI.PickerCloseStroke =
    Instance.new("UIStroke")
__UI.PickerCloseStroke.Thickness =
    1
__UI.PickerCloseStroke.Transparency =
    0.65
__UI.PickerCloseStroke.Parent =
    __UI.__L.PickerClose
--// =========================================================
--// PICKER SEARCH
--// =========================================================
__UI.__L.PickerSearch =
    Instance.new("TextBox")
__UI.__L.PickerSearch.Size =
    UDim2.new(
        1,
        -20,
        0,
        30
    )
__UI.__L.PickerSearch.Position =
    UDim2.new(
        0,
        10,
        0,
        36
    )
__UI.__L.PickerSearch.BackgroundColor3 =
    Color3.fromRGB(
        40,
        45,
        53
    )
__UI.__L.PickerSearch.BackgroundTransparency =
    0.20
__UI.__L.PickerSearch.BorderSizePixel =
    0
__UI.__L.PickerSearch.ClearTextOnFocus =
    false
__UI.__L.PickerSearch.PlaceholderText =
    "Search by name..."
__UI.__L.PickerSearch.PlaceholderColor3 =
    Color3.fromRGB(
        120,
        120,
        120
    )
__UI.__L.PickerSearch.Text =
    ""
__UI.__L.PickerSearch.TextSize =
    12
__UI.__L.PickerSearch.Font =
            Enum.Font.GothamBold
__UI.__L.PickerSearch.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
__UI.__L.PickerSearch.ZIndex =
    32
__UI.__L.PickerSearch.Parent =
    __UI.__L.Picker
__UI.SearchCorner =
    Instance.new("UICorner")
__UI.SearchCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.SearchCorner.Parent =
    __UI.__L.PickerSearch
--// =========================================================
--// PICKER SCROLL
--// =========================================================
__UI.__L.PickerScroll =
    Instance.new("ScrollingFrame")
__UI.__L.PickerScroll.Size =
    UDim2.new(
        1,
        -16,
        1,
        -74
    )
__UI.__L.PickerScroll.Position =
    UDim2.new(
        0,
        8,
        0,
        70
    )
__UI.__L.PickerScroll.BackgroundColor3 =
    Color3.fromRGB(
        32,
        35,
        42
    )
__UI.__L.PickerScroll.BackgroundTransparency =
    0.20
__UI.__L.PickerScroll.BorderSizePixel =
    0
__UI.__L.PickerScroll.ScrollBarThickness =
    6
__UI.__L.PickerScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
__UI.__L.PickerScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
__UI.__L.PickerScroll.ZIndex =
    31
__UI.__L.PickerScroll.Parent =
    __UI.__L.Picker
__UI.PickerScrollCorner =
    Instance.new("UICorner")
__UI.PickerScrollCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.PickerScrollCorner.Parent =
    __UI.__L.PickerScroll
__UI.PickerPadding =
    Instance.new("UIPadding")
__UI.PickerPadding.PaddingTop =
    UDim.new(
        0,
        8
    )
__UI.PickerPadding.PaddingBottom =
    UDim.new(
        0,
        8
    )
__UI.PickerPadding.PaddingLeft =
    UDim.new(
        0,
        8
    )
__UI.PickerPadding.PaddingRight =
    UDim.new(
        0,
        8
    )
__UI.PickerPadding.Parent =
    __UI.__L.PickerScroll
__UI.PickerGrid =
    Instance.new("UIGridLayout")
__UI.PickerGrid.CellSize =
    UDim2.new(
        1 / 3,
        -6,
        0,
        92
    )
__UI.PickerGrid.CellPadding =
    UDim2.new(
        0,
        6,
        0,
        8
    )
__UI.PickerGrid.SortOrder =
    Enum.SortOrder.LayoutOrder
__UI.PickerGrid.Parent =
    __UI.__L.PickerScroll
--// =========================================================
--// EMOTE VIEWPORT PREVIEW
--// Локальная копия native preview без CreateViewport()
--// =========================================================
__UI.__L.createEmotePreview = function(
    itemModule,
    viewport
)
    if not itemModule
        or not viewport
    then
        return false
    end

    local success, result =
        pcall(function()

            local oldWorldModel =
                viewport:FindFirstChildOfClass(
                    "WorldModel"
                )

            if oldWorldModel then
                oldWorldModel:Destroy()
            end

            local oldCamera =
                viewport.CurrentCamera

            if oldCamera then
                oldCamera:Destroy()
                viewport.CurrentCamera =
                    nil
            end

            local worldModel =
                Instance.new(
                    "WorldModel"
                )
            worldModel.Parent =
                viewport

            -- Match ClientItemService:GetVisualModel()
            -- without calling the service from the executor thread.
            local isR15 = false

            pcall(function()
                local character =
                    LocalPlayer.Character

                local humanoid =
                    character
                    and character:FindFirstChildOfClass(
                        "Humanoid"
                    )

                if humanoid then
                    isR15 =
                        humanoid.RigType
                        == Enum.HumanoidRigType.R15
                end
            end)

            local assets =
                ReplicatedStorage:FindFirstChild(
                    "Assets"
                )

            local items =
                assets
                and assets:FindFirstChild(
                    "Items"
                )

            local rigTemplate

            if isR15 then
                rigTemplate =
                    items
                    and items:FindFirstChild(
                        "VisualRigR15Emote"
                    )
            else
                rigTemplate =
                    items
                    and items:FindFirstChild(
                        "VisualRigClassic"
                    )
            end

            if not rigTemplate then
                error(
                    "Visual rig template not found"
                )
            end

            local rig =
                rigTemplate:Clone()

            if not rig.PrimaryPart then
                rig.PrimaryPart =
                    rig:FindFirstChild(
                        "HumanoidRootPart"
                    )
                    or rig:FindFirstChildWhichIsA(
                        "BasePart",
                        true
                    )
            end

            if not rig.PrimaryPart then
                rig:Destroy()

                error(
                    "Visual rig has no PrimaryPart"
                )
            end

            -- =================================================
            -- EXACT GetSelection() BEHAVIOR
            -- =================================================

            local selection

            if itemModule:FindFirstChild(
                "Selection"
            ) then
                local selectionFolder =
                    itemModule.Selection

                local children =
                    selectionFolder:GetChildren()

                selection =
                    children[1]
            end

            -- =================================================
            -- EXACT GetAnimations() BEHAVIOR
            -- =================================================

            local mainAnimation
            local introAnimation
            local walkAnimation
            local idleAnimation
            local activateModule

            local hasAnimations =
                itemModule:FindFirstChild(
                    "Animations"
                )

            local hasSelection =
                itemModule:FindFirstChild(
                    "Selection"
                )

            if not hasAnimations
                and not hasSelection
            then
                if isR15 then
                    mainAnimation =
                        itemModule:FindFirstChild(
                            "Animation"
                        )
                else
                    mainAnimation =
                        itemModule:FindFirstChild(
                            "AnimationClassic"
                        )
                end
            else
                local animationRoot

                if hasSelection then
                    animationRoot =
                        selection
                        and selection:FindFirstChild(
                            "Animations"
                        )
                else
                    animationRoot =
                        itemModule:FindFirstChild(
                            "Animations"
                        )
                end

                if animationRoot then
                    local rigAnimations

                    if isR15 then
                        rigAnimations =
                            animationRoot:FindFirstChild(
                                "R15"
                            )
                    else
                        rigAnimations =
                            animationRoot:FindFirstChild(
                                "R6"
                            )
                    end

                    if rigAnimations then
                        local intro =
                            rigAnimations:FindFirstChild(
                                "Intro"
                            )

                        if intro
                            and intro:IsA("Animation")
                            and intro.AnimationId ~= ""
                        then
                            introAnimation =
                                intro
                        end

                        local animation =
                            rigAnimations:FindFirstChild(
                                "Animation"
                            )

                        if animation
                            and animation:IsA("Animation")
                            and animation.AnimationId ~= ""
                        then
                            mainAnimation =
                                animation                        end

                        local walk =
                            rigAnimations:FindFirstChild(
                                "Walk"
                            )

                        if walk
                            and walk:IsA("Animation")
                            and walk.AnimationId ~= ""
                        then
                            walkAnimation =
                                walk
                        end

                        local idle =
                            rigAnimations:FindFirstChild(
                                "Idle"
                            )

                        if idle
                            and idle:IsA("Animation")
                            and idle.AnimationId ~= ""
                        then
                            idleAnimation =
                                idle
                        end

                        local activate =
                            rigAnimations:FindFirstChild(
                                "Activate"
                            )

                        if activate then
                            activateModule =
                                activate
                        elseif rigAnimations.Parent then
                            activateModule =
                                rigAnimations.Parent:
                                FindFirstChild(
                                    "Activate"
                                )
                        end
                    end
                end
            end

            -- =================================================
            -- EXACT SetModel() BEHAVIOR
            -- =================================================

            local visualRoot =
                selection
                or itemModule

            local characterFolder =
                visualRoot
                and visualRoot:FindFirstChild(
                    isR15
                    and "Character"
                    or "CharacterClassic"
                )

            if not characterFolder then
                characterFolder =
                    visualRoot
                    and (
                        visualRoot:FindFirstChild(
                            "CharacterClassic"
                        )
                        or visualRoot:FindFirstChild(
                            "Character"
                        )
                    )
            end

            local emoteModelClone

            if characterFolder then
                local emoteModel =
                    characterFolder:FindFirstChild(
                        "EmoteModel"
                    )

                if emoteModel then
                    -- Match the native optimization flags.
                    pcall(function()
                        if not emoteModel:GetAttribute(
                            "Optimized"
                        ) then
                            emoteModel:SetAttribute(
                                "Optimized",
                                true
                            )

                            for _, part in ipairs(
                                emoteModel:GetDescendants()
                            ) do
                                if part:IsA(
                                    "BasePart"
                                ) then
                                    part.CanCollide =
                                        false
                                    part.CanQuery =
                                        false
                                    part.CanTouch =
                                        false
                                    part.Massless =
                                        true
                                    part.RootPriority =
                                        -1

                                    pcall(function()
                                        part.CollisionGroup =
                                            "PlayerVis"
                                    end)
                                end
                            end
                        end
                    end)

                    emoteModelClone =
                        emoteModel:Clone()

                    emoteModelClone.Parent =
                        rig

                    -- This is the important part that the previous
                    -- preview was missing. Native SetModel rewires
                    -- the authored Motor6D/Weld Part0 references
                    -- from the source character to the preview rig.
                    for _, joint in ipairs(
                        emoteModelClone:GetChildren()
                    ) do
                        if joint:IsA("Motor6D")
                            or joint:IsA("Weld")
                        then
                            local part0 =
                                joint.Part0

                            if part0
                                and part0.Parent
                                    == characterFolder
                            then
                                if part0.Name
                                    == "HumanoidRootPart"
                                then
                                    joint.Part0 =
                                        rig.PrimaryPart
                                else
                                    joint.Part0 =
                                        rig:FindFirstChild(
                                            part0.Name
                                        )
                                end
                            end
                        end
                    end
                end
            end

            rig.Parent =
                worldModel

            -- =================================================
            -- EXACT Activate() STATE
            -- =================================================

            local emoteInfo

            pcall(function()
                local info =
                    require(
                        itemModule
                    )

                if type(info) == "table" then
                    emoteInfo =
                        info.EmoteInfo
                end
            end)

            local previewState = {
                Active = true,
                Character = rig,
                Rig = nil,
                EmoteModule = itemModule,
                EmoteInfo = emoteInfo,
                EmoteModel = emoteModelClone,
                Animations = {}
            }

            if activateModule then
                pcall(function()
                    local fn =
                        require(
                            activateModule
                        )

                    if type(fn) == "function"
                    then
                        fn(
                            emoteModelClone,
                            previewState
                        )
                    end
                end)
            end

            -- =================================================
            -- EXACT MAIN ANIMATION
            -- =================================================

            local humanoid =
                rig:FindFirstChildOfClass(
                    "Humanoid"
                )

            local animator

            if humanoid then
                animator =
                    humanoid:FindFirstChildOfClass(
                        "Animator"
                    )

                if not animator then
                    animator =
                        Instance.new(
                            "Animator"
                        )

                    animator.Parent =
                        humanoid
                end
            end

            if not animator then
                local controller =
                    rig:FindFirstChildOfClass(
                        "AnimationController"
                    )

                if not controller then
                    controller =
                        Instance.new(
                            "AnimationController"
                        )

                    controller.Parent =
                        rig
                end

                animator =
                    controller:FindFirstChildOfClass(
                        "Animator"
                    )

                if not animator then
                    animator =
                        Instance.new(
                            "Animator"
                        )

                    animator.Parent =
                        controller
                end
            end

            if mainAnimation
                and animator
            then
                local loaded,
                    track =
                    pcall(function()
                        -- Native code loads the actual Animation
                        -- object directly, not a reconstructed ID.
                        return animator:
                            LoadAnimation(
                                mainAnimation
                            )
                    end)

                if loaded
                    and track
                then
                    track.Priority =
                        Enum.AnimationPriority.Action3

                    track.Looped =
                        not (
                            emoteInfo
                            and emoteInfo.Length
                            and emoteInfo.Length > 0
                        )

                    previewState.Animations.Animation =
                        track

                    pcall(function()
                        track:Play(
                            0
                        )
                    end)

                    -- Native preview path:
                    -- Activate(..., true) -> pause at 0.5.
                    pcall(function()
                        track:AdjustSpeed(
                            0
                        )

                        track.TimePosition =
                            0.5
                    end)
                end
            end

            -- =================================================
            -- CAMERA
            -- =================================================

            local camera =
                Instance.new(
                    "Camera"
                )

            camera.FieldOfView =
                30

            camera.CFrame =
                CFrame.new(
                    0,
                    0.34,
                    0
                )
                * CFrame.new(
                    (
                        rig.PrimaryPart.CFrame
                        * CFrame.new(
                            4.25,
                            1.7,
                            -8.5
                        )
                    ).Position,
                    rig.PrimaryPart.CFrame.Position
                )

            camera.Parent =
                worldModel

            viewport.CurrentCamera =
                camera

            return true
        end)

    if not success then
        warn(
            "[DeadEye] Emote preview failed:",
            result
        )
    end

    return success
end
--// =========================================================
--// NativeWheel module
getgenv().DEADEYE_NATIVE_WHEEL_CONTEXT = {
    LocalPlayer = LocalPlayer,
    genv = genv,
    SLOT_COUNT = __UI.__L.SLOT_COUNT,
    slots = __UI.__L.slots,
    prepareOriginalModule = prepareOriginalModule,
    prepareReplaceModule = prepareReplaceModule,
    getEmoteName = getEmoteName,
    createEmotePreview = __UI.__L.createEmotePreview,
    isEnabled = function()
        return enabled
    end
}

__UI.__L.NativeWheel =
    loadstring(
        game:HttpGet(
            "https://raw.githubusercontent.com/skirkzhdimenya-source/DeadEye/8d0f6ff3659781c4beedbf2d2b33f6c6c0731fe3/DeadEye_NativeWheel.lua"
        )
    )()

--// Backward-compatible guard for a cached old factory-style module.
if type(__UI.__L.NativeWheel) == "function" then
    __UI.__L.NativeWheel = __UI.__L.NativeWheel(
        getgenv().DEADEYE_NATIVE_WHEEL_CONTEXT
    )
end

getgenv().DEADEYE_NATIVE_WHEEL_CONTEXT = nil

if type(__UI.__L.NativeWheel) ~= "table" then
    error(
        "[DeadEye] NativeWheel module did not return an API table"
    )
end
--// =========================================================
--// REBUILD PICKER
--// =========================================================
__UI.__L.rebuildPicker = function()
    for _, button in ipairs(
        __UI.__L.pickerButtons
    ) do
        pcall(function()
            local preview = button:FindFirstChild("EmotePreview")
            if preview then
                local id = tonumber(string.match(button.Name, "^Emote_(%d+)$"))
                if id then
                    __UI.__L.emotePreviewCache[id] = preview
                    preview.Parent = __UI.__L.emotePreviewCacheHolder
                end
            end
        end)
        pcall(function()
            button:Destroy()
        end)
    end
    table.clear(
        __UI.__L.pickerButtons
    )
    local query =
        string.lower(
            __UI.__L.PickerSearch.Text
                or ""
        )
    local shown = 0

    do
        local button =
            Instance.new("TextButton")

        button.Name = "Emote_None"
        button:SetAttribute("DeadEyePickerSearch", "none")
        button.Size = UDim2.new(0, 150, 0, 34)
        button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        button.BorderSizePixel = 0
        button.Text = "NONE"
        button.TextSize = 11
        button.Font = Enum.Font.GothamBold
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextTruncate = Enum.TextTruncate.AtEnd
        button.LayoutOrder = 0
        button.ZIndex = 22
        button.Parent = __UI.__L.PickerScroll

        local corner =
            Instance.new("UICorner")

        corner.CornerRadius =
            UDim.new(0, 5)
        corner.Parent = button

        table.insert(
            __UI.__L.pickerButtons,
            button
        )

        button.MouseButton1Click:Connect(
            function()
                if not __UI.__L.activePickerSlot
                    or not __UI.__L.activePickerSide then
                    return
                end

                local slot =
                    __UI.__L.slots[__UI.__L.activePickerSlot]

                if __UI.__L.activePickerSide == "Original" then
                    slot.originalId = nil
                    slot.originalName = nil
                    __UI.__L.slotOriginalButtons[
                        __UI.__L.activePickerSlot
                    ].Text = "Select"
                else
                    slot.replaceId = nil
                    slot.replaceName = nil
                    __UI.__L.slotReplaceButtons[
                        __UI.__L.activePickerSlot
                    ].Text = "Select"
                end

                __UI.__L.savedConfig.emotes[
                    __UI.__L.activePickerSlot
                ] = {
                    originalId = slot.originalId,
                    replaceId = slot.replaceId
                }

                saveSavedConfig()

                if __UI.__L.EmoteRuntime.getCurrentOriginalId() == slot.originalId
                    or (
                        __UI.__L.EmoteRuntime.getCurrentOriginalId()
                        and not slot.originalId
                    )
                then
                    __UI.__L.EmoteRuntime.stopCustomEmote()
                end

                __UI.__L.Status.Text =
                    "Slot "
                    .. tostring(__UI.__L.activePickerSlot)
                    .. " cleared"

                __UI.__L.Picker.Visible = false
                __UI.__L.activePickerSlot = nil
                __UI.__L.activePickerSide = nil
            end
        )

        shown = shown + 1
    end

    for index, data in ipairs(
        __UI.__L.emoteList
    ) do
        local nameLower =
            string.lower(
                data.name
            )
        if query == ""
            or string.find(
                nameLower,
                query,
                1,
                true
            ) then
            shown = shown + 1
            local button =
                Instance.new("TextButton")
            button.Name =
                "Emote_" ..
                tostring(
                    data.id
                )
            button:SetAttribute(
                "DeadEyePickerSearch",
                nameLower
            )
            button.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            button.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            button.BorderSizePixel =
                0
            button.Text =
                ""
            button.TextSize =
                11
            button.Font =
        Enum.Font.GothamBold
            button.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            button.TextTruncate =
                Enum.TextTruncate.AtEnd
            button.LayoutOrder =
                index
            button.ZIndex =
                32
            button.Parent =
                __UI.__L.PickerScroll


            --// NATIVE EMOTE PREVIEW
            --// Fully local: no native ViewportFrame clone and
            --// no EmoteService/ClientItemService viewport call.
            local viewport =
                Instance.new(
                    "ViewportFrame"
                )
            viewport.Name =
                "EmotePreview"
            viewport.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            viewport.Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                )
            viewport.BackgroundColor3 =
                Color3.fromRGB(
                    31,
                    35,
                    42
                )
            viewport.BackgroundTransparency =
                0
            viewport.BorderSizePixel =
                0
            viewport.Active =
                false
            viewport.ZIndex =
                33
            viewport.Parent =
                button

            local viewportCorner =
                Instance.new(
                    "UICorner"
                )
            viewportCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            viewportCorner.Parent =
                viewport

            local cachedPreview =
                __UI.__L.emotePreviewCache[data.id]

            if cachedPreview then
                pcall(function()
                    viewport:Destroy()
                end)
                cachedPreview.Parent = button
                viewport = cachedPreview
            else
                __UI.__L.createEmotePreview(
                    data.module,
                    viewport
                )
                __UI.__L.emotePreviewCache[data.id] = viewport
            end

            --// GLASS OVERLAY
            local glass =
                Instance.new("Frame")
            glass.Name =
                "GlassOverlay"
            glass.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )
            glass.Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                )
            glass.BackgroundColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            glass.BackgroundTransparency =
                0.95
            glass.BorderSizePixel =
                0
            glass.Active =
                false
            glass.ZIndex =
                34
            glass.Parent =
                button

            local glassCorner =
                Instance.new("UICorner")
            glassCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            glassCorner.Parent =
                glass

            --// NAME SHADE
            local shade =
                Instance.new("Frame")
            shade.Name =
                "NameShade"
            shade.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    36
                )
            shade.Position =
                UDim2.new(
                    0,
                    0,
                    1,
                    -36
                )
            shade.BackgroundColor3 =
                Color3.fromRGB(
                    0,
                    0,
                    0
                )
            shade.BackgroundTransparency =
                0.42
            shade.BorderSizePixel =
                0
            shade.Active =
                false
            shade.ZIndex =
                35
            shade.Parent =
                button

            local nameCorner =
                Instance.new("UICorner")
            nameCorner.CornerRadius =
                UDim.new(
                    0,
                    10
                )
            nameCorner.Parent =
                shade

            local nameLabel =
                Instance.new("TextLabel")
            nameLabel.Name =
                "EmoteName"
            nameLabel.Size =
                UDim2.new(
                    1,
                    -12,
                    0,
                    30
                )
            nameLabel.Position =
                UDim2.new(
                    0,
                    6,
                    1,
                    -33
                )
            nameLabel.BackgroundTransparency =
                1
            nameLabel.BorderSizePixel =
                0
            nameLabel.Text =
                data.name
            nameLabel.TextSize =
                11
            nameLabel.Font =
                Enum.Font.GothamMedium
            nameLabel.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            nameLabel.TextXAlignment =
                Enum.TextXAlignment.Left
            nameLabel.TextYAlignment =
                Enum.TextYAlignment.Center
            nameLabel.TextTruncate =
                Enum.TextTruncate.AtEnd
            nameLabel.ZIndex =
                36
            nameLabel.Parent =
                button
            local buttonCorner =
                Instance.new("UICorner")
            buttonCorner.CornerRadius =
                UDim.new(
                    0,
                    5
                )
            buttonCorner.Parent =
                button
            table.insert(
                __UI.__L.pickerButtons,
                button
            )
            button.MouseButton1Click:Connect(
                function()
                    if not __UI.__L.activePickerSlot
                        or not __UI.__L.activePickerSide then
                        return
                    end
                    local slot =
                        __UI.__L.slots[
                            __UI.__L.activePickerSlot
                        ]
                    if __UI.__L.activePickerSide ==
                        "Original" then
                        slot.originalId =
                            data.id
                        slot.originalName =
                            data.name
                        prepareOriginalModule(
                            data.id
                        )
                        __UI.__L.slotOriginalButtons[
                            __UI.__L.activePickerSlot
                        ].Text =
                            data.name
                    else
                        slot.replaceId =
                            data.id
                        slot.replaceName =
                            data.name
                        prepareReplaceModule(
                            data.id
                        )
                        __UI.__L.slotReplaceButtons[
                            __UI.__L.activePickerSlot
                        ].Text =
                            data.name
                    end
                    __UI.__L.savedConfig.emotes[
                        __UI.__L.activePickerSlot
                    ] = {
                        originalId =
                            slot.originalId,
                        replaceId =
                            slot.replaceId
                    }
                    saveSavedConfig()
                    --// Если текущий активный mapping
                    --// относится к изменённому слоту,
                    --// заставляем его пересоздаться
                    --// со следующего heartbeat.
                    if __UI.__L.EmoteRuntime.getCurrentOriginalId()
                        == slot.originalId then
                        __UI.__L.EmoteRuntime.stopCustomEmote()
                    end
                    __UI.__L.Status.Text =
                        "Slot "
                        .. tostring(
                            __UI.__L.activePickerSlot
                        )
                        .. " configured"
                    __UI.__L.Picker.Visible =
                        false
                    __UI.__L.activePickerSlot =
                        nil
                    __UI.__L.activePickerSide =
                        nil
                end
            )
        end
    end
    __UI.__L.Status.Text =
        "Found: "
        .. tostring(shown)
    __UI.__L.PickerScroll.CanvasPosition =
        Vector2.new(
            0,
            0
        )
    __UI.__L.emotePickerPreloaded = true
end
--// =========================================================
--// =========================================================
--// =========================================================
--// =========================================================
--// =========================================================
--// =========================================================
--// =========================================================
--// =========================================================
--// =========================================================
--// =========================================================
--// PICKER APPEARANCE
--// 2.2-second fade + size-in from the center.
--// Uses the popup Size instead of UIScale, so Roblox does not
--// resample the text while the window is opening.
--// =========================================================
__UI.PickerAppearTweens =
    __UI.PickerAppearTweens or {}

--// Immutable appearance targets for each picker.
--// Never use an in-progress tween value as the next final state.
__UI.PickerAppearFinalSizes =
    __UI.PickerAppearFinalSizes or {}

__UI.PickerAppearBaseStates =
    __UI.PickerAppearBaseStates or {}

function __UI.animatePickerAppear(
    picker
)
    if not picker
        or not picker.Parent
    then
        return
    end

    local oldTweens =
        __UI.PickerAppearTweens[picker]

    if type(oldTweens) == "table" then
        for _, tween in ipairs(
            oldTweens
        ) do
            pcall(function()
                tween:Cancel()
            end)
        end
    end

    picker.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    picker.Position =
        UDim2.new(
            0.5,
            0,
            0.5,
            0
        )

    local finalSize =
        __UI.PickerAppearFinalSizes[picker]

    if not finalSize then
        finalSize =
            picker.Size

        __UI.PickerAppearFinalSizes[picker] =
            finalSize
    end

    local startSize =
        UDim2.new(
            finalSize.X.Scale * 0.90,
            math.floor(
                finalSize.X.Offset * 0.90
                + 0.5
            ),
            finalSize.Y.Scale * 0.90,
            math.floor(
                finalSize.Y.Offset * 0.90
                + 0.5
            )
        )

    local targets = {}

    table.insert(
        targets,
        picker
    )

    for _, object in ipairs(
        picker:GetDescendants()
    ) do
        table.insert(
            targets,
            object
        )
    end

    local states =
        __UI.PickerAppearBaseStates[picker]

    if not states then
        states = {}
        __UI.PickerAppearBaseStates[picker] = states
    end

    for _, object in ipairs(
        targets
    ) do
        local state =
            states[object]

        if not state then
            state = {}

            if object:IsA("GuiObject") then
                state.background =
                    object.BackgroundTransparency
            end

            if object:IsA("TextLabel")
                or object:IsA("TextButton")
                or object:IsA("TextBox")
            then
                state.text =
                    object.TextTransparency

                state.textStroke =
                    object.TextStrokeTransparency
            end

            if object:IsA("ImageLabel")
                or object:IsA("ImageButton")
            then
                state.image =
                    object.ImageTransparency
            end

            if object:IsA("ScrollingFrame") then
                state.scrollbar =
                    object.ScrollBarImageTransparency
            end

            if object:IsA("UIStroke") then
                state.stroke =
                    object.Transparency
            end

            states[object] = state
        end

        if state.background ~= nil then
            object.BackgroundTransparency = 1
        end

        if state.text ~= nil then
            object.TextTransparency = 1
            object.TextStrokeTransparency = 1
        end

        if state.image ~= nil then
            object.ImageTransparency = 1
        end

        if state.scrollbar ~= nil then
            object.ScrollBarImageTransparency = 1
        end

        if state.stroke ~= nil then
            object.Transparency = 1
        end
    end

    picker.Size =
        startSize

    picker.Visible =
        true

    local tweens = {}

    local info =
        TweenInfo.new(
            3.20,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        )

    local textInfo =
        TweenInfo.new(
            0.55,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        )

    pcall(function()
        local sizeTween =
            __UI.TweenService:Create(
                picker,
                info,
                {
                    Size = finalSize
                }
            )

        table.insert(
            tweens,
            sizeTween
        )

        sizeTween:Play()
    end)

    for object, state in pairs(
        states
    ) do
        if object
            and object.Parent
        then
            local goal = {}

            if state.background ~= nil then
                goal.BackgroundTransparency =
                    state.background
            end

            if state.text ~= nil then
                goal.TextTransparency =
                    state.text
            end

            if state.textStroke ~= nil then
                goal.TextStrokeTransparency =
                    state.textStroke
            end

            if state.image ~= nil then
                goal.ImageTransparency =
                    state.image
            end

            if state.scrollbar ~= nil then
                goal.ScrollBarImageTransparency =
                    state.scrollbar
            end

            if state.stroke ~= nil then
                goal.Transparency =
                    state.stroke
            end

            if next(goal) then
                pcall(function()
                    local tween =
                        __UI.TweenService:Create(
                            object,
                            (
                                state.text ~= nil
                                and textInfo
                                or info
                            ),
                            goal
                        )

                    table.insert(
                        tweens,
                        tween
                    )

                    tween:Play()
                end)
            end
        end
    end

    __UI.PickerAppearTweens[picker] =
        tweens
end

--// OPEN PICKER


--// =========================================================
__UI.__L.openPicker = function(
    slotIndex,
    side
)
    __UI.__L.activePickerSlot =
        slotIndex
    __UI.__L.activePickerSide =
        side
    if side == "Original" then
        __UI.__L.PickerTitle.Text =
            "Slot "
            .. tostring(
                slotIndex
            )
            .. " • Original"
    else
        __UI.__L.PickerTitle.Text =
            "Slot "
            .. tostring(
                slotIndex
            )
            .. " • Replace"
    end
    __UI.__L.PickerSearch.Text =
        ""

    if not __UI.__L.emotePickerPreloaded then
        __UI.__L.rebuildPicker()
    end

    __UI.animatePickerAppear(
        __UI.__L.Picker
    )
end
--// =========================================================
--// CLOSE PICKER
--// =========================================================
__UI.__L.closePicker = function()
    __UI.__L.Picker.Visible =
        false
    __UI.__L.activePickerSlot =
        nil
    __UI.__L.activePickerSide =
        nil
end
--// =========================================================
--// CONNECT SLOT BUTTONS
--// =========================================================
for slotIndex = 1, __UI.__L.SLOT_COUNT do
    __UI.__L.slotOriginalButtons[
        slotIndex
    ].MouseButton1Click:Connect(
        function()
            __UI.__L.openPicker(
                slotIndex,
                "Original"
            )
        end
    )
    __UI.__L.slotReplaceButtons[
        slotIndex
    ].MouseButton1Click:Connect(
        function()
            __UI.__L.openPicker(
                slotIndex,
                "Replace"
            )
        end
    )
end
--// =========================================================
--// SEARCH
--// =========================================================
__UI.__L.addConnection(
    __UI.__L.PickerSearch:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()
            if __UI.__L.Picker.Visible then
                __UI.__L.rebuildPicker()
            end
        end
    )
)
__UI.__L.PickerClose.MouseButton1Click:Connect(
    function()
        __UI.__L.closePicker()
    end
)
--// =========================================================
--// TOGGLE
--// =========================================================
__UI.__L.addConnection(
    __UI.__L.Toggle.MouseButton1Click:Connect(
        function()
            if __UI.__L.currentCategory == "Cosmetic" then
                local valid = false

                for index = 1, 2 do
                    local state =
                        __UI.__L.cosmetic.slots[index]

                    if state.originalId
                        and state.replaceId
                        and state.originalId
                            ~= state.replaceId
                    then
                        valid = true
                        break
                    end
                end

                if valid then
                    __UI.__L.cosmetic.enabled =
                        not __UI.__L.cosmetic.enabled

                    pcall(
                        __UI.__L.cosmetic.updateToggle
                    )

                    -- Apply directly to the existing live rig.
                    -- Future respawns are still handled by SetRig.
                    task.spawn(function()
                        pcall(
                            __UI.__L.cosmetic.refreshRig
                        )
                    end)
                else
                    __UI.__L.cosmetic.enabled = false

                    pcall(
                        __UI.__L.cosmetic.updateToggle
                    )
                end

                return
            end

            if __UI.__L.currentCategory == "Unusual" then
                if __UI.__L.unusualEnabled then
                    __UI.__L.unusualEnabled =
                        false
                    genv.UNUSUAL_SWAPPER_ENABLED =
                        false
                    __UI.__L.UnusualFns.restoreUnusual()
                else
                    if not __UI.__L.unusualSlot.originalId
                        or not __UI.__L.unusualSlot.replaceId
                    then
                        __UI.__L.unusualStatus.Text =
                            "Select both Unusuals first"
                        return
                    end
                    if __UI.__L.UnusualFns.activateUnusual() then
                        __UI.__L.unusualEnabled =
                            true
                        __UI.__L.unusualRuntime.appliedRig =
                            __UI.__L.UnusualFns.getUnusualVisualRig()
                        genv.UNUSUAL_SWAPPER_ENABLED =
                            true
                    end
                end
                __UI.__L.updateUnusualToggle()
                return
            end
            --// EXISTING EMOTE TOGGLE
            if enabled then
                enabled = false
                __UI.__L.EmoteRuntime.stopCustomEmote()
                __UI.__L.NativeWheel.restore()
                updateGUI()
                __UI.__L.Status.Text =
                    "Swap disabled"
                                return
            end
            local validSlots = 0
            for i = 1, __UI.__L.SLOT_COUNT do
                local slot =
                    __UI.__L.slots[i]
                if slot.originalId
                    and slot.replaceId
                then
                    local a =
                        prepareOriginalModule(
                            slot.originalId
                        )
                    local b =
                        prepareReplaceModule(
                            slot.replaceId
                        )
                    if a and b then
                        validSlots =
                            validSlots + 1
                    end
                end
            end
            if validSlots == 0 then
                __UI.__L.Status.Text =
                    "No configured slots"
                return
            end
            enabled =
                true
            __UI.__L.NativeWheel.reset()
            __UI.__L.EmoteRuntime.reset()
            __UI.__L.NativeWheel.sync()
            updateGUI()
            __UI.__L.Status.Text =
                "Active • "
                .. tostring(
                    validSlots
                )
                .. " slots"
                    end
    )
)

--// =========================================================
--// MINIMIZE STATE
--// =========================================================
__UI.__L.setMainMinimized = function(state)
    __UI.__L.mainMinimized = state
    if __UI.__L.mainMinimized then
        __UI.__L.Main.Size =
            UDim2.new(
                0,                245,
                0,
                40
            )
        __UI.__L.MainTitle.Size =
            UDim2.new(
                0,
                155,
                0,
                36
            )
        __UI.__L.Status.Visible = false
        __UI.__L.Toggle.Visible = false
        __UI.__L.SlotsScroll.Visible = false
        if __UI.__L.Picker then
            __UI.__L.Picker.Visible = false
        end
        pcall(function()
            __UI.__L.categoryBar.Visible = false
            __UI.__L.mainPage.Visible = false
            __UI.__L.unusualPage.Visible = false
            __UI.__L.unusualStatus.Visible = false
            __UI.__L.others.page.Visible = false
        end)
        __UI.__L.Minimize.Text = "+"

        for _, name in ipairs({
            "ResizeRight",
            "ResizeBottom",
            "ResizeCorner"
        }) do
            local handle =
                __UI.__L.Main:FindFirstChild(name)
            if handle then
                handle.Visible = false
            end
        end
    else
        __UI.__L.Main.Size =
            UDim2.new(
                0,
                math.max(
                    __UI.__L.MIN_WINDOW_WIDTH,
                    __UI.__L.savedConfig.gui.width
                ),
                0,
                math.max(
                    __UI.__L.MIN_WINDOW_HEIGHT,
                    __UI.__L.savedConfig.gui.height
                )
            )
        __UI.__L.MainTitle.Size =
            UDim2.new(
                1,
                -105,
                0,
                36
            )
        __UI.__L.Status.Visible = true
        __UI.__L.Toggle.Visible = true
        __UI.__L.SlotsScroll.Visible = true
        pcall(function()
            __UI.__L.categoryBar.Visible = true
            if __UI.__L.currentCategory == "Main" then
                __UI.__L.Status.Visible = false
                __UI.__L.Toggle.Visible = false
                __UI.__L.SlotsScroll.Visible = false
                __UI.__L.mainPage.Visible = true
                __UI.__L.unusualPage.Visible = false
                __UI.__L.unusualStatus.Visible = false
                __UI.__L.others.page.Visible = false
            elseif __UI.__L.currentCategory == "Unusual" then
                __UI.__L.Status.Visible = false
                __UI.__L.Toggle.Visible = true
                __UI.__L.Toggle.Parent =
                    __UI.__L.unusualPage
                __UI.__L.Toggle.LayoutOrder =
                    0
                __UI.__L.SlotsScroll.Visible = false
                __UI.__L.mainPage.Visible = false
                __UI.__L.unusualPage.Visible = true
                __UI.__L.unusualStatus.Visible = false
                __UI.__L.others.page.Visible = false
            elseif __UI.__L.currentCategory == "Others" then
                __UI.__L.Status.Visible = false
                __UI.__L.Toggle.Visible = false
                __UI.__L.SlotsScroll.Visible = false
                __UI.__L.mainPage.Visible = false
                __UI.__L.unusualPage.Visible = false
                __UI.__L.unusualStatus.Visible = false
                __UI.__L.others.page.Visible = true
                __UI.__L.cosmetic.page.Visible = false
            elseif __UI.__L.currentCategory == "Cosmetic" then
                __UI.__L.Status.Visible = false
                __UI.__L.Toggle.Visible = true
                __UI.__L.Toggle.Parent = __UI.__L.cosmetic.page
                __UI.__L.Toggle.LayoutOrder = 0
                __UI.__L.SlotsScroll.Visible = false
                __UI.__L.mainPage.Visible = false
                __UI.__L.unusualPage.Visible = false
                __UI.__L.unusualStatus.Visible = false
                __UI.__L.others.page.Visible = false
                __UI.__L.cosmetic.page.Visible = true
                __UI.__L.unusualPicker.Visible = false
                __UI.__L.cosmetic.updateToggle()
            else
                __UI.__L.mainPage.Visible = false
                __UI.__L.unusualPage.Visible = false
                __UI.__L.unusualStatus.Visible = false
                __UI.__L.others.page.Visible = false
            end
        end)
        __UI.__L.Minimize.Text = "−"

        for _, name in ipairs({
            "ResizeRight",
            "ResizeBottom",
            "ResizeCorner"
        }) do
            local handle =
                __UI.__L.Main:FindFirstChild(name)
            if handle then
                handle.Visible = true
            end
        end
    end
end
--// =========================================================
--// MINIMIZE BUTTON CONNECTION
--// =========================================================
__UI.__L.addConnection(
    __UI.__L.Minimize.MouseButton1Click:Connect(
        function()
            __UI.__L.setMainMinimized(
                not __UI.__L.mainMinimized
            )
        end
    )
)
--// =========================================================
--// GUI UPDATE
--// =========================================================
function updateGUI()
    if enabled then
        __UI.__L.Toggle.Text =
            "SWAP: ON"
        __UI.__L.Toggle.BackgroundColor3 =
            Color3.fromRGB(
                68,
                74,
                84
            )
    else
        __UI.__L.Toggle.Text =
            "SWAP: OFF"
        __UI.__L.Toggle.BackgroundColor3 =
            Color3.fromRGB(
                47,
                52,
                61
            )
    end
end
--// =========================================================
--// WATCHER
--// =========================================================
__UI.__L.addConnection(
    RunService.Heartbeat:Connect(
        function()
            if not genv.EMOTE_SWAPPER_RUNNING then
                return
            end
            __UI.__L.NativeWheel.sync()
            __UI.__L.EmoteRuntime.checkState()
        end
    )
)
__UI.__L.DragHandle =
    Instance.new("Frame")
__UI.__L.DragHandle.Name =
    "DragHandle"
__UI.__L.DragHandle.Size =
    UDim2.new(
        1,
        -105,
        0,
        39
    )
__UI.__L.DragHandle.Position =
    UDim2.new(
        0,
        1,
        0,
        1
    )
__UI.__L.DragHandle.BackgroundTransparency =
    1
__UI.__L.DragHandle.BorderSizePixel =
    0
__UI.__L.DragHandle.Active =
    true
__UI.__L.DragHandle.ZIndex =
    4
__UI.__L.DragHandle.Parent =
    __UI.__L.Main

--// =========================================================
--// WINDOW GEOMETRY / DRAG / RESIZE
-- =========================================================
__UI.__L.dragging = false
__UI.__L.dragStart
__UI.__L.startPosition

__UI.__L.resizing = false
__UI.__L.resizeMode = nil
__UI.__L.resizeStart
__UI.__L.resizeStartSize

__UI.__L.saveWindowState = function()
    __UI.__L.savedConfig.gui =
        __UI.__L.savedConfig.gui
        or {}

    __UI.__L.savedConfig.gui.x =
        math.floor(
            __UI.__L.Main.Position.X.Offset
            + 0.5
        )

    __UI.__L.savedConfig.gui.y =
        math.floor(
            __UI.__L.Main.Position.Y.Offset
            + 0.5
        )

    if not __UI.__L.mainMinimized then
        __UI.__L.savedConfig.gui.width =
            math.floor(
                __UI.__L.Main.AbsoluteSize.X
                + 0.5
            )

        __UI.__L.savedConfig.gui.height =
            math.floor(
                __UI.__L.Main.AbsoluteSize.Y
                + 0.5
            )
    end

    pcall(function()
        saveSavedConfig()
    end)
end

__UI.__L.clampWindowPosition = function()
    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    local viewport =
        camera.ViewportSize

    local width =
        __UI.__L.Main.AbsoluteSize.X

    local height =
        __UI.__L.Main.AbsoluteSize.Y

    local x =
        __UI.__L.Main.Position.X.Offset

    local y =
        __UI.__L.Main.Position.Y.Offset

    local maxX =
        math.max(
            8,
            viewport.X - width - 8
        )

    local maxY =
        math.max(
            8,
            viewport.Y - height - 8
        )

    __UI.__L.Main.Position =
        UDim2.new(
            0,
            math.clamp(
                x,
                8,
                maxX
            ),
            0,
            math.clamp(
                y,
                8,
                maxY
            )
        )
end

__UI.__L.setMainSize = function(
    width,
    height
)
    __UI.__L.Main.Size =
        UDim2.new(
            0,
            math.max(
                __UI.__L.MIN_WINDOW_WIDTH,
                math.floor(
                    width + 0.5
                )
            ),
            0,
            math.max(
                __UI.__L.MIN_WINDOW_HEIGHT,
                math.floor(
                    height + 0.5
                )
            )
        )

    __UI.__L.clampWindowPosition()
end

--// Drag the title bar.
__UI.__L.beginWindowDrag = function(input)
    if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        or input.UserInputType ==
            Enum.UserInputType.Touch
    then
        __UI.__L.dragging = true
        __UI.__L.dragStart =
            input.Position
        __UI.__L.startPosition =
            __UI.__L.Main.Position
    end
end

__UI.__L.addConnection(
    __UI.__L.DragHandle.InputBegan:Connect(
        function(input)
            __UI.__L.beginWindowDrag(input)
        end
    )
)

__UI.__L.addConnection(
    __UI.__L.MainTitle.InputBegan:Connect(
        function(input)
            __UI.__L.beginWindowDrag(input)
        end
    )
)

__UI.__L.addConnection(
    UserInputService.InputChanged:Connect(
        function(input)
            if not __UI.__L.dragging then
                return
            end

            if input.UserInputType ~=
                    Enum.UserInputType.MouseMovement
                and input.UserInputType ~=
                    Enum.UserInputType.Touch
            then
                return
            end

            local delta =
                input.Position -
                __UI.__L.dragStart

            __UI.__L.Main.Position =
                UDim2.new(
                    __UI.__L.startPosition.X.Scale,
                    __UI.__L.startPosition.X.Offset
                        + delta.X,
                    __UI.__L.startPosition.Y.Scale,
                    __UI.__L.startPosition.Y.Offset
                        + delta.Y
                )

            __UI.__L.clampWindowPosition()
        end
    )
)

__UI.__L.beginResize = function(
    position,
    mode
)
    if __UI.__L.mainMinimized then
        return
    end

    __UI.__L.resizing = true
    __UI.__L.resizeMode = mode
    __UI.__L.resizeStart =
        position
    __UI.__L.resizeStartSize =
        __UI.__L.Main.AbsoluteSize
end

--// Invisible right-edge resize target.
__UI.__L.ResizeRight =
    Instance.new("Frame")
__UI.__L.ResizeRight.Name =
    "ResizeRight"
__UI.__L.ResizeRight.Size =
    UDim2.new(
        0,
        __UI.__L.RESIZE_EDGE,
        1,
        -54
    )
__UI.__L.ResizeRight.Position =
    UDim2.new(
        1,
        -__UI.__L.RESIZE_EDGE,
        0,
        48
    )
__UI.__L.ResizeRight.BackgroundTransparency =
    1
__UI.__L.ResizeRight.BorderSizePixel =
    0
__UI.__L.ResizeRight.ZIndex =
    20
__UI.__L.ResizeRight.Active =
    true
__UI.__L.ResizeRight.Parent =
    __UI.__L.Main

__UI.__L.addConnection(
    __UI.__L.ResizeRight.InputBegan:Connect(
        function(input)
            if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch
            then
                __UI.__L.beginResize(
                    input.Position,
                    "right"
                )
            end
        end
    )
)

--// Bottom-edge resize target.
__UI.__L.ResizeBottom =
    Instance.new("Frame")
__UI.__L.ResizeBottom.Name =
    "ResizeBottom"
__UI.__L.ResizeBottom.Size =
    UDim2.new(
        1,
        -54,
        0,
        __UI.__L.RESIZE_EDGE
    )
__UI.__L.ResizeBottom.Position =
    UDim2.new(
        0,
        8,
        1,
        -__UI.__L.RESIZE_EDGE
    )
__UI.__L.ResizeBottom.BackgroundTransparency =
    1
__UI.__L.ResizeBottom.BorderSizePixel =
    0
__UI.__L.ResizeBottom.ZIndex =
    20
__UI.__L.ResizeBottom.Active =
    true
__UI.__L.ResizeBottom.Parent =
    __UI.__L.Main

__UI.__L.addConnection(
    __UI.__L.ResizeBottom.InputBegan:Connect(
        function(input)
            if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch
            then
                __UI.__L.beginResize(
                    input.Position,
                    "bottom"
                )
            end
        end
    )
)

--// Bottom-right corner: width + height together.
__UI.__L.ResizeCorner =
    Instance.new("TextButton")
__UI.__L.ResizeCorner.Name =
    "ResizeCorner"
__UI.__L.ResizeCorner.Size =
    UDim2.new(
        0,
        24,
        0,
        24
    )
__UI.__L.ResizeCorner.Position =
    UDim2.new(
        1,
        -24,
        1,
        -24
    )
__UI.__L.ResizeCorner.BackgroundTransparency =
    1
__UI.__L.ResizeCorner.BorderSizePixel =
    0
__UI.__L.ResizeCorner.Text =
    ""
__UI.__L.ResizeCorner.TextSize =
    1
__UI.__L.ResizeCorner.ZIndex =
    21

for i = 1, 3 do
    local grip =
        Instance.new("Frame")

    grip.Name =
        "Grip" .. tostring(i)

    grip.Size =
        UDim2.new(
            0,
            2,
            0,
            2
        )

    grip.Position =
        UDim2.new(
            0,
            7 + ((i - 1) * 4),
            0,
            15 - ((i - 1) * 4)
        )

    grip.BackgroundColor3 =
        Color3.fromRGB(
            135,
            142,
            155
        )

    grip.BorderSizePixel =
        0

    grip.ZIndex =
        22

    grip.Parent =
        __UI.__L.ResizeCorner
end
__UI.__L.ResizeCorner.AutoButtonColor =
    false
__UI.__L.ResizeCorner.Parent =
    __UI.__L.Main

__UI.__L.addConnection(
    __UI.__L.ResizeCorner.InputBegan:Connect(
        function(input)
            if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch
            then
                __UI.__L.beginResize(
                    input.Position,
                    "corner"
                )
            end
        end
    )
)

__UI.__L.addConnection(
    UserInputService.InputChanged:Connect(
        function(input)
            if not __UI.__L.resizing then
                return
            end

            if input.UserInputType ~=
                    Enum.UserInputType.MouseMovement
                and input.UserInputType ~=
                    Enum.UserInputType.Touch
            then
                return
            end

            local delta =
                input.Position -
                __UI.__L.resizeStart

            local width =
                __UI.__L.resizeStartSize.X

            local height =
                __UI.__L.resizeStartSize.Y

            if __UI.__L.resizeMode == "right"
                or __UI.__L.resizeMode == "corner"
            then
                width =
                    __UI.__L.resizeStartSize.X +
                    delta.X
            end

            if __UI.__L.resizeMode == "bottom"
                or __UI.__L.resizeMode == "corner"
            then
                height =
                    __UI.__L.resizeStartSize.Y +
                    delta.Y
            end

            __UI.__L.setMainSize(
                width,
                height
            )
        end
    )
)

__UI.__L.addConnection(
    UserInputService.InputEnded:Connect(
        function(input)
            if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch
            then
                if __UI.__L.dragging then
                    __UI.__L.dragging = false
                    __UI.__L.saveWindowState()
                end

                if __UI.__L.resizing then
                    __UI.__L.resizing = false
                    __UI.__L.resizeMode = nil
                    __UI.__L.saveWindowState()
                end
            end
        end
    )
)

--// CLEANUP
--// =========================================================
__UI.__L.cleanup = function()
    if __UI.__L.cleaned then
        return
    end

    --// Save the complete Others state before destroying its TextBoxes.
    --// This also persists Avatar Import text and values changed without
    --// pressing APPLY / ENTER.
    pcall(function()
        __UI.__L.others.saveConfig()
    end)

    --// Persist Main / Reverse Look state on close as well.
    pcall(function()
        __UI.__L.mainJump.saveConfig()
    end)

    pcall(function()
        __UI.__L.ScreenGui.Enabled = false
    end)

    __UI.__L.NativeWheel.restore(true)

    pcall(function()
        __UI.__L.mainJump.setRageLookEnabled(
            false,
            false
        )
    end)

    pcall(function()
        __UI.__L.mainJump.uninstallReverseLookHooks()
    end)

    pcall(function()
        __UI.__L.mainJump.destroySensors()
        __UI.__L.mainJump.manualJumpActive = false
        __UI.__L.mainJump.lookAutoJumpCycle = false
        __UI.__L.mainJump.lookTriggeredThisAir = false
    end)

    pcall(function()
        if __UI.__L.mainJump.benchTrimpStateConnection then
            __UI.__L.mainJump.benchTrimpStateConnection:Disconnect()
            __UI.__L.mainJump.benchTrimpStateConnection = nil
        end
        __UI.__L.mainJump.benchTrimpEnabled = false
    end)

    pcall(function()
        if __UI.__L.mainJump.lookActive
            or __UI.__L.mainJump.lookRestoring
        then
            __UI.__L.mainJump.restoreLookNow()
        else
            __UI.__L.mainJump.unbindLookRender()
        end

        if __UI.__L.mainJump.lookStateConnection then
            __UI.__L.mainJump.lookStateConnection:Disconnect()
            __UI.__L.mainJump.lookStateConnection = nil
        end
    end)

    --// Stop every active loop before doing any cleanup that may yield.
    __UI.__L.cleaned = true
    genv.EMOTE_SWAPPER_RUNNING = false
    genv.DEADEYE_MAIN_RUNNING = false
    genv.DEADEYE_UNUSUAL_POV_RUNNING = false
    genv.DEADEYE_PORTRAIT_RUNNING = false

    pcall(function()
        __UI.__L.mainJump.stopCrouchSpam()
    end)

    enabled = false

    pcall(function()
        __UI.__L.EmoteRuntime.stopForCleanup()
    end)

    pcall(function()
        __UI.__L.disconnectAll()
    end)

    pcall(function()
        if genv.UNUSUAL_SWAPPER_CLEANUP then
            genv.UNUSUAL_SWAPPER_CLEANUP()
        end
    end)

    pcall(function()
        if genv.DEADEYE_PORTRAIT_CLEANUP then
            genv.DEADEYE_PORTRAIT_CLEANUP()
        end
    end)

    pcall(function()
        __UI.__L.saveWindowState()
    end)

    pcall(function()
        if __UI.__L.Picker then
            __UI.__L.Picker.Visible = false
        end
    end)

    pcall(function()
        if __UI.__L.ScreenGui then
            __UI.__L.ScreenGui:Destroy()
        end
    end)

    genv.EMOTE_SWAPPER_CLEANUP =
        nil

    genv.DEADEYE_REVERSE_LOOK_CLEANUP =
        nil

    genv.DEADEYE_REVERSE_LOOK =
        nil
end
genv.EMOTE_SWAPPER_CLEANUP =
    __UI.__L.cleanup
--// =========================================================
--// CLOSE
--// =========================================================
__UI.__L.addConnection(
    __UI.__L.Close.MouseButton1Click:Connect(
        function()
            __UI.__L.cleanup()
        end
    )
)
--// =========================================================
--// =========================================================
--// GLASS SURFACE FINISH
--// =========================================================
for _, object in ipairs(
    __UI.__L.Main:GetDescendants()
) do
    if object:IsA("TextButton") then
        pcall(function()
            object.BackgroundTransparency =
                math.max(
                    object.BackgroundTransparency,
                    0.30
                )
        end)
    elseif object:IsA("TextBox") then
        pcall(function()
            object.BackgroundTransparency =
                math.max(
                    object.BackgroundTransparency,
                    0.24
                )
        end)
    elseif object:IsA("ScrollingFrame") then
        pcall(function()
            object.BackgroundTransparency =
                math.max(
                    object.BackgroundTransparency,
                    0.24
                )
        end)
    elseif object:IsA("Frame")
        and object ~= __UI.__L.MainSurface
        and object ~= __UI.__L.MainHeader
        and object ~= __UI.__L.mainJump.autoJumpModePicker
    then
        pcall(function()
            object.BackgroundTransparency =
                math.max(
                    object.BackgroundTransparency,
                    0.24
                )
        end)
    end
end

--// =========================================================
--// =========================================================
--// =========================================================
--// AUTO JUMP MODE PICKER - EXACT BASE VISUAL
--//
--// Picker options are cloned before the final glass pass. Sync
--// them from the finished selector button before hover styling.
--// =========================================================
pcall(function()
    __UI.__L.mainJump.syncAutoJumpModePickerVisual()
end)

--// =========================================================
--// GUI BUTTON MOTION
--// Soft centered hover light + press animation.
--// Uses UIShadow so the light is always rendered BELOW the button.
--// =========================================================
__UI.TweenService =
    game:GetService("TweenService")

__UI.DeadEyeHoverShadows =
    __UI.DeadEyeHoverShadows or {}

__UI.setAutoJumpModePickerHoverSuppressed =
    function(state)
        state =
            state and true or false

        for button, shadow in pairs(
            __UI.DeadEyeHoverShadows
        ) do
            if button
                and button.Parent
                and string.sub(
                    tostring(button.Name),
                    1,
                    13
                ) ~= "AutoJumpMode_"
            then
                pcall(function()
                    button:SetAttribute(
                        "DeadEyeHoverSuppressed",
                        state
                    )
                end)

                if state then
                    pcall(function()
                        shadow.Transparency =
                            1
                    end)

                    local scale =
                        button:FindFirstChild(
                            "DeadEyeHoverScale"
                        )

                    if scale then
                        pcall(function()
                            scale.Scale = 1
                        end)
                    end
                end
            end
        end
    end

function __UI.styleButtonMotion(button)
    if not button
        or not button:IsA("TextButton")
        or button:GetAttribute("DeadEyeHoverStyled")
        or button.Name == "ResizeCorner"
    then
        return
    end

    if string.sub(
        tostring(button.Name),
        1,
        6
    ) == "Resize"
    then
        return
    end

    button:SetAttribute(
        "DeadEyeHoverStyled",
        true
    )

    local parent =
        button.Parent

    if not parent then
        return
    end

    --// Keep the existing centered enlargement unchanged.
    local hasLayout = false

    for _, child in ipairs(
        parent:GetChildren()
    ) do
        if child:IsA("UIGridLayout")
            or child:IsA("UIListLayout")
            or child:IsA("UITableLayout")
            or child:IsA("UIPageLayout")
        then
            hasLayout = true
            break
        end
    end

    pcall(function()
        button.AutoButtonColor =
            false
    end)

    local scale

    if not hasLayout then
        scale =
            button:FindFirstChild(
                "DeadEyeHoverScale"
            )

        if not scale then
            scale =
                Instance.new("UIScale")

            scale.Name =
                "DeadEyeHoverScale"

            scale.Scale =
                1

            scale.Parent =
                button
        end

        local oldAnchor =
            button.AnchorPoint

        if oldAnchor ~= Vector2.new(
            0.5,
            0.5
        ) then
            local oldPosition =
                button.Position

            local size =
                button.Size

            local deltaX =
                0.5
                - oldAnchor.X

            local deltaY =
                0.5
                - oldAnchor.Y

            button.AnchorPoint =
                Vector2.new(
                    0.5,
                    0.5
                )

            button.Position =
                UDim2.new(
                    oldPosition.X.Scale
                        + (
                            size.X.Scale
                            * deltaX
                        ),
                    oldPosition.X.Offset
                        + (
                            size.X.Offset
                            * deltaX
                        ),
                    oldPosition.Y.Scale
                        + (
                            size.Y.Scale
                            * deltaY
                        ),
                    oldPosition.Y.Offset
                        + (
                            size.Y.Offset
                            * deltaY
                        )
                )
        end
    end

    local pickerClose =
        button == __UI.__L.PickerClose
        or button == __UI.__L.unusualPickerClose

    local compact =
        button == __UI.__L.Minimize
        or button == __UI.__L.Close
        or pickerClose

    --// Hover glow belongs to the outer clickable card.
    --// Cosmetic visual contents are masked separately by CosmeticCard.
    local shadowTarget = button

    local shadow =
        button:FindFirstChild(
            "DeadEyeHoverGlow"
        )

    if not shadow then
        local success, result =
            pcall(function()
                return Instance.new("UIShadow")
            end)

        if success
            and result
        then
            shadow =
                result

            if not pickerModeButton then
                shadow.Name =
                    "DeadEyeHoverGlow"

                shadow.Color =
                    Color3.fromRGB(
                        190,
                        204,
                        226
                    )

                shadow.Offset =
                    UDim2.new(
                        0,
                        0,
                        0,
                        0
                    )

                if compact then
                    shadow.Spread =
                        UDim2.fromOffset(
                            2,
                            2
                        )

                    shadow.BlurRadius =
                        UDim.new(
                            0,
                            4
                        )
                else
                    shadow.Spread =
                        UDim2.fromOffset(
                            7,
                            7
                        )

                    shadow.BlurRadius =
                        UDim.new(
                            0,
                            6
                        )
                end

                shadow.Transparency =
                    1

                shadow.Enabled =
                    true

                shadow.ZIndex =
                    -1

                shadow.Parent =
                    shadowTarget
            end

            __UI.DeadEyeHoverShadows[button] =
                shadow
        end
    end

    local hovered = false
    local scaleTween
    local shadowTween

    local enterInfo =
        TweenInfo.new(
            0.16,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        )

    local leaveInfo =
        TweenInfo.new(
            0.20,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        )

    local pressInfo =
        TweenInfo.new(
            0.07,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        )

    local function cancelScaleTween()
        if scaleTween then
            pcall(function()
                scaleTween:Cancel()
            end)

            scaleTween =
                nil
        end
    end

    local function cancelShadowTween()
        if shadowTween then
            pcall(function()
                shadowTween:Cancel()
            end)

            shadowTween =
                nil
        end
    end

    local function tweenShadow(
        info,
        transparency
    )
        if not shadow then
            return
        end

        cancelShadowTween()

        pcall(function()
            shadowTween =
                __UI.TweenService:Create(
                    shadow,
                    info,
                    {
                        Transparency =
                            transparency
                    }
                )

            shadowTween:Play()
        end)
    end

    local function tweenScale(
        target,
        info
    )
        if not scale then
            return
        end

        cancelScaleTween()

        pcall(function()
            scaleTween =
                __UI.TweenService:Create(
                    scale,
                    info,
                    {
                        Scale =
                            target
                    }
                )

            scaleTween:Play()
        end)
    end

    __UI.__L.addConnection(
        button.MouseEnter:Connect(
            function()
                if not button.Parent
                    or button:GetAttribute("DeadEyeHoverSuppressed")
                then
                    return
                end

                hovered = true

                tweenScale(
                    1.018,
                    enterInfo
                )

                --// The shadow is centered on the button itself,
                --// then softly spreads outward from its edges.
                tweenShadow(
                    enterInfo,
                    compact
                    and 0.66
                    or 0.58
                )
            end
        )
    )

    __UI.__L.addConnection(
        button.MouseLeave:Connect(
            function()
                if not button.Parent then
                    return
                end

                if button:GetAttribute("DeadEyeHoverSuppressed") then
                    hovered = false

                    pcall(function()
                        if shadow then
                            shadow.Transparency = 1
                        end

                        if scale then
                            scale.Scale = 1
                        end
                    end)

                    return
                end

                hovered = false

                tweenScale(
                    1,
                    leaveInfo
                )

                tweenShadow(
                    leaveInfo,
                    1
                )
            end
        )
    )

    __UI.__L.addConnection(
        button.MouseButton1Down:Connect(
            function()
                if not button.Parent
                    or button:GetAttribute("DeadEyeHoverSuppressed")
                then
                    return
                end

                tweenScale(
                    0.994,
                    pressInfo
                )

                tweenShadow(
                    pressInfo,
                    compact
                    and 0.74
                    or 0.70
                )
            end
        )
    )

    __UI.__L.addConnection(
        button.MouseButton1Up:Connect(
            function()
                if not button.Parent then
                    return
                end

                if button:GetAttribute("DeadEyeHoverSuppressed") then
                    pcall(function()
                        if shadow then
                            shadow.Transparency = 1
                        end

                        if scale then
                            scale.Scale = 1
                        end
                    end)

                    return
                end

                if hovered then
                    tweenScale(
                        1.018,
                        enterInfo
                    )

                    tweenShadow(
                        enterInfo,
                        pickerClose
                        and 1
                        or (
                            compact
                            and 0.66
                            or 0.58
                        )
                    )
                else
                    tweenScale(
                        1,
                        leaveInfo
                    )

                    tweenShadow(
                        leaveInfo,
                        1
                    )
                end
            end
        )
    )

    __UI.__L.addConnection(
        button.Destroying:Connect(
            function()
                cancelShadowTween()
                cancelScaleTween()

                if __UI.DeadEyeHoverShadows then
                    __UI.DeadEyeHoverShadows[button] =
                        nil
                end
            end
        )
    )
end

for _, object in ipairs(
    __UI.__L.ScreenGui:GetDescendants()
) do
    if object:IsA("TextButton") then
        __UI.styleButtonMotion(object)
    end
end

__UI.__L.addConnection(
    __UI.__L.ScreenGui.DescendantAdded:Connect(
        function(object)
            if object:IsA("TextButton") then
                task.defer(function()
                    __UI.styleButtonMotion(
                        object
                    )
                end)
            end
        end
    )
)

--// INIT
--// =========================================================
pcall(function()
    __UI.__L.clampWindowPosition()
end)
prepareSlots()
__UI.__L.savedConfig.emotes =
    __UI.__L.savedConfig.emotes
    or {}
for i = 1, __UI.__L.SLOT_COUNT do
    __UI.__L.savedConfig.emotes[i] = {
        originalId =
            __UI.__L.slots[i].originalId,
        replaceId =
            __UI.__L.slots[i].replaceId
    }
end
__UI.__L.savedConfig.unusual = {
    originalId =
        __UI.__L.unusualSlot.originalId,
    replaceId =
        __UI.__L.unusualSlot.replaceId
}
__UI.__L.cosmetic.saveState()
saveSavedConfig()

--// PRELOAD PICKER 3D PREVIEWS ON SCRIPT START.
--// Opening the picker later only reuses these ready ViewportFrames.
pcall(function()
    __UI.__L.rebuildPicker()
end)

pcall(function()
    __UI.__L.cosmetic.rebuildPicker()
end)

__UI.__L.setMainMinimized(false)
updateGUI()
pcall(function()
    __UI.__L.setCategory("Emotes")
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/skirkzhdimenya-source/DeadEye/main/DeadEye_Portrait.lua"))()
