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
local D = {}
D.ReplicatedStorage = game:GetService("ReplicatedStorage")
D.__UI = {}
D.Players = game:GetService("Players")
D.UserInputService = game:GetService("UserInputService")
D.RunService = game:GetService("RunService")
local LocalPlayer = D.Players.LocalPlayer
D.genv = getgenv and getgenv() or _G
--// =========================================================
--// PREVIOUS INSTANCE CLEANUP
--// =========================================================
if D.genv.UNUSUAL_SWAPPER_CLEANUP then
    pcall(function()
        D.genv.UNUSUAL_SWAPPER_CLEANUP()
    end)
end
if D.genv.DEADEYE_PORTRAIT_CLEANUP then
    pcall(function()
        D.genv.DEADEYE_PORTRAIT_CLEANUP()
    end)
end
if D.genv.EMOTE_SWAPPER_CLEANUP then
    pcall(function()
        D.genv.EMOTE_SWAPPER_CLEANUP()
    end)
end
D.genv.DEADEYE_MAIN_RUNNING = true
D.genv.EMOTE_SWAPPER_RUNNING = true
D.genv.DEADEYE_PORTRAIT_RUNNING = true
--// =========================================================
--// SERVICES
--// =========================================================
D.__UI.CharacterService = require(
    D.ReplicatedStorage.Services.Asset.CharacterService
)
D.__UI.ClientItemService = require(
    D.ReplicatedStorage.Services.Items.ClientItemService
)
D.__UI.EmoteService = require(
    D.ReplicatedStorage.Services.Items.EmoteService
)
D.Registry = require(
    D.ReplicatedStorage.Items.Registry
)
D.HttpService = game:GetService("HttpService")
--// =========================================================
--// SETTINGS
--// =========================================================
D.SLOT_COUNT = 12
D.CONFIG_FILE = "DeadEye_Config.json"
D.savedConfig = {
    version = 1,
    emotes = {},
    unusual = {},
    D.others = {},
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
function loadSavedConfig()
    if type(readfile) ~= "function" then
        return
    end
    local success, raw
    if type(isfile) == "function" then
        local exists = false
        pcall(function()
            exists = isfile(D.CONFIG_FILE)
        end)
        if not exists then
            return
        end
    end
    success, raw =
        pcall(function()
            return readfile(
                D.CONFIG_FILE
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
            return D.HttpService:JSONDecode(
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
        D.savedConfig.emotes =
            decoded.emotes
    end
    if type(decoded.unusual) == "table" then
        D.savedConfig.unusual =
            decoded.unusual
    end
    if type(decoded.others) == "table" then
        D.savedConfig.others =
            decoded.others
    end
    if type(decoded.main) == "table" then
        D.savedConfig.main =
            decoded.main
    end
    D.savedConfig.main.hideUIHotkey =
        D.savedConfig.main.hideUIHotkey
        or "H"

    if type(decoded.gui) == "table" then
        D.savedConfig.gui = D.savedConfig.gui or {}

        D.savedConfig.gui.x =
            tonumber(decoded.gui.x)
            or D.savedConfig.gui.x
            or 35

        D.savedConfig.gui.y =
            tonumber(decoded.gui.y)
            or D.savedConfig.gui.y
            or 80

        D.savedConfig.gui.width =
            tonumber(decoded.gui.width)
            or D.savedConfig.gui.width
            or 455

        D.savedConfig.gui.height =
            tonumber(decoded.gui.height)
            or D.savedConfig.gui.height
            or 320
    end

    D.savedConfig.gui.x =
        tonumber(D.savedConfig.gui.x) or 35
    D.savedConfig.gui.y =
        tonumber(D.savedConfig.gui.y) or 80
    D.savedConfig.gui.width =
        tonumber(D.savedConfig.gui.width) or 455
    D.savedConfig.gui.height =
        tonumber(D.savedConfig.gui.height) or 320

    D.savedConfig.version =
        tonumber(decoded.version)
        or 1
end
function saveSavedConfig()
    if type(writefile) ~= "function" then
        return false
    end
    local success, raw =
        pcall(function()
            return D.HttpService:JSONEncode(
                D.savedConfig
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
                D.CONFIG_FILE,
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
    D.connections = {},
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
            if D.genv.DEADEYE_PORTRAIT_RUNNING then
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
            if D.genv.DEADEYE_PORTRAIT_RUNNING then
                portrait.watch(obj)
            end
        end)
    )

    table.insert(
        portrait.connections,
        D.RunService.Heartbeat:Connect(function()

            if not D.genv.DEADEYE_PORTRAIT_RUNNING then
                return
            end

            local signature = portrait.signature()

            if signature ~= portrait.rigSignature then
                portrait.rigSignature = signature

                if not portrait.refreshQueued then
                    portrait.refreshQueued = true

                    task.defer(function()
                        portrait.refreshQueued = false

                        if D.genv.DEADEYE_PORTRAIT_RUNNING then
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

    D.genv.DEADEYE_PORTRAIT_RUNNING = false

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

D.genv.DEADEYE_PORTRAIT_CLEANUP = portrait.cleanup

--// =========================================================
--// SLOTS
--// =========================================================
D.slots = {}
for i = 1, D.SLOT_COUNT do
    D.slots[i] = {
        originalId = nil,
        replaceId = nil,
        originalName = nil,
        replaceName = nil
    }
end
--// DEFAULT SLOT
D.slots[1].originalId = 1631
D.slots[1].replaceId = 51
D.slots[1].originalName = "Banger"
D.slots[1].replaceName = "RockinStride"
--// Load saved Emote mappings.
for i = 1, D.SLOT_COUNT do
    local saved =
        D.savedConfig.emotes[i]
    if type(saved) == "table" then
        local originalId =
            tonumber(saved.originalId)
        local replaceId =
            tonumber(saved.replaceId)
        if originalId then
            D.slots[i].originalId =
                originalId
        end
        if replaceId then
            D.slots[i].replaceId =
                replaceId
        end
    end
end
--// =========================================================
--// RUNTIME STATE
--// =========================================================
D.enabled = false
D.currentCustomEmote = nil
D.currentOriginalId = nil
D.currentReplaceId = nil
D.replacementRunning = false
D.replacementGeneration = 0
D.lastRegistryEmote = 0
D.cleaned = false
D.connections = {}

--// Native wheel visual state.
--// Keys are logical wheel positions ("Wheel:1", "Wheel2:4"),
--// not GUI Instances. The game can recreate Emote1..Emote6;
--// logical state survives those recreations and repeated ON/OFF.
D.nativeWheelStates = {}
D.nativeWheelRestoreDone = false
--// =========================================================
--// CACHE
--// =========================================================
D.originalModules = {}
D.replaceModules = {}
-- [originalId] = { [animationId] = true }
D.originalAnimationIds = {}
D.emoteList = {}
--// =========================================================
--// GUI STATE
--// =========================================================
D.ScreenGui
D.Main
D.SlotsScroll
D.Picker
D.PickerScroll
D.PickerSearch
D.PickerTitle
D.PickerClose
D.Status
D.Toggle
D.activePickerSlot = nil
D.activePickerSide = nil
D.slotOriginalButtons = {}
D.slotReplaceButtons = {}
D.pickerButtons = {}
--// =========================================================
--// CONNECTION HELPER
--// =========================================================
function DEADEYE_FN_addConnection(connection)
    table.insert(D.connections, connection)
end
function DEADEYE_FN_disconnectAll()
    for _, connection in ipairs(D.connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(D.connections)
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
        return D.__UI.ClientItemService:GetItemFromID(id)
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
    table.clear(D.emoteList)
    local all
    local success, result = pcall(function()
        return D.Registry.GetAll()
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
                        D.emoteList,
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
        D.emoteList,
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
    if D.originalModules[id] then
        return D.originalModules[id]
    end
    local module =
        getItemModule(id)
    if not module then
        return nil
    end
    D.originalModules[id] =
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
    D.originalAnimationIds[id] =
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
    if D.replaceModules[id] then
        return D.replaceModules[id]
    end
    local module =
        getItemModule(id)
    if not module then
        return nil
    end
    D.replaceModules[id] =
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
        D.emoteList
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
    for i = 1, D.SLOT_COUNT do
        local slot =
            D.slots[i]
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
            D.__UI.CharacterService:GetLocalCharacter()
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
function DEADEYE_FN_getCurrentEmoteId(object)
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
function DEADEYE_FN_getRigModel(object)
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
function DEADEYE_FN_getControllers(object)
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
        DEADEYE_FN_getRigModel(object)
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
function DEADEYE_FN_getPlayingTracks(object)
    local result = {}
    for _, controller in ipairs(
        DEADEYE_FN_getControllers(object)
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
function DEADEYE_FN_stopOriginalTracks(
    object,
    originalId
)
    if not object then
        return
    end
    local animationSet =
        D.originalAnimationIds[
            originalId
        ]
    local replacementAnimationIds = {}
    --// Не убивать наши replacement tracks.
    if D.currentCustomEmote
        and D.currentCustomEmote.Animations then
        for _, track in pairs(
            D.currentCustomEmote.Animations
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
        DEADEYE_FN_getPlayingTracks(object)
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
function DEADEYE_FN_stopOriginalSounds(object)
    if not object then
        return
    end
    local keepSound = nil
    if D.currentCustomEmote
        and D.currentCustomEmote.EmoteSound then
        keepSound =
            D.currentCustomEmote.EmoteSound
    end
    local seen = {}
    local roots = {
        object.Model,
        DEADEYE_FN_getRigModel(object)
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
function DEADEYE_FN_stopEmoteObject(emote)
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
function DEADEYE_FN_stopCustomEmote()
    D.replacementGeneration =
        D.replacementGeneration + 1
    D.replacementRunning = false

    local object =
        getCharacterObject()

    if D.currentCustomEmote then
        if object
            and object.Emote
            == D.currentCustomEmote
        then
            object.Emote = nil
        end

        DEADEYE_FN_stopEmoteObject(
            D.currentCustomEmote
        )

        D.currentCustomEmote =
            nil
    end

    D.currentOriginalId = nil
    D.currentReplaceId = nil
end
--// =========================================================
--// CREATE REPLACEMENT
--// =========================================================
function DEADEYE_FN_createReplacement(
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
        DEADEYE_FN_getRigModel(object)
    if not character
        or not rigModel then
        return nil
    end
    local success, result =
        pcall(function()
            return D.__UI.EmoteService:SetEmote(
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
function DEADEYE_FN_startReplacement(
    object,
    slot
)
    if D.replacementRunning then
        return
    end
    if not slot then
        return
    end
    if not slot.originalId
        or not slot.replaceId then
        return
    end
    D.replacementRunning = true
    D.replacementGeneration =
        D.replacementGeneration + 1
    local myGeneration =
        D.replacementGeneration
    local originalId =
        slot.originalId
    local replaceId =
        slot.replaceId
    task.spawn(function()
        --// Даём штатному коду игры создать оригинал
        task.wait()
        if not D.genv.EMOTE_SWAPPER_RUNNING
            or not D.enabled then
            D.replacementRunning = false
            return
        end
        if myGeneration ~=
            D.replacementGeneration then
            D.replacementRunning = false
            return
        end
        if DEADEYE_FN_getCurrentEmoteId(object)
            ~= originalId then
            D.replacementRunning = false
            return
        end
        --// =================================================
        --// ГАСИМ ОРИГИНАЛ
        --// =================================================
        if object.Emote
            and object.Emote ~= D.currentCustomEmote then
            DEADEYE_FN_stopEmoteObject(
                object.Emote
            )
            object.Emote = nil
        end
        --// =================================================
        --// ГАСИМ ОРИГИНАЛЬНЫЕ TRACKS
        --// =================================================
        DEADEYE_FN_stopOriginalTracks(
            object,
            originalId
        )
        DEADEYE_FN_stopOriginalSounds(
            object
        )
        --// =================================================
        --// СОЗДАЁМ REPLACEMENT
        --// =================================================
        local replacement =
            DEADEYE_FN_createReplacement(
                object,
                replaceId
            )
        if not replacement then
            D.replacementRunning = false
            return
        end
        if myGeneration ~=
            D.replacementGeneration
            or not D.enabled then
            DEADEYE_FN_stopEmoteObject(
                replacement
            )
            D.replacementRunning = false
            return
        end
        D.currentCustomEmote =
            replacement
        D.currentOriginalId =
            originalId
        D.currentReplaceId =
            replaceId
        object.Emote =
            replacement
        DEADEYE_FN_stopOriginalSounds(
            object
        )
        --// Сохраняем штатное состояние
        pcall(function()
            object:RegistryTermUpdated(
                "State"
            )
        end)
                D.replacementRunning = false
    end)
end
--// =========================================================
--// MAIN STATE WATCHER
-- =========================================================
function DEADEYE_FN_checkState()
    if not D.genv.EMOTE_SWAPPER_RUNNING then
        return
    end
    local object =
        getCharacterObject()
    if not object then
        return
    end
    local emoteId =
        DEADEYE_FN_getCurrentEmoteId(object)
    --// =====================================================
    --// NO EMOTE
    --// =====================================================
    if not emoteId
        or emoteId == 0 then
        if D.currentCustomEmote then
                    end
        DEADEYE_FN_stopCustomEmote()
        D.lastRegistryEmote = 0
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
        if D.currentCustomEmote then
            DEADEYE_FN_stopCustomEmote()
        end
        D.lastRegistryEmote =
            emoteId
        return
    end
    --// =====================================================
    --// IMPORTANT FIX:
    --// ЕСЛИ ORIGINAL АКТИВНА, НО REPLACEMENT ПОЧЕМУ-ТО
    --// ПРОПАЛ - ЗАПУСКАЕМ ЕГО СНОВА.
    --// =====================================================
    if not D.currentCustomEmote
        and not D.replacementRunning then
        DEADEYE_FN_startReplacement(
            object,
            slot
        )
        D.lastRegistryEmote =
            emoteId
        return
    end
    --// =====================================================
    --// WHILE ACTIVE:
    --// CONTINUOUSLY SUPPRESS ORIGINAL
    --// =====================================================
    if D.currentCustomEmote then
        DEADEYE_FN_stopOriginalTracks(
            object,
            emoteId
        )
        DEADEYE_FN_stopOriginalSounds(
            object
        )
        --// Если штатная система снова создала
        --// оригинальный Emote object.
        if object.Emote
            and object.Emote ~= D.currentCustomEmote then
            DEADEYE_FN_stopEmoteObject(
                object.Emote
            )
            object.Emote =
                D.currentCustomEmote
        end
    end
    D.lastRegistryEmote =
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
    for i = 1, D.SLOT_COUNT do
        local slot =
            D.slots[i]
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
D.guiParent
pcall(function()
    D.guiParent = gethui()
end)
if not D.guiParent then
    D.guiParent =
        game:GetService("CoreGui")
end
--// =========================================================
--// SCREEN GUI
--// =========================================================
D.ScreenGui =
    Instance.new("ScreenGui")
D.ScreenGui.Name =
    "EmoteSwapperGUI"
D.ScreenGui.ResetOnSpawn =
    false
D.ScreenGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling
D.ScreenGui.Parent =
    D.guiParent
--// =========================================================
--// MAIN
--// =========================================================
D.Main =
    Instance.new("Frame")
D.Main.Size =
    UDim2.new(
        0,
        math.max(
            455,
            D.savedConfig.gui.width
        ),
        0,
        math.max(
            285,
            D.savedConfig.gui.height
        )
    )
D.Main.Position =
    UDim2.new(
        0,
        D.savedConfig.gui.x,
        0,
        D.savedConfig.gui.y
    )
D.Main.BackgroundColor3 =
    Color3.fromRGB(
        18,
        20,
        24
    )
D.Main.BackgroundTransparency =
    1
D.Main.BorderSizePixel =
    0
D.Main.ClipsDescendants =
    true
D.Main.Parent =
    D.ScreenGui

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
    D.Main

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

D.__UI.MainGradient =
    Instance.new("UIGradient")
D.__UI.MainGradient.Rotation =
    115
D.__UI.MainGradient.Color =
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
D.__UI.MainGradient.Transparency =
    NumberSequence.new(0.20)
D.__UI.MainGradient.Parent =
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
    D.Main

local MainHeaderCorner =
    Instance.new("UICorner")

MainHeaderCorner.CornerRadius =
    UDim.new(
        0,
        11
    )

MainHeaderCorner.Parent =
    MainHeader

D.__UI.MainHeaderGradient =
    Instance.new("UIGradient")
D.__UI.MainHeaderGradient.Rotation =
    90
D.__UI.MainHeaderGradient.Color =
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
D.__UI.MainHeaderGradient.Transparency =
    NumberSequence.new(0.18)
D.__UI.MainHeaderGradient.Parent =
    MainHeader

D.__UI.MainHeaderLine =
    Instance.new("Frame")
D.__UI.MainHeaderLine.Name =
    "HeaderAccent"
D.__UI.MainHeaderLine.Size =
    UDim2.new(
        1,
        -24,
        0,
        1
    )
D.__UI.MainHeaderLine.Position =
    UDim2.new(
        0,
        12,
        1,
        -1
    )
D.__UI.MainHeaderLine.BackgroundTransparency =
    1
D.__UI.MainHeaderLine.Visible =
    false
D.__UI.MainHeaderLine.BorderSizePixel =
    0
D.__UI.MainHeaderLine.ZIndex =
    1
D.__UI.MainHeaderLine.Parent =
    D.Main

--// =========================================================
--// TITLE
--// =========================================================
D.MainTitle =
    Instance.new("TextLabel")
D.MainTitle.Size =
    UDim2.new(
        1,
        -105,
        0,
        36
    )
D.MainTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        2
    )
D.MainTitle.BackgroundTransparency =
    1
D.MainTitle.Text =
    "DeadEyes v1"
D.MainTitle.TextSize =
    18
D.MainTitle.Font =
    Enum.Font.GothamBold
D.MainTitle.ZIndex =
    2
D.MainTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.MainTitle.TextXAlignment =
    Enum.TextXAlignment.Left
D.MainTitle.Parent =
    D.Main
--// =========================================================
--// MINIMIZE
--// =========================================================
D.Minimize =
    Instance.new("TextButton")
D.Minimize.Size =
    UDim2.new(
        0,
        27,
        0,
        27
    )
D.Minimize.Position =
    UDim2.new(
        1,
        -65,
        0,
        6
    )
D.Minimize.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
D.Minimize.BorderSizePixel =
    0
D.Minimize.Text =
    "−"
D.Minimize.TextSize =
    20
D.Minimize.AutoButtonColor =
    true
D.Minimize.ZIndex =
    5
D.Minimize.BackgroundTransparency =
    0.05
D.Minimize.Font =
    Enum.Font.GothamBold
D.Minimize.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.Minimize.Parent =
    D.Main
D.__UI.MinimizeCorner =
    Instance.new("UICorner")
D.__UI.MinimizeCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
D.__UI.MinimizeCorner.Parent =
    D.Minimize
--// =========================================================
--// CLOSE
--// =========================================================
D.Close =
    Instance.new("TextButton")
D.Close.Size =
    UDim2.new(
        0,
        27,
        0,
        27
    )
D.Close.Position =
    UDim2.new(
        1,
        -32,
        0,
        6
    )
D.Close.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        50
    )
D.Close.BackgroundTransparency =
    0.05
D.Close.BorderSizePixel =
    0
D.Close.ZIndex =
    5
D.Close.Text =
    "×"
D.Close.TextSize =
    27
D.Close.Font =
    Enum.Font.GothamBold
D.Close.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.Close.Parent =
    D.Main

D.__UI.CloseCorner =
    Instance.new("UICorner")
D.__UI.CloseCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
D.__UI.CloseCorner.Parent =
    D.Close

D.__UI.CloseStroke =
    Instance.new("UIStroke")
D.__UI.CloseStroke.Thickness =
    1
D.__UI.CloseStroke.Transparency =
    0.65
D.__UI.CloseStroke.Parent =
    D.Close

--// =========================================================
--// STATUS
--// =========================================================
D.Status =
    Instance.new("TextLabel")
D.Status.Size =
    UDim2.new(
        0,
        190,
        0,
        20
    )
D.Status.Position =
    UDim2.new(
        0,
        10,
        0,
        43
    )
D.Status.BackgroundTransparency =
    1
D.Status.Text =
    ""
D.Status.TextSize =
    12
D.Status.Font =
    Enum.Font.Gotham
D.Status.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
D.Status.TextXAlignment =
    Enum.TextXAlignment.Left
D.Status.Parent =
    D.Main
--// =========================================================
--// UNUSUAL CATEGORY
--// ONE SLOT
--//
--// [Original] -> [Replace]
--//
--// FX-only local replacement.
--// =========================================================
D.unusualSlot = {
    originalId = nil,
    replaceId = 200,
    originalName = nil,
    replaceName = nil
}
D.unusualList = {}
D.unusualEnabled = false
D.unusualActive = false
D.unusualPicker
D.unusualPickerScroll
D.unusualPickerSearch
D.unusualPickerTitle
D.unusualPickerClose
D.unusualPickerButtons = {}
D.unusualPickerSide = nil
D.unusualIconCache = {}
D.unusualIconIdCache = {}

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
            D.Registry.GetConfig(
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
            D.unusualIconCache[key] = image
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

        D.RunService.Heartbeat:Wait()
        D.RunService.Heartbeat:Wait()

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
D.unusualPage
D.unusualStatus
D.categoryBar
D.mainCategoryButton
D.emoteCategoryButton
D.unusualCategoryButton
D.othersCategoryButton
D.currentCategory = "Emotes"
D.mainPage
D.others = {}
D.mainMinimized = false
D.setMainMinimized
D.updateUnusualToggle
D.others.originalDescription = nil
D.others.targetHumanoid = nil
D.others.page = nil
D.others.status = nil
D.others.fieldButtons = {}
D.others.fieldBoxes = {}
D.unusualConnections = {}
D.unusualDestroyed = false
D.unusualReapplyBusy = false
D.unusualRuntime = {
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
function DEADEYE_FN_addUnusualConnection(connection)
    table.insert(
        D.unusualConnections,
        connection
    )
end
function DEADEYE_FN_disconnectUnusualConnections()
    for _, connection in ipairs(
        D.unusualConnections
    ) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(
        D.unusualConnections
    )

    D.unusualReapplyBusy = false
end
--// =========================================================
--// UNUSUAL LIST
--// =========================================================
function DEADEYE_FN_buildUnusualList()
    table.clear(
        D.unusualList
    )
    local success, all = pcall(function()
        return D.Registry.GetAll()
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
                    D.Registry.GetConfig(
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
                            D.Registry.GetById(
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
                        D.unusualIconIdCache[
                            numericId
                        ] = icon
                    end

                    table.insert(
                        D.unusualList,
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
        D.unusualList,
        function(a, b)
            return a.id < b.id
        end
    )

    local iconCount = 0

    for _, data in ipairs(
        D.unusualList
    ) do
        if data.icon then
            iconCount += 1
        end
    end

    warn(
        "[DeadEye] Native Unusual icons:",
        tostring(iconCount),
        "/",
        tostring(#D.unusualList)
    )
    end
DEADEYE_FN_buildUnusualList()
--// =========================================================
--// GET UNUSUAL NAME
--// =========================================================
function DEADEYE_FN_getUnusualName(id)
    id =
        tonumber(id)
    if not id then
        return nil
    end
    for _, data in ipairs(
        D.unusualList
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
function DEADEYE_FN_getEquippedUnusualId()
    local value = 0
    pcall(function()
        value =
            require(
                D.ReplicatedStorage.Shared.UserData.ClientHooks:WaitForChild("useLoadout")
            ).GetEquippedFromSlot(
                "UnusualSlot"
            )
    end)
    return tonumber(value) or 0
end
--// First run: original = actual equipped Unusual.
do
    local equipped =
        DEADEYE_FN_getEquippedUnusualId()
    if equipped ~= 0 then
        D.unusualSlot.originalId =
            equipped
        D.unusualSlot.originalName =
            DEADEYE_FN_getUnusualName(
                equipped
            )
    end
    local savedUnusual =
        D.savedConfig.unusual
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
            D.unusualSlot.originalId =
                savedOriginal
            D.unusualSlot.originalName =
                DEADEYE_FN_getUnusualName(
                    savedOriginal
                )
        end
        if savedReplace then
            D.unusualSlot.replaceId =
                savedReplace
        end
    end
    D.unusualSlot.replaceName =
        DEADEYE_FN_getUnusualName(
            D.unusualSlot.replaceId
        )
end
--// =========================================================
--// GET REAL PLAYER CHARACTER
--// =========================================================
function DEADEYE_FN_getUnusualPlayerCharacter()
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
function DEADEYE_FN_getUnusualVisualRig()
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
function DEADEYE_FN_getUnusualCosmeticRig(
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
D.UNUSUAL_FX_CLASSES = {
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
function DEADEYE_FN_isUnusualFX(object)
    return D.UNUSUAL_FX_CLASSES[
        object.ClassName
    ] == true
end
function DEADEYE_FN_unusualAttachmentHasFX(
    attachment
)
    for _, descendant in ipairs(
        attachment:GetDescendants()
    ) do
        if DEADEYE_FN_isUnusualFX(descendant) then
            return true
        end
    end
    return false
end

--// =========================================================
--// TAG OUR FX
--// =========================================================
function DEADEYE_FN_tagUnusualFX(
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
            and DEADEYE_FN_unusualAttachmentHasFX(
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

            if DEADEYE_FN_isUnusualFX(object) then
                return true
            end

            if object:IsA("Attachment")
                and DEADEYE_FN_unusualAttachmentHasFX(
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
D.unusualRuntime.destroyAnimationSource = function()
    if D.unusualRuntime.animationSource then
        pcall(function()
            D.unusualRuntime.animationSource:Destroy()
        end)
    end

    D.unusualRuntime.animationSource = nil
    table.clear(
        D.unusualRuntime.animationLinks
    )

    for _, mirror in ipairs(
        D.unusualRuntime.visualMirrors
    ) do
        if mirror.model then
            pcall(function()
                mirror.model:Destroy()
            end)
        end
    end

    table.clear(
        D.unusualRuntime.visualMirrors
    )

    if D.unusualRuntime.specialCircling
        and D.unusualRuntime.specialCircling.model
    then
        pcall(function()
            D.unusualRuntime.specialCircling.model:Destroy()
        end)
    end

    D.unusualRuntime.specialCircling = nil

    for _, item in ipairs(
        D.unusualRuntime.animatedNestedVisuals
    ) do
        if item.model then
            pcall(function()
                item.model:Destroy()
            end)
        end
    end

    table.clear(
        D.unusualRuntime.animatedNestedVisuals
    )
end

D.unusualRuntime.findRelative = function(
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

D.unusualRuntime.startAnimations = function(
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

D.unusualRuntime.installAnimatedNestedModels = function(
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

                DEADEYE_FN_tagUnusualFX(
                    clone,
                    id
                )

                --// Start the same AnimationController
                --// animation that the source effect uses.
                D.unusualRuntime.startAnimations(
                    clone
                )

                table.insert(
                    D.unusualRuntime.animatedNestedVisuals,
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


D.unusualRuntime.createAnimationSource = function(
    cosmeticRig,
    id,
    playerCharacter
)
    D.unusualRuntime.destroyAnimationSource()

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
            DEADEYE_FN_getUnusualVisualRig()

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

        D.unusualRuntime.startAnimations(
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

    D.unusualRuntime.animationSource =
        source

    return source
end

D.unusualRuntime.createVisualMirror = function(
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
            #D.unusualRuntime.visualMirrors + 1
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
        D.unusualRuntime.visualMirrors,
        {
            model = clone,
            links = links
        }
    )

    return true
end

D.unusualRuntime.addAnimationLink = function(
    sourcePart,
    nested,
    targetPart,
    animatedSource
)
    if not animatedSource then
        return false
    end

    local animatedPart =
        D.unusualRuntime.findRelative(
            animatedSource,
            nested
        )

    local animatedRoot =
        D.unusualRuntime.findRelative(
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
        D.unusualRuntime.animationLinks,
        {
            sourceRoot = animatedRoot,
            sourcePart = animatedPart,
            targetPart = targetPart,
            anchor = nil
        }
    )

    return true
end

D.unusualRuntime.updateAnimatedParts = function()
    local source =
        D.unusualRuntime.animationSource

    if not source
        or not source.Parent
    then
        return
    end

    local targetRig =
        DEADEYE_FN_getUnusualVisualRig()

    local targetRoot

    if targetRig then
        targetRoot =
            targetRig:FindFirstChild(
                "HumanoidRootPart"
            )
    end

    if not targetRoot then
        local character =
            DEADEYE_FN_getUnusualPlayerCharacter()

        if character then
            targetRoot =
                character:FindFirstChild(
                    "HumanoidRootPart"
                )
        end
    end

    if D.unusualRuntime.specialCircling
        and D.unusualRuntime.specialCircling.root
        and D.unusualRuntime.specialCircling.root.Parent
        and targetRoot
    then

        pcall(function()
            D.unusualRuntime.specialCircling.root.CFrame =
                targetRoot.CFrame *
                D.unusualRuntime.specialCircling.offset
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
        D.unusualRuntime.visualMirrors
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
        D.unusualRuntime.animationLinks
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

    DEADEYE_FN_tagUnusualFX(
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
                D.unusualRuntime.createVisualMirror(
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
                    D.unusualRuntime.addAnimationLink(
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

                    D.unusualRuntime.animationLinks[
                        #D.unusualRuntime.animationLinks
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

                    DEADEYE_FN_tagUnusualFX(
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

                if DEADEYE_FN_isUnusualFX(
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

                        DEADEYE_FN_tagUnusualFX(
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
        DEADEYE_FN_getUnusualCosmeticRig(
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
        D.unusualRuntime.createAnimationSource(
            cosmeticRig,
            id,
            playerCharacter
        )

    local animatedNestedInstalled =
        D.unusualRuntime.installAnimatedNestedModels(
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
function DEADEYE_FN_removeOurUnusualFX()
    D.unusualRuntime.destroyAnimationSource()

    local removed = 0
    local roots = {
        DEADEYE_FN_getUnusualVisualRig(),
        DEADEYE_FN_getUnusualPlayerCharacter()
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
function DEADEYE_FN_hasOurUnusualFX(
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
function DEADEYE_FN_buildOriginalUnusualSignature(
    id,
    visualRig
)
    local cosmeticRig =
        DEADEYE_FN_getUnusualCosmeticRig(
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
        if DEADEYE_FN_isUnusualFX(object) then
            return true
        end

        if object:IsA("BasePart") then
            return true
        end

        for _, descendant in ipairs(
            object:GetDescendants()
        ) do
            if DEADEYE_FN_isUnusualFX(descendant)
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
function DEADEYE_FN_removeOriginalUnusualFX(
    id,
    visualRig,
    playerCharacter
)
    local signature =
        DEADEYE_FN_buildOriginalUnusualSignature(
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
function DEADEYE_FN_restoreUnusual()
    if not D.unusualActive then
        return
    end
    local visualRig =
        DEADEYE_FN_getUnusualVisualRig()
    local playerCharacter =
        DEADEYE_FN_getUnusualPlayerCharacter()
    if visualRig
        and D.unusualSlot.originalId
    then
        DEADEYE_FN_removeOurUnusualFX()
        task.wait()
        applyUnusualFX(
            D.unusualSlot.originalId,
            visualRig,
            playerCharacter
        )
    end
    D.unusualActive =
        false
    D.unusualRuntime.appliedRig =
        nil
end
--// =========================================================
--// ACTIVATE UNUSUAL
-- =========================================================
function DEADEYE_FN_activateUnusual()
    if not D.unusualSlot.originalId
        or not D.unusualSlot.replaceId
    then
        return false
    end
    if D.unusualSlot.originalId
        == D.unusualSlot.replaceId
    then
        return false
    end
    local visualRig =
        DEADEYE_FN_getUnusualVisualRig()
    local playerCharacter =
        DEADEYE_FN_getUnusualPlayerCharacter()
    if not visualRig then
        return false
    end
                            DEADEYE_FN_removeOurUnusualFX()
    task.wait()
    DEADEYE_FN_removeOriginalUnusualFX(
        D.unusualSlot.originalId,
        visualRig,
        playerCharacter
    )
    task.wait()
    if not applyUnusualFX(
        D.unusualSlot.replaceId,
        visualRig,
        playerCharacter
    ) then
        task.wait()
        applyUnusualFX(
            D.unusualSlot.originalId,
            visualRig,
            playerCharacter
        )
        return false
    end
    D.unusualActive =
        true
    D.unusualRuntime.appliedRig =
        visualRig
    return true
end
function DEADEYE_FN_reapplyUnusual()
    if not D.unusualEnabled
        or D.unusualReapplyBusy
    then
        return
    end

    D.unusualReapplyBusy = true
    D.unusualRuntime.reapplyGeneration += 1

    local generation =
        D.unusualRuntime.reapplyGeneration

    task.spawn(function()

        for attempt = 1, 20 do

            if not D.unusualEnabled
                or D.genv.DEADEYE_UNUSUAL_POV_RUNNING == false
                or generation ~= D.unusualRuntime.reapplyGeneration
            then
                break
            end

            local visualRig =
                DEADEYE_FN_getUnusualVisualRig()

            local playerCharacter =
                DEADEYE_FN_getUnusualPlayerCharacter()

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

                D.unusualActive = false
                DEADEYE_FN_removeOurUnusualFX()

                local ok, result =
                    pcall(function()
                        return DEADEYE_FN_activateUnusual()
                    end)

                if ok
                    and result == true
                then

                    local expected =
                        (
                            #D.unusualRuntime.animatedNestedVisuals > 0
                        )
                        or DEADEYE_FN_hasOurUnusualFX(
                            visualRig,
                            D.unusualSlot.replaceId
                        )
                        or DEADEYE_FN_hasOurUnusualFX(
                            playerCharacter,
                            D.unusualSlot.replaceId
                        )

                    if expected then
                        D.unusualRuntime.appliedRig =
                            visualRig
                        break
                    end

                end

            end

            task.wait(0.25)

        end

        D.unusualReapplyBusy = false

    end)
end
--// =========================================================
--// FIRST PERSON / VIEWMODEL SYNC
--//
--// 3P uses workspace.Rigs.<name>.
--// 1P uses workspace.Camera.Viewmodel.Clothing.
--// In 1P the game hides the 3P rig with LocalTransparencyModifier.
--// =========================================================
D.genv.DEADEYE_UNUSUAL_POV_RUNNING = true
D.lastUnusualPOVState = nil
function DEADEYE_FN_getUnusualViewmodel()
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
function DEADEYE_FN_isUnusualFirstPerson()
    local visualRig =
        DEADEYE_FN_getUnusualVisualRig()
    if not visualRig then
        return false
    end
    local bodyNames = {
        "Head",
        "Torso",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg"
    }
    local total = 0
    local hidden = 0
    for _, name in ipairs(
        bodyNames
    ) do
        local part =
            visualRig:FindFirstChild(
                name
            )
        if part
            and part:IsA("BasePart")
        then
            total += 1
            if part.LocalTransparencyModifier
                >= 0.99
            then
                hidden += 1
            end
        end
    end
    if total > 0
        and hidden >= math.ceil(
            total * 0.5
        )
    then
        return true
    end
    --// Fallback only when the rig does not expose
    --// LocalTransparencyModifier yet.
    local camera =
        workspace.CurrentCamera
    local head =
        visualRig:FindFirstChild(
            "Head"
        )
    if camera
        and head
    then
        local distance =
            (
                camera.CFrame.Position
                - head.Position
            ).Magnitude
        if distance < 1.5 then
            return true
        end
    end
    return false
end
function DEADEYE_FN_syncUnusualViewmodelAppearance()
    local visualRig =
        DEADEYE_FN_getUnusualVisualRig()
    if not visualRig then
        return
    end
    local viewmodel =
        DEADEYE_FN_getUnusualViewmodel()
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
    --// Shirt: the 1P viewmodel has its own shirt,
    --// and it was confirmed to contain the old skin.
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
    --// Body colors.
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
function DEADEYE_FN_setUnusualFXForPOV(
    firstPerson
)
    local roots = {
        DEADEYE_FN_getUnusualVisualRig(),
        DEADEYE_FN_getUnusualPlayerCharacter()
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
                local tagged =
                    false
                pcall(function()
                    tagged =
                        object:GetAttribute(
                            "DeadEyeUnusualFX"
                        ) == true
                end)
                if tagged then
                    --// Trail is always kept.
                    --// Every other supported FX is hidden in 1P.
                    if object:IsA("Trail") then
                        pcall(function()
                            object.Enabled =
                                true
                        end)
                    elseif object:IsA("ParticleEmitter")
                        or object:IsA("Beam")
                        or object:IsA("Sparkles")
                        or object:IsA("Fire")
                        or object:IsA("Smoke")
                        or object:IsA("Highlight")
                        or object:IsA("PointLight")
                        or object:IsA("SpotLight")
                        or object:IsA("SurfaceLight")
                        or object:IsA("BillboardGui")
                    then
                        pcall(function()
                            object.Enabled =
                                not firstPerson
                        end)
                    end
                end
            end
        end
    end
end
function DEADEYE_FN_updateUnusualPOV()
    if not D.genv.DEADEYE_UNUSUAL_POV_RUNNING then
        return
    end
    DEADEYE_FN_syncUnusualViewmodelAppearance()
    local firstPerson =
        DEADEYE_FN_isUnusualFirstPerson()
    if firstPerson
        ~= D.lastUnusualPOVState
    then
        D.lastUnusualPOVState =
            firstPerson
        DEADEYE_FN_setUnusualFXForPOV(
            firstPerson
        )
    elseif D.unusualActive then
        --// Re-apply the state when the game recreates
        --// one of the tagged FX while staying in the same POV.
        DEADEYE_FN_setUnusualFXForPOV(
            firstPerson
        )
    end
end
DEADEYE_FN_addUnusualConnection(
    D.RunService.Heartbeat:Connect(
        function()

            if not D.genv.DEADEYE_UNUSUAL_POV_RUNNING then
                return
            end

            D.unusualRuntime.updateAnimatedParts()
            DEADEYE_FN_updateUnusualPOV()

            if D.unusualEnabled
                and not D.unusualReapplyBusy
            then

                local rig =
                    DEADEYE_FN_getUnusualVisualRig()

                if rig then

                    local expected =
                        (
                            #D.unusualRuntime.animatedNestedVisuals > 0
                        )
                        or DEADEYE_FN_hasOurUnusualFX(
                            rig,
                            D.unusualSlot.replaceId
                        )
                        or DEADEYE_FN_hasOurUnusualFX(
                            DEADEYE_FN_getUnusualPlayerCharacter(),
                            D.unusualSlot.replaceId
                        )

                    if D.unusualRuntime.appliedRig ~= rig
                        or not expected
                    then
                        DEADEYE_FN_reapplyUnusual()
                    end

                end

            end

        end
    )
)
--// =========================================================
--// UNUSUAL PAGE
--// =========================================================
D.unusualPage =
    Instance.new("ScrollingFrame")
D.unusualPage.Name =
    "UnusualPage"
D.unusualPage.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
D.unusualPage.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
D.unusualPage.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
D.unusualPage.BorderSizePixel =
    0
D.unusualPage.ScrollBarThickness =
    6
D.unusualPage.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
D.unusualPage.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
D.unusualPage.ScrollingDirection =
    Enum.ScrollingDirection.Y
D.unusualPage.Visible =
    false
D.unusualPage.Parent =
    D.Main
D.__UI.unusualPageCorner =
    Instance.new("UICorner")
D.__UI.unusualPageCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
D.__UI.unusualPageCorner.Parent =
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
    D.unusualPage
D.unusualLayout =
    Instance.new("UIListLayout")
D.unusualLayout.Padding =
    UDim.new(
        0,
        7
    )
D.unusualLayout.SortOrder =
    Enum.SortOrder.LayoutOrder
D.unusualLayout.Parent =
    D.unusualPage
D.unusualRow =
    Instance.new("Frame")
D.unusualRow.Size =
    UDim2.new(
        1,
        -4,
        0,
        48
    )
D.unusualRow.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
D.unusualRow.BorderSizePixel =
    0
D.unusualRow.LayoutOrder =
    1
D.unusualRow.Parent =
    D.unusualPage
D.__UI.unusualRowCorner =
    Instance.new("UICorner")
D.__UI.unusualRowCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
D.__UI.unusualRowCorner.Parent =
    D.unusualRow
D.unusualRowLabel =
    Instance.new("TextLabel")
D.unusualRowLabel.Size =
    UDim2.new(
        0,
        60,
        1,
        0
    )
D.unusualRowLabel.Position =
    UDim2.new(
        0,
        8,
        0,
        0
    )
D.unusualRowLabel.BackgroundTransparency =
    1
D.unusualRowLabel.Text =
    "UNUSUAL"
D.unusualRowLabel.TextSize =
    10
D.unusualRowLabel.Font =
    Enum.Font.GothamBold
D.unusualRowLabel.TextColor3 =
    Color3.fromRGB(
        210,
        210,
        210
    )
D.unusualRowLabel.TextXAlignment =
    Enum.TextXAlignment.Left
D.unusualRowLabel.Parent =
    D.unusualRow
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
    D.unusualSlot.originalName
    or "Select"
unusualOriginalButton.TextSize =
    11
unusualOriginalButton.Font =
    Enum.Font.Gotham
unusualOriginalButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
unusualOriginalButton.TextTruncate =
    Enum.TextTruncate.AtEnd
unusualOriginalButton.Parent =
    D.unusualRow
D.__UI.unusualOriginalCorner =
    Instance.new("UICorner")
D.__UI.unusualOriginalCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
D.__UI.unusualOriginalCorner.Parent =
    unusualOriginalButton
--// ARROW
D.unusualArrow =
    Instance.new("TextLabel")
D.unusualArrow.Size =
    UDim2.new(
        0,
        24,
        0,
        32
    )
D.unusualArrow.Position =
    UDim2.new(
        0,
        202,
        0.5,
        -16
    )
D.unusualArrow.BackgroundTransparency =
    1
D.unusualArrow.Text =
    "→"
D.unusualArrow.TextSize =
    22
D.unusualArrow.Font =
    Enum.Font.GothamBold
D.unusualArrow.TextColor3 =
    Color3.fromRGB(
        180,
        180,
        180
    )
D.unusualArrow.Parent =
    D.unusualRow
--// REPLACE
D.unusualReplaceButton =
    Instance.new("TextButton")
D.unusualReplaceButton.Size =
    UDim2.new(
        0,
        125,
        0,
        32
    )
D.unusualReplaceButton.Position =
    UDim2.new(
        0,
        226,
        0.5,
        -16
    )
D.unusualReplaceButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
D.unusualReplaceButton.BorderSizePixel =
    0
D.unusualReplaceButton.Text =
    D.unusualSlot.replaceName
    or "NONE"
D.unusualReplaceButton.TextSize =
    11
D.unusualReplaceButton.Font =
    Enum.Font.Gotham
D.unusualReplaceButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.unusualReplaceButton.TextTruncate =
    Enum.TextTruncate.AtEnd
D.unusualReplaceButton.Parent =
    D.unusualRow
D.__UI.unusualReplaceCorner =
    Instance.new("UICorner")
D.__UI.unusualReplaceCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
D.__UI.unusualReplaceCorner.Parent =
    D.unusualReplaceButton
--// =========================================================
--// UNUSUAL PICKER
-- =========================================================
D.unusualPicker =
    Instance.new("Frame")
D.unusualPicker.Size =
    UDim2.new(
        0,
        560,
        0,
        450
    )
D.unusualPicker.Position =
    UDim2.new(
        0.5,
        -280,
        0.5,
        -225
    )
D.unusualPicker.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )
D.unusualPicker.BackgroundTransparency =
    0.10
D.unusualPicker.BorderSizePixel =
    0
D.unusualPicker.ClipsDescendants =
    true
D.unusualPicker.Visible =
    false
D.unusualPicker.ZIndex =
    30
D.unusualPicker.Parent =
    D.ScreenGui
D.__UI.unusualPickerCorner =
    Instance.new("UICorner")
D.__UI.unusualPickerCorner.CornerRadius =
    UDim.new(
        0,
        8
    )
D.__UI.unusualPickerCorner.Parent =
    D.unusualPicker
D.__UI.unusualPickerStroke =
    Instance.new("UIStroke")
D.__UI.unusualPickerStroke.Thickness =
    1
D.__UI.unusualPickerStroke.Transparency =
    0.66
D.__UI.unusualPickerStroke.Parent =
    D.unusualPicker

D.__UI.unusualPickerGlass =
    Instance.new("UIGradient")
D.__UI.unusualPickerGlass.Rotation =
    115
D.__UI.unusualPickerGlass.Color =
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
D.__UI.unusualPickerGlass.Transparency =
    NumberSequence.new(0.20)
D.__UI.unusualPickerGlass.Parent =
    D.unusualPicker

D.unusualPickerTitle =
    Instance.new("TextLabel")
D.unusualPickerTitle.Size =
    UDim2.new(
        1,
        -45,
        0,
        32
    )
D.unusualPickerTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        2
    )
D.unusualPickerTitle.BackgroundTransparency =
    1
D.unusualPickerTitle.Text =
    "Unusual Selector"
D.unusualPickerTitle.TextSize =
    16
D.unusualPickerTitle.Font =
    Enum.Font.GothamBold
D.unusualPickerTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.unusualPickerTitle.TextXAlignment =
    Enum.TextXAlignment.Left
D.unusualPickerTitle.ZIndex =
    31
D.unusualPickerTitle.Parent =
    D.unusualPicker
D.unusualPickerClose =
    Instance.new("TextButton")
D.unusualPickerClose.Size =
    UDim2.new(
        0,
        30,
        0,
        30
    )
D.unusualPickerClose.Position =
    UDim2.new(
        1,
        -35,
        0,
        4
    )
D.unusualPickerClose.BackgroundTransparency =
    1
D.unusualPickerClose.Text =
    "×"
D.unusualPickerClose.TextSize =
    25
D.unusualPickerClose.Font =
    Enum.Font.GothamBold
D.unusualPickerClose.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.unusualPickerClose.ZIndex =
    31
D.unusualPickerClose.Parent =
    D.unusualPicker
D.unusualPickerSearch =
    Instance.new("TextBox")
D.unusualPickerSearch.Size =
    UDim2.new(
        1,
        -20,
        0,
        30
    )
D.unusualPickerSearch.Position =
    UDim2.new(
        0,
        10,
        0,
        36
    )
D.unusualPickerSearch.BackgroundColor3 =
    Color3.fromRGB(
        40,
        45,
        53
    )
D.unusualPickerSearch.BackgroundTransparency =
    0.20
D.unusualPickerSearch.BorderSizePixel =
    0
D.unusualPickerSearch.ClearTextOnFocus =
    false
D.unusualPickerSearch.PlaceholderText =
    "Search by name or ID..."
D.unusualPickerSearch.PlaceholderColor3 =
    Color3.fromRGB(
        120,
        120,
        120
    )
D.unusualPickerSearch.Text =
    ""
D.unusualPickerSearch.TextSize =
    12
D.unusualPickerSearch.Font =
    Enum.Font.Gotham
D.unusualPickerSearch.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.unusualPickerSearch.ZIndex =
    32
D.unusualPickerSearch.Parent =
    D.unusualPicker
D.__UI.unusualSearchCorner =
    Instance.new("UICorner")
D.__UI.unusualSearchCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
D.__UI.unusualSearchCorner.Parent =
    D.unusualPickerSearch
D.unusualPickerScroll =
    Instance.new("ScrollingFrame")
D.unusualPickerScroll.Size =
    UDim2.new(
        1,
        -16,
        1,
        -74
    )
D.unusualPickerScroll.Position =
    UDim2.new(
        0,
        8,
        0,
        70
    )
D.unusualPickerScroll.BackgroundColor3 =
    Color3.fromRGB(
        32,
        35,
        42
    )
D.unusualPickerScroll.BackgroundTransparency =
    0.20
D.unusualPickerScroll.BorderSizePixel =
    0
D.unusualPickerScroll.ScrollBarThickness =
    6
D.unusualPickerScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
D.unusualPickerScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
D.unusualPickerScroll.ZIndex =
    31
D.unusualPickerScroll.Parent =
    D.unusualPicker
D.__UI.unusualPickerScrollCorner =
    Instance.new("UICorner")
D.__UI.unusualPickerScrollCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
D.__UI.unusualPickerScrollCorner.Parent =
    D.unusualPickerScroll
D.unusualPickerPadding =
    Instance.new("UIPadding")
D.unusualPickerPadding.PaddingTop =
    UDim.new(0, 8)
D.unusualPickerPadding.PaddingBottom =
    UDim.new(0, 8)
D.unusualPickerPadding.PaddingLeft =
    UDim.new(0, 8)
D.unusualPickerPadding.PaddingRight =
    UDim.new(0, 8)
D.unusualPickerPadding.Parent =
    D.unusualPickerScroll
D.unusualPickerGrid =
    Instance.new("UIGridLayout")
D.unusualPickerGrid.CellSize =
    UDim2.new(
        0,
        170,
        0,
        92
    )
D.unusualPickerGrid.CellPadding =
    UDim2.new(
        0,
        6,
        0,
        8
    )
D.unusualPickerGrid.SortOrder =
    Enum.SortOrder.LayoutOrder
D.unusualPickerGrid.Parent =
    D.unusualPickerScroll
--// =========================================================
--// REBUILD UNUSUAL PICKER
--// =========================================================
function DEADEYE_FN_rebuildUnusualPicker()

    pcall(function()
        collectCurrentUnusualIcons(
            LocalPlayer:FindFirstChild(
                "PlayerGui"
            )
        )
    end)

    for _, button in ipairs(
        D.unusualPickerButtons
    ) do
        pcall(function()
            button:Destroy()
        end)
    end
    table.clear(
        D.unusualPickerButtons
    )
    local query =
        string.lower(
            D.unusualPickerSearch.Text
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
        button.Parent = D.unusualPickerScroll

        local corner =
            Instance.new("UICorner")

        corner.CornerRadius =
            UDim.new(0, 5)
        corner.Parent = button

        table.insert(
            D.unusualPickerButtons,
            button
        )

        DEADEYE_FN_addUnusualConnection(
            button.MouseButton1Click:Connect(
                function()
                    if D.unusualPickerSide == "Original" then
                        D.unusualSlot.originalId = nil
                        D.unusualSlot.originalName = nil
                        unusualOriginalButton.Text = "Select"
                    elseif D.unusualPickerSide == "Replace" then
                        D.unusualSlot.replaceId = nil
                        D.unusualSlot.replaceName = nil
                        D.unusualReplaceButton.Text = "Select"
                    else
                        return
                    end

                    D.savedConfig.unusual = {
                        originalId = D.unusualSlot.originalId,
                        replaceId = D.unusualSlot.replaceId
                    }

                    saveSavedConfig()

                    if D.unusualEnabled then
                        D.unusualEnabled = false
                        D.genv.UNUSUAL_SWAPPER_ENABLED = false
                        DEADEYE_FN_restoreUnusual()
                        D.updateUnusualToggle()
                    end

                    D.unusualPicker.Visible = false
                    D.unusualPickerSide = nil
                end
            )
        )

        shown += 1
    end

    for index, data in ipairs(
        D.unusualList
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
                Enum.Font.Gotham
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
                D.unusualPickerScroll

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
                or D.unusualIconIdCache[
                    data.id
                ]
                or D.unusualIconCache[
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
                D.unusualPickerButtons,
                button
            )
            DEADEYE_FN_addUnusualConnection(
                button.MouseButton1Click:Connect(
                    function()
                        if D.unusualPickerSide
                            == "Original"
                        then
                            D.unusualSlot.originalId =
                                data.id
                            D.unusualSlot.originalName =
                                data.name
                            unusualOriginalButton.Text =
                                data.name
                        elseif D.unusualPickerSide
                            == "Replace"
                        then
                            D.unusualSlot.replaceId =
                                data.id
                            D.unusualSlot.replaceName =
                                data.name
                            D.unusualReplaceButton.Text =
                                data.name
                        end
                        D.savedConfig.unusual = {
                            originalId =
                                D.unusualSlot.originalId,
                            replaceId =
                                D.unusualSlot.replaceId
                        }
                        saveSavedConfig()
                        D.unusualPicker.Visible =
                            false
                        D.unusualPickerSide =
                            nil
                        if D.unusualEnabled then
                            task.spawn(
                                DEADEYE_FN_reapplyUnusual
                            )
                        end
                    end
                )
            )
        end
    end
    pcall(function()
        if D.unusualStatus then
            D.unusualStatus.Text =
                "Unusuals: "
                .. tostring(
                    #D.unusualList
                )
                .. " • "
                .. tostring(
                    shown
                )
                .. " found"
        end
    end)
    D.unusualPickerScroll.CanvasPosition =
        Vector2.new(
            0,
            0
        )
end
--// =========================================================
--// OPEN / CLOSE PICKER
-- =========================================================
function DEADEYE_FN_openUnusualPicker(
    side
)
    D.unusualPickerSide =
        side

    if side == "Original" then
        D.unusualPickerTitle.Text =
            "Select Original"
    else
        D.unusualPickerTitle.Text =
            "Select Replacement"
    end

    D.unusualPickerSearch.Text =
        ""
    D.unusualPicker.Visible =
        true

    DEADEYE_FN_rebuildUnusualPicker()
end
function DEADEYE_FN_closeUnusualPicker()
    D.unusualPicker.Visible =
        false
    D.unusualPickerSide =
        nil
end
DEADEYE_FN_addUnusualConnection(    unusualOriginalButton.MouseButton1Click:Connect(
        function()
            DEADEYE_FN_openUnusualPicker(
                "Original"
            )
        end
    )
)
DEADEYE_FN_addUnusualConnection(
    D.unusualReplaceButton.MouseButton1Click:Connect(
        function()
            DEADEYE_FN_openUnusualPicker(
                "Replace"
            )
        end
    )
)
DEADEYE_FN_addUnusualConnection(
    D.unusualPickerClose.MouseButton1Click:Connect(
        function()
            DEADEYE_FN_closeUnusualPicker()
        end
    )
)
DEADEYE_FN_addUnusualConnection(
    D.unusualPickerSearch:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()
            if D.unusualPicker.Visible then
                DEADEYE_FN_rebuildUnusualPicker()
            end
        end
    )
)

DEADEYE_FN_addUnusualConnection(
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

                DEADEYE_FN_addUnusualConnection(
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
D.unusualStatusText =
    Instance.new("TextLabel")
D.unusualStatusText.Name =
    "UnusualStatus"
D.unusualStatusText.Size =
    UDim2.new(
        0,
        260,
        0,
        20
    )
D.unusualStatusText.Position =
    UDim2.new(
        0,
        82,
        0,
        43
    )
D.unusualStatusText.BackgroundTransparency =
    1
D.unusualStatusText.Text =
    ""
D.unusualStatusText.TextSize =
    12
D.unusualStatusText.Font =
    Enum.Font.Gotham
D.unusualStatusText.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
D.unusualStatusText.TextXAlignment =
    Enum.TextXAlignment.Left
D.unusualStatusText.Visible =
    false
D.unusualStatusText.Parent =
    D.Main
D.unusualStatus =
    D.unusualStatusText
D.updateUnusualToggle = function()
    pcall(function()
        if D.unusualEnabled then
            D.Toggle.Text =
                "SWAP: ON"
            D.Toggle.BackgroundColor3 =
                Color3.fromRGB(
                    68,
                    74,
                    84
                )
        else
            D.Toggle.Text =
                "SWAP: OFF"
            D.Toggle.BackgroundColor3 =
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
function D.others.saveConfig()
    D.savedConfig.others =
        D.savedConfig.others
        or {}
    for _, slot in ipairs(
        D.others.ACCESSORY_SLOTS or {}
    ) do
        local box =
            D.others.fieldBoxes[
                slot.property
            ]
        if box then
            D.savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    for _, slot in ipairs(
        D.others.CLOTHING_SLOTS or {}
    ) do
        local box =
            D.others.fieldBoxes[
                slot.property
            ]
        if box then
            D.savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    for _, slot in ipairs(
        D.others.BODY_SLOTS or {}
    ) do
        local box =
            D.others.fieldBoxes[
                slot.property
            ]
        if box then
            D.savedConfig.others[
                slot.property
            ] =
                tostring(
                    box.Text
                    or ""
                )
        end
    end
    D.savedConfig.others._Headless =
        tostring(
            D.savedConfig.others._Headless
            or ""
        )
    D.savedConfig.others._Korblox =
        tostring(
            D.savedConfig.others._Korblox
            or ""
        )
    pcall(function()
        saveSavedConfig()
    end)
end
function D.others.loadConfig()
    local saved =
        D.savedConfig.others
    if type(saved) ~= "table" then
        return
    end
    for _, group in ipairs({
        D.others.ACCESSORY_SLOTS,
        D.others.CLOTHING_SLOTS,
        D.others.BODY_SLOTS
    }) do
        for _, slot in ipairs(
            group
        ) do
            local box =
                D.others.fieldBoxes[
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
D.others.HEADLESS_ID = 134082579
D.others.KORBLOX_ID = 139607718
D.others.ACCESSORY_SLOTS = {
    {label = "Hats", property = "HatAccessory", multi = true},
    {label = "Hair", property = "HairAccessory", multi = true},
    {label = "Face Accessory", property = "FaceAccessory", multi = true},
    {label = "Neck", property = "NeckAccessory", multi = true},
    {label = "Shoulder", property = "ShouldersAccessory", multi = true},
    {label = "Front", property = "FrontAccessory", multi = true},
    {label = "Back", property = "BackAccessory", multi = true},
    {label = "Waist", property = "WaistAccessory", multi = true}
}
D.others.CLOTHING_SLOTS = {
    {label = "Shirt", property = "Shirt"},
    {label = "Pants", property = "Pants"},
    {label = "T-Shirt", property = "GraphicTShirt"}
}
D.others.BODY_SLOTS = {
    {label = "Head", property = "Head"},
    {label = "Torso", property = "Torso"},
    {label = "Left Arm", property = "LeftArm"},
    {label = "Right Arm", property = "RightArm"},
    {label = "Left Leg", property = "LeftLeg"},
    {label = "Right Leg", property = "RightLeg"}
}
D.others.ACCESSORY_PROPERTIES = {
    "HatAccessory",
    "HairAccessory",
    "FaceAccessory",
    "NeckAccessory",
    "ShouldersAccessory",
    "FrontAccessory",
    "BackAccessory",
    "WaistAccessory"
}
D.others.page = nil
D.others.status = nil
D.others.originalDescription = nil
D.others.targetHumanoid = nil
D.others.fieldBoxes = {}
function D.others.getHumanoids()
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
        DEADEYE_FN_getUnusualVisualRig()
    if rig then
        add(
            rig:FindFirstChildOfClass(
                "Humanoid"
            )
        )
    end
    local character =
        DEADEYE_FN_getUnusualPlayerCharacter()
    if character then
        add(
            character:FindFirstChildOfClass(
                "Humanoid"
            )
        )
    end
    return result
end
function D.others.getHumanoid()
    return D.others.getHumanoids()[1]
end
function D.others.ensureSnapshot()
    if D.others.originalDescription then
        return true
    end
    local humanoid =
        D.others.getHumanoid()
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
    D.others.targetHumanoid =
        humanoid
    D.others.originalDescription =
        clone
    return true
end
function D.others.isR6()
    local humanoid =
        D.others.getHumanoid()
    return humanoid
        and humanoid.RigType
            == Enum.HumanoidRigType.R6
end
function D.others.getDescription()
    if not D.others.isR6() then
        if D.others.status then
            D.others.status.Text =
                "R6 only"
        end
        return nil
    end
    if not D.others.ensureSnapshot() then
        return nil
    end
    local humanoid =
        D.others.getHumanoid()
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
function D.others.propertyText(
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
function D.others.refresh()
    local description =
        D.others.getDescription()
    if not description then
        return
    end
    local groups = {
        D.others.ACCESSORY_SLOTS,
        D.others.CLOTHING_SLOTS,
        D.others.BODY_SLOTS
    }
    for _, group in ipairs(groups) do
        for _, slot in ipairs(group) do
            local box =
                D.others.fieldBoxes[
                    slot.property
                ]
            if box then
                box.Text =
                    D.others.propertyText(
                        description,
                        slot
                    )
            end
        end
    end
end
function D.others.applyDescription(
    description
)
    if not D.others.isR6() then
        if D.others.status then
            D.others.status.Text =
                "R6 only"
        end
        return false
    end
    local applied = 0
    local lastError
    for _, humanoid in ipairs(
        D.others.getHumanoids()
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
            D.others.getHumanoids()
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
        if D.others.status then
            D.others.status.Text =
                "Apply Error"
        end
        return false
    end
    if D.others.status then
        D.others.status.Text =
            "Applied"
    end
    return true
end
function D.others.applyField(
    slot,
    textValue
)
    local description =
        D.others.getDescription()
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
    return D.others.applyDescription(
        description
    )
end
function D.others.scan()
    local description =
        D.others.getDescription()
    if not description then
        return false
    end
    D.others.refresh()
    if D.others.status then
        D.others.status.Text =
            "Scanned • R6"
    end
    return true
end
function D.others.clearAccessories()
    local description =
        D.others.getDescription()
    if not description then
        return false
    end
    for _, property in ipairs(
        D.others.ACCESSORY_PROPERTIES
    ) do
        pcall(function()
            description[property] = ""
        end)
    end
    pcall(function()
        description.Face = 0
    end)
    return D.others.applyDescription(
        description
    )
end
function D.others.restore(
    keepSnapshot
)
    if not D.others.originalDescription then
        return false
    end
    local result =
        D.others.applyDescription(
            D.others.originalDescription
        )
    if not keepSnapshot then
        D.others.originalDescription =
            nil
        D.others.targetHumanoid =
            nil
    end
    return result
end
--// =========================================================
--// MAIN / AUTOJUMP
--// =========================================================
local mainJump = {
    D.enabled = false,
    jumpDelay = 0.01,
    hotkeyName = "Z",
    hideUIHotkeyName = "H",
    lastJump = 0,
    capturing = nil,
    character = nil,
    humanoid = nil,
    root = nil,
    sensorPart = nil,
    frontSensorPart = nil,
    sensorTouchConnection = nil,
    frontSensorTouchConnection = nil,
    D.connections = {}
}
mainJump.jumpDelay =
    math.clamp(
        tonumber(
            D.savedConfig.main
            and D.savedConfig.main.jumpDelay
        ) or 0.01,
        0,
        5
    )
mainJump.hotkeyName =
    tostring(
        D.savedConfig.main
        and D.savedConfig.main.hotkey
        or "Z"
    )
mainJump.hideUIHotkeyName =
    tostring(
        D.savedConfig.main
        and D.savedConfig.main.hideUIHotkey
        or "H"
    )
function DEADEYE_FN_mainConnect(connection)
    table.insert(
        mainJump.connections,
        connection
    )
end
function DEADEYE_FN_mainDisconnect()
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
    D.savedConfig.main = {
        jumpDelay = mainJump.jumpDelay,
        hotkey = mainJump.hotkeyName,
        hideUIHotkey =
            mainJump.hideUIHotkeyName
    }
    pcall(function()
        saveSavedConfig()
    end)
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
end
function mainJump.setEnabled(state)
    mainJump.enabled =
        state and true or false

    if mainJump.enabled then
        if mainJump.character
            and mainJump.humanoid
            and mainJump.humanoid.Parent
        then
            pcall(function()
                mainJump.createSensors(
                    mainJump.character
                )
            end)

            task.defer(function()
                if not D.genv.DEADEYE_MAIN_RUNNING
                    or not mainJump.enabled
                    or not mainJump.humanoid
                    or not mainJump.humanoid.Parent
                then
                    return
                end
                if mainJump.canJump() then
                    mainJump.jump()
                end
            end)
        end
    else
        mainJump.destroySensors()

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
function DEADEYE_FN_mainFindKeyCode(value)
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
D.jumpKey =
    DEADEYE_FN_mainFindKeyCode(
        mainJump.hotkeyName
    )
if D.jumpKey then
    mainJump.hotkeyName =
        D.jumpKey.Name
else
    mainJump.hotkeyName = "Z"
end
D.hideKey =
    DEADEYE_FN_mainFindKeyCode(
        mainJump.hideUIHotkeyName
    )
if D.hideKey then
    mainJump.hideUIHotkeyName =
        D.hideKey.Name
else
    mainJump.hideUIHotkeyName = "H"
end
function mainJump.setHotkey(value)
    local key =
        DEADEYE_FN_mainFindKeyCode(
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
        DEADEYE_FN_mainFindKeyCode(
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
    else
        mainJump.hideUIHotkeyBox.Text =
            "PRESS KEY..."
    end
end
function mainJump.destroySensors()
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
    if mainJump.sensorPart then
        pcall(function()
            mainJump.sensorPart:Destroy()
        end)
        mainJump.sensorPart = nil
    end
    if mainJump.frontSensorPart then
        pcall(function()
            mainJump.frontSensorPart:Destroy()
        end)
        mainJump.frontSensorPart = nil
    end
end
function mainJump.canJump()
    if not D.genv.DEADEYE_MAIN_RUNNING
        or not mainJump.enabled
        or not mainJump.humanoid
        or mainJump.humanoid.Health <= 0
    then
        return false
    end
    if mainJump.humanoid.FloorMaterial
        == Enum.Material.Air
    then
        return false
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
function mainJump.jump(hit)
    if not mainJump.canJump() then
        return
    end
    mainJump.lastJump = tick()
    mainJump.humanoid.Jump = true
    pcall(function()
        mainJump.humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end)
end
function mainJump.contact(hit)
    if not D.genv.DEADEYE_MAIN_RUNNING
        or not mainJump.enabled
        or not hit
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
    if not D.genv.DEADEYE_MAIN_RUNNING
        or not mainJump.enabled
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
    mainJump.character = char
    mainJump.humanoid =
        char:WaitForChild(
            "Humanoid"
        )
    mainJump.root =
        char:WaitForChild(
            "HumanoidRootPart"
        )
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
            end        )
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
end
D.genv.DEADEYE_MAIN_RUNNING = true
D.mainPage =
    Instance.new("ScrollingFrame")
D.mainPage.Name =
    "MainPage"
D.mainPage.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
D.mainPage.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
D.mainPage.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
D.mainPage.BorderSizePixel = 0
D.mainPage.ScrollBarThickness = 6
D.mainPage.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
D.mainPage.ScrollingDirection =
    Enum.ScrollingDirection.Y
D.mainPage.Visible = false
D.mainPage.Parent = D.Main
D.__UI.mainCorner =
    Instance.new("UICorner")
D.__UI.mainCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
D.__UI.mainCorner.Parent =
    D.mainPage
D.mainPadding =
    Instance.new("UIPadding")
D.mainPadding.PaddingTop =
    UDim.new(
        0,
        8
    )
D.mainPadding.PaddingBottom =
    UDim.new(
        0,
        8
    )
D.mainPadding.PaddingLeft =
    UDim.new(
        0,
        8
    )
D.mainPadding.PaddingRight =
    UDim.new(
        0,
        8
    )
D.mainPadding.Parent =
    D.mainPage
D.__UI.mainLayout =
    Instance.new("UIListLayout")
D.__UI.mainLayout.Padding =
    UDim.new(
        0,
        6
    )
D.__UI.mainLayout.SortOrder =
    Enum.SortOrder.LayoutOrder
D.__UI.mainLayout.Parent =
    D.mainPage
function DEADEYE_FN_mainRow(labelText, order)
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
    row.Parent = D.mainPage

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
D.__UI.autoRow =
    DEADEYE_FN_mainRow(
        "AUTOJUMP",
        1
    )
D.autoLabel =
    Instance.new("TextLabel")
D.autoLabel.Size =
    UDim2.new(
        0.7,
        0,
        1,
        0
    )
D.autoLabel.Position =
    UDim2.new(
        0,
        10,
        0,
        0
    )
D.autoLabel.BackgroundTransparency = 1
D.autoLabel.Text = "AUTOJUMP"
D.autoLabel.TextSize = 11
D.autoLabel.Font = Enum.Font.GothamBold
D.autoLabel.TextColor3 =
    Color3.fromRGB(
        215,
        215,
        215
    )
D.autoLabel.TextXAlignment =
    Enum.TextXAlignment.Left
D.autoLabel.Parent = D.__UI.autoRow
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
mainJump.toggle.Font =
    Enum.Font.GothamBold
mainJump.toggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.toggle.Parent =
    D.__UI.autoRow
D.__UI.toggleCorner =
    Instance.new("UICorner")
D.__UI.toggleCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
D.__UI.toggleCorner.Parent =
    mainJump.toggle
DEADEYE_FN_mainConnect(
    mainJump.toggle.MouseButton1Click:Connect(
        function()
            mainJump.setEnabled(
                not mainJump.enabled
            )
        end
    )
)
D.__UI.delayRow =
    DEADEYE_FN_mainRow(
        "DELAY",
        2
    )
D.__UI.delayLabel =
    D.autoLabel:Clone()
D.__UI.delayLabel.Text =
    "DELAY"
D.__UI.delayLabel.Parent =
    D.__UI.delayRow
mainJump.delayBox =
    Instance.new("TextBox")
mainJump.delayBox.Size =
    UDim2.new(
        1,
        -190,
        0,
        28
    )
mainJump.delayBox.Position =
    UDim2.new(
        0,
        105,
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
mainJump.delayBox.TextSize = 11
mainJump.delayBox.Font =
    Enum.Font.Gotham
mainJump.delayBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.delayBox.Parent =
    D.__UI.delayRow
D.__UI.delayCorner =
    Instance.new("UICorner")
D.__UI.delayCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
D.__UI.delayCorner.Parent =
    mainJump.delayBox
D.delaySet =
    Instance.new("TextButton")
D.delaySet.Size =
    UDim2.new(
        0,
        65,
        0,
        28
    )
D.delaySet.Position =
    UDim2.new(
        1,
        -75,
        0.5,
        -14
    )
D.delaySet.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
D.delaySet.BorderSizePixel = 0
D.delaySet.Text = "SET"
D.delaySet.TextSize = 9
D.delaySet.Font =
    Enum.Font.GothamBold
D.delaySet.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.delaySet.Parent =
    D.__UI.delayRow
D.__UI.delaySetCorner =
    Instance.new("UICorner")
D.__UI.delaySetCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
D.__UI.delaySetCorner.Parent =
    D.delaySet
DEADEYE_FN_mainConnect(
    D.delaySet.MouseButton1Click:Connect(
        function()
            mainJump.setDelay(
                mainJump.delayBox.Text
            )
        end
    )
)
DEADEYE_FN_mainConnect(
    mainJump.delayBox.FocusLost:Connect(
        function(enterPressed)
            if enterPressed then
                mainJump.setDelay(
                    mainJump.delayBox.Text
                )
            end
        end
    )
)
D.__UI.hotkeyRow =
    DEADEYE_FN_mainRow(
        "HOTKEY",
        3
    )
D.__UI.hotkeyLabel =
    D.autoLabel:Clone()
D.__UI.hotkeyLabel.Text =
    "HOTKEY"
D.__UI.hotkeyLabel.Parent =
    D.__UI.hotkeyRow
mainJump.hotkeyBox =
    Instance.new("TextButton")
mainJump.hotkeyBox.Size =
    UDim2.new(
        1,
        -120,
        0,
        28
    )
mainJump.hotkeyBox.Position =
    UDim2.new(
        0,
        105,
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
mainJump.hotkeyBox.TextSize = 11
mainJump.hotkeyBox.Font =
    Enum.Font.Gotham
mainJump.hotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.hotkeyBox.Parent =
    D.__UI.hotkeyRow
D.__UI.hotkeyCorner =
    Instance.new("UICorner")
D.__UI.hotkeyCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
D.__UI.hotkeyCorner.Parent =
    mainJump.hotkeyBox
DEADEYE_FN_mainConnect(
    mainJump.hotkeyBox.MouseButton1Click:Connect(
        function()
            mainJump.startCapture(
                "jump"
            )
        end
    )
)
D.__UI.hideRow =
    DEADEYE_FN_mainRow(
        "HIDE UI",
        4
    )
D.__UI.hideLabel =
    D.autoLabel:Clone()
D.__UI.hideLabel.Text =
    "HIDE UI"
D.__UI.hideLabel.Parent =
    D.__UI.hideRow
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
    Enum.Font.Gotham
mainJump.hideUIHotkeyBox.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
mainJump.hideUIHotkeyBox.Parent =
    D.__UI.hideRow
D.__UI.hideCorner =
    Instance.new("UICorner")
D.__UI.hideCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
D.__UI.hideCorner.Parent =
    mainJump.hideUIHotkeyBox
DEADEYE_FN_mainConnect(
    mainJump.hideUIHotkeyBox.MouseButton1Click:Connect(
        function()
            mainJump.startCapture(
                "hide"
            )
        end
    )
)
DEADEYE_FN_mainConnect(
    D.UserInputService.InputBegan:Connect(
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
                else
                    mainJump.setHideUIHotkey(
                        keyCode.Name
                    )
                end
                return
            end

            if input.KeyCode
                == DEADEYE_FN_mainFindKeyCode(
                    mainJump.hotkeyName
                )
            then
                mainJump.setEnabled(
                    not mainJump.enabled
                )
            end
            if input.KeyCode
                == DEADEYE_FN_mainFindKeyCode(
                    mainJump.hideUIHotkeyName
                )
            then
                D.ScreenGui.Enabled =
                    not D.ScreenGui.Enabled
            end
        end
    )
)
DEADEYE_FN_mainConnect(
    D.UserInputService.JumpRequest:Connect(
        function()
            if mainJump.enabled
                or not D.genv.DEADEYE_MAIN_RUNNING
                or not mainJump.humanoid
                or not mainJump.humanoid.Parent
            then
                return
            end

            local humanoid = mainJump.humanoid

            if humanoid.Health <= 0
                or humanoid.FloorMaterial
                    == Enum.Material.Air
            then
                return
            end

            local state =
                humanoid:GetState()

            --// Native manual jump is allowed only while the
            --// humanoid is actually grounded. FloorMaterial alone
            --// can become non-Air slightly before physical contact.
            if state
                    ~= Enum.HumanoidStateType.Running
            then
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
        end
    )
)
DEADEYE_FN_mainConnect(
    LocalPlayer.CharacterAdded:Connect(
        function(char)
            task.wait(0.2)
            if D.genv.DEADEYE_MAIN_RUNNING then
                mainJump.createSensors(char)
            end
        end
    )
)
if LocalPlayer.Character
    and D.genv.DEADEYE_MAIN_RUNNING
then
    task.spawn(
        function()
            mainJump.createSensors(
                LocalPlayer.Character
            )
        end
    )
end
mainJump.update()
--// =========================================================
--// OTHERS PAGE
--// =========================================================
D.others.page =
    Instance.new("ScrollingFrame")
D.others.page.Name =
    "OthersPage"
D.others.page.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
D.others.page.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
D.others.page.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
D.others.page.BorderSizePixel =
    0
D.others.page.ScrollBarThickness =
    6
D.others.page.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
D.others.page.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
D.others.page.ScrollingDirection =
    Enum.ScrollingDirection.Y
D.others.page.Visible =
    false
D.others.page.Parent =
    D.Main
D.others.pageCorner =
    Instance.new("UICorner")
D.others.pageCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
D.others.pageCorner.Parent =
    D.others.page
D.others.padding =
    Instance.new("UIPadding")
D.others.padding.PaddingTop =
    UDim.new(
        0,
        8
    )
D.others.padding.PaddingBottom =
    UDim.new(
        0,
        8
    )
D.others.padding.PaddingLeft =
    UDim.new(
        0,
        8
    )
D.others.padding.PaddingRight =
    UDim.new(
        0,
        8
    )
D.others.padding.Parent =
    D.others.page
D.others.layout =
    Instance.new("UIListLayout")
D.others.layout.Padding =
    UDim.new(
        0,
        6
    )
D.others.layout.SortOrder =
    Enum.SortOrder.LayoutOrder
D.others.layout.Parent =
    D.others.page
function D.others.header(
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
        D.others.page
end
function D.others.row(
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
        D.others.page
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
        Enum.Font.Gotham
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
    D.others.fieldBoxes[
        slot.property
    ] =
        box
    DEADEYE_FN_addUnusualConnection(
        apply.MouseButton1Click:Connect(
            function()
                if D.others.applyField(
                    slot,
                    box.Text
                ) then
                    D.others.saveConfig()
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
    DEADEYE_FN_addUnusualConnection(
        box.FocusLost:Connect(
            function(enterPressed)
                if enterPressed then
                    if D.others.applyField(
                        slot,
                        box.Text
                    ) then
                        D.others.saveConfig()
                    end
                end
            end
        )
    )
end
function D.others.quickRow(
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
        D.others.page
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
    DEADEYE_FN_addUnusualConnection(
        apply.MouseButton1Click:Connect(
            function()
                if D.others.applyBodyPart(
                    property,
                    assetId
                ) then
                    if property == "Head" then
                        D.savedConfig.others._Headless =
                            tostring(
                                assetId
                            )
                    elseif property == "RightLeg" then
                        D.savedConfig.others._Korblox =
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
function D.others.applyBodyPart(
    property,
    assetId
)
    local description =
        D.others.getDescription()
    if not description then
        return false
    end
    pcall(function()
        description[property] =
            assetId
    end)
    return D.others.applyDescription(
        description
    )
end
--// =========================================================
--// APPLY ALL OTHERS
--// Applies every current field in one HumanoidDescription call.
--// =========================================================
function D.others.applyAll()
    local description =
        D.others.getDescription()
    if not description then
        return false
    end
    local groups = {
        D.others.ACCESSORY_SLOTS,
        D.others.CLOTHING_SLOTS,
        D.others.BODY_SLOTS
    }
    local changed = 0
    for _, group in ipairs(
        groups
    ) do
        for _, slot in ipairs(
            group
        ) do
            local box =
                D.others.fieldBoxes[
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
    return D.others.applyDescription(
        description
    )
end
D.others.applyAllRow =
    Instance.new("Frame")
D.others.applyAllRow.Size =
    UDim2.new(
        1,
        -4,
        0,
        42
    )
D.others.applyAllRow.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
D.others.applyAllRow.BorderSizePixel =
    0
D.others.applyAllRow.LayoutOrder =
    0
D.others.applyAllRow.Parent =
    D.others.page
D.others.applyAllCorner =
    Instance.new("UICorner")
D.others.applyAllCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
D.others.applyAllCorner.Parent =
    D.others.applyAllRow
D.others.applyAllButton =
    Instance.new("TextButton")
D.others.applyAllButton.Size =
    UDim2.new(
        1,
        -12,
        0,
        30
    )
D.others.applyAllButton.Position =
    UDim2.new(
        0,
        6,
        0.5,
        -15
    )
D.others.applyAllButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
D.others.applyAllButton.BorderSizePixel =
    0
D.others.applyAllButton.Text =
    "APPLY ALL"
D.others.applyAllButton.TextSize =
    10
D.others.applyAllButton.Font =
    Enum.Font.GothamBold
D.others.applyAllButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.others.applyAllButton.Parent =
    D.others.applyAllRow
D.others.applyAllButtonCorner =
    Instance.new("UICorner")
D.others.applyAllButtonCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
D.others.applyAllButtonCorner.Parent =
    D.others.applyAllButton
DEADEYE_FN_addUnusualConnection(
    D.others.applyAllButton.MouseButton1Click:Connect(
        function()
            if D.others.applyAll() then
                D.others.saveConfig()
                D.others.applyAllButton.Text =
                    "APPLIED"
                task.delay(
                    0.8,
                    function()
                        pcall(function()
                            if D.others.applyAllButton.Parent then
                                D.others.applyAllButton.Text =
                                    "APPLY ALL"
                            end
                        end)
                    end
                )
            end
        end
    )
)
D.others.header(
    "QUICK BODY",
    1
)
D.others.quickRow(
    "HEADLESS",
    "Head",
    D.others.HEADLESS_ID,
    2
)
D.others.quickRow(
    "KORBLOX",
    "RightLeg",
    D.others.KORBLOX_ID,
    3
)
D.others.header(
    "ACCESSORIES",
    4
)
D.nextOrder =
    5
for _, slot in ipairs(
    D.others.ACCESSORY_SLOTS
) do
    D.others.row(
        slot,
        D.nextOrder
    )
    D.nextOrder += 1
end
D.others.header(
    "2D CLOTHING",
    D.nextOrder
)
D.nextOrder += 1
for _, slot in ipairs(
    D.others.CLOTHING_SLOTS
) do
    D.others.row(
        slot,
        D.nextOrder
    )
    D.nextOrder += 1
end
D.others.header(
    "BODY BUNDLES",
    D.nextOrder
)
D.nextOrder += 1
for _, slot in ipairs(
    D.others.BODY_SLOTS
) do
    D.others.row(
        slot,
        D.nextOrder
    )
    D.nextOrder += 1
end
--// =========================================================
--// FULL SCAN / CLEAR / RESET
--// =========================================================
D.others.scanRow =
    Instance.new("Frame")
D.others.scanRow.Size =
    UDim2.new(
        1,
        -4,
        0,
        40
    )
D.others.scanRow.BackgroundColor3 =
    Color3.fromRGB(
        40,
        40,
        40
    )
D.others.scanRow.BorderSizePixel =
    0
D.others.scanRow.LayoutOrder =
    D.nextOrder + 1
D.others.scanRow.Parent =
    D.others.page
D.others.scanButton =
    Instance.new("TextButton")
D.others.scanButton.Size =
    UDim2.new(
        0,
        100,
        0,
        28
    )
D.others.scanButton.Position =
    UDim2.new(
        0,
        8,
        0.5,
        -14
    )
D.others.scanButton.BackgroundColor3 =
    Color3.fromRGB(
        52,
        52,
        52
    )
D.others.scanButton.BorderSizePixel =
    0
D.others.scanButton.Text =
    "FULL SCAN"
D.others.scanButton.TextSize =
    9
D.others.scanButton.Font =
    Enum.Font.GothamBold
D.others.scanButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.others.scanButton.Parent =
    D.others.scanRow
D.others.scanButtonCorner =
    Instance.new("UICorner")
D.others.scanButtonCorner.CornerRadius =
    UDim.new(
        0,
        5
    )
D.others.scanButtonCorner.Parent =
    D.others.scanButton
D.others.status =
    Instance.new("TextLabel")
D.others.status.Size =
    UDim2.new(
        1,
        -122,
        1,
        0
    )
D.others.status.Position =
    UDim2.new(
        0,
        118,
        0,
        0
    )
D.others.status.BackgroundTransparency =
    1
D.others.status.Text =
    "Click FULL SCAN"
D.others.status.TextSize =
    10
D.others.status.Font =
    Enum.Font.Gotham
D.others.status.TextColor3 =
    Color3.fromRGB(
        150,
        150,
        150
    )
D.others.status.TextXAlignment =
    Enum.TextXAlignment.Left
D.others.status.Parent =
    D.others.scanRow
D.others.header(
    "TOOLS",
    D.nextOrder + 2
)
D.others.toolsFrame =
    Instance.new("Frame")
D.others.toolsFrame.Size =
    UDim2.new(
        1,
        -4,
        0,
        80
    )
D.others.toolsFrame.BackgroundTransparency =
    1
D.others.toolsFrame.LayoutOrder =
    D.nextOrder + 3
D.others.toolsFrame.Parent =
    D.others.page
D.others.clearButton =
    Instance.new("TextButton")
D.others.clearButton.Size =
    UDim2.new(
        1,
        0,
        0,
        34
    )
D.others.clearButton.Position =
    UDim2.new(
        0,
        0,
        0,
        0
    )
D.others.clearButton.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
D.others.clearButton.BorderSizePixel =
    0
D.others.clearButton.Text =
    "REMOVE EVERYTHING EXCEPT 2D CLOTHES + BODY"
D.others.clearButton.TextSize =
    9
D.others.clearButton.Font =
    Enum.Font.GothamBold
D.others.clearButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.others.clearButton.Parent =
    D.others.toolsFrame
D.others.clearCorner =
    Instance.new("UICorner")
D.others.clearCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
D.others.clearCorner.Parent =
    D.others.clearButton
D.others.resetButton =
    Instance.new("TextButton")
D.others.resetButton.Size =
    UDim2.new(
        1,
        0,
        0,
        34
    )
D.others.resetButton.Position =
    UDim2.new(
        0,
        0,
        0,
        40
    )
D.others.resetButton.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
D.others.resetButton.BorderSizePixel =
    0
D.others.resetButton.Text =
    "RESET TO INITIAL AVATAR"
D.others.resetButton.TextSize =
    9
D.others.resetButton.Font =
    Enum.Font.GothamBold
D.others.resetButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.others.resetButton.Parent =
    D.others.toolsFrame
D.others.resetCorner =
    Instance.new("UICorner")
D.others.resetCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
D.others.resetCorner.Parent =
    D.others.resetButton
DEADEYE_FN_addUnusualConnection(
    D.others.scanButton.MouseButton1Click:Connect(
        function()
            D.others.scan()
        end
    )
)
DEADEYE_FN_addUnusualConnection(
    D.others.clearButton.MouseButton1Click:Connect(
        function()
            if D.others.clearAccessories() then
                task.delay(
                    0.3,
                    function()
                        D.others.saveConfig()
                    end
                )
            end
        end
    )
)
DEADEYE_FN_addUnusualConnection(
    D.others.resetButton.MouseButton1Click:Connect(
        function()
            D.others.ensureSnapshot()
            if D.others.restore(true) then
                D.others.scan()
            end
        end
    )
)
task.defer(
    function()
        pcall(function()
            D.others.loadConfig()
        end)
    end
)
--// CATEGORY BAR
-- =========================================================
D.categoryBar =
    Instance.new("Frame")
D.categoryBar.Name =
    "CategoryBar"
D.categoryBar.Size =
    UDim2.new(
        0,
        66,
        1,
        -56
    )
D.categoryBar.Position =
    UDim2.new(
        0,
        8,
        0,
        48
    )
D.categoryBar.BackgroundColor3 =
    Color3.fromRGB(
        26,
        30,
        36
    )
D.categoryBar.BorderSizePixel =
    0
D.categoryBar.Parent =
    D.Main

D.__UI.categoryGradient =
    Instance.new("UIGradient")
D.__UI.categoryGradient.Rotation =
    90
D.__UI.categoryGradient.Transparency =
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
D.__UI.categoryGradient.Parent =
    D.categoryBar

D.__UI.categoryStroke =
    Instance.new("UIStroke")
D.__UI.categoryStroke.Thickness =
    1
D.__UI.categoryStroke.Transparency =
    0.55
D.__UI.categoryStroke.Parent =
    D.categoryBar

D.__UI.categoryCorner =
    Instance.new("UICorner")
D.__UI.categoryCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
D.__UI.categoryCorner.Parent =
    D.categoryBar
function DEADEYE_FN_makeCategoryButton(
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
        D.categoryBar
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
D.mainCategoryButton =
    DEADEYE_FN_makeCategoryButton(
        "MAIN",
        6
    )
D.emoteCategoryButton =
    DEADEYE_FN_makeCategoryButton(
        "EMOTES",
        41
    )
D.unusualCategoryButton =
    DEADEYE_FN_makeCategoryButton(
        "UNUSUAL",
        76
    )
D.othersCategoryButton =
    DEADEYE_FN_makeCategoryButton(
        "OTHERS",
        111
    )
--// =========================================================
--// CATEGORY SWITCH
--// =========================================================
function DEADEYE_FN_setCategory(
    category
)
    D.currentCategory =
        category
    pcall(function()
        if category == "Main" then
            D.MainTitle.Text =
                "DeadEyes v1"
            D.Status.Visible = false
            D.Toggle.Visible = false
            D.SlotsScroll.Visible = false
            D.mainPage.Visible = true
            D.unusualPage.Visible = false
            D.unusualStatus.Visible = false
            D.unusualPicker.Visible = false
            D.others.page.Visible = false
            D.mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    65,
                    65,
                    65
                )
            D.emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
        elseif category == "Unusual" then
            D.MainTitle.Text =
                "DeadEyes v1"
            D.Status.Visible =
                false
            D.Toggle.Visible =
                true
            D.Toggle.Parent =
                D.unusualPage
            D.Toggle.LayoutOrder =
                0
            D.SlotsScroll.Visible =
                false
            D.mainPage.Visible =
                false
            D.unusualPage.Visible =
                true
            D.unusualStatus.Visible =
                false
            D.unusualPicker.Visible =
                false
            D.others.page.Visible =
                false
            D.mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    65,
                    65,
                    65
                )
            D.othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.updateUnusualToggle()
        elseif category == "Others" then
            D.MainTitle.Text =
                "DeadEyes v1"
            D.Status.Visible =
                false
            D.Toggle.Visible =
                false
            D.SlotsScroll.Visible =
                false
            D.unusualPage.Visible =
                false
            D.unusualStatus.Visible =
                false
            D.mainPage.Visible =
                false
            D.unusualPicker.Visible =
                false
            D.others.page.Visible =
                true
            D.mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    65,
                    65,
                    65
                )
        else
            D.MainTitle.Text =
                "DeadEyes v1"
            D.Status.Visible =
                false
            D.Toggle.Visible =
                true
            D.Toggle.Parent =
                D.SlotsScroll
            D.Toggle.LayoutOrder =
                0
            D.SlotsScroll.Visible =
                true
            D.mainPage.Visible =
                false
            D.unusualPage.Visible =
                false
            D.unusualStatus.Visible =
                false
            D.unusualPicker.Visible =
                false
            D.others.page.Visible =
                false
            D.mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            D.emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    65,
                    65,
                    65
                )
            updateGUI()
        end
    end)
end
DEADEYE_FN_addUnusualConnection(
    D.mainCategoryButton.MouseButton1Click:Connect(
        function()
            if D.mainMinimized then
                D.setMainMinimized(false)
            end
            DEADEYE_FN_setCategory(
                "Main"
            )
        end
    )
)
DEADEYE_FN_addUnusualConnection(
    D.emoteCategoryButton.MouseButton1Click:Connect(
        function()
            if D.mainMinimized then
                D.setMainMinimized(false)
            end
            DEADEYE_FN_setCategory(
                "Emotes"
            )
        end
    )
)
DEADEYE_FN_addUnusualConnection(    D.unusualCategoryButton.MouseButton1Click:Connect(
        function()
            if D.mainMinimized then
                D.setMainMinimized(false)
            end
            DEADEYE_FN_setCategory(
                "Unusual"
            )
        end
    )
)
DEADEYE_FN_addUnusualConnection(
    D.othersCategoryButton.MouseButton1Click:Connect(
        function()
            if D.mainMinimized then
                D.setMainMinimized(false)
            end
            DEADEYE_FN_setCategory(
                "Others"
            )
        end
    )
)
--// =========================================================
--// EXTERNAL CLEANUP
--// =========================================================
function DEADEYE_FN_cleanupUnusual()
    if D.unusualDestroyed then
        return
    end
    D.unusualDestroyed =
        true
    if D.unusualActive then
        pcall(function()
            DEADEYE_FN_restoreUnusual()
        end)
    end
    pcall(function()
        D.others.restore(false)
    end)
    D.unusualEnabled =
        false
    D.unusualRuntime.reapplyGeneration += 1
    D.unusualRuntime.appliedRig = nil
    D.genv.UNUSUAL_SWAPPER_ENABLED =
        false
    DEADEYE_FN_disconnectUnusualConnections()
    pcall(function()
        DEADEYE_FN_removeOurUnusualFX()
    end)
    D.genv.DEADEYE_MAIN_RUNNING = false
    pcall(function()
        if D.mainPage then
            D.mainPage.Visible = false
        end
        DEADEYE_FN_mainDisconnect()
        if D.unusualPicker then
            D.unusualPicker:Destroy()
        end
        if D.unusualPage then
            D.unusualPage:Destroy()
        end
        if D.others.page then
            D.others.page:Destroy()
        end
        if D.unusualStatus then
            D.unusualStatus:Destroy()
        end
        if D.categoryBar then
            D.categoryBar:Destroy()
        end
    end)
    D.genv.UNUSUAL_SWAPPER_CLEANUP =
        nil
    end
D.genv.UNUSUAL_SWAPPER_CLEANUP =
    DEADEYE_FN_cleanupUnusual
--// =========================================================
--// REPLACE EXISTING TOGGLE BEHAVIOUR
--// =========================================================
--// =========================================================
--// TOGGLE
--// =========================================================
D.Toggle =
    Instance.new("TextButton")
D.Toggle.Size =
    UDim2.new(
        1,
        -12,
        0,
        36
    )
D.Toggle.Position =
    UDim2.new(
        0,
        0,
        0,
        0
    )
D.Toggle.LayoutOrder =
    0
D.Toggle.BackgroundColor3 =
    Color3.fromRGB(
        45,
        45,
        45
    )
D.Toggle.BorderSizePixel =
    0
D.Toggle.Text =
    "SWAP: OFF"
D.Toggle.TextSize =
    11
D.Toggle.Font =
    Enum.Font.GothamBold
D.Toggle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.Toggle.Parent =
    D.SlotsScroll
D.__UI.ToggleCorner =
    Instance.new("UICorner")
D.__UI.ToggleCorner.CornerRadius =
    UDim.new(
        0,
        8
    )
D.__UI.ToggleCorner.Parent =
    D.Toggle
--// =========================================================
--// SLOTS SCROLL
--// =========================================================
D.SlotsScroll =
    Instance.new("ScrollingFrame")
D.SlotsScroll.Name =
    "Slots"
D.SlotsScroll.Size =
    UDim2.new(
        1,
        -16,
        1,
        -76
    )
D.SlotsScroll.Position =
    UDim2.new(
        0,
        8,
        0,
        68
    )
D.SlotsScroll.BackgroundColor3 =
    Color3.fromRGB(
        32,
        32,
        32
    )
D.SlotsScroll.BorderSizePixel =
    0
D.SlotsScroll.ScrollBarThickness =
    6
D.SlotsScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
D.SlotsScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
D.SlotsScroll.Parent =
    D.Main
--// Existing Emote content moves right of the category rail.
D.SlotsScroll.Size =
    UDim2.new(
        1,
        -92,
        1,
        -56
    )
D.SlotsScroll.Position =
    UDim2.new(
        0,
        82,
        0,
        48
    )
D.__UI.SlotsCorner =
    Instance.new("UICorner")
D.__UI.SlotsCorner.CornerRadius =
    UDim.new(
        0,
        9
    )
D.__UI.SlotsCorner.Parent =
    D.SlotsScroll
D.__UI.SlotsPadding =
    Instance.new("UIPadding")
D.__UI.SlotsPadding.PaddingTop =
    UDim.new(
        0,
        8
    )
D.__UI.SlotsPadding.PaddingBottom =
    UDim.new(
        0,
        8
    )
D.__UI.SlotsPadding.PaddingLeft =
    UDim.new(
        0,
        8
    )
D.__UI.SlotsPadding.PaddingRight =
    UDim.new(
        0,
        8
    )
D.__UI.SlotsPadding.Parent =
    D.SlotsScroll
D.__UI.SlotsLayout =
    Instance.new("UIListLayout")
D.__UI.SlotsLayout.Padding =
    UDim.new(
        0,
        7
    )
D.__UI.SlotsLayout.SortOrder =
    Enum.SortOrder.LayoutOrder
D.__UI.SlotsLayout.Parent =
    D.SlotsScroll
--// =========================================================
--// CREATE SLOT ROWS
--// =========================================================
for slotIndex = 1, D.SLOT_COUNT do
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
        D.SlotsScroll
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
        D.slots[slotIndex].originalName
        or "Select"
    originalButton.TextSize =
        11
    originalButton.Font =
        Enum.Font.Gotham
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
    D.slotOriginalButtons[
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
        D.slots[slotIndex].replaceName
        or "Select"
    replaceButton.TextSize =
        11
    replaceButton.Font =
        Enum.Font.Gotham
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
    D.slotReplaceButtons[
        slotIndex
    ] =
        replaceButton
end
--// =========================================================
--// PICKER
--// =========================================================
D.Picker =
    Instance.new("Frame")
D.Picker.Size =
    UDim2.new(
        0,
        560,
        0,
        450
    )
D.Picker.Position =
    UDim2.new(
        0.5,
        -280,
        0.5,
        -225
    )
D.Picker.BackgroundColor3 =
    Color3.fromRGB(
        31,
        35,
        42
    )
D.Picker.BackgroundTransparency =
    0.10
D.Picker.BorderSizePixel =
    0
D.Picker.ClipsDescendants =
    true
D.Picker.Visible =
    false
D.Picker.ZIndex =
    30
D.Picker.Parent =
    D.ScreenGui
D.__UI.PickerCorner =
    Instance.new("UICorner")
D.__UI.PickerCorner.CornerRadius =
    UDim.new(
        0,
        8
    )
D.__UI.PickerCorner.Parent =
    D.Picker
D.__UI.PickerStroke =
    Instance.new("UIStroke")
D.__UI.PickerStroke.Thickness =
    1
D.__UI.PickerStroke.Transparency =
    0.66
D.__UI.PickerStroke.Parent =
    D.Picker
D.__UI.PickerGlass =
    Instance.new("UIGradient")
D.__UI.PickerGlass.Rotation =
    115
D.__UI.PickerGlass.Color =
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
D.__UI.PickerGlass.Transparency =
    NumberSequence.new(0.20)
D.__UI.PickerGlass.Parent =
    D.Picker
--// PICKER TITLE
D.PickerTitle =
    Instance.new("TextLabel")
D.PickerTitle.Size =
    UDim2.new(
        1,
        -45,
        0,
        32
    )
D.PickerTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        2
    )
D.PickerTitle.BackgroundTransparency =
    1
D.PickerTitle.Text =
    "Select Emote"
D.PickerTitle.TextSize =
    16
D.PickerTitle.Font =
    Enum.Font.GothamBold
D.PickerTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.PickerTitle.TextXAlignment =
    Enum.TextXAlignment.Left
D.PickerTitle.ZIndex =
    31
D.PickerTitle.Parent =
    D.Picker
--// =========================================================
--// PICKER CLOSE
--// =========================================================
D.PickerClose =
    Instance.new("TextButton")
D.PickerClose.Size =
    UDim2.new(
        0,
        30,
        0,
        30
    )
D.PickerClose.Position =
    UDim2.new(
        1,
        -35,
        0,
        4
    )
D.PickerClose.BackgroundTransparency =
    1
D.PickerClose.Text =
    "×"
D.PickerClose.TextSize =
    25
D.PickerClose.Font =
    Enum.Font.GothamBold
D.PickerClose.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.PickerClose.ZIndex =
    31
D.PickerClose.Parent =
    D.Picker
--// =========================================================
--// PICKER SEARCH
--// =========================================================
D.PickerSearch =
    Instance.new("TextBox")
D.PickerSearch.Size =
    UDim2.new(
        1,
        -20,
        0,
        30
    )
D.PickerSearch.Position =
    UDim2.new(
        0,
        10,
        0,
        36
    )
D.PickerSearch.BackgroundColor3 =
    Color3.fromRGB(
        40,
        45,
        53
    )
D.PickerSearch.BackgroundTransparency =
    0.20
D.PickerSearch.BorderSizePixel =
    0
D.PickerSearch.ClearTextOnFocus =
    false
D.PickerSearch.PlaceholderText =
    "Search by name..."
D.PickerSearch.PlaceholderColor3 =
    Color3.fromRGB(
        120,
        120,
        120
    )
D.PickerSearch.Text =
    ""
D.PickerSearch.TextSize =
    12
D.PickerSearch.Font =
    Enum.Font.Gotham
D.PickerSearch.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
D.PickerSearch.ZIndex =
    32
D.PickerSearch.Parent =
    D.Picker
D.__UI.SearchCorner =
    Instance.new("UICorner")
D.__UI.SearchCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
D.__UI.SearchCorner.Parent =
    D.PickerSearch
--// =========================================================
--// PICKER SCROLL
--// =========================================================
D.PickerScroll =
    Instance.new("ScrollingFrame")
D.PickerScroll.Size =
    UDim2.new(
        1,
        -16,
        1,
        -74
    )
D.PickerScroll.Position =
    UDim2.new(
        0,
        8,
        0,
        70
    )
D.PickerScroll.BackgroundColor3 =
    Color3.fromRGB(
        32,
        35,
        42
    )
D.PickerScroll.BackgroundTransparency =
    0.20
D.PickerScroll.BorderSizePixel =
    0
D.PickerScroll.ScrollBarThickness =
    6
D.PickerScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )
D.PickerScroll.AutomaticCanvasSize =
    Enum.AutomaticSize.Y
D.PickerScroll.ZIndex =
    31
D.PickerScroll.Parent =
    D.Picker
D.__UI.PickerScrollCorner =
    Instance.new("UICorner")
D.__UI.PickerScrollCorner.CornerRadius =
    UDim.new(
        0,
        7
    )
D.__UI.PickerScrollCorner.Parent =
    D.PickerScroll
D.__UI.PickerPadding =
    Instance.new("UIPadding")
D.__UI.PickerPadding.PaddingTop =
    UDim.new(
        0,
        8
    )
D.__UI.PickerPadding.PaddingBottom =
    UDim.new(
        0,
        8
    )
D.__UI.PickerPadding.PaddingLeft =
    UDim.new(
        0,
        8
    )
D.__UI.PickerPadding.PaddingRight =
    UDim.new(
        0,
        8
    )
D.__UI.PickerPadding.Parent =
    D.PickerScroll
D.__UI.PickerGrid =
    Instance.new("UIGridLayout")
D.__UI.PickerGrid.CellSize =
    UDim2.new(
        0,
        170,
        0,
        92
    )
D.__UI.PickerGrid.CellPadding =
    UDim2.new(
        0,
        6,
        0,
        8
    )
D.__UI.PickerGrid.SortOrder =
    Enum.SortOrder.LayoutOrder
D.__UI.PickerGrid.Parent =
    D.PickerScroll
--// =========================================================
--// EMOTE VIEWPORT PREVIEW
--// Локальная копия native preview без CreateViewport()
--// =========================================================
function DEADEYE_FN_createEmotePreview(
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
                D.ReplicatedStorage:FindFirstChild(
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
function DEADEYE_FN_getNativeEmoteWheels()
    local playerGui =
        LocalPlayer:FindFirstChild(
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

    for i = 1, D.SLOT_COUNT do
        local slot =
            D.slots[i]

        if slot
            and slot.originalId
            and slot.replaceId
            and normalizeEmoteName(
                slot.originalName
                    or getEmoteName(
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
        prepareOriginalModule(
            state.originalId
        )

    if viewport
        and originalModule
    then
        pcall(function()
            DEADEYE_FN_createEmotePreview(
                originalModule,
                viewport
            )
        end)
    end

    if textLabel then
        pcall(function()
            textLabel.Text =
                state.originalName
                or getEmoteName(
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
    if D.nativeWheelRestoreDone
        and not force
    then
        return
    end

    local wheels =
        DEADEYE_FN_getNativeEmoteWheels()

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
                D.nativeWheelStates[
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

    D.nativeWheelRestoreDone = true
end


local function applyNativeEmoteSlot(
    nativeSlot,
    slot
)
    D.nativeWheelRestoreDone = false

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
        prepareReplaceModule(
            slot.replaceId
        )

    if not replaceModule then
        return false
    end

    local replacementName =
        slot.replaceName
        or replaceModule.Name
        or getEmoteName(
            slot.replaceId
        )

    if not replacementName then
        return false
    end

    local previewOk = false

    local success =
        pcall(function()
            previewOk =
                DEADEYE_FN_createEmotePreview(
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
        DEADEYE_FN_getNativeEmoteWheels()

    if #wheels == 0 then
        return
    end

    -- OFF = restore from the persistent logical snapshots.
    if not D.genv.EMOTE_SWAPPER_RUNNING
        or not D.enabled
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
                D.nativeWheelStates[
                    key
                ]

            local configuredSlot =
                nil

            -- Existing logical snapshot tells us exactly which
            -- original belongs to this position.
            if state then
                for slotIndex = 1, D.SLOT_COUNT do
                    local configured =
                        D.slots[slotIndex]

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

                    D.nativeWheelStates[
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
                for slotIndex = 1, D.SLOT_COUNT do
                    local configured =
                        D.slots[slotIndex]

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
                    or getEmoteName(
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
--// REBUILD PICKER
--// =========================================================
function DEADEYE_FN_rebuildPicker()
    for _, button in ipairs(
        D.pickerButtons
    ) do
        pcall(function()
            button:Destroy()
        end)
    end
    table.clear(
        D.pickerButtons
    )
    local query =
        string.lower(
            D.PickerSearch.Text
                or ""
        )
    local shown = 0

    do
        local button =
            Instance.new("TextButton")

        button.Name = "Emote_None"
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
        button.Parent = D.PickerScroll

        local corner =
            Instance.new("UICorner")

        corner.CornerRadius =
            UDim.new(0, 5)
        corner.Parent = button

        table.insert(
            D.pickerButtons,
            button
        )

        button.MouseButton1Click:Connect(
            function()
                if not D.activePickerSlot
                    or not D.activePickerSide then
                    return
                end

                local slot =
                    D.slots[D.activePickerSlot]

                if D.activePickerSide == "Original" then
                    slot.originalId = nil
                    slot.originalName = nil
                    D.slotOriginalButtons[
                        D.activePickerSlot
                    ].Text = "Select"
                else
                    slot.replaceId = nil
                    slot.replaceName = nil
                    D.slotReplaceButtons[
                        D.activePickerSlot
                    ].Text = "Select"
                end

                D.savedConfig.emotes[
                    D.activePickerSlot
                ] = {
                    originalId = slot.originalId,
                    replaceId = slot.replaceId
                }

                saveSavedConfig()

                if D.currentOriginalId == slot.originalId
                    or (
                        D.currentOriginalId
                        and not slot.originalId
                    )
                then
                    DEADEYE_FN_stopCustomEmote()
                end

                D.Status.Text =
                    "Slot "
                    .. tostring(D.activePickerSlot)
                    .. " cleared"

                D.Picker.Visible = false
                D.activePickerSlot = nil
                D.activePickerSide = nil
            end
        )

        shown = shown + 1
    end

    for index, data in ipairs(
        D.emoteList
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
                Enum.Font.Gotham
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
                D.PickerScroll


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

            DEADEYE_FN_createEmotePreview(
                data.module,
                viewport
            )

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
                D.pickerButtons,
                button
            )
            button.MouseButton1Click:Connect(
                function()
                    if not D.activePickerSlot
                        or not D.activePickerSide then
                        return
                    end
                    local slot =
                        D.slots[
                            D.activePickerSlot
                        ]
                    if D.activePickerSide ==
                        "Original" then
                        slot.originalId =
                            data.id
                        slot.originalName =
                            data.name
                        prepareOriginalModule(
                            data.id
                        )
                        D.slotOriginalButtons[
                            D.activePickerSlot
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
                        D.slotReplaceButtons[
                            D.activePickerSlot
                        ].Text =
                            data.name
                    end
                    D.savedConfig.emotes[
                        D.activePickerSlot
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
                    if D.currentOriginalId
                        == slot.originalId then
                        DEADEYE_FN_stopCustomEmote()
                    end
                    D.Status.Text =
                        "Slot "
                        .. tostring(
                            D.activePickerSlot
                        )
                        .. " configured"
                    D.Picker.Visible =
                        false
                    D.activePickerSlot =
                        nil
                    D.activePickerSide =
                        nil
                end
            )
        end
    end
    D.Status.Text =
        "Found: "
        .. tostring(shown)
    D.PickerScroll.CanvasPosition =
        Vector2.new(
            0,
            0
        )
end
--// =========================================================
--// OPEN PICKER
--// =========================================================
function DEADEYE_FN_openPicker(
    slotIndex,
    side
)
    D.activePickerSlot =
        slotIndex
    D.activePickerSide =
        side
    if side == "Original" then
        D.PickerTitle.Text =
            "Slot "
            .. tostring(
                slotIndex
            )
            .. " • Original"
    else
        D.PickerTitle.Text =
            "Slot "
            .. tostring(
                slotIndex
            )
            .. " • Replace"
    end
    D.PickerSearch.Text =
        ""
    DEADEYE_FN_rebuildPicker()
    D.Picker.Visible =
        true
end
--// =========================================================
--// CLOSE PICKER
--// =========================================================
function DEADEYE_FN_closePicker()
    D.Picker.Visible =
        false
    D.activePickerSlot =
        nil
    D.activePickerSide =
        nil
end
--// =========================================================
--// CONNECT SLOT BUTTONS
--// =========================================================
for slotIndex = 1, D.SLOT_COUNT do
    D.slotOriginalButtons[
        slotIndex
    ].MouseButton1Click:Connect(
        function()
            DEADEYE_FN_openPicker(
                slotIndex,
                "Original"
            )
        end
    )
    D.slotReplaceButtons[
        slotIndex
    ].MouseButton1Click:Connect(
        function()
            DEADEYE_FN_openPicker(
                slotIndex,
                "Replace"
            )
        end
    )
end
--// =========================================================
--// SEARCH
--// =========================================================
DEADEYE_FN_addConnection(
    D.PickerSearch:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()
            if D.Picker.Visible then
                DEADEYE_FN_rebuildPicker()
            end
        end
    )
)
D.PickerClose.MouseButton1Click:Connect(
    function()
        DEADEYE_FN_closePicker()
    end
)
--// =========================================================
--// TOGGLE
--// =========================================================
DEADEYE_FN_addConnection(
    D.Toggle.MouseButton1Click:Connect(
        function()
            if D.currentCategory == "Unusual" then
                if D.unusualEnabled then
                    D.unusualEnabled =
                        false
                    D.genv.UNUSUAL_SWAPPER_ENABLED =
                        false
                    DEADEYE_FN_restoreUnusual()
                else
                    if not D.unusualSlot.originalId
                        or not D.unusualSlot.replaceId
                    then
                        D.unusualStatus.Text =
                            "Select both Unusuals first"
                        return
                    end
                    if DEADEYE_FN_activateUnusual() then
                        D.unusualEnabled =
                            true
                        D.unusualRuntime.appliedRig =
                            DEADEYE_FN_getUnusualVisualRig()
                        D.genv.UNUSUAL_SWAPPER_ENABLED =
                            true
                    end
                end
                D.updateUnusualToggle()
                return
            end
            --// EXISTING EMOTE TOGGLE
            if D.enabled then
                D.enabled = false
                DEADEYE_FN_stopCustomEmote()
                restoreNativeEmoteWheel()
                updateGUI()
                D.Status.Text =
                    "Swap disabled"
                                return
            end
            local validSlots = 0
            for i = 1, D.SLOT_COUNT do
                local slot =
                    D.slots[i]
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
                D.Status.Text =
                    "No configured slots"
                return
            end
            D.enabled =
                true
            D.nativeWheelRestoreDone =
                false
            D.lastRegistryEmote =
                0
            syncNativeEmoteWheel()
            updateGUI()
            D.Status.Text =
                "Active • "
                .. tostring(
                    validSlots
                )
                .. " slots"
                    end
    )
)
--// =========================================================
--// WINDOW SIZE LIMITS
--// =========================================================
D.MIN_WINDOW_WIDTH = 455
D.MIN_WINDOW_HEIGHT = 285
D.RESIZE_EDGE = 8

--// =========================================================
--// MINIMIZE STATE
--// =========================================================
D.setMainMinimized = function(state)
    D.mainMinimized = state
    if D.mainMinimized then
        D.Main.Size =
            UDim2.new(
                0,                245,
                0,
                40
            )
        D.MainTitle.Size =
            UDim2.new(
                0,
                155,
                0,
                36
            )
        D.Status.Visible = false
        D.Toggle.Visible = false
        D.SlotsScroll.Visible = false
        if D.Picker then
            D.Picker.Visible = false
        end
        pcall(function()
            D.categoryBar.Visible = false
            D.mainPage.Visible = false
            D.unusualPage.Visible = false
            D.unusualStatus.Visible = false
            D.others.page.Visible = false
        end)
        D.Minimize.Text = "+"

        for _, name in ipairs({
            "ResizeRight",
            "ResizeBottom",
            "ResizeCorner"
        }) do
            local handle =
                D.Main:FindFirstChild(name)
            if handle then
                handle.Visible = false
            end
        end
    else
        D.Main.Size =
            UDim2.new(
                0,
                math.max(
                    D.MIN_WINDOW_WIDTH,
                    D.savedConfig.gui.width
                ),
                0,
                math.max(
                    D.MIN_WINDOW_HEIGHT,
                    D.savedConfig.gui.height
                )
            )
        D.MainTitle.Size =
            UDim2.new(
                1,
                -105,
                0,
                36
            )
        D.Status.Visible = true
        D.Toggle.Visible = true
        D.SlotsScroll.Visible = true
        pcall(function()
            D.categoryBar.Visible = true
            if D.currentCategory == "Main" then
                D.Status.Visible = false
                D.Toggle.Visible = false
                D.SlotsScroll.Visible = false
                D.mainPage.Visible = true
                D.unusualPage.Visible = false
                D.unusualStatus.Visible = false
                D.others.page.Visible = false
            elseif D.currentCategory == "Unusual" then
                D.Status.Visible = false
                D.Toggle.Visible = true
                D.Toggle.Parent =
                    D.unusualPage
                D.Toggle.LayoutOrder =
                    0
                D.SlotsScroll.Visible = false
                D.mainPage.Visible = false
                D.unusualPage.Visible = true
                D.unusualStatus.Visible = false
                D.others.page.Visible = false
            elseif D.currentCategory == "Others" then
                D.Status.Visible = false
                D.Toggle.Visible = false
                D.SlotsScroll.Visible = false
                D.mainPage.Visible = false
                D.unusualPage.Visible = false
                D.unusualStatus.Visible = false
                D.others.page.Visible = true
            else
                D.mainPage.Visible = false
                D.unusualPage.Visible = false
                D.unusualStatus.Visible = false
                D.others.page.Visible = false
            end
        end)
        D.Minimize.Text = "−"

        for _, name in ipairs({
            "ResizeRight",
            "ResizeBottom",
            "ResizeCorner"
        }) do
            local handle =
                D.Main:FindFirstChild(name)
            if handle then
                handle.Visible = true
            end
        end
    end
end
--// =========================================================
--// MINIMIZE BUTTON CONNECTION
--// =========================================================
DEADEYE_FN_addConnection(
    D.Minimize.MouseButton1Click:Connect(
        function()
            D.setMainMinimized(
                not D.mainMinimized
            )
        end
    )
)
--// =========================================================
--// GUI UPDATE
--// =========================================================
function updateGUI()
    if D.enabled then
        D.Toggle.Text =
            "SWAP: ON"
        D.Toggle.BackgroundColor3 =
            Color3.fromRGB(
                68,
                74,
                84
            )
    else
        D.Toggle.Text =
            "SWAP: OFF"
        D.Toggle.BackgroundColor3 =
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
DEADEYE_FN_addConnection(
    D.RunService.Heartbeat:Connect(
        function()
            if not D.genv.EMOTE_SWAPPER_RUNNING then
                return
            end
            syncNativeEmoteWheel()
            DEADEYE_FN_checkState()
        end
    )
)
D.DragHandle =
    Instance.new("Frame")
D.DragHandle.Name =
    "DragHandle"
D.DragHandle.Size =
    UDim2.new(
        1,
        -105,
        0,
        39
    )
D.DragHandle.Position =
    UDim2.new(
        0,
        1,
        0,
        1
    )
D.DragHandle.BackgroundTransparency =
    1
D.DragHandle.BorderSizePixel =
    0
D.DragHandle.Active =
    true
D.DragHandle.ZIndex =
    4
D.DragHandle.Parent =
    D.Main

--// =========================================================
--// WINDOW GEOMETRY / DRAG / RESIZE
-- =========================================================
D.dragging = false
D.dragStart
D.startPosition

local resizing = false
D.resizeMode = nil
D.resizeStart
D.resizeStartSize

local function saveWindowState()
    D.savedConfig.gui =
        D.savedConfig.gui
        or {}

    D.savedConfig.gui.x =
        math.floor(
            D.Main.Position.X.Offset
            + 0.5
        )

    D.savedConfig.gui.y =
        math.floor(
            D.Main.Position.Y.Offset
            + 0.5
        )

    if not D.mainMinimized then
        D.savedConfig.gui.width =
            math.floor(
                D.Main.AbsoluteSize.X
                + 0.5
            )

        D.savedConfig.gui.height =
            math.floor(
                D.Main.AbsoluteSize.Y
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
        D.Main.AbsoluteSize.X

    local height =
        D.Main.AbsoluteSize.Y

    local x =
        D.Main.Position.X.Offset

    local y =
        D.Main.Position.Y.Offset

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

    D.Main.Position =
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
    D.Main.Size =
        UDim2.new(
            0,
            math.max(
                D.MIN_WINDOW_WIDTH,
                math.floor(
                    width + 0.5
                )
            ),
            0,
            math.max(
                D.MIN_WINDOW_HEIGHT,
                math.floor(
                    height + 0.5
                )
            )
        )

    clampWindowPosition()
end

--// Drag the title bar.
function DEADEYE_FN_beginWindowDrag(input)
    if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        or input.UserInputType ==
            Enum.UserInputType.Touch
    then
        D.dragging = true
        D.dragStart =
            input.Position
        D.startPosition =
            D.Main.Position
    end
end

DEADEYE_FN_addConnection(
    D.DragHandle.InputBegan:Connect(
        function(input)
            DEADEYE_FN_beginWindowDrag(input)
        end
    )
)

DEADEYE_FN_addConnection(
    D.MainTitle.InputBegan:Connect(
        function(input)
            DEADEYE_FN_beginWindowDrag(input)
        end
    )
)

DEADEYE_FN_addConnection(
    D.UserInputService.InputChanged:Connect(
        function(input)
            if not D.dragging then
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
                D.dragStart

            D.Main.Position =
                UDim2.new(
                    D.startPosition.X.Scale,
                    D.startPosition.X.Offset
                        + delta.X,
                    D.startPosition.Y.Scale,
                    D.startPosition.Y.Offset
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
    if D.mainMinimized then
        return
    end

    resizing = true
    D.resizeMode = mode
    D.resizeStart =
        position
    D.resizeStartSize =
        D.Main.AbsoluteSize
end

--// Invisible right-edge resize target.
D.ResizeRight =
    Instance.new("Frame")
D.ResizeRight.Name =
    "ResizeRight"
D.ResizeRight.Size =
    UDim2.new(
        0,
        D.RESIZE_EDGE,
        1,
        -54
    )
D.ResizeRight.Position =
    UDim2.new(
        1,
        -D.RESIZE_EDGE,
        0,
        48
    )
D.ResizeRight.BackgroundTransparency =
    1
D.ResizeRight.BorderSizePixel =
    0
D.ResizeRight.ZIndex =
    20
D.ResizeRight.Active =
    true
D.ResizeRight.Parent =
    D.Main

DEADEYE_FN_addConnection(
    D.ResizeRight.InputBegan:Connect(
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
D.ResizeBottom =
    Instance.new("Frame")
D.ResizeBottom.Name =
    "ResizeBottom"
D.ResizeBottom.Size =
    UDim2.new(
        1,
        -54,
        0,
        D.RESIZE_EDGE
    )
D.ResizeBottom.Position =
    UDim2.new(
        0,
        8,
        1,
        -D.RESIZE_EDGE
    )
D.ResizeBottom.BackgroundTransparency =
    1
D.ResizeBottom.BorderSizePixel =
    0
D.ResizeBottom.ZIndex =
    20
D.ResizeBottom.Active =
    true
D.ResizeBottom.Parent =
    D.Main

DEADEYE_FN_addConnection(
    D.ResizeBottom.InputBegan:Connect(
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
D.ResizeCorner =
    Instance.new("TextButton")
D.ResizeCorner.Name =
    "ResizeCorner"
D.ResizeCorner.Size =
    UDim2.new(
        0,
        24,
        0,
        24
    )
D.ResizeCorner.Position =
    UDim2.new(
        1,
        -24,
        1,
        -24
    )
D.ResizeCorner.BackgroundTransparency =
    1
D.ResizeCorner.BorderSizePixel =
    0
D.ResizeCorner.Text =
    ""
D.ResizeCorner.TextSize =
    1
D.ResizeCorner.ZIndex =
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
        D.ResizeCorner
end
D.ResizeCorner.AutoButtonColor =
    false
D.ResizeCorner.Parent =
    D.Main

DEADEYE_FN_addConnection(
    D.ResizeCorner.InputBegan:Connect(
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

DEADEYE_FN_addConnection(
    D.UserInputService.InputChanged:Connect(
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
                D.resizeStart

            local width =
                D.resizeStartSize.X

            local height =
                D.resizeStartSize.Y

            if D.resizeMode == "right"
                or D.resizeMode == "corner"
            then
                width =
                    D.resizeStartSize.X +
                    delta.X
            end

            if D.resizeMode == "bottom"
                or D.resizeMode == "corner"
            then
                height =
                    D.resizeStartSize.Y +
                    delta.Y
            end

            setMainSize(
                width,
                height
            )
        end
    )
)

DEADEYE_FN_addConnection(
    D.UserInputService.InputEnded:Connect(
        function(input)
            if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch
            then
                if D.dragging then
                    D.dragging = false
                    saveWindowState()
                end

                if resizing then
                    resizing = false
                    D.resizeMode = nil
                    saveWindowState()
                end
            end
        end
    )
)

--// CLEANUP
--// =========================================================
function DEADEYE_FN_cleanup()
    if D.cleaned then
        return
    end

    restoreNativeEmoteWheel(true)

    --// Stop every active loop before doing any cleanup that may yield.
    D.cleaned = true
    D.genv.EMOTE_SWAPPER_RUNNING = false
    D.genv.DEADEYE_MAIN_RUNNING = false
    D.genv.DEADEYE_UNUSUAL_POV_RUNNING = false
    D.genv.DEADEYE_PORTRAIT_RUNNING = false

    D.enabled = false
    D.replacementGeneration =
        D.replacementGeneration + 1
    D.replacementRunning =
        false

    local activeObject =
        getCharacterObject()

    if activeObject
        and D.currentCustomEmote
        and activeObject.Emote
            == D.currentCustomEmote
    then
        pcall(function()
            activeObject.Emote = nil
        end)
    end

    local emoteToStop =
        D.currentCustomEmote

    D.currentCustomEmote = nil
    D.currentOriginalId = nil
    D.currentReplaceId = nil

    if emoteToStop then
        task.spawn(function()
            DEADEYE_FN_stopEmoteObject(
                emoteToStop
            )
        end)
    end

    DEADEYE_FN_disconnectAll()

    pcall(function()
        if D.genv.UNUSUAL_SWAPPER_CLEANUP then
            D.genv.UNUSUAL_SWAPPER_CLEANUP()
        end
    end)

    pcall(function()
        if D.genv.DEADEYE_PORTRAIT_CLEANUP then
            D.genv.DEADEYE_PORTRAIT_CLEANUP()
        end
    end)

    pcall(function()
        saveWindowState()
    end)

    pcall(function()
        if D.Picker then
            D.Picker.Visible = false
        end
    end)

    pcall(function()
        if D.ScreenGui then
            D.ScreenGui:Destroy()
        end
    end)

    D.genv.EMOTE_SWAPPER_CLEANUP =
        nil
end
D.genv.EMOTE_SWAPPER_CLEANUP =
    DEADEYE_FN_cleanup
--// =========================================================
--// CLOSE
--// =========================================================
DEADEYE_FN_addConnection(
    D.Close.MouseButton1Click:Connect(
        function()
            DEADEYE_FN_cleanup()
        end
    )
)
--// =========================================================
--// =========================================================
--// GLASS SURFACE FINISH
--// =========================================================
for _, object in ipairs(
    D.Main:GetDescendants()
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

--// INIT
--// =========================================================
pcall(function()
    clampWindowPosition()
end)
prepareSlots()
D.savedConfig.emotes =
    D.savedConfig.emotes
    or {}
for i = 1, D.SLOT_COUNT do
    D.savedConfig.emotes[i] = {
        originalId =
            D.slots[i].originalId,
        replaceId =
            D.slots[i].replaceId
    }
end
D.savedConfig.unusual = {
    originalId =
        D.unusualSlot.originalId,
    replaceId =
        D.unusualSlot.replaceId
}
saveSavedConfig()
D.setMainMinimized(false)
updateGUI()
pcall(function()
    DEADEYE_FN_setCategory("Emotes")
end)
portrait.start()
