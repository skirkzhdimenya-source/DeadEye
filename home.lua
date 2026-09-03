local G = getgenv().DeadEye or {}
getgenv().DeadEye = G

G.UI = G.UI or {}
G.State = G.State or {}
G.Functions = G.Functions or {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- =========================================================
-- GUI
-- =========================================================

local hui = gethui()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyWindowGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = hui

-- =========================================================
-- ОКНО
-- =========================================================

local frame = Instance.new("Frame")
frame.Name = "WindowFrame"
frame.Size = UDim2.new(0.2, 0, 0.4, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- =========================================================
-- ЗАГОЛОВОК
-- =========================================================

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 18)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
title.TextColor3 = Color3.fromRGB(242, 242, 242)
title.Text = "trajectory"
title.TextSize = 12
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.BackgroundTransparency = 0
title.BorderSizePixel = 0
title.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10)
padding.Parent = title

-- =========================================================
-- КНОПКА X
-- =========================================================

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 12, 0, 12)
closeButton.Position = UDim2.new(1, -15, 0, 3)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.TextSize = 8
closeButton.Font = Enum.Font.SourceSansBold
closeButton.BorderSizePixel = 0
closeButton.Parent = frame

-- =========================================================
-- КНОПКА _
-- =========================================================

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 12, 0, 12)
minimizeButton.Position = UDim2.new(1, -30, 0, 3)
minimizeButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Text = "_"
minimizeButton.TextSize = 8
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.BorderSizePixel = 0
minimizeButton.Parent = frame

-- =========================================================
-- SIDEBAR / КОНТЕНТ
-- =========================================================

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 70, 1, -18)
sidebar.Position = UDim2.new(0, 0, 0, 18)
sidebar.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
sidebar.BorderSizePixel = 0
sidebar.Parent = frame

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -70, 1, -18)
content.Position = UDim2.new(0, 70, 0, 18)
content.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
content.BorderSizePixel = 0
content.Parent = frame

local mainButton = Instance.new("TextButton")
mainButton.Name = "MainButton"
mainButton.Size = UDim2.new(1, 0, 0, 30)
mainButton.Position = UDim2.new(0, 0, 0, 5)
mainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainButton.TextColor3 = Color3.fromRGB(242, 242, 242)
mainButton.Text = "main"
mainButton.TextSize = 12
mainButton.Font = Enum.Font.SourceSans
mainButton.BorderSizePixel = 0
mainButton.Parent = sidebar

local visButton = Instance.new("TextButton")
visButton.Name = "VisButton"
visButton.Size = UDim2.new(1, 0, 0, 30)
visButton.Position = UDim2.new(0, 0, 0, 40)
visButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
visButton.TextColor3 = Color3.fromRGB(180, 180, 180)
visButton.Text = "vis"
visButton.TextSize = 12
visButton.Font = Enum.Font.SourceSans
visButton.BorderSizePixel = 0
visButton.Parent = sidebar

local othButton = Instance.new("TextButton")
othButton.Name = "OthButton"
othButton.Size = UDim2.new(1, 0, 0, 30)
othButton.Position = UDim2.new(0, 0, 0, 75)
othButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
othButton.TextColor3 = Color3.fromRGB(180, 180, 180)
othButton.Text = "oth"
othButton.TextSize = 12
othButton.Font = Enum.Font.SourceSans
othButton.BorderSizePixel = 0
othButton.Parent = sidebar

local mainPage = Instance.new("Frame")
mainPage.Name = "MainPage"
mainPage.Size = UDim2.new(1, 0, 1, 0)
mainPage.BackgroundTransparency = 1
mainPage.Parent = content

local visPage = Instance.new("Frame")
visPage.Name = "VisPage"
visPage.Size = UDim2.new(1, 0, 1, 0)
visPage.BackgroundTransparency = 1
visPage.Visible = false
visPage.Parent = content

local othPage = Instance.new("Frame")
othPage.Name = "OthPage"
othPage.Size = UDim2.new(1, 0, 1, 0)
othPage.BackgroundTransparency = 1
othPage.Visible = false
othPage.Parent = content

-- =========================================================
-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
-- =========================================================

mainButton.MouseButton1Click:Connect(function()

    mainPage.Visible = true
    visPage.Visible = false
    othPage.Visible = false

    mainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    visButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    othButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)

end)

visButton.MouseButton1Click:Connect(function()

    mainPage.Visible = false
    visPage.Visible = true
    othPage.Visible = false

    mainButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    visButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    othButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)

end)

othButton.MouseButton1Click:Connect(function()

    mainPage.Visible = false
    visPage.Visible = false
    othPage.Visible = true

    mainButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    visButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    othButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

end)

-- =========================================================
-- ПЕРЕДАЁМ GUI ДРУГИМ СКРИПТАМ
-- =========================================================

G.UI.ScreenGui = screenGui
G.UI.Frame = frame

G.UI.Title = title
G.UI.CloseButton = closeButton
G.UI.MinimizeButton = minimizeButton

G.UI.Sidebar = sidebar
G.UI.Content = content

G.UI.MainButton = mainButton
G.UI.VisButton = visButton
G.UI.OthButton = othButton

G.UI.MainPage = mainPage
G.UI.VisPage = visPage
G.UI.OthPage = othPage

print("[Home] GUI создан")
