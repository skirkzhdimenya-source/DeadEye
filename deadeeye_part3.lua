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
    addUnusualConnection(
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
    addUnusualConnection(
        box.FocusLost:Connect(
            function(enterPressed)
                if enterPressed then
                    if others.applyField(
                        slot,
                        box.Text
                    ) then
                        others.saveConfig()
                    end
                end
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
    addUnusualConnection(
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
    local description =
        others.getDescription()
    if not description then
        return false
    end
    pcall(function()
        description[property] =
            assetId
    end)
    return others.applyDescription(
        description
    )
end
--// =========================================================
--// APPLY ALL OTHERS
--// Applies every current field in one HumanoidDescription call.
--// =========================================================
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
addUnusualConnection(
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
others.resetCorner =
    Instance.new("UICorner")
others.resetCorner.CornerRadius =
    UDim.new(
        0,
        6
    )
others.resetCorner.Parent =
    others.resetButton
addUnusualConnection(
    others.scanButton.MouseButton1Click:Connect(
        function()
            others.scan()
        end
    )
)
addUnusualConnection(
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
addUnusualConnection(
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
        end)
    end
)
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
local function makeCategoryButton(
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
    makeCategoryButton(
        "MAIN",
        6
    )
emoteCategoryButton =
    makeCategoryButton(
        "EMOTES",
        41
    )
unusualCategoryButton =
    makeCategoryButton(
        "UNUSUAL",
        76
    )
othersCategoryButton =
    makeCategoryButton(
        "OTHERS",
        111
    )
--// =========================================================
--// CATEGORY SWITCH
--// =========================================================
local function setCategory(
    category
)
    currentCategory =
        category
    pcall(function()
        if category == "Main" then
            MainTitle.Text =
                "DeadEyes v1"
            Status.Visible = false
            Toggle.Visible = false
            SlotsScroll.Visible = false
            mainPage.Visible = true
            unusualPage.Visible = false
            unusualStatus.Visible = false
            unusualPicker.Visible = false
            others.page.Visible = false
            mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    65,
                    65,
                    65
                )
            emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
        elseif category == "Unusual" then
            MainTitle.Text =
                "DeadEyes v1"
            Status.Visible =
                false
            Toggle.Visible =
                true
            Toggle.Parent =
                unusualPage
            Toggle.LayoutOrder =
                0
            SlotsScroll.Visible =
                false
            mainPage.Visible =
                false
            unusualPage.Visible =
                true
            unusualStatus.Visible =
                false
            unusualPicker.Visible =
                false
            others.page.Visible =
                false
            mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    65,
                    65,
                    65
                )
            othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            updateUnusualToggle()
        elseif category == "Others" then
            MainTitle.Text =
                "DeadEyes v1"
            Status.Visible =
                false
            Toggle.Visible =
                false
            SlotsScroll.Visible =
                false
            unusualPage.Visible =
                false
            unusualStatus.Visible =
                false
            mainPage.Visible =
                false
            unusualPicker.Visible =
                false
            others.page.Visible =
                true
            mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    65,
                    65,
                    65
                )
        else
            MainTitle.Text =
                "DeadEyes v1"
            Status.Visible =
                false
            Toggle.Visible =
                true
            Toggle.Parent =
                SlotsScroll
            Toggle.LayoutOrder =
                0
            SlotsScroll.Visible =
                true
            mainPage.Visible =
                false
            unusualPage.Visible =
                false
            unusualStatus.Visible =
                false
            unusualPicker.Visible =
                false
            others.page.Visible =
                false
            mainCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            unusualCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            othersCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    45,
                    45,
                    45
                )
            emoteCategoryButton.BackgroundColor3 =
                Color3.fromRGB(
                    65,
                    65,
                    65
                )
            updateGUI()
        end
    end)
end
addUnusualConnection(
    mainCategoryButton.MouseButton1Click:Connect(
        function()
            if mainMinimized then
                setMainMinimized(false)
            end
            setCategory(
                "Main"
            )
        end
    )
)
addUnusualConnection(
    emoteCategoryButton.MouseButton1Click:Connect(
        function()
            if mainMinimized then
                setMainMinimized(false)
            end
            setCategory(
                "Emotes"
            )
        end
    )
)
addUnusualConnection(    unusualCategoryButton.MouseButton1Click:Connect(
        function()
            if mainMinimized then
                setMainMinimized(false)
            end
            setCategory(
                "Unusual"
            )
        end
    )
)
addUnusualConnection(
    othersCategoryButton.MouseButton1Click:Connect(
        function()
            if mainMinimized then
                setMainMinimized(false)
            end
            setCategory(
                "Others"
            )
        end
    )
)
--// =========================================================
--// EXTERNAL CLEANUP
--// =========================================================
local function cleanupUnusual()
    if unusualDestroyed then
        return
    end
    unusualDestroyed =
        true
    if unusualActive then
        pcall(function()
            restoreUnusual()
        end)
    end
    pcall(function()
        others.restore(false)
    end)
    unusualEnabled =
        false
    unusualRuntime.reapplyGeneration += 1
    unusualRuntime.appliedRig = nil
    genv.UNUSUAL_SWAPPER_ENABLED =
        false
    disconnectUnusualConnections()
    pcall(function()
        removeOurUnusualFX()
    end)
    genv.DEADEYE_MAIN_RUNNING = false
    pcall(function()
        if mainPage then
            mainPage.Visible = false
        end
        mainDisconnect()
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
    cleanupUnusual
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
    slotReplaceButtons[
        slotIndex
    ] =
        replaceButton
end
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
        30,
        0,
        30
    )
PickerClose.Position =
    UDim2.new(
        1,
        -35,
        0,
        4
    )
PickerClose.BackgroundTransparency =
    1
PickerClose.Text =
    "×"
PickerClose.TextSize =
    25
PickerClose.Font =
    Enum.Font.GothamBold
PickerClose.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )
PickerClose.ZIndex =
    31
PickerClose.Parent =
    Picker
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
    Enum.Font.Gotham
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
        0,
        170,
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
local function createEmotePreview(
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
local function getNativeEmoteWheels()
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

    for i = 1, SLOT_COUNT do
        local slot =
            slots[i]

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
            createEmotePreview(
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

local function restoreNativeEmoteWheel()
    -- Restore every known logical slot. This intentionally does
    -- NOT clear nativeWheelStates, because the next ON must still
    -- know which original belongs to each Wheel/EmoteN position.
    local wheels =
        getNativeEmoteWheels()

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
                nativeWheelStates[
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
end

local function applyNativeEmoteSlot(
    nativeSlot,
    slot
)
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
                createEmotePreview(
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
        getNativeEmoteWheels()

    if #wheels == 0 then
        return
    end

    -- OFF = restore from the persistent logical snapshots.
    if not genv.EMOTE_SWAPPER_RUNNING
        or not enabled
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
                nativeWheelStates[
                    key
                ]

            local configuredSlot =
                nil

            -- Existing logical snapshot tells us exactly which
            -- original belongs to this position.
            if state then
                for slotIndex = 1, SLOT_COUNT do
                    local configured =
                        slots[slotIndex]

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

                    nativeWheelStates[
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
                for slotIndex = 1, SLOT_COUNT do
                    local configured =
                        slots[slotIndex]

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
local function rebuildPicker()
    for _, button in ipairs(
        pickerButtons
    ) do
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

                if currentOriginalId == slot.originalId
                    or (
                        currentOriginalId
                        and not slot.originalId
                    )
                then
                    stopCustomEmote()
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

            createEmotePreview(
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
                    if currentOriginalId
                        == slot.originalId then
                        stopCustomEmote()
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
end
--// =========================================================
--// OPEN PICKER
--// =========================================================
local function openPicker(
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
    rebuildPicker()
    Picker.Visible =
        true
end
--// =========================================================
--// CLOSE PICKER
--// =========================================================
local function closePicker()
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
            openPicker(
                slotIndex,
                "Original"
            )
        end
    )
    slotReplaceButtons[
        slotIndex
    ].MouseButton1Click:Connect(
        function()
            openPicker(
                slotIndex,
                "Replace"
            )
        end
    )
end
--// =========================================================
--// SEARCH
--// =========================================================
addConnection(
    PickerSearch:GetPropertyChangedSignal(
        "Text"
    ):Connect(
        function()
            if Picker.Visible then
                rebuildPicker()
            end
        end
    )
)
PickerClose.MouseButton1Click:Connect(
    function()
        closePicker()
    end
)
--// =========================================================
--// TOGGLE
--// =========================================================
addConnection(
    Toggle.MouseButton1Click:Connect(
        function()
            if currentCategory == "Unusual" then
                if unusualEnabled then
                    unusualEnabled =
                        false
                    genv.UNUSUAL_SWAPPER_ENABLED =
                        false
                    restoreUnusual()
                else
                    if not unusualSlot.originalId
                        or not unusualSlot.replaceId
                    then
                        unusualStatus.Text =
                            "Select both Unusuals first"
                        return
                    end
                    if activateUnusual() then
                        unusualEnabled =
                            true
                        unusualRuntime.appliedRig =
                            getUnusualVisualRig()
                        genv.UNUSUAL_SWAPPER_ENABLED =
                            true
                    end
                end
                updateUnusualToggle()
                return
            end
            --// EXISTING EMOTE TOGGLE
            if enabled then
                enabled = false
                stopCustomEmote()
                restoreNativeEmoteWheel()
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
            lastRegistryEmote =
                0
            syncNativeEmoteWheel()
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
--// WINDOW SIZE LIMITS
--// =========================================================
local MIN_WINDOW_WIDTH = 455
local MIN_WINDOW_HEIGHT = 285
local RESIZE_EDGE = 8

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
            if currentCategory == "Main" then
                Status.Visible = false
                Toggle.Visible = false
                SlotsScroll.Visible = false
                mainPage.Visible = true
                unusualPage.Visible = false
                unusualStatus.Visible = false
                others.page.Visible = false
            elseif currentCategory == "Unusual" then
                Status.Visible = false
                Toggle.Visible = true
                Toggle.Parent =
                    unusualPage
                Toggle.LayoutOrder =
                    0
                SlotsScroll.Visible = false
                mainPage.Visible = false
                unusualPage.Visible = true
                unusualStatus.Visible = false
                others.page.Visible = false
            elseif currentCategory == "Others" then
                Status.Visible = false
                Toggle.Visible = false
                SlotsScroll.Visible = false
                mainPage.Visible = false
                unusualPage.Visible = false
                unusualStatus.Visible = false
                others.page.Visible = true
            else
                mainPage.Visible = false
                unusualPage.Visible = false
                unusualStatus.Visible = false
                others.page.Visible = false
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
addConnection(
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
addConnection(
    RunService.Heartbeat:Connect(
        function()
            if not genv.EMOTE_SWAPPER_RUNNING then
                return
            end
            syncNativeEmoteWheel()
            checkState()
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

local function saveWindowState()
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

local function clampWindowPosition()
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

local function setMainSize(
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

    clampWindowPosition()
end

--// Drag the title bar.
local function beginWindowDrag(input)
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

addConnection(
    DragHandle.InputBegan:Connect(
        function(input)
            beginWindowDrag(input)
        end
    )
)

addConnection(
    MainTitle.InputBegan:Connect(
        function(input)
            beginWindowDrag(input)
        end
    )
)

addConnection(
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

            clampWindowPosition()
        end
    )
)

local function beginResize(
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

addConnection(
    ResizeRight.InputBegan:Connect(
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

addConnection(
    ResizeBottom.InputBegan:Connect(
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

addConnection(
    ResizeCorner.InputBegan:Connect(
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

addConnection(
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

            setMainSize(
                width,
                height
            )
        end
    )
)

addConnection(
    UserInputService.InputEnded:Connect(
        function(input)
            if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                    Enum.UserInputType.Touch
            then
                if dragging then
                    dragging = false
                    saveWindowState()
                end

                if resizing then
                    resizing = false
                    resizeMode = nil
                    saveWindowState()
                end
            end
        end
    )
)

--// CLEANUP
--// =========================================================
local function cleanup()
    if cleaned then
        return
    end

    restoreNativeEmoteWheel()

    --// Stop every active loop before doing any cleanup that may yield.
    cleaned = true
    genv.EMOTE_SWAPPER_RUNNING = false
    genv.DEADEYE_MAIN_RUNNING = false
    genv.DEADEYE_UNUSUAL_POV_RUNNING = false
    genv.DEADEYE_PORTRAIT_RUNNING = false

    enabled = false
    replacementGeneration =
        replacementGeneration + 1
    replacementRunning =
        false

    local activeObject =
        getCharacterObject()

    if activeObject
        and currentCustomEmote
        and activeObject.Emote
            == currentCustomEmote
    then
        pcall(function()
            activeObject.Emote = nil
        end)
    end

    local emoteToStop =
        currentCustomEmote

    currentCustomEmote = nil
    currentOriginalId = nil
    currentReplaceId = nil

    if emoteToStop then
        task.spawn(function()
            stopEmoteObject(
                emoteToStop
            )
        end)
    end

    disconnectAll()

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
        saveWindowState()
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
end
genv.EMOTE_SWAPPER_CLEANUP =
    cleanup
--// =========================================================
--// CLOSE
--// =========================================================
addConnection(
    Close.MouseButton1Click:Connect(
        function()
            cleanup()
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
saveSavedConfig()
setMainMinimized(false)
updateGUI()
pcall(function()
    setCategory("Emotes")
end)
portrait.start()