--// =========================================================
--// RAGE LOOK STANDALONE TEST
--// CURRENT VERSION: 1.01
--//
--// ВАЖНО:
--// После каждого полностью завершённого изменения этого
--// отдельного тестового скрипта повышать версию на 0.01.
--// Пример: v1.01 -> v1.02.
--//
--// Цель:
--// Игре отдаётся фальшивый LookCFrame с pitch ~= -89°,
--// но реальная камера игрока вообще не изменяется.
--//
--// F6 = полностью снять хуки и остановить тест.
--// Повторный запуск автоматически снимает старый экземпляр.
--// =========================================================

local genv = getgenv and getgenv() or _G

--// =========================================================
--// PREVIOUS INSTANCE CLEANUP
--// =========================================================
pcall(function()
    if genv.RAGE_LOOK_TEST_CLEANUP then
        genv.RAGE_LOOK_TEST_CLEANUP()
    end
end)

genv.RAGE_LOOK_TEST_RUNNING = true

--// =========================================================
--// SETTINGS
--// =========================================================
local RAGE_LOOK_PITCH = -math.rad(89)
local STOP_KEY = Enum.KeyCode.F6

--// =========================================================
--// SERVICES
--// =========================================================
local ReplicatedStorage =
    game:GetService("ReplicatedStorage")

local Players =
    game:GetService("Players")

local UserInputService =
    game:GetService("UserInputService")

local LocalPlayer =
    Players.LocalPlayer

--// =========================================================
--// STATE
--// =========================================================
local cleaned = false

local rageAirDepth = 0
local hooksInstalled = false

local rageLookAirFunction = nil
local rageLookOriginalAir = nil

local registryGetFunction = nil
local registryOriginalGet = nil

local stopConnection = nil

--// =========================================================
--// GET CHARACTER OBJECT
--// =========================================================
local CharacterService

pcall(function()
    CharacterService =
        require(
            ReplicatedStorage
            .Services
            .Asset
            .CharacterService
        )
end)

local function getCharacterObject()
    if not CharacterService then
        return nil
    end

    local object

    pcall(function()
        object =
            CharacterService:GetLocalCharacter()
    end)

    if not object then
        return nil
    end

    return object
end

--// =========================================================
--// BUILD FAKE LOOK CFRAME
--// =========================================================
local function getFakeLookCFrame(realCFrame)
    if typeof(realCFrame) ~= "CFrame" then
        return nil
    end

    --// Keep the real yaw.
    --// Remove the real pitch first so the fake pitch is stable.
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

--// =========================================================
--// FIND REAL AIR FUNCTION
--// =========================================================
local function findAirFunction()
    if type(getgc) ~= "function"
        or not debug
        or type(debug.getinfo) ~= "function"
    then
        return nil
    end

    local objects

    local ok =
        pcall(function()
            objects =
                getgc(true)
        end)

    if not ok
        or type(objects) ~= "table"
    then
        return nil
    end

    for _, object in ipairs(objects) do
        if type(object) == "function" then

            local info

            pcall(function()
                info =
                    debug.getinfo(
                        object
                    )
            end)

            if info then
                local source =
                    tostring(
                        info.source or ""
                    )

                local line =
                    tonumber(
                        info.linedefined
                    )

                if string.find(
                    source,
                    "ReplicatedStorage.Objects.Game.Character.Client.Movement.MoveFunction.Functions",
                    1,
                    true
                )
                and line == 109
                then
                    return object
                end
            end
        end
    end

    return nil
end

--// =========================================================
--// FIND DATEREGISTRY.GET
--// =========================================================
local function findRegistryGet()
    local object =
        getCharacterObject()

    if not object
        or not object.DataRegistry
    then
        return nil
    end

    local registry =
        object.DataRegistry

    local getFunction

    pcall(function()
        getFunction =
            registry.Get
    end)

    if type(getFunction) ~= "function" then
        return nil
    end

    return getFunction
end

--// =========================================================
--// CLEANUP
--// =========================================================
local function cleanup()
    if cleaned then
        return
    end

    cleaned = true
    genv.RAGE_LOOK_TEST_RUNNING = false

    rageAirDepth = 0

    if stopConnection then
        pcall(function()
            stopConnection:Disconnect()
        end)

        stopConnection = nil
    end

    if type(hookfunction) == "function" then

        if registryGetFunction
            and registryOriginalGet
        then
            pcall(function()
                hookfunction(
                    registryGetFunction,
                    registryOriginalGet
                )
            end)
        end

        if rageLookAirFunction
            and rageLookOriginalAir
        then
            pcall(function()
                hookfunction(
                    rageLookAirFunction,
                    rageLookOriginalAir
                )
            end)
        end
    end

    registryGetFunction = nil
    registryOriginalGet = nil

    rageLookAirFunction = nil
    rageLookOriginalAir = nil

    hooksInstalled = false

    genv.RAGE_LOOK_TEST_CLEANUP =
        nil

    print(
        "[RageLookTest] STOPPED / CLEANED"
    )
end

genv.RAGE_LOOK_TEST_CLEANUP =
    cleanup

--// =========================================================
--// INSTALL
--// =========================================================
if type(hookfunction) ~= "function" then
    warn(
        "[RageLookTest] hookfunction is unavailable"
    )

    cleanup()
    return
end

local ok, err =
    pcall(function()

        --// ---------------------------------------------
        --// FIND FUNCTIONS
        --// ---------------------------------------------
        rageLookAirFunction =
            findAirFunction()

        if type(rageLookAirFunction) ~= "function" then
            error(
                "Real Air function (line 109) not found"
            )
        end

        registryGetFunction =
            findRegistryGet()

        if type(registryGetFunction) ~= "function" then
            error(
                "DataRegistry.Get not found"
            )
        end

        --// ---------------------------------------------
        --// HOOK DATEREGISTRY.GET
        --// ---------------------------------------------
        registryOriginalGet =
            hookfunction(
                registryGetFunction,
                function(
                    self,
                    key
                )

                    local results =
                        table.pack(
                            registryOriginalGet(
                                self,
                                key
                            )
                        )

                    --// ONLY movement code currently inside
                    --// the real Air function receives fake LookCFrame.
                    --
                    --// The actual Roblox camera is never touched.
                    if genv.RAGE_LOOK_TEST_RUNNING
                        and rageAirDepth > 0
                        and key == "LookCFrame"
                        and not cleaned
                    then

                        local realCFrame =
                            results[1]

                        local fakeCFrame =
                            getFakeLookCFrame(
                                realCFrame
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

        if type(registryOriginalGet) ~= "function" then
            error(
                "Failed to hook DataRegistry.Get"
            )
        end

        --// ---------------------------------------------
        --// HOOK AIR
        --// ---------------------------------------------
        rageLookOriginalAir =
            hookfunction(
                rageLookAirFunction,
                function(...)

                    if not genv.RAGE_LOOK_TEST_RUNNING
                        or cleaned
                    then
                        return rageLookOriginalAir(...)
                    end

                    rageAirDepth =
                        rageAirDepth + 1

                    local results =
                        table.pack(
                            pcall(function()
                                return rageLookOriginalAir(...)
                            end)
                        )

                    rageAirDepth =
                        math.max(
                            0,
                            rageAirDepth - 1
                        )

                    if not results[1] then
                        error(
                            results[2],
                            0
                        )
                    end

                    return table.unpack(
                        results,
                        2,
                        results.n
                    )
                end
            )

        if type(rageLookOriginalAir) ~= "function" then
            error(
                "Failed to hook Air"
            )
        end

        hooksInstalled = true
    end)

if not ok then
    warn(
        "[RageLookTest] INSTALL ERROR:",
        err
    )

    cleanup()
    return
end

--// =========================================================
--// F6 STOP
--// =========================================================
stopConnection =
    UserInputService.InputBegan:Connect(
        function(input, gameProcessed)
            if gameProcessed then
                return
            end

            if input.KeyCode == STOP_KEY then
                cleanup()
            end
        end
    )

print(
    "[RageLookTest] v1.01 ACTIVE"
)

print(
    "[RageLookTest] Fake Look pitch = -89 degrees"
)

print(
    "[RageLookTest] Real camera is NOT modified"
)

print(
    "[RageLookTest] F6 = STOP + CLEANUP"
)
