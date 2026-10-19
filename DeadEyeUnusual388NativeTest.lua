--// DeadEyeUnusual388NativeTest.lua
--// Standalone test: clone a clean local avatar rig to the player's right,
--// then apply Unusual 388 through the game's own RigService.AddCosmetics.
--// This script does not load or modify DeadEyeTest.lua.

local TEST_ID = 388
local TEST_RIG_NAME = "DeadEye_Unusual388_NativeTestRig"
local ENV = _G
pcall(function()
    if type(getgenv) == "function" then
        ENV = getgenv()
    end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    warn("[Native 388 Test] LocalPlayer not available.")
    return
end

-- Clean up only a previous copy created by this standalone test.
pcall(function()
    if type(ENV.DEADEYE_UNUSUAL_388_TEST_CLEANUP) == "function" then
        ENV.DEADEYE_UNUSUAL_388_TEST_CLEANUP()
    end
end)

local existing = workspace:FindFirstChild(TEST_RIG_NAME)
if existing then
    pcall(function()
        existing:Destroy()
    end)
end

local function countFX(root)
    local counts = {
        ParticleEmitter = 0,
        Trail = 0,
        Beam = 0,
        Sparkles = 0,
        Fire = 0,
        Smoke = 0,
        Highlight = 0,
        Lights = 0,
        BillboardGui = 0,
    }

    for _, object in ipairs(root:GetDescendants()) do
        local className = object.ClassName
        if counts[className] ~= nil then
            counts[className] += 1
        elseif object:IsA("PointLight")
            or object:IsA("SpotLight")
            or object:IsA("SurfaceLight")
        then
            counts.Lights += 1
        end
    end

    local total = 0
    for _, count in pairs(counts) do
        total += count
    end
    return total, counts
end

local function formatCounts(counts)
    return ("PE=%d Trail=%d Beam=%d Sparkles=%d Fire=%d Smoke=%d Highlight=%d Lights=%d Billboard=%d")
        :format(
            counts.ParticleEmitter,
            counts.Trail,
            counts.Beam,
            counts.Sparkles,
            counts.Fire,
            counts.Smoke,
            counts.Highlight,
            counts.Lights,
            counts.BillboardGui
        )
end

local function getRigType()
    local rigs = workspace:FindFirstChild("Rigs")
    local visual = rigs and rigs:FindFirstChild(LocalPlayer.Name)
    local humanoid = visual and visual:FindFirstChildOfClass("Humanoid")

    if not humanoid and LocalPlayer.Character then
        humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end

    if humanoid then
        return humanoid.RigType
    end

    return Enum.HumanoidRigType.R15
end

local function getLiveRoot()
    local playersFolder = workspace:FindFirstChild("Players")
    local character = playersFolder and playersFolder:FindFirstChild(LocalPlayer.Name)
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root and LocalPlayer.Character then
        root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end

    if root and root:IsA("BasePart") then
        return root
    end

    local rigs = workspace:FindFirstChild("Rigs")
    local visual = rigs and rigs:FindFirstChild(LocalPlayer.Name)
    root = visual and visual:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then
        return root
    end

    return nil
end

local function findAppearanceTemplate()
    local cache = workspace:FindFirstChild("PlayerCache")
    local entry = cache and cache:FindFirstChild(LocalPlayer.Name)

    if not entry then
        return nil
    end

    local rigType = getRigType()
    local templateName = rigType == Enum.HumanoidRigType.R6 and "R6" or "Player"
    local template = entry:FindFirstChild(templateName)

    if template and template:IsA("Model")
        and template:FindFirstChildOfClass("Humanoid")
        and template:FindFirstChild("HumanoidRootPart")
    then
        return template
    end

    -- Some games/cache states only expose one appearance variant.
    for _, candidateName in ipairs({"Player", "R6"}) do
        local candidate = entry:FindFirstChild(candidateName)
        if candidate and candidate:IsA("Model")
            and candidate:FindFirstChildOfClass("Humanoid")
            and candidate:FindFirstChild("HumanoidRootPart")
        then
            return candidate
        end
    end

    return nil
end

local function setBaseRigSafe(testRig)
    local humanoid = testRig:FindFirstChildOfClass("Humanoid")
    if humanoid then
        pcall(function()
            humanoid.EvaluateStateMachine = false
            humanoid.RequiresNeck = false
            humanoid.BreakJointsOnDeath = false
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            humanoid.AutoRotate = false
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end)
    end

    -- Disable scripts copied from the avatar template before applying 388.
    -- The native AddCosmetics module remains free to enable scripts inside
    -- the effect it clones, just as it does during the game's normal build.
    for _, object in ipairs(testRig:GetDescendants()) do
        if object:IsA("Script") or object:IsA("LocalScript") then
            pcall(function()
                object.Disabled = true
            end)
        elseif object:IsA("BasePart") then
            pcall(function()
                object.CanCollide = false
                object.CanTouch = false
                object.CanQuery = false
                object.Massless = true
                object.LocalTransparencyModifier = 0
            end)
        end
    end
end

local function cleanup()
    local rig = ENV.DEADEYE_UNUSUAL_388_TEST_RIG
    if rig then
        pcall(function()
            rig:Destroy()
        end)
    end
    ENV.DEADEYE_UNUSUAL_388_TEST_RIG = nil

    local namedRig = workspace:FindFirstChild(TEST_RIG_NAME)
    if namedRig then
        pcall(function()
            namedRig:Destroy()
        end)
    end

    if ENV.DEADEYE_UNUSUAL_388_TEST_CLEANUP == cleanup then
        ENV.DEADEYE_UNUSUAL_388_TEST_CLEANUP = nil
    end
end

ENV.DEADEYE_UNUSUAL_388_TEST_CLEANUP = cleanup

local template
for attempt = 1, 60 do
    template = findAppearanceTemplate()
    if template and getLiveRoot() then
        break
    end
    task.wait(0.25)
end

if not template then
    warn("[Native 388 Test] PlayerCache appearance not found. Make sure the character has loaded, then rerun.")
    return
end

local liveRoot = getLiveRoot()
if not liveRoot then
    warn("[Native 388 Test] Could not locate the player's HumanoidRootPart.")
    return
end

local testRig
local cloneOK, cloneError = pcall(function()
    testRig = template:Clone()
end)

if not cloneOK or not testRig then
    warn("[Native 388 Test] Could not clone PlayerCache appearance: " .. tostring(cloneError))
    return
end

testRig.Name = TEST_RIG_NAME
testRig:SetAttribute("DeadEyeNativeUnusualTestId", TEST_ID)

local rootPart = testRig:FindFirstChild("HumanoidRootPart")
if not rootPart or not rootPart:IsA("BasePart") then
    testRig:Destroy()
    warn("[Native 388 Test] The cloned appearance has no HumanoidRootPart.")
    return
end

testRig.PrimaryPart = rootPart
setBaseRigSafe(testRig)

-- Set the clone to the avatar's right, preserving its facing direction.
local targetRootCFrame = liveRoot.CFrame * CFrame.new(6, 0, 0)
local pivotToRoot = testRig:GetPivot():ToObjectSpace(rootPart.CFrame)
pcall(function()
    testRig:PivotTo(targetRootCFrame * pivotToRoot:Inverse())
end)

-- Anchor only the root: limb joints and effect-driven parts can still move.
rootPart.Anchored = true
testRig.Parent = workspace
ENV.DEADEYE_UNUSUAL_388_TEST_RIG = testRig

local beforeDescendants = #testRig:GetDescendants()
local beforeFXTotal, beforeFXCounts = countFX(testRig)

local applyOK, applyError = pcall(function()
    local services = ReplicatedStorage:WaitForChild("Services")
    local rigService = services:WaitForChild("Asset"):WaitForChild("RigService")
    local nativeAddCosmetics = require(rigService:WaitForChild("AddCosmetics"))

    -- The exact native cosmetic-attachment module used by RigService.
    nativeAddCosmetics(testRig, { TEST_ID })
end)

local afterDescendants = #testRig:GetDescendants()
local afterFXTotal, afterFXCounts = countFX(testRig)

warn(
    "[Native 388 Test]"
        .. " rig=" .. testRig:GetFullName()
        .. " | id=" .. tostring(TEST_ID)
        .. " | AddCosmetics pcall=" .. tostring(applyOK)
        .. " | FX=" .. tostring(beforeFXTotal) .. " -> " .. tostring(afterFXTotal)
        .. " (" .. formatCounts(afterFXCounts) .. ")"
        .. " | descendants=" .. tostring(beforeDescendants) .. " -> " .. tostring(afterDescendants)
        .. (applyOK and "" or " | error=" .. tostring(applyError))
)

if applyOK then
    print("[Native 388 Test] Rig is at the player's right. To remove it, run: getgenv().DEADEYE_UNUSUAL_388_TEST_CLEANUP()")
end
