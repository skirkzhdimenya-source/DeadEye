--// VERSION RULE: increment only digits after the dot; keep major version v1.
--// DEADEYE DIAGNOSTIC BOOTSTRAP (starts before DeadEye initialization)
local __DDCore = {}
__DDCore.Env = _G
pcall(function()
    if type(getgenv) == "function" then
        __DDCore.Env = getgenv()
    end
end)

__DDCore.PreviousState = __DDCore.Env.DEADEYE_DIAG_STATE
pcall(function()
    if type(__DDCore.PreviousState) == "table" then
        if __DDCore.PreviousState.messageConnection then
            __DDCore.PreviousState.messageConnection:Disconnect()
        end
        if __DDCore.PreviousState.inputConnection then
            __DDCore.PreviousState.inputConnection:Disconnect()
        end
        if __DDCore.PreviousState.guiConnection then
            __DDCore.PreviousState.guiConnection:Disconnect()
        end
        if type(__DDCore.PreviousState.buttonConnections) == "table" then
            for _, connection in pairs(__DDCore.PreviousState.buttonConnections) do
                pcall(function()
                    connection:Disconnect()
                end)
            end
        end
        if type(__DDCore.PreviousState.loadoutObserverCancels) == "table" then
            for _, cancel in pairs(__DDCore.PreviousState.loadoutObserverCancels) do
                pcall(cancel)
            end
        end
    end
end)

__DDCore.State = {
    active = true,
    stopRequested = false,
    log = {},
    startedAt = os.clock(),
    errorCounts = {},
    watchedButtons = setmetatable({}, { __mode = "k" }),
    buttonConnections = {},
    loadoutObserverCancels = {},
    repeatMessage = nil,
    repeatCount = 0
}

__DDCore.Env.DEADEYE_DIAG_STATE = __DDCore.State
__DDCore.Env.DEADEYE_DIAG_LOG = __DDCore.State.log

function __DDCore.Log(message)
    if not __DDCore.State.active then
        return
    end

    local messageText = tostring(message)
    local keep =
        string.find(messageText, "SWAPTRACE|", 1, true) ~= nil
        or string.find(messageText, "F6:", 1, true) ~= nil
        or string.find(messageText, "THROW ", 1, true) ~= nil
        or string.find(messageText, "UNUSUAL FAIL:", 1, true) ~= nil
        or string.find(messageText, "UNUSUAL ACTIVATE OK:", 1, true) ~= nil

    if not keep then
        return
    end

    local elapsed = 0
    pcall(function()
        elapsed = os.clock() - __DDCore.State.startedAt
    end)

    local line = string.format(
        "[DeadEyeDiag %s +%.3fs] %s",
        SCRIPT_VERSION or "swap-trace",
        elapsed,
        messageText
    )

    table.insert(__DDCore.State.log, line)

    pcall(function()
        print(line)
    end)
end

function __DDCore.CallCleanup(label, callback)
    __DDCore.Log("BOOT CLEANUP BEGIN: " .. tostring(label))
    local ok, err = pcall(function()
        callback()
    end)

    if ok then
        __DDCore.Log("BOOT CLEANUP OK: " .. tostring(label))
    else
        __DDCore.Log("BOOT CLEANUP FAILED: " .. tostring(label) .. "\n" .. tostring(err))
    end

    return ok, err
end

__DDCore.StopAndCopy = nil
__DDCore.StopAndCopy = function()
    if __DDCore.State.stopRequested then
        return
    end

    __DDCore.State.stopRequested = true
    __DDCore.Log("F6: FULL STOP requested; beginning DeadEye cleanup")

    pcall(function()
        __DDCore.Env.DEADEYE_MAIN_RUNNING = false
        __DDCore.Env.EMOTE_SWAPPER_RUNNING = false
        __DDCore.Env.DEADEYE_PORTRAIT_RUNNING = false
        __DDCore.Env.DEADEYE_UNUSUAL_POV_RUNNING = false
    end)

    local mainCleanup = __DDCore.Env.EMOTE_SWAPPER_CLEANUP
    local mainCleanupOK = false

    if type(mainCleanup) == "function" then
        mainCleanupOK = __DDCore.CallCleanup("EMOTE_SWAPPER_CLEANUP (main)", mainCleanup)
    else
        __DDCore.Log("F6: main cleanup callback not installed yet")
    end

    -- If the regular cleanup failed or the script stopped before assigning
    -- its main cleanup function, try the remaining independent cleanup hooks.
    if not mainCleanupOK then
        for _, key in ipairs({
            "UNUSUAL_SWAPPER_CLEANUP",
            "DEADEYE_PORTRAIT_CLEANUP",
            "DEADEYE_COSMETIC_CLEANUP",
            "DEADEYE_MAIN_SENSORS_CLEANUP",
            "DEADEYE_UNUSUAL_POV_TRANSPARENCY_CLEANUP",
            "DEADEYE_FOV_BODY_VISIBILITY_CLEANUP",
            "DEADEYE_FIRSTPERSON_HEAD_FIX_CLEANUP",
            "DEADEYE_MAIN_AIR_TURN_CLEANUP",
            "DEADEYE_REVERSE_LOOK_CLEANUP",
            "DEADEYE_RAGE_LOOK_CLEANUP"
        }) do
            local callback = __DDCore.Env[key]
            if callback then
                __DDCore.CallCleanup(key, callback)
            end
        end
    end

    pcall(function()
        __DDCore.Env.DEADEYE_MAIN_RUNNING = false
        __DDCore.Env.EMOTE_SWAPPER_RUNNING = false
        __DDCore.Env.DEADEYE_PORTRAIT_RUNNING = false
        __DDCore.Env.DEADEYE_UNUSUAL_POV_RUNNING = false
    end)

    if type(__DDCore.State.loadoutObserverCancels) == "table" then
        for slotName, cancel in pairs(__DDCore.State.loadoutObserverCancels) do
            local ok, err = pcall(cancel)
            __DDCore.Log("F6: loadout observer cleanup slot=" .. tostring(slotName)
                .. ", ok=" .. tostring(ok)
                .. (not ok and (", error=" .. tostring(err)) or ""))
        end
        table.clear(__DDCore.State.loadoutObserverCancels)
    end

    __DDCore.Log("F6: cleanup stage finished; preparing clipboard log")

    local copied = false
    local chosenClipboard = nil
    local clipboardNames = {
        "setclipboard",
        "toclipboard",
        "writeclipboard"
    }

    for _, name in ipairs(clipboardNames) do
        local callback = __DDCore.Env[name]
        if type(callback) ~= "function" then
            callback = _G[name]
        end

        if type(callback) == "function" then
            local ok = pcall(callback, table.concat(__DDCore.State.log, "\n"))
            if ok then
                copied = true
                chosenClipboard = name
                break
            end
        end
    end

    if copied then
        __DDCore.Log("F6: clipboard API succeeded (" .. tostring(chosenClipboard) .. ")")
        -- Copy a second time so the clipboard also contains the final status line.
        local callback = __DDCore.Env[chosenClipboard]
        if type(callback) ~= "function" then
            callback = _G[chosenClipboard]
        end
        if type(callback) == "function" then
            pcall(callback, table.concat(__DDCore.State.log, "\n"))
        end
    else
        __DDCore.Log("F6: clipboard API unavailable/failed; log remains in getgenv().DEADEYE_DIAG_LOG")
    end

    __DDCore.State.active = false

    pcall(function()
        if __DDCore.State.messageConnection then
            __DDCore.State.messageConnection:Disconnect()
        end
        if __DDCore.State.inputConnection then
            __DDCore.State.inputConnection:Disconnect()
        end
        if __DDCore.State.guiConnection then
            __DDCore.State.guiConnection:Disconnect()
        end
        for _, connection in pairs(__DDCore.State.buttonConnections) do
            pcall(function()
                connection:Disconnect()
            end)
        end
    end)
end

__DDCore.Env.DEADEYE_DIAG_STOP = __DDCore.StopAndCopy
__DDCore.Log("BOOT: first executable statement reached; diagnostic capture is active")

-- Capture engine/runtime errors and warnings from the very beginning.
__DDCore.LogListenerInstalled = false
__DDCore.LogListenerOK, __DDCore.LogListenerError = pcall(function()
    local logService = game:GetService("LogService")
    __DDCore.State.messageConnection = logService.MessageOut:Connect(function(message, messageType)
        if not __DDCore.State.active then
            return
        end

        local typeName = tostring(messageType)
        if not string.find(typeName, "Error", 1, true)
            and not string.find(typeName, "Warning", 1, true)
        then
            return
        end

        local text = tostring(message)
        if text == __DDCore.State.repeatMessage then
            __DDCore.State.repeatCount = __DDCore.State.repeatCount + 1
            if __DDCore.State.repeatCount == 1
                or __DDCore.State.repeatCount == 10
                or __DDCore.State.repeatCount % 100 == 0
            then
                __DDCore.Log("ENGINE " .. typeName .. " (repeated x"
                    .. tostring(__DDCore.State.repeatCount + 1) .. "): " .. text)
            end
            return
        end

        if __DDCore.State.repeatCount > 0 then
            __DDCore.Log("ENGINE previous message repeated x"
                .. tostring(__DDCore.State.repeatCount + 1))
        end
        __DDCore.State.repeatMessage = text
        __DDCore.State.repeatCount = 0
        __DDCore.Log("ENGINE " .. typeName .. ": " .. text)
    end)
    __DDCore.LogListenerInstalled = true
end)
if not __DDCore.LogListenerOK then
    __DDCore.Log("BOOT ERROR: failed to install LogService listener: " .. tostring(__DDCore.LogListenerError))
end

-- F6 is reserved for diagnostic stop + copy-log in this build.
__DDCore.F6ListenerInstalled = false
__DDCore.F6ListenerOK, __DDCore.F6ListenerError = pcall(function()
    local inputService = game:GetService("UserInputService")
    __DDCore.State.inputConnection = inputService.InputBegan:Connect(function(input)
        if tostring(input.KeyCode) == "Enum.KeyCode.F6" then
            __DDCore.StopAndCopy()
        end
    end)
    __DDCore.F6ListenerInstalled = true
end)
if not __DDCore.F6ListenerOK then
    __DDCore.Log("BOOT ERROR: failed to install F6 listener: " .. tostring(__DDCore.F6ListenerError))
end

__DDCore.Log("BOOT listeners: LogService=" .. tostring(__DDCore.LogListenerInstalled)
    .. ", F6=" .. tostring(__DDCore.F6ListenerInstalled))

function __DDCore.Traceback(err)
    local message = tostring(err)
    pcall(function()
        if debug and type(debug.traceback) == "function" then
            message = debug.traceback(message, 2)
        end
    end)
    return message
end

__DDCore.Pack = table.pack or function(...)
    return { n = select("#", ...), ... }
end
__DDCore.Unpack = table.unpack or unpack

function __DDCore.Value(value)
    if value == nil then
        return "nil"
    end

    local kind = type(value)
    if kind == "string" then
        if #value > 96 then
            return string.format("%q", string.sub(value, 1, 93) .. "...")
        end
        return string.format("%q", value)
    elseif kind == "number" or kind == "boolean" then
        return tostring(value)
    elseif kind == "function" then
        return "<function>"
    elseif kind == "table" then
        local details = {}
        pcall(function()
            if value.id ~= nil then
                table.insert(details, "id=" .. tostring(value.id))
            end
            if value.property ~= nil then
                table.insert(details, "property=" .. tostring(value.property))
            end
            if value.Name ~= nil then
                table.insert(details, "Name=" .. tostring(value.Name))
            end
        end)
        if #details > 0 then
            return "<table " .. table.concat(details, ",") .. ">"
        end
        return "<table>"
    end

    local result = "<" .. kind .. ">"
    pcall(function()
        if type(typeof) == "function" and typeof(value) == "Instance" then
            result = "<Instance " .. tostring(value.Name)
                .. ":" .. tostring(value.ClassName) .. ">"
        end
    end)
    return result
end

function __DDCore.Args(args)
    local values = {}
    local limit = math.min(args.n or #args, 6)
    for i = 1, limit do
        values[#values + 1] = __DDCore.Value(args[i])
    end
    if (args.n or #args) > limit then
        values[#values + 1] = "..."
    end
    return table.concat(values, ", ")
end

function __DDCore.WrapFunction(original, label, mode)
    if type(original) ~= "function" then
        __DDCore.Log("WRAP SKIPPED: " .. tostring(label) .. " is " .. type(original))
        return original
    end

    local calls = 0
    local function wrapped(...)
        if not __DDCore.State.active then
            return original(...)
        end

        calls = calls + 1
        local args = __DDCore.Pack(...)

        if mode == "sample" then
            if calls == 1 or calls % 300 == 0 then
                __DDCore.Log("CALL " .. label .. " count=" .. tostring(calls)
                    .. " args=" .. __DDCore.Args(args))
            end
        elseif mode == "result" then
            if calls == 1 then
                __DDCore.Log("CALL " .. label .. " (first call) args=" .. __DDCore.Args(args))
            end
        else
            __DDCore.Log("CALL " .. label .. " args=" .. __DDCore.Args(args))
        end

        local ok, packedOrError = xpcall(function()
            return __DDCore.Pack(original(__DDCore.Unpack(args, 1, args.n)))
        end, __DDCore.Traceback)

        if not ok then
            local count = (__DDCore.State.errorCounts[label] or 0) + 1
            __DDCore.State.errorCounts[label] = count
            if count <= 5 or count % 100 == 0 then
                __DDCore.Log("THROW " .. label .. " count=" .. tostring(count)
                    .. "\n" .. tostring(packedOrError))
            end
            error(packedOrError, 0)
        end

        local results = packedOrError
        if mode == "result" then
            if results.n == 0 or results[1] == false or results[1] == nil then
                __DDCore.Log("RESULT " .. label .. " => " .. __DDCore.Args(results))
            elseif calls == 1 then
                __DDCore.Log("RESULT " .. label .. " => " .. __DDCore.Args(results))
            end
        elseif mode ~= "sample" then
            __DDCore.Log("RETURN " .. label .. " => " .. __DDCore.Args(results))
        end

        return __DDCore.Unpack(results, 1, results.n)
    end

    return wrapped
end

function __DDCore.WrapTable(target, key, label, mode)
    if type(target) ~= "table" then
        __DDCore.Log("WRAP SKIPPED: " .. tostring(label) .. " owner is " .. type(target))
        return
    end
    target[key] = __DDCore.WrapFunction(target[key], label, mode)
end


--// =========================================================
--// DEADEYE VERSION
--// ТЕКУЩАЯ ВЕРСИЯ: 1.246
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
local SCRIPT_VERSION = "1.248"
__DDCore.Log("SWAPTRACE|BOOT|version=" .. SCRIPT_VERSION .. "|focus=picker,toggle,snapshot,apply")
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
__DDCore.Log("BOOT checkpoint: LocalPlayer=" .. tostring(LocalPlayer) .. ", core services acquired")

-- Stop stale runtime components and log each cleanup attempt.
__DDCore.Log("BOOT: checking previous-instance cleanup hooks")
__DDCore.PreviousFOVFix = genv.DeadEyeFOVBodyVisibilityFix
if type(__DDCore.PreviousFOVFix) == "table"
    and type(__DDCore.PreviousFOVFix.Stop) == "function"
then
    __DDCore.CallCleanup("DeadEyeFOVBodyVisibilityFix.Stop", __DDCore.PreviousFOVFix.Stop)
else
    __DDCore.Log("BOOT CLEANUP SKIPPED: standalone FOV fix not present")
end

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

__DDCore.Log("BOOT: purging stale jump sensors")
__UI.__L.purgeStaleMainJumpSensors()
__DDCore.Log("BOOT: stale jump sensor purge returned")

__DDCore.CleanupHooks = {
    "DEADEYE_MAIN_SENSORS_CLEANUP",
    "DEADEYE_UNUSUAL_POV_TRANSPARENCY_CLEANUP",
    "DEADEYE_FOV_BODY_VISIBILITY_CLEANUP",
    "DEADEYE_FIRSTPERSON_HEAD_FIX_CLEANUP",
    "DEADEYE_MAIN_AIR_TURN_CLEANUP",
    "DEADEYE_REVERSE_LOOK_CLEANUP",
    "DEADEYE_RAGE_LOOK_CLEANUP",
    "UNUSUAL_SWAPPER_CLEANUP",
    "DEADEYE_PORTRAIT_CLEANUP",
    "DEADEYE_COSMETIC_CLEANUP",
    "EMOTE_SWAPPER_CLEANUP"
}

for _, cleanupName in ipairs(__DDCore.CleanupHooks) do
    local cleanupCallback = genv[cleanupName]
    if cleanupCallback then
        __DDCore.CallCleanup(cleanupName, cleanupCallback)
    else
        __DDCore.Log("BOOT CLEANUP SKIPPED: " .. cleanupName .. " not present")
    end
end

__DDCore.Log("BOOT: previous-instance cleanup sequence complete")
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
__DDCore.Log("INIT checkpoint: CharacterService/ClientItemService/EmoteService/Registry requires completed; types="
    .. type(__UI.CharacterService) .. "/" .. type(__UI.ClientItemService) .. "/" .. type(__UI.EmoteService) .. "/" .. type(Registry))
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
        benchTrimpEnabled = false,
        fovBodyVisibilityEnabled = false
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

    savedConfig.main.fovBodyVisibilityEnabled =
        savedConfig.main.fovBodyVisibilityEnabled == true

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
__UI.__L.addConnection = function(connection)
    table.insert(connections, connection)
end
__UI.__L.disconnectAll = function()
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
prepareOriginalModule = __DDCore.WrapFunction(prepareOriginalModule, "EMOTE.prepareOriginalModule")
prepareReplaceModule = __DDCore.WrapFunction(prepareReplaceModule, "EMOTE.prepareReplaceModule")
__DDCore.Log("INIT: wrapped emote resolver functions before module construction")
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
__DDCore.Log("INIT: loading external EmoteRuntime module")
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
__DDCore.Log("INIT checkpoint: EmoteRuntime API loaded; checkState=" .. type(EmoteRuntime.checkState)
    .. ", stopCustomEmote=" .. type(EmoteRuntime.stopCustomEmote))
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
__DDCore.Log("INIT: constructing ScreenGui")
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
__DDCore.Log("INIT checkpoint: ScreenGui parented; continuing UI construction")

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
            unusualIconCache[key] = image
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
local unusualPage
local unusualStatus
local categoryBar
local mainCategoryButton
local emoteCategoryButton
local unusualCategoryButton
local avatarCategoryButton
local otherCategoryButton
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
    appliedCharacter = nil,
    appliedTargets = nil,
    originalId = nil,
    replacementId = nil,
    --// Rule state:
    --// originalId/replacementId describe the configured swap only.
    --// currentEquippedId describes what the player actually has equipped.
    currentEquippedId = nil,
    nativeSnapshot = nil,
    --// Local-only visibility states for native welded cosmetic trees.
    --// Keep original Weld trees intact; recreate neither their joints nor their meshes.
    nativeWeldedStates = {},
    --// Native P1 particle state for the LIVE visual rig.
    --// The clean-game test showed active Unusual ParticleEmitters
    --// switching true -> false in P1. Preserve each emitter's
    --// exact 3P Enabled value so P3 restores only what was there.
    nativeParticleStates = {},
    nativeParticleRig = nil,
    nativeParticleRigs = {},
    nativeParticleConnection = nil,
    nativeParticleConnections = {},
    nativeParticleLastFirstPerson = nil,
    reapplyGeneration = 0,
    suppressOwnedTags = false,
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
                        __UI.__L.getUnusualIconFromData(
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

--// Current loadout API:
--// ReplicatedStorage.Client.Services.UserData.Inventory.Loadout
--// GetEquipped(slotKey) reads the authoritative client Inventory Store.
--// The old Shared.UserData.ClientHooks.useLoadout API is retained as fallback.
__DDCore.LoadoutCache = __DDCore.LoadoutCache or {}
__DDCore.LoadoutResolver = function(slotName)
    if not __DDCore.LoadoutSearchDone then
        __DDCore.LoadoutSearchDone = true

        local module = nil
        local moduleKind = nil
        local candidates = {}
        local userDataChildren = {}

        pcall(function()
            local client = ReplicatedStorage:FindFirstChild("Client")
            local services = client and client:FindFirstChild("Services")
            local servicesUserData = services and services:FindFirstChild("UserData")
            local inventory = servicesUserData and servicesUserData:FindFirstChild("Inventory")
            local currentLoadout = inventory and inventory:FindFirstChild("Loadout")

            if currentLoadout and currentLoadout:IsA("ModuleScript") then
                module = currentLoadout
                moduleKind = "Inventory.Loadout"
                candidates[#candidates + 1] = currentLoadout:GetFullName()
            end

            local shared = ReplicatedStorage:FindFirstChild("Shared")
            local userData = shared and shared:FindFirstChild("UserData")
            if userData then
                for _, child in ipairs(userData:GetChildren()) do
                    userDataChildren[#userDataChildren + 1] =
                        child.Name .. "[" .. child.ClassName .. "]"
                end
            end

            if not module then
                local hooks = userData and userData:FindFirstChild("ClientHooks")
                local legacy = hooks and hooks:FindFirstChild("useLoadout")
                if legacy and legacy:IsA("ModuleScript") then
                    module = legacy
                    moduleKind = "legacy useLoadout"
                    candidates[#candidates + 1] = legacy:GetFullName()
                end
            end
        end)

        __DDCore.LoadoutModule = module
        __DDCore.LoadoutModuleKind = moduleKind
        __DDCore.LoadoutAPI = nil

        if module then
            local ok, apiOrError = pcall(require, module)
            if ok and type(apiOrError) == "table" then
                __DDCore.LoadoutAPI = apiOrError
            else
                __DDCore.Log("LOADOUT API REQUIRE FAILED: path=" .. tostring(module)
                    .. ", error=" .. tostring(apiOrError))
            end
        end

        local api = __DDCore.LoadoutAPI
        if api
            and __DDCore.LoadoutModuleKind == "Inventory.Loadout"
            and type(api.Observe) == "function"
        then
            for _, observedSlot in ipairs({
                "UnusualSlot",
                "CosmeticSlot_1",
                "CosmeticSlot_2"
            }) do
                if not __DDCore.State.loadoutObserverCancels[observedSlot] then
                    local ok, cancelOrError = pcall(function()
                        return api.Observe(observedSlot, function(value)
                            if not __DDCore.State.active then
                                return
                            end

                            local numeric = tonumber(value) or 0
                            __DDCore.LoadoutCache[observedSlot] = numeric
                            __DDCore.Log("LOADOUT OBSERVE: source="
                                .. tostring(__DDCore.LoadoutModuleKind)
                                .. ", slot=" .. tostring(observedSlot)
                                .. ", id=" .. tostring(numeric))

                            if string.sub(observedSlot, 1, 13) == "CosmeticSlot_" then
                                local cosmeticIndex = tonumber(string.sub(observedSlot, 14))
                                if cosmeticIndex and type(cosmetic.setInitialOriginal) == "function" then
                                    pcall(cosmetic.setInitialOriginal, cosmeticIndex, numeric)
                                end
                            end
                        end)
                    end)

                    if ok and type(cancelOrError) == "function" then
                        __DDCore.State.loadoutObserverCancels[observedSlot] = cancelOrError
                    elseif not ok then
                        __DDCore.Log("LOADOUT OBSERVE FAILED: slot=" .. tostring(observedSlot)
                            .. ", error=" .. tostring(cancelOrError))
                    end
                end
            end
        end

        __DDCore.Log("LOADOUT RESOLVER DISCOVERY: module=" .. tostring(module)
            .. ", api=" .. tostring(moduleKind or "<none>")
            .. ", candidates=" .. (#candidates > 0 and table.concat(candidates, ";") or "<none>")
            .. ", API=" .. tostring(api ~= nil)
            .. ", GetEquipped=" .. tostring(api and type(api.GetEquipped) == "function" or false)
            .. ", GetEquippedFromSlot=" .. tostring(api and type(api.GetEquippedFromSlot) == "function" or false)
            .. ", Observe=" .. tostring(api and type(api.Observe) == "function" or false)
            .. ", UserData children=" .. (#userDataChildren > 0 and table.concat(userDataChildren, ";") or "<none>"))
    end

    local api = __DDCore.LoadoutAPI
    if api then
        local ok, value = pcall(function()
            if type(api.GetEquipped) == "function" then
                return api.GetEquipped(slotName)
            elseif type(api.GetEquippedFromSlot) == "function" then
                return api.GetEquippedFromSlot(slotName)
            end
            error("loadout API has neither GetEquipped nor GetEquippedFromSlot")
        end)

        if ok then
            -- The current API returns nil for an empty slot; treat that as ID 0.
            -- Do not resurrect a stale positive cache value after a genuine unequip.
            local numeric = tonumber(value) or 0
            __DDCore.LoadoutCache[slotName] = numeric
            return numeric
        end

        if not __DDCore.LoadoutCallFailureLogged then
            __DDCore.LoadoutCallFailureLogged = true
            __DDCore.Log("LOADOUT RESOLVER API FAILED: path=" .. tostring(__DDCore.LoadoutModule)
                .. ", api=" .. tostring(__DDCore.LoadoutModuleKind)
                .. ", error=" .. tostring(value))
        end
    end

    local cached = tonumber(__DDCore.LoadoutCache[slotName])
    if cached ~= nil then
        return cached
    end
    return 0
end

function cosmetic.getEquippedId(slot)
    return __DDCore.LoadoutResolver("CosmeticSlot_" .. tostring(slot))
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
                            __UI.__L.getUnusualIconFromData(
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

function cosmetic.refreshRigSingle(live, isAdditionalTarget)
    __DDCore.Log("COSMETIC.refreshRigSingle START: enabled=" .. tostring(cosmetic.enabled)
        .. ", refreshBusy=" .. tostring(cosmetic.refreshBusy)
        .. ", skinDescription=" .. tostring(cosmetic.skinDescription ~= nil)
        .. ", directAction1=" .. tostring(cosmetic.directAction[1])
        .. ", directAction2=" .. tostring(cosmetic.directAction[2]))
    if cosmetic.refreshBusy then
        __DDCore.Log("COSMETIC.refreshRig FAIL: refreshBusy was already true")
        return false
    end

    if not live
        or not live:IsA("Model")
        or live.Name ~= LocalPlayer.Name
        or not live.Parent
    then
        __DDCore.Log("COSMETIC.refreshRigSingle FAIL: target rig missing/invalid; live="
            .. tostring(live) .. ", playerName=" .. tostring(LocalPlayer.Name))
        return false
    end

    local humanoid =
        live:FindFirstChildOfClass(
            "Humanoid"
        )

    if not humanoid then
        __DDCore.Log("COSMETIC.refreshRig FAIL: Humanoid missing from live rig "
            .. tostring(live:GetFullName()))
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
            __DDCore.Log("COSMETIC.refreshRig FAIL: GetAppliedDescription failed; ok="
                .. tostring(descriptionOK) .. ", description=" .. tostring(description))
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
            __DDCore.Log("COSMETIC.refreshRig FAIL: HumanoidDescription:Clone failed; ok="
                .. tostring(cloneOK) .. ", clone=" .. tostring(clone))
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
        __DDCore.Log("COSMETIC.refreshRig FAIL: base rig missing; baseName="
            .. tostring(baseName) .. ", PlayerCache=" .. tostring(cache)
            .. ", playerCache=" .. tostring(playerCache)
            .. ", RigType=" .. tostring(humanoid.RigType))
        return false
    end

    local equippedUnusualId
    if not isAdditionalTarget then
        equippedUnusualId = UnusualFns.getEquippedUnusualId()
    end

    local restoreUnusualSwap =
        not isAdditionalTarget
        and unusualEnabled
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
        --// AddCosmetics(live, equipped) below rebuilds the native effect
        --// itself. Never snapshot/copy it back over the top while SWAP is OFF.
        restoreNativeUnusualId =
            tonumber(equippedUnusualId)
    end

    if restoreUnusualSwap then
        pcall(function()
            UnusualFns.removeOurUnusualFX()
        end)
        unusualActive = false
    end

    cosmetic.refreshBusy = true

    local success, refreshError =
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

            local useLoadout = {
                GetEquippedFromSlot = function(slotName)
                    return __DDCore.LoadoutResolver(slotName)
                end
            }

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
                        unusualRuntime.appliedCharacter =
                            UnusualFns.getUnusualPlayerCharacter()
                    end
                end)
            elseif restoreNativeUnusualId then
                --// AddCosmetics has just rebuilt the real currently equipped
                --// Unusual on this live model. Do not clone a second copy:
                --// repeated fallback copies made effects pile up and disappear
                --// when the game's rig/visibility code refreshed.
                local visibilityRefreshed = false
                pcall(function()
                    UnusualFns.removeNativeFallbackFX()
                    visibilityRefreshed =
                        __UI.__L.refreshNativeVisibilityAfterUnusualRestore() == true
                end)
                UnusualFns.traceSwap(
                    "NATIVE_UNUSUAL_KEEP_ADDCOSMETICS",
                    "id=" .. tostring(restoreNativeUnusualId)
                        .. "|visibilityRefreshed=" .. tostring(visibilityRefreshed),
                    UnusualFns.getUnusualVisualRig(),
                    UnusualFns.getUnusualPlayerCharacter()
                )
            end
        end)

    if success then
        __DDCore.Log("COSMETIC.refreshRig INTERNAL REBUILD OK")
    else
        __DDCore.Log("COSMETIC.refreshRig INTERNAL REBUILD FAILED: " .. tostring(refreshError))
    end

    cosmetic.skinCharacter =
        live

    cosmetic.refreshBusy = false

    return success
end

function cosmetic.getLiveRigModels()
    local result = {}
    local seen = {}
    local rigs = workspace:FindFirstChild("Rigs")
    if not rigs then
        return result
    end

    --// There can be multiple same-name Model children. Refresh each distinct
    --// instance because the game's active visual may not be FindFirstChild().
    for _, model in ipairs(rigs:GetChildren()) do
        if model:IsA("Model")
            and model.Name == LocalPlayer.Name
            and not seen[model]
        then
            seen[model] = true
            table.insert(result, model)
        end
    end

    return result
end

function cosmetic.refreshRig()
    if cosmetic.refreshBusy then
        __DDCore.Log("COSMETIC.refreshRig SKIP: refreshBusy was already true")
        return false
    end

    local targets = cosmetic.getLiveRigModels()
    if #targets == 0 then
        __DDCore.Log("COSMETIC.refreshRig FAIL: no matching Models under Workspace.Rigs")
        return false
    end

    local targetNames = {}
    for index, target in ipairs(targets) do
        local path = tostring(target)
        pcall(function()
            path = target:GetFullName()
        end)
        table.insert(targetNames, tostring(index) .. ":" .. path)
    end
    __DDCore.Log("COSMETIC.refreshRig TARGETS|count=" .. tostring(#targets)
        .. "|models=" .. table.concat(targetNames, ";"))

    local successCount = 0
    for index, target in ipairs(targets) do
        local ok, result = pcall(function()
            return cosmetic.refreshRigSingle(target, index > 1)
        end)

        if ok and result == true then
            successCount += 1
        elseif not ok then
            __DDCore.Log("COSMETIC.refreshRig TARGET FAILED|index="
                .. tostring(index) .. "|model=" .. tostring(target)
                .. "|error=" .. tostring(result))
        end
    end

    return successCount > 0
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
                            cosmetic.getLiveRigModels()[1]

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

    -- Viewport previews are visual-only. Some cosmetics bundle Scripts
    -- inside CharacterClassic (for example Head.Model.Script), which
    -- Roblox blocks from running under CoreGui/restricted containers.
    -- Remove them only from this preview clone, never from real cosmetics.
    for _, descendant in ipairs(visual:GetDescendants()) do
        if descendant:IsA("Script")
            or descendant:IsA("LocalScript")
        then
            pcall(function()
                descendant:Destroy()
            end)
        end
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
    return __DDCore.LoadoutResolver("UnusualSlot")
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
    local folder = workspace:FindFirstChild("Players")
    if folder then
        for _, character in ipairs(folder:GetChildren()) do
            if character:IsA("Model")
                and character.Name == LocalPlayer.Name
                and character.Parent
            then
                return character
            end
        end
    end

    local character = LocalPlayer.Character
    if character
        and character:IsA("Model")
        and character.Parent
    then
        return character
    end

    return nil
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
--// Resolve both live client-side representations of the local rig.
--// Most visuals live under Workspace.Rigs; the character/physics model can
--// live separately under Workspace.Players. Apply changes independently to
--// every distinct model that is currently available.
function UnusualFns.getUnusualTargetModels(visualRig, playerCharacter)
    local targets = {}
    local seen = {}
    local roleCounters = {
        Rigs = 0,
        Players = 0
    }

    local function add(model, role)
        if not model
            or not model:IsA("Model")
            or seen[model]
            or not model.Parent
        then
            return
        end

        seen[model] = true
        table.insert(targets, {
            model = model,
            role = role
        })
    end

    --// RigLife observed multiple distinct Models with the same name under
    --// Workspace.Rigs. Never resolve the local target using FindFirstChild.
    local rigsFolder = workspace:FindFirstChild("Rigs")
    if rigsFolder then
        for _, model in ipairs(rigsFolder:GetChildren()) do
            if model:IsA("Model") and model.Name == LocalPlayer.Name then
                roleCounters.Rigs += 1
                add(model, "Rigs#" .. tostring(roleCounters.Rigs))
            end
        end
    end

    local playersFolder = workspace:FindFirstChild("Players")
    if playersFolder then
        for _, model in ipairs(playersFolder:GetChildren()) do
            if model:IsA("Model") and model.Name == LocalPlayer.Name then
                roleCounters.Players += 1
                add(model, "Players#" .. tostring(roleCounters.Players))
            end
        end
    end

    --// Keep uncommon active targets such as MenuScene.VisualModel, but only
    --// when they are real, parented Instances rather than menu placeholders.
    add(visualRig, "visual")
    add(playerCharacter, "character")

    local character = LocalPlayer.Character
    if character and character.Parent then
        add(character, "local-character")
    end

    return targets
end

function UnusualFns.resolveUnusualTargetModel(role, visualRig, playerCharacter)
    if type(role) == "string" then
        local folderName, requestedIndex = string.match(role, "^(Rigs)#(%d+)$")
        if folderName and requestedIndex then
            local folder = workspace:FindFirstChild(folderName)
            local index = 0
            if folder then
                for _, model in ipairs(folder:GetChildren()) do
                    if model:IsA("Model") and model.Name == LocalPlayer.Name then
                        index += 1
                        if index == tonumber(requestedIndex) then
                            return model
                        end
                    end
                end
            end
        end

        folderName, requestedIndex = string.match(role, "^(Players)#(%d+)$")
        if folderName and requestedIndex then
            local folder = workspace:FindFirstChild(folderName)
            local index = 0
            if folder then
                for _, model in ipairs(folder:GetChildren()) do
                    if model:IsA("Model") and model.Name == LocalPlayer.Name then
                        index += 1
                        if index == tonumber(requestedIndex) then
                            return model
                        end
                    end
                end
            end
        end
    end

    if role == "visual" then
        return visualRig
    elseif role == "character" then
        return playerCharacter
    elseif role == "local-character" then
        local character = LocalPlayer.Character
        return character and character.Parent and character or nil
    end

    return nil
end

function UnusualFns.getUnusualTargetModelSet(visualRig, playerCharacter)
    local result = {}
    for _, target in ipairs(
        UnusualFns.getUnusualTargetModels(visualRig, playerCharacter)
    ) do
        result[target.model] = true
    end
    return result
end

function UnusualFns.sameUnusualTargetModelSet(first, second)
    if type(first) ~= "table" or type(second) ~= "table" then
        return false
    end

    for model in pairs(first) do
        if not second[model] then
            return false
        end
    end

    for model in pairs(second) do
        if not first[model] then
            return false
        end
    end

    return true
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

--// Compact Unusual-only trace. It records the actual model path selected
--// by the swapper, plus whether MenuView/Rigs/Players roots are present.
local function unusualTraceRootSummary(root)
    if not root then
        return "<nil>"
    end

    local counts = {
        bp = 0, att = 0, pe = 0, beam = 0, trail = 0,
        weld = 0, motor = 0
    }
    local ok, descendants = pcall(function()
        return root:GetDescendants()
    end)
    if not ok then
        return pathOf and tostring(root) or "<unreadable>"
    end

    for _, object in ipairs(descendants) do
        if object:IsA("BasePart") then counts.bp += 1 end
        if object:IsA("Attachment") then counts.att += 1 end
        if object:IsA("ParticleEmitter") then counts.pe += 1 end
        if object:IsA("Beam") then counts.beam += 1 end
        if object:IsA("Trail") then counts.trail += 1 end
        if object:IsA("Weld") or object:IsA("WeldConstraint") then counts.weld += 1 end
        if object:IsA("Motor6D") then counts.motor += 1 end
    end

    local objectPath = tostring(root)
    pcall(function() objectPath = root:GetFullName() end)

    return objectPath
        .. "{d=" .. tostring(#descendants)
        .. ",bp=" .. tostring(counts.bp)
        .. ",att=" .. tostring(counts.att)
        .. ",pe=" .. tostring(counts.pe)
        .. ",beam=" .. tostring(counts.beam)
        .. ",trail=" .. tostring(counts.trail)
        .. ",weld=" .. tostring(counts.weld)
        .. ",motor=" .. tostring(counts.motor) .. "}"
end

function UnusualFns.traceSwap(event, extra, suppliedVisualRig, suppliedPlayerCharacter)
    local visualRig = suppliedVisualRig
    if not visualRig then
        pcall(function()
            visualRig = UnusualFns.getUnusualVisualRig()
        end)
    end

    local playerCharacter = suppliedPlayerCharacter
    if not playerCharacter then
        pcall(function()
            playerCharacter = UnusualFns.getUnusualPlayerCharacter()
        end)
    end

    local menuView = workspace:FindFirstChild("MenuView")
    local rigsFolder = workspace:FindFirstChild("Rigs")
    local playersFolder = workspace:FindFirstChild("Players")
    local rigsLocal = rigsFolder and rigsFolder:FindFirstChild(LocalPlayer.Name)
    local playersLocal = playersFolder and playersFolder:FindFirstChild(LocalPlayer.Name)

    local context = "NO_MODEL"
    if visualRig then
        if menuView and (visualRig == menuView or visualRig:IsDescendantOf(menuView)) then
            context = "MENU_VIEW"
        elseif rigsFolder and (visualRig == rigsFolder or visualRig:IsDescendantOf(rigsFolder)) then
            context = "WORKSPACE_RIGS"
        elseif playersFolder and (visualRig == playersFolder or visualRig:IsDescendantOf(playersFolder)) then
            context = "WORKSPACE_PLAYERS"
        elseif LocalPlayer.Character == visualRig then
            context = "LOCAL_CHARACTER"
        else
            context = "OTHER_MODEL"
        end
    end

    local equippedId = "<unreadable>"
    pcall(function()
        equippedId = tostring(UnusualFns.getEquippedUnusualId())
    end)

    __DDCore.Log(
        "SWAPTRACE|event=" .. tostring(event)
        .. "|context=" .. context
        .. "|original=" .. tostring(unusualSlot.originalId)
        .. "|replacement=" .. tostring(unusualSlot.replaceId)
        .. "|equipped=" .. equippedId
        .. "|enabled=" .. tostring(unusualEnabled)
        .. "|active=" .. tostring(unusualActive)
        .. "|MenuView=" .. tostring(menuView ~= nil)
        .. "|RigsLocal=" .. tostring(rigsLocal ~= nil)
        .. "|PlayersLocal=" .. tostring(playersLocal ~= nil)
        .. "|visual=" .. unusualTraceRootSummary(visualRig)
        .. "|character=" .. unusualTraceRootSummary(playerCharacter)
        .. "|extra=" .. tostring(extra or "-")
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
    local suppressOwnership = unusualRuntime.suppressOwnedTags == true

    local function applyTag(target)
        pcall(function()
            if suppressOwnership then
                target:SetAttribute("DeadEyeUnusualFX", nil)
                target:SetAttribute("DeadEyeUnusualFXID", nil)
                target:SetAttribute("DeadEyeNativeFallback", true)
            else
                target:SetAttribute("DeadEyeNativeFallback", nil)
                target:SetAttribute("DeadEyeUnusualFX", true)
                target:SetAttribute("DeadEyeUnusualFXID", id)
            end
        end)
    end

    applyTag(object)
    for _, descendant in ipairs(object:GetDescendants()) do
        applyTag(descendant)
    end
end

-- Remove only explicit backup copies built by DeadEye after native snapshot
-- recovery failed. Unlike the old untagged fallback, this cannot be confused
-- with the game's own native effect.
function UnusualFns.removeNativeFallbackFX()
    local roots = {}
    local seenRoots = {}

    local function addRoot(root)
        if root and not seenRoots[root] then
            seenRoots[root] = true
            table.insert(roots, root)
        end
    end

    for _, name in ipairs({"Rigs", "Players", "MenuView", "DeadEyeUnusualVisuals"}) do
        addRoot(workspace:FindFirstChild(name))
    end

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        addRoot(playerGui:FindFirstChild("DeadEyeUnusualRuntime"))
    end

    local destroyed = 0
    for _, root in ipairs(roots) do
        local objects = {}
        pcall(function()
            for _, object in ipairs(root:GetDescendants()) do
                table.insert(objects, object)
            end
        end)

        for _, object in ipairs(objects) do
            local isFallback = false
            pcall(function()
                isFallback = object:GetAttribute("DeadEyeNativeFallback") == true
            end)

            if isFallback then
                local parentFallback = false
                pcall(function()
                    parentFallback = object.Parent
                        and object.Parent:GetAttribute("DeadEyeNativeFallback") == true
                end)

                if not parentFallback then
                    pcall(function()
                        object:Destroy()
                        destroyed += 1
                    end)
                end
            end
        end
    end

    return destroyed
end

-- Used only when the game has already removed the native original and there
-- is no usable snapshot. Recreate a visible backup that is explicitly marked
-- as DeadEye-owned fallback, never as the actual game-native instance.
function UnusualFns.applyNativeUnusualFallback(
    id,
    visualRig,
    playerCharacter,
    reason
)
    if not id or tonumber(id) == 0 then
        return false
    end

    local previousSuppress = unusualRuntime.suppressOwnedTags
    unusualRuntime.suppressOwnedTags = true

    local ok, result = pcall(function()
        return __UI.__L.applyUnusualFX(
            id,
            visualRig,
            playerCharacter
        )
    end)

    unusualRuntime.suppressOwnedTags = previousSuppress

    UnusualFns.traceSwap(
        ok and result and "NATIVE_FALLBACK_APPLIED" or "NATIVE_FALLBACK_FAILED",
        "id=" .. tostring(id)
            .. "|reason=" .. tostring(reason)
            .. "|pcall=" .. tostring(ok)
            .. "|result=" .. tostring(result),
        visualRig,
        playerCharacter
    )

    return ok and result == true
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

local unusualNestedJointCache = setmetatable(
    {},
    { __mode = "k" }
)

__UI.__L.unusualJointHasNestedBasePart = function(joint)

    local cached =
        unusualNestedJointCache[joint]

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

    unusualNestedJointCache[joint] =
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
                        root = root,
                        targetRig = targetRig,
                        id = id
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

    --// Two target models can request the same source mini-rig. This mirror
    --// follows the source in world space, so only one visible copy is needed.
    for _, mirror in ipairs(unusualRuntime.visualMirrors) do
        if mirror.source == sourceModel
            and tostring(mirror.id) == tostring(id)
            and mirror.model
            and mirror.model.Parent
        then
            return true
        end
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
            links = links,
            source = sourceModel,
            id = id
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

        --// Keep the cloned geometry as a connected subtree.
        --// Native Unusuals commonly store joints beside the MeshPart they
        --// connect, and other effects keep joints inside the geometry tree.
        --// Destroying every joint here breaks both layouts.
        for _, object in ipairs(
            anchor:GetDescendants()
        ) do

            if object:IsA("Script")
                or object:IsA("LocalScript")
                or object:IsA("ModuleScript")
                or object:IsA("AnimationController")
                or object:IsA("Animator")
            then

                pcall(function()
                    object:Destroy()
                end)

            end

        end

        --// Build a full instance map before the clone enters Workspace.
        --// This preserves nested BasePart transforms and rebinds internal
        --// Weld/Motor6D/Beam/Trail references to the cloned tree.
        local cloneMap = {}

        __UI.__L.mapUnusualCloneTree(
            sourcePart,
            anchor,
            cloneMap
        )

        for sourceObject, cloneObject in pairs(
            cloneMap
        ) do

            if sourceObject:IsA("BasePart")
                and cloneObject:IsA("BasePart")
            then

                pcall(function()
                    cloneObject.CFrame =
                        targetPart.CFrame
                        * sourceRoot.CFrame:ToObjectSpace(
                            sourceObject.CFrame
                        )
                end)

            end

        end

        __UI.__L.rebindUnusualCloneTree(
            sourcePart,
            anchor,
            cloneMap,
            sourceRoot,
            targetPart
        )

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

                        --// Resolve references outside the cloned subtree against live BaseParts.
                        --// FindFirstChild(name, true) is unsafe here: when a Weld and
                        --// its MeshPart share a name, Roblox may return the Weld first.
                        --// The old code then skipped the real BasePart and kept a stale
                        --// Part0/Part1 reference to an object detached by RigService.
                        if not reboundPart and targetPart then
                            local function matchesReferencePart(candidate)
                                if not candidate
                                    or not candidate:IsA("BasePart")
                                    or candidate.Name ~= originalPart.Name
                                then
                                    return false
                                end

                                --// For geometry, match the actual mesh rather than a
                                --// different same-named part elsewhere in the rig.
                                if originalPart:IsA("MeshPart") then
                                    if not candidate:IsA("MeshPart")
                                        or tostring(candidate.MeshId) ~= tostring(originalPart.MeshId)
                                        or tostring(candidate.TextureID) ~= tostring(originalPart.TextureID)
                                    then
                                        return false
                                    end
                                elseif candidate.ClassName ~= originalPart.ClassName
                                    and not (
                                        candidate == targetPart
                                        and candidate.Name == originalPart.Name
                                    )
                                then
                                    return false
                                end

                                return true
                            end

                            local function findReferencePart(root)
                                if not root then
                                    return nil
                                end

                                if root:IsA("BasePart")
                                    and matchesReferencePart(root)
                                then
                                    return root
                                end

                                for _, candidate in ipairs(root:GetDescendants()) do
                                    if matchesReferencePart(candidate) then
                                        return candidate
                                    end
                                end

                                return nil
                            end

                            --// Search the host limb first, then its live rig.
                            reboundPart = findReferencePart(targetPart)

                            if not reboundPart and targetPart.Parent then
                                reboundPart = findReferencePart(targetPart.Parent)
                            end
                        end

                        if reboundPart then
                            pcall(function()
                                cloneObject[property] = reboundPart
                            end)
                        elseif not originalPart.Parent
                            or (
                                sourcePart
                                and sourcePart.Parent
                                and originalPart:IsDescendantOf(sourcePart.Parent)
                            )
                        then
                            --// Never preserve a reference to a detached old/template part.
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
                object.LocalTransparencyModifier = 0
            end)
        elseif object:IsA("Script") then
            --// Match the native AddCosmetics behavior for scripts in cosmetics.
            pcall(function()
                object.Enabled = true
            end)
        end
    end

    UnusualFns.tagUnusualFX(clone, id)
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
                unusualRuntime.createVisualMirror(
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

                --// Map every descendant, not only the top-level MeshPart.
                --// Sibling joints on the source limb may reference a nested
                --// Neon/mesh/part several levels inside this geometry tree.
                local geometryMap = {}

                __UI.__L.mapUnusualCloneTree(
                    nested,
                    anchor,
                    geometryMap
                )

                for sourceObject, cloneObject in pairs(
                    geometryMap
                ) do
                    targetMap[sourceObject] = cloneObject
                end

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

    --// Recreate sibling joints that connect the body limb to geometry
    --// cloned above. In many cosmetic models, a Weld/Motor6D is a sibling
    --// of its Part rather than a descendant of that Part. Treat the whole
    --// relationship as a graph edge and resolve both endpoints by identity.
    for _, sourceJoint in ipairs(
        sourcePart:GetChildren()
    ) do

        if __UI.__L.isUnusualJointObject(sourceJoint)
            and not __UI.__L.unusualJointHasNestedBasePart(sourceJoint)
        then

            local sourcePart0
            local sourcePart1

            pcall(function()
                sourcePart0 = sourceJoint.Part0
                sourcePart1 = sourceJoint.Part1
            end)

            local clonedPart0 =
                sourcePart0 and targetMap[sourcePart0]

            local clonedPart1 =
                sourcePart1 and targetMap[sourcePart1]

            if clonedPart0
                and clonedPart1
                and clonedPart0:IsA("BasePart")
                and clonedPart1:IsA("BasePart")
                and (
                    clonedPart0 ~= sourcePart0
                    or clonedPart1 ~= sourcePart1
                )
            then

                local clone
                local clonedOK = pcall(function()
                    clone = sourceJoint:Clone()
                    clone.Part0 = clonedPart0
                    clone.Part1 = clonedPart1
                    clone.Parent = targetPart
                end)

                if clonedOK and clone then

                    UnusualFns.tagUnusualFX(
                        clone,
                        id
                    )

                    --// If the native sibling joint already attaches the
                    --// top-level geometry root to this limb, use that joint's
                    --// real C0/C1 instead of keeping a second synthetic weld.
                    local mappedRoot

                    if sourcePart0 == sourcePart then
                        mappedRoot = clonedPart1
                    elseif sourcePart1 == sourcePart then
                        mappedRoot = clonedPart0
                    end

                    local isDirectGeometryRoot = false

                    if mappedRoot then
                        for _, child in ipairs(
                            sourcePart:GetChildren()
                        ) do
                            if child:IsA("BasePart")
                                and targetMap[child] == mappedRoot
                            then
                                isDirectGeometryRoot = true
                                break
                            end
                        end
                    end

                    if isDirectGeometryRoot then
                        for _, child in ipairs(
                            mappedRoot:GetChildren()
                        ) do
                            if child:IsA("WeldConstraint")
                                and child.Name == "DeadEyeUnusualWeld"
                            then
                                local weldPart0
                                local weldPart1

                                pcall(function()
                                    weldPart0 = child.Part0
                                    weldPart1 = child.Part1
                                end)

                                if (
                                    weldPart0 == targetPart
                                    and weldPart1 == mappedRoot
                                ) or (
                                    weldPart1 == targetPart
                                    and weldPart0 == mappedRoot
                                ) then
                                    pcall(function()
                                        child:Destroy()
                                    end)
                                end
                            end
                        end
                    end

                end

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

                    UnusualFns.tagUnusualFX(
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

                if UnusualFns.isUnusualFX(
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

__UI.__L.applyUnusualFX = function(
    id,
    visualRig,
    playerCharacter
)
    UnusualFns.traceSwap("APPLY_ENTER", "id=" .. tostring(id), visualRig, playerCharacter)

    local cosmeticRig =
        UnusualFns.getUnusualCosmeticRig(
            id,
            visualRig
        )

    if not cosmeticRig then
        UnusualFns.traceSwap(
            "APPLY_ABORT_NO_COSMETIC_MODEL",
            "id=" .. tostring(id) .. "|module/model resolution failed",
            visualRig,
            playerCharacter
        )
        warn("[UnusualSwapper] Cosmetic rig not found:", id)
        return false
    end

    local targets = UnusualFns.getUnusualTargetModels(visualRig, playerCharacter)
    if #targets == 0 then
        UnusualFns.traceSwap(
            "APPLY_ABORT_NO_TARGET_MODELS",
            "id=" .. tostring(id),
            visualRig,
            playerCharacter
        )
        return false
    end

    local targetSummary = {}
    for _, target in ipairs(targets) do
        local path = tostring(target.model)
        pcall(function()
            path = target.model:GetFullName()
        end)
        table.insert(targetSummary, tostring(target.role) .. ":" .. path)
    end

    UnusualFns.traceSwap(
        "APPLY_COSMETIC_MODEL",
        "id=" .. tostring(id)
            .. "|model=" .. cosmeticRig:GetFullName()
            .. "|children=" .. tostring(#cosmeticRig:GetChildren())
            .. "|descendants=" .. tostring(#cosmeticRig:GetDescendants())
            .. "|targets=" .. table.concat(targetSummary, ";"),
        visualRig,
        playerCharacter
    )

    --// Build one hidden animation source, then bind visible copies to each
    --// target model. This avoids resetting the shared animation source for
    --// every target while allowing both models to receive the same effect.
    local animatedSource =
        unusualRuntime.createAnimationSource(
            cosmeticRig,
            id,
            playerCharacter
        )

    local animatedNestedInstalled = 0
    for _, target in ipairs(targets) do
        local ok, count = pcall(function()
            return unusualRuntime.installAnimatedNestedModels(
                cosmeticRig,
                id,
                target.model,
                playerCharacter
            )
        end)

        if ok and type(count) == "number" then
            animatedNestedInstalled += count
        elseif not ok then
            __DDCore.Log("UNUSUAL APPLY NESTED ERROR: role="
                .. tostring(target.role) .. ", error=" .. tostring(count))
        end
    end

    local installedParts = 0
    for _, sourcePart in ipairs(cosmeticRig:GetChildren()) do
        if sourcePart:IsA("BasePart") then
            for _, target in ipairs(targets) do
                local targetPart =
                    target.model:FindFirstChild(sourcePart.Name)

                if targetPart and targetPart:IsA("BasePart") then
                    local ok, err = pcall(function()
                        __UI.__L.installUnusualPartFX(
                            sourcePart,
                            targetPart,
                            id,
                            animatedSource
                        )
                    end)

                    if ok then
                        installedParts += 1
                    else
                        __DDCore.Log("UNUSUAL APPLY PART ERROR: role="
                            .. tostring(target.role)
                            .. "|part=" .. tostring(sourcePart.Name)
                            .. "|error=" .. tostring(err))
                    end
                end
            end
        end
    end

    local applyResult =
        installedParts > 0
        or animatedNestedInstalled > 0

    UnusualFns.traceSwap(
        "APPLY_END",
        "id=" .. tostring(id)
            .. "|installedTargetParts=" .. tostring(installedParts)
            .. "|animatedNestedModels=" .. tostring(animatedNestedInstalled)
            .. "|targetModels=" .. tostring(#targets)
            .. "|result=" .. tostring(applyResult),
        visualRig,
        playerCharacter
    )

    return applyResult
end

--// =========================================================
--// REMOVE OUR FX
-- =========================================================
function UnusualFns.removeOurUnusualFX()
    unusualRuntime.destroyAnimationSource()
    pcall(function()
        UnusualFns.removeNativeFallbackFX()
    end)

    local removed = 0
    local roots = {}
    for _, target in ipairs(UnusualFns.getUnusualTargetModels(
        UnusualFns.getUnusualVisualRig(),
        UnusualFns.getUnusualPlayerCharacter()
    )) do
        table.insert(roots, target.model)
    end
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

--// Native Unusual geometry can use a Weld and its MeshPart as siblings
--// under the body limb. Preserve and repair links by instance identity,
--// not only by descendant-tree shape or name.
function UnusualFns.unusualJointReferencesPart(joint, sourcePart)
    if not joint or not sourcePart
        or not __UI.__L.isUnusualJointObject(joint)
    then
        return false
    end

    for _, property in ipairs({"Part0", "Part1"}) do
        local referencedPart
        pcall(function()
            referencedPart = joint[property]
        end)

        if referencedPart
            and referencedPart:IsA("BasePart")
            and referencedPart ~= sourcePart
        then
            local ok, isDescendant = pcall(function()
                return referencedPart:IsDescendantOf(sourcePart)
            end)
            if ok and isDescendant then
                return true
            end
        end
    end

    return false
end

function UnusualFns.unusualBasePartReferencedByJoint(sourcePart, basePart)
    if not sourcePart or not basePart then
        return false
    end

    for _, sibling in ipairs(sourcePart:GetChildren()) do
        if __UI.__L.isUnusualJointObject(sibling) then
            for _, property in ipairs({"Part0", "Part1"}) do
                local referencedPart
                pcall(function()
                    referencedPart = sibling[property]
                end)

                if referencedPart == basePart then
                    return true
                end
            end
        end
    end

    return false
end

function UnusualFns.repairNativeJointLinks(visualRig)
    if not visualRig then
        return 0
    end

    local repaired = 0

    local function isInsideRoot(instance)
        if not instance then
            return false
        end
        if instance == visualRig then
            return true
        end
        local ok, result = pcall(function()
            return instance:IsDescendantOf(visualRig)
        end)
        return ok and result
    end

    local function matchesPart(stalePart, candidate)
        if not stalePart or not candidate
            or not stalePart:IsA("BasePart")
            or not candidate:IsA("BasePart")
            or stalePart.Name ~= candidate.Name
            or stalePart.ClassName ~= candidate.ClassName
        then
            return false
        end

        if stalePart:IsA("MeshPart") then
            return tostring(stalePart.MeshId) == tostring(candidate.MeshId)
                and tostring(stalePart.TextureID) == tostring(candidate.TextureID)
        end

        return true
    end

    for _, joint in ipairs(visualRig:GetDescendants()) do
        if __UI.__L.isUnusualJointObject(joint)
            and joint.Parent
            and joint.Parent:IsA("BasePart")
        then
            local part0, part1
            pcall(function()
                part0 = joint.Part0
                part1 = joint.Part1
            end)

            -- Only repair a joint hosted by one of its endpoints. This avoids
            -- touching intentional cross-model joints such as the game's torso rig.
            local hostPart = joint.Parent
            local propertyToRepair
            local stalePart

            if part0 == hostPart then
                propertyToRepair = "Part1"
                stalePart = part1
            elseif part1 == hostPart then
                propertyToRepair = "Part0"
                stalePart = part0
            end

            if propertyToRepair
                and (not stalePart or not isInsideRoot(stalePart))
            then
                local searchRoot = hostPart.Parent or visualRig
                local bestCandidate

                if searchRoot then
                    for _, candidate in ipairs(searchRoot:GetDescendants()) do
                        local match = matchesPart(stalePart, candidate)

                        -- If the endpoint was cleared during restore, the joint
                        -- name is a fallback; candidates are still BaseParts only.
                        if not stalePart
                            and candidate ~= hostPart
                            and candidate:IsA("BasePart")
                            and candidate.Name == joint.Name
                        then
                            match = true
                        end

                        if match then
                            if candidate.Parent == hostPart
                                or candidate:IsDescendantOf(hostPart)
                            then
                                bestCandidate = candidate
                                break
                            end
                            if not bestCandidate then
                                bestCandidate = candidate
                            end
                        end
                    end
                end

                if bestCandidate then
                    local ok = pcall(function()
                        joint[propertyToRepair] = bestCandidate
                    end)
                    if ok then
                        repaired += 1
                    end
                end
            end
        end
    end

    return repaired
end

local unusualJointRepairQueued = setmetatable({}, {__mode = "k"})
function UnusualFns.queueNativeJointRepair(visualRig)
    if not visualRig or unusualJointRepairQueued[visualRig] then
        return
    end

    unusualJointRepairQueued[visualRig] = true
    task.defer(function()
        unusualJointRepairQueued[visualRig] = nil
        if visualRig and visualRig.Parent then
            pcall(function()
                UnusualFns.repairNativeJointLinks(visualRig)
            end)
        end
    end)
end

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

                if __UI.__L.isUnusualJointObject(object)
                    or object:IsA("CFrameValue")
                then

                    --// Record joint roots that contain actual nested geometry.
                    if __UI.__L.isUnusualJointObject(object)
                        and (
                            __UI.__L.unusualJointHasNestedBasePart(object)
                            or UnusualFns.unusualJointReferencesPart(object, sourcePart)
                        )
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

                    --// The sibling joint and this part form one native unit.
                    if object:IsA("BasePart")
                        and UnusualFns.unusualBasePartReferencedByJoint(sourcePart, object)
                    then
                        info.WholeTree = true
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
--// =========================================================
--// PRESERVE NATIVE WELDED COSMETIC TREES
--// =========================================================

--// Property-change guards close the one-frame visibility race observed in the trace:
--// the native cosmetic controller restores the old effect about 5ms after the swap
--// hides it. Re-hide the same native instances synchronously when their properties
--// are rewritten, rather than waiting for the next RenderStep.
function UnusualFns.installNativeWeldedVisibilityGuard(object, state)
    if not object
        or not state
        or state.guardConnections
    then
        return
    end

    local properties = {}

    if state.kind == "BasePart" then
        properties = { "Transparency", "LocalTransparencyModifier" }
    elseif state.kind == "LocalTransparencyModifier" then
        properties = { "LocalTransparencyModifier" }
    elseif state.kind == "Transparency" then
        properties = { "Transparency" }
    elseif state.kind == "Enabled" then
        properties = { "Enabled" }
    else
        return
    end

    state.guardConnections = {}
    state.guardBusy = false

    local function enforceHidden()
        if state.guardBusy
            or not object.Parent
            or unusualRuntime.nativeWeldedStates[object] ~= state
        then
            return
        end

        state.guardBusy = true

        pcall(function()
            if state.kind == "BasePart" then
                if object.Transparency ~= 1 then
                    object.Transparency = 1
                end
                if object.LocalTransparencyModifier ~= 1 then
                    object.LocalTransparencyModifier = 1
                end

            elseif state.kind == "LocalTransparencyModifier" then
                if object.LocalTransparencyModifier ~= 1 then
                    object.LocalTransparencyModifier = 1
                end

            elseif state.kind == "Transparency" then
                if object.Transparency ~= 1 then
                    object.Transparency = 1
                end

            elseif state.kind == "Enabled" then
                if object.Enabled ~= false then
                    object.Enabled = false

                    if object:IsA("ParticleEmitter")
                        or object:IsA("Trail")
                    then
                        object:Clear()
                    end
                end
            end
        end)

        state.guardBusy = false
    end

    for _, property in ipairs(properties) do
        local ok, connection = pcall(function()
            return object:GetPropertyChangedSignal(property):Connect(enforceHidden)
        end)

        if ok and connection then
            table.insert(state.guardConnections, connection)
        end
    end
end

function UnusualFns.hideNativeWeldedTree(rootJoint)
    if not rootJoint then
        return
    end

    local objects = { rootJoint }
    for _, descendant in ipairs(rootJoint:GetDescendants()) do
        table.insert(objects, descendant)
    end

    local states = unusualRuntime.nativeWeldedStates

    for _, object in ipairs(objects) do
        if object:IsA("BasePart") then
            if states[object] == nil then
                local oldModifier = 0
                local oldTransparency = 0

                pcall(function()
                    oldModifier = object.LocalTransparencyModifier
                    oldTransparency = object.Transparency
                end)

                states[object] = {
                    kind = "BasePart",
                    localTransparencyModifier = oldModifier,
                    transparency = oldTransparency
                }
            end

            --// Hide geometry through both channels. Some live-round visuals
            --// have their LocalTransparencyModifier refreshed by native rig code.
            pcall(function()
                object.LocalTransparencyModifier = 1
                object.Transparency = 1
            end)

        elseif object:IsA("Decal")
            or object:IsA("Texture")
        then
            if states[object] == nil then
                local oldTransparency = 0
                pcall(function()
                    oldTransparency = object.Transparency
                end)
                states[object] = {
                    kind = "Transparency",
                    value = oldTransparency
                }
            end

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
            or object:IsA("SurfaceGui")
            or object:IsA("PointLight")
            or object:IsA("SpotLight")
            or object:IsA("SurfaceLight")
        then
            if states[object] == nil then
                local oldEnabled = true
                pcall(function()
                    oldEnabled = object.Enabled
                end)
                states[object] = {
                    kind = "Enabled",
                    value = oldEnabled
                }
            end

            pcall(function()
                object.Enabled = false
            end)

            --// Disabling stops future emission; clear already-rendered trails
            --// and particles too, so the old effect vanishes on this switch.
            if object:IsA("ParticleEmitter")
                or object:IsA("Trail")
            then
                pcall(function()
                    object:Clear()
                end)
            end
        end

        local trackedState = states[object]
        if trackedState then
            UnusualFns.installNativeWeldedVisibilityGuard(
                object,
                trackedState
            )
        end
    end
end

function UnusualFns.restoreNativeWeldedTreeStates()
    local states = unusualRuntime.nativeWeldedStates

    --// Disconnect the immediate-hide guards before restoring saved values.
    for _, state in pairs(states) do
        if state.guardConnections then
            for _, connection in ipairs(state.guardConnections) do
                pcall(function()
                    connection:Disconnect()
                end)
            end
            state.guardConnections = nil
        end
    end

    for object, state in pairs(states) do
        pcall(function()
            if state.kind == "BasePart" then
                object.LocalTransparencyModifier =
                    state.localTransparencyModifier
                object.Transparency =
                    state.transparency
            elseif state.kind == "LocalTransparencyModifier" then
                --// Backward compatibility with states saved by older versions.
                object.LocalTransparencyModifier = state.value
            elseif state.kind == "Enabled" then
                object.Enabled = state.value
            elseif state.kind == "Transparency" then
                object.Transparency = state.value
            end
        end)
    end

    table.clear(states)
end

--// Keep the original Unusual hidden while a replacement is active.
--// The game's cosmetic controller may periodically re-enable emitters or
--// rewrite part visibility after the one-time swap. Reassert only the objects
--// recorded by hideNativeWeldedTree, so replacement-owned visuals stay intact.
function UnusualFns.enforceNativeWeldedTreeHidden()
    if not unusualActive
        or not unusualRuntime.originalId
    then
        return
    end

    for object, state in pairs(unusualRuntime.nativeWeldedStates) do
        if object and object.Parent then
            pcall(function()
                if state.kind == "BasePart" then
                    object.LocalTransparencyModifier = 1
                    object.Transparency = 1

                elseif state.kind == "LocalTransparencyModifier" then
                    --// Backward compatibility with an in-memory state
                    --// created by an older script revision.
                    object.LocalTransparencyModifier = 1

                elseif state.kind == "Transparency" then
                    object.Transparency = 1

                elseif state.kind == "Enabled" then
                    local wasEnabled = object.Enabled
                    object.Enabled = false

                    if wasEnabled
                        and (
                            object:IsA("ParticleEmitter")
                            or object:IsA("Trail")
                        )
                    then
                        object:Clear()
                    end
                end
            end)
        end
    end
end

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

    local targets = UnusualFns.getUnusualTargetModels(visualRig, playerCharacter)

    --// Hide the native original on every distinct target model, not just
    --// Rigs plus the special-case HumanoidRootPart under Players.
    for partName, objects in pairs(signature) do
        for _, target in ipairs(targets) do
            local targetPart = target.model:FindFirstChild(partName)

            if targetPart and targetPart:IsA("BasePart") then
                for _, existing in ipairs(targetPart:GetDescendants()) do
                    for _, info in ipairs(objects) do
                        local match = false
                        local deadEyeOwned = false
                        pcall(function()
                            deadEyeOwned =
                                existing:GetAttribute("DeadEyeUnusualFX") == true
                                or existing:GetAttribute("DeadEyeNativeFallback") == true
                        end)

                        if not deadEyeOwned
                            and existing.ClassName == info.Class then
                            if existing:IsA("MeshPart") and info.MeshId then
                                match =
                                    existing.Name == info.Name
                                    and tostring(existing.MeshId) == info.MeshId
                                    and tostring(existing.TextureID) == info.TextureId
                            else
                                match = existing.Name == info.Name
                            end
                        end

                        if match then
                            --// Keep native instances and joints alive: the game can
                            --// cache those exact references while rebuilding a rig.
                            UnusualFns.hideNativeWeldedTree(existing)
                            break
                        end
                    end
                end

                for _, joint in ipairs(targetPart:GetDescendants()) do
                    if joint:IsA("Weld")
                        or joint:IsA("WeldConstraint")
                        or joint:IsA("Motor6D")
                        or joint:IsA("Motor")
                    then
                        for _, info in ipairs(objects) do
                            if joint.Name == info.Name and not info.WholeTree then
                                UnusualFns.hideNativeWeldedTree(joint)
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    --// Clean up only DeadEye-owned objects outside named body parts.
    for _, target in ipairs(targets) do
        for _, child in ipairs(target.model:GetChildren()) do
            local isBodyPart = false

            for partName in pairs(signature) do
                if child.Name == partName then
                    isBodyPart = true
                    break
                end
            end

            if not isBodyPart then
                local owned = false
                pcall(function()
                    owned = child:GetAttribute("DeadEyeUnusualFXID") ~= nil
                end)

                if owned then
                    pcall(function()
                        child:Destroy()
                    end)
                end
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
    playerCharacter,
    existingSnapshot
)
    local signature =
        UnusualFns.buildOriginalUnusualSignature(
            id,
            visualRig
        )

    if not signature then
        UnusualFns.traceSwap("SNAPSHOT_SIGNATURE_NIL", "id=" .. tostring(id), visualRig, playerCharacter)
        return nil
    end

    local signaturePartCount = 0
    local signatureObjectCount = 0
    for _, objects in pairs(signature) do
        signaturePartCount += 1
        signatureObjectCount += #objects
    end

    UnusualFns.traceSwap(
        "SNAPSHOT_SIGNATURE",
        "id=" .. tostring(id)
            .. "|parts=" .. tostring(signaturePartCount)
            .. "|objects=" .. tostring(signatureObjectCount),
        visualRig,
        playerCharacter
    )

    local snapshot = existingSnapshot or { parts = {} }
    local alreadyCaptured = {}
    local baselineByPart = {}

    -- Keep a per-limb record. A single saved limb must not mark the entire
    -- model as captured, otherwise later limbs/new models are silently skipped.
    for _, savedPart in ipairs(snapshot.parts or {}) do
        if savedPart.targetModel then
            alreadyCaptured[savedPart.targetModel] =
                alreadyCaptured[savedPart.targetModel] or {}
            alreadyCaptured[savedPart.targetModel][savedPart.partName] = true
        end

        if savedPart.partName
            and (
                #(savedPart.objects or {}) > 0
                or #(savedPart.joints or {}) > 0
            )
            and not baselineByPart[savedPart.partName]
        then
            baselineByPart[savedPart.partName] = savedPart
        end
    end

    local targets =
        UnusualFns.getUnusualTargetModels(visualRig, playerCharacter)

    local function clearOwnershipTags(root)
        if not root then
            return
        end
        local list = { root }
        pcall(function()
            for _, descendant in ipairs(root:GetDescendants()) do
                table.insert(list, descendant)
            end
        end)
        for _, object in ipairs(list) do
            pcall(function()
                object:SetAttribute("DeadEyeUnusualFX", nil)
                object:SetAttribute("DeadEyeUnusualFXID", nil)
                object:SetAttribute("DeadEyeNativeFallback", nil)
            end)
        end
    end

    local function cloneForTarget(source, targetPart)
        local clone
        pcall(function()
            clone = source:Clone()
        end)
        if not clone then
            return nil
        end

        -- Snapshot entries are baselines, never DeadEye-owned replacement FX.
        clearOwnershipTags(clone)

        pcall(function()
            local cloneMap = {}
            __UI.__L.mapUnusualCloneTree(source, clone, cloneMap)
            __UI.__L.rebindUnusualCloneTree(
                source,
                clone,
                cloneMap,
                nil,
                targetPart
            )
        end)
        return clone
    end

    local function isDeadEyeOwned(object)
        local owned = false
        pcall(function()
            owned = object:GetAttribute("DeadEyeUnusualFX") == true
        end)
        return owned
    end

    local function matchesObject(object, info)
        if isDeadEyeOwned(object)
            or object.ClassName ~= info.Class
            or object.Name ~= info.Name
        then
            return false
        end

        if object:IsA("MeshPart") and info.MeshId then
            return tostring(object.MeshId) == info.MeshId
                and tostring(object.TextureID) == info.TextureId
        end

        return true
    end

    -- Capture the original effect only once per exact model/limb. When a new
    -- duplicate rig appears, seed its snapshot from the previously saved clean
    -- baseline instead of cloning already-hidden/replacement objects from it.
    for partName, objects in pairs(signature) do
        for _, target in ipairs(targets) do
            local targetPart = target.model:FindFirstChild(partName)
            local capturedForModel = alreadyCaptured[target.model]

            if targetPart
                and targetPart:IsA("BasePart")
                and not (capturedForModel and capturedForModel[partName])
            then
                local partSnapshot = {
                    partName = partName,
                    targetRole = target.role,
                    targetModel = target.model,
                    objects = {},
                    joints = {}
                }

                local baseline =
                    existingSnapshot
                    and baselineByPart[partName]
                    or nil

                if baseline then
                    for _, savedObject in ipairs(baseline.objects or {}) do
                        local clone = cloneForTarget(savedObject, targetPart)
                        if clone then
                            table.insert(partSnapshot.objects, clone)
                        end
                    end

                    for _, savedJoint in ipairs(baseline.joints or {}) do
                        local clone = cloneForTarget(savedJoint, targetPart)
                        if clone then
                            table.insert(partSnapshot.joints, clone)
                        end
                    end
                else
                    for _, existing in ipairs(targetPart:GetChildren()) do
                        local matchedInfo = nil

                        for _, info in ipairs(objects) do
                            if matchesObject(existing, info) then
                                matchedInfo = info
                                break
                            end
                        end

                        if matchedInfo then
                            local clone = cloneForTarget(existing, targetPart)
                            if clone then
                                table.insert(partSnapshot.objects, clone)
                            end
                        end
                    end

                    for _, joint in ipairs(targetPart:GetChildren()) do
                        if not isDeadEyeOwned(joint)
                            and (
                                joint:IsA("Weld")
                                or joint:IsA("WeldConstraint")
                                or joint:IsA("Motor6D")
                                or joint:IsA("Motor")
                            )
                        then
                            for _, info in ipairs(objects) do
                                if joint.Name == info.Name and not info.WholeTree then
                                    local clone = cloneForTarget(joint, targetPart)
                                    if clone then
                                        table.insert(partSnapshot.joints, clone)
                                    end
                                    break
                                end
                            end
                        end
                    end
                end

                if #partSnapshot.objects > 0 or #partSnapshot.joints > 0 then
                    table.insert(snapshot.parts, partSnapshot)
                    alreadyCaptured[target.model] =
                        alreadyCaptured[target.model] or {}
                    alreadyCaptured[target.model][partName] = true
                end
            end
        end
    end

    if #snapshot.parts == 0 then
        UnusualFns.traceSwap(
            "SNAPSHOT_NO_TARGET_MATCHES",
            "id=" .. tostring(id)
                .. "|signatureParts=" .. tostring(signaturePartCount)
                .. "|signatureObjects=" .. tostring(signatureObjectCount)
                .. "|targetModels=" .. tostring(#targets)
                .. "|reason=no exact objects matched direct target children",
            visualRig,
            playerCharacter
        )
        return nil
    end

    local capturedObjects = 0
    local capturedJoints = 0
    for _, partSnapshot in ipairs(snapshot.parts) do
        capturedObjects += #(partSnapshot.objects or {})
        capturedJoints += #(partSnapshot.joints or {})
    end

    UnusualFns.traceSwap(
        "SNAPSHOT_CAPTURED",
        "id=" .. tostring(id)
            .. "|parts=" .. tostring(#snapshot.parts)
            .. "|objects=" .. tostring(capturedObjects)
            .. "|joints=" .. tostring(capturedJoints)
            .. "|targetModels=" .. tostring(#targets),
        visualRig,
        playerCharacter
    )

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
    local matchedObjects = 0
    local clonedObjects = 0
    local matchedJoints = 0
    local clonedJoints = 0
    local restoredTargets = {}

    local function clearOwnershipTags(root)
        if not root then
            return
        end
        local list = { root }
        pcall(function()
            for _, descendant in ipairs(root:GetDescendants()) do
                table.insert(list, descendant)
            end
        end)
        for _, object in ipairs(list) do
            pcall(function()
                object:SetAttribute("DeadEyeUnusualFX", nil)
                object:SetAttribute("DeadEyeUnusualFXID", nil)
                object:SetAttribute("DeadEyeNativeFallback", nil)
            end)
        end
    end

    local function copyVisualProperties(saved, current)
        if saved:IsA("BasePart") and current:IsA("BasePart") then
            pcall(function()
                current.Transparency = saved.Transparency
                current.LocalTransparencyModifier = saved.LocalTransparencyModifier
                current.CastShadow = saved.CastShadow
            end)
        end

        if (saved:IsA("Decal") or saved:IsA("Texture"))
            and (current:IsA("Decal") or current:IsA("Texture"))
        then
            pcall(function()
                current.Transparency = saved.Transparency
            end)
        end

        local enabledClass =
            saved:IsA("ParticleEmitter")
            or saved:IsA("Trail")
            or saved:IsA("Beam")
            or saved:IsA("Fire")
            or saved:IsA("Smoke")
            or saved:IsA("Sparkles")
            or saved:IsA("Highlight")
            or saved:IsA("BillboardGui")
            or saved:IsA("SurfaceGui")
            or saved:IsA("PointLight")
            or saved:IsA("SpotLight")
            or saved:IsA("SurfaceLight")

        if enabledClass then
            pcall(function()
                current.Enabled = saved.Enabled
            end)
        end

        if saved:IsA("ParticleEmitter") and current:IsA("ParticleEmitter") then
            pcall(function()
                current.LocalTransparencyModifier = saved.LocalTransparencyModifier
            end)
        end
    end

    local function findMatchingChild(parent, saved)
        if not parent then
            return nil
        end
        for _, current in ipairs(parent:GetChildren()) do
            local deadEyeOwned = false
            local fallbackOwned = false
            pcall(function()
                deadEyeOwned = current:GetAttribute("DeadEyeUnusualFX") == true
                fallbackOwned = current:GetAttribute("DeadEyeNativeFallback") == true
            end)

            if not deadEyeOwned
                and not fallbackOwned
                and current.Name == saved.Name
                and current.ClassName == saved.ClassName
            then
                if saved:IsA("MeshPart") then
                    local match = false
                    pcall(function()
                        match =
                            tostring(current.MeshId) == tostring(saved.MeshId)
                            and tostring(current.TextureID) == tostring(saved.TextureID)
                    end)
                    if match then
                        return current
                    end
                else
                    return current
                end
            end
        end
        return nil
    end

    local function restoreMatchedTree(savedRoot, currentRoot)
        copyVisualProperties(savedRoot, currentRoot)
        clearOwnershipTags(currentRoot)

        local used = {}
        for _, savedChild in ipairs(savedRoot:GetChildren()) do
            local currentChild = findMatchingChild(currentRoot, savedChild)
            if currentChild and not used[currentChild] then
                used[currentChild] = true
                restoreMatchedTree(savedChild, currentChild)
            end
        end
    end

    local function cloneIntoTarget(saved, targetPart)
        local clone
        local ok = pcall(function()
            clone = saved:Clone()
        end)
        if not ok or not clone then
            return false
        end

        local cloneMap = {}
        pcall(function()
            __UI.__L.mapUnusualCloneTree(saved, clone, cloneMap)
            __UI.__L.rebindUnusualCloneTree(
                saved,
                clone,
                cloneMap,
                nil,
                targetPart
            )
        end)
        clearOwnershipTags(clone)
        clone.Parent = targetPart
        return true
    end

    -- Build a clean baseline per body-part name. Snapshot targetModel references
    -- can point at a menu/old rig that is still parented but is no longer the
    -- model rendered by the game. Restore the saved baseline to EVERY current
    -- matching live target so whichever duplicate Rigs model is active has FX.
    local baselineByPartName = {}
    for _, partSnapshot in ipairs(snapshot.parts or {}) do
        if partSnapshot.partName
            and (
                #(partSnapshot.objects or {}) > 0
                or #(partSnapshot.joints or {}) > 0
            )
            and not baselineByPartName[partSnapshot.partName]
        then
            baselineByPartName[partSnapshot.partName] = partSnapshot
        end
    end

    local targets =
        UnusualFns.getUnusualTargetModels(visualRig, playerCharacter)

    for partName, partSnapshot in pairs(baselineByPartName) do
        for _, target in ipairs(targets) do
            local targetModel = target.model
            local targetPart =
                targetModel and targetModel:FindFirstChild(partName)

            if targetPart and targetPart:IsA("BasePart") then
                restoredTargets[tostring(targetModel) .. "|" .. tostring(partName)] = true

                for _, savedObject in ipairs(partSnapshot.objects or {}) do
                    local current = findMatchingChild(targetPart, savedObject)

                    if current then
                        restoreMatchedTree(savedObject, current)
                        matchedObjects += 1
                        restored = true
                    elseif cloneIntoTarget(savedObject, targetPart) then
                        clonedObjects += 1
                        restored = true
                    end
                end

                for _, savedJoint in ipairs(partSnapshot.joints or {}) do
                    local current = findMatchingChild(targetPart, savedJoint)

                    if current then
                        local map = {}
                        pcall(function()
                            __UI.__L.mapUnusualCloneTree(savedJoint, current, map)
                            __UI.__L.rebindUnusualCloneTree(
                                savedJoint,
                                current,
                                map,
                                nil,
                                targetPart
                            )
                        end)
                        clearOwnershipTags(current)
                        matchedJoints += 1
                        restored = true
                    elseif cloneIntoTarget(savedJoint, targetPart) then
                        clonedJoints += 1
                        restored = true
                    end
                end
            end
        end
    end

    for _, target in ipairs(
        UnusualFns.getUnusualTargetModels(visualRig, playerCharacter)
    ) do
        pcall(function()
            UnusualFns.repairNativeJointLinks(target.model)
        end)
    end

    UnusualFns.traceSwap(
        "SNAPSHOT_RESTORE_RESULT",
        "restored=" .. tostring(restored)
            .. "|matchedObjects=" .. tostring(matchedObjects)
            .. "|clonedObjects=" .. tostring(clonedObjects)
            .. "|matchedJoints=" .. tostring(matchedJoints)
            .. "|clonedJoints=" .. tostring(clonedJoints)
            .. "|targetParts=" .. tostring((function()
                local count = 0
                for _ in pairs(restoredTargets) do
                    count += 1
                end
                return count
            end)()),
        visualRig,
        playerCharacter
    )

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
            UnusualFns.restoreNativeWeldedTreeStates()
            UnusualFns.repairNativeJointLinks(visualRig)

            --// The game owns the currently equipped effect.
            --// Do not delete native geometry by matching old effect names.
            UnusualFns.bindNativeParticlePOV(
                visualRig
            )
        else
            UnusualFns.restoreNativeWeldedTreeStates()
        end

        unusualActive =
            false
        unusualRuntime.appliedRig =
            visualRig
        unusualRuntime.appliedCharacter =
            playerCharacter
        unusualRuntime.appliedTargets =
            UnusualFns.getUnusualTargetModelSet(visualRig, playerCharacter)
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

            UnusualFns.applyNativeUnusualFallback(
                originalId,
                visualRig,
                playerCharacter,
                "snapshot restore missed"
            )
        end

        --// Restore exact visibility/emission states of the untouched native Weld trees.
        UnusualFns.restoreNativeWeldedTreeStates()
        UnusualFns.repairNativeJointLinks(visualRig)

        --// The original effect is now the live effect again.
        --// Keep the same instant P1/P3 behavior on it.
        pcall(function()
            local refreshed =
                __UI.__L.refreshNativeVisibilityAfterUnusualRestore() == true
            UnusualFns.traceSwap(
                "NATIVE_VISIBILITY_REFRESH",
                "result=" .. tostring(refreshed),
                visualRig,
                playerCharacter
            )
        end)
        UnusualFns.bindNativeParticlePOV(
            visualRig
        )
    end

    unusualActive =
        false
    unusualRuntime.appliedRig =
        nil
    unusualRuntime.appliedCharacter =
        nil
    unusualRuntime.appliedTargets =
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
    UnusualFns.traceSwap("ACTIVATE_ENTER", "button/reapply path")
    if not unusualSlot.originalId
        or not unusualSlot.replaceId
    then
        __DDCore.Log("UNUSUAL FAIL: IDs missing; original="
            .. tostring(unusualSlot.originalId) .. ", replacement=" .. tostring(unusualSlot.replaceId))
        return false
    end
    if unusualSlot.originalId
        == unusualSlot.replaceId
    then
        __DDCore.Log("UNUSUAL FAIL: original and replacement IDs are identical: "
            .. tostring(unusualSlot.originalId))
        return false
    end

    local equippedId =
        UnusualFns.getEquippedUnusualId()

    if equippedId == 0
        or tonumber(equippedId)
            ~= tonumber(unusualSlot.originalId)
    then
        __DDCore.Log("UNUSUAL FAIL: equipped ID does not match selected original; equipped="
            .. tostring(equippedId) .. ", selectedOriginal=" .. tostring(unusualSlot.originalId)
            .. ", replacement=" .. tostring(unusualSlot.replaceId))
        return false
    end

    local visualRig =
        UnusualFns.getUnusualVisualRig()
    local playerCharacter =
        UnusualFns.getUnusualPlayerCharacter()
    UnusualFns.traceSwap(
        "ACTIVATE_TARGET",
        "target resolved",
        visualRig,
        playerCharacter
    )
    if not visualRig then
        __DDCore.Log("UNUSUAL FAIL: visual rig nil; playerCharacter=" .. tostring(playerCharacter)
            .. ", workspace.Rigs=" .. tostring(workspace:FindFirstChild("Rigs"))
            .. ", workspace.Players=" .. tostring(workspace:FindFirstChild("Players")))
        return false
    end

    local currentTargetSet =
        UnusualFns.getUnusualTargetModelSet(visualRig, playerCharacter)

    local sameOriginal =
        tonumber(unusualRuntime.originalId) == tonumber(equippedId)

    local snapshotForMerge =
        sameOriginal
        and unusualRuntime.nativeSnapshot
        and unusualRuntime.appliedTargets
        and unusualRuntime.nativeSnapshot
        or nil

    if not unusualRuntime.nativeSnapshot
        or not sameOriginal
        or unusualRuntime.appliedRig ~= visualRig
        or unusualRuntime.appliedCharacter ~= playerCharacter
        or not UnusualFns.sameUnusualTargetModelSet(
            currentTargetSet,
            unusualRuntime.appliedTargets
        )
    then
        UnusualFns.traceSwap("SNAPSHOT_CAPTURE_BEGIN", "id=" .. tostring(equippedId), visualRig, playerCharacter)
        local capturedSnapshot =
            UnusualFns.captureNativeUnusualSnapshot(
                equippedId,
                visualRig,
                playerCharacter,
                snapshotForMerge
            )

        if capturedSnapshot then
            unusualRuntime.nativeSnapshot = capturedSnapshot
        elseif not snapshotForMerge then
            unusualRuntime.nativeSnapshot = nil
        end
        local snap = unusualRuntime.nativeSnapshot
        local snapObjects = 0
        if snap then
            for _, partSnapshot in ipairs(snap.parts or {}) do
                snapObjects += #(partSnapshot.objects or {})
                snapObjects += #(partSnapshot.joints or {})
            end
        end
        UnusualFns.traceSwap(
            snap and "SNAPSHOT_CAPTURE_OK" or "SNAPSHOT_CAPTURE_NIL",
            "parts=" .. tostring(snap and #snap.parts or 0)
                .. "|objectsAndJoints=" .. tostring(snapObjects),
            visualRig,
            playerCharacter
        )
    end

    if not unusualRuntime.nativeSnapshot then
        __DDCore.Log("UNUSUAL FAIL: native snapshot nil; equipped=" .. tostring(equippedId)
            .. ", visualRig=" .. tostring(visualRig) .. ", playerCharacter=" .. tostring(playerCharacter))
        return false
    end

    --// Reset the previous replacement's POV state.
    UnusualFns.clearNativeParticlePOV(
        true
    )

    UnusualFns.removeOurUnusualFX()
    task.wait()
    UnusualFns.traceSwap("REMOVE_ORIGINAL_BEGIN", "id=" .. tostring(unusualSlot.originalId), visualRig, playerCharacter)
    UnusualFns.removeOriginalUnusualFX(
        unusualSlot.originalId,
        visualRig,
        playerCharacter
    )
    UnusualFns.traceSwap("REMOVE_ORIGINAL_END", "id=" .. tostring(unusualSlot.originalId), visualRig, playerCharacter)
    task.wait()
    UnusualFns.traceSwap("APPLY_REPLACEMENT_BEGIN", "id=" .. tostring(unusualSlot.replaceId), visualRig, playerCharacter)
    if not __UI.__L.applyUnusualFX(
        unusualSlot.replaceId,
        visualRig,
        playerCharacter
    ) then
        __DDCore.Log("UNUSUAL FAIL: applyUnusualFX returned false for replacement="
            .. tostring(unusualSlot.replaceId) .. ", original=" .. tostring(unusualSlot.originalId))
        --// Native Weld trees were kept in place; restore their exact states and any direct FX.
        UnusualFns.removeOurUnusualFX()
        task.wait()
        UnusualFns.restoreNativeUnusualSnapshot(
            unusualRuntime.nativeSnapshot,
            visualRig,
            playerCharacter
        )
        UnusualFns.restoreNativeWeldedTreeStates()
        pcall(function()
            __UI.__L.refreshNativeVisibilityAfterUnusualRestore()
        end)
        UnusualFns.bindNativeParticlePOV(
            visualRig
        )
        return false
    end
    unusualActive =
        true
    unusualRuntime.appliedRig =
        visualRig
    unusualRuntime.appliedCharacter =
        playerCharacter
    unusualRuntime.appliedTargets =
        UnusualFns.getUnusualTargetModelSet(visualRig, playerCharacter)
    unusualRuntime.originalId =
        equippedId
    unusualRuntime.currentEquippedId =
        equippedId
    unusualRuntime.replacementId =
        tonumber(unusualSlot.replaceId)

    __DDCore.Log("UNUSUAL ACTIVATE OK: equipped=" .. tostring(equippedId)
        .. ", replacement=" .. tostring(unusualSlot.replaceId)
        .. ", visualRig=" .. tostring(visualRig))

    --// Repair stale native links left by a preceding rig rebuild.
    UnusualFns.repairNativeJointLinks(visualRig)

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

    UnusualFns.traceSwap("REAPPLY_BEGIN", "picker change or rig refresh")
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

            local humanoid =
                visualRig
                and visualRig:FindFirstChildOfClass("Humanoid")

            if not humanoid then
                for _, target in ipairs(
                    UnusualFns.getUnusualTargetModels(visualRig, playerCharacter)
                ) do
                    humanoid = target.model:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        break
                    end
                end
            end

            --// Static Unusual FX can be applied to a visual-only rig even
            --// when it has no HumanoidRootPart. The root is only needed by
            --// optional animated sources, not by the whole swap operation.
            if visualRig
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

                if equippedId == 0 then
                    --// LoadoutResolver can briefly return 0 during menu-to-round
                    --// rig replacement. Do not treat that transient as unequipping.
                    UnusualFns.traceSwap(
                        "REAPPLY_WAIT_LOADOUT",
                        "equipped=0|attempt=" .. tostring(attempt)
                    )
                    task.wait(0.25)
                    continue
                end

                if tonumber(equippedId)
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

                    UnusualFns.restoreNativeWeldedTreeStates()
                    UnusualFns.repairNativeJointLinks(visualRig)

                    unusualActive = false
                    unusualEnabled = false
                    unusualRuntime.appliedRig = visualRig
                    unusualRuntime.appliedCharacter = playerCharacter
                    unusualRuntime.appliedTargets =
                        UnusualFns.getUnusualTargetModelSet(visualRig, playerCharacter)
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

                    local expected = true
                    local checkedRigTargets = 0
                    local hasGlobalMirror = false

                    for _, mirror in ipairs(unusualRuntime.visualMirrors) do
                        if tonumber(mirror.id) == tonumber(unusualSlot.replaceId)
                            and mirror.model
                            and mirror.model.Parent
                        then
                            hasGlobalMirror = true
                            break
                        end
                    end

                    for _, target in ipairs(
                        UnusualFns.getUnusualTargetModels(visualRig, playerCharacter)
                    ) do
                        if string.match(target.role or "", "^Rigs#") then
                            checkedRigTargets += 1

                            local hasReplacement =
                                UnusualFns.hasOurUnusualFX(
                                    target.model,
                                    unusualSlot.replaceId
                                )

                            local hasAnimatedNested = false
                            for _, animated in ipairs(unusualRuntime.animatedNestedVisuals) do
                                if animated.targetRig == target.model
                                    and tonumber(animated.id) == tonumber(unusualSlot.replaceId)
                                    and animated.model
                                    and animated.model.Parent
                                then
                                    hasAnimatedNested = true
                                    break
                                end
                            end

                            if not hasReplacement
                                and not hasAnimatedNested
                                and not hasGlobalMirror
                            then
                                expected = false
                            end
                        end
                    end

                    if checkedRigTargets == 0 then
                        expected =
                            hasGlobalMirror
                            or UnusualFns.hasOurUnusualFX(
                                visualRig,
                                unusualSlot.replaceId
                            )
                            or UnusualFns.hasOurUnusualFX(
                                playerCharacter,
                                unusualSlot.replaceId
                            )
                    end

                    if expected then
                        unusualRuntime.appliedRig =
                            visualRig
                        unusualRuntime.appliedCharacter =
                            playerCharacter
                        unusualRuntime.appliedTargets =
                            UnusualFns.getUnusualTargetModelSet(visualRig, playerCharacter)
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

__UI.__L.isStockUnusualPOVTransparencyObject = function(
    object
)
    if not object then
        return false
    end

    return unusualPovTransparencyClasses[
        object.ClassName
    ] == true
end

__UI.__L.forEachDeadEyeUnusualVisualObject = function(
    callback
)
    local roots = {}
    for _, target in ipairs(UnusualFns.getUnusualTargetModels(
        UnusualFns.getUnusualVisualRig(),
        UnusualFns.getUnusualPlayerCharacter()
    )) do
        table.insert(roots, target.model)
    end
    table.insert(roots, workspace:FindFirstChild("DeadEyeUnusualAnimatedVisuals"))
    table.insert(roots, workspace:FindFirstChild("DeadEyeUnusualVisuals"))

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

    if type(unusualRuntime.nativeParticleConnections) == "table" then
        for _, connection in ipairs(unusualRuntime.nativeParticleConnections) do
            pcall(function()
                connection:Disconnect()
            end)
        end
        table.clear(unusualRuntime.nativeParticleConnections)
    end

    unusualRuntime.nativeParticleConnection = nil

    if restore then
        for object, enabled in pairs(unusualRuntime.nativeParticleStates) do
            if object and object.Parent then
                pcall(function()
                    object.Enabled = enabled
                end)
            end
        end
    end

    table.clear(unusualRuntime.nativeParticleStates)
    table.clear(unusualRuntime.nativeParticleRigs)

    unusualRuntime.nativeParticleRig = nil
    unusualRuntime.nativeParticleLastFirstPerson = nil
end

function UnusualFns.bindNativeParticlePOV(
    visualRig
)
    UnusualFns.clearNativeParticlePOV(true)

    if not visualRig then
        return
    end

    local targets = UnusualFns.getUnusualTargetModels(
        visualRig,
        UnusualFns.getUnusualPlayerCharacter()
    )

    if #targets == 0 and visualRig.Parent then
        targets = {
            {model = visualRig, role = "visual"}
        }
    end

    unusualRuntime.nativeParticleRig = visualRig
    unusualRuntime.nativeParticleRigs = {}
    unusualRuntime.nativeParticleConnections = {}

    for _, target in ipairs(targets) do
        local root = target.model
        if root and root.Parent then
            unusualRuntime.nativeParticleRigs[root] = true

            for _, object in ipairs(root:GetDescendants()) do
                if object:IsA("ParticleEmitter")
                    and unusualRuntime.nativeParticleStates[object] == nil
                then
                    unusualRuntime.nativeParticleStates[object] = object.Enabled
                end
            end

            local connection = root.DescendantAdded:Connect(function(object)
                if not unusualRuntime.nativeParticleRigs[root] then
                    return
                end

                if object:IsA("BasePart")
                    or __UI.__L.isUnusualJointObject(object)
                then
                    UnusualFns.queueNativeJointRepair(root)
                end

                local firstPerson = false
                pcall(function()
                    firstPerson = UnusualFns.isUnusualFirstPerson()
                end)

                if object:IsA("ParticleEmitter") then
                    if unusualRuntime.nativeParticleStates[object] == nil then
                        unusualRuntime.nativeParticleStates[object] = object.Enabled
                    end

                    if firstPerson then
                        pcall(function()
                            object.Enabled = false
                            object:Clear()
                        end)
                    end
                elseif object:IsA("Trail") and firstPerson then
                    pcall(function()
                        object.Enabled = false
                        object:Clear()
                    end)
                end
            end)

            table.insert(unusualRuntime.nativeParticleConnections, connection)
            if root == visualRig then
                unusualRuntime.nativeParticleConnection = connection
            end
        end
    end
end

function UnusualFns.nativeParticleTargetsChanged(visualRig)
    local current = UnusualFns.getUnusualTargetModelSet(
        visualRig,
        UnusualFns.getUnusualPlayerCharacter()
    )

    if not UnusualFns.sameUnusualTargetModelSet(
        current,
        unusualRuntime.nativeParticleRigs
    ) then
        return true
    end

    return false
end

function UnusualFns.syncNativeParticlePOV(
    visualRig,
    firstPerson
)
    if not visualRig
        or not unusualRuntime.nativeParticleRigs[visualRig]
    then
        return
    end

    --// Register emitters created after binding on every duplicate rig.
    for root in pairs(unusualRuntime.nativeParticleRigs) do
        if root and root.Parent then
            for _, object in ipairs(root:GetDescendants()) do
                if object:IsA("ParticleEmitter")
                    and unusualRuntime.nativeParticleStates[object] == nil
                then
                    unusualRuntime.nativeParticleStates[object] = object.Enabled
                end
            end
        end
    end

    local enteredFirstPerson =
        firstPerson
        and unusualRuntime.nativeParticleLastFirstPerson ~= true

    local leftFirstPerson =
        not firstPerson
        and unusualRuntime.nativeParticleLastFirstPerson == true

    if leftFirstPerson then
        for object, enabled in pairs(unusualRuntime.nativeParticleStates) do
            if object and object.Parent then
                pcall(function()
                    object.Enabled = enabled
                end)
            else
                unusualRuntime.nativeParticleStates[object] = nil
            end
        end
    end

    for object, enabled in pairs(unusualRuntime.nativeParticleStates) do
        if object and object.Parent then
            pcall(function()
                if firstPerson then
                    local wasEnabled = object.Enabled
                    object.Enabled = false
                    if enteredFirstPerson or wasEnabled == true then
                        object:Clear()
                    end
                else
                    object.Enabled = enabled
                end
            end)
        else
            unusualRuntime.nativeParticleStates[object] = nil
        end
    end

    if firstPerson then
        for root in pairs(unusualRuntime.nativeParticleRigs) do
            if root and root.Parent then
                for _, object in ipairs(root:GetDescendants()) do
                    if object:IsA("Trail") then
                        pcall(function()
                            local wasEnabled = object.Enabled
                            object.Enabled = false
                            if enteredFirstPerson or wasEnabled == true then
                                object:Clear()
                            end
                        end)
                    end
                end
            end
        end
    end

    unusualRuntime.nativeParticleLastFirstPerson = firstPerson
end

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

    --// Run after the native cosmetic/visibility updates every frame.
    --// This prevents the original effect from reappearing during a round.
    UnusualFns.enforceNativeWeldedTreeHidden()
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
        if not UnusualFns.isUnusualPOVRuntimeActive() then
            UnusualFns.clearNativeParticlePOV(
                true
            )
            return
        end

        local gameplayRig =
            UnusualFns.getUnusualVisualRig()

        if gameplayRig
            and (
                unusualRuntime.nativeParticleRig ~= gameplayRig
                or UnusualFns.nativeParticleTargetsChanged(gameplayRig)
            )
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

                    local playerCharacter =
                        UnusualFns.getUnusualPlayerCharacter()

                    local currentTargetSet =
                        UnusualFns.getUnusualTargetModelSet(rig, playerCharacter)

                    local targetSetChanged =
                        not UnusualFns.sameUnusualTargetModelSet(
                            currentTargetSet,
                            unusualRuntime.appliedTargets
                        )

                    local expected = true
                    local checkedRigTargets = 0

                    for _, target in ipairs(
                        UnusualFns.getUnusualTargetModels(rig, playerCharacter)
                    ) do
                        if string.match(target.role or "", "^Rigs#") then
                            checkedRigTargets += 1

                            local hasReplacement =
                                UnusualFns.hasOurUnusualFX(
                                    target.model,
                                    unusualSlot.replaceId
                                )

                            local hasAnimatedNested = false
                            for _, animated in ipairs(unusualRuntime.animatedNestedVisuals) do
                                if animated.targetRig == target.model
                                    and tonumber(animated.id) == tonumber(unusualSlot.replaceId)
                                    and animated.model
                                    and animated.model.Parent
                                then
                                    hasAnimatedNested = true
                                    break
                                end
                            end

                            --// Some Unusuals are a single world-space visual mirror,
                            --// not child FX on the rig model itself.
                            local hasGlobalMirror = false
                            for _, mirror in ipairs(unusualRuntime.visualMirrors) do
                                if tonumber(mirror.id) == tonumber(unusualSlot.replaceId)
                                    and mirror.model
                                    and mirror.model.Parent
                                then
                                    hasGlobalMirror = true
                                    break
                                end
                            end

                            if not hasReplacement
                                and not hasAnimatedNested
                                and not hasGlobalMirror
                            then
                                expected = false
                            end
                        end
                    end

                    if checkedRigTargets == 0 then
                        expected =
                            (#unusualRuntime.animatedNestedVisuals > 0)
                            or UnusualFns.hasOurUnusualFX(
                                rig,
                                unusualSlot.replaceId
                            )
                    end

                    if unusualRuntime.appliedRig ~= rig
                        or unusualRuntime.appliedCharacter ~= playerCharacter
                        or targetSetChanged
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
        __UI.__L.collectCurrentUnusualIcons(
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
                        UnusualFns.traceSwap(
                            "PICKER_SELECT",
                            "side=" .. tostring(unusualPickerSide)
                                .. "|pickedID=" .. tostring(data.id)
                        )
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
                __UI.__L.cacheUnusualIconFromObject(
                    obj
                )

                UnusualFns.addUnusualConnection(
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
others.lastAppliedDescription = nil
others.appliedHumanoids = setmetatable({}, { __mode = "k" })
others.pendingHumanoids = setmetatable({}, { __mode = "k" })
others.originalDescriptionsByHumanoid = setmetatable({}, { __mode = "k" })
others.avatarSyncEnabled = false
others.avatarSyncConnections = {}
others.avatarSyncConnection = nil
others.fieldBoxes = {}
function others.getHumanoids()
    local result = {}
    local seen = {}

    local function add(humanoid)
        if humanoid
            and humanoid:IsA("Humanoid")
            and not seen[humanoid]
            and humanoid.Parent
        then
            seen[humanoid] = true
            table.insert(result, humanoid)
        end
    end

    local visualRig = UnusualFns.getUnusualVisualRig()
    local playerCharacter = UnusualFns.getUnusualPlayerCharacter()

    for _, target in ipairs(
        UnusualFns.getUnusualTargetModels(visualRig, playerCharacter)
    ) do
        add(target.model:FindFirstChildOfClass("Humanoid"))
    end

    return result
end
function others.getHumanoid()
    return others.getHumanoids()[1]
end

function others.captureOriginalDescriptionForHumanoid(humanoid)
    if not humanoid
        or not humanoid:IsA("Humanoid")
        or others.originalDescriptionsByHumanoid[humanoid]
    then
        return others.originalDescriptionsByHumanoid
            and others.originalDescriptionsByHumanoid[humanoid] ~= nil
    end

    local sourceDescription
    if humanoid == others.targetHumanoid and others.originalDescription then
        sourceDescription = others.originalDescription
    else
        local ok, description = pcall(function()
            return humanoid:GetAppliedDescription()
        end)
        if ok then
            sourceDescription = description
        end
    end

    if not sourceDescription then
        return false
    end

    local clone
    local ok = pcall(function()
        clone = sourceDescription:Clone()
    end)
    if not ok or not clone then
        return false
    end

    others.originalDescriptionsByHumanoid[humanoid] = clone
    return true
end

function others.applyDescriptionDirect(humanoid, description)
    if not humanoid or not humanoid.Parent or not description then
        return false
    end

    local clone
    pcall(function()
        clone = description:Clone()
    end)
    if not clone then
        return false
    end

    local ok = pcall(function()
        humanoid:ApplyDescriptionResetAsync(clone)
    end)
    if not ok then
        ok = pcall(function()
            humanoid:ApplyDescriptionReset(clone)
        end)
    end
    if not ok then
        ok = pcall(function()
            humanoid:ApplyDescriptionAsync(clone)
        end)
    end
    return ok
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
    local targetHumanoids = others.getHumanoids()

    for _, humanoid in ipairs(targetHumanoids) do
        others.captureOriginalDescriptionForHumanoid(humanoid)
    end

    for _, humanoid in ipairs(targetHumanoids) do
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
            others.appliedHumanoids[humanoid] = true
        end
    end
    if applied == 0 then
        --// Last compatibility fallback.
        for _, humanoid in ipairs(targetHumanoids) do
            local ok =
                pcall(function()
                    humanoid:ApplyDescriptionAsync(
                        description
                    )
                end)
            if ok then
                applied += 1
                others.appliedHumanoids[humanoid] = true
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

    local savedDescription
    pcall(function()
        savedDescription = description:Clone()
    end)
    if savedDescription then
        others.lastAppliedDescription = savedDescription
        others.avatarSyncEnabled = true
    end

    __DDCore.Log("AVATAR APPLY COMPLETE|humanoids=" .. tostring(#others.getHumanoids())
        .. "|applied=" .. tostring(applied)
        .. "|savedDescription=" .. tostring(savedDescription ~= nil))

    pcall(function()
        if others.status then
            others.status.Text =
                "Applied"
        end
    end)
    return true
end
--// Keep later-created copies of the local rig in sync after an Avatar edit.
function others.findLocalRigModel(instance)
    local current = instance
    while current and current ~= workspace do
        if current:IsA("Model")
            and current.Name == LocalPlayer.Name
            and current.Parent
            and (current.Parent.Name == "Rigs" or current.Parent.Name == "Players")
        then
            return current
        end
        current = current.Parent
    end
    return nil
end

function others.applyDescriptionToNewHumanoid(humanoid)
    if not humanoid
        or not humanoid:IsA("Humanoid")
        or not humanoid.Parent
        or others.appliedHumanoids[humanoid]
        or others.pendingHumanoids[humanoid]
        or not others.avatarSyncEnabled
        or not others.lastAppliedDescription
    then
        return
    end

    local model = others.findLocalRigModel(humanoid)
    if not model or humanoid.Parent ~= model then
        return
    end

    others.pendingHumanoids[humanoid] = true
    task.spawn(function()
        task.wait(0.15)
        if not others.avatarSyncEnabled
            or not humanoid.Parent
            or not model.Parent
            or not others.lastAppliedDescription
        then
            others.pendingHumanoids[humanoid] = nil
            return
        end

        others.captureOriginalDescriptionForHumanoid(humanoid)

        local description
        pcall(function()
            description = others.lastAppliedDescription:Clone()
        end)

        local succeeded = false
        if description then
            local ok = pcall(function()
                humanoid:ApplyDescriptionResetAsync(description)
            end)
            if not ok then
                ok = pcall(function()
                    humanoid:ApplyDescriptionReset(description)
                end)
            end
            if not ok then
                ok = pcall(function()
                    humanoid:ApplyDescriptionAsync(description)
                end)
            end
            succeeded = ok
        end

        if succeeded then
            others.appliedHumanoids[humanoid] = true
            __DDCore.Log("AVATAR AUTO-APPLIED|model=" .. tostring(model)
                .. "|humanoid=" .. tostring(humanoid))
        else
            __DDCore.Log("AVATAR AUTO-APPLY FAILED|model=" .. tostring(model))
        end

        others.pendingHumanoids[humanoid] = nil
    end)
end

local avatarRigAddedConnection = workspace.DescendantAdded:Connect(function(object)
    if object:IsA("Humanoid") then
        others.applyDescriptionToNewHumanoid(object)
    elseif object:IsA("Model")
        and object.Name == LocalPlayer.Name
        and object.Parent
        and (object.Parent.Name == "Rigs" or object.Parent.Name == "Players")
    then
        task.defer(function()
            if not object.Parent then
                return
            end
            local humanoid = object:FindFirstChildOfClass("Humanoid")
            if humanoid then
                others.applyDescriptionToNewHumanoid(humanoid)
            end
        end)
    end
end)
table.insert(others.avatarSyncConnections, avatarRigAddedConnection)
others.avatarSyncConnection = avatarRigAddedConnection
UnusualFns.addUnusualConnection(avatarRigAddedConnection)

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
    if not others.originalDescription
        and next(others.originalDescriptionsByHumanoid) == nil
    then
        return false
    end

    local restored = 0

    if not keepSnapshot then
        --// Stop auto-apply before restoring. Pending tasks check this flag.
        others.avatarSyncEnabled = false
        others.lastAppliedDescription = nil

        for _, connection in ipairs(others.avatarSyncConnections) do
            pcall(function()
                connection:Disconnect()
            end)
        end
        table.clear(others.avatarSyncConnections)
        others.avatarSyncConnection = nil
    end

    if keepSnapshot then
        for humanoid, description in pairs(others.originalDescriptionsByHumanoid) do
            if others.applyDescriptionDirect(humanoid, description) then
                restored += 1
            end
        end

        if restored == 0 and others.originalDescription then
            if others.applyDescription(others.originalDescription) then
                restored = 1
            end
        end

        if others.originalDescription then
            pcall(function()
                others.lastAppliedDescription = others.originalDescription:Clone()
            end)
            others.avatarSyncEnabled = others.lastAppliedDescription ~= nil
        end
        return restored > 0
    end

    --// Shutdown: restore each model to its own recorded native description.
    for humanoid, description in pairs(others.originalDescriptionsByHumanoid) do
        if others.applyDescriptionDirect(humanoid, description) then
            restored += 1
        end
    end

    --// Legacy fallback if the per-Humanoid map has not been populated.
    if restored == 0 and others.originalDescription then
        for _, humanoid in ipairs(others.getHumanoids()) do
            if others.applyDescriptionDirect(humanoid, others.originalDescription) then
                restored += 1
            end
        end
    end

    table.clear(others.originalDescriptionsByHumanoid)
    table.clear(others.appliedHumanoids)
    table.clear(others.pendingHumanoids)
    others.originalDescription = nil
    others.targetHumanoid = nil

    __DDCore.Log("AVATAR RESTORE|restoredHumanoids=" .. tostring(restored))
    return restored > 0
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
    fovBodyVisibilityEnabled = false,
    fovBodyVisibilityModule = nil,
    fovBodyVisibilityOriginalGetType = nil,
    fovBodyVisibilityHook = nil,
    fovBodyVisibilityToggle = nil,
    fovBodyVisibilityCleanup = nil,
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
mainJump.fovBodyVisibilityEnabled =
    savedConfig.main
    and savedConfig.main.fovBodyVisibilityEnabled == true
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
__UI.__L.mainConnect = function(connection)
    table.insert(
        mainJump.connections,
        connection
    )
end
__UI.__L.mainDisconnect = function()
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
        benchTrimpEnabled = mainJump.benchTrimpEnabled,
        fovBodyVisibilityEnabled = mainJump.fovBodyVisibilityEnabled
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

    savedConfig.main.fovBodyVisibilityEnabled =
        mainJump.fovBodyVisibilityEnabled == true

    pcall(function()
        saveSavedConfig()
    end)
end

--// =========================================================
--// FOV BODY VISIBILITY
--// Bypass only the native "FOV > 90 => None" check.
--// No hotkeys, render loops, or transparency writes.
--// =========================================================
function mainJump.restoreFOVBodyVisibility()
    local module =
        mainJump.fovBodyVisibilityModule

    local hook =
        mainJump.fovBodyVisibilityHook

    local original =
        mainJump.fovBodyVisibilityOriginalGetType

    if module
        and hook
        and original
        and module.GetType == hook
    then
        module.GetType = original
    end

    mainJump.fovBodyVisibilityEnabled = false
end

mainJump.fovBodyVisibilityCleanup = function()
    mainJump.restoreFOVBodyVisibility()

    if genv.DEADEYE_FOV_BODY_VISIBILITY_CLEANUP
        == mainJump.fovBodyVisibilityCleanup
    then
        genv.DEADEYE_FOV_BODY_VISIBILITY_CLEANUP = nil
    end
end

genv.DEADEYE_FOV_BODY_VISIBILITY_CLEANUP =
    mainJump.fovBodyVisibilityCleanup

function mainJump.setFOVBodyVisibilityEnabled(state, persist)
    state = state == true

    if state then
        if not mainJump.fovBodyVisibilityModule then
            local ok, module =
                pcall(function()
                    return require(
                        ReplicatedStorage
                            :WaitForChild("Objects")
                            :WaitForChild("Game")
                            :WaitForChild("Character")
                            :WaitForChild("Client")
                            :WaitForChild("Visibility")
                    )
                end)

            if ok
                and type(module) == "table"
                and type(module.GetType) == "function"
            then
                mainJump.fovBodyVisibilityModule = module
            else
                warn(
                    "[DeadEye] FOV Body Fix: failed to load Visibility module",
                    module
                )
                state = false
            end
        end

        local module =
            mainJump.fovBodyVisibilityModule

        if state and module then
            if not mainJump.fovBodyVisibilityHook then
                local original =
                    module.GetType

                if type(original) ~= "function" then
                    warn(
                        "[DeadEye] FOV Body Fix: Visibility.GetType is unavailable"
                    )
                    state = false
                else
                    mainJump.fovBodyVisibilityOriginalGetType =
                        original

                    mainJump.fovBodyVisibilityHook =
                        function(self)
                            if self.DataRegistry:Get("Scoped")
                                or self.DataRegistry:Get("Hidden")
                            then
                                return "None"
                            end

                            if self.Player.CameraMaxZoomDistance > 1 then
                                return "All"
                            end

                            if Players.LocalPlayer:GetAttribute("VR") then
                                return "VR"
                            end

                            -- Deliberately omit the native FOV > 90 check.
                            if self.DataRegistry:Get("DontShowFPCharacter") then
                                return "None"
                            end

                            local tool =
                                self.Parent.ToolProfile:GetCurrentTool()

                            if not tool then
                                return "None"
                            end

                            if self.DataRegistry:Get("LookBack") == true then
                                self.LastLookedBack = tick()
                                return "None"
                            end

                            if tick() - (self.LastLookedBack or 0) <= 0.4 then
                                return "None"
                            end

                            local speed =
                                self.DataRegistry:Get("Speed") or 1000

                            local adjustments =
                                tool.Info.Adjustments

                            return adjustments.BothArmsVisible == true
                                and speed <= 20
                                and "BothArms"
                                or (
                                    adjustments.LeftArmVisible == true
                                    and speed <= 20
                                    and "LeftArm"
                                    or "NoArms"
                                )
                        end
                end
            end

            if state then
                module.GetType =
                    mainJump.fovBodyVisibilityHook

                mainJump.fovBodyVisibilityEnabled = true
            end
        end
    end

    if not state then
        mainJump.fovBodyVisibilityEnabled = false
        mainJump.restoreFOVBodyVisibility()
    end

    if persist ~= false then
        mainJump.saveConfig()
        mainJump.saveEnabledStates()
    end

    mainJump.update()
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

__UI.__L.mainLookAngleDelta = function(target, current)
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

__UI.__L.reverseLookTween = function(
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
            __UI.__L.reverseLookTween(
                mainJump.reverseLookModeKnob,
                {
                    Position = knobPosition
                }
            )

            __UI.__L.reverseLookTween(
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

            __UI.__L.reverseLookTween(
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

            __UI.__L.reverseLookTween(
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
                __UI.__L.reverseLookTween(
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
                __UI.__L.reverseLookTween(
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

    if mainJump.fovBodyVisibilityToggle then
        if mainJump.fovBodyVisibilityEnabled then
            mainJump.fovBodyVisibilityToggle.Text =
                "ON"
            mainJump.fovBodyVisibilityToggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            mainJump.fovBodyVisibilityToggle.Text =
                "OFF"
            mainJump.fovBodyVisibilityToggle.BackgroundColor3 =
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

function mainJump.setCrouching(
    state,
    movementOverride
)
    local movement =
        movementOverride
        or mainJump.getCrouchMovement()

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
local CROUCH_SPAM_PREJUMP_MAX_HOLD = 0.35

function mainJump.armCrouchSpamPreJump()
    if not mainJump.crouchSpamEnabled
        or mainJump.crouchSpamPreJump
        or mainJump.crouchSpamState
    then
        return false
    end

    local humanoid =
        mainJump.humanoid

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

    mainJump.crouchSpamPreJump =
        true

    mainJump.crouchSpamPreJumpStartedAt =
        os.clock()

    mainJump.crouchSpamState =
        true

    mainJump.crouchSpamElapsed =
        0

    mainJump.setCrouching(true)

    return true
end

function mainJump.startCrouchSpam()
    if mainJump.crouchSpamConnection then
        return
    end

    mainJump.crouchSpamState =
        true

    mainJump.crouchSpamElapsed =
        0

    mainJump.crouchSpamPreJump =
        false

    mainJump.crouchSpamPreJumpStartedAt =
        0

    if not mainJump.setCrouching(true) then
        return
    end

    mainJump.crouchSpamConnection =
        RunService.PreSimulation:Connect(
            function(deltaTime)
                if not genv.DEADEYE_MAIN_RUNNING
                    or cleaned
                    or not mainJump.crouchSpamEnabled
                then
                    return
                end

                if mainJump.crouchSpamPreJump then
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
                        mainJump.crouchSpamPreJump =
                            false

                        mainJump.crouchSpamPreJumpStartedAt =
                            0

                        mainJump.crouchSpamState =
                            true

                        mainJump.crouchSpamElapsed =
                            0

                        mainJump.setCrouching(true)

                        return

                    elseif mainJump.crouchSpamPreJumpStartedAt > 0
                        and os.clock()
                            - mainJump.crouchSpamPreJumpStartedAt
                            > CROUCH_SPAM_PREJUMP_MAX_HOLD
                    then
                        --// Safety timeout. Resume normal ON/OFF spam.
                        mainJump.crouchSpamPreJump =
                            false

                        mainJump.crouchSpamPreJumpStartedAt =
                            0

                        mainJump.crouchSpamElapsed =
                            0

                    else
                        --// Still inside the real pre-Grounded window.
                        mainJump.crouchSpamState =
                            true

                        mainJump.crouchSpamElapsed =
                            0

                        mainJump.setCrouching(true)

                        return
                    end
                end

                --// Arm ONLY from Crouch Spam's own landing signal.
                --// No AutoJump mode / Legit / JumpReact dependency.
                if mainJump.armCrouchSpamPreJump() then
                    return
                end

                local delay =
                    math.max(
                        tonumber(
                            mainJump.crouchSpamDelay
                        ) or 0.03,
                        0.001
                    )

                mainJump.crouchSpamElapsed =
                    mainJump.crouchSpamElapsed
                    + math.max(
                        tonumber(deltaTime) or 0,
                        0
                    )

                while mainJump.crouchSpamElapsed >= delay do
                    mainJump.crouchSpamElapsed =
                        mainJump.crouchSpamElapsed
                        - delay

                    mainJump.crouchSpamState =
                        not mainJump.crouchSpamState

                    if not mainJump.setCrouching(
                        mainJump.crouchSpamState
                    )
                    then
                        return
                    end
                end
            end
        )
end

function mainJump.stopCrouchSpam()
    if mainJump.crouchSpamConnection then
        pcall(function()
            mainJump.crouchSpamConnection:Disconnect()
        end)

        mainJump.crouchSpamConnection =
            nil
    end

    mainJump.crouchSpamEnabled =
        false

    mainJump.crouchSpamState =
        false

    mainJump.crouchSpamElapsed =
        0

    mainJump.crouchSpamPreJump =
        false

    mainJump.crouchSpamPreJumpStartedAt =
        0

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
        and mainJump.crouchSpamConnection
    then
        return
    end

    mainJump.crouchSpamEnabled =
        true

    mainJump.startCrouchSpam()

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
local airTurnHotkeyKey =
    __UI.__L.mainFindKeyCode(
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
        __UI.__L.mainFindKeyCode(
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
    __UI.__L.mainFindKeyCode(
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
        __UI.__L.mainFindKeyCode(
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
    __UI.__L.mainFindKeyCode(
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
        __UI.__L.mainFindKeyCode(
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
    __UI.__L.mainFindKeyCode(
        mainJump.hotkeyName
    )
if jumpKey then
    mainJump.hotkeyName =
        jumpKey.Name
else
    mainJump.hotkeyName = "Z"
end
local hideKey =
    __UI.__L.mainFindKeyCode(
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
        __UI.__L.mainFindKeyCode(
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
        __UI.__L.mainFindKeyCode(
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

    mainJump.legitMovement = nil
    mainJump.legitHumanoid = nil
    mainJump.legitRoot = nil
    mainJump.legitActiveJumpReact = false
    mainJump.legitActiveJumpStartedAt = 0
    mainJump.legitGroundJumpUsed = false
    mainJump.legitClimbJumpUsed = false
    mainJump.legitPreviousHumanoidState = nil
end

function mainJump.legitSetupCharacter(
    object,
    movement,
    humanoid,
    root
)
    if mainJump.legitMovement == movement
        and mainJump.legitHumanoid == humanoid
    then
        return
    end

    mainJump.legitMovement =
        movement
    mainJump.legitHumanoid =
        humanoid
    mainJump.legitRoot =
        root

    mainJump.legitGroundJumpUsed = false
    mainJump.legitClimbJumpUsed = false
    mainJump.legitJumpSequence =
        (tonumber(mainJump.legitJumpSequence) or 0) + 1
    mainJump.legitActiveJumpReact = false
    mainJump.legitActiveJumpStartedAt = 0

    mainJump.legitPreviousHumanoidState =
        humanoid:GetState()
end

function mainJump.legitGetGrounded(
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

function mainJump.legitAutoRelease(
    movement,
    sequence
)
    RunService.Heartbeat:Wait()

    if not genv.DEADEYE_MAIN_RUNNING
        or cleaned
        or not mainJump.enabled
        or mainJump.autoJumpMode ~= "legit"
        or sequence ~= mainJump.legitJumpSequence
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

function mainJump.legitExecuteOriginalJumpReact(
    movement,
    reason
)
    if not genv.DEADEYE_MAIN_RUNNING
        or cleaned
        or not mainJump.enabled
        or mainJump.autoJumpMode ~= "legit"
        or mainJump.legitActiveJumpReact
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

    mainJump.legitActiveJumpReact = true
    mainJump.legitActiveJumpStartedAt = os.clock()

    mainJump.legitJumpSequence =
        (tonumber(mainJump.legitJumpSequence) or 0) + 1

    local sequence =
        mainJump.legitJumpSequence

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

        if mainJump.legitJumpSequence ~= sequence then
            return
        end

        mainJump.legitActiveJumpReact = false
        mainJump.legitActiveJumpStartedAt = 0
    end)

    task.spawn(function()
        mainJump.legitAutoRelease(
            movement,
            sequence
        )
    end)

    return true
end

function mainJump.legitTryGroundJump(
    movement
)
    if not genv.DEADEYE_MAIN_RUNNING
        or cleaned
        or not mainJump.enabled
        or mainJump.autoJumpMode ~= "legit"
        or mainJump.legitActiveJumpReact
        or mainJump.legitGroundJumpUsed
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
    if not mainJump.legitGetGrounded(
        movement
    ) then
        return
    end

    mainJump.legitGroundJumpCount =
        (tonumber(mainJump.legitGroundJumpCount) or 0) + 1

    mainJump.legitGroundJumpUsed =
        true

    mainJump.legitExecuteOriginalJumpReact(
        movement,
        "GROUND"
    )
end

function mainJump.legitTryClimbJump(
    movement
)
    if not genv.DEADEYE_MAIN_RUNNING
        or cleaned
        or not mainJump.enabled
        or mainJump.autoJumpMode ~= "legit"
        or mainJump.legitActiveJumpReact
        or mainJump.legitClimbJumpUsed
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

    mainJump.legitClimbJumpCount =
        (tonumber(mainJump.legitClimbJumpCount) or 0) + 1

    mainJump.legitClimbJumpUsed =
        true

    mainJump.legitExecuteOriginalJumpReact(
        movement,
        "NATURAL CLIMBING"
    )
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

                if mainJump.legitMovement ~= movement
                    or mainJump.legitHumanoid ~= humanoid
                then
                    mainJump.legitSetupCharacter(
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
                    mainJump.legitTryClimbJump(
                        movement
                    )
                else
                    --// GROUND.
                    mainJump.legitTryGroundJump(
                        movement
                    )
                end

                --// Re-arm one ground JumpReact on the next real Freefall.
                if state == Enum.HumanoidStateType.Freefall
                    and mainJump.legitGroundJumpUsed
                then
                    mainJump.legitGroundJumpUsed = false
                end

                --// Re-arm one Climbing JumpReact after leaving actual Climbing.
                if state ~= Enum.HumanoidStateType.Climbing
                    and mainJump.legitClimbJumpUsed
                    and mainJump.legitPreviousHumanoidState
                        == Enum.HumanoidStateType.Climbing
                then
                    mainJump.legitClimbJumpUsed = false
                end

                --// Same watchdog window as the standalone test.
                if mainJump.legitActiveJumpReact
                    and mainJump.legitActiveJumpStartedAt > 0
                    and os.clock()
                        - mainJump.legitActiveJumpStartedAt
                        > 0.35
                then
                    pcall(function()
                        movement.JumpHeldDown = false
                    end)

                    mainJump.legitActiveJumpReact = false
                    mainJump.legitActiveJumpStartedAt = 0
                end

                mainJump.legitPreviousHumanoidState =
                    state
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
    __UI.__L.mainRow(
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

__UI.__L.mainConnect(
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

__UI.__L.mainConnect(
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
__UI.__L.mainConnect(
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

__UI.__L.createAutoJumpModeOption = function(
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

    __UI.__L.mainConnect(
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

__UI.__L.mainConnect(
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
    __UI.__L.mainRow(
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
__UI.__L.mainConnect(
    mainJump.lookToggle.MouseButton1Click:Connect(
        function()
            mainJump.setLookEnabled(
                not mainJump.lookEnabled
            )
        end
    )
)

__UI.rageLookRow =
    __UI.__L.mainRow(
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

__UI.__L.mainConnect(
    mainJump.rageLookToggle.MouseButton1Click:Connect(
        function()
            mainJump.setRageLookEnabled(
                not mainJump.rageLookEnabled
            )
        end
    )
)

__UI.airTurnRow =
    __UI.__L.mainRow(
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

__UI.__L.mainConnect(
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
__UI.__L.mainConnect(
    mainJump.airTurnToggle.MouseButton1Click:Connect(
        function()
            mainJump.setAirTurnEnabled(
                not mainJump.airTurnEnabled
            )
        end
    )
)

__UI.smartAirTurnRow =
    __UI.__L.mainRow(
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

__UI.__L.mainConnect(
    mainJump.smartAirTurnToggle.MouseButton1Click:Connect(
        function()
            mainJump.setSmartAirTurnEnabled(
                not mainJump.smartAirTurnEnabled
            )
        end
    )
)

__UI.airTurnSpeedRow =
    __UI.__L.mainRow(
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

__UI.__L.updateAirTurnSliderFromX = function(x)
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

__UI.__L.mainConnect(
    mainJump.airTurnSliderTrack.InputBegan:Connect(
        function(input)
            if input.UserInputType
                == Enum.UserInputType.MouseButton1
            then
                airTurnSliderDragging =
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
            if not airTurnSliderDragging then
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
    __UI.__L.mainRow(
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

__UI.__L.mainConnect(
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

__UI.__L.mainConnect(
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

__UI.__L.mainConnect(
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
    __UI.__L.mainRow(
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

__UI.__L.mainConnect(
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

__UI.__L.mainConnect(
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
    __UI.__L.mainRow(
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

__UI.__L.mainConnect(
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

__UI.__L.mainConnect(
    mainJump.benchTrimpToggle.MouseButton1Click:Connect(
        function()
            mainJump.setBenchTrimpEnabled(
                not mainJump.benchTrimpEnabled
            )
        end
    )
)


__UI.fovBodyVisibilityRow =
    __UI.__L.mainRow(
        "FOV BODY FIX",
        11
    )

local fovBodyVisibilityLabel =
    autoLabel:Clone()
fovBodyVisibilityLabel.Text =
    "FOV BODY FIX"
fovBodyVisibilityLabel.Parent =
    __UI.fovBodyVisibilityRow

mainJump.fovBodyVisibilityToggle =
    Instance.new("TextButton")
mainJump.fovBodyVisibilityToggle.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
mainJump.fovBodyVisibilityToggle.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
mainJump.fovBodyVisibilityToggle.BackgroundColor3 =
    Color3.fromRGB(
        47,
        52,
        61
    )
mainJump.fovBodyVisibilityToggle.BorderSizePixel = 0
mainJump.fovBodyVisibilityToggle.Text =
    "OFF"
mainJump.fovBodyVisibilityToggle.TextSize = 10
mainJump.fovBodyVisibilityToggle.Font =
    Enum.Font.GothamBold
mainJump.fovBodyVisibilityToggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.fovBodyVisibilityToggle.Parent =
    __UI.fovBodyVisibilityRow

local fovBodyVisibilityToggleCorner =
    Instance.new("UICorner")
fovBodyVisibilityToggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
fovBodyVisibilityToggleCorner.Parent =
    mainJump.fovBodyVisibilityToggle

__UI.__L.mainConnect(
    mainJump.fovBodyVisibilityToggle.MouseButton1Click:Connect(
        function()
            mainJump.setFOVBodyVisibilityEnabled(
                not mainJump.fovBodyVisibilityEnabled
            )
        end
    )
)

--// HIDE UI MUST ALWAYS BE THE LOWEST / LAST ROW IN MAIN.
__UI.hideRow =
    __UI.__L.mainRow(
        "HIDE UI",
        12
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
__UI.__L.mainConnect(
    mainJump.hideUIHotkeyBox.MouseButton1Click:Connect(
        function()
            mainJump.startCapture(
                "hide"
            )
        end
    )
)

__UI.__L.mainConnect(
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
                == __UI.__L.mainFindKeyCode(
                    mainJump.hotkeyName
                )
            then
                mainJump.setEnabled(
                    not mainJump.enabled
                )
            end
            if input.KeyCode
                == __UI.__L.mainFindKeyCode(
                    mainJump.hideUIHotkeyName
                )
            then
                ScreenGui.Enabled =
                    not ScreenGui.Enabled
            end

            if input.KeyCode
                == __UI.__L.mainFindKeyCode(
                    mainJump.airTurnHotkeyName
                )
            then
                mainJump.setAirTurnEnabled(
                    not mainJump.airTurnEnabled
                )
            end

            if input.KeyCode
                == __UI.__L.mainFindKeyCode(
                    mainJump.crouchSpamHotkeyName
                )
            then
                mainJump.setCrouchSpamEnabled(
                    not mainJump.crouchSpamEnabled
                )
            end

            if input.KeyCode
                == __UI.__L.mainFindKeyCode(
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
__UI.__L.mainConnect(
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
__UI.__L.mainConnect(
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
__UI.__L.mainConnect(
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
__UI.__L.mainConnect(
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

if mainJump.fovBodyVisibilityEnabled then
    pcall(function()
        mainJump.setFOVBodyVisibilityEnabled(
            true,
            false
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

        __UI.__L.purgeStaleMainJumpSensors()
    end
--// =========================================================
--// AVATAR PAGE
--// =========================================================
others.page =
    Instance.new("ScrollingFrame")
others.page.Name =
    "AvatarPage"
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
    __DDCore.Log("AVATAR BODY PART START: property=" .. tostring(property)
        .. ", requestedAssetId=" .. tostring(assetId)
        .. ", isR6=" .. tostring(others.isR6()))
    local description =
        others.getDescription()
    if not description then
        __DDCore.Log("AVATAR BODY PART FAIL: getDescription returned nil")
        return false
    end
    local assignmentOK, assignmentError = pcall(function()
        description[property] =
            assetId
    end)
    local requestedValue = nil
    pcall(function()
        requestedValue = description[property]
    end)
    __DDCore.Log("AVATAR BODY PART ASSIGN: ok=" .. tostring(assignmentOK)
        .. ", error=" .. tostring(assignmentError)
        .. ", description[" .. tostring(property) .. "]=" .. tostring(requestedValue))

    local applied = others.applyDescription(description)
    __DDCore.Log("AVATAR BODY PART APPLY returned=" .. tostring(applied))

    for index, humanoid in ipairs(others.getHumanoids()) do
        local readOK, appliedDescription = pcall(function()
            return humanoid:GetAppliedDescription()
        end)
        if readOK and appliedDescription then
            local actualValue = nil
            pcall(function()
                actualValue = appliedDescription[property]
            end)
            __DDCore.Log("AVATAR BODY PART READBACK: humanoid#" .. tostring(index)
                .. " name=" .. tostring(humanoid:GetFullName())
                .. ", property=" .. tostring(property)
                .. ", actual=" .. tostring(actualValue)
                .. ", requested=" .. tostring(assetId))
        else
            __DDCore.Log("AVATAR BODY PART READBACK FAILED: humanoid#" .. tostring(index)
                .. ", error=" .. tostring(appliedDescription))
        end
    end

    return applied
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
--// =========================================================
--// OTHERS PAGE: MULTI-PLAYER HIGHLIGHT
--// Uses CharacterService's custom visual rig first, not only Player.Character.
--// =========================================================
local otherFeatures = {
    enabled = savedConfig.others
        and savedConfig.others._PlayerHighlightEnabled == true
        or false,
    hotkey = "None",
    hotkeyCapture = false,
    selectedUserIds = {},
    highlights = {},
    playerButtonConnections = {},
    page = nil,
    toggleButton = nil,
    hotkeyButton = nil,
    status = nil,
    playerScroll = nil,
    playerLayout = nil
}

local savedPlayerHighlight = savedConfig.others or {}
local savedHighlightTargets = savedPlayerHighlight._PlayerHighlightTargets

if type(savedHighlightTargets) == "table" then
    for _, value in ipairs(savedHighlightTargets) do
        local userId = tonumber(value)
        if userId and userId > 0 then
            otherFeatures.selectedUserIds[userId] = true
        end
    end
end

local configuredHighlightHotkey =
    tostring(savedPlayerHighlight._PlayerHighlightHotkey or "None")

if configuredHighlightHotkey ~= "None" then
    local validHotkey = pcall(function()
        return Enum.KeyCode[configuredHighlightHotkey]
    end)

    if validHotkey then
        local keyCode = Enum.KeyCode[configuredHighlightHotkey]
        if keyCode and keyCode ~= Enum.KeyCode.Unknown then
            otherFeatures.hotkey = configuredHighlightHotkey
        end
    end
end

function otherFeatures.getSelectedCount()
    local count = 0
    for userId, selected in pairs(otherFeatures.selectedUserIds) do
        if selected and tonumber(userId) then
            count += 1
        end
    end
    return count
end

function otherFeatures.saveConfig()
    savedConfig.others = savedConfig.others or {}
    savedConfig.others._PlayerHighlightEnabled =
        otherFeatures.enabled == true
    savedConfig.others._PlayerHighlightHotkey =
        otherFeatures.hotkey or "None"

    local targets = {}
    for userId, selected in pairs(otherFeatures.selectedUserIds) do
        local numericUserId = tonumber(userId)
        if selected and numericUserId then
            table.insert(targets, numericUserId)
        end
    end

    table.sort(targets)
    savedConfig.others._PlayerHighlightTargets = targets

    pcall(saveSavedConfig)
end

function otherFeatures.updateToggle()
    local button = otherFeatures.toggleButton
    if not button then
        return
    end

    local isOn = otherFeatures.enabled == true

    -- Match the existing DeadEye SWAP toggles and repaint the state explicitly.
    pcall(function()
        button.Text = isOn and "HIGHLIGHT: ON" or "HIGHLIGHT: OFF"
        button.BackgroundColor3 = isOn
            and Color3.fromRGB(68, 74, 84)
            or Color3.fromRGB(47, 52, 61)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.AutoButtonColor = false
        button.BackgroundTransparency = 0.30
        button.TextTransparency = 0
    end)
end

function otherFeatures.updateHotkeyButton()
    if not otherFeatures.hotkeyButton then
        return
    end

    if otherFeatures.hotkeyCapture then
        otherFeatures.hotkeyButton.Text = "PRESS A KEY..."
    else
        otherFeatures.hotkeyButton.Text =
            otherFeatures.hotkey or "None"
    end
end

function otherFeatures.updateStatus()
    if not otherFeatures.status then
        return
    end

    local selectedCount = otherFeatures.getSelectedCount()
    local onlineCount = 0

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            onlineCount += 1
        end
    end

    otherFeatures.status.Text =
        "SEL " .. tostring(selectedCount)
        .. "  •  ONLINE " .. tostring(onlineCount)
end

function otherFeatures.destroyTargetHighlight(userId)
    local record = otherFeatures.highlights[userId]
    if not record then
        return
    end

    otherFeatures.highlights[userId] = nil
    pcall(function()
        record.highlight:Destroy()
    end)
end

function otherFeatures.destroyAllHighlights()
    local ids = {}
    for userId in pairs(otherFeatures.highlights) do
        table.insert(ids, userId)
    end

    for _, userId in ipairs(ids) do
        otherFeatures.destroyTargetHighlight(userId)
    end
end

function otherFeatures.getVisualRig(player)
    if not player then
        return nil
    end

    -- Primary path used by DeadEye for this game's separate visual character.
    local ok, characterObject = pcall(function()
        return __UI.CharacterService:GetCharacterFromPlayer(player)
    end)

    if ok and characterObject then
        local rigComponent
        local nativeRig
        local visualModel

        pcall(function()
            rigComponent = characterObject.Rig
            nativeRig = rigComponent and rigComponent.Rig
            visualModel = nativeRig and nativeRig.Model
        end)

        if typeof(visualModel) == "Instance"
            and visualModel:IsA("Model")
            and visualModel.Parent
        then
            return visualModel
        end

        -- Match the standalone test's fallback before looking in Workspace.Rigs.
        if rigComponent then
            local fallbackOK, fallbackModel = pcall(function()
                return rigComponent:GetRigModel()
            end)

            if fallbackOK
                and typeof(fallbackModel) == "Instance"
                and fallbackModel:IsA("Model")
                and fallbackModel.Parent
            then
                return fallbackModel
            end
        end
    end

    -- Explicit fallback to the game's visual rig container.
    local rigsFolder = Workspace:FindFirstChild("Rigs")
    if rigsFolder then
        local rigModel = rigsFolder:FindFirstChild(player.Name)
        if rigModel and rigModel:IsA("Model") and rigModel.Parent then
            return rigModel
        end

        for _, candidate in ipairs(rigsFolder:GetChildren()) do
            if candidate:IsA("Model")
                and string.lower(candidate.Name) == string.lower(player.Name)
                and candidate.Parent
            then
                return candidate
            end
        end
    end

    -- Final fallback only; custom game rig above is preferred.
    local character = player.Character
    if character and character:IsA("Model") and character.Parent then
        return character
    end

    return nil
end

function otherFeatures.refreshHighlights()
    if not otherFeatures.enabled then
        otherFeatures.destroyAllHighlights()
        otherFeatures.updateStatus()
        return
    end

    -- Remove highlights for deselected or departed players.
    local staleIds = {}
    for userId in pairs(otherFeatures.highlights) do
        local player = Players:GetPlayerByUserId(tonumber(userId) or -1)
        if not otherFeatures.selectedUserIds[tonumber(userId) or -1]
            or not player
            or player == LocalPlayer
        then
            table.insert(staleIds, userId)
        end
    end

    for _, userId in ipairs(staleIds) do
        otherFeatures.destroyTargetHighlight(userId)
    end

    -- Re-resolve each selected player's custom visual rig regularly.
    for userId, selected in pairs(otherFeatures.selectedUserIds) do
        local numericUserId = tonumber(userId)
        local player = numericUserId
            and Players:GetPlayerByUserId(numericUserId)
            or nil

        if selected and player and player ~= LocalPlayer then
            local model = otherFeatures.getVisualRig(player)
            local existing = otherFeatures.highlights[numericUserId]

            if existing
                and (
                    existing.model ~= model
                    or not existing.highlight
                    or not existing.highlight.Parent
                )
            then
                otherFeatures.destroyTargetHighlight(numericUserId)
                existing = nil
            end

            if model and not existing then
                local createOK, highlight = pcall(function()
                    local item = Instance.new("Highlight")
                    item.Name = "DeadEye_PlayerHighlight_" .. tostring(numericUserId)
                    item.Adornee = model
                    item.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    item.FillColor = Color3.fromRGB(40, 90, 165)
                    item.OutlineColor = Color3.fromRGB(65, 120, 200)
                    item.FillTransparency = 0.78
                    item.OutlineTransparency = 0
                    item.Enabled = true
                    item.Parent = Workspace
                    return item
                end)

                if createOK and highlight then
                    otherFeatures.highlights[numericUserId] = {
                        highlight = highlight,
                        model = model
                    }
                end
            end
        end
    end

    otherFeatures.updateStatus()
end

function otherFeatures.setEnabled(value, persist)
    otherFeatures.enabled = value == true

    if not otherFeatures.enabled then
        otherFeatures.destroyAllHighlights()
    else
        pcall(otherFeatures.refreshHighlights)
    end

    otherFeatures.updateToggle()
    otherFeatures.updateStatus()

    if persist ~= false then
        otherFeatures.saveConfig()
    end
end

function otherFeatures.rebuildPlayerList()
    if not otherFeatures.playerScroll then
        return
    end

    for _, connection in ipairs(otherFeatures.playerButtonConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(otherFeatures.playerButtonConnections)

    for _, child in ipairs(otherFeatures.playerScroll:GetChildren()) do
        if child ~= otherFeatures.playerLayout then
            pcall(function()
                child:Destroy()
            end)
        end
    end

    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player)
        end
    end

    table.sort(playerList, function(a, b)
        local aName = string.lower(a.Name)
        local bName = string.lower(b.Name)
        if aName == bName then
            return a.UserId < b.UserId
        end
        return aName < bName
    end)

    if #playerList == 0 then
        local empty = Instance.new("TextLabel")
        empty.Name = "NoPlayersLabel"
        empty.Size = UDim2.new(1, -6, 0, 28)
        empty.BackgroundTransparency = 1
        empty.Text = "No other players currently in this server"
        empty.TextSize = 10
        empty.Font = Enum.Font.Gotham
        empty.TextColor3 = Color3.fromRGB(140, 145, 155)
        empty.TextXAlignment = Enum.TextXAlignment.Left
        empty.LayoutOrder = 1
        empty.Parent = otherFeatures.playerScroll
    end

    for index, player in ipairs(playerList) do
        local userId = player.UserId
        local selected = otherFeatures.selectedUserIds[userId] == true

        local button = Instance.new("TextButton")
        button.Name = "Player_" .. tostring(userId)
        button.Size = UDim2.new(1, -6, 0, 29)
        button.BackgroundColor3 = selected
            and Color3.fromRGB(40, 76, 116)
            or Color3.fromRGB(43, 47, 54)
        button.BorderSizePixel = 0
        button.AutoButtonColor = true
        button.Text = (selected and "✓  " or "+  ")
            .. tostring(player.DisplayName)
            .. "  (@" .. tostring(player.Name) .. ")"
        button.TextSize = 10
        button.Font = Enum.Font.GothamMedium
        button.TextColor3 = Color3.fromRGB(240, 242, 247)
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.TextTruncate = Enum.TextTruncate.AtEnd
        button.LayoutOrder = index
        button.Parent = otherFeatures.playerScroll

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = button

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 6)
        padding.Parent = button

        local connection = button.MouseButton1Click:Connect(function()
            if otherFeatures.selectedUserIds[userId] then
                otherFeatures.selectedUserIds[userId] = nil
            else
                otherFeatures.selectedUserIds[userId] = true
            end

            otherFeatures.rebuildPlayerList()
            otherFeatures.updateStatus()
            otherFeatures.saveConfig()

            if otherFeatures.enabled then
                pcall(otherFeatures.refreshHighlights)
            end
        end)

        table.insert(otherFeatures.playerButtonConnections, connection)
    end

    otherFeatures.updateStatus()
end

otherFeatures.page = Instance.new("ScrollingFrame")
otherFeatures.page.Name = "OthersPage"
otherFeatures.page.Size = UDim2.new(1, -92, 1, -56)
otherFeatures.page.Position = UDim2.new(0, 82, 0, 48)
otherFeatures.page.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
otherFeatures.page.BorderSizePixel = 0
otherFeatures.page.ScrollBarThickness = 5
otherFeatures.page.CanvasSize = UDim2.new(0, 0, 0, 0)
otherFeatures.page.AutomaticCanvasSize = Enum.AutomaticSize.Y
otherFeatures.page.ScrollingDirection = Enum.ScrollingDirection.Y
otherFeatures.page.Visible = false
otherFeatures.page.Parent = Main

local otherPageCorner = Instance.new("UICorner")
otherPageCorner.CornerRadius = UDim.new(0, 9)
otherPageCorner.Parent = otherFeatures.page

local otherPagePadding = Instance.new("UIPadding")
otherPagePadding.PaddingTop = UDim.new(0, 6)
otherPagePadding.PaddingBottom = UDim.new(0, 6)
otherPagePadding.PaddingLeft = UDim.new(0, 6)
otherPagePadding.PaddingRight = UDim.new(0, 6)
otherPagePadding.Parent = otherFeatures.page

local otherPageLayout = Instance.new("UIListLayout")
otherPageLayout.Padding = UDim.new(0, 4)
otherPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
otherPageLayout.Parent = otherFeatures.page

local otherTitle = Instance.new("TextLabel")
otherTitle.Name = "PlayerHighlightHeader"
otherTitle.Size = UDim2.new(1, -4, 0, 18)
otherTitle.BackgroundTransparency = 1
otherTitle.Text = "PLAYER HIGHLIGHT"
otherTitle.TextSize = 10
otherTitle.Font = Enum.Font.GothamBold
otherTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
otherTitle.TextXAlignment = Enum.TextXAlignment.Left
otherTitle.LayoutOrder = 1
otherTitle.Parent = otherFeatures.page

-- One compact control row, matching the 40px settings rows elsewhere in DeadEye.
local otherControls = Instance.new("Frame")
otherControls.Name = "PlayerHighlightControls"
otherControls.Size = UDim2.new(1, -4, 0, 34)
otherControls.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
otherControls.BorderSizePixel = 0
otherControls.LayoutOrder = 2
otherControls.Parent = otherFeatures.page

local otherControlsCorner = Instance.new("UICorner")
otherControlsCorner.CornerRadius = UDim.new(0, 6)
otherControlsCorner.Parent = otherControls

otherFeatures.toggleButton = Instance.new("TextButton")
otherFeatures.toggleButton.Name = "HighlightToggle"
otherFeatures.toggleButton.Size = UDim2.new(0, 100, 0, 27)
otherFeatures.toggleButton.Position = UDim2.new(0, 5, 0.5, -13)
otherFeatures.toggleButton.BackgroundColor3 = Color3.fromRGB(47, 52, 61)
otherFeatures.toggleButton.BorderSizePixel = 0
otherFeatures.toggleButton.Text = "HIGHLIGHT: OFF"
otherFeatures.toggleButton.TextSize = 9
otherFeatures.toggleButton.Font = Enum.Font.GothamBold
otherFeatures.toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
otherFeatures.toggleButton.AutoButtonColor = false
otherFeatures.toggleButton.Parent = otherControls

local otherToggleCorner = Instance.new("UICorner")
otherToggleCorner.CornerRadius = UDim.new(0, 5)
otherToggleCorner.Parent = otherFeatures.toggleButton

local otherHotkeyLabel = Instance.new("TextLabel")
otherHotkeyLabel.Name = "HotkeyLabel"
otherHotkeyLabel.Size = UDim2.new(0, 35, 1, 0)
otherHotkeyLabel.Position = UDim2.new(0, 111, 0, 0)
otherHotkeyLabel.BackgroundTransparency = 1
otherHotkeyLabel.Text = "KEY"
otherHotkeyLabel.TextSize = 9
otherHotkeyLabel.Font = Enum.Font.GothamBold
otherHotkeyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
otherHotkeyLabel.TextXAlignment = Enum.TextXAlignment.Left
otherHotkeyLabel.Parent = otherControls

otherFeatures.hotkeyButton = Instance.new("TextButton")
otherFeatures.hotkeyButton.Name = "HotkeyButton"
otherFeatures.hotkeyButton.Size = UDim2.new(0, 60, 0, 27)
otherFeatures.hotkeyButton.Position = UDim2.new(0, 144, 0.5, -13)
otherFeatures.hotkeyButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
otherFeatures.hotkeyButton.BorderSizePixel = 0
otherFeatures.hotkeyButton.Text = "None"
otherFeatures.hotkeyButton.TextSize = 10
otherFeatures.hotkeyButton.Font = Enum.Font.GothamBold
otherFeatures.hotkeyButton.TextColor3 = Color3.fromRGB(236, 239, 245)
otherFeatures.hotkeyButton.Parent = otherControls

local otherHotkeyCorner = Instance.new("UICorner")
otherHotkeyCorner.CornerRadius = UDim.new(0, 5)
otherHotkeyCorner.Parent = otherFeatures.hotkeyButton

otherFeatures.status = Instance.new("TextLabel")
otherFeatures.status.Name = "HighlightStatus"
otherFeatures.status.Size = UDim2.new(1, -214, 1, 0)
otherFeatures.status.Position = UDim2.new(0, 210, 0, 0)
otherFeatures.status.BackgroundTransparency = 1
otherFeatures.status.TextSize = 8
otherFeatures.status.Font = Enum.Font.Gotham
otherFeatures.status.TextColor3 = Color3.fromRGB(150, 150, 150)
otherFeatures.status.TextXAlignment = Enum.TextXAlignment.Right
otherFeatures.status.TextTruncate = Enum.TextTruncate.AtEnd
otherFeatures.status.Parent = otherControls

local otherPlayersHeader = Instance.new("TextLabel")
otherPlayersHeader.Name = "ServerPlayersHeader"
otherPlayersHeader.Size = UDim2.new(1, -4, 0, 17)
otherPlayersHeader.BackgroundTransparency = 1
otherPlayersHeader.Text = "SERVER PLAYERS  •  MULTI-SELECT"
otherPlayersHeader.TextSize = 9
otherPlayersHeader.Font = Enum.Font.GothamBold
otherPlayersHeader.TextColor3 = Color3.fromRGB(150, 150, 150)
otherPlayersHeader.TextXAlignment = Enum.TextXAlignment.Left
otherPlayersHeader.LayoutOrder = 3
otherPlayersHeader.Parent = otherFeatures.page

otherFeatures.playerScroll = Instance.new("ScrollingFrame")
otherFeatures.playerScroll.Name = "ServerPlayerList"
otherFeatures.playerScroll.Size = UDim2.new(1, -4, 0, 102)
otherFeatures.playerScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
otherFeatures.playerScroll.BackgroundTransparency = 0.12
otherFeatures.playerScroll.BorderSizePixel = 0
otherFeatures.playerScroll.ScrollBarThickness = 4
otherFeatures.playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
otherFeatures.playerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
otherFeatures.playerScroll.ScrollingDirection = Enum.ScrollingDirection.Y
otherFeatures.playerScroll.LayoutOrder = 4
otherFeatures.playerScroll.Parent = otherFeatures.page

local otherPlayerScrollCorner = Instance.new("UICorner")
otherPlayerScrollCorner.CornerRadius = UDim.new(0, 6)
otherPlayerScrollCorner.Parent = otherFeatures.playerScroll

local otherPlayerPadding = Instance.new("UIPadding")
otherPlayerPadding.PaddingTop = UDim.new(0, 4)
otherPlayerPadding.PaddingBottom = UDim.new(0, 4)
otherPlayerPadding.PaddingLeft = UDim.new(0, 4)
otherPlayerPadding.PaddingRight = UDim.new(0, 4)
otherPlayerPadding.Parent = otherFeatures.playerScroll

otherFeatures.playerLayout = Instance.new("UIListLayout")
otherFeatures.playerLayout.Padding = UDim.new(0, 3)
otherFeatures.playerLayout.SortOrder = Enum.SortOrder.LayoutOrder
otherFeatures.playerLayout.Parent = otherFeatures.playerScroll

__UI.__L.addConnection(
    otherFeatures.toggleButton.MouseButton1Click:Connect(function()
        otherFeatures.setEnabled(not otherFeatures.enabled, true)
        -- Repaint on the next UI frame too; the label and state must always agree.
        task.defer(function()
            if not cleaned then
                otherFeatures.updateToggle()
                otherFeatures.updateStatus()
            end
        end)
    end)
)

__UI.__L.addConnection(
    otherFeatures.hotkeyButton.MouseButton1Click:Connect(function()
        otherFeatures.hotkeyCapture = true
        otherFeatures.updateHotkeyButton()
    end)
)

__UI.__L.addConnection(
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if otherFeatures.hotkeyCapture then
            if input.UserInputType ~= Enum.UserInputType.Keyboard
                or input.KeyCode == Enum.KeyCode.Unknown
            then
                return
            end

            if input.KeyCode == Enum.KeyCode.Escape
                or input.KeyCode == Enum.KeyCode.Backspace
                or input.KeyCode == Enum.KeyCode.Delete
            then
                otherFeatures.hotkey = "None"
            else
                otherFeatures.hotkey = input.KeyCode.Name
            end

            otherFeatures.hotkeyCapture = false
            otherFeatures.updateHotkeyButton()
            otherFeatures.saveConfig()
            return
        end

        if gameProcessed
            or otherFeatures.hotkey == "None"
            or input.UserInputType ~= Enum.UserInputType.Keyboard
            or input.KeyCode.Name ~= otherFeatures.hotkey
        then
            return
        end

        local focusedTextBox
        pcall(function()
            focusedTextBox = UserInputService:GetFocusedTextBox()
        end)

        if focusedTextBox then
            return
        end

        otherFeatures.setEnabled(not otherFeatures.enabled, true)
    end)
)

__UI.__L.addConnection(
    Players.PlayerAdded:Connect(function()
        task.defer(function()
            if not cleaned then
                otherFeatures.rebuildPlayerList()
            end
        end)
    end)
)

__UI.__L.addConnection(
    Players.PlayerRemoving:Connect(function(player)
        otherFeatures.destroyTargetHighlight(player.UserId)
        task.defer(function()
            if not cleaned then
                otherFeatures.rebuildPlayerList()
                otherFeatures.updateStatus()
            end
        end)
    end)
)

otherFeatures.updateToggle()
otherFeatures.updateHotkeyButton()
otherFeatures.rebuildPlayerList()

task.spawn(function()
    while not cleaned do
        pcall(otherFeatures.updateToggle)
        pcall(otherFeatures.updateStatus)

        if otherFeatures.enabled then
            pcall(otherFeatures.refreshHighlights)
        end

        task.wait(0.35)
    end

    otherFeatures.destroyAllHighlights()
end)

--// =========================================================
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
    __UI.__L.makeCategoryButton(
        "MAIN",
        6
    )
emoteCategoryButton =
    __UI.__L.makeCategoryButton(
        "EMOTES",
        41
    )
unusualCategoryButton =
    __UI.__L.makeCategoryButton(
        "UNUSUAL",
        76
    )
cosmetic.categoryButton =
    __UI.__L.makeCategoryButton(
        "COSMETIC",
        111
    )
otherCategoryButton =
    __UI.__L.makeCategoryButton(
        "OTHERS",
        146
    )
avatarCategoryButton =
    __UI.__L.makeCategoryButton(
        "AVATAR",
        181
    )
--// =========================================================
--// CATEGORY SWITCH
--// =========================================================
__UI.__L.setCategory = function(category)
    currentCategory = category

    pcall(function()
        Status.Visible = false
        Toggle.Visible = false
        unusualStatus.Visible = false
        unusualPicker.Visible = false
        mainPage.Visible = false
        unusualPage.Visible = false
        others.page.Visible = false
        cosmetic.page.Visible = false
        otherFeatures.page.Visible = false
        SlotsScroll.Visible = false

        mainCategoryButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        emoteCategoryButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        unusualCategoryButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        cosmetic.categoryButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        otherCategoryButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        avatarCategoryButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

        MainTitle.Text = "DeadEyes v" .. SCRIPT_VERSION

        if category == "Main" then
            mainPage.Visible = true
            mainCategoryButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)

        elseif category == "Unusual" then
            Toggle.Visible = true
            Toggle.Parent = unusualPage
            Toggle.LayoutOrder = 0
            unusualPage.Visible = true
            unusualCategoryButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            updateUnusualToggle()

        elseif category == "Cosmetic" then
            Toggle.Visible = true
            Toggle.Parent = cosmetic.page
            Toggle.LayoutOrder = 0
            cosmetic.page.Visible = true
            cosmetic.categoryButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            cosmetic.updateToggle()

        elseif category == "Others" then
            otherFeatures.page.Visible = true
            otherCategoryButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            otherFeatures.updateToggle()
            otherFeatures.updateHotkeyButton()
            otherFeatures.updateStatus()

        elseif category == "Avatar" then
            others.page.Visible = true
            avatarCategoryButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)

        else
            Toggle.Visible = true
            Toggle.Parent = SlotsScroll
            Toggle.LayoutOrder = 0
            SlotsScroll.Visible = true
            emoteCategoryButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            updateGUI()
        end
    end)
end

UnusualFns.addUnusualConnection(
    mainCategoryButton.MouseButton1Click:Connect(function()
        if mainMinimized then
            setMainMinimized(false)
        end
        __UI.__L.setCategory("Main")
    end)
)

UnusualFns.addUnusualConnection(
    emoteCategoryButton.MouseButton1Click:Connect(function()
        if mainMinimized then
            setMainMinimized(false)
        end
        __UI.__L.setCategory("Emotes")
    end)
)

UnusualFns.addUnusualConnection(
    unusualCategoryButton.MouseButton1Click:Connect(function()
        if mainMinimized then
            setMainMinimized(false)
        end
        __UI.__L.setCategory("Unusual")
    end)
)

UnusualFns.addUnusualConnection(
    cosmetic.categoryButton.MouseButton1Click:Connect(function()
        if mainMinimized then
            setMainMinimized(false)
        end
        __UI.__L.setCategory("Cosmetic")
    end)
)

UnusualFns.addUnusualConnection(
    otherCategoryButton.MouseButton1Click:Connect(function()
        if mainMinimized then
            setMainMinimized(false)
        end
        __UI.__L.setCategory("Others")
    end)
)

UnusualFns.addUnusualConnection(
    avatarCategoryButton.MouseButton1Click:Connect(function()
        if mainMinimized then
            setMainMinimized(false)
        end
        __UI.__L.setCategory("Avatar")
    end)
)
--// EXTERNAL CLEANUP
--// =========================================================
__UI.__L.cleanupUnusual = function()
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

    local currentTargetSet =
        UnusualFns.getUnusualTargetModelSet(currentVisualRig, currentPlayerCharacter)

    --// Snapshot is only valid for the model set it was captured from.
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
            and unusualRuntime.appliedCharacter == currentPlayerCharacter
            and UnusualFns.sameUnusualTargetModelSet(
                currentTargetSet,
                unusualRuntime.appliedTargets
            )
            and unusualRuntime.nativeSnapshot
        then
            runtimeSnapshot =
                unusualRuntime.nativeSnapshot
            runtimeSnapshotRig =
                currentVisualRig
        elseif runtimeSnapshotRig
            ~= currentVisualRig
            or unusualRuntime.appliedCharacter ~= currentPlayerCharacter
            or not UnusualFns.sameUnusualTargetModelSet(
                currentTargetSet,
                unusualRuntime.appliedTargets
            )
        then
            local freshSnapshot =
                UnusualFns.captureNativeUnusualSnapshot(
                    runtimeOriginalId,
                    currentVisualRig,
                    currentPlayerCharacter,
                    unusualRuntime.nativeSnapshot
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
                    UnusualFns.restoreNativeWeldedTreeStates()
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

                    UnusualFns.applyNativeUnusualFallback(
                        runtimeRestoreId,
                        visualRig,
                        playerCharacter,
                        "cleanup had no current native snapshot"
                    )
                end
            end
        end)
    end

    UnusualFns.restoreNativeWeldedTreeStates()

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
    unusualRuntime.appliedCharacter = nil
    unusualRuntime.appliedTargets = nil
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
        __UI.__L.mainDisconnect()
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
    __UI.__L.cleanupUnusual
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

--// Current versions are observed through Inventory.Loadout:Observe above.
--// Keep the old channel listener only if the legacy API was selected.
if __DDCore.LoadoutModuleKind == "legacy useLoadout" then
    pcall(function()
        local shared = ReplicatedStorage:FindFirstChild("Shared")
        local userData = shared and shared:FindFirstChild("UserData")
        local events = userData and userData:FindFirstChild("Events")
        local remotes = events and events:FindFirstChild("Remotes")
        local channels = remotes and remotes:FindFirstChild("Channels")
        local loadoutChannel = channels and channels:FindFirstChild("Loadout")

        if loadoutChannel and loadoutChannel:IsA("RemoteEvent") then
            UnusualFns.addUnusualConnection(
                loadoutChannel.OnClientEvent:Connect(function(kind, data)
                    if (kind == "sync" or kind == "patch") and type(data) == "table" then
                        for slotName, slotValue in pairs(data) do
                            __DDCore.LoadoutCache[slotName] = tonumber(slotValue) or 0
                        end
                        __DDCore.Log("LOADOUT EVENT (legacy): kind=" .. tostring(kind)
                            .. ", UnusualSlot=" .. tostring(data.UnusualSlot)
                            .. ", CosmeticSlot_1=" .. tostring(data.CosmeticSlot_1)
                            .. ", CosmeticSlot_2=" .. tostring(data.CosmeticSlot_2))

                        cosmetic.setInitialOriginal(1, data.CosmeticSlot_1)
                        cosmetic.setInitialOriginal(2, data.CosmeticSlot_2)
                    end
                end)
            )
        else
            __DDCore.Log("LOADOUT LEGACY CHANNEL MISSING")
        end
    end)
else
    __DDCore.Log("LOADOUT: using current Inventory.Loadout API observers")
end

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
    SLOT_COUNT = SLOT_COUNT,
    slots = slots,
    prepareOriginalModule = prepareOriginalModule,
    prepareReplaceModule = prepareReplaceModule,
    getEmoteName = getEmoteName,
    createEmotePreview = __UI.__L.createEmotePreview,
    isEnabled = function()
        return enabled
    end
}

__DDCore.Log("INIT: loading external NativeWheel module")
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
__DDCore.Log("INIT checkpoint: NativeWheel API loaded; sync=" .. type(NativeWheel.sync)
    .. ", restore=" .. type(NativeWheel.restore))
--// =========================================================
--// REBUILD PICKER
--// =========================================================
__UI.__L.rebuildPicker = function()
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
                __UI.__L.createEmotePreview(
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
__UI.__L.openPicker = function(
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
        __UI.__L.rebuildPicker()
    end

    __UI.animatePickerAppear(
        Picker
    )
end
--// =========================================================
--// CLOSE PICKER
--// =========================================================
__UI.__L.closePicker = function()
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
            __UI.__L.openPicker(
                slotIndex,
                "Original"
            )
        end
    )
    slotReplaceButtons[
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
    PickerSearch:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()
            if Picker.Visible then
                __UI.__L.rebuildPicker()
            end
        end
    )
)
PickerClose.MouseButton1Click:Connect(
    function()
        __UI.__L.closePicker()
    end
)
--// =========================================================
--// TOGGLE
--// =========================================================
__UI.__L.addConnection(
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
                UnusualFns.traceSwap(
                    "TOGGLE_CLICK",
                    "category=Unusual|requested=" .. (unusualEnabled and "disable" or "enable")
                )
                if unusualEnabled then
                    unusualEnabled =
                        false
                    genv.UNUSUAL_SWAPPER_ENABLED =
                        false
                    UnusualFns.restoreUnusual()
                    UnusualFns.traceSwap("TOGGLE_DISABLED", "restore returned")
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
                        UnusualFns.traceSwap("TOGGLE_ENABLED", "activate returned true")
                    else
                        UnusualFns.traceSwap("TOGGLE_ENABLE_FAILED", "activate returned false")
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
            cosmetic.page.Visible = false
            otherFeatures.page.Visible = false
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

            mainPage.Visible = false
            unusualPage.Visible = false
            unusualStatus.Visible = false
            others.page.Visible = false
            cosmetic.page.Visible = false
            otherFeatures.page.Visible = false
            unusualPicker.Visible = false

            if currentCategory == "Main" then
                Status.Visible = false
                Toggle.Visible = false
                SlotsScroll.Visible = false
                mainPage.Visible = true

            elseif currentCategory == "Unusual" then
                Status.Visible = false
                Toggle.Visible = true
                Toggle.Parent = unusualPage
                Toggle.LayoutOrder = 0
                SlotsScroll.Visible = false
                unusualPage.Visible = true
                updateUnusualToggle()

            elseif currentCategory == "Cosmetic" then
                Status.Visible = false
                Toggle.Visible = true
                Toggle.Parent = cosmetic.page
                Toggle.LayoutOrder = 0
                SlotsScroll.Visible = false
                cosmetic.page.Visible = true
                cosmetic.updateToggle()

            elseif currentCategory == "Others" then
                Status.Visible = false
                Toggle.Visible = false
                SlotsScroll.Visible = false
                otherFeatures.page.Visible = true
                otherFeatures.updateToggle()
                otherFeatures.updateHotkeyButton()
                otherFeatures.updateStatus()

            elseif currentCategory == "Avatar" then
                Status.Visible = false
                Toggle.Visible = false
                SlotsScroll.Visible = false
                others.page.Visible = true

            else
                Status.Visible = false
                Toggle.Visible = true
                Toggle.Parent = SlotsScroll
                Toggle.LayoutOrder = 0
                SlotsScroll.Visible = true
                updateGUI()
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
__UI.__L.addConnection(
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
__UI.__L.addConnection(
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

__UI.__L.saveWindowState = function()
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

__UI.__L.clampWindowPosition = function()
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

__UI.__L.setMainSize = function(
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

    __UI.__L.clampWindowPosition()
end

--// Drag the title bar.
__UI.__L.beginWindowDrag = function(input)
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

__UI.__L.addConnection(
    DragHandle.InputBegan:Connect(
        function(input)
            __UI.__L.beginWindowDrag(input)
        end
    )
)

__UI.__L.addConnection(
    MainTitle.InputBegan:Connect(
        function(input)
            __UI.__L.beginWindowDrag(input)
        end
    )
)

__UI.__L.addConnection(
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

            __UI.__L.clampWindowPosition()
        end
    )
)

__UI.__L.beginResize = function(
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

__UI.__L.addConnection(
    ResizeRight.InputBegan:Connect(
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

__UI.__L.addConnection(
    ResizeBottom.InputBegan:Connect(
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

__UI.__L.addConnection(
    ResizeCorner.InputBegan:Connect(
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
                if dragging then
                    dragging = false
                    __UI.__L.saveWindowState()
                end

                if resizing then
                    resizing = false
                    resizeMode = nil
                    __UI.__L.saveWindowState()
                end
            end
        end
    )
)

--// CLEANUP
--// =========================================================
__UI.__L.cleanup = function()
    if cleaned then
        return
    end

    --// Save the Avatar editor state first.
    pcall(function()
        others.saveConfig()
    end)

    --// The highlight is tied to the lifetime of this DeadEye instance.
    --// Stop it fully on close, remove every Highlight, and persist OFF.
    pcall(function()
        otherFeatures.enabled = false
        otherFeatures.hotkeyCapture = false
        otherFeatures.updateToggle()
        otherFeatures.destroyAllHighlights()

        for _, connection in ipairs(otherFeatures.playerButtonConnections) do
            pcall(function()
                connection:Disconnect()
            end)
        end
        table.clear(otherFeatures.playerButtonConnections)

        otherFeatures.saveConfig()
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
        mainJump.restoreFOVBodyVisibility()

        if genv.DEADEYE_FOV_BODY_VISIBILITY_CLEANUP
            == mainJump.fovBodyVisibilityCleanup
        then
            genv.DEADEYE_FOV_BODY_VISIBILITY_CLEANUP = nil
        end
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

    enabled = false

    pcall(function()
        EmoteRuntime.stopForCleanup()
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
    __UI.__L.cleanup
--// =========================================================
--// CLOSE
--// =========================================================
__UI.__L.addConnection(
    Close.MouseButton1Click:Connect(
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
    ScreenGui:GetDescendants()
) do
    if object:IsA("TextButton") then
        __UI.styleButtonMotion(object)
    end
end

__UI.__L.addConnection(
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

--// DIAGNOSTIC WRAPPERS
--// Installed before initial preview build and before the user can press controls.
__DDCore.Log("INIT checkpoint: UI created; installing targeted diagnostics")

-- Emote swap: log real native Emote ID transitions and replacement start/result.
__DDCore.WrapTable(__UI.EmoteService, "SetEmote", "EMOTE.EmoteService.SetEmote", "result")
__DDCore.WrapTable(EmoteRuntime, "checkState", "EMOTE.checkState", "sample")

__DDCore.NativeEmoteCounter = 0
__DDCore.LastNativeEmoteId = "__DD_UNSET"
__DDCore.LastNativeEmoteReadOK = "__DD_UNSET"
__DDCore.LastSwapEnabled = "__DD_UNSET"
__DDCore.LastRuntimeOriginalId = "__DD_UNSET"
__DDCore.WrappedCheckState = EmoteRuntime.checkState

EmoteRuntime.checkState = function(...)
    local args = __DDCore.Pack(...)

    if __DDCore.State.active then
        __DDCore.NativeEmoteCounter += 1

        -- The runtime already polls every frame; sample native state periodically.
        if __DDCore.NativeEmoteCounter == 1
            or __DDCore.NativeEmoteCounter % 6 == 0
        then
            local characterObject
            local objectOK, objectError = pcall(function()
                characterObject = __UI.CharacterService:GetLocalCharacter()
            end)

            local registry = characterObject and characterObject.DataRegistry
            local nativeEmoteId
            local registryOK, registryError = pcall(function()
                if not registry then
                    error("Character object or DataRegistry missing")
                end
                nativeEmoteId = registry:Get("Emote")
            end)

            local rawIdKey = tostring(nativeEmoteId)
            local enabledKey = tostring(enabled)
            local readOKKey = tostring(objectOK) .. "/" .. tostring(registryOK)

            if rawIdKey ~= __DDCore.LastNativeEmoteId
                or readOKKey ~= __DDCore.LastNativeEmoteReadOK
                or enabledKey ~= __DDCore.LastSwapEnabled
            then
                local slotDescription = "no matching configured original slot"
                local numericId = tonumber(nativeEmoteId)

                if numericId then
                    for slotIndex = 1, SLOT_COUNT do
                        local slot = slots[slotIndex]
                        if slot
                            and tonumber(slot.originalId) == numericId
                            and slot.replaceId
                        then
                            slotDescription = "slot=" .. tostring(slotIndex)
                                .. " original=" .. tostring(slot.originalId)
                                .. " replacement=" .. tostring(slot.replaceId)
                            break
                        end
                    end
                end

                __DDCore.Log("EMOTE NATIVE STATE: enabled=" .. enabledKey
                    .. ", nativeEmoteId=" .. rawIdKey
                    .. ", matchingSlot={" .. slotDescription .. "}"
                    .. ", characterObject=" .. tostring(characterObject)
                    .. ", DataRegistry=" .. tostring(registry)
                    .. ", objectReadOK=" .. tostring(objectOK)
                    .. ", registryReadOK=" .. tostring(registryOK)
                    .. (objectOK and "" or ", objectError=" .. tostring(objectError))
                    .. (registryOK and "" or ", registryError=" .. tostring(registryError)))

                __DDCore.LastNativeEmoteId = rawIdKey
                __DDCore.LastNativeEmoteReadOK = readOKKey
                __DDCore.LastSwapEnabled = enabledKey
            end
        end
    end

    local ok, result = xpcall(function()
        return __DDCore.Pack(__DDCore.WrappedCheckState(__DDCore.Unpack(args, 1, args.n)))
    end, __DDCore.Traceback)

    if not ok then
        __DDCore.Log("EMOTE CHECKSTATE TRACKER FAILED:\n" .. tostring(result))
        error(result, 0)
    end

    if __DDCore.State.active then
        local currentOriginalId
        local readOK, readError = pcall(function()
            currentOriginalId = EmoteRuntime.getCurrentOriginalId()
        end)

        local currentKey = readOK and tostring(currentOriginalId) or "<read failed>"
        if currentKey ~= __DDCore.LastRuntimeOriginalId then
            __DDCore.Log("EMOTE RUNTIME SWAP STATE: currentOriginalId=" .. currentKey
                .. ", enabled=" .. tostring(enabled)
                .. (readOK and "" or ", readError=" .. tostring(readError)))
            __DDCore.LastRuntimeOriginalId = currentKey
        end
    end

    return __DDCore.Unpack(result, 1, result.n)
end

__DDCore.WrapTable(EmoteRuntime, "stopCustomEmote", "EMOTE.stopCustomEmote")
__DDCore.WrapTable(EmoteRuntime, "stopForCleanup", "EMOTE.stopForCleanup")
__DDCore.WrapTable(EmoteRuntime, "reset", "EMOTE.reset")
__DDCore.WrapTable(NativeWheel, "sync", "EMOTE.NativeWheel.sync", "sample")
__DDCore.WrapTable(NativeWheel, "restore", "EMOTE.NativeWheel.restore")
__DDCore.WrapTable(NativeWheel, "reset", "EMOTE.NativeWheel.reset")
__DDCore.WrapTable(__UI.__L, "rebuildPicker", "EMOTE.rebuildPicker")
__DDCore.WrapTable(__UI.__L, "setCategory", "GUI.setCategory")

-- Cosmetic swap: capture the live rig rebuild and slot-selection path.
__DDCore.WrapTable(cosmetic, "select", "COSMETIC.select")
__DDCore.WrapTable(cosmetic, "updateToggle", "COSMETIC.updateToggle")
__DDCore.WrapTable(cosmetic, "installHook", "COSMETIC.installHook")
__DDCore.WrapTable(cosmetic, "refreshRig", "COSMETIC.refreshRig")
__DDCore.WrapTable(cosmetic, "rebuildPicker", "COSMETIC.rebuildPicker")
__DDCore.WrapTable(cosmetic, "createPreview", "COSMETIC.createPreview", "result")

-- Unusual effects: trace the source data that controls activation.
__DDCore.WrapTable(UnusualFns, "getEquippedUnusualId", "UNUSUAL.getEquippedUnusualId")
__DDCore.WrapTable(UnusualFns, "getUnusualVisualRig", "UNUSUAL.getUnusualVisualRig")
__DDCore.WrapTable(UnusualFns, "getUnusualPlayerCharacter", "UNUSUAL.getUnusualPlayerCharacter")
__DDCore.WrapTable(UnusualFns, "captureNativeUnusualSnapshot", "UNUSUAL.captureNativeUnusualSnapshot")
__DDCore.WrapTable(UnusualFns, "activateUnusual", "UNUSUAL.activateUnusual")
__DDCore.WrapTable(UnusualFns, "restoreUnusual", "UNUSUAL.restoreUnusual")
__DDCore.WrapTable(UnusualFns, "reapplyUnusual", "UNUSUAL.reapplyUnusual")
__DDCore.WrapTable(UnusualFns, "openUnusualPicker", "UNUSUAL.openPicker")
__DDCore.WrapTable(UnusualFns, "closeUnusualPicker", "UNUSUAL.closePicker")
__DDCore.WrapTable(UnusualFns, "rebuildUnusualPicker", "UNUSUAL.rebuildPicker")
__DDCore.WrapTable(__UI.__L, "applyUnusualFX", "UNUSUAL.applyUnusualFX")

-- Avatar actions: log their results and verify applied fields on every Humanoid.
__DDCore.WrapTable(others, "applyDescription", "AVATAR.applyDescription")

__DDCore.AvatarVerifyProperties = {
    "Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg",
    "Face", "Shirt", "Pants", "GraphicTShirt",
    "BodyTypeScale", "HeightScale", "WidthScale", "DepthScale",
    "HeadScale", "ProportionScale",
    "HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory",
    "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory"
}

__DDCore.ApplyDescriptionLogged = others.applyDescription
others.applyDescription = function(description)
    local expected = {}
    for _, property in ipairs(__DDCore.AvatarVerifyProperties) do
        pcall(function()
            expected[property] = description[property]
        end)
    end

    local result = __DDCore.Pack(__DDCore.ApplyDescriptionLogged(description))

    if __DDCore.State.active then
        local humanoids = {}
        local listOK, listError = pcall(function()
            humanoids = others.getHumanoids()
        end)

        __DDCore.Log("AVATAR READBACK BEGIN: applyResult=" .. __DDCore.Args(result)
            .. ", humanoidListOK=" .. tostring(listOK)
            .. ", humanoidCount=" .. tostring(#humanoids)
            .. (listOK and "" or ", error=" .. tostring(listError)))

        for index, humanoid in ipairs(humanoids) do
            local descriptionOK, appliedDescription = pcall(function()
                return humanoid:GetAppliedDescription()
            end)

            if not descriptionOK or not appliedDescription then
                __DDCore.Log("AVATAR READBACK FAILED: humanoid#" .. tostring(index)
                    .. ", humanoid=" .. tostring(humanoid)
                    .. ", error=" .. tostring(appliedDescription))
            else
                local checked = 0
                local mismatches = {}

                for _, property in ipairs(__DDCore.AvatarVerifyProperties) do
                    local desired = expected[property]
                    if desired ~= nil then
                        checked += 1
                        local actualOK, actual = pcall(function()
                            return appliedDescription[property]
                        end)

                        if not actualOK or tostring(actual) ~= tostring(desired) then
                            mismatches[#mismatches + 1] = property
                                .. ": requested=" .. tostring(desired)
                                .. ", actual=" .. (actualOK and tostring(actual) or "<read failed>")
                        end
                    end
                end

                if #mismatches == 0 then
                    __DDCore.Log("AVATAR READBACK MATCH: humanoid#" .. tostring(index)
                        .. ", path=" .. tostring(humanoid)
                        .. ", checkedProperties=" .. tostring(checked))
                else
                    __DDCore.Log("AVATAR READBACK MISMATCH: humanoid#" .. tostring(index)
                        .. ", path=" .. tostring(humanoid)
                        .. ", checkedProperties=" .. tostring(checked)
                        .. ", mismatches=" .. table.concat(mismatches, " | "))
                end
            end
        end
    end

    return __DDCore.Unpack(result, 1, result.n)
end

__DDCore.WrapTable(others, "applyField", "AVATAR.applyField")
__DDCore.WrapTable(others, "applyBodyPart", "AVATAR.applyBodyPart")
__DDCore.WrapTable(others, "scan", "AVATAR.scan")
__DDCore.WrapTable(others, "clearAccessories", "AVATAR.clearAccessories")
__DDCore.WrapTable(others, "restore", "AVATAR.restore")
__DDCore.WrapTable(others, "applyAvatarDump", "AVATAR.applyAvatarDump")
__DDCore.WrapTable(others, "applyAll", "AVATAR.applyAll")

-- Track actual button activations, including dynamically-created picker cards.
function __DDCore.WatchButton(object)
    local ok, isButton = pcall(function()
        return object:IsA("GuiButton")
    end)
    if not ok or not isButton or __DDCore.State.watchedButtons[object] then
        return
    end

    __DDCore.State.watchedButtons[object] = true

    pcall(function()
        local connection = object.Activated:Connect(function()
            if not __DDCore.State.active then
                return
            end

            local path = tostring(object.Name)
            pcall(function()
                path = object:GetFullName()
            end)

            local textValue = ""
            pcall(function()
                if object:IsA("TextButton") then
                    textValue = tostring(object.Text)
                end
            end)

            __DDCore.Log("UI_CLICK path=" .. path .. " text=" .. string.sub(textValue, 1, 100))
        end)
        table.insert(__DDCore.State.buttonConnections, connection)
    end)
end

for _, object in ipairs(ScreenGui:GetDescendants()) do
    __DDCore.WatchButton(object)
end
__DDCore.State.guiConnection = ScreenGui.DescendantAdded:Connect(function(object)
    __DDCore.WatchButton(object)
end)

__DDCore.Log("INIT checkpoint: diagnostic wrappers and GUI click watcher installed")

--// INIT
--// =========================================================
__DDCore.Log("INIT: beginning final config save and picker preload")
pcall(function()
    __UI.__L.clampWindowPosition()
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
    __UI.__L.rebuildPicker()
end)

pcall(function()
    cosmetic.rebuildPicker()
end)

__DDCore.Log("INIT checkpoint: picker preload calls completed; applying initial GUI state")
setMainMinimized(false)
updateGUI()
pcall(function()
    __UI.__L.setCategory("Emotes")
end)
__DDCore.Log("INIT: loading external Portrait component")
loadstring(game:HttpGet("https://raw.githubusercontent.com/skirkzhdimenya-source/DeadEye/main/DeadEye_Portrait.lua"))()
__DDCore.Log("INIT COMPLETE: core GUI and Portrait loader returned")
