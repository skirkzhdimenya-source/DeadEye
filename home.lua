local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local hui = gethui()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyWindowGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = hui

local frame = Instance.new("Frame")
frame.Name = "WindowFrame"
frame.Size = UDim2.new(0.2, 0, 0.4, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 18)
title.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
title.TextColor3 = Color3.fromRGB(242, 242, 242)
title.Text = "trajectory"
title.TextSize = 12
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.BorderSizePixel = 0
title.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10)
padding.Parent = title

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

local function setPage(page)
    mainPage.Visible = page == "main"
    visPage.Visible = page == "vis"
    othPage.Visible = page == "oth"

    mainButton.BackgroundColor3 =
        page == "main"
        and Color3.fromRGB(50, 50, 50)
        or Color3.fromRGB(32, 32, 32)

    visButton.BackgroundColor3 =
        page == "vis"
        and Color3.fromRGB(50, 50, 50)
        or Color3.fromRGB(32, 32, 32)

    othButton.BackgroundColor3 =
        page == "oth"
        and Color3.fromRGB(50, 50, 50)
        or Color3.fromRGB(32, 32, 32)
end

mainButton.MouseButton1Click:Connect(function()
    setPage("main")
end)

visButton.MouseButton1Click:Connect(function()
    setPage("vis")
end)

othButton.MouseButton1Click:Connect(function()
    setPage("oth")
end)

local minimized = false

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        sidebar.Visible = false
        content.Visible = false
        frame.Size = UDim2.new(0.2, 0, 0, 18)
        minimizeButton.Text = "+"
    else
        sidebar.Visible = true
        content.Visible = true
        frame.Size = UDim2.new(0.2, 0, 0.4, 0)
        minimizeButton.Text = "_"
    end
end)

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

local function setToggleVisual(button, knob, enabled)
    if not button or not knob then
        return
    end

    if enabled then
        knob.Position =
            UDim2.new(1, -16, 0.5, -7)

        button.BackgroundColor3 =
            Color3.fromRGB(60, 180, 90)
    else
        knob.Position =
            UDim2.new(0, 2, 0.5, -7)

        button.BackgroundColor3 =
            Color3.fromRGB(70, 70, 70)
    end
end

local environment =
    (getgenv and getgenv())
    or _G

environment.DeadEye =
    environment.DeadEye
    or {}

local DeadEye = environment.DeadEye

DeadEye.BaseUrl =
    DeadEye.BaseUrl
    or "https://raw.githubusercontent.com/skirkzhdimenya-source/DeadEye/main/"

local function normalizeUrl(url)
    if url:sub(-1) ~= "/" then
        return url .. "/"
    end

    return url
end

local BASE_URL =
    normalizeUrl(
        DeadEye.BaseUrl
    )

local function getSource(url)
    local response = request({
        Url = url,
        Method = "GET"
    })

    if not response.Success then
        error(
            "HTTP "
                .. tostring(response.StatusCode)
                .. ": "
                .. url
        )
    end

    return response.Body
end

local function loadModule(name)
    local source =
        getSource(
            BASE_URL
                .. name
                .. ".lua"
        )

    local chunk, err =
        loadstring(
            source,
            "=" .. name .. ".lua"
        )

    if not chunk then
        error(
            "Compile error in "
                .. name
                .. ".lua: "
                .. tostring(err)
        )
    end

    local module = chunk()

    if type(module) ~= "table" then
        error(
            name
                .. ".lua must return a table"
        )
    end

    return module
end

local Main = loadModule("main")
local Vis = loadModule("vis")
local Oth = loadModule("oth")

Main.mount({
    mainPage = mainPage,
    createToggle = createToggle,
    setToggleVisual = setToggleVisual
})

Vis.mount({
    visPage = visPage,
    createToggle = createToggle,
    setToggleVisual = setToggleVisual
})

if Oth.mount then
    Oth.mount({
        othPage = othPage,
        createToggle = createToggle,
        setToggleVisual = setToggleVisual
    })
end

local renderConnection =
    RunService.RenderStepped:Connect(function()
        if Vis.render then
            Vis.render()
        end
    end)

local inputConnection =
    UserInputService.InputBegan:Connect(
        function(input)
            if input.UserInputType
                ~= Enum.UserInputType.Keyboard
            then
                return
            end

            if Main.assignHotkey
                and Main.assignHotkey(input.KeyCode)
            then
                return
            end

            if Vis.assignHotkey
                and Vis.assignHotkey(input.KeyCode)
            then
                return
            end

            if Main.handleKey
                and Main.handleKey(input.KeyCode)
            then
                return
            end

            if Vis.handleKey
                and Vis.handleKey(input.KeyCode)
            then
                return
            end
        end
    )

local drag = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType
        == Enum.UserInputType.MouseButton1
    then
        drag = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType
        == Enum.UserInputType.MouseButton1
    then
        drag = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if drag
        and input.UserInputType
        == Enum.UserInputType.MouseMovement
    then
        local delta =
            input.Position - dragStart

        frame.Position =
            UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,

                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
    end
end)

closeButton.MouseButton1Click:Connect(function()
    if Main.destroy then
        Main.destroy()
    end

    if Vis.destroy then
        Vis.destroy()
    end

    if Oth.destroy then
        Oth.destroy()
    end

    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end

    if inputConnection then
        inputConnection:Disconnect()
        inputConnection = nil
    end

    screenGui:Destroy()
end)
