local G = getgenv().DeadEye

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local root = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")

local mainPage = G.UI.MainPage

print("[Main] запущен")
print("[Main] MainPage найден:", mainPage ~= nil)

-- =========================================================
-- CIRCLE
-- =========================================================

local circleEnabled = false

local radius = 7.7
local lineThickness = 0.2
local segments = 128

local folder = nil
local parts = {}
local circleConnection = nil

local function createCircle()

    if folder then
        return
    end

    folder = Instance.new("Folder")

    folder.Name = "CircleZone"
    folder.Parent = workspace

    parts = {}

    local segmentLength =
        (
            2
            * math.pi
            * radius
            / segments
        )
        + 0.2

    for i = 1, segments do

        local part = Instance.new("Part")

        part.Size =
            Vector3.new(
                lineThickness,
                0.15,
                segmentLength
            )

        part.Material = Enum.Material.Neon
        part.Transparency = 0.3

        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false

        part.Anchored = true
        part.Parent = folder

        table.insert(parts, part)

    end

    circleConnection =
        RunService.RenderStepped:Connect(
            function()

                if not root
                    or not root.Parent
                then
                    return
                end

                for i, part in ipairs(parts) do

                    local angle =
                        (
                            i / segments
                        )
                        * math.pi
                        * 2

                    local position =
                        root.Position
                        +
                        Vector3.new(
                            math.cos(angle)
                                * radius,

                            -3,

                            math.sin(angle)
                                * radius
                        )

                    part.Position = position

                    part.CFrame =
                        CFrame.new(
                            position
                        )
                        *
                        CFrame.Angles(
                            0,
                            -angle,
                            0
                        )

                end

            end
        )

end

local function destroyCircle()

    if circleConnection then

        circleConnection:Disconnect()
        circleConnection = nil

    end

    if folder then

        folder:Destroy()
        folder = nil

    end

    parts = {}

end

G.Cleanup.Circle = function()
    circleEnabled = false

    if destroyCircle then
        destroyCircle()
    end
end

-- =========================================================
-- CIRCLE GUI
-- =========================================================

local createToggle = G.Functions.createToggle
local setToggleVisual = G.Functions.setToggleVisual

local circleLabel = Instance.new("TextLabel")

circleLabel.Name = "CircleLabel"
circleLabel.Size = UDim2.new(0, 80, 0, 25)
circleLabel.Position = UDim2.new(0, 10, 0, 5)
circleLabel.BackgroundTransparency = 1
circleLabel.Text = "circle"
circleLabel.TextColor3 = Color3.fromRGB(242, 242, 242)
circleLabel.TextSize = 12
circleLabel.Font = Enum.Font.SourceSans
circleLabel.TextXAlignment = Enum.TextXAlignment.Left
circleLabel.TextYAlignment = Enum.TextYAlignment.Center
circleLabel.Parent = mainPage

local circleToggle, circleKnob =
    createToggle(mainPage, 11)

setToggleVisual(
    circleToggle,
    circleKnob,
    false
)

circleToggle.MouseButton1Click:Connect(function()

    circleEnabled =
        not circleEnabled

    if circleEnabled then

        createCircle()

    else

        destroyCircle()

    end

    setToggleVisual(
        circleToggle,
        circleKnob,
        circleEnabled
    )

end)
