--// =========================================================
--// NO LANDING FRICTION TEST
--// CURRENT VERSION: 1.02
--//
--// ВАЖНО:
--// После каждого полностью завершённого изменения этого
--// отдельного тестового скрипта повышать версию на 0.01.
--// Пример: v1.01 -> v1.02 -> v1.03.
--//
--// Этот файл НЕ меняет DeadEye.lua.
--// Цель: проверить только удаление первого Run ApplyFriction
--// после Air -> Run.
--//
--// F6 = полностью снять хуки и остановить тест.
--// Повторный запуск автоматически снимает старую копию.
--// =========================================================

local genv = getgenv and getgenv() or _G

--// =========================================================
--// PREVIOUS TEST CLEANUP
--// =========================================================
pcall(function()
    if genv.NO_LANDING_FRICTION_TEST_CLEANUP then
        genv.NO_LANDING_FRICTION_TEST_CLEANUP()
    end
end)

genv.NO_LANDING_FRICTION_TEST_RUNNING = true

--// =========================================================
--// SETTINGS
--// =========================================================
local NO_LANDING_FRICTION = true
local STOP_KEY = Enum.KeyCode.F6

--// =========================================================
--// SERVICES
--// =========================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

--// =========================================================
--// =========================================================
--// STATE
--// =========================================================
local cleaned = false

local FunctionsModule =
    ReplicatedStorage
    .Objects
    .Game
    .Character
    .Client
    .Movement
    .MoveFunction
    .Functions

local HelpersModule =
    FunctionsModule.Helpers

local Helpers =
    require(HelpersModule)

local OriginalApplyFriction = nil
local hookInstalled = false

--// True after ApplyFriction was observed being called by Air.
local sawAirFriction = false

local stopConnection = nil


--// =========================================================
--// CLEANUP
--// =========================================================
local function cleanup()
    if cleaned then
        return
    end

    cleaned = true
    genv.NO_LANDING_FRICTION_TEST_RUNNING = false
    sawAirFriction = false

    if stopConnection then
        pcall(function()
            stopConnection:Disconnect()
        end)
        stopConnection = nil
    end

    if hookInstalled
        and type(hookfunction) == "function"
        and Helpers
        and Helpers.ApplyFriction
        and OriginalApplyFriction
    then
        pcall(function()
            hookfunction(
                Helpers.ApplyFriction,
                OriginalApplyFriction
            )
        end)
    end

    OriginalApplyFriction = nil
    hookInstalled = false

    genv.NO_LANDING_FRICTION_TEST_CLEANUP = nil

    print(
        "[NoLandingFrictionTest] STOPPED / CLEANED"
    )
end

genv.NO_LANDING_FRICTION_TEST_CLEANUP =
    cleanup


--// =========================================================
--// INSTALL
--// =========================================================
if type(hookfunction) ~= "function" then
    warn(
        "[NoLandingFrictionTest] hookfunction is unavailable"
    )
    cleanup()
    return
end

local ok, err =
    pcall(function()

        if type(Helpers) ~= "table"
            or type(Helpers.ApplyFriction) ~= "function"
        then
            error(
                "Helpers.ApplyFriction not found"
            )
        end

        --// IMPORTANT:
        --// We hook ONLY ApplyFriction.
        --// Run and Air themselves are never hooked.
        --
        --// ApplyFriction is called from:
        --//   Functions.Run -> line 41
        --//   Functions.Air -> its Air friction call
        --
        --// debug.info caller line lets us distinguish these
        --// without replacing Run/Air and without disturbing
        --// their native execution.

        OriginalApplyFriction =
            hookfunction(
                Helpers.ApplyFriction,
                function(
                    self,
                    dt,
                    movementData,
                    dataRegistry,
                    character,
                    moveStats,
                    frictionFactor
                )
                    local callerLine = -1

                    pcall(function()
                        callerLine =
                            debug.info(
                                2,
                                "l"
                            )
                    end)

                    --// Functions.Run's ApplyFriction call is
                    --// confirmed at source line 41 in the
                    --// recovered Functions module.
                    local fromRun =
                        callerLine == 41

                    if not fromRun then
                        --// Air also uses factor 1, but its call
                        --// must remain 100% native.
                        sawAirFriction = true

                        return OriginalApplyFriction(
                            self,
                            dt,
                            movementData,
                            dataRegistry,
                            character,
                            moveStats,
                            frictionFactor
                        )
                    end

                    local skip =
                        NO_LANDING_FRICTION
                        and sawAirFriction
                        and frictionFactor == 1

                    sawAirFriction = false

                    if skip then
                        --// Do not alter Run itself.
                        --// Only this exact friction result is replaced.
                        return dataRegistry:Get(
                            "Velocity"
                        )
                    end

                    return OriginalApplyFriction(
                        self,
                        dt,
                        movementData,
                        dataRegistry,
                        character,
                        moveStats,
                        frictionFactor
                    )
                end
            )

        if type(OriginalApplyFriction) ~= "function" then
            error(
                "Failed to capture original Helpers.ApplyFriction"
            )
        end

        hookInstalled = true
    end)

if not ok then
    warn(
        "[NoLandingFrictionTest] INSTALL ERROR:",
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
    "[NoLandingFrictionTest] v1.02 ACTIVE"
)
print(
    "[NoLandingFrictionTest] NO_LANDING_FRICTION =",
    NO_LANDING_FRICTION
)
print(
    "[NoLandingFrictionTest] F6 = STOP + CLEANUP"
)
