local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ModernUI = {}

--// Theme Configuration
ModernUI.Theme = {
    MainColor = Color3.fromRGB(25, 25, 35),
    SecondaryColor = Color3.fromRGB(30, 30, 45),
    AccentColor = Color3.fromRGB(0, 120, 215), -- Default Blue
    TextColor = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 160),
    BorderColor = Color3.fromRGB(45, 45, 60),
    Success = Color3.fromRGB(60, 200, 100),
    Error = Color3.fromRGB(255, 60, 60),
    Font = Enum.Font.GothamBold,
    TextSize = 14
}

--// Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		local Tween = TweenService:Create(object, TweenInfo.new(0.15), {Position = pos})
		Tween:Play()
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

local function Ripple(object)
	spawn(function()
		local Circle = Instance.new("ImageLabel")
		Circle.Parent = object
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(210, 210, 210)
		Circle.ImageTransparency = 0.8
		
		local NewX, NewY = Mouse.X - Circle.AbsolutePosition.X, Mouse.Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
		
		local Size = object.AbsoluteSize.X
		if object.AbsoluteSize.Y > Size then Size = object.AbsoluteSize.Y end
		
		local Time = 0.5
		Circle:TweenSizeAndPosition(UDim2.new(0, Size * 3, 0, Size * 3), UDim2.new(0.5, -Size * 1.5, 0.5, -Size * 1.5), "Out", "Quad", Time, false, nil)
		
		for i = 1, 10 do
			Circle.ImageTransparency = Circle.ImageTransparency + 0.02
			wait(Time / 10)
		end
		Circle:Destroy()
	end)
end

--// Main Library Functions
function ModernUI:CreateWindow(Config)
    local Title = Config.Title or "Modern UI"
    local Size = Config.Size or UDim2.fromOffset(550, 350)
    
    local ScreenGui = Create("ScreenGui", {
        Name = "ModernUILib",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end

    --// Notification System
    local NotificationContainer = Create("Frame", {
        Name = "Notifications",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -320, 1, -20),
        Size = UDim2.new(0, 300, 1, 0),
        AnchorPoint = Vector2.new(0, 1)
    })
    
    local NotificationLayout = Create("UIListLayout", {
        Parent = NotificationContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })

    function ModernUI:Notify(Title, Content, Duration)
        Duration = Duration or 3
        
        local Notif = Create("Frame", {
            Parent = NotificationContainer,
            BackgroundColor3 = ModernUI.Theme.SecondaryColor,
            Size = UDim2.new(1, 0, 0, 0), -- Start closed
            ClipsDescendants = true
        })
        Create("UICorner", {Parent = Notif, CornerRadius = UDim.new(0, 6)})
        
        local NotifTitle = Create("TextLabel", {
            Parent = Notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(1, -20, 0, 20),
            Font = ModernUI.Theme.Font,
            Text = Title,
            TextColor3 = ModernUI.Theme.AccentColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local NotifContent = Create("TextLabel", {
            Parent = Notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 25),
            Size = UDim2.new(1, -20, 0, 35),
            Font = ModernUI.Theme.Font,
            Text = Content,
            TextColor3 = ModernUI.Theme.TextColor,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        
        -- Animation In
        TweenService:Create(Notif, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 70)}):Play()
        
        spawn(function()
            wait(Duration)
            TweenService:Create(Notif, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.3)
            Notif:Destroy()
        end)
    end

    --// Watermark
    local Watermark = Create("Frame", {
        Name = "Watermark",
        Parent = ScreenGui,
        BackgroundColor3 = ModernUI.Theme.SecondaryColor,
        Position = UDim2.new(0, 20, 0, 20),
        Size = UDim2.new(0, 0, 0, 26), -- Auto size
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Watermark, CornerRadius = UDim.new(0, 4)})
    
    local WatermarkText = Create("TextLabel", {
        Parent = Watermark,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        Font = ModernUI.Theme.Font,
        Text = Title .. " | FPS: 60",
        TextColor3 = ModernUI.Theme.TextColor,
        TextSize = 12
    })
    
    -- Auto size watermark
    RunService.RenderStepped:Connect(function()
        WatermarkText.Text = Title .. " | FPS: " .. math.floor(1 / RunService.RenderStepped:Wait())
        WatermarkText.Size = UDim2.new(0, WatermarkText.TextBounds.X, 1, 0)
        Watermark.Size = UDim2.new(0, WatermarkText.TextBounds.X + 20, 0, 26)
    end)

    --// Main Window
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = ModernUI.Theme.MainColor,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromScale(0, 0),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 6)})
    
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = Size}):Play()

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = ModernUI.Theme.SecondaryColor,
        Size = UDim2.new(1, 0, 0, 35),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = TopBar, CornerRadius = UDim.new(0, 6)})
    
    local TopBarFix = Create("Frame", {
        Parent = TopBar,
        BackgroundColor3 = ModernUI.Theme.SecondaryColor,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BorderSizePixel = 0
    })

    local TitleLabel = Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = ModernUI.Theme.Font,
        Text = Title,
        TextColor3 = ModernUI.Theme.TextColor,
        TextSize = ModernUI.Theme.TextSize + 2,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ContentContainer = Create("Frame", {
        Name = "Content",
        Parent = MainFrame,
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(1, 0, 1, -35)
    })

    local TabContainer = Create("Frame", {
        Name = "Tabs",
        Parent = ContentContainer,
        BackgroundColor3 = ModernUI.Theme.SecondaryColor,
        Size = UDim2.new(0, 130, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 2
    })
    
    local Separator = Create("Frame", {
        Parent = TabContainer,
        BackgroundColor3 = ModernUI.Theme.BorderColor,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0
    })

    local TabListLayout = Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    Create("UIPadding", {
        Parent = TabContainer,
        PaddingTop = UDim.new(0, 10)
    })

    local PagesContainer = Create("Frame", {
        Name = "Pages",
        Parent = ContentContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 140, 0, 0),
        Size = UDim2.new(1, -150, 1, 0),
        ClipsDescendants = true
    })

    MakeDraggable(TopBar, MainFrame)

    local Window = {}
    local FirstTab = true

    -- Toggle UI Logic
    local UIHidden = false
    local ToggleKey = Enum.KeyCode.RightControl

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == ToggleKey and not gameProcessed then
            UIHidden = not UIHidden
            if UIHidden then
                MainFrame.Visible = false
            else
                MainFrame.Visible = true
            end
        end
    end)

    function Window:Tab(Name)
        local TabButton = Create("TextButton", {
            Name = Name .. "Tab",
            Parent = TabContainer,
            BackgroundColor3 = Color3.new(1,1,1),
            BackgroundTransparency = 1,
            Size = UDim2.new(0.9, 0, 0, 30),
            Font = ModernUI.Theme.Font,
            Text = Name,
            TextColor3 = ModernUI.Theme.TextDark,
            TextSize = ModernUI.Theme.TextSize,
            AutoButtonColor = false
        })
        Create("UICorner", {Parent = TabButton, CornerRadius = UDim.new(0, 4)})

        local Page = Create("ScrollingFrame", {
            Name = Name .. "Page",
            Parent = PagesContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = ModernUI.Theme.AccentColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false
        })
        
        local PageLayout = Create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })
        
        Create("UIPadding", {
            Parent = Page,
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5)
        })

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        local function Activate()
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = ModernUI.Theme.TextDark}):Play()
                end
            end
            for _, child in pairs(PagesContainer:GetChildren()) do
                child.Visible = false
            end
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, TextColor3 = ModernUI.Theme.TextColor}):Play()
            TabButton.BackgroundColor3 = ModernUI.Theme.AccentColor
            Page.Visible = true
        end

        TabButton.MouseButton1Click:Connect(Activate)

        if FirstTab then
            FirstTab = false
            Activate()
        end

        local Elements = {}

        function Elements:Button(Text, Callback)
            Callback = Callback or function() end
            
            local ButtonFrame = Create("Frame", {
                Name = "Button",
                Parent = Page,
                BackgroundColor3 = ModernUI.Theme.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 36),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = ButtonFrame, CornerRadius = UDim.new(0, 4)})
            
            local Btn = Create("TextButton", {
                Parent = ButtonFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = Text,
                TextColor3 = ModernUI.Theme.TextColor,
                TextSize = ModernUI.Theme.TextSize
            })
            
            Btn.MouseButton1Click:Connect(function()
                Ripple(Btn)
                Callback()
            end)
            return Btn
        end

        function Elements:Toggle(Text, Default, Callback)
            Default = Default or false
            Callback = Callback or function() end
            local Toggled = Default

            local ToggleFrame = Create("Frame", {
                Name = "Toggle",
                Parent = Page,
                BackgroundColor3 = ModernUI.Theme.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 36),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = ToggleFrame, CornerRadius = UDim.new(0, 4)})

            local Label = Create("TextLabel", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = Text,
                TextColor3 = ModernUI.Theme.TextColor,
                TextSize = ModernUI.Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SwitchBg = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = Toggled and ModernUI.Theme.AccentColor or Color3.fromRGB(60, 60, 70),
                Position = UDim2.new(1, -50, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20),
            })
            Create("UICorner", {Parent = SwitchBg, CornerRadius = UDim.new(1, 0)})

            local SwitchCircle = Create("Frame", {
                Parent = SwitchBg,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
            })
            Create("UICorner", {Parent = SwitchCircle, CornerRadius = UDim.new(1, 0)})

            local Button = Create("TextButton", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            Button.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Callback(Toggled)
                
                local TargetColor = Toggled and ModernUI.Theme.AccentColor or Color3.fromRGB(60, 60, 70)
                local TargetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor}):Play()
                TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {Position = TargetPos}):Play()
            end)
        end

        function Elements:Slider(Text, Min, Max, Default, Callback)
            Default = Default or Min
            Callback = Callback or function() end
            
            local SliderFrame = Create("Frame", {
                Name = "Slider",
                Parent = Page,
                BackgroundColor3 = ModernUI.Theme.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 50),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SliderFrame, CornerRadius = UDim.new(0, 4)})

            local Label = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                Font = ModernUI.Theme.Font,
                Text = Text,
                TextColor3 = ModernUI.Theme.TextColor,
                TextSize = ModernUI.Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                Font = ModernUI.Theme.Font,
                Text = tostring(Default),
                TextColor3 = ModernUI.Theme.TextDark,
                TextSize = ModernUI.Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local SliderBg = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                Position = UDim2.new(0, 10, 0, 35),
                Size = UDim2.new(1, -20, 0, 4),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SliderBg, CornerRadius = UDim.new(1, 0)})

            local SliderFill = Create("Frame", {
                Parent = SliderBg,
                BackgroundColor3 = ModernUI.Theme.AccentColor,
                Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SliderFill, CornerRadius = UDim.new(1, 0)})
            
            local Trigger = Create("TextButton", {
                Parent = SliderBg,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            local Dragging = false
            
            local function UpdateSlider(input)
                local Pos = UDim2.new(math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1), 0, 1, 0)
                TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = Pos}):Play()
                
                local Value = math.floor(((Pos.X.Scale * (Max - Min)) + Min) * 100) / 100
                ValueLabel.Text = tostring(Value)
                Callback(Value)
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
        end

        function Elements:Keybind(Text, Default, Callback)
            Default = Default or Enum.KeyCode.RightControl
            Callback = Callback or function() end
            
            local CurrentKey = Default
            
            local KeybindFrame = Create("Frame", {
                Name = "Keybind",
                Parent = Page,
                BackgroundColor3 = ModernUI.Theme.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 36),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = KeybindFrame, CornerRadius = UDim.new(0, 4)})
            
            local Label = Create("TextLabel", {
                Parent = KeybindFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -100, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = Text,
                TextColor3 = ModernUI.Theme.TextColor,
                TextSize = ModernUI.Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local KeyButton = Create("TextButton", {
                Parent = KeybindFrame,
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                Position = UDim2.new(1, -90, 0.5, -12),
                Size = UDim2.new(0, 80, 0, 24),
                Font = ModernUI.Theme.Font,
                Text = Default.Name,
                TextColor3 = ModernUI.Theme.TextColor,
                TextSize = 12
            })
            Create("UICorner", {Parent = KeyButton, CornerRadius = UDim.new(0, 4)})
            
            local Listening = false
            
            KeyButton.MouseButton1Click:Connect(function()
                Listening = true
                KeyButton.Text = "..."
                KeyButton.TextColor3 = ModernUI.Theme.AccentColor
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    Listening = false
                    CurrentKey = input.KeyCode
                    KeyButton.Text = CurrentKey.Name
                    KeyButton.TextColor3 = ModernUI.Theme.TextColor
                    Callback(CurrentKey)
                end
            end)
        end

        return Elements
    end

    --// Default Settings Tab
    local SettingsTab = Window:Tab("Settings")
    SettingsTab:Keybind("Toggle UI", ToggleKey, function(NewKey)
        ToggleKey = NewKey
    end)
    
    SettingsTab:Button("Unload UI", function()
        ScreenGui:Destroy()
    end)

    return Window
end

return ModernUI
