local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Utility Functions
local function Tween(instance, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos

    dragHandle = dragHandle or frame

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.1)
        end
    end)
end

-- Main Library Functions
function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Tokyo UI Library"
    local theme = config.Theme or "Dark"
    local accentColor = config.AccentColor or Color3.fromRGB(138, 43, 226)
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TokyoUI_" .. math.random(1000, 9999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(20, 20, 25) or Color3.fromRGB(240, 240, 245)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.Size = UDim2.new(1, 40, 1, 40)
    DropShadow.Position = UDim2.new(0, -20, 0, -20)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ZIndex = 0
    DropShadow.Parent = MainFrame

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = accentColor
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar

    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 12)
    TopBarCover.Position = UDim2.new(0, 0, 1, -12)
    TopBarCover.BackgroundColor3 = accentColor
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowTitle
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        ScreenGui:Destroy()
    end)

    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -75, 0.5, -15)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Parent = TopBar

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeButton

    local minimized = false
    local originalSize = MainFrame.Size
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 40)}, 0.3)
        else
            Tween(MainFrame, {Size = originalSize}, 0.3)
        end
    end)

    MakeDraggable(MainFrame, TopBar)

    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -50)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(230, 230, 235)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer

    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabContainer

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -175, 1, -50)
    ContentContainer.Position = UDim2.new(0, 165, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = MainFrame

    local WindowAPI = {}
    WindowAPI.CurrentTab = nil
    WindowAPI.Tabs = {}

    function WindowAPI:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(25, 25, 30) or Color3.fromRGB(220, 220, 225)
        TabButton.Text = tabName
        TabButton.TextColor3 = theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(50, 50, 50)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer

        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = accentColor
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = ContentContainer

        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 10)
        ContentList.Parent = TabContent

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 5)
        ContentPadding.Parent = TabContent

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(WindowAPI.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = theme == "Dark" and Color3.fromRGB(25, 25, 30) or Color3.fromRGB(220, 220, 225)}, 0.2)
            end

            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = accentColor}, 0.2)
            WindowAPI.CurrentTab = tabName
        end)

        if not WindowAPI.CurrentTab then
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = accentColor}, 0.2)
            WindowAPI.CurrentTab = tabName
        end

        local TabAPI = {}
        TabAPI.Button = TabButton
        TabAPI.Content = TabContent
        WindowAPI.Tabs[tabName] = TabAPI

        -- Tab Functions
        function TabAPI:AddButton(config)
            config = config or {}
            local buttonText = config.Text or "Button"
            local callback = config.Callback or function() end

            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(1, -10, 0, 40)
            ButtonFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame

            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -20, 1, -10)
            Button.Position = UDim2.new(0, 10, 0, 5)
            Button.BackgroundTransparency = 1
            Button.Text = buttonText
            Button.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            Button.TextSize = 14
            Button.Font = Enum.Font.Gotham
            Button.Parent = ButtonFrame

            Button.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = accentColor}, 0.1)
                wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)}, 0.1)
                callback()
            end)

            return Button
        end

        function TabAPI:AddToggle(config)
            config = config or {}
            local toggleText = config.Text or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
            ToggleFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.BackgroundColor3 = default and accentColor or Color3.fromRGB(60, 60, 65)
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame

            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ToggleIndicator.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator

            local toggled = default

            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                Tween(ToggleButton, {BackgroundColor3 = toggled and accentColor or Color3.fromRGB(60, 60, 65)}, 0.2)
                Tween(ToggleIndicator, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                callback(toggled)
            end)

            local ToggleAPI = {}
            function ToggleAPI:SetValue(value)
                toggled = value
                Tween(ToggleButton, {BackgroundColor3 = toggled and accentColor or Color3.fromRGB(60, 60, 65)}, 0.2)
                Tween(ToggleIndicator, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                callback(toggled)
            end

            return ToggleAPI
        end

        function TabAPI:AddSlider(config)
            config = config or {}
            local sliderText = config.Text or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or 50
            local increment = config.Increment or 1
            local callback = config.Callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -10, 0, 60)
            SliderFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame

            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderText
            SliderLabel.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame

            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -60, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = accentColor
            SliderValue.TextSize = 14
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 6)
            SliderBar.Position = UDim2.new(0, 10, 1, -15)
            SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame

            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = accentColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar

            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill

            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar

            local dragging = false

            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            SliderButton.MouseButton1Click:Connect(function()
                local mousePos = UserInputService:GetMouseLocation().X
                local barPos = SliderBar.AbsolutePosition.X
                local barSize = SliderBar.AbsoluteSize.X
                local value = math.clamp((mousePos - barPos) / barSize, 0, 1)
                value = math.floor((min + (max - min) * value) / increment + 0.5) * increment
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new((value - min) / (max - min), 0, 1, 0)}, 0.1)
                callback(value)
            end)

            RunService.RenderStepped:Connect(function()
                if dragging then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local barPos = SliderBar.AbsolutePosition.X
                    local barSize = SliderBar.AbsoluteSize.X
                    local value = math.clamp((mousePos - barPos) / barSize, 0, 1)
                    value = math.floor((min + (max - min) * value) / increment + 0.5) * increment
                    SliderValue.Text = tostring(value)
                    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    callback(value)
                end
            end)

            local SliderAPI = {}
            function SliderAPI:SetValue(value)
                value = math.clamp(value, min, max)
                value = math.floor(value / increment + 0.5) * increment
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new((value - min) / (max - min), 0, 1, 0)}, 0.2)
                callback(value)
            end

            return SliderAPI
        end

        function TabAPI:AddDropdown(config)
            config = config or {}
            local dropdownText = config.Text or "Dropdown"
            local options = config.Options or {"Option 1", "Option 2", "Option 3"}
            local default = config.Default or options[1]
            local callback = config.Callback or function() end

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
            DropdownFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, -20, 0, 30)
            DropdownButton.Position = UDim2.new(0, 10, 0, 5)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = dropdownText .. ": " .. default
            DropdownButton.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            DropdownButton.TextSize = 14
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
            DropdownButton.Parent = DropdownFrame

            local DropdownIcon = Instance.new("TextLabel")
            DropdownIcon.Size = UDim2.new(0, 20, 0, 20)
            DropdownIcon.Position = UDim2.new(1, -25, 0, 10)
            DropdownIcon.BackgroundTransparency = 1
            DropdownIcon.Text = "▼"
            DropdownIcon.TextColor3 = accentColor
            DropdownIcon.TextSize = 12
            DropdownIcon.Font = Enum.Font.Gotham
            DropdownIcon.Parent = DropdownFrame

            local OptionsContainer = Instance.new("Frame")
            OptionsContainer.Size = UDim2.new(1, -20, 0, 0)
            OptionsContainer.Position = UDim2.new(0, 10, 0, 40)
            OptionsContainer.BackgroundTransparency = 1
            OptionsContainer.Parent = DropdownFrame

            local OptionsList = Instance.new("UIListLayout")
            OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsList.Padding = UDim.new(0, 2)
            OptionsList.Parent = OptionsContainer

            local opened = false
            local selectedOption = default

            DropdownButton.MouseButton1Click:Connect(function()
                opened = not opened
                if opened then
                    Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40 + (#options * 32))}, 0.3)
                    Tween(DropdownIcon, {Rotation = 180}, 0.3)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40)}, 0.3)
                    Tween(DropdownIcon, {Rotation = 0}, 0.3)
                end
            end)

            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = option == selectedOption and accentColor or (theme == "Dark" and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(225, 225, 230))
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionButton.TextSize = 13
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.BorderSizePixel = 0
                OptionButton.Parent = OptionsContainer

                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionButton

                OptionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    DropdownButton.Text = dropdownText .. ": " .. option
                    callback(option)

                    for _, child in ipairs(OptionsContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            Tween(child, {BackgroundColor3 = theme == "Dark" and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(225, 225, 230)}, 0.2)
                        end
                    end

                    Tween(OptionButton, {BackgroundColor3 = accentColor}, 0.2)
                    opened = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40)}, 0.3)
                    Tween(DropdownIcon, {Rotation = 0}, 0.3)
                end)
            end

            local DropdownAPI = {}
            function DropdownAPI:SetValue(value)
                if table.find(options, value) then
                    selectedOption = value
                    DropdownButton.Text = dropdownText .. ": " .. value
                    callback(value)

                    for _, child in ipairs(OptionsContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            if child.Text == value then
                                Tween(child, {BackgroundColor3 = accentColor}, 0.2)
                            else
                                Tween(child, {BackgroundColor3 = theme == "Dark" and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(225, 225, 230)}, 0.2)
                            end
                        end
                    end
                end
            end

            return DropdownAPI
        end

        function TabAPI:AddTextbox(config)
            config = config or {}
            local textboxText = config.Text or "Textbox"
            local placeholder = config.Placeholder or "Enter text..."
            local default = config.Default or ""
            local callback = config.Callback or function() end

            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Size = UDim2.new(1, -10, 0, 65)
            TextboxFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent

            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Parent = TextboxFrame

            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -20, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = textboxText
            TextboxLabel.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame

            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(1, -20, 0, 30)
            Textbox.Position = UDim2.new(0, 10, 0, 30)
            Textbox.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(225, 225, 230)
            Textbox.Text = default
            Textbox.PlaceholderText = placeholder
            Textbox.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            Textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            Textbox.TextSize = 13
            Textbox.Font = Enum.Font.Gotham
            Textbox.BorderSizePixel = 0
            Textbox.ClearTextOnFocus = false
            Textbox.Parent = TextboxFrame

            local TextboxBoxCorner = Instance.new("UICorner")
            TextboxBoxCorner.CornerRadius = UDim.new(0, 6)
            TextboxBoxCorner.Parent = Textbox

            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(Textbox.Text)
                end
            end)

            local TextboxAPI = {}
            function TextboxAPI:SetValue(value)
                Textbox.Text = value
                callback(value)
            end

            return TextboxAPI
        end

        function TabAPI:AddLabel(config)
            config = config or {}
            local labelText = config.Text or "Label"

            local LabelFrame = Instance.new("Frame")
            LabelFrame.Size = UDim2.new(1, -10, 0, 30)
            LabelFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent

            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = LabelFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = labelText
            Label.TextColor3 = theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(80, 80, 80)
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = LabelFrame

            local LabelAPI = {}
            function LabelAPI:SetText(text)
                Label.Text = text
            end

            return LabelAPI
        end

        function TabAPI:AddColorPicker(config)
            config = config or {}
            local pickerText = config.Text or "Color Picker"
            local default = config.Default or Color3.fromRGB(255, 255, 255)
            local callback = config.Callback or function() end

            local PickerFrame = Instance.new("Frame")
            PickerFrame.Size = UDim2.new(1, -10, 0, 40)
            PickerFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            PickerFrame.BorderSizePixel = 0
            PickerFrame.Parent = TabContent

            local PickerCorner = Instance.new("UICorner")
            PickerCorner.CornerRadius = UDim.new(0, 8)
            PickerCorner.Parent = PickerFrame

            local PickerLabel = Instance.new("TextLabel")
            PickerLabel.Size = UDim2.new(1, -60, 1, 0)
            PickerLabel.Position = UDim2.new(0, 10, 0, 0)
            PickerLabel.BackgroundTransparency = 1
            PickerLabel.Text = pickerText
            PickerLabel.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            PickerLabel.TextSize = 14
            PickerLabel.Font = Enum.Font.Gotham
            PickerLabel.TextXAlignment = Enum.TextXAlignment.Left
            PickerLabel.Parent = PickerFrame

            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Size = UDim2.new(0, 30, 0, 30)
            ColorDisplay.Position = UDim2.new(1, -40, 0.5, -15)
            ColorDisplay.BackgroundColor3 = default
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = PickerFrame

            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 8)
            ColorCorner.Parent = ColorDisplay

            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(1, 0, 1, 0)
            ColorButton.BackgroundTransparency = 1
            ColorButton.Text = ""
            ColorButton.Parent = ColorDisplay

            local selectedColor = default

            -- Simple color picker popup
            ColorButton.MouseButton1Click:Connect(function()
                local ColorPopup = Instance.new("Frame")
                ColorPopup.Size = UDim2.new(0, 200, 0, 180)
                ColorPopup.Position = UDim2.new(0.5, -100, 0.5, -90)
                ColorPopup.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(25, 25, 30) or Color3.fromRGB(240, 240, 245)
                ColorPopup.BorderSizePixel = 0
                ColorPopup.ZIndex = 100
                ColorPopup.Parent = ScreenGui

                local PopupCorner = Instance.new("UICorner")
                PopupCorner.CornerRadius = UDim.new(0, 12)
                PopupCorner.Parent = ColorPopup

                local PopupTitle = Instance.new("TextLabel")
                PopupTitle.Size = UDim2.new(1, 0, 0, 30)
                PopupTitle.BackgroundTransparency = 1
                PopupTitle.Text = "Pick a Color"
                PopupTitle.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
                PopupTitle.TextSize = 16
                PopupTitle.Font = Enum.Font.GothamBold
                PopupTitle.Parent = ColorPopup

                -- RGB Sliders
                local function CreateRGBSlider(name, position, defaultValue)
                    local SliderFrame = Instance.new("Frame")
                    SliderFrame.Size = UDim2.new(1, -20, 0, 30)
                    SliderFrame.Position = UDim2.new(0, 10, 0, position)
                    SliderFrame.BackgroundTransparency = 1
                    SliderFrame.Parent = ColorPopup

                    local SliderLabel = Instance.new("TextLabel")
                    SliderLabel.Size = UDim2.new(0, 20, 1, 0)
                    SliderLabel.BackgroundTransparency = 1
                    SliderLabel.Text = name
                    SliderLabel.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
                    SliderLabel.TextSize = 14
                    SliderLabel.Font = Enum.Font.GothamBold
                    SliderLabel.Parent = SliderFrame

                    local SliderBar = Instance.new("Frame")
                    SliderBar.Size = UDim2.new(1, -70, 0, 6)
                    SliderBar.Position = UDim2.new(0, 30, 0.5, -3)
                    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
                    SliderBar.BorderSizePixel = 0
                    SliderBar.Parent = SliderFrame

                    local SliderBarCorner = Instance.new("UICorner")
                    SliderBarCorner.CornerRadius = UDim.new(1, 0)
                    SliderBarCorner.Parent = SliderBar

                    local SliderFill = Instance.new("Frame")
                    SliderFill.Size = UDim2.new(defaultValue / 255, 0, 1, 0)
                    SliderFill.BackgroundColor3 = name == "R" and Color3.fromRGB(255, 0, 0) or name == "G" and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 255)
                    SliderFill.BorderSizePixel = 0
                    SliderFill.Parent = SliderBar

                    local SliderFillCorner = Instance.new("UICorner")
                    SliderFillCorner.CornerRadius = UDim.new(1, 0)
                    SliderFillCorner.Parent = SliderFill

                    local ValueLabel = Instance.new("TextLabel")
                    ValueLabel.Size = UDim2.new(0, 35, 1, 0)
                    ValueLabel.Position = UDim2.new(1, -40, 0, 0)
                    ValueLabel.BackgroundTransparency = 1
                    ValueLabel.Text = tostring(math.floor(defaultValue))
                    ValueLabel.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
                    ValueLabel.TextSize = 13
                    ValueLabel.Font = Enum.Font.Gotham
                    ValueLabel.Parent = SliderFrame

                    local SliderButton = Instance.new("TextButton")
                    SliderButton.Size = UDim2.new(1, 0, 1, 0)
                    SliderButton.BackgroundTransparency = 1
                    SliderButton.Text = ""
                    SliderButton.Parent = SliderBar

                    local dragging = false

                    SliderButton.MouseButton1Down:Connect(function()
                        dragging = true
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)

                    local function updateSlider()
                        local mousePos = UserInputService:GetMouseLocation().X
                        local barPos = SliderBar.AbsolutePosition.X
                        local barSize = SliderBar.AbsoluteSize.X
                        local value = math.clamp((mousePos - barPos) / barSize, 0, 1)
                        value = math.floor(value * 255)
                        ValueLabel.Text = tostring(value)
                        SliderFill.Size = UDim2.new(value / 255, 0, 1, 0)
                        return value
                    end

                    SliderButton.MouseButton1Click:Connect(updateSlider)

                    RunService.RenderStepped:Connect(function()
                        if dragging then
                            updateSlider()
                        end
                    end)

                    return {
                        GetValue = function()
                            return tonumber(ValueLabel.Text) or 0
                        end,
                        Update = updateSlider
                    }
                end

                local RSlider = CreateRGBSlider("R", 40, selectedColor.R * 255)
                local GSlider = CreateRGBSlider("G", 75, selectedColor.G * 255)
                local BSlider = CreateRGBSlider("B", 110, selectedColor.B * 255)

                local ConfirmButton = Instance.new("TextButton")
                ConfirmButton.Size = UDim2.new(0, 80, 0, 25)
                ConfirmButton.Position = UDim2.new(0.5, -40, 1, -35)
                ConfirmButton.BackgroundColor3 = accentColor
                ConfirmButton.Text = "Confirm"
                ConfirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ConfirmButton.TextSize = 13
                ConfirmButton.Font = Enum.Font.GothamBold
                ConfirmButton.BorderSizePixel = 0
                ConfirmButton.Parent = ColorPopup

                local ConfirmCorner = Instance.new("UICorner")
                ConfirmCorner.CornerRadius = UDim.new(0, 8)
                ConfirmCorner.Parent = ConfirmButton

                ConfirmButton.MouseButton1Click:Connect(function()
                    local r = RSlider.GetValue() / 255
                    local g = GSlider.GetValue() / 255
                    local b = BSlider.GetValue() / 255
                    selectedColor = Color3.new(r, g, b)
                    ColorDisplay.BackgroundColor3 = selectedColor
                    callback(selectedColor)
                    ColorPopup:Destroy()
                end)
            end)

            local PickerAPI = {}
            function PickerAPI:SetValue(color)
                selectedColor = color
                ColorDisplay.BackgroundColor3 = color
                callback(color)
            end

            return PickerAPI
        end

        function TabAPI:AddKeybind(config)
            config = config or {}
            local keybindText = config.Text or "Keybind"
            local default = config.Default or Enum.KeyCode.E
            local callback = config.Callback or function() end

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, -10, 0, 40)
            KeybindFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContent

            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 8)
            KeybindCorner.Parent = KeybindFrame

            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = keybindText
            KeybindLabel.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            KeybindLabel.TextSize = 14
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame

            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 60, 0, 25)
            KeybindButton.Position = UDim2.new(1, -70, 0.5, -12.5)
            KeybindButton.BackgroundColor3 = accentColor
            KeybindButton.Text = default.Name
            KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindButton.TextSize = 12
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Parent = KeybindFrame

            local KeybindButtonCorner = Instance.new("UICorner")
            KeybindButtonCorner.CornerRadius = UDim.new(0, 6)
            KeybindButtonCorner.Parent = KeybindButton

            local selectedKey = default
            local listening = false

            KeybindButton.MouseButton1Click:Connect(function()
                listening = true
                KeybindButton.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        selectedKey = input.KeyCode
                        KeybindButton.Text = input.KeyCode.Name
                        listening = false
                    end
                end

                if not gameProcessed and input.KeyCode == selectedKey then
                    callback()
                end
            end)

            local KeybindAPI = {}
            function KeybindAPI:SetValue(keycode)
                selectedKey = keycode
                KeybindButton.Text = keycode.Name
            end

            return KeybindAPI
        end

        function TabAPI:AddParagraph(config)
            config = config or {}
            local title = config.Title or "Paragraph"
            local content = config.Content or "This is a paragraph."

            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Size = UDim2.new(1, -10, 0, 0)
            ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
            ParagraphFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            ParagraphFrame.BorderSizePixel = 0
            ParagraphFrame.Parent = TabContent

            local ParagraphCorner = Instance.new("UICorner")
            ParagraphCorner.CornerRadius = UDim.new(0, 8)
            ParagraphCorner.Parent = ParagraphFrame

            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Size = UDim2.new(1, -20, 0, 0)
            ParagraphTitle.AutomaticSize = Enum.AutomaticSize.Y
            ParagraphTitle.Position = UDim2.new(0, 10, 0, 10)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Text = title
            ParagraphTitle.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            ParagraphTitle.TextSize = 15
            ParagraphTitle.Font = Enum.Font.GothamBold
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.TextWrapped = true
            ParagraphTitle.Parent = ParagraphFrame

            local ParagraphContent = Instance.new("TextLabel")
            ParagraphContent.Size = UDim2.new(1, -20, 0, 0)
            ParagraphContent.AutomaticSize = Enum.AutomaticSize.Y
            ParagraphContent.Position = UDim2.new(0, 10, 0, 35)
            ParagraphContent.BackgroundTransparency = 1
            ParagraphContent.Text = content
            ParagraphContent.TextColor3 = theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(80, 80, 80)
            ParagraphContent.TextSize = 13
            ParagraphContent.Font = Enum.Font.Gotham
            ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphContent.TextWrapped = true
            ParagraphContent.Parent = ParagraphFrame

            local ParagraphPadding = Instance.new("UIPadding")
            ParagraphPadding.PaddingBottom = UDim.new(0, 10)
            ParagraphPadding.Parent = ParagraphFrame

            local ParagraphAPI = {}
            function ParagraphAPI:SetTitle(text)
                ParagraphTitle.Text = text
            end

            function ParagraphAPI:SetContent(text)
                ParagraphContent.Text = text
            end

            return ParagraphAPI
        end

        function TabAPI:AddDivider(config)
            config = config or {}
            local text = config.Text or nil

            local DividerFrame = Instance.new("Frame")
            DividerFrame.Size = UDim2.new(1, -10, 0, text and 25 or 10)
            DividerFrame.BackgroundTransparency = 1
            DividerFrame.Parent = TabContent

            if text then
                local DividerLabel = Instance.new("TextLabel")
                DividerLabel.Size = UDim2.new(1, 0, 1, 0)
                DividerLabel.BackgroundTransparency = 1
                DividerLabel.Text = text
                DividerLabel.TextColor3 = theme == "Dark" and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(100, 100, 100)
                DividerLabel.TextSize = 13
                DividerLabel.Font = Enum.Font.GothamBold
                DividerLabel.Parent = DividerFrame
            else
                local Line = Instance.new("Frame")
                Line.Size = UDim2.new(1, 0, 0, 2)
                Line.Position = UDim2.new(0, 0, 0.5, -1)
                Line.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(50, 50, 55) or Color3.fromRGB(200, 200, 205)
                Line.BorderSizePixel = 0
                Line.Parent = DividerFrame
            end
        end

        function TabAPI:AddCheckbox(config)
            config = config or {}
            local checkboxText = config.Text or "Checkbox"
            local default = config.Default or false
            local callback = config.Callback or function() end

            local CheckboxFrame = Instance.new("Frame")
            CheckboxFrame.Size = UDim2.new(1, -10, 0, 40)
            CheckboxFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            CheckboxFrame.BorderSizePixel = 0
            CheckboxFrame.Parent = TabContent

            local CheckboxCorner = Instance.new("UICorner")
            CheckboxCorner.CornerRadius = UDim.new(0, 8)
            CheckboxCorner.Parent = CheckboxFrame

            local CheckboxLabel = Instance.new("TextLabel")
            CheckboxLabel.Size = UDim2.new(1, -60, 1, 0)
            CheckboxLabel.Position = UDim2.new(0, 10, 0, 0)
            CheckboxLabel.BackgroundTransparency = 1
            CheckboxLabel.Text = checkboxText
            CheckboxLabel.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            CheckboxLabel.TextSize = 14
            CheckboxLabel.Font = Enum.Font.Gotham
            CheckboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            CheckboxLabel.Parent = CheckboxFrame

            local CheckboxButton = Instance.new("TextButton")
            CheckboxButton.Size = UDim2.new(0, 24, 0, 24)
            CheckboxButton.Position = UDim2.new(1, -34, 0.5, -12)
            CheckboxButton.BackgroundColor3 = default and accentColor or Color3.fromRGB(60, 60, 65)
            CheckboxButton.Text = ""
            CheckboxButton.BorderSizePixel = 0
            CheckboxButton.Parent = CheckboxFrame

            local CheckboxButtonCorner = Instance.new("UICorner")
            CheckboxButtonCorner.CornerRadius = UDim.new(0, 6)
            CheckboxButtonCorner.Parent = CheckboxButton

            local Checkmark = Instance.new("TextLabel")
            Checkmark.Size = UDim2.new(1, 0, 1, 0)
            Checkmark.BackgroundTransparency = 1
            Checkmark.Text = "✓"
            Checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
            Checkmark.TextSize = 18
            Checkmark.Font = Enum.Font.GothamBold
            Checkmark.Visible = default
            Checkmark.Parent = CheckboxButton

            local checked = default

            CheckboxButton.MouseButton1Click:Connect(function()
                checked = not checked
                Tween(CheckboxButton, {BackgroundColor3 = checked and accentColor or Color3.fromRGB(60, 60, 65)}, 0.2)
                Checkmark.Visible = checked
                callback(checked)
            end)

            local CheckboxAPI = {}
            function CheckboxAPI:SetValue(value)
                checked = value
                Tween(CheckboxButton, {BackgroundColor3 = checked and accentColor or Color3.fromRGB(60, 60, 65)}, 0.2)
                Checkmark.Visible = checked
                callback(checked)
            end

            return CheckboxAPI
        end

        function TabAPI:AddImage(config)
            config = config or {}
            local imageId = config.ImageId or "rbxassetid://0"
            local imageSize = config.Size or UDim2.new(1, -10, 0, 150)

            local ImageFrame = Instance.new("Frame")
            ImageFrame.Size = imageSize
            ImageFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            ImageFrame.BorderSizePixel = 0
            ImageFrame.Parent = TabContent

            local ImageCorner = Instance.new("UICorner")
            ImageCorner.CornerRadius = UDim.new(0, 8)
            ImageCorner.Parent = ImageFrame

            local Image = Instance.new("ImageLabel")
            Image.Size = UDim2.new(1, -10, 1, -10)
            Image.Position = UDim2.new(0, 5, 0, 5)
            Image.BackgroundTransparency = 1
            Image.Image = imageId
            Image.ScaleType = Enum.ScaleType.Fit
            Image.Parent = ImageFrame

            local ImageAPI = {}
            function ImageAPI:SetImage(id)
                Image.Image = id
            end

            return ImageAPI
        end

        function TabAPI:AddProgressBar(config)
            config = config or {}
            local progressText = config.Text or "Progress"
            local maxValue = config.Max or 100
            local defaultValue = config.Default or 0

            local ProgressFrame = Instance.new("Frame")
            ProgressFrame.Size = UDim2.new(1, -10, 0, 50)
            ProgressFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(235, 235, 240)
            ProgressFrame.BorderSizePixel = 0
            ProgressFrame.Parent = TabContent

            local ProgressCorner = Instance.new("UICorner")
            ProgressCorner.CornerRadius = UDim.new(0, 8)
            ProgressCorner.Parent = ProgressFrame

            local ProgressLabel = Instance.new("TextLabel")
            ProgressLabel.Size = UDim2.new(1, -80, 0, 20)
            ProgressLabel.Position = UDim2.new(0, 10, 0, 5)
            ProgressLabel.BackgroundTransparency = 1
            ProgressLabel.Text = progressText
            ProgressLabel.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            ProgressLabel.TextSize = 14
            ProgressLabel.Font = Enum.Font.Gotham
            ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
            ProgressLabel.Parent = ProgressFrame

            local ProgressValue = Instance.new("TextLabel")
            ProgressValue.Size = UDim2.new(0, 70, 0, 20)
            ProgressValue.Position = UDim2.new(1, -75, 0, 5)
            ProgressValue.BackgroundTransparency = 1
            ProgressValue.Text = defaultValue .. "/" .. maxValue
            ProgressValue.TextColor3 = accentColor
            ProgressValue.TextSize = 13
            ProgressValue.Font = Enum.Font.GothamBold
            ProgressValue.TextXAlignment = Enum.TextXAlignment.Right
            ProgressValue.Parent = ProgressFrame

            local ProgressBar = Instance.new("Frame")
            ProgressBar.Size = UDim2.new(1, -20, 0, 8)
            ProgressBar.Position = UDim2.new(0, 10, 1, -15)
            ProgressBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            ProgressBar.BorderSizePixel = 0
            ProgressBar.Parent = ProgressFrame

            local ProgressBarCorner = Instance.new("UICorner")
            ProgressBarCorner.CornerRadius = UDim.new(1, 0)
            ProgressBarCorner.Parent = ProgressBar

            local ProgressFill = Instance.new("Frame")
            ProgressFill.Size = UDim2.new(defaultValue / maxValue, 0, 1, 0)
            ProgressFill.BackgroundColor3 = accentColor
            ProgressFill.BorderSizePixel = 0
            ProgressFill.Parent = ProgressBar

            local ProgressFillCorner = Instance.new("UICorner")
            ProgressFillCorner.CornerRadius = UDim.new(1, 0)
            ProgressFillCorner.Parent = ProgressFill

            local ProgressAPI = {}
            function ProgressAPI:SetValue(value)
                value = math.clamp(value, 0, maxValue)
                ProgressValue.Text = value .. "/" .. maxValue
                Tween(ProgressFill, {Size = UDim2.new(value / maxValue, 0, 1, 0)}, 0.3)
            end

            return ProgressAPI
        end

        return TabAPI
    end

    function WindowAPI:Notify(config)
        config = config or {}
        local title = config.Title or "Notification"
        local content = config.Content or "This is a notification"
        local duration = config.Duration or 3

        local NotificationFrame = Instance.new("Frame")
        NotificationFrame.Size = UDim2.new(0, 300, 0, 0)
        NotificationFrame.Position = UDim2.new(1, -310, 1, 10)
        NotificationFrame.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(25, 25, 30) or Color3.fromRGB(240, 240, 245)
        NotificationFrame.BorderSizePixel = 0
        NotificationFrame.Parent = ScreenGui

        local NotificationCorner = Instance.new("UICorner")
        NotificationCorner.CornerRadius = UDim.new(0, 10)
        NotificationCorner.Parent = NotificationFrame

        local NotificationTitle = Instance.new("TextLabel")
        NotificationTitle.Size = UDim2.new(1, -20, 0, 25)
        NotificationTitle.Position = UDim2.new(0, 10, 0, 10)
        NotificationTitle.BackgroundTransparency = 1
        NotificationTitle.Text = title
        NotificationTitle.TextColor3 = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        NotificationTitle.TextSize = 15
        NotificationTitle.Font = Enum.Font.GothamBold
        NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotificationTitle.Parent = NotificationFrame

        local NotificationContent = Instance.new("TextLabel")
        NotificationContent.Size = UDim2.new(1, -20, 0, 0)
        NotificationContent.AutomaticSize = Enum.AutomaticSize.Y
        NotificationContent.Position = UDim2.new(0, 10, 0, 35)
        NotificationContent.BackgroundTransparency = 1
        NotificationContent.Text = content
        NotificationContent.TextColor3 = theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(80, 80, 80)
        NotificationContent.TextSize = 13
        NotificationContent.Font = Enum.Font.Gotham
        NotificationContent.TextXAlignment = Enum.TextXAlignment.Left
        NotificationContent.TextWrapped = true
        NotificationContent.Parent = NotificationFrame

        task.wait()
        local contentHeight = NotificationContent.AbsoluteSize.Y
        NotificationFrame.Size = UDim2.new(0, 300, 0, contentHeight + 55)

        Tween(NotificationFrame, {Position = UDim2.new(1, -310, 1, -contentHeight - 65)}, 0.5, Enum.EasingStyle.Back)

        task.wait(duration)

        Tween(NotificationFrame, {Position = UDim2.new(1, -310, 1, 10)}, 0.3)
        task.wait(0.3)
        NotificationFrame:Destroy()
    end

    function WindowAPI:Destroy()
        ScreenGui:Destroy()
    end

    -- Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    return WindowAPI
end

return Library
