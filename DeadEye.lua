--// =========================================================
--// DEADEYE VERSION
--// ТЕКУЩАЯ ВЕРСИЯ: 1.214
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
local SCRIPT_VERSION = "1.214"
--// Others settings are persisted on edit/unfocus and again during cleanup.
--// Reverse Look WITH mode also reinstalls its hook when Crouch Spam is enabled.
--// These reminders must stay near script start.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local __UI = {}
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
local function purgeStaleMainJumpSensors()
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
                or object.Name == "CrouchSpamFootSensor"
            )
        then
            pcall(function()
                object:Destroy()
            end)
        end
    end
end

purgeStaleMainJumpSensors()

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
    if type(decoded.cosmetic) == "table" then
        savedConfig.cosmetic =
            decoded.cosmetic
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

    if savedConfig.main.rageLook ~= true then
        savedConfig.main.rageLook = false
    else
        savedConfig.main.rageLook = true
    end

    if savedConfig.main.benchTrimpEnabled ~= true then
        savedConfig.main.benchTrimpEnabled = false
    else
        savedConfig.main.benchTrimpEnabled = true
    end

    if savedConfig.main.reverseLookMode ~= "with"
        and savedConfig.main.reverseLookMode ~= "without"
    then
        savedConfig.main.reverseLookMode = "without"
    end

    if savedConfig.main.reverseLookEnabled ~= true then
        savedConfig.main.reverseLookEnabled = false
    end

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
function saveSavedConfig()
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
--// =========================================================
--// LOCAL PORTRAIT OVERRIDE MODULE
--// =========================================================
--// Portrait module is loaded at the original final initialization point.

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
local cleaned = false
local connections = {}

--// Native wheel visual state.
--// Keys are logical wheel positions ("Wheel:1", "Wheel2:4"),
--// not GUI Instances. The game can recreate Emote1..Emote6;
--// logical state survives those recreations and repeated ON/OFF.

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
local emotePreviewCache = {}
local cosmeticPreviewCache = {}
local emotePreviewCacheHolder
local cosmeticPreviewCacheHolder
local emotePickerPreloaded = false
local cosmeticPickerPreloaded = false
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
function prepareOriginalModule(id)
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
function prepareReplaceModule(id)
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
function getEmoteName(id)
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
function prepareSlots()
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
local function refreshNativeVisibilityAfterUnusualRestore()
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
--// =========================================================
--// EMOTE RUNTIME MODULE
--// =========================================================
local EmoteRuntime =
    loadstring(
        game:HttpGet(
            "https://raw.githubusercontent.com/skirkzhdimenya-source/DeadEye/a424881ee7e4e542b46a543aaf489734afd102ea/DeadEye_EmoteRuntime.lua"
        )
    )()

if type(EmoteRuntime) == "function" then
    EmoteRuntime = EmoteRuntime(
        {
            genv = genv,
            isEnabled = function()
                return enabled
            end,
            EmoteService = __UI.EmoteService,
            originalAnimationIds = originalAnimationIds
        }
    )
end

if type(EmoteRuntime) ~= "table" then
    error(
        "[DeadEye] EmoteRuntime module did not return an API table"
    )
end
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
--// WINDOW SIZE LIMITS
--// =========================================================
local MIN_WINDOW_WIDTH = 500
local MIN_WINDOW_HEIGHT = 295
local RESIZE_EDGE = 8
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

emotePreviewCacheHolder =
    Instance.new("Frame")
emotePreviewCacheHolder.Name = "DeadEyeEmotePreviewCache"
emotePreviewCacheHolder.Size = UDim2.new(0, 1, 0, 1)
emotePreviewCacheHolder.Position = UDim2.new(0, -10000, 0, -10000)
emotePreviewCacheHolder.BackgroundTransparency = 1
emotePreviewCacheHolder.BorderSizePixel = 0
emotePreviewCacheHolder.Visible = false
emotePreviewCacheHolder.Parent = ScreenGui

cosmeticPreviewCacheHolder =
    Instance.new("Frame")
cosmeticPreviewCacheHolder.Name = "DeadEyeCosmeticPreviewCache"
cosmeticPreviewCacheHolder.Size = UDim2.new(0, 1, 0, 1)
cosmeticPreviewCacheHolder.Position = UDim2.new(0, -10000, 0, -10000)
cosmeticPreviewCacheHolder.BackgroundTransparency = 1
cosmeticPreviewCacheHolder.BorderSizePixel = 0
cosmeticPreviewCacheHolder.Visible = false
cosmeticPreviewCacheHolder.Parent = ScreenGui

--// =========================================================
--// MAIN
--// =========================================================
Main =
    Instance.new("Frame")
Main.Size =
    UDim2.new(
        0,
        math.max(
            MIN_WINDOW_WIDTH,
            savedConfig.gui.width
        ),
        0,
        math.max(
            MIN_WINDOW_HEIGHT,
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
    false
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
    "DeadEyes v" .. SCRIPT_VERSION
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

--// Header button surfaces stay solid.
--// Their hover light is the centered UIShadow created below.
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
local UnusualFns = {}
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

--// =========================================================
--// COSMETIC CATEGORY
--// TWO LOCAL REPLACEMENT SLOTS
--// [Original] -> [Replace]
--// =========================================================
local cosmetic = {
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
others.firstPersonTransparency = {}

local unusualConnections = {}
local unusualDestroyed = false
local unusualReapplyBusy = false
local unusualRuntime = {
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
function UnusualFns.addUnusualConnection(connection)
    table.insert(
        unusualConnections,
        connection
    )
end
function UnusualFns.disconnectUnusualConnections()
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
function UnusualFns.buildUnusualList()
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
UnusualFns.buildUnusualList()
--// =========================================================
--// GET UNUSUAL NAME
--// =========================================================
--// =========================================================
--// COSMETIC HELPERS
--// =========================================================
function cosmetic.getName(id)
    id = tonumber(id)
    if not id then
        return nil
    end

    local name
    pcall(function()
        local entry = Registry.GetById(id)
        local module =
            entry
            and entry.Module
        if module then
            name = module.Name
        end
    end)
    return name
end

function cosmetic.getEquippedId(slot)
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

function cosmetic.updateRow(slotIndex)
    local state =
        cosmetic.slots[slotIndex]

    if not state then
        return
    end

    local row =
        cosmetic.page
        and cosmetic.page:FindFirstChild(
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

function cosmetic.setInitialOriginal(
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
        cosmetic.slots[slotIndex]

    if not state
        or state.originalId
    then
        return
    end

    state.originalId =
        id
    state.originalName =
        cosmetic.getName(id)

    cosmetic.saveState()
    cosmetic.updateRow(slotIndex)
end

function cosmetic.loadState()
    local saved =
        type(savedConfig.cosmetic) == "table"
        and savedConfig.cosmetic
        or {}

    for index = 1, 2 do
        local state =
            cosmetic.slots[index]

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
                    cosmetic.getName(
                        savedOriginal
                    )
            end

            if savedReplace
                and savedReplace ~= 0
            then
                state.replaceId =
                    savedReplace
                state.replaceName =
                    cosmetic.getName(
                        savedReplace
                    )
            end
        end

        -- Only auto-detect the currently equipped item when
        -- this slot has no saved Original mapping.
        if not state.originalId then
            local equipped =
                cosmetic.getEquippedId(index)

            if equipped ~= 0 then
                state.originalId =
                    equipped
                state.originalName =
                    cosmetic.getName(
                        equipped
                    )
            end
        end
    end
end

function cosmetic.saveState()
    savedConfig.cosmetic = {
        slot1 = {
            originalId =
                cosmetic.slots[1].originalId,
            replaceId =
                cosmetic.slots[1].replaceId
        },
        slot2 = {
            originalId =
                cosmetic.slots[2].originalId,
            replaceId =
                cosmetic.slots[2].replaceId
        }
    }
end

function cosmetic.buildList()
    table.clear(
        cosmetic.list
    )

    local success, all =
        pcall(function()
            return Registry.GetAll()
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
                    Registry.GetConfig(
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
                            Registry.GetById(
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
                            getUnusualIconFromData(
                                numericId,
                                data,
                                module
                            )
                    end)

                    table.insert(
                        cosmetic.list,
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
        cosmetic.list,
        function(a, b)
            return a.id < b.id
        end
    )

    warn(
        "[DeadEye] Cosmetics:",
        tostring(
            #cosmetic.list
        )
    )
end

function cosmetic.replaceArray(cosmetics)
    if not cosmetic.enabled
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
                        cosmetic.slots[slotIndex]

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

function cosmetic.getLiveRig()
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

function cosmetic.refreshRig()
    if cosmetic.refreshBusy then
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
    if not cosmetic.skinDescription
        or cosmetic.skinCharacter == live
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

        cosmetic.skinDescription =
            clone
        cosmetic.skinCharacter =
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
        UnusualFns.getEquippedUnusualId()

    local restoreUnusualSwap =
        unusualEnabled
        and unusualActive
        and unusualRuntime.originalId
        and tonumber(
            unusualRuntime.originalId
        ) == tonumber(
            equippedUnusualId
        )

    local restoreNativeUnusualId =
        nil

    local cosmeticUnusualSnapshot =
        nil

    if restoreUnusualSwap then
        cosmeticUnusualSnapshot =
            unusualRuntime.nativeSnapshot
    elseif equippedUnusualId
        and equippedUnusualId ~= 0
    then
        restoreNativeUnusualId =
            tonumber(equippedUnusualId)

        cosmeticUnusualSnapshot =
            UnusualFns.captureNativeUnusualSnapshot(
                equippedUnusualId,
                UnusualFns.getUnusualVisualRig(),
                UnusualFns.getUnusualPlayerCharacter()
            )
    end

    if restoreUnusualSwap then
        pcall(function()
            UnusualFns.removeOurUnusualFX()
        end)
        unusualActive = false
    end

    cosmetic.refreshBusy = true

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
                    cosmetic.skinDescription
                )

                restoredSkin = true
            end)

            if not restoredSkin then
                pcall(function()
                    humanoid:ApplyDescriptionReset(
                        cosmetic.skinDescription
                    )

                    restoredSkin = true
                end)
            end

            if not restoredSkin then
                pcall(function()
                    humanoid:ApplyDescriptionAsync(
                        cosmetic.skinDescription
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
                    cosmetic.slots[
                        slotIndex
                    ]

                local directAction =
                    cosmetic.directAction[
                        slotIndex
                    ]

                if directAction == "remove" then
                elseif id
                    and id ~= 0
                then
                    local effectiveId =
                        id

                    if cosmetic.enabled then
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
                    if UnusualFns.activateUnusual() then
                        unusualEnabled = true
                        unusualActive = true
                        unusualRuntime.appliedRig =
                            UnusualFns.getUnusualVisualRig()
                    end
                end)
            elseif restoreNativeUnusualId then
                if cosmeticUnusualSnapshot then
                    pcall(function()
                        UnusualFns.restoreNativeUnusualSnapshot(
                            cosmeticUnusualSnapshot,
                            UnusualFns.getUnusualVisualRig(),
                            UnusualFns.getUnusualPlayerCharacter()
                        )
                    end)
                else
                    pcall(function()
                        applyUnusualFX(
                            restoreNativeUnusualId,
                            UnusualFns.getUnusualVisualRig(),
                            UnusualFns.getUnusualPlayerCharacter()
                        )
                    end)
                end
            end
        end)

    cosmetic.skinCharacter =
        live

    cosmetic.refreshBusy = false

    return success
end

function cosmetic.installHook()
    if cosmetic.hooked
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
                        cosmetic.lastSetRigArgs = {
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
                                not cosmetic.skinDescription
                                or cosmetic.skinCharacter == liveBefore
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

                                    cosmetic.skinDescription =
                                        clone
                                    cosmetic.skinCharacter =
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
                                cosmetic.replaceArray(
                                    cosmetics
                                ),
                                gear,
                                boombox
                            )

                        if cosmetic.skinDescription
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
                                    and not cosmetic.refreshBusy
                                then
                                    pcall(
                                        cosmetic.refreshRig
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

    cosmetic.targetSetRig =
        target
    cosmetic.originalSetRig =
        original
    cosmetic.hooked = true

    return true
end

function cosmetic.removeHook()
    if not cosmetic.hooked
        or type(hookfunction) ~= "function"
    then
        return
    end

    pcall(function()
        if cosmetic.targetSetRig
            and cosmetic.originalSetRig
        then
            hookfunction(
                cosmetic.targetSetRig,
                cosmetic.originalSetRig
            )
        end
    end)

    cosmetic.hooked = false
    cosmetic.targetSetRig = nil
    cosmetic.originalSetRig = nil
    cosmetic.lastSetRigArgs = nil
end

function cosmetic.updateToggle()
    pcall(function()
        if cosmetic.enabled then
            Toggle.Text =
                "SWAP: ON"
            Toggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            Toggle.Text =
                "SWAP: OFF"
            Toggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end)
end

function cosmetic.closePicker()
    cosmetic.picking = false
    cosmetic.pickerSide = nil
    if unusualPicker then
        unusualPicker.Visible = false
    end
end

function cosmetic.select(
    slotIndex,
    side,
    id,
    name
)
    local state =
        cosmetic.slots[slotIndex]

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

    cosmetic.directAction[slotIndex] = nil

    cosmetic.saveState()
    pcall(saveSavedConfig)

    if cosmetic.enabled then
        cosmetic.enabled = false
        pcall(cosmetic.updateToggle)

        task.spawn(function()
            pcall(cosmetic.refreshRig)
        end)
    end

    -- The executor may invoke this picker callback from a
    -- thread without Instance access. Never let GUI access
    -- prevent the actual selection from being saved.
    pcall(function()
        cosmetic.closePicker()
    end)

    pcall(function()
        local row =
            cosmetic.page
            and cosmetic.page:FindFirstChild(
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
function cosmetic.createPreview(
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
                Registry.GetById(
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

function cosmetic.rebuildPicker()
    for _, button in ipairs(
        unusualPickerButtons
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
                    cosmeticPreviewCache[id] =
                        preview

                    preview.Parent =
                        cosmeticPreviewCacheHolder
                end
            end
        end)

        pcall(function()
            button:Destroy()
        end)
    end
    table.clear(
        unusualPickerButtons
    )

    local query =
        string.lower(
            unusualPickerSearch.Text
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
            unusualPickerScroll

        local corner =
            Instance.new(
                "UICorner"
            )
        corner.CornerRadius =
            UDim.new(0, 5)
        corner.Parent =
            button

        table.insert(
            unusualPickerButtons,
            button
        )

        UnusualFns.addUnusualConnection(
            button.MouseButton1Click:Connect(
                function()
                    local slotIndex =
                        tonumber(
                            string.match(
                                cosmetic.pickerSide
                                    or "",
                                "^(%d+):"
                            )
                        )
                    local side =
                        string.match(
                            cosmetic.pickerSide
                                or "",
                            "^%d+:(.+)$"
                        )

                    if slotIndex and side then
                        cosmetic.select(
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
        cosmetic.list
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
                unusualPickerScroll

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
                cosmeticPreviewCache[data.id]

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
                    cosmeticPreviewCache[data.id] =
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
                        cosmetic.createPreview(
                            data.id,
                            preview
                        )
                    end)

                    cosmeticPreviewCache[
                        data.id
                    ] = preview
                end
            else
                if cachedPreview then
                    cosmeticPreviewCache[
                        data.id
                    ] = nil
                end

                pcall(function()
                    cosmetic.createPreview(
                        data.id,
                        preview
                    )
                end)

                cosmeticPreviewCache[data.id] =
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
                unusualPickerButtons,
                button
            )

            UnusualFns.addUnusualConnection(
                button.MouseButton1Click:Connect(
                    function()
                        local slotIndex =
                            tonumber(
                                string.match(
                                    cosmetic.pickerSide
                                        or "",
                                    "^(%d+):"
                                )
                            )
                        local side =
                            string.match(
                                cosmetic.pickerSide
                                    or "",
                                "^%d+:(.+)$"
                            )

                        if slotIndex and side then
                            cosmetic.select(
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

    unusualPickerScroll.CanvasPosition =
        Vector2.new(
            0,
            0
        )

    if unusualStatus then
        unusualStatus.Text =
            "Cosmetics: "
                .. tostring(
                    #cosmetic.list
                )
                .. " • "
                .. tostring(
                    shown
                )
                .. " found"
    end
    cosmeticPickerPreloaded = true
end

function cosmetic.openPicker(
    slotIndex,
    side
)
    cosmetic.picking = true
    cosmetic.pickerSide =
        tostring(slotIndex)
        .. ":"
        .. side

    unusualPickerTitle.Text =
        side == "Original"
        and "Select Original"
        or "Select Replacement"
    unusualPickerSearch.Text = ""
    if not cosmeticPickerPreloaded then
        cosmetic.rebuildPicker()
    end

    __UI.animatePickerAppear(
        unusualPicker
    )
end

function cosmetic.buildUI()
    cosmetic.page =
        Instance.new(
            "ScrollingFrame"
        )
    cosmetic.page.Name =
        "CosmeticPage"
    cosmetic.page.Size =
        UDim2.new(
            1,
            -92,
            1,
            -56
        )
    cosmetic.page.Position =
        UDim2.new(
            0,
            82,
            0,
            48
        )
    cosmetic.page.BackgroundColor3 =
        Color3.fromRGB(
            32,
            32,
            32
        )
    cosmetic.page.BorderSizePixel = 0
    cosmetic.page.ScrollBarThickness = 6
    cosmetic.page.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            0
        )
    cosmetic.page.AutomaticCanvasSize =
        Enum.AutomaticSize.Y
    cosmetic.page.Visible = false
    cosmetic.page.Parent =
        Main

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
        cosmetic.page

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
        cosmetic.page

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
        cosmetic.page

    cosmetic.pageStatus =
        Instance.new(
            "TextLabel"
        )
    cosmetic.pageStatus.Name =
        "CosmeticStatus"
    cosmetic.pageStatus.Size =
        UDim2.new(
            1,
            -4,
            0,
            18
        )
    cosmetic.pageStatus.BackgroundTransparency = 1
    cosmetic.pageStatus.Text =
        "Cosmetics: "
            .. tostring(
                #cosmetic.list
            )
    cosmetic.pageStatus.TextSize = 11
    cosmetic.pageStatus.Font =
        Enum.Font.Gotham
    cosmetic.pageStatus.TextColor3 =
        Color3.fromRGB(
            145,
            145,
            145
        )
    cosmetic.pageStatus.TextXAlignment =
        Enum.TextXAlignment.Left
    cosmetic.pageStatus.LayoutOrder = 1
    cosmetic.pageStatus.Parent =
        cosmetic.page

    Toggle.Parent =
        cosmetic.page
    Toggle.LayoutOrder = 0

    for slotIndex = 1, 2 do
        local state =
            cosmetic.slots[slotIndex]

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
            cosmetic.page

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

        UnusualFns.addUnusualConnection(
            a.MouseButton1Click:Connect(
                function()
                    cosmetic.openPicker(
                        slotIndex,
                        "Original"
                    )
                end
            )
        )

        UnusualFns.addUnusualConnection(
            b.MouseButton1Click:Connect(
                function()
                    cosmetic.openPicker(
                        slotIndex,
                        "Replace"
                    )
                end
            )
        )

        UnusualFns.addUnusualConnection(
            addButton.MouseButton1Click:Connect(
                function()
                    local current =
                        cosmetic.slots[
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

                    cosmetic.directAction[
                        slotIndex
                    ] = "add"

                    task.spawn(function()
                        pcall(
                            cosmetic.refreshRig
                        )
                    end)
                end
            )
        )

        UnusualFns.addUnusualConnection(
            removeButton.MouseButton1Click:Connect(
                function()
                    local current =
                        cosmetic.slots[
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

                    cosmetic.directAction[
                        slotIndex
                    ] = "remove"

                    task.spawn(function()
                        pcall(
                            cosmetic.refreshRig
                        )
                    end)
                end
            )
        )
    end
end

function cosmetic.cleanup()
    local wasEnabled =
        cosmetic.enabled

    local hadDirectAdd = false

    for slotIndex = 1, 2 do
        if cosmetic.directAction[slotIndex] == "add" then
            hadDirectAdd = true
            cosmetic.directAction[slotIndex] = "remove"
        end
    end

    cosmetic.enabled = false

    --// A previous refresh can still be rebuilding the live rig.
    --// Wait for it to finish so cleanup cannot leave the replacement
    --// cosmetics behind.
    local deadline =
        tick() + 1

    while cosmetic.refreshBusy
        and tick() < deadline
    do
        task.wait()
    end

    if cosmetic.refreshBusy then
        cosmetic.refreshBusy = false
    end

    --// Always refresh while a live skin snapshot exists. This makes
    --// cleanup idempotent even when the swap was already disabled but
    --// its visual result is still present on the rig.
    if wasEnabled
        or hadDirectAdd
        or cosmetic.skinDescription
    then
        pcall(function()
            cosmetic.refreshRig()
        end)
    end

    cosmetic.directAction[1] = nil
    cosmetic.directAction[2] = nil

    cosmetic.closePicker()
    cosmetic.refreshBusy = false
    cosmetic.removeHook()

    cosmetic.skinDescription = nil
    cosmetic.skinCharacter = nil

    pcall(function()
        if cosmetic.page then
            cosmetic.page:Destroy()
        end
    end)

    cosmetic.page = nil
    cosmetic.pageStatus = nil
end

function UnusualFns.getUnusualName(id)
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
function UnusualFns.getEquippedUnusualId()
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
        UnusualFns.getEquippedUnusualId()
    if equipped ~= 0 then
        unusualSlot.originalId =
            equipped
        unusualSlot.originalName =
            UnusualFns.getUnusualName(
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
                UnusualFns.getUnusualName(
                    savedOriginal
                )
        end
        if savedReplace then
            unusualSlot.replaceId =
                savedReplace
        end
    end
    unusualSlot.replaceName =
        UnusualFns.getUnusualName(
            unusualSlot.replaceId
        )
end
--// =========================================================
--// GET REAL PLAYER CHARACTER
--// =========================================================
function UnusualFns.getUnusualPlayerCharacter()
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
function UnusualFns.getUnusualVisualRig()
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
function UnusualFns.getUnusualCosmeticRig(
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
function UnusualFns.isUnusualFX(object)
    return UNUSUAL_FX_CLASSES[
        object.ClassName
    ] == true
end
function UnusualFns.unusualAttachmentHasFX(
    attachment
)
    for _, descendant in ipairs(
        attachment:GetDescendants()
    ) do
        if UnusualFns.isUnusualFX(descendant) then
            return true
        end
    end
    return false
end

--// =========================================================
--// TAG OUR FX
--// =========================================================
function UnusualFns.tagUnusualFX(
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
            and UnusualFns.unusualAttachmentHasFX(
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

            if UnusualFns.isUnusualFX(object) then
                return true
            end

            if object:IsA("Attachment")
                and UnusualFns.unusualAttachmentHasFX(
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

                UnusualFns.tagUnusualFX(
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
            UnusualFns.getUnusualVisualRig()

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

    --// The mirrored nested visual is another visible copy of the
    --// Unusual effect. Tag the whole clone so first-person handling
    --// also reaches its Trail/Beam/ParticleEmitter descendants.
    UnusualFns.tagUnusualFX(
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
        UnusualFns.getUnusualVisualRig()

    local targetRoot

    if targetRig then
        targetRoot =
            targetRig:FindFirstChild(
                "HumanoidRootPart"
            )
    end

    if not targetRoot then
        local character =
            UnusualFns.getUnusualPlayerCharacter()

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
        unusualRuntime.animationLinks
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

local function createUnusualAnchor(
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

    UnusualFns.tagUnusualFX(
        anchor,
        id
    )

    return anchor
end

--// =========================================================
--// INSTALL ONE SOURCE PART
--// =========================================================

local function installUnusualPartFX(
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
                unusualRuntime.createVisualMirror(
                    child,
                    id
                )
            end

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
                createUnusualAnchor(
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
                    unusualRuntime.addAnimationLink(
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

                    unusualRuntime.animationLinks[
                        #unusualRuntime.animationLinks
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
                getNeededUnusualAttachments(
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

                    UnusualFns.tagUnusualFX(
                        clone,
                        id
                    )

                    mapUnusualAttachments(
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

                if UnusualFns.isUnusualFX(
                    sourceObject
                )
                and unusualObjectBelongsToPart(
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

                        UnusualFns.tagUnusualFX(
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
        UnusualFns.getUnusualCosmeticRig(
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
        unusualRuntime.createAnimationSource(
            cosmeticRig,
            id,
            playerCharacter
        )

    local animatedNestedInstalled =
        unusualRuntime.installAnimatedNestedModels(
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

                installUnusualPartFX(
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
function UnusualFns.removeOurUnusualFX()
    unusualRuntime.destroyAnimationSource()

    local removed = 0
    local roots = {
        UnusualFns.getUnusualVisualRig(),
        UnusualFns.getUnusualPlayerCharacter()
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
function UnusualFns.hasOurUnusualFX(
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
function UnusualFns.buildOriginalUnusualSignature(
    id,
    visualRig
)
    local cosmeticRig =
        UnusualFns.getUnusualCosmeticRig(
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
        if UnusualFns.isUnusualFX(object) then
            return true
        end

        if object:IsA("BasePart") then
            return true
        end

        for _, descendant in ipairs(
            object:GetDescendants()
        ) do
            if UnusualFns.isUnusualFX(descendant)
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

                if (
                    object:IsA("Weld")
                    or object:IsA("WeldConstraint")
                    or object:IsA("Motor6D")
                    or object:IsA("Motor")
                    or object:IsA("CFrameValue")
                ) then

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
function UnusualFns.removeOriginalUnusualFX(
    id,
    visualRig,
    playerCharacter
)
    local signature =
        UnusualFns.buildOriginalUnusualSignature(
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
function UnusualFns.captureNativeUnusualSnapshot(
    id,
    visualRig,
    playerCharacter
)
    local signature =
        UnusualFns.buildOriginalUnusualSignature(
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

            for _, existing in ipairs(
                targetPart:GetChildren()
            ) do
                local matched = false

                for _, info in ipairs(objects) do
                    if matchesObject(existing, info) then
                        matched = true
                        break
                    end
                end

                if matched then
                    local clone
                    pcall(function()
                        clone = existing:Clone()
                    end)

                    if clone then
                        table.insert(
                            partSnapshot.objects,
                            clone
                        )
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
                        if joint.Name == info.Name then
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

function UnusualFns.restoreNativeUnusualSnapshot(
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

function UnusualFns.restoreUnusual()
    if not unusualActive
        and not unusualRuntime.originalId
    then
        return
    end

    local visualRig =
        UnusualFns.getUnusualVisualRig()
    local playerCharacter =
        UnusualFns.getUnusualPlayerCharacter()

    --// Always inspect the real current loadout before restoring.
    --// unusualRuntime.originalId is the configured swap source only.
    local currentEquippedId =
        tonumber(
            UnusualFns.getEquippedUnusualId()
        )

    local originalId =
        tonumber(
            unusualRuntime.originalId
        )

    unusualRuntime.currentEquippedId =
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
        UnusualFns.clearNativeParticlePOV(
            false
        )

        if visualRig then
            UnusualFns.removeOurUnusualFX()

            pcall(function()
                UnusualFns.removeOriginalUnusualFX(
                    originalId,
                    visualRig,
                    playerCharacter
                )
            end)

            --// Keep P1 handling on the currently native Unusual.
            UnusualFns.bindNativeParticlePOV(
                visualRig
            )
        end

        unusualActive =
            false
        unusualRuntime.appliedRig =
            visualRig
        unusualRuntime.originalId =
            nil
        unusualRuntime.replacementId =
            nil
        unusualRuntime.nativeSnapshot =
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
        UnusualFns.clearNativeParticlePOV(
            true
        )

        UnusualFns.removeOurUnusualFX()
        task.wait()

        local restored =
            UnusualFns.restoreNativeUnusualSnapshot(
                unusualRuntime.nativeSnapshot,
                visualRig,
                playerCharacter
            )

        if not restored
            and originalId
            and tonumber(currentEquippedId)
                == tonumber(originalId)
        then
            UnusualFns.removeOriginalUnusualFX(
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
        UnusualFns.bindNativeParticlePOV(
            visualRig
        )
    end

    unusualActive =
        false
    unusualRuntime.appliedRig =
        nil
    unusualRuntime.originalId =
        nil
    unusualRuntime.currentEquippedId =
        currentEquippedId
    unusualRuntime.replacementId =
        nil
    unusualRuntime.nativeSnapshot =
        nil
end
--// =========================================================
--// ACTIVATE UNUSUAL
-- =========================================================
function UnusualFns.activateUnusual()
    if not unusualSlot.originalId
        or not unusualSlot.replaceId
    then
        return false
    end
    if unusualSlot.originalId
        == unusualSlot.replaceId
    then
        return false
    end

    local equippedId =
        UnusualFns.getEquippedUnusualId()

    if equippedId == 0
        or tonumber(equippedId)
            ~= tonumber(unusualSlot.originalId)
    then
        return false
    end

    local visualRig =
        UnusualFns.getUnusualVisualRig()
    local playerCharacter =
        UnusualFns.getUnusualPlayerCharacter()
    if not visualRig then
        return false
    end

    if not unusualRuntime.nativeSnapshot
        or tonumber(
            unusualRuntime.originalId
        ) ~= tonumber(equippedId)
        or unusualRuntime.appliedRig ~= visualRig
    then
        unusualRuntime.nativeSnapshot =
            UnusualFns.captureNativeUnusualSnapshot(
                equippedId,
                visualRig,
                playerCharacter
            )
    end

    if not unusualRuntime.nativeSnapshot then
        return false
    end

    --// Reset the previous replacement's POV state.
    UnusualFns.clearNativeParticlePOV(
        true
    )

    UnusualFns.removeOurUnusualFX()
    task.wait()
    UnusualFns.removeOriginalUnusualFX(
        unusualSlot.originalId,
        visualRig,
        playerCharacter
    )
    task.wait()
    if not applyUnusualFX(
        unusualSlot.replaceId,
        visualRig,
        playerCharacter
    ) then
        task.wait()
        applyUnusualFX(
            unusualSlot.originalId,
            visualRig,
            playerCharacter
        )
        return false
    end
    unusualActive =
        true
    unusualRuntime.appliedRig =
        visualRig
    unusualRuntime.originalId =
        equippedId
    unusualRuntime.currentEquippedId =
        equippedId
    unusualRuntime.replacementId =
        tonumber(unusualSlot.replaceId)

    --// The replacement is now live in Rigs.<player>.
    --// Track all of its current ParticleEmitters and any that
    --// its client driver creates later.
    UnusualFns.bindNativeParticlePOV(
        visualRig
    )

    return true
end
function UnusualFns.reapplyUnusual()
    if not unusualEnabled
        or unusualReapplyBusy
    then
        return
    end

    unusualReapplyBusy = true
    unusualRuntime.reapplyGeneration += 1

    local generation =
        unusualRuntime.reapplyGeneration

    task.spawn(function()

        for attempt = 1, 20 do

            if not unusualEnabled
                or genv.DEADEYE_UNUSUAL_POV_RUNNING == false
                or generation ~= unusualRuntime.reapplyGeneration
            then
                break
            end

            local visualRig =
                UnusualFns.getUnusualVisualRig()

            local playerCharacter =
                UnusualFns.getUnusualPlayerCharacter()

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

                if not unusualEnabled
                    or genv.DEADEYE_UNUSUAL_POV_RUNNING == false
                    or generation ~= unusualRuntime.reapplyGeneration
                then
                    break
                end

                local equippedId =
                    UnusualFns.getEquippedUnusualId()

                if equippedId == 0
                    or tonumber(equippedId)
                        ~= tonumber(
                            unusualSlot.originalId
                        )
                then
                    --// The player changed the actually equipped Unusual.
                    --// Do NOT restore unusualRuntime.originalId here:
                    --// that is only the configured swap rule (for example 1 -> 2).
                    --// The new equipped effect is now the real current state.
                    unusualRuntime.currentEquippedId =
                        tonumber(equippedId)

                    --// The game already handles the newly equipped
                    --// Unusual. DeadEye must only remove its own
                    --// replacement FX and any leftover old original FX.
                    --// Do NOT call applyUnusualFX here: that would mark
                    --// the user's real effect as DeadEye-owned and cleanup
                    --// would delete it.
                    UnusualFns.removeOurUnusualFX()
                    task.wait()

                    pcall(function()
                        UnusualFns.removeOriginalUnusualFX(
                            unusualRuntime.originalId
                                or unusualSlot.originalId,
                            visualRig,
                            playerCharacter
                        )
                    end)

                    unusualActive = false
                    unusualEnabled = false
                    unusualRuntime.appliedRig = visualRig
                    unusualRuntime.originalId = nil
                    unusualRuntime.replacementId = nil
                    unusualRuntime.nativeSnapshot = nil
                    genv.UNUSUAL_SWAPPER_ENABLED =
                        false
                    break
                end

                unusualActive = false
                UnusualFns.removeOurUnusualFX()

                local ok, result =
                    pcall(function()
                        return UnusualFns.activateUnusual()
                    end)

                if ok
                    and result == true
                then

                    local expected =
                        (
                            #unusualRuntime.animatedNestedVisuals > 0
                        )
                        or UnusualFns.hasOurUnusualFX(
                            visualRig,
                            unusualSlot.replaceId
                        )
                        or UnusualFns.hasOurUnusualFX(
                            playerCharacter,
                            unusualSlot.replaceId
                        )

                    if expected then
                        unusualRuntime.appliedRig =
                            visualRig
                        break
                    end

                end

            end

            task.wait(0.25)

        end

        unusualReapplyBusy = false

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
local lastUnusualPOVState = nil

function UnusualFns.getUnusualViewmodel()
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

function UnusualFns.isUnusualPOVRuntimeActive()
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

function UnusualFns.isUnusualFirstPerson()
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

function UnusualFns.syncUnusualViewmodelAppearance()
    local visualRig =
        UnusualFns.getUnusualVisualRig()

    if not visualRig then
        return
    end

    local viewmodel =
        UnusualFns.getUnusualViewmodel()

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
local unusualPovTransparencyClasses = {
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

local function isStockUnusualPOVTransparencyObject(
    object
)
    if not object then
        return false
    end

    return unusualPovTransparencyClasses[
        object.ClassName
    ] == true
end

local function forEachDeadEyeUnusualVisualObject(
    callback
)
    local roots = {
        UnusualFns.getUnusualVisualRig(),
        UnusualFns.getUnusualPlayerCharacter(),
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
                    and isStockUnusualPOVTransparencyObject(
                        object
                    )
                then
                    callback(object)
                end
            end
        end
    end
end

local function hideUnusualAnimationSourceVisuals()
    local source =
        unusualRuntime.animationSource

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
function UnusualFns.clearNativeParticlePOV(
    restore
)
    if unusualRuntime.nativeParticleConnection then
        pcall(function()
            unusualRuntime.nativeParticleConnection:Disconnect()
        end)
    end

    unusualRuntime.nativeParticleConnection = nil

    if restore then
        for object, enabled in pairs(
            unusualRuntime.nativeParticleStates
        ) do
            if object and object.Parent then
                pcall(function()
                    object.Enabled = enabled
                end)
            end
        end
    end

    table.clear(
        unusualRuntime.nativeParticleStates
    )

    unusualRuntime.nativeParticleRig = nil
    unusualRuntime.nativeParticleLastFirstPerson = nil
end

function UnusualFns.bindNativeParticlePOV(
    visualRig
)
    UnusualFns.clearNativeParticlePOV(
        true
    )

    if not visualRig then
        return
    end

    unusualRuntime.nativeParticleRig =
        visualRig

    for _, object in ipairs(
        visualRig:GetDescendants()
    ) do
        if object:IsA("ParticleEmitter") then
            unusualRuntime.nativeParticleStates[
                object
            ] = object.Enabled
        end
    end

    unusualRuntime.nativeParticleConnection =
        visualRig.DescendantAdded:Connect(
            function(object)
                if unusualRuntime.nativeParticleRig
                    ~= visualRig
                then
                    return
                end

                local firstPerson = false

                pcall(function()
                    firstPerson =
                        UnusualFns.isUnusualFirstPerson()
                end)

                if object:IsA("ParticleEmitter") then
                    if unusualRuntime.nativeParticleStates[
                        object
                    ] == nil
                    then
                        unusualRuntime.nativeParticleStates[
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

function UnusualFns.syncNativeParticlePOV(
    visualRig,
    firstPerson
)
    if not visualRig
        or unusualRuntime.nativeParticleRig
            ~= visualRig
    then
        return
    end

    --// Register newly-created ParticleEmitters.
    for _, object in ipairs(
        visualRig:GetDescendants()
    ) do
        if object:IsA("ParticleEmitter")
            and unusualRuntime.nativeParticleStates[
                object
            ] == nil
        then
            unusualRuntime.nativeParticleStates[
                object
            ] = object.Enabled
        end
    end

    local enteredFirstPerson =
        firstPerson
        and unusualRuntime.nativeParticleLastFirstPerson
            ~= true

    local leftFirstPerson =
        not firstPerson
        and unusualRuntime.nativeParticleLastFirstPerson
            == true

    --// Returning to 3P restores the exact saved enabled state.
    if leftFirstPerson then
        for object, enabled in pairs(
            unusualRuntime.nativeParticleStates
        ) do
            if object and object.Parent then
                pcall(function()
                    object.Enabled = enabled
                end)
            else
                unusualRuntime.nativeParticleStates[
                    object
                ] = nil
            end
        end
    end

    for object, enabled in pairs(
        unusualRuntime.nativeParticleStates
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
            unusualRuntime.nativeParticleStates[
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

    unusualRuntime.nativeParticleLastFirstPerson =
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
local function getDeadEyeAccessoryHostPart(accessory, nativeModel)
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

local function syncDeadEyeCosmeticsWithNativeVisibility()
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
                getDeadEyeAccessoryHostPart(
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
                    if isStockUnusualPOVTransparencyObject(
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
        syncDeadEyeCosmeticsWithNativeVisibility()
    end
)

function UnusualFns.setUnusualFXForPOV(
    firstPerson,
    _deltaTime
)
    if not UnusualFns.isUnusualPOVRuntimeActive() then
        return
    end

    --// Mirror the native live-rig ParticleEmitter behavior first.
    UnusualFns.syncNativeParticlePOV(
        UnusualFns.getUnusualVisualRig(),
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

    forEachDeadEyeUnusualVisualObject(
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
    hideUnusualAnimationSourceVisuals()
end

function UnusualFns.updateUnusualPOV()
    if not genv.DEADEYE_UNUSUAL_POV_RUNNING then
        return
    end

    if not UnusualFns.isUnusualPOVRuntimeActive() then
        lastUnusualPOVState = false
        UnusualFns.clearNativeParticlePOV(
            true
        )
        return
    end

    UnusualFns.syncUnusualViewmodelAppearance()

    lastUnusualPOVState =
        UnusualFns.isUnusualFirstPerson()
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
        UnusualFns.clearNativeParticlePOV(
            true
        )
    end)

    --// Return DeadEye's Unusual layer to the native 3P state.
    pcall(function()
        forEachDeadEyeUnusualVisualObject(
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
                elseif isStockUnusualPOVTransparencyObject(object) then
                    object.LocalTransparencyModifier = 0
                end
            end
        )
    end)

    pcall(function()
        hideUnusualAnimationSourceVisuals()
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
        if not UnusualFns.isUnusualPOVRuntimeActive() then
            UnusualFns.clearNativeParticlePOV(
                true
            )
            return
        end

        local gameplayRig =
            UnusualFns.getUnusualVisualRig()

        if gameplayRig
            and unusualRuntime.nativeParticleRig
                ~= gameplayRig
        then
            UnusualFns.bindNativeParticlePOV(
                gameplayRig
            )
        end

        local firstPerson =
            UnusualFns.isUnusualFirstPerson()

        UnusualFns.setUnusualFXForPOV(
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
    if UnusualFns.isUnusualPOVRuntimeActive() then
        UnusualFns.bindNativeParticlePOV(
            UnusualFns.getUnusualVisualRig()
        )
    end
end)

UnusualFns.addUnusualConnection(
    RunService.Heartbeat:Connect(
        function(deltaTime)

            if not genv.DEADEYE_UNUSUAL_POV_RUNNING then
                return
            end

            unusualRuntime.updateAnimatedParts()
            UnusualFns.updateUnusualPOV()

            if unusualEnabled
                and not unusualReapplyBusy
            then

                local rig =
                    UnusualFns.getUnusualVisualRig()

                if rig then

                    local expected =
                        (
                            #unusualRuntime.animatedNestedVisuals > 0
                        )
                        or UnusualFns.hasOurUnusualFX(
                            rig,
                            unusualSlot.replaceId
                        )
                        or UnusualFns.hasOurUnusualFX(
                            UnusualFns.getUnusualPlayerCharacter(),
                            unusualSlot.replaceId
                        )

                    if unusualRuntime.appliedRig ~= rig
                        or not expected
                    then
                        UnusualFns.reapplyUnusual()
                    end

                end

            end

        end
    )
)
--// =========================================================
--// UNUSUAL PAGE
--// =========================================================
unusualPage =
    Instance.new("ScrollingFrame")
unusualPage.Name =
    "UnusualPage"
unusualPage.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
unusualPage.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
unusualPage.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
unusualPage.BorderSizePixel =
    0
unusualPage.ScrollBarThickness =
    6
unusualPage.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
unusualPage.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
unusualPage.ScrollingDirection =
    Enum.ScrollingDirection.Y
unusualPage.Visible =
    false
unusualPage.Parent =
    Main
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
    unusualPage
local unusualLayout =
    Instance.new("UIListLayout")
unusualLayout.Padding =
    UDim.new(
        0,
        7
    )
unusualLayout.SortOrder =
    Enum.SortOrder.LayoutOrder
unusualLayout.Parent =
    unusualPage
local unusualRow =
    Instance.new("Frame")
unusualRow.Size =
    UDim2.new(
        1,
        -4,
        0,
        48
    )
unusualRow.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
unusualRow.BorderSizePixel =
    0
unusualRow.LayoutOrder =
    1
unusualRow.Parent =
    unusualPage
__UI.unusualRowCorner =
    Instance.new("UICorner")
__UI.unusualRowCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualRowCorner.Parent =
    unusualRow
local unusualRowLabel =
    Instance.new("TextLabel")
unusualRowLabel.Size =
    UDim2.new(
        0,
        60,
        1,
        0
    )
unusualRowLabel.Position =
    UDim2.new(
        0,
        8,
        0,
        0
    )
unusualRowLabel.BackgroundTransparency =
    1
unusualRowLabel.Text =
    "UNUSUAL"
unusualRowLabel.TextSize =
    10
unusualRowLabel.Font =
    Enum.Font.GothamBold
unusualRowLabel.TextColor3 =
    Color3.fromRGB(
        210,
        210,
        210
    )
unusualRowLabel.TextXAlignment =
    Enum.TextXAlignment.Left
unusualRowLabel.Parent =
    unusualRow
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
    unusualSlot.originalName
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
    unusualRow
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
local unusualArrow =
    Instance.new("TextLabel")
unusualArrow.Size =
    UDim2.new(
        0,
        24,
        0,
        32
    )
unusualArrow.Position =
    UDim2.new(
        0,
        202,
        0.5,
        -16
    )
unusualArrow.BackgroundTransparency =
    1
unusualArrow.Text =
    "→"
unusualArrow.TextSize =
    22
unusualArrow.Font =
    Enum.Font.GothamBold
unusualArrow.TextColor3 =
    Color3.fromRGB(
        180,
        180,
        180
    )
unusualArrow.Parent =
    unusualRow
--// REPLACE
local unusualReplaceButton =
    Instance.new("TextButton")
unusualReplaceButton.Size =
    UDim2.new(
        0,
        125,
        0,
        32
    )
unusualReplaceButton.Position =
    UDim2.new(
        0,
        226,
        0.5,
        -16
    )
unusualReplaceButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
unusualReplaceButton.BorderSizePixel =
    0
unusualReplaceButton.Text =
    unusualSlot.replaceName
    or "NONE"
unusualReplaceButton.TextSize =
    11
unusualReplaceButton.Font =
            Enum.Font.GothamBold
unusualReplaceButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualReplaceButton.TextTruncate =
    Enum.TextTruncate.AtEnd
unusualReplaceButton.Parent =
    unusualRow
__UI.unusualReplaceCorner =
    Instance.new("UICorner")
__UI.unusualReplaceCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualReplaceCorner.Parent =
    unusualReplaceButton
--// =========================================================
--// UNUSUAL PICKER
-- =========================================================
unusualPicker =
    Instance.new("Frame")
unusualPicker.Size =
    UDim2.new(
        0,
        560,
        0,
        450
    )
unusualPicker.Position =
    UDim2.new(
        0.5,
        -280,
        0.5,
        -225
    )
unusualPicker.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )
unusualPicker.BackgroundTransparency =
    0.10
unusualPicker.BorderSizePixel =
    0
unusualPicker.ClipsDescendants =
    true
unusualPicker.Visible =
    false
unusualPicker.ZIndex =
    30
unusualPicker.Parent =
    ScreenGui
__UI.unusualPickerCorner =
    Instance.new("UICorner")
__UI.unusualPickerCorner.CornerRadius =
    UDim.new(
        0,
        8
    )
__UI.unusualPickerCorner.Parent =
    unusualPicker
__UI.unusualPickerStroke =
    Instance.new("UIStroke")
__UI.unusualPickerStroke.Thickness =
    1
__UI.unusualPickerStroke.Transparency =
    0.66
__UI.unusualPickerStroke.Parent =
    unusualPicker

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
    unusualPicker

unusualPickerTitle =
    Instance.new("TextLabel")
unusualPickerTitle.Size =
    UDim2.new(
        1,
        -45,
        0,
        32
    )
unusualPickerTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        2
    )
unusualPickerTitle.BackgroundTransparency =
    1
unusualPickerTitle.Text =
    "Unusual Selector"
unusualPickerTitle.TextSize =
    16
unusualPickerTitle.Font =
    Enum.Font.GothamBold
unusualPickerTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualPickerTitle.TextXAlignment =
    Enum.TextXAlignment.Left
unusualPickerTitle.ZIndex =
    31
unusualPickerTitle.Parent =
    unusualPicker
unusualPickerClose =
    Instance.new("TextButton")
unusualPickerClose.Size =
    UDim2.new(
        0,
        27,
        0,
        27
    )
unusualPickerClose.Position =
    UDim2.new(
        1,
        -32,
        0,
        6
    )
unusualPickerClose.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        50
    )
unusualPickerClose.BackgroundTransparency =
    0.05
unusualPickerClose.BorderSizePixel =
    0
unusualPickerClose.ZIndex =
    31
unusualPickerClose.Text =
    "×"
unusualPickerClose.TextSize =
    27
unusualPickerClose.Font =
    Enum.Font.GothamBold
unusualPickerClose.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualPickerClose.AutoButtonColor =
    false
unusualPickerClose.Active =
    true
unusualPickerClose.Selectable =
    false
unusualPickerClose.Parent =
    unusualPicker

__UI.UnusualPickerCloseCorner =
    Instance.new("UICorner")
__UI.UnusualPickerCloseCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.UnusualPickerCloseCorner.Parent =
    unusualPickerClose

__UI.UnusualPickerCloseStroke =
    Instance.new("UIStroke")
__UI.UnusualPickerCloseStroke.Thickness =
    1
__UI.UnusualPickerCloseStroke.Transparency =
    0.65
__UI.UnusualPickerCloseStroke.Parent =
    unusualPickerClose
unusualPickerSearch =
    Instance.new("TextBox")
unusualPickerSearch.Size =
    UDim2.new(
        1,
        -20,
        0,
        30
    )
unusualPickerSearch.Position =
    UDim2.new(
        0,
        10,
        0,
        36
    )
unusualPickerSearch.BackgroundColor3 =
    Color3.fromRGB(
        40,
        45,
        53
    )
unusualPickerSearch.BackgroundTransparency =
    0.20
unusualPickerSearch.BorderSizePixel =
    0
unusualPickerSearch.ClearTextOnFocus =
    false
unusualPickerSearch.PlaceholderText =
    "Search by name or ID..."
unusualPickerSearch.PlaceholderColor3 =
    Color3.fromRGB(
        120,
        120,
        120
    )
unusualPickerSearch.Text =
    ""
unusualPickerSearch.TextSize =
    12
unusualPickerSearch.Font =
            Enum.Font.GothamBold
unusualPickerSearch.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualPickerSearch.ZIndex =
    32
unusualPickerSearch.Parent =
    unusualPicker
__UI.unusualSearchCorner =
    Instance.new("UICorner")
__UI.unusualSearchCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.unusualSearchCorner.Parent =
    unusualPickerSearch
unusualPickerScroll =
    Instance.new("ScrollingFrame")
unusualPickerScroll.Size =
    UDim2.new(
        1,
        -16,
        1,
        -74
    )
unusualPickerScroll.Position =
    UDim2.new(
        0,
        8,
        0,
        70
    )
unusualPickerScroll.BackgroundColor3 =
    Color3.fromRGB(
        32,
        35,
        42
    )
unusualPickerScroll.BackgroundTransparency =
    0.20
unusualPickerScroll.BorderSizePixel =
    0
unusualPickerScroll.ScrollBarThickness =
    6
unusualPickerScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
unusualPickerScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
unusualPickerScroll.ZIndex =
    31
unusualPickerScroll.Parent =
    unusualPicker
__UI.unusualPickerScrollCorner =
    Instance.new("UICorner")
__UI.unusualPickerScrollCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.unusualPickerScrollCorner.Parent =
    unusualPickerScroll
local unusualPickerPadding =
    Instance.new("UIPadding")
unusualPickerPadding.PaddingTop =
    UDim.new(0, 8)
unusualPickerPadding.PaddingBottom =
    UDim.new(0, 8)
unusualPickerPadding.PaddingLeft =
    UDim.new(0, 8)
unusualPickerPadding.PaddingRight =
    UDim.new(0, 8)
unusualPickerPadding.Parent =
    unusualPickerScroll
local unusualPickerGrid =
    Instance.new("UIGridLayout")
unusualPickerGrid.CellSize =
    UDim2.new(
        1 / 3,
        -6,
        0,
        92
    )
unusualPickerGrid.CellPadding =
    UDim2.new(
        0,
        6,
        0,
        8
    )
unusualPickerGrid.SortOrder =
    Enum.SortOrder.LayoutOrder
unusualPickerGrid.Parent =
    unusualPickerScroll
--// =========================================================
--// REBUILD UNUSUAL PICKER
--// =========================================================
function UnusualFns.rebuildUnusualPicker()

    pcall(function()
        collectCurrentUnusualIcons(
            LocalPlayer:FindFirstChild(
                "PlayerGui"
            )
        )
    end)

    local cosmeticButtonsWereRemoved = false

    for _, button in ipairs(
        unusualPickerButtons
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
                        cosmeticPreviewCache[id] =
                            preview
                        preview.Parent =
                            cosmeticPreviewCacheHolder
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
        cosmeticPickerPreloaded = false
    end

    table.clear(
        unusualPickerButtons
    )
    local query =
        string.lower(
            unusualPickerSearch.Text
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
        button.Parent = unusualPickerScroll

        local corner =
            Instance.new("UICorner")

        corner.CornerRadius =
            UDim.new(0, 5)
        corner.Parent = button

        table.insert(
            unusualPickerButtons,
            button
        )

        UnusualFns.addUnusualConnection(
            button.MouseButton1Click:Connect(
                function()
                    if unusualPickerSide == "Original" then
                        unusualSlot.originalId = nil
                        unusualSlot.originalName = nil
                        unusualOriginalButton.Text = "Select"
                    elseif unusualPickerSide == "Replace" then
                        unusualSlot.replaceId = nil
                        unusualSlot.replaceName = nil
                        unusualReplaceButton.Text = "Select"
                    else
                        return
                    end

                    savedConfig.unusual = {
                        originalId = unusualSlot.originalId,
                        replaceId = unusualSlot.replaceId
                    }

                    saveSavedConfig()

                    if unusualEnabled then
                        unusualEnabled = false
                        genv.UNUSUAL_SWAPPER_ENABLED = false
                        UnusualFns.restoreUnusual()
                        updateUnusualToggle()
                    end

                    unusualPicker.Visible = false
                    unusualPickerSide = nil
                end
            )
        )

        shown += 1
    end

    for index, data in ipairs(
        unusualList
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
                unusualPickerScroll

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
                or unusualIconIdCache[
                    data.id
                ]
                or unusualIconCache[
                    normalizeUnusualIconKey(
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
                unusualPickerButtons,
                button
            )
            UnusualFns.addUnusualConnection(
                button.MouseButton1Click:Connect(
                    function()
                        if unusualPickerSide
                            == "Original"
                        then
                            unusualSlot.originalId =
                                data.id
                            unusualSlot.originalName =
                                data.name
                            unusualOriginalButton.Text =
                                data.name
                        elseif unusualPickerSide
                            == "Replace"
                        then
                            unusualSlot.replaceId =
                                data.id
                            unusualSlot.replaceName =
                                data.name
                            unusualReplaceButton.Text =
                                data.name
                        end
                        savedConfig.unusual = {
                            originalId =
                                unusualSlot.originalId,
                            replaceId =
                                unusualSlot.replaceId
                        }
                        saveSavedConfig()
                        unusualPicker.Visible =
                            false
                        unusualPickerSide =
                            nil
                        if unusualEnabled then
                            task.spawn(
                                UnusualFns.reapplyUnusual
                            )
                        end
                    end
                )
            )
        end
    end
    pcall(function()
        if unusualStatus then
            unusualStatus.Text =
                "Unusuals: "
                .. tostring(
                    #unusualList
                )
                .. " • "
                .. tostring(
                    shown
                )
                .. " found"
        end
    end)
    unusualPickerScroll.CanvasPosition =
        Vector2.new(
            0,
            0
        )
end
--// =========================================================
--// OPEN / CLOSE PICKER
-- =========================================================
function UnusualFns.openUnusualPicker(
    side
)
    unusualPickerSide =
        side

    if side == "Original" then
        unusualPickerTitle.Text =
            "Select Original"
    else
        unusualPickerTitle.Text =
            "Select Replacement"
    end

    unusualPickerSearch.Text =
        ""

    UnusualFns.rebuildUnusualPicker()

    __UI.animatePickerAppear(
        unusualPicker
    )
end
function UnusualFns.closeUnusualPicker()
    unusualPicker.Visible =
        false
    unusualPickerSide =
        nil
    cosmetic.picking = false
    cosmetic.pickerSide = nil
end
UnusualFns.addUnusualConnection(    unusualOriginalButton.MouseButton1Click:Connect(
        function()
            UnusualFns.openUnusualPicker(
                "Original"
            )
        end
    )
)
UnusualFns.addUnusualConnection(
    unusualReplaceButton.MouseButton1Click:Connect(
        function()
            UnusualFns.openUnusualPicker(
                "Replace"
            )
        end
    )
)
UnusualFns.addUnusualConnection(
    unusualPickerClose.MouseButton1Click:Connect(
        function()
            UnusualFns.closeUnusualPicker()
        end
    )
)
UnusualFns.addUnusualConnection(
    unusualPickerSearch:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()
            if unusualPicker.Visible then
                if cosmetic.picking then
                    cosmetic.rebuildPicker()
                else
                    UnusualFns.rebuildUnusualPicker()
                end
            end
        end
    )
)

UnusualFns.addUnusualConnection(
    LocalPlayer:WaitForChild(
        "PlayerGui"
    ).DescendantAdded:Connect(
        function(obj)
            if obj:IsA("ImageLabel")
                and obj.Name == "IconIMG"
            then
                cacheUnusualIconFromObject(
                    obj
                )

                UnusualFns.addUnusualConnection(
                    obj:GetPropertyChangedSignal(
                        "Image"
                    ):Connect(
                        function()
                            cacheUnusualIconFromObject(
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
local unusualStatusText =
    Instance.new("TextLabel")
unusualStatusText.Name =
    "UnusualStatus"
unusualStatusText.Size =
    UDim2.new(
        0,
        260,
        0,
        20
    )
unusualStatusText.Position =
    UDim2.new(
        0,
        82,
        0,
        43
    )
unusualStatusText.BackgroundTransparency =
    1
unusualStatusText.Text =
    ""
unusualStatusText.TextSize =
    12
unusualStatusText.Font =
    Enum.Font.Gotham
unusualStatusText.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
unusualStatusText.TextXAlignment =
    Enum.TextXAlignment.Left
unusualStatusText.Visible =
    false
unusualStatusText.Parent =
    Main
unusualStatus =
    unusualStatusText
updateUnusualToggle = function()
    pcall(function()
        if unusualEnabled then
            Toggle.Text =
                "SWAP: ON"
            Toggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            Toggle.Text =
                "SWAP: OFF"
            Toggle.BackgroundColor3 =
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
function others.saveConfig()
    savedConfig.others =
        savedConfig.others
        or {}
    for _, slot in ipairs(
        others.ACCESSORY_SLOTS or {}
    ) do
        local box =
            others.fieldBoxes[
                slot.property
            ]
        if box then
            savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    for _, slot in ipairs(
        others.CLOTHING_SLOTS or {}
    ) do
        local box =
            others.fieldBoxes[
                slot.property
            ]
        if box then
            savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    for _, slot in ipairs(
        others.BODY_SLOTS or {}
    ) do
        local box =
            others.fieldBoxes[
                slot.property
            ]
        if box then
            savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    savedConfig.others._Headless =
        tostring(
            savedConfig.others._Headless
            or ""
        )
    savedConfig.others._Korblox =
        tostring(
            savedConfig.others._Korblox
            or ""
        )
    if others.avatarImportBox then
        savedConfig.others._AvatarImport =
            tostring(
                others.avatarImportBox.Text
                or ""
            )
    end
    pcall(function()
        saveSavedConfig()
    end)
end
function others.loadConfig()
    local saved =
        savedConfig.others
    if type(saved) ~= "table" then
        return
    end
    for _, group in ipairs({
        others.ACCESSORY_SLOTS,
        others.CLOTHING_SLOTS,
        others.BODY_SLOTS
    }) do
        for _, slot in ipairs(
            group
        ) do
            local box =
                others.fieldBoxes[
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
others.HEADLESS_ID = 134082579
others.KORBLOX_ID = 139607718
others.ACCESSORY_SLOTS = {
    {label = "Hats", property = "HatAccessory", multi = true},
    {label = "Hair", property = "HairAccessory", multi = true},
    {label = "Face Accessory", property = "FaceAccessory", multi = true},
    {label = "Neck", property = "NeckAccessory", multi = true},
    {label = "Shoulder", property = "ShouldersAccessory", multi = true},
    {label = "Front", property = "FrontAccessory", multi = true},
    {label = "Back", property = "BackAccessory", multi = true},
    {label = "Waist", property = "WaistAccessory", multi = true}
}
others.CLOTHING_SLOTS = {
    {label = "Shirt", property = "Shirt"},
    {label = "Pants", property = "Pants"},
    {label = "T-Shirt", property = "GraphicTShirt"}
}
others.BODY_SLOTS = {
    {label = "Head", property = "Head"},
    {label = "Torso", property = "Torso"},
    {label = "Left Arm", property = "LeftArm"},
    {label = "Right Arm", property = "RightArm"},
    {label = "Left Leg", property = "LeftLeg"},
    {label = "Right Leg", property = "RightLeg"}
}
others.ACCESSORY_PROPERTIES = {
    "HatAccessory",
    "HairAccessory",
    "FaceAccessory",
    "NeckAccessory",
    "ShouldersAccessory",
    "FrontAccessory",
    "BackAccessory",
    "WaistAccessory"
}
others.page = nil
others.status = nil
others.originalDescription = nil
others.targetHumanoid = nil
others.fieldBoxes = {}
function others.getHumanoids()
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
        UnusualFns.getUnusualVisualRig()
    if rig then
        add(
            rig:FindFirstChildOfClass(
                "Humanoid"
            )
        )
    end
    local character =
        UnusualFns.getUnusualPlayerCharacter()
    if character then
        add(
            character:FindFirstChildOfClass(
                "Humanoid"
            )
        )
    end
    return result
end
function others.getHumanoid()
    return others.getHumanoids()[1]
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

local function othersBuildNativeVisibilityEntries()
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
        others.getHumanoids()
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

local function othersSyncWithNativeVisibility()
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
        othersBuildNativeVisibilityEntries()

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
        othersSyncWithNativeVisibility()
    end
)

function others.ensureSnapshot()

    if others.originalDescription then
        return true
    end
    local humanoid =
        others.getHumanoid()
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
    others.targetHumanoid =
        humanoid
    others.originalDescription =
        clone
    return true
end
function others.isR6()
    local humanoid =
        others.getHumanoid()
    return humanoid
        and humanoid.RigType
            == Enum.HumanoidRigType.R6
end
function others.getDescription()
    if not others.isR6() then
        if others.status then
            others.status.Text =
                "R6 only"
        end
        return nil
    end
    if not others.ensureSnapshot() then
        return nil
    end
    local humanoid =
        others.getHumanoid()
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
function others.propertyText(
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
function others.refresh()
    local description =
        others.getDescription()
    if not description then
        return
    end
    local groups = {
        others.ACCESSORY_SLOTS,
        others.CLOTHING_SLOTS,
        others.BODY_SLOTS
    }
    for _, group in ipairs(groups) do
        for _, slot in ipairs(group) do
            local box =
                others.fieldBoxes[
                    slot.property
                ]
            if box then
                box.Text =
                    others.propertyText(
                        description,
                        slot
                    )
            end
        end
    end
end
function others.applyDescription(
    description
)
    if not others.isR6() then
        if others.status then
            others.status.Text =
                "R6 only"
        end
        return false
    end
    local applied = 0
    local lastError

    for _, humanoid in ipairs(
        others.getHumanoids()
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
            others.getHumanoids()
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
        if others.status then
            others.status.Text =
                "Apply Error"
        end
        return false
    end

    pcall(function()
        if others.status then
            others.status.Text =
                "Applied"
        end
    end)
    return true
end
function others.applyField(
    slot,
    textValue
)
    local description =
        others.getDescription()
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
    return others.applyDescription(
        description
    )
end
function others.scan()
    local description =
        others.getDescription()
    if not description then
        return false
    end
    others.refresh()
    if others.status then
        others.status.Text =
            "Scanned • R6"
    end
    return true
end
function others.clearAccessories()
    local description =
        others.getDescription()
    if not description then
        return false
    end
    for _, property in ipairs(
        others.ACCESSORY_PROPERTIES
    ) do
        pcall(function()
            description[property] = ""
        end)
    end
    pcall(function()
        description.Face = 0
    end)
    return others.applyDescription(
        description
    )
end
function others.restore(
    keepSnapshot
)
    if not others.originalDescription then
        return false
    end
    local result =
        others.applyDescription(
            others.originalDescription
        )
    if not keepSnapshot then
        others.originalDescription =
            nil
        others.targetHumanoid =
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
local mainJump = {
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
    crouchSpamThread = nil,
    crouchSpamMovement = nil,
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
    crouchSpamSensorPart = nil,
    crouchSpamSensorHeartbeatConnection = nil,
    crouchSpamSensorContacting = false,
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
    autoJumpModeButton = nil,
    autoJumpModePicker = nil,
    connections = {}
}
mainJump.jumpDelay =
    math.clamp(
        tonumber(
            savedConfig.main
            and savedConfig.main.jumpDelay
        ) or 0.01,
        0,
        5
    )
mainJump.autoJumpMode =
    tostring(
        savedConfig.main
        and savedConfig.main.autoJumpMode
        or "rage"
    ):lower()

if mainJump.autoJumpMode ~= "legit"
    and mainJump.autoJumpMode ~= "rage"
then
    mainJump.autoJumpMode = "rage"
end

mainJump.hotkeyName =
    tostring(
        savedConfig.main
        and savedConfig.main.hotkey
        or "Z"
    )
mainJump.hideUIHotkeyName =
    tostring(
        savedConfig.main
        and savedConfig.main.hideUIHotkey
        or "H"
    )
mainJump.crouchSpamDelay =
    math.clamp(
        tonumber(
            savedConfig.main
            and savedConfig.main.crouchSpamDelay
        ) or 0.03,
        0.001,
        5
    )
mainJump.crouchSpamHotkeyName =
    tostring(
        savedConfig.main
        and savedConfig.main.crouchSpamHotkey
        or "I"
    )
mainJump.benchTrimpHotkeyName =
    tostring(
        savedConfig.main
        and savedConfig.main.benchTrimpHotkey
        or "P"
    )
mainJump.benchTrimpEnabled =
    savedConfig.main
    and savedConfig.main.benchTrimpEnabled == true
    or false
mainJump.smartAirTurnEnabled =
    savedConfig.main
    and savedConfig.main.smartAirTurn == true
    or false
mainJump.airTurnHotkeyName =
    tostring(
        savedConfig.main
        and (
            savedConfig.main.airTurnHotkey
            or savedConfig.main.smartAirTurnHotkey
        )
        or "O"
    )
mainJump.lookEnabled =
    savedConfig.main
    and savedConfig.main.look == true
    or false
mainJump.rageLookEnabled =
    savedConfig.main
    and savedConfig.main.rageLook == true
    or false
mainJump.reverseLookMode =
    savedConfig.main
    and savedConfig.main.reverseLookMode
        == "with"
    and "with"
    or "without"
mainJump.reverseLookEnabled =
    savedConfig.main
    and savedConfig.main.reverseLookEnabled == true
    or false
mainJump.airTurnEnabled =
    savedConfig.main
    and savedConfig.main.airTurn == true
    or false
mainJump.airTurnSpeed =
    math.clamp(
        tonumber(
            savedConfig.main
            and savedConfig.main.airTurnSpeed
        ) or 180,
        30,
        480
    )
local function mainConnect(connection)
    table.insert(
        mainJump.connections,
        connection
    )
end
local function mainDisconnect()
    for _, connection in ipairs(
        mainJump.connections
    ) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(
        mainJump.connections
    )
end
function mainJump.saveConfig()
    savedConfig.main = {
        jumpDelay = mainJump.jumpDelay,
        autoJumpMode = mainJump.autoJumpMode,
        hotkey = mainJump.hotkeyName,
        hideUIHotkey =
            mainJump.hideUIHotkeyName,
        look = mainJump.lookEnabled,
        rageLook = mainJump.rageLookEnabled,
        airTurn = mainJump.airTurnEnabled,
        airTurnSpeed = mainJump.airTurnSpeed,
        smartAirTurn = mainJump.smartAirTurnEnabled,
        airTurnHotkey = mainJump.airTurnHotkeyName,
        crouchSpamDelay = mainJump.crouchSpamDelay,
        crouchSpamHotkey = mainJump.crouchSpamHotkeyName,
        reverseLookMode = mainJump.reverseLookMode,
        reverseLookEnabled = mainJump.reverseLookEnabled,
        benchTrimpHotkey = mainJump.benchTrimpHotkeyName,
        benchTrimpEnabled = mainJump.benchTrimpEnabled
    }
    pcall(function()
        saveSavedConfig()
    end)
end


--// Persist only the two toggle states directly into DeadEye_Config.json.
--// This does not rebuild or replace savedConfig.main.
function mainJump.saveEnabledStates()
    savedConfig.main =
        savedConfig.main
        or {}

    savedConfig.main.rageLook =
        mainJump.rageLookEnabled == true

    savedConfig.main.benchTrimpEnabled =
        mainJump.benchTrimpEnabled == true

    pcall(function()
        saveSavedConfig()
    end)
end

--// =========================================================
--// CAMERA LOOK / JUMP
--// =========================================================
--// LOOK is deliberately tied to the AUTOJUMP sensor cycle.
--// Manual/native jumps never call beginLook().
local LOOK_RENDER_NAME = "DeadEyeMainLook"
local LOOK_INPUT_RADIANS = 0.00575958658
local LOOK_TARGET_PITCH = -math.rad(89)
local LOOK_MAX_INPUT = 12
local LOOK_PITCH_GAIN = 0.32
local LOOK_RESTORE_EPSILON = math.rad(0.75)
local LOOK_MIN_ACTIVE = 0.10
local LOOK_MAX_AFTER_JUMP = 0.30

mainJump.lookRenderBound = false
mainJump.lookRestoreDeadline = 0
mainJump.lookMinActiveDeadline = 0

local function mainLookAngleDelta(target, current)
    return math.atan2(
        math.sin(target - current),
        math.cos(target - current)
    )
end

function mainJump.findLookMovementState()
    if type(mainJump.lookMovementState) == "table" then
        local valid = false
        pcall(function()
            valid =
                typeof(
                    mainJump.lookMovementState.Movement
                ) == "Vector2"
        end)
        if valid then
            return mainJump.lookMovementState
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
                                mainJump.lookMovementState =
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

function mainJump.unbindLookRender()
    pcall(function()
        RunService:UnbindFromRenderStep(
            LOOK_RENDER_NAME
        )
    end)

    mainJump.lookRenderBound = false
end

function mainJump.finishLookRestore()
    mainJump.lookActive = false
    mainJump.lookRestoring = false
    mainJump.lookRestoreDeadline = 0
    mainJump.lookMinActiveDeadline = 0
    mainJump.lookAutoJumpCycle = false

    mainJump.unbindLookRender()
end

function mainJump.restoreLookNow()
    local camera =
        workspace.CurrentCamera

    if mainJump.lookSavedPitch
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
                    mainJump.lookSavedPitch,
                    currentYaw,
                    0
                )
        end)
    end

    mainJump.finishLookRestore()
end

function mainJump.bindLookRender()
    if mainJump.lookRenderBound then
        return
    end

    pcall(function()
        RunService:UnbindFromRenderStep(
            LOOK_RENDER_NAME
        )
    end)

    mainJump.lookRenderBound = true

    RunService:BindToRenderStep(
        LOOK_RENDER_NAME,
        Enum.RenderPriority.Camera.Value - 1,
        function()
            if not genv.DEADEYE_MAIN_RUNNING
                or cleaned
            then
                if mainJump.lookRestoring then
                    mainJump.restoreLookNow()
                else
                    mainJump.unbindLookRender()
                end
                return
            end

            if not mainJump.lookActive
                and not mainJump.lookRestoring
            then
                mainJump.unbindLookRender()
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
                mainJump.lookActive
                and LOOK_TARGET_PITCH
                or mainJump.lookSavedPitch

            if not targetPitch then
                return
            end

            local pitchDelta =
                targetPitch - pitch

            if mainJump.lookRestoring
                and math.abs(pitchDelta)
                    <= LOOK_RESTORE_EPSILON
            then
                mainJump.finishLookRestore()
                return
            end

            if mainJump.lookActive then
                local now =
                    tick()

                if mainJump.lookRestoreDeadline > 0
                    and now
                        >= mainJump.lookRestoreDeadline
                then
                    mainJump.endLook()
                    return
                end

                if mainJump.lookMinActiveDeadline > 0
                    and now
                        >= mainJump.lookMinActiveDeadline
                    and not mainJump.lookScannerSeesSurface()
                then
                    mainJump.endLook()
                    return
                end
            end

            local movementState =
                mainJump.findLookMovementState()

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
                        / LOOK_INPUT_RADIANS
                        * LOOK_PITCH_GAIN,
                    -LOOK_MAX_INPUT,
                    LOOK_MAX_INPUT
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

function mainJump.beginLook()
    if not mainJump.lookEnabled
        or mainJump.rageLookEnabled
        or not mainJump.enabled
        or not mainJump.lookAutoJumpCycle
        or cleaned
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

    if not mainJump.lookActive
        and not mainJump.lookRestoring
    then
        mainJump.lookSavedPitch =
            pitch
    end

    mainJump.lookActive = true
    mainJump.lookRestoring = false
    mainJump.lookRestoreDeadline =
        tick()
        + LOOK_MAX_AFTER_JUMP
    mainJump.lookMinActiveDeadline =
        tick()
        + LOOK_MIN_ACTIVE

    mainJump.findLookMovementState()
    mainJump.bindLookRender()
end

function mainJump.endLook()
    if not mainJump.lookActive
        and not mainJump.lookRestoring
    then
        return
    end

    mainJump.lookActive = false
    mainJump.lookRestoring = true
    mainJump.lookRestoreDeadline = 0

    mainJump.findLookMovementState()
    mainJump.bindLookRender()
end


local AIR_TURN_RENDER_NAME =
    "DeadEyeMainAirTurn"

local AIR_TURN_MIN_SPEED = 30
local AIR_TURN_MAX_SPEED = 600

local SMART_AIR_TURN_INPUT_RADIANS = 0.00575958658
local SMART_AIR_TURN_MAX_PIXELS = 12
local SMART_AIR_TURN_GAIN = 1

mainJump.airTurnRenderBound = false

function mainJump.unbindAirTurnRender()
    if not mainJump.airTurnRenderBound then
        return
    end

    pcall(function()
        RunService:UnbindFromRenderStep(
            AIR_TURN_RENDER_NAME
        )
    end)

    mainJump.airTurnRenderBound = false
end

function mainJump.bindAirTurnRender()
    if mainJump.airTurnRenderBound then
        return
    end

    pcall(function()
        RunService:UnbindFromRenderStep(
            AIR_TURN_RENDER_NAME
        )
    end)

    mainJump.airTurnRenderBound = true

    RunService:BindToRenderStep(
        AIR_TURN_RENDER_NAME,
        Enum.RenderPriority.Camera.Value - 2,
        function(deltaTime)
            if not genv.DEADEYE_MAIN_RUNNING
                or cleaned
                or not mainJump.airTurnEnabled
                or not mainJump.enabled
            then
                mainJump.unbindAirTurnRender()
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
                        mainJump.root
                        and mainJump.root.AssemblyLinearVelocity

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
                mainJump.findLookMovementState()

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
            if mainJump.smartAirTurnEnabled then
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
                    mainJump.humanoid

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
                    * SMART_AIR_TURN_GAIN
                    / SMART_AIR_TURN_INPUT_RADIANS
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
                        -SMART_AIR_TURN_MAX_PIXELS,
                        SMART_AIR_TURN_MAX_PIXELS
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
                    mainJump.airTurnSpeed
                )
                * dt

            local moveX =
                radiansPerFrame
                / LOOK_INPUT_RADIANS
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

function mainJump.setAirTurnEnabled(state)
    mainJump.airTurnEnabled =
        state and true or false

    if mainJump.airTurnEnabled
        and mainJump.enabled
    then
        mainJump.findLookMovementState()
        mainJump.bindAirTurnRender()
    else
        mainJump.unbindAirTurnRender()
    end

    mainJump.saveConfig()
    mainJump.update()
end

function mainJump.setSmartAirTurnEnabled(state)
    mainJump.smartAirTurnEnabled =
        state and true or false

    if mainJump.smartAirTurnEnabled
        and mainJump.airTurnEnabled
        and mainJump.enabled
    then
        mainJump.findLookMovementState()
        mainJump.bindAirTurnRender()
    end

    mainJump.saveConfig()
    mainJump.update()
end

function mainJump.setAirTurnSpeed(value, persist)
    local number =
        tonumber(value)

    if not number then
        number =
            mainJump.airTurnSpeed
    end

    mainJump.airTurnSpeed =
        math.clamp(
            math.floor(
                number
                + 0.5
            ),
            AIR_TURN_MIN_SPEED,
            AIR_TURN_MAX_SPEED
        )

    if mainJump.airTurnSpeedValue then
        mainJump.airTurnSpeedValue.Text =
            tostring(
                mainJump.airTurnSpeed
            )
            .. "°/s"
    end

    if mainJump.airTurnSliderFill
        and mainJump.airTurnSliderTrack
    then
        local alpha =
            (
                mainJump.airTurnSpeed
                - AIR_TURN_MIN_SPEED
            )
            / (
                AIR_TURN_MAX_SPEED
                - AIR_TURN_MIN_SPEED
            )

        mainJump.airTurnSliderFill.Size =
            UDim2.new(
                alpha,
                0,
                1,
                0
            )
    end

    if mainJump.airTurnSliderKnob
        and mainJump.airTurnSliderTrack
    then
        local alpha =
            (
                mainJump.airTurnSpeed
                - AIR_TURN_MIN_SPEED
            )
            / (
                AIR_TURN_MAX_SPEED
                - AIR_TURN_MIN_SPEED
            )

        mainJump.airTurnSliderKnob.Position =
            UDim2.new(
                alpha,
                -5,
                0.5,
                -5
            )
    end

    if persist then
        mainJump.saveConfig()
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

local RAGE_LOOK_PITCH =
    -math.rad(70)

-- The game quantizes LookY to 1/40 radian:
-- floor(angle * 40 + 0.5) / 40
local RAGE_LOOK_Y =
    math.floor(
        RAGE_LOOK_PITCH * 40
        + 0.5
    ) / 40

mainJump.rageLookHookInstalled =
    false

mainJump.rageLookDataRegistryGet =
    nil

mainJump.rageLookOriginalDataRegistryGet =
    nil

mainJump.rageLookLookYEntry =
    nil

mainJump.rageLookOriginalLookYCalculate =
    nil

mainJump.rageLookTerms =
    nil

mainJump.rageLookMode =
    nil

function mainJump.getRageLookFakeCFrame(
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
            RAGE_LOOK_PITCH,
            0,
            0
        )
end

function mainJump.findRageLookDataRegistryGet()

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

function mainJump.findRageLookTerms()

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

function mainJump.installRageLookHook()

    if mainJump.rageLookHookInstalled then
        return true
    end

    local terms, lookYEntry =
        mainJump.findRageLookTerms()

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
        mainJump.findRageLookDataRegistryGet()

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

                        if mainJump.rageLookEnabled
                            and not cleaned
                            and key == "LookCFrame"
                            and typeof(results[1]) == "CFrame"
                        then

                            local fakeCFrame =
                                mainJump.getRageLookFakeCFrame(
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

    mainJump.rageLookDataRegistryGet =
        registryGet

    mainJump.rageLookOriginalDataRegistryGet =
        originalGet

    mainJump.rageLookTerms =
        terms

    mainJump.rageLookLookYEntry =
        lookYEntry

    mainJump.rageLookOriginalLookYCalculate =
        lookYEntry.CalculateFunction

    -- The game's Movement.UpdateTerms() will now call this
    -- function itself and then DataRegistry:Set("LookY", ...).
    lookYEntry.CalculateFunction =
        function(_)
            return RAGE_LOOK_Y
        end

    mainJump.rageLookHookInstalled =
        true

    mainJump.rageLookMode =
        "Movement Terms LookY + DataRegistry LookCFrame"

    return true
end

function mainJump.uninstallRageLookHook()

    local terms =
        mainJump.rageLookTerms

    local lookYEntry =
        mainJump.rageLookLookYEntry

    local originalLookYCalculate =
        mainJump.rageLookOriginalLookYCalculate

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
        mainJump.rageLookDataRegistryGet

    local originalGet =
        mainJump.rageLookOriginalDataRegistryGet

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

    mainJump.rageLookHookInstalled =
        false

    mainJump.rageLookDataRegistryGet =
        nil

    mainJump.rageLookOriginalDataRegistryGet =
        nil

    mainJump.rageLookLookYEntry =
        nil

    mainJump.rageLookOriginalLookYCalculate =
        nil

    mainJump.rageLookTerms =
        nil

    mainJump.rageLookMode =
        nil
end

function mainJump.setRageLookEnabled(
    state,
    persist
)

    state =
        state and true or false

    if state then

        if mainJump.rageLookEnabled then

            mainJump.saveConfig()
            mainJump.update()

            return true
        end

        --// Normal visual LOOK must not fight Rage Look.
        if mainJump.lookActive
            or mainJump.lookRestoring
        then

            mainJump.endLook()

        end

        local hooked =
            mainJump.installRageLookHook()

        if not hooked then

            mainJump.rageLookEnabled =
                false

            mainJump.update()

            return false
        end

        mainJump.rageLookEnabled =
            true

    else

        mainJump.rageLookEnabled =
            false

        mainJump.uninstallRageLookHook()

    end

    if mainJump.rageLookMode then

        print(
            "[DeadEye] Rage Look mode =",
            mainJump.rageLookMode
        )

    end

    if persist ~= false then
        mainJump.saveConfig()
        mainJump.saveEnabledStates()
    end

    mainJump.update()

    return true
end

function mainJump.setLookEnabled(state)
    mainJump.lookEnabled =
        state and true or false

    if not mainJump.lookEnabled then
        mainJump.endLook()
    end

    mainJump.saveConfig()
    mainJump.update()
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

local REVERSE_LOOK_YAW =
    math.rad(180)

local ReverseLookTweenService =
    game:GetService("TweenService")

local reverseLookUITweens = {}

local function reverseLookTween(
    object,
    properties
)
    if not object then
        return
    end

    local oldTween =
        reverseLookUITweens[object]

    if oldTween then
        pcall(function()
            oldTween:Cancel()
        end)
    end

    local tween

    local success =
        pcall(function()
            tween =
                ReverseLookTweenService:Create(
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

    reverseLookUITweens[object] =
        tween

    tween:Play()
end

function mainJump.isReverseLookActive()

    if cleaned then
        return false
    end

    if mainJump.reverseLookMode
        == "with"
    then
        return mainJump.crouchSpamEnabled == true
    end

    return mainJump.reverseLookEnabled == true
end

function mainJump.getReverseLookCFrame(
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
            REVERSE_LOOK_YAW,
            0
        )
        * CFrame.Angles(
            pitch,
            0,
            0
        )
end

function mainJump.findReverseLookRegistry()

    local object =
        getCharacterObject()

    if not object
        or not object.DataRegistry
    then
        return nil
    end

    return object.DataRegistry
end

function mainJump.installReverseLookHooks()

    if mainJump.reverseLookHookInstalled then
        return true
    end

    if type(hookfunction) ~= "function" then
        warn(
            "[DeadEye] Reverse Look: hookfunction unavailable"
        )
        return false
    end

    local registry =
        mainJump.findReverseLookRegistry()

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
                            and mainJump.isReverseLookActive()
                        then

                            local fakeCFrame =
                                mainJump.getReverseLookCFrame(
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

    mainJump.reverseLookSetFunction =
        setTarget

    mainJump.reverseLookOriginalSet =
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
                            and mainJump.isReverseLookActive()
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

        mainJump.reverseLookSetFunction =
            nil

        mainJump.reverseLookOriginalSet =
            nil

        warn(
            "[DeadEye] Reverse Look: failed to hook DataRegistry.Get"
        )

        return false
    end

    mainJump.reverseLookGetFunction =
        getTarget

    mainJump.reverseLookOriginalGet =
        savedGet

    mainJump.reverseLookHookInstalled =
        true

    return true
end

function mainJump.uninstallReverseLookHooks()

    local setTarget =
        mainJump.reverseLookSetFunction

    local savedSet =
        mainJump.reverseLookOriginalSet

    local getTarget =
        mainJump.reverseLookGetFunction

    local savedGet =
        mainJump.reverseLookOriginalGet

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

    mainJump.reverseLookSetFunction =
        nil

    mainJump.reverseLookOriginalSet =
        nil

    mainJump.reverseLookGetFunction =
        nil

    mainJump.reverseLookOriginalGet =
        nil

    mainJump.reverseLookHookInstalled =
        false
end

function mainJump.setReverseLookEnabled(
    state,
    persist
)

    mainJump.reverseLookEnabled =
        state and true or false

    if not mainJump.reverseLookHookInstalled then
        mainJump.installReverseLookHooks()
    end

    if persist ~= false then
        mainJump.saveConfig()
    end

    mainJump.update()
end

function mainJump.setReverseLookMode(
    mode
)

    if mode ~= "with"
        and mode ~= "without"
    then
        mode = "without"
    end

    mainJump.reverseLookMode =
        mode

    if not mainJump.reverseLookHookInstalled then
        mainJump.installReverseLookHooks()
    end

    mainJump.saveConfig()
    mainJump.update()
end

function mainJump.updateReverseLookUI(
    animated
)

    local mode =
        mainJump.reverseLookMode
        == "with"
        and "with"
        or "without"

    if mainJump.reverseLookModeButton
        and mainJump.reverseLookModeKnob
        and mainJump.reverseLookModeWithLabel
        and mainJump.reverseLookModeSoloLabel
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
            reverseLookTween(
                mainJump.reverseLookModeKnob,
                {
                    Position = knobPosition
                }
            )

            reverseLookTween(
                mainJump.reverseLookModeWithLabel,
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

            reverseLookTween(
                mainJump.reverseLookModeSoloLabel,
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

            reverseLookTween(
                mainJump.reverseLookModeButton,
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
            mainJump.reverseLookModeKnob.Position =
                knobPosition

            mainJump.reverseLookModeWithLabel.TextColor3 =
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

            mainJump.reverseLookModeSoloLabel.TextColor3 =
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

    if mainJump.reverseLookToggle then

        if mode == "with" then

            mainJump.reverseLookToggle.Text =
                "AUTO"

            mainJump.reverseLookToggle.Active =
                false

            if animated then
                reverseLookTween(
                    mainJump.reverseLookToggle,
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
                mainJump.reverseLookToggle.BackgroundColor3 =
                    Color3.fromRGB(
                        47,
                        52,
                        61
                    )
            end

        else

            mainJump.reverseLookToggle.Active =
                true

            mainJump.reverseLookToggle.Text =
                mainJump.reverseLookEnabled
                and "ON"
                or "OFF"

            local targetColor =
                mainJump.reverseLookEnabled
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
                reverseLookTween(
                    mainJump.reverseLookToggle,
                    {
                        BackgroundColor3 =
                            targetColor
                    }
                )
            else
                mainJump.reverseLookToggle.BackgroundColor3 =
                    targetColor
            end

        end

    end
end

function mainJump.syncAutoJumpModePickerVisual()
    local source =
        mainJump.autoJumpModeButton

    if not source
        or not ScreenGui
    then
        return
    end

    for _, object in ipairs(
        ScreenGui:GetDescendants()
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

function mainJump.update()
    if not mainJump.toggle then
        return
    end
    if mainJump.enabled then
        mainJump.toggle.Text =
            "ON"
        mainJump.toggle.BackgroundColor3 =
            Color3.fromRGB(
                68,
                74,
                84
            )
    else
        mainJump.toggle.Text =
            "OFF"
        mainJump.toggle.BackgroundColor3 =
            Color3.fromRGB(
                47,
                52,
                61
            )
    end

    if mainJump.autoJumpModeButton then
        mainJump.autoJumpModeButton.Text =
            mainJump.autoJumpMode == "legit"
            and "LEGIT"
            or "RAGE"

        --// Mode selection changes the label only.
        --// The button itself keeps the same normal DeadEye color.
        mainJump.autoJumpModeButton.BackgroundColor3 =
            Color3.fromRGB(
                47,
                52,
                61
            )
    end

    if mainJump.lookToggle then
        if mainJump.lookEnabled then
            mainJump.lookToggle.Text =
                "ON"
            mainJump.lookToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            mainJump.lookToggle.Text =
                "OFF"
            mainJump.lookToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end

    if mainJump.rageLookToggle then
        if mainJump.rageLookEnabled then
            mainJump.rageLookToggle.Text =
                "ON"
            mainJump.rageLookToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            mainJump.rageLookToggle.Text =
                "OFF"
            mainJump.rageLookToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end

    if mainJump.smartAirTurnToggle then
        if mainJump.smartAirTurnEnabled then
            mainJump.smartAirTurnToggle.Text =
                "ON"
            mainJump.smartAirTurnToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            mainJump.smartAirTurnToggle.Text =
                "OFF"
            mainJump.smartAirTurnToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end

    if mainJump.crouchSpamToggle then
        if mainJump.crouchSpamEnabled then
            mainJump.crouchSpamToggle.Text =
                "ON"
            mainJump.crouchSpamToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            mainJump.crouchSpamToggle.Text =
                "OFF"
            mainJump.crouchSpamToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end

    mainJump.updateReverseLookUI(
        true
    )

    if mainJump.benchTrimpToggle then
        if mainJump.benchTrimpEnabled then
            mainJump.benchTrimpToggle.Text =
                "ON"
            mainJump.benchTrimpToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            mainJump.benchTrimpToggle.Text =
                "OFF"
            mainJump.benchTrimpToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end

    pcall(function()
        mainJump.syncAutoJumpModePickerVisual()
    end)

    if mainJump.airTurnToggle then
        if mainJump.airTurnEnabled then
            mainJump.airTurnToggle.Text =
                "ON"
            mainJump.airTurnToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            mainJump.airTurnToggle.Text =
                "OFF"
            mainJump.airTurnToggle.BackgroundColor3 =
                Color3.fromRGB(
                    47,
                    52,
                    61
                )
        end
    end
end
function mainJump.setEnabled(state)
    mainJump.enabled =
        state and true or false

    if mainJump.enabled then
        mainJump.needsInputRearm = false

        if mainJump.airTurnEnabled then
            mainJump.findLookMovementState()
            mainJump.bindAirTurnRender()
        end

        if mainJump.character
            and mainJump.humanoid
            and mainJump.humanoid.Parent
        then
            if mainJump.autoJumpMode == "legit" then
                mainJump.destroySensors()
                mainJump.bindLegitJumpLoop()
            else
                pcall(function()
                    mainJump.createSensors(
                        mainJump.character
                    )
                end)

                task.defer(function()
                    if not genv.DEADEYE_MAIN_RUNNING
                        or not mainJump.enabled
                        or mainJump.autoJumpMode ~= "rage"
                        or not mainJump.humanoid
                        or not mainJump.humanoid.Parent
                    then
                        return
                    end

                    if mainJump.canJump() then
                        mainJump.lookAutoJumpCycle = true
                        mainJump.jump()
                    end
                end)
            end
        end
    else
        mainJump.needsInputRearm = true
        mainJump.destroySensors()

        mainJump.lookAutoJumpCycle = false
        mainJump.lookTriggeredThisAir = false
        mainJump.manualJumpActive = false
        mainJump.unbindAirTurnRender()

        if mainJump.lookWatcherConnection then
            pcall(function()
                mainJump.lookWatcherConnection:Disconnect()
            end)
            mainJump.lookWatcherConnection = nil
        end

        mainJump.endLook()

        if mainJump.humanoid
            and mainJump.humanoid.Parent
        then
            pcall(function()
                mainJump.humanoid.Jump = false
            end)

            task.defer(function()
                if mainJump.humanoid
                    and mainJump.humanoid.Parent
                then
                    pcall(function()
                        mainJump.humanoid.Jump = false
                    end)
                end
            end)
        end
    end

    mainJump.update()
end

function mainJump.setAutoJumpMode(mode, persist)
    mode =
        tostring(
            mode or ""
        ):lower()

    if mode ~= "legit"
        and mode ~= "rage"
    then
        mode = "rage"
    end

    mainJump.autoJumpMode = mode

    if mainJump.enabled
        and mainJump.character
        and mainJump.humanoid
        and mainJump.humanoid.Parent
    then
        if mode == "legit" then
            mainJump.destroySensors()
            mainJump.lookAutoJumpCycle = false
            mainJump.lookTriggeredThisAir = false
            mainJump.bindLegitJumpLoop()
        else
            mainJump.stopLegitJumpLoop()

            pcall(function()
                mainJump.createSensors(
                    mainJump.character
                )
            end)

            task.defer(function()
                if not genv.DEADEYE_MAIN_RUNNING
                    or not mainJump.enabled
                    or mainJump.autoJumpMode ~= "rage"
                    or not mainJump.humanoid
                    or not mainJump.humanoid.Parent
                then
                    return
                end

                if mainJump.canJump() then
                    mainJump.lookAutoJumpCycle = true
                    mainJump.jump()
                end
            end)
        end
    end

    if persist ~= false then
        mainJump.saveConfig()
    end

    mainJump.update()
end

function mainJump.setupAutoJumpCharacter(char)
    if not char
        or not char:IsA("Model")
    then
        return
    end

    mainJump.stopLegitJumpLoop()
    mainJump.destroySensors()

    mainJump.character =
        char

    mainJump.humanoid =
        char:WaitForChild(
            "Humanoid"
        )

    mainJump.root =
        char:WaitForChild(
            "HumanoidRootPart"
        )

    if mainJump.autoJumpMode == "legit" then
        if mainJump.enabled then
            mainJump.bindLegitJumpLoop()
        end
    else
        pcall(function()
            mainJump.createSensors(
                char
            )
        end)
    end
end

function mainJump.setDelay(value)
    value =
        tonumber(
            tostring(value or "")
        )
    if not value then
        return
    end
    mainJump.jumpDelay =
        math.clamp(
            value,
            0,
            5
        )
    mainJump.delayBox.Text =
        tostring(
            mainJump.jumpDelay
        )
    mainJump.saveConfig()
end

function mainJump.getCrouchMovement()
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

function mainJump.setCrouching(state)
    local movement =
        mainJump.getCrouchMovement()

    if not movement then
        return false
    end

    mainJump.crouchSpamMovement =
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

function mainJump.stopCrouchSpam()
    if mainJump.crouchSpamThread then
        pcall(function()
            task.cancel(
                mainJump.crouchSpamThread
            )
        end)

        mainJump.crouchSpamThread = nil
    end

    mainJump.crouchSpamEnabled =
        false

    mainJump.destroyCrouchSpamSensor()

    -- Always finish standing.
    mainJump.setCrouching(false)
end

function mainJump.setCrouchSpamEnabled(state)
    state =
        state and true or false

    if not state then
        mainJump.stopCrouchSpam()
        mainJump.update()
        mainJump.saveConfig()
        return
    end

    if cleaned then
        return
    end

    --// WITH mode depends on the Reverse Look hook intercepting
    --// DataRegistry.LookCFrame. After a script restart the saved
    --// mode is restored, but the hook itself is not, so install it
    --// when CROUCH SPAM is enabled as well.
    if state
        and mainJump.reverseLookMode == "with"
        and not mainJump.reverseLookHookInstalled
    then
        pcall(function()
            mainJump.installReverseLookHooks()
        end)
    end

    if mainJump.crouchSpamEnabled
        and mainJump.crouchSpamThread
    then
        return
    end

    mainJump.crouchSpamEnabled = true

    if mainJump.character
        and mainJump.character.Parent
    then
        mainJump.createCrouchSpamSensor(
            mainJump.character
        )
    end

    mainJump.crouchSpamThread =
        task.spawn(
            function()
                while genv.DEADEYE_MAIN_RUNNING
                    and not cleaned
                    and mainJump.crouchSpamEnabled
                do
                    if not mainJump.setCrouching(true) then
                        break
                    end

                    task.wait(
                        mainJump.crouchSpamDelay
                    )

                    if not genv.DEADEYE_MAIN_RUNNING
                        or cleaned
                        or not mainJump.crouchSpamEnabled
                    then
                        break
                    end

                    --// Contacting geometry has priority over the
                    --// normal stand edge of the crouch-spam cycle.
                    if not mainJump.crouchSpamSensorContacting then
                        if not mainJump.setCrouching(false) then
                            break
                        end
                    end

                    task.wait(
                        mainJump.crouchSpamDelay
                    )
                end

                mainJump.crouchSpamEnabled =
                    false

                mainJump.crouchSpamThread =
                    nil

                mainJump.setCrouching(false)

                mainJump.update()
            end
        )

    mainJump.update()
    mainJump.saveConfig()
end

function mainJump.setCrouchSpamDelay(value)
    local number =
        tonumber(
            tostring(value or "")
        )

    if not number then
        return
    end

    mainJump.crouchSpamDelay =
        math.clamp(
            number,
            0.001,
            5
        )

    if mainJump.crouchSpamDelayBox then
        mainJump.crouchSpamDelayBox.Text =
            tostring(
                mainJump.crouchSpamDelay
            )
    end

    mainJump.saveConfig()
end

local function mainFindKeyCode(value)
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
local airTurnHotkeyKey =
    mainFindKeyCode(
        mainJump.airTurnHotkeyName
    )
if airTurnHotkeyKey then
    mainJump.airTurnHotkeyName =
        airTurnHotkeyKey.Name
else
    mainJump.airTurnHotkeyName =
        "O"
end

function mainJump.setAirTurnHotkey(value)
    local key =
        mainFindKeyCode(
            value
        )

    if not key then
        return
    end

    mainJump.airTurnHotkeyName =
        key.Name

    if mainJump.airTurnHotkeyBox then
        mainJump.airTurnHotkeyBox.Text =
            key.Name
    end

    mainJump.capturing = nil
    mainJump.saveConfig()
end

local crouchSpamKey =
    mainFindKeyCode(
        mainJump.crouchSpamHotkeyName
    )
if crouchSpamKey then
    mainJump.crouchSpamHotkeyName =
        crouchSpamKey.Name
else
    mainJump.crouchSpamHotkeyName =
        "I"
end

function mainJump.setCrouchSpamHotkey(value)
    local key =
        mainFindKeyCode(
            value
        )

    if not key then
        return
    end

    mainJump.crouchSpamHotkeyName =
        key.Name

    if mainJump.crouchSpamHotkeyBox then
        mainJump.crouchSpamHotkeyBox.Text =
            key.Name
    end

    mainJump.capturing = nil

    mainJump.saveConfig()
end

local benchTrimpKey =
    mainFindKeyCode(
        mainJump.benchTrimpHotkeyName
    )
if benchTrimpKey then
    mainJump.benchTrimpHotkeyName =
        benchTrimpKey.Name
else
    mainJump.benchTrimpHotkeyName =
        "P"
end

function mainJump.setBenchTrimpHotkey(value)
    local key =
        mainFindKeyCode(
            value
        )

    if not key then
        return
    end

    mainJump.benchTrimpHotkeyName =
        key.Name

    if mainJump.benchTrimpHotkeyBox then
        mainJump.benchTrimpHotkeyBox.Text =
            key.Name
    end

    mainJump.capturing = nil

    mainJump.saveConfig()
end

local jumpKey =
    mainFindKeyCode(
        mainJump.hotkeyName
    )
if jumpKey then
    mainJump.hotkeyName =
        jumpKey.Name
else
    mainJump.hotkeyName = "Z"
end
local hideKey =
    mainFindKeyCode(
        mainJump.hideUIHotkeyName
    )
if hideKey then
    mainJump.hideUIHotkeyName =
        hideKey.Name
else
    mainJump.hideUIHotkeyName = "H"
end
function mainJump.setHotkey(value)
    local key =
        mainFindKeyCode(
            value
        )
    if not key then
        return
    end
    mainJump.hotkeyName =
        key.Name
    mainJump.hotkeyBox.Text =
        key.Name
    mainJump.saveConfig()
    mainJump.capturing = nil
end
function mainJump.setHideUIHotkey(value)
    local key =
        mainFindKeyCode(
            value
        )
    if not key then
        return
    end
    mainJump.hideUIHotkeyName =
        key.Name
    mainJump.hideUIHotkeyBox.Text =
        key.Name
    mainJump.saveConfig()
    mainJump.capturing = nil
end
function mainJump.startCapture(kind)
    mainJump.capturing =
        kind

    if kind == "jump" then
        mainJump.hotkeyBox.Text =
            "PRESS KEY..."
    elseif kind == "hide" then
        mainJump.hideUIHotkeyBox.Text =
            "PRESS KEY..."
    elseif kind == "airTurn" then
        mainJump.airTurnHotkeyBox.Text =
            "PRESS KEY..."
    elseif kind == "crouchSpam" then
        mainJump.crouchSpamHotkeyBox.Text =
            "PRESS KEY..."
    elseif kind == "benchTrimp" then
        mainJump.benchTrimpHotkeyBox.Text =
            "PRESS KEY..."
    end
end
function mainJump.stopLegitJumpLoop()
    if mainJump.legitJumpConnection then
        pcall(function()
            mainJump.legitJumpConnection:Disconnect()
        end)
        mainJump.legitJumpConnection = nil
    end
end

function mainJump.bindLegitJumpLoop()
    mainJump.stopLegitJumpLoop()

    if not genv.DEADEYE_MAIN_RUNNING
        or cleaned
        or not mainJump.enabled
        or mainJump.autoJumpMode ~= "legit"
    then
        return
    end

    mainJump.legitJumpConnection =
        RunService.PreSimulation:Connect(
            function()
                if not genv.DEADEYE_MAIN_RUNNING
                    or cleaned
                    or not mainJump.enabled
                    or mainJump.autoJumpMode ~= "legit"
                then
                    mainJump.stopLegitJumpLoop()
                    return
                end

                local object =
                    getCharacterObject()

                local movement =
                    object
                    and object.Movement

                if not movement then
                    return
                end

                pcall(function()
                    movement:AttemptJump(
                        nil,
                        true
                    )
                end)
            end
        )
end

function mainJump.destroySensors()
    mainJump.stopLegitJumpLoop()

    if mainJump.lookWatcherConnection then
        pcall(function()
            mainJump.lookWatcherConnection:Disconnect()
        end)
        mainJump.lookWatcherConnection = nil
    end

    mainJump.manualJumpActive = false
    mainJump.lookTriggeredThisAir = false

    if mainJump.sensorTouchConnection then
        pcall(function()
            mainJump.sensorTouchConnection:Disconnect()
        end)
        mainJump.sensorTouchConnection = nil
    end

    if mainJump.frontSensorTouchConnection then
        pcall(function()
            mainJump.frontSensorTouchConnection:Disconnect()
        end)
        mainJump.frontSensorTouchConnection = nil
    end

    if mainJump.rearSensorTouchConnection then
        pcall(function()
            mainJump.rearSensorTouchConnection:Disconnect()
        end)
        mainJump.rearSensorTouchConnection = nil
    end

    if mainJump.jumpForwardSensorTouchConnection then
        pcall(function()
            mainJump.jumpForwardSensorTouchConnection:Disconnect()
        end)
        mainJump.jumpForwardSensorTouchConnection = nil
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
            mainJump[key]

        if sensor then
            pcall(function()
                sensor:Destroy()
            end)

            mainJump[key] = nil
        end
    end

    --// Crouch Spam has its own independent sensor. Keep it alive
    --// when only AutoJump is disabled.
    if not mainJump.crouchSpamEnabled then
        mainJump.destroyCrouchSpamSensor()
    end
end

function mainJump.isGameJumpBlocked()
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
        mainJump.character,
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

function mainJump.canJump(benchTrimp)
    if not genv.DEADEYE_MAIN_RUNNING
        or not mainJump.humanoid
        or mainJump.humanoid.Health <= 0
    then
        return false
    end

    if not benchTrimp
        and not mainJump.enabled
    then
        return false
    end

    if not benchTrimp
        and mainJump.humanoid.FloorMaterial
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
            if mainJump.isGameJumpBlocked() then
                return false
            end
        end
    else
        if mainJump.isGameJumpBlocked() then
            return false
        end
    end

    if benchTrimp then
        --// Bench Trimp fires from Climbing, so do not require
        --// the grounded/airborne state rules used by AutoJump.
        return true
    end

    local state =
        mainJump.humanoid:GetState()

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
function mainJump.bindBenchTrimp(char)
    if mainJump.benchTrimpStateConnection then
        pcall(function()
            mainJump.benchTrimpStateConnection:Disconnect()
        end)
        mainJump.benchTrimpStateConnection = nil
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

    mainJump.benchTrimpStateConnection =
        humanoid.StateChanged:Connect(
            function(_, newState)
                if not genv.DEADEYE_MAIN_RUNNING
                    or cleaned
                    or not mainJump.benchTrimpEnabled
                    or mainJump.character ~= char
                    or forcing
                then
                    return
                end

                if newState
                    ~= Enum.HumanoidStateType.Climbing
                then
                    return
                end

                if not mainJump.canJump(true) then
                    return
                end

                forcing = true

                task.defer(function()
                    if not genv.DEADEYE_MAIN_RUNNING
                        or cleaned
                        or not mainJump.benchTrimpEnabled
                        or mainJump.character ~= char
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

                    if not mainJump.canJump(true) then
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

function mainJump.setBenchTrimpEnabled(state)
    mainJump.benchTrimpEnabled =
        state and true or false

    if mainJump.benchTrimpEnabled then
        local char =
            mainJump.character
            or LocalPlayer.Character

        if char then
            pcall(function()
                mainJump.bindBenchTrimp(
                    char
                )
            end)
        end
    end

    mainJump.saveConfig()
    mainJump.saveEnabledStates()
    mainJump.update()
end

function mainJump.lookScannerSeesSurface()
    --// Only accept an actual collidable landing surface directly below.
    --// The old overlap-box scanner could see arbitrary map geometry and
    --// re-trigger LOOK repeatedly on some maps.
    if not mainJump.lookEnabled
        or not mainJump.enabled
        or not mainJump.root
        or not mainJump.character
    then
        return false
    end

    local params =
        RaycastParams.new()

    params.FilterType =
        Enum.RaycastFilterType.Exclude

    params.FilterDescendantsInstances = {
        mainJump.character
    }

    params.IgnoreWater = true

    local rayLength =
        7.5

    local origins = {
        mainJump.root.Position
            + Vector3.new(
                0,
                -0.75,
                0
            )
    }

    if mainJump.lookForwardSensorPart
        and mainJump.lookForwardSensorPart.Parent
    then
        table.insert(
            origins,
            mainJump.lookForwardSensorPart.Position
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

function mainJump.jump(hit)
    if not mainJump.canJump() then
        return
    end

    mainJump.lastJump =
        tick()

    --// Starting an automatic jump begins a NEW airborne phase.
    --// LOOK is allowed to trigger once near the landing of this jump.

    if mainJump.lookEnabled
        and mainJump.enabled
        and mainJump.lookActive
    then
        mainJump.lookAutoJumpCycle = true
        mainJump.lookRestoreDeadline =
            tick()
            + LOOK_MAX_AFTER_JUMP
        mainJump.lookMinActiveDeadline =
            tick()
            + LOOK_MIN_ACTIVE
    end

    mainJump.humanoid.Jump = true

    if mainJump.lookActive then
        mainJump.lookRestoreDeadline =
            tick()
            + LOOK_MAX_AFTER_JUMP
    end

    pcall(function()
        mainJump.humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end)
end

function mainJump.isCameraLookingBackward()
    local camera =
        workspace.CurrentCamera

    local root =
        mainJump.root

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

function mainJump.contact(hit, requireCameraBackward)
    if not genv.DEADEYE_MAIN_RUNNING
        or not mainJump.enabled
        or mainJump.autoJumpMode ~= "rage"
        or not hit
    then
        return
    end

    if requireCameraBackward
        and not mainJump.isCameraLookingBackward()
    then
        return
    end

    if mainJump.character
        and hit:IsDescendantOf(
            mainJump.character
        )
    then
        return
    end

    task.wait(
        mainJump.jumpDelay
    )

    if not genv.DEADEYE_MAIN_RUNNING
        or not mainJump.enabled
    then
        return
    end

    if requireCameraBackward
        and not mainJump.isCameraLookingBackward()
    then
        return
    end

    mainJump.jump(hit)
end

function mainJump.destroyCrouchSpamSensor()
    if mainJump.crouchSpamSensorHeartbeatConnection then
        pcall(function()
            mainJump.crouchSpamSensorHeartbeatConnection:Disconnect()
        end)

        mainJump.crouchSpamSensorHeartbeatConnection = nil
    end

    if mainJump.crouchSpamSensorPart then
        pcall(function()
            mainJump.crouchSpamSensorPart:Destroy()
        end)

        mainJump.crouchSpamSensorPart = nil
    end

    mainJump.crouchSpamSensorContacting = false
end

function mainJump.getCrouchSpamSensorLegs(char)
    if not char then
        return {}
    end

    local result = {}

    local function addNamedLeg(names)
        for _, name in ipairs(names) do
            local part =
                char:FindFirstChild(
                    name,
                    true
                )

            if part
                and part:IsA("BasePart")
            then
                table.insert(
                    result,
                    part
                )

                return
            end
        end
    end

    --// Prefer the actual foot part when the rig exposes one.
    --// Falling back to lower-leg / R6 leg keeps this compatible
    --// with rigs that do not have separate foot parts.
    addNamedLeg({
        "LeftFoot",
        "Left Foot",
        "LeftLowerLeg",
        "Left Leg"
    })

    addNamedLeg({
        "RightFoot",
        "Right Foot",
        "RightLowerLeg",
        "Right Leg"
    })

    return result
end

function mainJump.getCrouchSpamSensorLayout(char)
    local legs =
        mainJump.getCrouchSpamSensorLegs(
            char
        )

    if #legs == 0 then
        return Vector3.new(
            2,
            0.20,
            1
        ), nil
    end

    local minWorldY = math.huge
    local minWorldX = math.huge
    local maxWorldX = -math.huge
    local minWorldZ = math.huge
    local maxWorldZ = -math.huge

    for _, leg in ipairs(legs) do
        local halfSize =
            leg.Size * 0.5

        --// Use all 8 world-space corners so the sensor follows the
        --// actual lower leg footprint even while the rig animates.
        for _, sx in ipairs({ -1, 1 }) do
            for _, sy in ipairs({ -1, 1 }) do
                for _, sz in ipairs({ -1, 1 }) do
                    local corner =
                        leg.CFrame:PointToWorldSpace(
                            Vector3.new(
                                halfSize.X * sx,
                                halfSize.Y * sy,
                                halfSize.Z * sz
                            )
                        )

                    minWorldY =
                        math.min(
                            minWorldY,
                            corner.Y
                        )

                    minWorldX =
                        math.min(
                            minWorldX,
                            corner.X
                        )

                    maxWorldX =
                        math.max(
                            maxWorldX,
                            corner.X
                        )

                    minWorldZ =
                        math.min(
                            minWorldZ,
                            corner.Z
                        )

                    maxWorldZ =
                        math.max(
                            maxWorldZ,
                            corner.Z
                        )
                end
            end
        end
    end

    local center =
        Vector3.new(
            (minWorldX + maxWorldX) * 0.5,
            minWorldY,
            (minWorldZ + maxWorldZ) * 0.5
        )

    return Vector3.new(
        2,
        0.40,
        1
    ), center
end

function mainJump.createCrouchSpamSensor(char)
    mainJump.destroyCrouchSpamSensor()

    if not mainJump.crouchSpamEnabled
        or not char
        or not char:IsA("Model")
    then
        return
    end

    local root =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root then
        return
    end

    local sensorSize =
        mainJump.getCrouchSpamSensorLayout(
            char
        )

    local sensor =
        Instance.new("Part")

    sensor.Name =
        "CrouchSpamFootSensor"

    sensor.Size =
        sensorSize

    sensor.Transparency = 1
    sensor.Color = Color3.fromRGB(
        255,
        80,
        80
    )
    sensor.Anchored = true
    sensor.CanCollide = false
    sensor.CanTouch = false
    sensor.CanQuery = true
    sensor.Massless = true
    sensor.CastShadow = false

    --// Independent from the actual legs: there is no weld.
    --// The sensor itself is only anchored in the character.
    --// Its position is recalculated from the real world-space
    --// bottom of the leg parts every Heartbeat.
    local function updateSensorPosition()
        if not sensor.Parent
            or not root.Parent
        then
            return
        end

        local _, center =
            mainJump.getCrouchSpamSensorLayout(
                char
            )

        if not center then
            return
        end

        local _, yaw, _ =
            root.CFrame:ToOrientation()

        sensor.CFrame =
            CFrame.new(
                center.X,
                center.Y
                    + (sensor.Size.Y * 0.5)
                    - 1.79,
                center.Z
            )
            * CFrame.Angles(
                0,
                yaw,
                0
            )
    end

    updateSensorPosition()

    sensor.Parent = char

    mainJump.crouchSpamSensorPart =
        sensor

    local overlapParams =
        OverlapParams.new()

    overlapParams.FilterType =
        Enum.RaycastFilterType.Exclude

    overlapParams.FilterDescendantsInstances = {
        char
    }

    overlapParams.MaxParts = 32

    local function scanContact()
        if not genv.DEADEYE_MAIN_RUNNING
            or cleaned
            or not mainJump.crouchSpamEnabled
            or mainJump.crouchSpamSensorPart ~= sensor
            or not sensor.Parent
            or not root.Parent
        then
            return false
        end

        updateSensorPosition()

        local parts = {}
        pcall(function()
            parts =
                workspace:GetPartBoundsInBox(
                    sensor.CFrame,
                    sensor.Size,
                    overlapParams
                )
        end)

        --// Any collidable BasePart overlapping the sensor counts as
        --// contact. No extra Y/height test: visible overlap means
        --// forced crouch until the overlap disappears.
        for _, part in ipairs(parts) do
            if part
                and part:IsA("BasePart")
                and part.CanCollide
                and not part:IsDescendantOf(char)
            then
                return true
            end
        end

        return false
    end

    mainJump.crouchSpamSensorHeartbeatConnection =
        RunService.Heartbeat:Connect(
            function()
                local touching =
                    scanContact()

                if not genv.DEADEYE_MAIN_RUNNING
                    or cleaned
                    or not mainJump.crouchSpamEnabled
                    or mainJump.crouchSpamSensorPart ~= sensor
                then
                    return
                end

                if touching then
                    mainJump.crouchSpamSensorContacting =
                        true

                    --// Re-assert crouch while contact is active.
                    mainJump.setCrouching(true)
                elseif mainJump.crouchSpamSensorContacting then
                    mainJump.crouchSpamSensorContacting =
                        false
                end
            end
        )

    local touching =
        scanContact()

    if touching then
        mainJump.crouchSpamSensorContacting =
            true

        mainJump.setCrouching(true)
    end
end

function mainJump.createSensors(char)
    if not char
        or not char:IsA("Model")
    then
        return
    end

    mainJump.destroySensors()

    mainJump.character =
        char

    mainJump.humanoid =
        char:WaitForChild(
            "Humanoid"
        )

    mainJump.root =
        char:WaitForChild(
            "HumanoidRootPart"
        )

    mainJump.lookTriggeredThisAir = false

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
        mainJump.root.CFrame
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
        mainJump.root
    weld.Part1 =
        sensor
    weld.Parent =
        sensor

    mainJump.sensorPart =
        sensor

    mainJump.sensorTouchConnection =
        sensor.Touched:Connect(
            function(hit)
                mainJump.contact(hit)
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
        mainJump.root.CFrame
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
        mainJump.root
    frontWeld.Part1 =
        front
    frontWeld.Parent =
        front

    mainJump.frontSensorPart =
        front

    mainJump.frontSensorTouchConnection =
        front.Touched:Connect(
            function(hit)
                mainJump.contact(hit)
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
        mainJump.root.CFrame
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
        mainJump.root

    rearWeld.Part1 =
        rear

    rearWeld.Parent =
        rear

    mainJump.rearSensorPart =
        rear

    mainJump.rearSensorTouchConnection =
        rear.Touched:Connect(
            function(hit)
                mainJump.contact(
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
        mainJump.root.CFrame
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
        mainJump.root

    jumpForwardExtraWeld.Part1 =
        jumpForwardExtra

    jumpForwardExtraWeld.Parent =
        jumpForwardExtra

    mainJump.jumpForwardSensorPart =
        jumpForwardExtra

    mainJump.jumpForwardSensorTouchConnection =
        jumpForwardExtra.Touched:Connect(
            function(hit)
                mainJump.contact(hit)
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
        mainJump.root.CFrame
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
        mainJump.root

    lookForwardExtraWeld.Part1 =
        lookForwardExtra

    lookForwardExtraWeld.Parent =
        lookForwardExtra

    mainJump.lookForwardSensorPart =
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
        mainJump.root.CFrame
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
        mainJump.root
    lookWeld.Part1 =
        lookSensor
    lookWeld.Parent =
        lookSensor

    mainJump.lookSensorPart =
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
        mainJump.root.CFrame
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
        mainJump.root
    lookFrontWeld.Part1 =
        lookFront
    lookFrontWeld.Parent =
        lookFront

    mainJump.lookFrontSensorPart =
        lookFront

    --// =====================================================
    --// LOOK PRE-LANDING WATCHER
    --// =====================================================
    --// Runs only while AutoJump is enabled. It waits for the
    --// character to be descending and for the separate LOOK
    --// sensor to see the landing surface. This is deliberately
    --// earlier than the normal AutoJump Touched event.
    mainJump.lookWatcherConnection =
        RunService.Heartbeat:Connect(
            function()
                if not genv.DEADEYE_MAIN_RUNNING
                    or cleaned
                    or not mainJump.enabled
                    or not mainJump.lookEnabled
                    or mainJump.rageLookEnabled
                    or not mainJump.humanoid
                    or not mainJump.root
                then
                    return
                end

                if mainJump.manualJumpActive then
                    if mainJump.humanoid.FloorMaterial
                        ~= Enum.Material.Air
                    then
                        mainJump.manualJumpActive = false
                    else
                        return
                    end
                end

                local state
                local verticalVelocity = 0

                pcall(function()
                    state =
                        mainJump.humanoid:GetState()
                    verticalVelocity =
                        mainJump.root.AssemblyLinearVelocity.Y
                end)

                local grounded =
                    mainJump.humanoid.FloorMaterial
                        ~= Enum.Material.Air
                    or state
                        == Enum.HumanoidStateType.Landed
                    or state
                        == Enum.HumanoidStateType.Running
                    or state
                        == Enum.HumanoidStateType.RunningNoPhysics

                if grounded then
                    mainJump.lookTriggeredThisAir = false
                    mainJump.lookAutoJumpCycle = false
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
                if not mainJump.lookTriggeredThisAir
                    and not mainJump.lookActive
                    and mainJump.lookScannerSeesSurface()
                then
                    mainJump.lookTriggeredThisAir = true
                    mainJump.lookAutoJumpCycle = true
                    mainJump.beginLook()
                end
            end
        )

    if mainJump.crouchSpamEnabled then
        mainJump.createCrouchSpamSensor(
            char
        )
    end
end
genv.DEADEYE_MAIN_RUNNING = true
mainPage =
    Instance.new("ScrollingFrame")
mainPage.Name =
    "MainPage"
mainPage.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
mainPage.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
mainPage.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainPage.BorderSizePixel = 0
mainPage.ScrollBarThickness = 6
mainPage.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
mainPage.ScrollingDirection =
    Enum.ScrollingDirection.Y
mainPage.Visible = false
mainPage.Parent = Main
__UI.mainCorner =
    Instance.new("UICorner")
__UI.mainCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
__UI.mainCorner.Parent =
    mainPage
local mainPadding =
    Instance.new("UIPadding")
mainPadding.PaddingTop =
    UDim.new(
        0,
        8
    )
mainPadding.PaddingBottom =
    UDim.new(
        0,
        8
    )
mainPadding.PaddingLeft =
    UDim.new(
        0,
        8
    )
mainPadding.PaddingRight =
    UDim.new(
        0,
        8
    )
mainPadding.Parent =
    mainPage
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
    mainPage
local function mainRow(labelText, order)
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
    row.Parent = mainPage

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
    mainRow(
        "AUTOJUMP",
        1
    )
local autoLabel =
    Instance.new("TextLabel")
autoLabel.Size =
    UDim2.new(
        0.7,
        0,
        1,
        0
    )
autoLabel.Position =
    UDim2.new(
        0,
        10,
        0,
        0
    )
autoLabel.BackgroundTransparency = 1
autoLabel.Text = "AUTOJUMP"
autoLabel.TextSize = 11
autoLabel.Font = Enum.Font.GothamBold
autoLabel.TextColor3 =
    Color3.fromRGB(
        215,
        215,
        215
    )
autoLabel.TextXAlignment =
    Enum.TextXAlignment.Left
autoLabel.Parent = __UI.autoRow

mainJump.hotkeyBox =
    Instance.new("TextButton")
mainJump.hotkeyBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
mainJump.hotkeyBox.Position =
    UDim2.new(
        1,
        -235,
        0.5,
        -14
    )
mainJump.hotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.hotkeyBox.BorderSizePixel = 0
mainJump.hotkeyBox.Text =
    mainJump.hotkeyName
mainJump.hotkeyBox.TextSize = 10
mainJump.hotkeyBox.Font =
    Enum.Font.GothamBold
mainJump.hotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.hotkeyBox.Parent =
    __UI.autoRow

__UI.autoHotkeyCorner =
    Instance.new("UICorner")
__UI.autoHotkeyCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.autoHotkeyCorner.Parent =
    mainJump.hotkeyBox

mainConnect(
    mainJump.hotkeyBox.MouseButton1Click:Connect(
        function()
            mainJump.startCapture(
                "jump"
            )
        end
    )
)

mainJump.delayBox =
    Instance.new("TextBox")
mainJump.delayBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
mainJump.delayBox.Position =
    UDim2.new(
        1,
        -155,
        0.5,
        -14
    )
mainJump.delayBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.delayBox.BorderSizePixel = 0
mainJump.delayBox.ClearTextOnFocus = false
mainJump.delayBox.Text =
    tostring(
        mainJump.jumpDelay
    )
mainJump.delayBox.TextSize = 10
mainJump.delayBox.Font =
    Enum.Font.GothamBold
mainJump.delayBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.delayBox.Parent =
    __UI.autoRow

__UI.autoDelayCorner =
    Instance.new("UICorner")
__UI.autoDelayCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.autoDelayCorner.Parent =
    mainJump.delayBox

mainConnect(
    mainJump.delayBox.FocusLost:Connect(
        function(enterPressed)
            if enterPressed then
                mainJump.setDelay(
                    mainJump.delayBox.Text
                )
            else
                mainJump.delayBox.Text =
                    tostring(
                        mainJump.jumpDelay
                    )
            end
        end
    )
)

mainJump.toggle =
    Instance.new("TextButton")
mainJump.toggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
mainJump.toggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
mainJump.toggle.BorderSizePixel = 0
mainJump.toggle.TextSize = 10
mainJump.toggle.Font = Enum.Font.GothamBold
mainJump.toggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.toggle.Parent =
    __UI.autoRow
__UI.toggleCorner =
    Instance.new("UICorner")
__UI.toggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.toggleCorner.Parent =
    mainJump.toggle
mainConnect(
    mainJump.toggle.MouseButton1Click:Connect(
        function()
            mainJump.setEnabled(
                not mainJump.enabled
            )
        end
    )
)

--// =========================================================
--// AUTO JUMP MODE
--// LEGIT = proven native AttemptJump(nil, true) on PreSimulation.
--// RAGE = existing sensor-based DeadEye AutoJump.
--// =========================================================
__UI.autoJumpModeRow =
    mainRow(
        "AUTO JUMP MODE",
        2
    )

local autoJumpModeLabel =
    autoLabel:Clone()

autoJumpModeLabel.Text =
    "AUTO JUMP MODE"

autoJumpModeLabel.Parent =
    __UI.autoJumpModeRow

mainJump.autoJumpModeButton =
    Instance.new("TextButton")

mainJump.autoJumpModeButton.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )

mainJump.autoJumpModeButton.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )

mainJump.autoJumpModeButton.BorderSizePixel =
    0

mainJump.autoJumpModeButton.TextSize =
    10

mainJump.autoJumpModeButton.Font =
    Enum.Font.GothamBold

mainJump.autoJumpModeButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

mainJump.autoJumpModeButton.Parent =
    __UI.autoJumpModeRow

local autoJumpModeCorner =
    Instance.new("UICorner")

autoJumpModeCorner.CornerRadius =
    UDim.new(
        0,
        5
    )

autoJumpModeCorner.Parent =
    mainJump.autoJumpModeButton

mainJump.autoJumpModePicker =
    Instance.new("Frame")

mainJump.autoJumpModePicker.Name =
    "AutoJumpModePicker"

mainJump.autoJumpModePicker.Size =
    UDim2.new(
        0,
        88,
        0,
        94
    )

mainJump.autoJumpModePicker.Position =
    UDim2.new(
        1,
        -102,
        1,
        5
    )

mainJump.autoJumpModePicker.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )

mainJump.autoJumpModePicker.BackgroundTransparency =
    0

mainJump.autoJumpModePicker.BackgroundTransparency =
    0

mainJump.autoJumpModePicker.ClipsDescendants =
    false

mainJump.autoJumpModePicker.Active =
    true

mainJump.autoJumpModePicker.BorderSizePixel =
    0

mainJump.autoJumpModePicker.ZIndex =
    80

mainJump.autoJumpModePicker.Visible =
    false

mainJump.autoJumpModePicker.Parent =
    Main

local autoJumpModePickerCorner =
    Instance.new("UICorner")

autoJumpModePickerCorner.CornerRadius =
    UDim.new(
        0,
        7
    )

autoJumpModePickerCorner.Parent =
    mainJump.autoJumpModePicker

--// Reuse the existing local register for the picker outline.
autoJumpModePickerCorner =
    Instance.new("UIStroke")

autoJumpModePickerCorner.Color =
    Color3.fromRGB(
        20,
        22,
        26
    )

autoJumpModePickerCorner.Thickness =
    1

autoJumpModePickerCorner.Transparency =
    0

autoJumpModePickerCorner.ApplyStrokeMode =
    Enum.ApplyStrokeMode.Border

autoJumpModePickerCorner.Parent =
    mainJump.autoJumpModePicker

local autoJumpModeScroll =
    Instance.new("ScrollingFrame")

autoJumpModeScroll.Size =
    UDim2.new(
        1,
        -12,
        1,
        -12
    )

autoJumpModeScroll.Position =
    UDim2.new(
        0,
        6,
        0,
        6
    )

autoJumpModeScroll.BackgroundTransparency =
    1

autoJumpModeScroll.BorderSizePixel =
    0

autoJumpModeScroll.ScrollBarThickness =
    4

autoJumpModeScroll.Active =
    true

autoJumpModeScroll.ScrollingDirection =
    Enum.ScrollingDirection.Y

autoJumpModeScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y

autoJumpModeScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )

autoJumpModeScroll.ZIndex =
    81

autoJumpModeScroll.Parent =
    mainJump.autoJumpModePicker

local autoJumpModeLayout =
    Instance.new("UIListLayout")

autoJumpModeLayout.Padding =
    UDim.new(
        0,
        12
    )

autoJumpModeLayout.HorizontalAlignment =
    Enum.HorizontalAlignment.Center

autoJumpModeLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

autoJumpModeLayout.Parent =
    autoJumpModeScroll

local autoJumpModePadding =
    Instance.new("UIPadding")

autoJumpModePadding.PaddingTop =
    UDim.new(
        0,
        6
    )

autoJumpModePadding.PaddingBottom =
    UDim.new(
        0,
        6
    )

autoJumpModePadding.Parent =
    autoJumpModeScroll

local function createAutoJumpModeOption(
    mode,
    text
)
    --// Clone the real Auto Jump Mode selector button so the picker
    --// buttons use the EXACT same visual base: size, background,
    --// transparency, font, text sizing and corner radius.
    local button =
        mainJump.autoJumpModeButton:Clone()

    button.Name =
        "AutoJumpMode_" .. mode

    button.Position =
        UDim2.fromScale(
            0,
            0
        )

    button.Size =
        mainJump.autoJumpModeButton.Size

    button.AnchorPoint =
        mainJump.autoJumpModeButton.AnchorPoint

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
        autoJumpModeScroll

    button.ZIndex =
        83

    button.Parent =
        buttonHolder

    mainConnect(
        button.MouseButton1Click:Connect(
            function()
                mainJump.setAutoJumpMode(
                    mode
                )

                mainJump.autoJumpModePicker.Visible =
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

createAutoJumpModeOption(
    "legit",
    "LEGIT"
)

createAutoJumpModeOption(
    "rage",
    "RAGE"
)

local function positionAutoJumpModePicker()
    local picker =
        mainJump.autoJumpModePicker

    local button =
        mainJump.autoJumpModeButton

    if not picker
        or not button
        or not button.Parent
        or not Main
    then
        return
    end

    local mainPosition =
        Main.AbsolutePosition

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

mainConnect(
    mainJump.autoJumpModeButton.MouseButton1Click:Connect(
        function()
            local picker =
                mainJump.autoJumpModePicker

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
                positionAutoJumpModePicker()
            end
        end
    )
)

mainConnect(
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
                mainJump.autoJumpModePicker

            local button =
                mainJump.autoJumpModeButton

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
    mainRow(
        "LOOK",
        3
    )
local lookLabel =
    autoLabel:Clone()
lookLabel.Text =
    "LOOK"
lookLabel.Parent =
    __UI.lookRow
mainJump.lookToggle =
    Instance.new("TextButton")
mainJump.lookToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
mainJump.lookToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
mainJump.lookToggle.BorderSizePixel = 0
mainJump.lookToggle.TextSize = 10
mainJump.lookToggle.Font =
    Enum.Font.GothamBold
mainJump.lookToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.lookToggle.Parent =
    __UI.lookRow
__UI.lookToggleCorner =
    Instance.new("UICorner")
__UI.lookToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.lookToggleCorner.Parent =
    mainJump.lookToggle
mainConnect(
    mainJump.lookToggle.MouseButton1Click:Connect(
        function()
            mainJump.setLookEnabled(
                not mainJump.lookEnabled
            )
        end
    )
)

__UI.rageLookRow =
    mainRow(
        "RAGE LOOK",
        4
    )
local rageLookLabel =
    autoLabel:Clone()
rageLookLabel.Text =
    "RAGE LOOK"
rageLookLabel.Parent =
    __UI.rageLookRow

mainJump.rageLookToggle =
    Instance.new("TextButton")
mainJump.rageLookToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
mainJump.rageLookToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
mainJump.rageLookToggle.BorderSizePixel = 0
mainJump.rageLookToggle.TextSize = 10
mainJump.rageLookToggle.Font =
    Enum.Font.GothamBold
mainJump.rageLookToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.rageLookToggle.Parent =
    __UI.rageLookRow

__UI.rageLookToggleCorner =
    Instance.new("UICorner")
__UI.rageLookToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.rageLookToggleCorner.Parent =
    mainJump.rageLookToggle

mainConnect(
    mainJump.rageLookToggle.MouseButton1Click:Connect(
        function()
            mainJump.setRageLookEnabled(
                not mainJump.rageLookEnabled
            )
        end
    )
)

__UI.airTurnRow =
    mainRow(
        "AIR TURN",
        5
    )
local airTurnLabel =
    autoLabel:Clone()
airTurnLabel.Text =
    "AIR TURN"
airTurnLabel.Parent =
    __UI.airTurnRow

mainJump.airTurnHotkeyBox =
    Instance.new("TextButton")
mainJump.airTurnHotkeyBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
mainJump.airTurnHotkeyBox.Position =
    UDim2.new(
        1,
        -155,
        0.5,
        -14
    )
mainJump.airTurnHotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.airTurnHotkeyBox.BorderSizePixel = 0
mainJump.airTurnHotkeyBox.Text =
    mainJump.airTurnHotkeyName
mainJump.airTurnHotkeyBox.TextSize = 10
mainJump.airTurnHotkeyBox.Font =
    Enum.Font.GothamBold
mainJump.airTurnHotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.airTurnHotkeyBox.Parent =
    __UI.airTurnRow

local airTurnHotkeyCorner =
    Instance.new("UICorner")
airTurnHotkeyCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
airTurnHotkeyCorner.Parent =
    mainJump.airTurnHotkeyBox

mainConnect(
    mainJump.airTurnHotkeyBox.MouseButton1Click:Connect(
        function()
            mainJump.startCapture(
                "airTurn"
            )
        end
    )
)

mainJump.airTurnToggle =
    Instance.new("TextButton")
mainJump.airTurnToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
mainJump.airTurnToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
mainJump.airTurnToggle.BorderSizePixel =
    0
mainJump.airTurnToggle.TextSize =
    10
mainJump.airTurnToggle.Font =
    Enum.Font.GothamBold
mainJump.airTurnToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.airTurnToggle.Parent =
    __UI.airTurnRow
__UI.airTurnToggleCorner =
    Instance.new("UICorner")
__UI.airTurnToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.airTurnToggleCorner.Parent =
    mainJump.airTurnToggle
mainConnect(
    mainJump.airTurnToggle.MouseButton1Click:Connect(
        function()
            mainJump.setAirTurnEnabled(
                not mainJump.airTurnEnabled
            )
        end
    )
)

__UI.smartAirTurnRow =
    mainRow(
        "SMART AIR TURN",
        6
    )

local smartAirTurnLabel =
    autoLabel:Clone()
smartAirTurnLabel.Text =
    "SMART AIR TURN"
smartAirTurnLabel.Parent =
    __UI.smartAirTurnRow

mainJump.smartAirTurnToggle =
    Instance.new("TextButton")
mainJump.smartAirTurnToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
mainJump.smartAirTurnToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
mainJump.smartAirTurnToggle.BorderSizePixel = 0
mainJump.smartAirTurnToggle.TextSize = 10
mainJump.smartAirTurnToggle.Font =
    Enum.Font.GothamBold
mainJump.smartAirTurnToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.smartAirTurnToggle.Parent =
    __UI.smartAirTurnRow

local smartAirTurnToggleCorner =
    Instance.new("UICorner")
smartAirTurnToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
smartAirTurnToggleCorner.Parent =
    mainJump.smartAirTurnToggle

mainConnect(
    mainJump.smartAirTurnToggle.MouseButton1Click:Connect(
        function()
            mainJump.setSmartAirTurnEnabled(
                not mainJump.smartAirTurnEnabled
            )
        end
    )
)

__UI.airTurnSpeedRow =
    mainRow(
        "TURN SPEED",
        7
    )
local airTurnSpeedLabel =
    autoLabel:Clone()
airTurnSpeedLabel.Text =
    "TURN SPEED"
airTurnSpeedLabel.Parent =
    __UI.airTurnSpeedRow

mainJump.airTurnSliderTrack =
    Instance.new("Frame")
mainJump.airTurnSliderTrack.Size =
    UDim2.new(
        1,
        -190,
        0,
        6
    )
mainJump.airTurnSliderTrack.Position =
    UDim2.new(
        0,
        105,
        0.5,
        -3
    )
mainJump.airTurnSliderTrack.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.airTurnSliderTrack.BorderSizePixel =
    0
mainJump.airTurnSliderTrack.Active =
    true
mainJump.airTurnSliderTrack.Parent =
    __UI.airTurnSpeedRow

__UI.airTurnSliderTrackCorner =
    Instance.new("UICorner")
__UI.airTurnSliderTrackCorner.CornerRadius =
    UDim.new(
        1,
        0
    )
__UI.airTurnSliderTrackCorner.Parent =
    mainJump.airTurnSliderTrack

mainJump.airTurnSliderFill =
    Instance.new("Frame")
mainJump.airTurnSliderFill.Size =
    UDim2.new(
        0,
        0,
        1,
        0
    )
mainJump.airTurnSliderFill.BackgroundColor3 =
    Color3.fromRGB(
        82,
        88,
        100
    )
mainJump.airTurnSliderFill.BorderSizePixel =
    0
mainJump.airTurnSliderFill.Parent =
    mainJump.airTurnSliderTrack

__UI.airTurnSliderFillCorner =
    Instance.new("UICorner")
__UI.airTurnSliderFillCorner.CornerRadius =
    UDim.new(
        1,
        0
    )
__UI.airTurnSliderFillCorner.Parent =
    mainJump.airTurnSliderFill

mainJump.airTurnSliderKnob =
    Instance.new("Frame")
mainJump.airTurnSliderKnob.Size =
    UDim2.new(
        0,
        10,
        0,
        10
    )
mainJump.airTurnSliderKnob.AnchorPoint =
    Vector2.new(
        0,
        0.5
    )
mainJump.airTurnSliderKnob.BackgroundColor3 =
    Color3.fromRGB(
        205,
        205,
        205
    )
mainJump.airTurnSliderKnob.BorderSizePixel =
    0
mainJump.airTurnSliderKnob.Parent =
    mainJump.airTurnSliderTrack

__UI.airTurnSliderKnobCorner =
    Instance.new("UICorner")
__UI.airTurnSliderKnobCorner.CornerRadius =
    UDim.new(
        1,
        0
    )
__UI.airTurnSliderKnobCorner.Parent =
    mainJump.airTurnSliderKnob

mainJump.airTurnSpeedValue =
    Instance.new("TextLabel")
mainJump.airTurnSpeedValue.Size =
    UDim2.new(
        0,
        62,
        0,
        28
    )
mainJump.airTurnSpeedValue.Position =
    UDim2.new(
        1,
        -74,
        0.5,
        -14
    )
mainJump.airTurnSpeedValue.BackgroundTransparency =
    1
mainJump.airTurnSpeedValue.TextSize =
    10
mainJump.airTurnSpeedValue.Font =
    Enum.Font.GothamBold
mainJump.airTurnSpeedValue.TextColor3 =
    Color3.fromRGB(
        215,
        215,
        215
    )
mainJump.airTurnSpeedValue.TextXAlignment =
    Enum.TextXAlignment.Right
mainJump.airTurnSpeedValue.Parent =
    __UI.airTurnSpeedRow

local airTurnSliderDragging =
    false

local function updateAirTurnSliderFromX(x)
    if not mainJump.airTurnSliderTrack then
        return
    end

    local position =
        mainJump.airTurnSliderTrack.AbsolutePosition.X
    local size =
        mainJump.airTurnSliderTrack.AbsoluteSize.X

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
        AIR_TURN_MIN_SPEED
        + (
            AIR_TURN_MAX_SPEED
            - AIR_TURN_MIN_SPEED
        )
        * alpha

    mainJump.setAirTurnSpeed(
        value,
        false
    )
end

mainConnect(
    mainJump.airTurnSliderTrack.InputBegan:Connect(
        function(input)
            if input.UserInputType
                == Enum.UserInputType.MouseButton1
            then
                airTurnSliderDragging =
                    true

                updateAirTurnSliderFromX(
                    input.Position.X
                )
            end
        end
    )
)

mainConnect(
    UserInputService.InputChanged:Connect(
        function(input)
            if not airTurnSliderDragging then
                return
            end

            if input.UserInputType
                == Enum.UserInputType.MouseMovement
            then
                updateAirTurnSliderFromX(
                    input.Position.X
                )
            end
        end
    )
)

mainConnect(
    UserInputService.InputEnded:Connect(
        function(input)
            if input.UserInputType
                == Enum.UserInputType.MouseButton1
                and airTurnSliderDragging
            then
                airTurnSliderDragging =
                    false
                mainJump.saveConfig()
            end
        end
    )
)

__UI.crouchSpamRow =
    mainRow(
        "CROUCH SPAM",
        8
    )

local crouchSpamLabel =
    autoLabel:Clone()
crouchSpamLabel.Text =
    "CROUCH SPAM"
crouchSpamLabel.Parent =
    __UI.crouchSpamRow

mainJump.crouchSpamHotkeyBox =
    Instance.new("TextButton")
mainJump.crouchSpamHotkeyBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
mainJump.crouchSpamHotkeyBox.Position =
    UDim2.new(
        1,
        -235,
        0.5,
        -14
    )
mainJump.crouchSpamHotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.crouchSpamHotkeyBox.BorderSizePixel = 0
mainJump.crouchSpamHotkeyBox.Text =
    mainJump.crouchSpamHotkeyName
mainJump.crouchSpamHotkeyBox.TextSize = 10
mainJump.crouchSpamHotkeyBox.Font =
    Enum.Font.GothamBold
mainJump.crouchSpamHotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.crouchSpamHotkeyBox.Parent =
    __UI.crouchSpamRow

local crouchSpamHotkeyCorner =
    Instance.new("UICorner")
crouchSpamHotkeyCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
crouchSpamHotkeyCorner.Parent =
    mainJump.crouchSpamHotkeyBox

mainConnect(
    mainJump.crouchSpamHotkeyBox.MouseButton1Click:Connect(
        function()
            mainJump.startCapture(
                "crouchSpam"
            )
        end
    )
)

mainJump.crouchSpamDelayBox =
    Instance.new("TextBox")
mainJump.crouchSpamDelayBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
mainJump.crouchSpamDelayBox.Position =
    UDim2.new(
        1,
        -155,
        0.5,
        -14
    )
mainJump.crouchSpamDelayBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.crouchSpamDelayBox.BorderSizePixel = 0
mainJump.crouchSpamDelayBox.ClearTextOnFocus = false
mainJump.crouchSpamDelayBox.Text =
    tostring(
        mainJump.crouchSpamDelay
    )
mainJump.crouchSpamDelayBox.TextSize = 10
mainJump.crouchSpamDelayBox.Font =
    Enum.Font.GothamBold
mainJump.crouchSpamDelayBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.crouchSpamDelayBox.Parent =
    __UI.crouchSpamRow

local crouchSpamDelayCorner =
    Instance.new("UICorner")
crouchSpamDelayCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
crouchSpamDelayCorner.Parent =
    mainJump.crouchSpamDelayBox

mainConnect(
    mainJump.crouchSpamDelayBox.FocusLost:Connect(
        function(enterPressed)
            if enterPressed then
                mainJump.setCrouchSpamDelay(
                    mainJump.crouchSpamDelayBox.Text
                )
            else
                mainJump.crouchSpamDelayBox.Text =
                    tostring(
                        mainJump.crouchSpamDelay
                    )
            end
        end
    )
)

mainJump.crouchSpamToggle =
    Instance.new("TextButton")
mainJump.crouchSpamToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
mainJump.crouchSpamToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
mainJump.crouchSpamToggle.BackgroundColor3 =
    Color3.fromRGB(
        47,
        52,
        61
    )
mainJump.crouchSpamToggle.BorderSizePixel = 0
mainJump.crouchSpamToggle.TextSize = 10
mainJump.crouchSpamToggle.Font =
    Enum.Font.GothamBold
mainJump.crouchSpamToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.crouchSpamToggle.Parent =
    __UI.crouchSpamRow

__UI.crouchSpamToggleCorner =
    Instance.new("UICorner")
__UI.crouchSpamToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.crouchSpamToggleCorner.Parent =
    mainJump.crouchSpamToggle

mainConnect(
    mainJump.crouchSpamToggle.MouseButton1Click:Connect(
        function()
            mainJump.setCrouchSpamEnabled(
                not mainJump.crouchSpamEnabled
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
    mainRow(
        "REVERSE LOOK",
        9
    )

local reverseLookLabel =
    autoLabel:Clone()
reverseLookLabel.Text =
    "REVERSE LOOK"
reverseLookLabel.Parent =
    __UI.reverseLookRow

mainJump.reverseLookModeButton =
    Instance.new("TextButton")

mainJump.reverseLookModeButton.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )

mainJump.reverseLookModeButton.Position =
    UDim2.new(
        1,
        -155,
        0.5,
        -14
    )

mainJump.reverseLookModeButton.BackgroundColor3 =
    Color3.fromRGB(
        34,
        34,
        34
    )

mainJump.reverseLookModeButton.BorderSizePixel =
    0

mainJump.reverseLookModeButton.AutoButtonColor =
    false

mainJump.reverseLookModeButton.Text =
    ""

mainJump.reverseLookModeButton.Parent =
    __UI.reverseLookRow

local reverseLookModeCorner =
    Instance.new("UICorner")

reverseLookModeCorner.CornerRadius =
    UDim.new(
        0,
        5
    )

reverseLookModeCorner.Parent =
    mainJump.reverseLookModeButton

mainJump.reverseLookModeKnob =
    Instance.new("Frame")

mainJump.reverseLookModeKnob.Size =
    UDim2.new(
        0,
        34,
        0,
        24
    )

mainJump.reverseLookModeKnob.Position =
    UDim2.new(
        0,
        36,
        0.5,
        -12
    )

mainJump.reverseLookModeKnob.BackgroundColor3 =
    Color3.fromRGB(
        68,
        74,
        84
    )

mainJump.reverseLookModeKnob.BorderSizePixel =
    0

mainJump.reverseLookModeKnob.Active =
    false

mainJump.reverseLookModeKnob.Parent =
    mainJump.reverseLookModeButton

local reverseLookModeKnobCorner =
    Instance.new("UICorner")

reverseLookModeKnobCorner.CornerRadius =
    UDim.new(
        0,
        5
    )

reverseLookModeKnobCorner.Parent =
    mainJump.reverseLookModeKnob

mainJump.reverseLookModeWithLabel =
    Instance.new("TextLabel")

mainJump.reverseLookModeWithLabel.Size =
    UDim2.new(
        0,
        34,
        0,
        28
    )

mainJump.reverseLookModeWithLabel.Position =
    UDim2.new(
        0,
        2,
        0,
        0
    )

mainJump.reverseLookModeWithLabel.BackgroundTransparency =
    1

mainJump.reverseLookModeWithLabel.Text =
    "WITH"

mainJump.reverseLookModeWithLabel.TextSize =
    8

mainJump.reverseLookModeWithLabel.Font =
    Enum.Font.GothamBold

mainJump.reverseLookModeWithLabel.TextColor3 =
    Color3.fromRGB(
        145,
        145,
        145
    )

mainJump.reverseLookModeWithLabel.TextXAlignment =
    Enum.TextXAlignment.Center

mainJump.reverseLookModeWithLabel.Parent =
    mainJump.reverseLookModeButton

mainJump.reverseLookModeSoloLabel =
    Instance.new("TextLabel")

mainJump.reverseLookModeSoloLabel.Size =
    UDim2.new(
        0,
        34,
        0,
        28
    )

mainJump.reverseLookModeSoloLabel.Position =
    UDim2.new(
        0,
        37,
        0,
        0
    )

mainJump.reverseLookModeSoloLabel.BackgroundTransparency =
    1

mainJump.reverseLookModeSoloLabel.Text =
    "SOLO"

mainJump.reverseLookModeSoloLabel.TextSize =
    8

mainJump.reverseLookModeSoloLabel.Font =
    Enum.Font.GothamBold

mainJump.reverseLookModeSoloLabel.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

mainJump.reverseLookModeSoloLabel.TextXAlignment =
    Enum.TextXAlignment.Center

mainJump.reverseLookModeSoloLabel.Parent =
    mainJump.reverseLookModeButton

mainConnect(
    mainJump.reverseLookModeButton.MouseButton1Click:Connect(
        function()
            local newMode

            if mainJump.reverseLookMode
                == "with"
            then
                newMode =
                    "without"
            else
                newMode =
                    "with"
            end

            mainJump.setReverseLookMode(
                newMode
            )
        end
    )
)

--// Reverse Look standalone toggle.
mainJump.reverseLookToggle =
    Instance.new("TextButton")

mainJump.reverseLookToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )

mainJump.reverseLookToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )

mainJump.reverseLookToggle.BackgroundColor3 =
    Color3.fromRGB(
        47,
        52,
        61
    )

mainJump.reverseLookToggle.BorderSizePixel =
    0

mainJump.reverseLookToggle.TextSize =
    10

mainJump.reverseLookToggle.Font =
    Enum.Font.GothamBold

mainJump.reverseLookToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

mainJump.reverseLookToggle.AutoButtonColor =
    false

mainJump.reverseLookToggle.Parent =
    __UI.reverseLookRow

local reverseLookToggleCorner =
    Instance.new("UICorner")

reverseLookToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )

reverseLookToggleCorner.Parent =
    mainJump.reverseLookToggle

mainConnect(
    mainJump.reverseLookToggle.MouseButton1Click:Connect(
        function()
            if mainJump.reverseLookMode
                ~= "without"
            then
                return
            end

            mainJump.setReverseLookEnabled(
                not mainJump.reverseLookEnabled
            )
        end
    )
)

mainJump.updateReverseLookUI(
    false
)

__UI.benchTrimpRow =
    mainRow(
        "BENCH TRIMP",
        10
    )

local benchTrimpLabel =
    autoLabel:Clone()
benchTrimpLabel.Text =
    "BENCH TRIMP"
benchTrimpLabel.Parent =
    __UI.benchTrimpRow

mainJump.benchTrimpHotkeyBox =
    Instance.new("TextButton")
mainJump.benchTrimpHotkeyBox.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
mainJump.benchTrimpHotkeyBox.Position =
    UDim2.new(
        1,
        -155,
        0.5,
        -14
    )
mainJump.benchTrimpHotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.benchTrimpHotkeyBox.BorderSizePixel = 0
mainJump.benchTrimpHotkeyBox.Text =
    mainJump.benchTrimpHotkeyName
mainJump.benchTrimpHotkeyBox.TextSize = 10
mainJump.benchTrimpHotkeyBox.Font =
    Enum.Font.GothamBold
mainJump.benchTrimpHotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.benchTrimpHotkeyBox.Parent =
    __UI.benchTrimpRow

local benchTrimpHotkeyCorner =
    Instance.new("UICorner")
benchTrimpHotkeyCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
benchTrimpHotkeyCorner.Parent =
    mainJump.benchTrimpHotkeyBox

mainConnect(
    mainJump.benchTrimpHotkeyBox.MouseButton1Click:Connect(
        function()
            mainJump.startCapture(
                "benchTrimp"
            )
        end
    )
)

mainJump.benchTrimpToggle =
    Instance.new("TextButton")
mainJump.benchTrimpToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
mainJump.benchTrimpToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
mainJump.benchTrimpToggle.BackgroundColor3 =
    Color3.fromRGB(
        47,
        52,
        61
    )
mainJump.benchTrimpToggle.BorderSizePixel = 0
mainJump.benchTrimpToggle.TextSize = 10
mainJump.benchTrimpToggle.Font =
    Enum.Font.GothamBold
mainJump.benchTrimpToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.benchTrimpToggle.Parent =
    __UI.benchTrimpRow

local benchTrimpToggleCorner =
    Instance.new("UICorner")
benchTrimpToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
benchTrimpToggleCorner.Parent =
    mainJump.benchTrimpToggle

mainConnect(
    mainJump.benchTrimpToggle.MouseButton1Click:Connect(
        function()
            mainJump.setBenchTrimpEnabled(
                not mainJump.benchTrimpEnabled
            )
        end
    )
)


--// HIDE UI MUST ALWAYS BE THE LOWEST / LAST ROW IN MAIN.
__UI.hideRow =
    mainRow(
        "HIDE UI",
        11
    )
__UI.hideLabel =
    autoLabel:Clone()
__UI.hideLabel.Text =
    "HIDE UI"
__UI.hideLabel.Parent =
    __UI.hideRow
mainJump.hideUIHotkeyBox =
    Instance.new("TextButton")
mainJump.hideUIHotkeyBox.Size =
    UDim2.new(
        1,
        -120,
        0,
        28
    )
mainJump.hideUIHotkeyBox.Position =
    UDim2.new(
        0,
        105,
        0.5,
        -14
    )
mainJump.hideUIHotkeyBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
mainJump.hideUIHotkeyBox.BorderSizePixel = 0
mainJump.hideUIHotkeyBox.Text =
    mainJump.hideUIHotkeyName
mainJump.hideUIHotkeyBox.TextSize = 11
mainJump.hideUIHotkeyBox.Font =
            Enum.Font.GothamBold
mainJump.hideUIHotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.hideUIHotkeyBox.Parent =
    __UI.hideRow
__UI.hideCorner =
    Instance.new("UICorner")
__UI.hideCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
__UI.hideCorner.Parent =
    mainJump.hideUIHotkeyBox
mainConnect(
    mainJump.hideUIHotkeyBox.MouseButton1Click:Connect(
        function()
            mainJump.startCapture(
                "hide"
            )
        end
    )
)

mainConnect(
    UserInputService.InputBegan:Connect(
        function(input)
            if mainJump.capturing then
                local keyCode =
                    input.KeyCode
                if not keyCode
                    or keyCode
                        == Enum.KeyCode.Unknown
                then
                    return
                end
                if mainJump.capturing
                    == "jump"
                then
                    mainJump.setHotkey(
                        keyCode.Name
                    )
                elseif mainJump.capturing
                    == "hide"
                then
                    mainJump.setHideUIHotkey(
                        keyCode.Name
                    )
                elseif mainJump.capturing
                    == "airTurn"
                then
                    mainJump.setAirTurnHotkey(
                        keyCode.Name
                    )
                elseif mainJump.capturing
                    == "crouchSpam"
                then
                    mainJump.setCrouchSpamHotkey(
                        keyCode.Name
                    )
                elseif mainJump.capturing
                    == "benchTrimp"
                then
                    mainJump.setBenchTrimpHotkey(
                        keyCode.Name
                    )
                end
                return
            end

            if input.KeyCode
                == mainFindKeyCode(
                    mainJump.hotkeyName
                )
            then
                mainJump.setEnabled(
                    not mainJump.enabled
                )
            end
            if input.KeyCode
                == mainFindKeyCode(
                    mainJump.hideUIHotkeyName
                )
            then
                ScreenGui.Enabled =
                    not ScreenGui.Enabled
            end

            if input.KeyCode
                == mainFindKeyCode(
                    mainJump.airTurnHotkeyName
                )
            then
                mainJump.setAirTurnEnabled(
                    not mainJump.airTurnEnabled
                )
            end

            if input.KeyCode
                == mainFindKeyCode(
                    mainJump.crouchSpamHotkeyName
                )
            then
                mainJump.setCrouchSpamEnabled(
                    not mainJump.crouchSpamEnabled
                )
            end

            if input.KeyCode
                == mainFindKeyCode(
                    mainJump.benchTrimpHotkeyName
                )
            then
                mainJump.setBenchTrimpEnabled(
                    not mainJump.benchTrimpEnabled
                )
            end
        end
    )
)
mainConnect(
    UserInputService.JumpRequest:Connect(
        function()
            if mainJump.enabled
                and mainJump.humanoid
                and mainJump.humanoid.Parent
            then
                mainJump.manualJumpActive = true
                mainJump.lookAutoJumpCycle = false
                mainJump.lookTriggeredThisAir = true

                if mainJump.lookActive then
                    mainJump.endLook()
                end
            end
        end
    )
)
mainConnect(
    UserInputService.JumpRequest:Connect(
        function()
            if mainJump.enabled
                or not genv.DEADEYE_MAIN_RUNNING
                or not mainJump.needsInputRearm
                or not mainJump.humanoid
                or not mainJump.humanoid.Parent
            then
                return
            end

            local humanoid =
                mainJump.humanoid

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
            mainJump.needsInputRearm = false

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
                    or mainJump.enabled
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
mainConnect(
    UserInputService.InputEnded:Connect(
        function(input)
            if input.KeyCode
                == Enum.KeyCode.Space
                and not mainJump.enabled
                and mainJump.humanoid
                and mainJump.humanoid.Parent
            then
                pcall(function()
                    mainJump.humanoid.Jump = false
                end)
            end
        end
    )
)
mainConnect(
    LocalPlayer.CharacterAdded:Connect(
        function(char)
            task.wait(0.2)

            mainJump.crouchSpamMovement =
                nil

            if genv.DEADEYE_MAIN_RUNNING then
                mainJump.setupAutoJumpCharacter(
                    char
                )
                mainJump.bindBenchTrimp(
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

            mainJump.setupAutoJumpCharacter(
                LocalPlayer.Character
            )

            mainJump.bindBenchTrimp(
                LocalPlayer.Character
            )
        end
    )
end
pcall(function()
    mainJump.installReverseLookHooks()
end)

mainJump.setAirTurnSpeed(
    mainJump.airTurnSpeed,
    false
)
mainJump.setCrouchSpamDelay(
    mainJump.crouchSpamDelay
)

if mainJump.benchTrimpEnabled then
    pcall(function()
        mainJump.bindBenchTrimp(
            mainJump.character
            or LocalPlayer.Character
        )
    end)
end

mainJump.update()

if mainJump.rageLookEnabled then
    mainJump.rageLookEnabled =
        false

    mainJump.setRageLookEnabled(
        true,
        true
    )
end

if mainJump.airTurnEnabled
    and mainJump.enabled
then
    mainJump.findLookMovementState()
    mainJump.bindAirTurnRender()
end

genv.DEADEYE_MAIN_AIR_TURN_CLEANUP =
    function()
        pcall(function()
            mainJump.unbindAirTurnRender()
        end)
    end

genv.DEADEYE_REVERSE_LOOK =
    function(state)
        mainJump.setReverseLookEnabled(
            state
        )
    end

genv.DEADEYE_REVERSE_LOOK_CLEANUP =
    function()
        pcall(function()
            mainJump.setReverseLookEnabled(
                false,
                false
            )
        end)

        pcall(function()
            mainJump.uninstallReverseLookHooks()
        end)
    end

genv.DEADEYE_RAGE_LOOK =
    function(state)
        mainJump.setRageLookEnabled(
            state
        )
    end

genv.DEADEYE_RAGE_LOOK_CLEANUP =
    function()
        pcall(function()
            mainJump.setRageLookEnabled(
                false,
                false
            )
        end)
    end

genv.DEADEYE_MAIN_SENSORS_CLEANUP =
    function()
        pcall(function()
            mainJump.destroySensors()
        end)

        purgeStaleMainJumpSensors()
    end
--// =========================================================
--// OTHERS PAGE
--// =========================================================
others.page =
    Instance.new("ScrollingFrame")
others.page.Name =
    "OthersPage"
others.page.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
others.page.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
others.page.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
others.page.BorderSizePixel =
    0
others.page.ScrollBarThickness =
    6
others.page.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
others.page.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
others.page.ScrollingDirection =
    Enum.ScrollingDirection.Y
others.page.Visible =
    false
others.page.Parent =
    Main
others.pageCorner =
    Instance.new("UICorner")
others.pageCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
others.pageCorner.Parent =
    others.page
others.padding =
    Instance.new("UIPadding")
others.padding.PaddingTop =
    UDim.new(
        0,
        8
    )
others.padding.PaddingBottom =
    UDim.new(
        0,
        8
    )
others.padding.PaddingLeft =
    UDim.new(
        0,
        8
    )
others.padding.PaddingRight =
    UDim.new(
        0,
        8
    )
others.padding.Parent =
    others.page
others.layout =
    Instance.new("UIListLayout")
others.layout.Padding =
    UDim.new(
        0,
        6
    )
others.layout.SortOrder =
    Enum.SortOrder.LayoutOrder
others.layout.Parent =
    others.page
function others.header(
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
        others.page
end
function others.row(
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
        others.page
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
    others.fieldBoxes[
        slot.property
    ] =
        box
    UnusualFns.addUnusualConnection(
        apply.MouseButton1Click:Connect(
            function()
                if others.applyField(
                    slot,
                    box.Text
                ) then
                    others.saveConfig()
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
    UnusualFns.addUnusualConnection(
        box.FocusLost:Connect(
            function(enterPressed)
                if enterPressed then
                    others.applyField(
                        slot,
                        box.Text
                    )
                end
                --// Persist the current Others field even when the
                --// user only edits it and closes/unfocuses the GUI.
                others.saveConfig()
            end
        )
    )
end
function others.quickRow(
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
        others.page
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
    UnusualFns.addUnusualConnection(
        apply.MouseButton1Click:Connect(
            function()
                if others.applyBodyPart(
                    property,
                    assetId
                ) then
                    if property == "Head" then
                        savedConfig.others._Headless =
                            tostring(
                                assetId
                            )
                    elseif property == "RightLeg" then
                        savedConfig.others._Korblox =
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
function others.applyBodyPart(
    property,
    assetId
)
    local description =
        others.getDescription()
    if not description then
        return false
    end
    pcall(function()
        description[property] =
            assetId
    end)
    return others.applyDescription(
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
function others.avatarImportVector3(value)
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

function others.avatarImportColor3(value)
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

function others.avatarImportAccessoryType(name)
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

function others.parseAvatarDump(raw)
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
            return HttpService:JSONDecode(raw)
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
        others.getDescription()

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
                    others.avatarImportColor3(
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
                    others.avatarImportAccessoryType(
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
                        others.avatarImportVector3(
                            source.Position
                        )

                    local rotation =
                        others.avatarImportVector3(
                            source.Rotation
                        )

                    local scale =
                        others.avatarImportVector3(
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

function others.applyAvatarDump(raw)
    local description, data =
        others.parseAvatarDump(raw)

    if not description then
        if others.status then
            others.status.Text =
                "Import failed"
        end
        return false
    end

    local ok =
        others.applyDescription(
            description
        )

    if not ok then
        return false
    end

    others.importedDescription =
        description:Clone()

    if others.status then
        local version =
            tostring(
                data.version or "?"
            )

        others.status.Text =
            "Avatar imported • v"
            .. version
    end

    return true
end

function others.applyAll()
    local description =
        others.getDescription()
    if not description then
        return false
    end
    local groups = {
        others.ACCESSORY_SLOTS,
        others.CLOTHING_SLOTS,
        others.BODY_SLOTS
    }
    local changed = 0
    for _, group in ipairs(
        groups
    ) do
        for _, slot in ipairs(
            group
        ) do
            local box =
                others.fieldBoxes[
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
    return others.applyDescription(
        description
    )
end
others.applyAllRow =
    Instance.new("Frame")
others.applyAllRow.Size =
    UDim2.new(
        1,
        -4,
        0,
        42
    )
others.applyAllRow.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
others.applyAllRow.BorderSizePixel =
    0
others.applyAllRow.LayoutOrder =
    0
others.applyAllRow.Parent =
    others.page
others.applyAllCorner =
    Instance.new("UICorner")
others.applyAllCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
others.applyAllCorner.Parent =
    others.applyAllRow
others.applyAllButton =
    Instance.new("TextButton")
others.applyAllButton.Size =
    UDim2.new(
        1,
        -12,
        0,
        30
    )
others.applyAllButton.Position =
    UDim2.new(
        0,
        6,
        0.5,
        -15
    )
others.applyAllButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
others.applyAllButton.BorderSizePixel =
    0
others.applyAllButton.Text =
    "APPLY ALL"
others.applyAllButton.TextSize =
    10
others.applyAllButton.Font =
    Enum.Font.GothamBold
others.applyAllButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
others.applyAllButton.Parent =
    others.applyAllRow
others.applyAllButtonCorner =
    Instance.new("UICorner")
others.applyAllButtonCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
others.applyAllButtonCorner.Parent =
    others.applyAllButton
UnusualFns.addUnusualConnection(
    others.applyAllButton.MouseButton1Click:Connect(
        function()
            if others.applyAll() then
                others.saveConfig()
                others.applyAllButton.Text =
                    "APPLIED"
                task.delay(
                    0.8,
                    function()
                        pcall(function()
                            if others.applyAllButton.Parent then
                                others.applyAllButton.Text =
                                    "APPLY ALL"
                            end
                        end)
                    end
                )
            end
        end
    )
)
others.header(
    "QUICK BODY",
    1
)
others.quickRow(
    "HEADLESS",
    "Head",
    others.HEADLESS_ID,
    2
)
others.quickRow(
    "KORBLOX",
    "RightLeg",
    others.KORBLOX_ID,
    3
)
others.header(
    "ACCESSORIES",
    4
)
local nextOrder =
    5
for _, slot in ipairs(
    others.ACCESSORY_SLOTS
) do
    others.row(
        slot,
        nextOrder
    )
    nextOrder += 1
end
others.header(
    "2D CLOTHING",
    nextOrder
)
nextOrder += 1
for _, slot in ipairs(
    others.CLOTHING_SLOTS
) do
    others.row(
        slot,
        nextOrder
    )
    nextOrder += 1
end
others.header(
    "BODY BUNDLES",
    nextOrder
)
nextOrder += 1
for _, slot in ipairs(
    others.BODY_SLOTS
) do
    others.row(
        slot,
        nextOrder
    )
    nextOrder += 1
end
--// =========================================================
--// FULL SCAN / CLEAR / RESET
--// =========================================================
others.scanRow =
    Instance.new("Frame")
others.scanRow.Size =
    UDim2.new(
        1,
        -4,
        0,
        40
    )
others.scanRow.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
others.scanRow.BorderSizePixel =
    0
others.scanRow.LayoutOrder =
    nextOrder + 1
others.scanRow.Parent =
    others.page
others.scanButton =
    Instance.new("TextButton")
others.scanButton.Size =
    UDim2.new(
        0,
        100,
        0,
        28
    )
others.scanButton.Position =
    UDim2.new(
        0,
        8,
        0.5,
        -14
    )
others.scanButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
others.scanButton.BorderSizePixel =
    0
others.scanButton.Text =
    "FULL SCAN"
others.scanButton.TextSize =
    9
others.scanButton.Font =
    Enum.Font.GothamBold
others.scanButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
others.scanButton.Parent =
    others.scanRow
others.scanButtonCorner =
    Instance.new("UICorner")
others.scanButtonCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
others.scanButtonCorner.Parent =
    others.scanButton
others.status =
    Instance.new("TextLabel")
others.status.Size =
    UDim2.new(
        1,
        -122,
        1,
        0
    )
others.status.Position =
    UDim2.new(
        0,
        118,
        0,
        0
    )
others.status.BackgroundTransparency =
    1
others.status.Text =
    "Click FULL SCAN"
others.status.TextSize =
    10
others.status.Font =
    Enum.Font.Gotham
others.status.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
others.status.TextXAlignment =
    Enum.TextXAlignment.Left
others.status.Parent =
    others.scanRow
others.header(
    "TOOLS",
    nextOrder + 2
)
others.toolsFrame =
    Instance.new("Frame")
others.toolsFrame.Size =
    UDim2.new(
        1,
        -4,
        0,
        80
    )
others.toolsFrame.BackgroundTransparency =
    1
others.toolsFrame.LayoutOrder =
    nextOrder + 3
others.toolsFrame.Parent =
    others.page
others.clearButton =
    Instance.new("TextButton")
others.clearButton.Size =
    UDim2.new(
        1,
        0,
        0,
        34
    )
others.clearButton.Position =
    UDim2.new(
        0,
        0,
        0,
        0
    )
others.clearButton.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
others.clearButton.BorderSizePixel =
    0
others.clearButton.Text =
    "REMOVE EVERYTHING EXCEPT 2D CLOTHES + BODY"
others.clearButton.TextSize =
    9
others.clearButton.Font =
    Enum.Font.GothamBold
others.clearButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
others.clearButton.Parent =
    others.toolsFrame
others.clearCorner =
    Instance.new("UICorner")
others.clearCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
others.clearCorner.Parent =
    others.clearButton
others.resetButton =
    Instance.new("TextButton")
others.resetButton.Size =
    UDim2.new(
        1,
        0,
        0,
        34
    )
others.resetButton.Position =
    UDim2.new(
        0,
        0,
        0,
        40
    )
others.resetButton.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
others.resetButton.BorderSizePixel =
    0
others.resetButton.Text =
    "RESET TO INITIAL AVATAR"
others.resetButton.TextSize =
    9
others.resetButton.Font =
    Enum.Font.GothamBold
others.resetButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
others.resetButton.Parent =
    others.toolsFrame
--// =========================================================
--// AVATAR IMPORT UI
--// =========================================================
others.avatarImportHeader =
    Instance.new("TextLabel")
others.avatarImportHeader.Size =
    UDim2.new(
        1,
        -4,
        0,
        24
    )
others.avatarImportHeader.BackgroundTransparency =
    1
others.avatarImportHeader.Text =
    "AVATAR IMPORT"
others.avatarImportHeader.TextSize =
    10
others.avatarImportHeader.Font =
    Enum.Font.GothamBold
others.avatarImportHeader.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
others.avatarImportHeader.TextXAlignment =
    Enum.TextXAlignment.Left
others.avatarImportHeader.LayoutOrder =
    nextOrder + 4
others.avatarImportHeader.Parent =
    others.page

others.avatarImportFrame =
    Instance.new("Frame")
others.avatarImportFrame.Size =
    UDim2.new(
        1,
        -4,
        0,
        118
    )
others.avatarImportFrame.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
others.avatarImportFrame.BorderSizePixel =
    0
others.avatarImportFrame.LayoutOrder =
    nextOrder + 5
others.avatarImportFrame.Parent =
    others.page

local avatarImportCorner =
    Instance.new("UICorner")
avatarImportCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
avatarImportCorner.Parent =
    others.avatarImportFrame

others.avatarImportBox =
    Instance.new("TextBox")
others.avatarImportBox.Size =
    UDim2.new(
        1,
        -92,
        0,
        72
    )
others.avatarImportBox.Position =
    UDim2.new(
        0,
        8,
        0,
        8
    )
others.avatarImportBox.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
others.avatarImportBox.BorderSizePixel =
    0
others.avatarImportBox.ClearTextOnFocus =
    false
others.avatarImportBox.MultiLine =
    true
others.avatarImportBox.TextWrapped =
    false
others.avatarImportBox.PlaceholderText =
    "Paste avatar JSON here"
others.avatarImportBox.TextSize =
    10
others.avatarImportBox.Font =
    Enum.Font.Code
others.avatarImportBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
others.avatarImportBox.PlaceholderColor3 =
    Color3.fromRGB(
        105,
        105,
        105
    )
others.avatarImportBox.TextXAlignment =
    Enum.TextXAlignment.Left
others.avatarImportBox.TextYAlignment =
    Enum.TextYAlignment.Top
others.avatarImportBox.Parent =
    others.avatarImportFrame

local avatarImportBoxCorner =
    Instance.new("UICorner")
avatarImportBoxCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
avatarImportBoxCorner.Parent =
    others.avatarImportBox

others.avatarImportButton =
    Instance.new("TextButton")
others.avatarImportButton.Size =
    UDim2.new(
        0,
        72,
        0,
        28
    )
others.avatarImportButton.Position =
    UDim2.new(
        1,
        -80,
        0,
        30
    )
others.avatarImportButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
others.avatarImportButton.BorderSizePixel =
    0
others.avatarImportButton.Text =
    "IMPORT"
others.avatarImportButton.TextSize =
    9
others.avatarImportButton.Font =
    Enum.Font.GothamBold
others.avatarImportButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
others.avatarImportButton.Parent =
    others.avatarImportFrame

local avatarImportButtonCorner =
    Instance.new("UICorner")
avatarImportButtonCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
avatarImportButtonCorner.Parent =
    others.avatarImportButton

others.avatarImportClear =
    Instance.new("TextButton")
others.avatarImportClear.Size =
    UDim2.new(
        0,
        72,
        0,
        24
    )
others.avatarImportClear.Position =
    UDim2.new(
        1,
        -80,
        0,
        62
    )
others.avatarImportClear.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
others.avatarImportClear.BorderSizePixel =
    0
others.avatarImportClear.Text =
    "CLEAR"
others.avatarImportClear.TextSize =
    8
others.avatarImportClear.Font =
    Enum.Font.GothamBold
others.avatarImportClear.TextColor3 =
    Color3.fromRGB(
        215,
        215,
        215
    )
others.avatarImportClear.Parent =
    others.avatarImportFrame

local avatarImportClearCorner =
    Instance.new("UICorner")
avatarImportClearCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
avatarImportClearCorner.Parent =
    others.avatarImportClear

UnusualFns.addUnusualConnection(
    others.avatarImportButton.MouseButton1Click:Connect(
        function()
            local imported =
                others.applyAvatarDump(
                    others.avatarImportBox.Text
                )

            if imported then
                others.avatarImportButton.Text =
                    "APPLIED"
            else
                others.avatarImportButton.Text =
                    "ERROR"
            end

            task.delay(
                0.8,
                function()
                    pcall(function()
                        if others.avatarImportButton.Parent then
                            others.avatarImportButton.Text =
                                "IMPORT"
                        end
                    end)
                end
            )
        end
    )
)

UnusualFns.addUnusualConnection(
    others.avatarImportClear.MouseButton1Click:Connect(
        function()
            others.avatarImportBox.Text =
                ""
        end
    )
)
others.resetCorner =
    Instance.new("UICorner")
others.resetCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
others.resetCorner.Parent =
    others.resetButton
UnusualFns.addUnusualConnection(
    others.scanButton.MouseButton1Click:Connect(
        function()
            others.scan()
        end
    )
)
UnusualFns.addUnusualConnection(
    others.clearButton.MouseButton1Click:Connect(
        function()
            if others.clearAccessories() then
                task.delay(
                    0.3,
                    function()
                        others.saveConfig()
                    end
                )
            end
        end
    )
)
UnusualFns.addUnusualConnection(
    others.resetButton.MouseButton1Click:Connect(
        function()
            others.ensureSnapshot()
            if others.restore(true) then
                others.scan()
            end
        end
    )
)
task.defer(
    function()
        pcall(function()
            others.loadConfig()
            if others.avatarImportBox then
                others.avatarImportBox.Text =
                    tostring(
                        savedConfig.others._AvatarImport
                        or ""
                    )
            end
        end)
    end
)
--// CATEGORY BAR
-- =========================================================
categoryBar =
    Instance.new("Frame")
categoryBar.Name =
    "CategoryBar"
categoryBar.Size =
    UDim2.new(
        0,
        66,
        1,
        -56
    )
categoryBar.Position =
    UDim2.new(
        0,
        8,
        0,
        48
    )
categoryBar.BackgroundColor3 =
    Color3.fromRGB(
        26,
        30,
        36
    )
categoryBar.BorderSizePixel =
    0
categoryBar.Parent =
    Main

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
    categoryBar

__UI.categoryStroke =
    Instance.new("UIStroke")
__UI.categoryStroke.Thickness =
    1
__UI.categoryStroke.Transparency =
    0.55
__UI.categoryStroke.Parent =
    categoryBar

__UI.categoryCorner =
    Instance.new("UICorner")
__UI.categoryCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
__UI.categoryCorner.Parent =
    categoryBar
local function makeCategoryButton(
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
        categoryBar
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
mainCategoryButton =
    makeCategoryButton(
        "MAIN",
        6
    )
emoteCategoryButton =
    makeCategoryButton(
        "EMOTES",
        41
    )
unusualCategoryButton =
    makeCategoryButton(
        "UNUSUAL",
        76
    )
othersCategoryButton =
    makeCategoryButton(
        "OTHERS",
        111
    )
cosmetic.categoryButton =
    makeCategoryButton(
        "COSMETIC",
        146
    )
--// =========================================================
--// CATEGORY SWITCH
--// =========================================================
local function setCategory(
    category
)
    currentCategory =
        category

    pcall(function()
        if category == "Main" then
            MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION
            Status.Visible = false
            Toggle.Visible = false
            SlotsScroll.Visible = false
            mainPage.Visible = true
            unusualPage.Visible = false
            unusualStatus.Visible = false
            unusualPicker.Visible = false
            others.page.Visible = false
            cosmetic.page.Visible = false
            mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(65, 65, 65)
            emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            cosmetic.categoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)

        elseif category == "Unusual" then
            MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION
            Status.Visible = false
            Toggle.Visible = true
            Toggle.Parent = unusualPage
            Toggle.LayoutOrder = 0
            SlotsScroll.Visible = false
            mainPage.Visible = false
            unusualPage.Visible = true
            unusualStatus.Visible = false
            unusualPicker.Visible = false
            others.page.Visible = false
            cosmetic.page.Visible = false
            mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(65, 65, 65)
            othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            cosmetic.categoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            updateUnusualToggle()

        elseif category == "Others" then
            MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION
            Status.Visible = false
            Toggle.Visible = false
            SlotsScroll.Visible = false
            unusualPage.Visible = false
            unusualStatus.Visible = false
            mainPage.Visible = false
            unusualPicker.Visible = false
            others.page.Visible = true
            cosmetic.page.Visible = false
            mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(65, 65, 65)
            cosmetic.categoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)

        elseif category == "Cosmetic" then
            MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION
            Status.Visible = false
            Toggle.Visible = true
            Toggle.Parent = cosmetic.page
            Toggle.LayoutOrder = 0
            SlotsScroll.Visible = false
            mainPage.Visible = false
            unusualPage.Visible = false
            unusualStatus.Visible = false
            unusualPicker.Visible = false
            others.page.Visible = false
            cosmetic.page.Visible = true
            mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            cosmetic.categoryButton.BackgroundColor3 =
                Color3.fromRGB(65, 65, 65)
            cosmetic.updateToggle()

        else
            MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION
            Status.Visible = false
            Toggle.Visible = true
            Toggle.Parent = SlotsScroll
            Toggle.LayoutOrder = 0
            SlotsScroll.Visible = true
            mainPage.Visible = false
            unusualPage.Visible = false
            unusualStatus.Visible = false
            unusualPicker.Visible = false
            others.page.Visible = false
            cosmetic.page.Visible = false
            mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            cosmetic.categoryButton.BackgroundColor3 =
                Color3.fromRGB(45, 45, 45)
            emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(65, 65, 65)
            updateGUI()
        end
    end)
end

UnusualFns.addUnusualConnection(
    mainCategoryButton.MouseButton1Click:Connect(
        function()
            if mainMinimized then
                setMainMinimized(false)
            end
            setCategory(
                "Main"
            )
        end
    )
)
UnusualFns.addUnusualConnection(
    emoteCategoryButton.MouseButton1Click:Connect(
        function()
            if mainMinimized then
                setMainMinimized(false)
            end
            setCategory(
                "Emotes"
            )
        end
    )
)
UnusualFns.addUnusualConnection(    unusualCategoryButton.MouseButton1Click:Connect(
        function()
            if mainMinimized then
                setMainMinimized(false)
            end
            setCategory(
                "Unusual"
            )
        end
    )
)
UnusualFns.addUnusualConnection(
    othersCategoryButton.MouseButton1Click:Connect(
        function()
            if mainMinimized then
                setMainMinimized(false)
            end
            setCategory(
                "Others"
            )
        end
    )
)
UnusualFns.addUnusualConnection(
    cosmetic.categoryButton.MouseButton1Click:Connect(
        function()
            if mainMinimized then
                setMainMinimized(false)
            end
            setCategory(
                "Cosmetic"
            )
        end
    )
)
--// =========================================================
--// EXTERNAL CLEANUP
--// =========================================================
local function cleanupUnusual()
    if unusualDestroyed then
        return
    end
    unusualDestroyed =
        true

    --// originalId is the configured swap source, not necessarily
    --// the effect the player currently has equipped.
    local runtimeCurrentEquippedId =
        tonumber(
            UnusualFns.getEquippedUnusualId()
        )

    unusualRuntime.currentEquippedId =
        runtimeCurrentEquippedId

    local runtimeOriginalId =
        tonumber(
            unusualRuntime.originalId
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
        unusualActive
        or runtimeOriginalId

    local runtimeSnapshot =
        unusualRuntime.nativeSnapshot

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
        unusualRuntime.appliedRig

    --// Invalidate reapply work BEFORE restoring the live effect.
    unusualEnabled =
        false
    genv.UNUSUAL_SWAPPER_ENABLED =
        false
    unusualRuntime.reapplyGeneration += 1

    --// Wait for a reapply already inside activation so it cannot write
    --// the replacement after cleanup has restored the native effect.
    local reapplyDeadline =
        tick() + 1

    while unusualReapplyBusy
        and tick() < reapplyDeadline
    do
        task.wait()
    end

    local currentVisualRig =
        UnusualFns.getUnusualVisualRig()

    local currentPlayerCharacter =
        UnusualFns.getUnusualPlayerCharacter()

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
        if unusualRuntime.appliedRig == currentVisualRig
            and unusualRuntime.nativeSnapshot
        then
            runtimeSnapshot =
                unusualRuntime.nativeSnapshot
            runtimeSnapshotRig =
                currentVisualRig
        elseif runtimeSnapshotRig
            ~= currentVisualRig
        then
            local freshSnapshot =
                UnusualFns.captureNativeUnusualSnapshot(
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
                UnusualFns.getUnusualVisualRig()
            local playerCharacter =
                UnusualFns.getUnusualPlayerCharacter()

            if visualRig then
                UnusualFns.removeOurUnusualFX()
                task.wait()

                if runtimeCurrentEquippedId
                    and runtimeOriginalId
                    and tonumber(runtimeCurrentEquippedId)
                        ~= tonumber(runtimeOriginalId)
                then
                    --// Player changed the equipped Unusual.
                    --// Keep the game's current native effect; remove only
                    --// the FX owned by DeadEye.
                    UnusualFns.removeOurUnusualFX()
                    pcall(function()
                        UnusualFns.removeOriginalUnusualFX(
                            runtimeOriginalId,
                            visualRig,
                            playerCharacter
                        )
                    end)
                elseif runtimeSnapshot
                    and runtimeSnapshotRig == visualRig
                then
                    UnusualFns.restoreNativeUnusualSnapshot(
                        runtimeSnapshot,
                        visualRig,
                        playerCharacter
                    )
                else
                    UnusualFns.removeOriginalUnusualFX(
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

    unusualActive =
        false

    pcall(function()
        others.restore(false)
    end)

    pcall(function()
        cosmetic.cleanup()
    end)

    --// Do not rebuild the native Unusual here.
    --// The game's AddCosmetics(CharacterClassic) path can receive a
    --// cosmetic rig that does not contain the expected HumanoidRootPart
    --// limb and produces repeated shutdown errors.
    --// The active/native snapshot is already handled above. Cleanup
    --// must not call AddCosmetics again.

    unusualRuntime.originalId =
        nil
    unusualRuntime.currentEquippedId =
        runtimeRestoreId
    unusualRuntime.replacementId =
        nil
    unusualRuntime.nativeSnapshot =
        nil

    genv.DEADEYE_COSMETIC_CLEANUP =
        nil
    unusualEnabled =
        false
    unusualActive =
        false
    unusualRuntime.reapplyGeneration += 1
    unusualRuntime.appliedRig = nil
    genv.UNUSUAL_SWAPPER_ENABLED =
        false
    UnusualFns.disconnectUnusualConnections()
    if not preserveFinalRestoredUnusualFX then
        pcall(function()
            UnusualFns.removeOurUnusualFX()
        end)
    end
    genv.DEADEYE_MAIN_RUNNING = false
    pcall(function()
        if mainPage then
            mainPage.Visible = false
        end
        mainDisconnect()
        if unusualPicker then
            unusualPicker:Destroy()
        end
        if unusualPage then
            unusualPage:Destroy()
        end
        if others.page then
            others.page:Destroy()
        end
        if unusualStatus then
            unusualStatus:Destroy()
        end
        if categoryBar then
            categoryBar:Destroy()
        end
    end)
    genv.UNUSUAL_SWAPPER_CLEANUP =
        nil
    end
genv.UNUSUAL_SWAPPER_CLEANUP =
    cleanupUnusual
--// =========================================================
--// REPLACE EXISTING TOGGLE BEHAVIOUR
--// =========================================================
--// =========================================================
--// TOGGLE
--// =========================================================
Toggle =
    Instance.new("TextButton")
Toggle.Size =
    UDim2.new(
        1,
        -12,
        0,
        36
    )
Toggle.Position =
    UDim2.new(
        0,
        0,
        0,
        0
    )
Toggle.LayoutOrder =
    0
Toggle.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
Toggle.BorderSizePixel =
    0
Toggle.Text =
    "SWAP: OFF"
Toggle.TextSize =
    11
Toggle.Font =
    Enum.Font.GothamBold
Toggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
Toggle.Parent =
    SlotsScroll
__UI.ToggleCorner =
    Instance.new("UICorner")
__UI.ToggleCorner.CornerRadius =
    UDim.new(
        0,
        8
    )
__UI.ToggleCorner.Parent =
    Toggle
--// =========================================================
--// SLOTS SCROLL
--// =========================================================
SlotsScroll =
    Instance.new("ScrollingFrame")
SlotsScroll.Name =
    "Slots"
SlotsScroll.Size =
    UDim2.new(
        1,
        -16,
        1,
        -76
    )
SlotsScroll.Position =
    UDim2.new(
        0,
        8,
        0,
        68
    )
SlotsScroll.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
SlotsScroll.BorderSizePixel =
    0
SlotsScroll.ScrollBarThickness =
    6
SlotsScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
SlotsScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
SlotsScroll.Parent =
    Main
--// Existing Emote content moves right of the category rail.
SlotsScroll.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
SlotsScroll.Position =
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
    SlotsScroll
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
    SlotsScroll
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
    SlotsScroll
--// =========================================================
--// CREATE SLOT ROWS
--// =========================================================
for slotIndex = 1, SLOT_COUNT do
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
        SlotsScroll
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
        slots[slotIndex].originalName
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
    slotOriginalButtons[
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
        slots[slotIndex].replaceName
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
    slotReplaceButtons[
        slotIndex
    ] =
        replaceButton
end
cosmetic.loadState()
cosmetic.buildList()
cosmetic.installHook()
cosmetic.buildUI()

pcall(function()
    local loadoutChannel =
        ReplicatedStorage.Shared.UserData.Events.Remotes.Channels.Loadout

    UnusualFns.addUnusualConnection(
        loadoutChannel.OnClientEvent:Connect(
            function(kind, data)
                if kind == "sync"
                    and type(data) == "table"
                then
                    cosmetic.setInitialOriginal(
                        1,
                        data.CosmeticSlot_1
                    )
                    cosmetic.setInitialOriginal(
                        2,
                        data.CosmeticSlot_2
                    )
                elseif kind == "patch"
                    and type(data) == "table"
                then
                    cosmetic.setInitialOriginal(
                        1,
                        data.CosmeticSlot_1
                    )
                    cosmetic.setInitialOriginal(
                        2,
                        data.CosmeticSlot_2
                    )
                end
            end
        )
    )
end)

genv.DEADEYE_COSMETIC_CLEANUP =
    cosmetic.cleanup

--// =========================================================
--// PICKER
--// =========================================================
Picker =
    Instance.new("Frame")
Picker.Size =
    UDim2.new(
        0,
        560,
        0,
        450
    )
Picker.Position =
    UDim2.new(
        0.5,
        -280,
        0.5,
        -225
    )
Picker.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )
Picker.BackgroundTransparency =
    0.10
Picker.BorderSizePixel =
    0
Picker.ClipsDescendants =
    true
Picker.Visible =
    false
Picker.ZIndex =
    30
Picker.Parent =
    ScreenGui
__UI.PickerCorner =
    Instance.new("UICorner")
__UI.PickerCorner.CornerRadius =
    UDim.new(
        0,
        8
    )
__UI.PickerCorner.Parent =
    Picker
__UI.PickerStroke =
    Instance.new("UIStroke")
__UI.PickerStroke.Thickness =
    1
__UI.PickerStroke.Transparency =
    0.66
__UI.PickerStroke.Parent =
    Picker
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
    Picker
--// PICKER TITLE
PickerTitle =
    Instance.new("TextLabel")
PickerTitle.Size =
    UDim2.new(
        1,
        -45,
        0,
        32
    )
PickerTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        2
    )
PickerTitle.BackgroundTransparency =
    1
PickerTitle.Text =
    "Select Emote"
PickerTitle.TextSize =
    16
PickerTitle.Font =
    Enum.Font.GothamBold
PickerTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
PickerTitle.TextXAlignment =
    Enum.TextXAlignment.Left
PickerTitle.ZIndex =
    31
PickerTitle.Parent =
    Picker
--// =========================================================
--// PICKER CLOSE
--// =========================================================
PickerClose =
    Instance.new("TextButton")
PickerClose.Size =
    UDim2.new(
        0,
        27,
        0,
        27
    )
PickerClose.Position =
    UDim2.new(
        1,
        -32,
        0,
        6
    )
PickerClose.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        50
    )
PickerClose.BackgroundTransparency =
    0.05
PickerClose.BorderSizePixel =
    0
PickerClose.ZIndex =
    31
PickerClose.Text =
    "×"
PickerClose.TextSize =
    27
PickerClose.Font =
    Enum.Font.GothamBold
PickerClose.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
PickerClose.AutoButtonColor =
    false
PickerClose.Active =
    true
PickerClose.Selectable =
    false
PickerClose.Parent =
    Picker

__UI.PickerCloseCorner =
    Instance.new("UICorner")
__UI.PickerCloseCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.PickerCloseCorner.Parent =
    PickerClose

__UI.PickerCloseStroke =
    Instance.new("UIStroke")
__UI.PickerCloseStroke.Thickness =
    1
__UI.PickerCloseStroke.Transparency =
    0.65
__UI.PickerCloseStroke.Parent =
    PickerClose
--// =========================================================
--// PICKER SEARCH
--// =========================================================
PickerSearch =
    Instance.new("TextBox")
PickerSearch.Size =
    UDim2.new(
        1,
        -20,
        0,
        30
    )
PickerSearch.Position =
    UDim2.new(
        0,
        10,
        0,
        36
    )
PickerSearch.BackgroundColor3 =
    Color3.fromRGB(
        40,
        45,
        53
    )
PickerSearch.BackgroundTransparency =
    0.20
PickerSearch.BorderSizePixel =
    0
PickerSearch.ClearTextOnFocus =
    false
PickerSearch.PlaceholderText =
    "Search by name..."
PickerSearch.PlaceholderColor3 =
    Color3.fromRGB(
        120,
        120,
        120
    )
PickerSearch.Text =
    ""
PickerSearch.TextSize =
    12
PickerSearch.Font =
            Enum.Font.GothamBold
PickerSearch.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
PickerSearch.ZIndex =
    32
PickerSearch.Parent =
    Picker
__UI.SearchCorner =
    Instance.new("UICorner")
__UI.SearchCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
__UI.SearchCorner.Parent =
    PickerSearch
--// =========================================================
--// PICKER SCROLL
--// =========================================================
PickerScroll =
    Instance.new("ScrollingFrame")
PickerScroll.Size =
    UDim2.new(
        1,
        -16,
        1,
        -74
    )
PickerScroll.Position =
    UDim2.new(
        0,
        8,
        0,
        70
    )
PickerScroll.BackgroundColor3 =
    Color3.fromRGB(
        32,
        35,
        42
    )
PickerScroll.BackgroundTransparency =
    0.20
PickerScroll.BorderSizePixel =
    0
PickerScroll.ScrollBarThickness =
    6
PickerScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
PickerScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
PickerScroll.ZIndex =
    31
PickerScroll.Parent =
    Picker
__UI.PickerScrollCorner =
    Instance.new("UICorner")
__UI.PickerScrollCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
__UI.PickerScrollCorner.Parent =
    PickerScroll
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
    PickerScroll
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
    PickerScroll
--// =========================================================
--// EMOTE VIEWPORT PREVIEW
--// Локальная копия native preview без CreateViewport()
--// =========================================================
local function createEmotePreview(
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
    SLOT_COUNT = SLOT_COUNT,
    slots = slots,
    prepareOriginalModule = prepareOriginalModule,
    prepareReplaceModule = prepareReplaceModule,
    getEmoteName = getEmoteName,
    createEmotePreview = createEmotePreview,
    isEnabled = function()
        return enabled
    end
}

local NativeWheel =
    loadstring(
        game:HttpGet(
            "https://raw.githubusercontent.com/skirkzhdimenya-source/DeadEye/8d0f6ff3659781c4beedbf2d2b33f6c6c0731fe3/DeadEye_NativeWheel.lua"
        )
    )()

--// Backward-compatible guard for a cached old factory-style module.
if type(NativeWheel) == "function" then
    NativeWheel = NativeWheel(
        getgenv().DEADEYE_NATIVE_WHEEL_CONTEXT
    )
end

getgenv().DEADEYE_NATIVE_WHEEL_CONTEXT = nil

if type(NativeWheel) ~= "table" then
    error(
        "[DeadEye] NativeWheel module did not return an API table"
    )
end
--// =========================================================
--// REBUILD PICKER
--// =========================================================
local function rebuildPicker()
    for _, button in ipairs(
        pickerButtons
    ) do
        pcall(function()
            local preview = button:FindFirstChild("EmotePreview")
            if preview then
                local id = tonumber(string.match(button.Name, "^Emote_(%d+)$"))
                if id then
                    emotePreviewCache[id] = preview
                    preview.Parent = emotePreviewCacheHolder
                end
            end
        end)
        pcall(function()
            button:Destroy()
        end)
    end
    table.clear(
        pickerButtons
    )
    local query =
        string.lower(
            PickerSearch.Text
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
        button.Parent = PickerScroll

        local corner =
            Instance.new("UICorner")

        corner.CornerRadius =
            UDim.new(0, 5)
        corner.Parent = button

        table.insert(
            pickerButtons,
            button
        )

        button.MouseButton1Click:Connect(
            function()
                if not activePickerSlot
                    or not activePickerSide then
                    return
                end

                local slot =
                    slots[activePickerSlot]

                if activePickerSide == "Original" then
                    slot.originalId = nil
                    slot.originalName = nil
                    slotOriginalButtons[
                        activePickerSlot
                    ].Text = "Select"
                else
                    slot.replaceId = nil
                    slot.replaceName = nil
                    slotReplaceButtons[
                        activePickerSlot
                    ].Text = "Select"
                end

                savedConfig.emotes[
                    activePickerSlot
                ] = {
                    originalId = slot.originalId,
                    replaceId = slot.replaceId
                }

                saveSavedConfig()

                if EmoteRuntime.getCurrentOriginalId() == slot.originalId
                    or (
                        EmoteRuntime.getCurrentOriginalId()
                        and not slot.originalId
                    )
                then
                    EmoteRuntime.stopCustomEmote()
                end

                Status.Text =
                    "Slot "
                    .. tostring(activePickerSlot)
                    .. " cleared"

                Picker.Visible = false
                activePickerSlot = nil
                activePickerSide = nil
            end
        )

        shown = shown + 1
    end

    for index, data in ipairs(
        emoteList
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
                PickerScroll


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
                emotePreviewCache[data.id]

            if cachedPreview then
                pcall(function()
                    viewport:Destroy()
                end)
                cachedPreview.Parent = button
                viewport = cachedPreview
            else
                createEmotePreview(
                    data.module,
                    viewport
                )
                emotePreviewCache[data.id] = viewport
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
                pickerButtons,
                button
            )
            button.MouseButton1Click:Connect(
                function()
                    if not activePickerSlot
                        or not activePickerSide then
                        return
                    end
                    local slot =
                        slots[
                            activePickerSlot
                        ]
                    if activePickerSide ==
                        "Original" then
                        slot.originalId =
                            data.id
                        slot.originalName =
                            data.name
                        prepareOriginalModule(
                            data.id
                        )
                        slotOriginalButtons[
                            activePickerSlot
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
                        slotReplaceButtons[
                            activePickerSlot
                        ].Text =
                            data.name
                    end
                    savedConfig.emotes[
                        activePickerSlot
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
                    if EmoteRuntime.getCurrentOriginalId()
                        == slot.originalId then
                        EmoteRuntime.stopCustomEmote()
                    end
                    Status.Text =
                        "Slot "
                        .. tostring(
                            activePickerSlot
                        )
                        .. " configured"
                    Picker.Visible =
                        false
                    activePickerSlot =
                        nil
                    activePickerSide =
                        nil
                end
            )
        end
    end
    Status.Text =
        "Found: "
        .. tostring(shown)
    PickerScroll.CanvasPosition =
        Vector2.new(
            0,
            0
        )
    emotePickerPreloaded = true
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
local function openPicker(
    slotIndex,
    side
)
    activePickerSlot =
        slotIndex
    activePickerSide =
        side
    if side == "Original" then
        PickerTitle.Text =
            "Slot "
            .. tostring(
                slotIndex
            )
            .. " • Original"
    else
        PickerTitle.Text =
            "Slot "
            .. tostring(
                slotIndex
            )
            .. " • Replace"
    end
    PickerSearch.Text =
        ""

    if not emotePickerPreloaded then
        rebuildPicker()
    end

    __UI.animatePickerAppear(
        Picker
    )
end
--// =========================================================
--// CLOSE PICKER
--// =========================================================
local function closePicker()
    Picker.Visible =
        false
    activePickerSlot =
        nil
    activePickerSide =
        nil
end
--// =========================================================
--// CONNECT SLOT BUTTONS
--// =========================================================
for slotIndex = 1, SLOT_COUNT do
    slotOriginalButtons[
        slotIndex
    ].MouseButton1Click:Connect(
        function()
            openPicker(
                slotIndex,
                "Original"
            )
        end
    )
    slotReplaceButtons[
        slotIndex
    ].MouseButton1Click:Connect(
        function()
            openPicker(
                slotIndex,
                "Replace"
            )
        end
    )
end
--// =========================================================
--// SEARCH
--// =========================================================
addConnection(
    PickerSearch:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()
            if Picker.Visible then
                rebuildPicker()
            end
        end
    )
)
PickerClose.MouseButton1Click:Connect(
    function()
        closePicker()
    end
)
--// =========================================================
--// TOGGLE
--// =========================================================
addConnection(
    Toggle.MouseButton1Click:Connect(
        function()
            if currentCategory == "Cosmetic" then
                local valid = false

                for index = 1, 2 do
                    local state =
                        cosmetic.slots[index]

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
                    cosmetic.enabled =
                        not cosmetic.enabled

                    pcall(
                        cosmetic.updateToggle
                    )

                    -- Apply directly to the existing live rig.
                    -- Future respawns are still handled by SetRig.
                    task.spawn(function()
                        pcall(
                            cosmetic.refreshRig
                        )
                    end)
                else
                    cosmetic.enabled = false

                    pcall(
                        cosmetic.updateToggle
                    )
                end

                return
            end

            if currentCategory == "Unusual" then
                if unusualEnabled then
                    unusualEnabled =
                        false
                    genv.UNUSUAL_SWAPPER_ENABLED =
                        false
                    UnusualFns.restoreUnusual()
                else
                    if not unusualSlot.originalId
                        or not unusualSlot.replaceId
                    then
                        unusualStatus.Text =
                            "Select both Unusuals first"
                        return
                    end
                    if UnusualFns.activateUnusual() then
                        unusualEnabled =
                            true
                        unusualRuntime.appliedRig =
                            UnusualFns.getUnusualVisualRig()
                        genv.UNUSUAL_SWAPPER_ENABLED =
                            true
                    end
                end
                updateUnusualToggle()
                return
            end
            --// EXISTING EMOTE TOGGLE
            if enabled then
                enabled = false
                EmoteRuntime.stopCustomEmote()
                NativeWheel.restore()
                updateGUI()
                Status.Text =
                    "Swap disabled"
                                return
            end
            local validSlots = 0
            for i = 1, SLOT_COUNT do
                local slot =
                    slots[i]
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
                Status.Text =
                    "No configured slots"
                return
            end
            enabled =
                true
            NativeWheel.reset()
            EmoteRuntime.reset()
            NativeWheel.sync()
            updateGUI()
            Status.Text =
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
setMainMinimized = function(state)
    mainMinimized = state
    if mainMinimized then
        Main.Size =
            UDim2.new(
                0,                245,
                0,
                40
            )
        MainTitle.Size =
            UDim2.new(
                0,
                155,
                0,
                36
            )
        Status.Visible = false
        Toggle.Visible = false
        SlotsScroll.Visible = false
        if Picker then
            Picker.Visible = false
        end
        pcall(function()
            categoryBar.Visible = false
            mainPage.Visible = false
            unusualPage.Visible = false
            unusualStatus.Visible = false
            others.page.Visible = false
        end)
        Minimize.Text = "+"

        for _, name in ipairs({
            "ResizeRight",
            "ResizeBottom",
            "ResizeCorner"
        }) do
            local handle =
                Main:FindFirstChild(name)
            if handle then
                handle.Visible = false
            end
        end
    else
        Main.Size =
            UDim2.new(
                0,
                math.max(
                    MIN_WINDOW_WIDTH,
                    savedConfig.gui.width
                ),
                0,
                math.max(
                    MIN_WINDOW_HEIGHT,
                    savedConfig.gui.height
                )
            )
        MainTitle.Size =
            UDim2.new(
                1,
                -105,
                0,
                36
            )
        Status.Visible = true
        Toggle.Visible = true
        SlotsScroll.Visible = true
        pcall(function()
            categoryBar.Visible = true
            if currentCategory == "Main" then
                Status.Visible = false
                Toggle.Visible = false
                SlotsScroll.Visible = false
                mainPage.Visible = true
                unusualPage.Visible = false
                unusualStatus.Visible = false
                others.page.Visible = false
            elseif currentCategory == "Unusual" then
                Status.Visible = false
                Toggle.Visible = true
                Toggle.Parent =
                    unusualPage
                Toggle.LayoutOrder =
                    0
                SlotsScroll.Visible = false
                mainPage.Visible = false
                unusualPage.Visible = true
                unusualStatus.Visible = false
                others.page.Visible = false
            elseif currentCategory == "Others" then
                Status.Visible = false
                Toggle.Visible = false
                SlotsScroll.Visible = false
                mainPage.Visible = false
                unusualPage.Visible = false
                unusualStatus.Visible = false
                others.page.Visible = true
                cosmetic.page.Visible = false
            elseif currentCategory == "Cosmetic" then
                Status.Visible = false
                Toggle.Visible = true
                Toggle.Parent = cosmetic.page
                Toggle.LayoutOrder = 0
                SlotsScroll.Visible = false
                mainPage.Visible = false
                unusualPage.Visible = false
                unusualStatus.Visible = false
                others.page.Visible = false
                cosmetic.page.Visible = true
                unusualPicker.Visible = false
                cosmetic.updateToggle()
            else
                mainPage.Visible = false
                unusualPage.Visible = false
                unusualStatus.Visible = false
                others.page.Visible = false
            end
        end)
        Minimize.Text = "−"

        for _, name in ipairs({
            "ResizeRight",
            "ResizeBottom",
            "ResizeCorner"
        }) do
            local handle =
                Main:FindFirstChild(name)
            if handle then
                handle.Visible = true
            end
        end
    end
end
--// =========================================================
--// MINIMIZE BUTTON CONNECTION
--// =========================================================
addConnection(
    Minimize.MouseButton1Click:Connect(
        function()
            setMainMinimized(
                not mainMinimized
            )
        end
    )
)
--// =========================================================
--// GUI UPDATE
--// =========================================================
function updateGUI()
    if enabled then
        Toggle.Text =
            "SWAP: ON"
        Toggle.BackgroundColor3 =
            Color3.fromRGB(
                68,
                74,
                84
            )
    else
        Toggle.Text =
            "SWAP: OFF"
        Toggle.BackgroundColor3 =
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
addConnection(
    RunService.Heartbeat:Connect(
        function()
            if not genv.EMOTE_SWAPPER_RUNNING then
                return
            end
            NativeWheel.sync()
            EmoteRuntime.checkState()
        end
    )
)
local DragHandle =
    Instance.new("Frame")
DragHandle.Name =
    "DragHandle"
DragHandle.Size =
    UDim2.new(
        1,
        -105,
        0,
        39
    )
DragHandle.Position =
    UDim2.new(
        0,
        1,
        0,
        1
    )
DragHandle.BackgroundTransparency =
    1
DragHandle.BorderSizePixel =
    0
DragHandle.Active =
    true
DragHandle.ZIndex =
    4
DragHandle.Parent =
    Main

--// =========================================================
--// WINDOW GEOMETRY / DRAG / RESIZE
-- =========================================================
local dragging = false
local dragStart
local startPosition

local resizing = false
local resizeMode = nil
local resizeStart
local resizeStartSize

local function saveWindowState()
    savedConfig.gui =
        savedConfig.gui
        or {}

    savedConfig.gui.x =
        math.floor(
            Main.Position.X.Offset
            + 0.5
        )

    savedConfig.gui.y =
        math.floor(
            Main.Position.Y.Offset
            + 0.5
        )

    if not mainMinimized then
        savedConfig.gui.width =
            math.floor(
                Main.AbsoluteSize.X
                + 0.5
            )

        savedConfig.gui.height =
            math.floor(
                Main.AbsoluteSize.Y
                + 0.5
            )
    end

    pcall(function()
        saveSavedConfig()
    end)
end

local function clampWindowPosition()
    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    local viewport =
        camera.ViewportSize

    local width =
        Main.AbsoluteSize.X

    local height =
        Main.AbsoluteSize.Y

    local x =
        Main.Position.X.Offset

    local y =
        Main.Position.Y.Offset

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

    Main.Position =
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

local function setMainSize(
    width,
    height
)
    Main.Size =
        UDim2.new(
            0,
            math.max(
                MIN_WINDOW_WIDTH,
                math.floor(
                    width + 0.5
                )
            ),
            0,
            math.max(
                MIN_WINDOW_HEIGHT,
                math.floor(
                    height + 0.5
                )
            )
        )

    clampWindowPosition()
end

--// Drag the title bar.
local function beginWindowDrag(input)
    if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        or input.UserInputType ==
            Enum.UserInputType.Touch
    then
        dragging = true
        dragStart =
            input.Position
        startPosition =
            Main.Position
    end
end

addConnection(
    DragHandle.InputBegan:Connect(
        function(input)
            beginWindowDrag(input)
        end
    )
)

addConnection(
    MainTitle.InputBegan:Connect(
        function(input)
            beginWindowDrag(input)
        end
    )
)

addConnection(
    UserInputService.InputChanged:Connect(
        function(input)
            if not dragging then
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
                dragStart

            Main.Position =
                UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset
                        + delta.X,
                    startPosition.Y.Scale,
                    startPosition.Y.Offset
                        + delta.Y
                )

            clampWindowPosition()
        end
    )
)

local function beginResize(
    position,
    mode
)
    if mainMinimized then
        return
    end

    resizing = true
    resizeMode = mode
    resizeStart =
        position
    resizeStartSize =
        Main.AbsoluteSize
end

--// Invisible right-edge resize target.
local ResizeRight =
    Instance.new("Frame")
ResizeRight.Name =
    "ResizeRight"
ResizeRight.Size =
    UDim2.new(
        0,
        RESIZE_EDGE,
        1,
        -54
    )
ResizeRight.Position =
    UDim2.new(
        1,
        -RESIZE_EDGE,
        0,
        48
    )
ResizeRight.BackgroundTransparency =
    1
ResizeRight.BorderSizePixel =
    0
ResizeRight.ZIndex =
    20
ResizeRight.Active =
    true
ResizeRight.Parent =
    Main

addConnection(
    ResizeRight.InputBegan:Connect(
        function(input)
            if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch
            then
                beginResize(
                    input.Position,
                    "right"
                )
            end
        end
    )
)

--// Bottom-edge resize target.
local ResizeBottom =
    Instance.new("Frame")
ResizeBottom.Name =
    "ResizeBottom"
ResizeBottom.Size =
    UDim2.new(
        1,
        -54,
        0,
        RESIZE_EDGE
    )
ResizeBottom.Position =
    UDim2.new(
        0,
        8,
        1,
        -RESIZE_EDGE
    )
ResizeBottom.BackgroundTransparency =
    1
ResizeBottom.BorderSizePixel =
    0
ResizeBottom.ZIndex =
    20
ResizeBottom.Active =
    true
ResizeBottom.Parent =
    Main

addConnection(
    ResizeBottom.InputBegan:Connect(
        function(input)
            if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch
            then
                beginResize(
                    input.Position,
                    "bottom"
                )
            end
        end
    )
)

--// Bottom-right corner: width + height together.
local ResizeCorner =
    Instance.new("TextButton")
ResizeCorner.Name =
    "ResizeCorner"
ResizeCorner.Size =
    UDim2.new(
        0,
        24,
        0,
        24
    )
ResizeCorner.Position =
    UDim2.new(
        1,
        -24,
        1,
        -24
    )
ResizeCorner.BackgroundTransparency =
    1
ResizeCorner.BorderSizePixel =
    0
ResizeCorner.Text =
    ""
ResizeCorner.TextSize =
    1
ResizeCorner.ZIndex =
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
        ResizeCorner
end
ResizeCorner.AutoButtonColor =
    false
ResizeCorner.Parent =
    Main

addConnection(
    ResizeCorner.InputBegan:Connect(
        function(input)
            if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch
            then
                beginResize(
                    input.Position,
                    "corner"
                )
            end
        end
    )
)

addConnection(
    UserInputService.InputChanged:Connect(
        function(input)
            if not resizing then
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
                resizeStart

            local width =
                resizeStartSize.X

            local height =
                resizeStartSize.Y

            if resizeMode == "right"
                or resizeMode == "corner"
            then
                width =
                    resizeStartSize.X +
                    delta.X
            end

            if resizeMode == "bottom"
                or resizeMode == "corner"
            then
                height =
                    resizeStartSize.Y +
                    delta.Y
            end

            setMainSize(
                width,
                height
            )
        end
    )
)

addConnection(
    UserInputService.InputEnded:Connect(
        function(input)
            if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch
            then
                if dragging then
                    dragging = false
                    saveWindowState()
                end

                if resizing then
                    resizing = false
                    resizeMode = nil
                    saveWindowState()
                end
            end
        end
    )
)

--// CLEANUP
--// =========================================================
local function cleanup()
    if cleaned then
        return
    end

    --// Save the complete Others state before destroying its TextBoxes.
    --// This also persists Avatar Import text and values changed without
    --// pressing APPLY / ENTER.
    pcall(function()
        others.saveConfig()
    end)

    --// Persist Main / Reverse Look state on close as well.
    pcall(function()
        mainJump.saveConfig()
    end)

    pcall(function()
        ScreenGui.Enabled = false
    end)

    NativeWheel.restore(true)

    pcall(function()
        mainJump.setRageLookEnabled(
            false,
            false
        )
    end)

    pcall(function()
        mainJump.uninstallReverseLookHooks()
    end)

    pcall(function()
        mainJump.destroySensors()
        mainJump.manualJumpActive = false
        mainJump.lookAutoJumpCycle = false
        mainJump.lookTriggeredThisAir = false
    end)

    pcall(function()
        if mainJump.benchTrimpStateConnection then
            mainJump.benchTrimpStateConnection:Disconnect()
            mainJump.benchTrimpStateConnection = nil
        end
        mainJump.benchTrimpEnabled = false
    end)

    pcall(function()
        if mainJump.lookActive
            or mainJump.lookRestoring
        then
            mainJump.restoreLookNow()
        else
            mainJump.unbindLookRender()
        end

        if mainJump.lookStateConnection then
            mainJump.lookStateConnection:Disconnect()
            mainJump.lookStateConnection = nil
        end
    end)

    --// Stop every active loop before doing any cleanup that may yield.
    cleaned = true
    genv.EMOTE_SWAPPER_RUNNING = false
    genv.DEADEYE_MAIN_RUNNING = false
    genv.DEADEYE_UNUSUAL_POV_RUNNING = false
    genv.DEADEYE_PORTRAIT_RUNNING = false

    pcall(function()
        mainJump.stopCrouchSpam()
    end)

    pcall(function()
        mainJump.destroyCrouchSpamSensor()
    end)

    enabled = false

    pcall(function()
        EmoteRuntime.stopForCleanup()
    end)

    pcall(function()
        disconnectAll()
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
        saveWindowState()
    end)

    pcall(function()
        if Picker then
            Picker.Visible = false
        end
    end)

    pcall(function()
        if ScreenGui then
            ScreenGui:Destroy()
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
    cleanup
--// =========================================================
--// CLOSE
--// =========================================================
addConnection(
    Close.MouseButton1Click:Connect(
        function()
            cleanup()
        end
    )
)
--// =========================================================
--// =========================================================
--// GLASS SURFACE FINISH
--// =========================================================
for _, object in ipairs(
    Main:GetDescendants()
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
        and object ~= MainSurface
        and object ~= MainHeader
        and object ~= mainJump.autoJumpModePicker
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
    mainJump.syncAutoJumpModePickerVisual()
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
        button == PickerClose
        or button == unusualPickerClose

    local compact =
        button == Minimize
        or button == Close
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

    addConnection(
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

    addConnection(
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

    addConnection(
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

    addConnection(
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

    addConnection(
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
    ScreenGui:GetDescendants()
) do
    if object:IsA("TextButton") then
        __UI.styleButtonMotion(object)
    end
end

addConnection(
    ScreenGui.DescendantAdded:Connect(
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
    clampWindowPosition()
end)
prepareSlots()
savedConfig.emotes =
    savedConfig.emotes
    or {}
for i = 1, SLOT_COUNT do
    savedConfig.emotes[i] = {
        originalId =
            slots[i].originalId,
        replaceId =
            slots[i].replaceId
    }
end
savedConfig.unusual = {
    originalId =
        unusualSlot.originalId,
    replaceId =
        unusualSlot.replaceId
}
cosmetic.saveState()
saveSavedConfig()

--// PRELOAD PICKER 3D PREVIEWS ON SCRIPT START.
--// Opening the picker later only reuses these ready ViewportFrames.
pcall(function()
    rebuildPicker()
end)

pcall(function()
    cosmetic.rebuildPicker()
end)

setMainMinimized(false)
updateGUI()
pcall(function()
    setCategory("Emotes")
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/skirkzhdimenya-source/DeadEye/main/DeadEye_Portrait.lua"))()
