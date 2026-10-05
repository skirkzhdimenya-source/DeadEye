--// =========================================================
--// NO LANDING FRICTION TEST
--// CURRENT VERSION: 1.01
--//
--// ВАЖНО:
--// После каждого полностью завершённого изменения этого
--// отдельного тестового скрипта повышать версию на 0.01.
--// Пример: v1.01 -> v1.02.
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

local Functions =
    require(FunctionsModule)

local Helpers =
    require(HelpersModule)

local OriginalAir = nil
local OriginalRun = nil
local OriginalApplyFriction = nil

local hooksInstalled = false

--// True when the latest movement-function update was Air.
local LastMovementWasAir = false

--// Only true for the first Run update after Air.
local SkipNextRunFriction = false

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

    LastMovementWasAir = false
    SkipNextRunFriction = false

    if stopConnection then
        pcall(function()
            stopConnection:Disconnect()
        end)
        stopConnection = nil
    end

    if type(hookfunction) == "function" then
        if hooksInstalled
            and Functions
            and Functions.Air
            and OriginalAir
        then
            pcall(function()
                hookfunction(
                    Functions.Air,
                    OriginalAir
                )
            end)
        end

        if hooksInstalled
            and Functions
            and Functions.Run
            and OriginalRun
        then
            pcall(function()
                hookfunction(
                    Functions.Run,
                    OriginalRun
                )
            end)
        end

        if hooksInstalled
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
    end

    OriginalAir = nil
    OriginalRun = nil
    OriginalApplyFriction = nil

    hooksInstalled = false

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

        if type(Functions) ~= "table"
            or type(Functions.Air) ~= "function"
            or type(Functions.Run) ~= "function"
        then
            error(
                "Functions.Air / Functions.Run not found"
            )
        end

        if type(Helpers) ~= "table"
            or type(Helpers.ApplyFriction) ~= "function"
        then
            error(
                "Helpers.ApplyFriction not found"
            )
        end

        --// -------------------------------------------------
        --// AIR HOOK
        --// -------------------------------------------------
        OriginalAir =
            hookfunction(
                Functions.Air,
                function(...)
                    --// A new Air update starts / continues an
                    --// airborne phase. Any old pending landing
                    --// skip must be discarded.
                    LastMovementWasAir = true
                    SkipNextRunFriction = false

                    return OriginalAir(...)
                end
            )

        if type(OriginalAir) ~= "function" then
            error(
                "Failed to capture original Functions.Air"
            )
        end

        --// -------------------------------------------------
        --// RUN HOOK
        --// -------------------------------------------------
        OriginalRun =
            hookfunction(
                Functions.Run,
                function(...)
                    local wasAir =
                        LastMovementWasAir

                    --// This Run is no longer the Air update.
                    LastMovementWasAir = false

                    SkipNextRunFriction =
                        NO_LANDING_FRICTION
                        and wasAir
                        or false

                    return OriginalRun(...)
                end
            )

        if type(OriginalRun) ~= "function" then
            error(
                "Failed to capture original Functions.Run"
            )
        end

        --// -------------------------------------------------
        --// APPLY FRICTION HOOK
        --// -------------------------------------------------
        --
        --// IMPORTANT:
        --// The native function has 7 parameters:
        --
        --// function ApplyFriction(
        --//     self,
        --//     dt,
        --//     movementData,
        --//     dataRegistry,
        --//     character,
        --//     moveStats,
        --//     frictionFactor
        --// )
        --
        --// The previous failed test had only 6 parameters.
        --// That shifted moveStats into p11 and caused:
        --// "arithmetic ... number and nil"
        --
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
                    if SkipNextRunFriction
                        and frictionFactor == 1
                    then
                        --// Normal Run calls:
                        --// Helpers:ApplyFriction(..., 1)
                        --
                        --// Returning the current Velocity is
                        --// exactly the same result as the native
                        --// helper with frictionFactor = 0,
                        --// for this one call only.
                        SkipNextRunFriction = false

                        return dataRegistry:Get(
                            "Velocity"
                        )
                    end

                    --// Every other ApplyFriction call stays native.
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

        hooksInstalled = true
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
    "[NoLandingFrictionTest] v1.01 ACTIVE"
)
print(
    "[NoLandingFrictionTest] NO_LANDING_FRICTION =",
    NO_LANDING_FRICTION
)
print(
    "[NoLandingFrictionTest] F6 = STOP + CLEANUP"
)
