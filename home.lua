local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

mainButton.MouseButton1Click:Connect(function()
    mainPage.Visible = true
    visPage.Visible = false
    othPage.Visible = false
    mainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    visButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
end)

visButton.MouseButton1Click:Connect(function()
    mainPage.Visible = false
    visPage.Visible = true
    othPage.Visible = false
    mainButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    visButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

othButton.MouseButton1Click:Connect(function()
    mainPage.Visible = false
    visPage.Visible = false
    othPage.Visible = true
    mainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    othButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
end)

local minimized = false

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        -- Скрываем содержимое
        sidebar.Visible = false
        content.Visible = false

        -- Уменьшаем окно до высоты заголовка
        frame.Size = UDim2.new(0.2, 0, 0, 18)

        -- Можно поменять символ кнопки
        minimizeButton.Text = "+"
    else
        -- Возвращаем содержимое
        sidebar.Visible = true
        content.Visible = true

        -- Возвращаем исходный размер
        frame.Size = UDim2.new(0.2, 0, 0.4, 0)

        minimizeButton.Text = "_"
    end
end)

-- =========================================================
-- ВСПОМОГАТЕЛЬНОЕ СОЗДАНИЕ TOGGLE
-- =========================================================

local function createToggle(parent, y)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 40, 0, 18)
    button.Position = UDim2.new(1, -50, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    knob.BorderSizePixel = 0
    knob.Parent = button

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    return button, knob
end

setToggleVisual = function(button, knob, enabled)
    if enabled then
        knob.Position = UDim2.new(1, -16, 0.5, -7)
        button.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
    else
        knob.Position = UDim2.new(0, 2, 0.5, -7)
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end
local Main = require(script.Parent.main)
local Vis = require(script.Parent.vis)

Main.mount({ mainPage = mainPage, createToggle = createToggle, setToggleVisual = setToggleVisual })
Vis.mount({ visPage = visPage, createToggle = createToggle, setToggleVisual = setToggleVisual })

local renderConnection = RunService.RenderStepped:Connect(function()
    Vis.render()
end)

local inputConnection = UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if Main.assignHotkey(input.KeyCode) or Vis.assignHotkey(input.KeyCode) then return end
    if Main.handleKey(input.KeyCode) or Vis.handleKey(input.KeyCode) then return end
end)

local drag, dragStart, startPos = false, nil, nil
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag, dragStart, startPos = true, input.Position, frame.Position
    end
end)
title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    Main.destroy()
    Vis.destroy()
    if renderConnection then renderConnection:Disconnect() end
    if inputConnection then inputConnection:Disconnect() end
    screenGui:Destroy()
end)
