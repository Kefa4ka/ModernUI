local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ModernUI = {}

--// Tokyo Theme Configuration
ModernUI.Theme = {
    MainColor = Color3.fromRGB(10, 10, 10),
    SecondaryColor = Color3.fromRGB(15, 15, 15),
    AccentColor = Color3.fromRGB(0, 170, 255), -- Electric Blue
    TextColor = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150),
    BorderColor = Color3.fromRGB(40, 40, 40),
    HoverColor = Color3.fromRGB(25, 25, 25),
    Font = Enum.Font.Code, -- Technical Look
    TextSize = 13
}

--// Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function CreateBorder(parent, color)
    local border = Create("UIStroke", {
        Parent = parent,
        Color = color or ModernUI.Theme.BorderColor,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    return border
end

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		object.Position = pos -- Instant movement for technical feel
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

--// Main Library Functions
function ModernUI:CreateWindow(Config)
    local Title = Config.Title or "Tokyo Hub"
    local Size = Config.Size or UDim2.fromOffset(500, 350)
    
    local ScreenGui = Create("ScreenGui", {
        Name = "TokyoUI",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end

    --// Top Stats Bar
    local StatsBar = Create("Frame", {
        Name = "StatsBar",
        Parent = ScreenGui,
        BackgroundColor3 = ModernUI.Theme.MainColor,
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0
    })
    
    -- Gradient Line at Bottom of Stats Bar
    local StatsLine = Create("Frame", {
        Parent = StatsBar,
        BackgroundColor3 = ModernUI.Theme.AccentColor,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0
    })
    
    local StatsText = Create("TextLabel", {
        Parent = StatsBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = ModernUI.Theme.Font,
        Text = "",
        TextColor3 = ModernUI.Theme.TextColor,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    RunService.RenderStepped:Connect(function()
        local FPS = math.floor(1 / RunService.RenderStepped:Wait())
        local Ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():match("%d+"))
        local Time = os.date("%H:%M:%S")
        StatsText.Text = string.format("%s | User: %s | FPS: %d | Ping: %dms | Time: %s", Title, LocalPlayer.Name, FPS, Ping, Time)
    end)

    --// Notification System
    local NotificationContainer = Create("Frame", {
        Name = "Notifications",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -320, 1, -50),
        Size = UDim2.new(0, 300, 1, 0),
        AnchorPoint = Vector2.new(0, 1)
    })
    
    local NotificationLayout = Create("UIListLayout", {
        Parent = NotificationContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })

    function ModernUI:Notify(Title, Content, Duration)
        Duration = Duration or 3
        
        local Notif = Create("Frame", {
            Parent = NotificationContainer,
            BackgroundColor3 = ModernUI.Theme.MainColor,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true,
            BorderSizePixel = 0
        })
        CreateBorder(Notif, ModernUI.Theme.AccentColor)
        
        local NotifTitle = Create("TextLabel", {
            Parent = Notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(1, -20, 0, 20),
            Font = ModernUI.Theme.Font,
            Text = Title,
            TextColor3 = ModernUI.Theme.AccentColor,
            TextSize = 13,
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
        
        TweenService:Create(Notif, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 60)}):Play()
        
        spawn(function()
            wait(Duration)
            TweenService:Create(Notif, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.3)
            Notif:Destroy()
        end)
    end

    --// Keybind List Window
    local KeybindListFrame = Create("Frame", {
        Name = "KeybindList",
        Parent = ScreenGui,
        BackgroundColor3 = ModernUI.Theme.MainColor,
        Size = UDim2.new(0, 200, 0, 22), -- Initial size for title only
        Position = UDim2.new(0, 10, 0.5, 0),
        BorderSizePixel = 0,
        Visible = false -- Hidden by default
    })
    CreateBorder(KeybindListFrame, ModernUI.Theme.AccentColor)
    MakeDraggable(KeybindListFrame, KeybindListFrame)

    local KeybindListTitle = Create("TextLabel", {
        Parent = KeybindListFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22),
        Font = ModernUI.Theme.Font,
        Text = "Keybinds",
        TextColor3 = ModernUI.Theme.AccentColor,
        TextSize = 13
    })

    local KeybindListContainer = Create("Frame", {
        Parent = KeybindListFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 22),
        Size = UDim2.new(1, 0, 1, -22),
        ClipsDescendants = true
    })

    local KeybindListLayout = Create("UIListLayout", {
        Parent = KeybindListContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    local ActiveKeybinds = {}

    local function UpdateKeybindList()
        -- Clear existing
        for _, child in pairs(KeybindListContainer:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end

        local Count = 0
        for Name, Data in pairs(ActiveKeybinds) do
            Count = Count + 1
            local Item = Create("Frame", {
                Parent = KeybindListContainer,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18)
            })
            
            Create("TextLabel", {
                Parent = Item,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -10, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = Name,
                TextColor3 = ModernUI.Theme.TextColor,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            Create("TextLabel", {
                Parent = Item,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -10, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = "[" .. Data.Key.Name .. "]",
                TextColor3 = ModernUI.Theme.TextDark,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })
        end

        if Count > 0 then
            KeybindListFrame.Visible = true
            KeybindListFrame.Size = UDim2.new(0, 200, 0, 22 + (Count * 20) + 5)
        else
            KeybindListFrame.Visible = false
        end
    end

    --// Main Window
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = ModernUI.Theme.MainColor,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = Size,
        BorderSizePixel = 0
    })
    CreateBorder(MainFrame, ModernUI.Theme.AccentColor)

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = ModernUI.Theme.MainColor,
        Size = UDim2.new(1, 0, 0, 30),
        BorderSizePixel = 0
    })
    
    local TopBarLine = Create("Frame", {
        Parent = TopBar,
        BackgroundColor3 = ModernUI.Theme.BorderColor,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0
    })

    local TitleLabel = Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = ModernUI.Theme.Font,
        Text = Title,
        TextColor3 = ModernUI.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TabContainer = Create("Frame", {
        Name = "Tabs",
        Parent = MainFrame,
        BackgroundColor3 = ModernUI.Theme.MainColor,
        Position = UDim2.new(0, 10, 0, 40),
        Size = UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1
    })

    local TabListLayout = Create("UIListLayout", {
        Parent = TabContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    local ContentContainer = Create("Frame", {
        Name = "Content",
        Parent = MainFrame,
        BackgroundColor3 = ModernUI.Theme.MainColor,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 75),
        Size = UDim2.new(1, -20, 1, -85),
        ClipsDescendants = true
    })
    CreateBorder(ContentContainer, ModernUI.Theme.BorderColor)

    MakeDraggable(TopBar, MainFrame)

    local Window = {}
    local FirstTab = true

    -- Toggle UI Logic
    local UIHidden = false
    local ToggleKey = Enum.KeyCode.RightControl

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == ToggleKey and not gameProcessed then
            UIHidden = not UIHidden
            MainFrame.Visible = not UIHidden
        end
    end)

    function Window:Tab(Name)
        local TabButton = Create("TextButton", {
            Name = Name .. "Tab",
            Parent = TabContainer,
            BackgroundColor3 = ModernUI.Theme.MainColor,
            Size = UDim2.new(0, 0, 1, 0), -- Auto sized
            Font = ModernUI.Theme.Font,
            Text = Name,
            TextColor3 = ModernUI.Theme.TextDark,
            TextSize = ModernUI.Theme.TextSize,
            AutoButtonColor = false,
            BorderSizePixel = 0
        })
        
        -- Auto size tab button
        TabButton.Size = UDim2.new(0, game:GetService("TextService"):GetTextSize(Name, ModernUI.Theme.TextSize, ModernUI.Theme.Font, Vector2.new(1000, 1000)).X + 20, 1, 0)
        
        local TabBorder = CreateBorder(TabButton, ModernUI.Theme.BorderColor)

        local Page = Create("ScrollingFrame", {
            Name = Name .. "Page",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = ModernUI.Theme.AccentColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            BorderSizePixel = 0
        })
        
        local PageLayout = Create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })
        
        Create("UIPadding", {
            Parent = Page,
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        })

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        local function Activate()
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = ModernUI.Theme.TextDark
                    child:FindFirstChild("UIStroke").Color = ModernUI.Theme.BorderColor
                end
            end
            for _, child in pairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            
            TabButton.TextColor3 = ModernUI.Theme.AccentColor
            TabBorder.Color = ModernUI.Theme.AccentColor
            Page.Visible = true
        end

        TabButton.MouseButton1Click:Connect(Activate)

        if FirstTab then
            FirstTab = false
            Activate()
        end

        local Elements = {}

        function Elements:Section(Text)
            local SectionFrame = Create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
            })
            
            local Label = Create("TextLabel", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = "- " .. Text .. " -",
                TextColor3 = ModernUI.Theme.AccentColor,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function Elements:Button(Text, Callback)
            Callback = Callback or function() end
            
            local ButtonFrame = Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = ModernUI.Theme.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 26),
                Font = ModernUI.Theme.Font,
                Text = Text,
                TextColor3 = ModernUI.Theme.TextColor,
                TextSize = ModernUI.Theme.TextSize,
                AutoButtonColor = false,
                BorderSizePixel = 0
            })
            CreateBorder(ButtonFrame, ModernUI.Theme.BorderColor)
            
            ButtonFrame.MouseButton1Click:Connect(function()
                Callback()
                -- Flash effect
                local oldColor = ButtonFrame.BackgroundColor3
                ButtonFrame.BackgroundColor3 = ModernUI.Theme.AccentColor
                wait(0.1)
                ButtonFrame.BackgroundColor3 = oldColor
            end)
            
            return ButtonFrame
        end

        function Elements:Toggle(Text, Default, Keybind, Callback)
            Default = Default or false
            -- Handle optional Keybind argument
            if typeof(Keybind) == "function" then
                Callback = Keybind
                Keybind = nil
            end
            
            Callback = Callback or function() end
            local Toggled = Default
            local CurrentKey = Keybind

            local ToggleFrame = Create("TextButton", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Text = ""
            })

            local Checkbox = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = ModernUI.Theme.SecondaryColor,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, 0, 0.5, -7),
                BorderSizePixel = 0
            })
            CreateBorder(Checkbox, ModernUI.Theme.BorderColor)
            
            local CheckMarker = Create("Frame", {
                Parent = Checkbox,
                BackgroundColor3 = ModernUI.Theme.AccentColor,
                Size = UDim2.new(1, -4, 1, -4),
                Position = UDim2.new(0, 2, 0, 2),
                BorderSizePixel = 0,
                Visible = Toggled
            })

            local Label = Create("TextLabel", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 24, 0, 0),
                Size = UDim2.new(1, -24, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = Text,
                TextColor3 = Toggled and ModernUI.Theme.TextColor or ModernUI.Theme.TextDark,
                TextSize = ModernUI.Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            -- Keybind Button (Small, next to label)
            local KeyButton = Create("TextButton", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -60, 0, 0),
                Size = UDim2.new(0, 60, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = CurrentKey and "[" .. CurrentKey.Name .. "]" or "[-]",
                TextColor3 = ModernUI.Theme.TextDark,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local function SetState(NewState)
                Toggled = NewState
                CheckMarker.Visible = Toggled
                Label.TextColor3 = Toggled and ModernUI.Theme.TextColor or ModernUI.Theme.TextDark
                
                if Toggled and CurrentKey then
                    ActiveKeybinds[Text] = {Key = CurrentKey}
                else
                    ActiveKeybinds[Text] = nil
                end
                UpdateKeybindList()
                
                Callback(Toggled)
            end

            ToggleFrame.MouseButton1Click:Connect(function()
                SetState(not Toggled)
            end)

            -- Keybind Logic
            local Listening = false
            KeyButton.MouseButton1Click:Connect(function()
                Listening = true
                KeyButton.Text = "[...]"
                KeyButton.TextColor3 = ModernUI.Theme.AccentColor
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    Listening = false
                    CurrentKey = input.KeyCode
                    KeyButton.Text = "[" .. CurrentKey.Name .. "]"
                    KeyButton.TextColor3 = ModernUI.Theme.TextDark
                    
                    -- Update active keybinds if currently toggled
                    if Toggled then
                        ActiveKeybinds[Text] = {Key = CurrentKey}
                        UpdateKeybindList()
                    end
                elseif not Listening and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                    if CurrentKey and input.KeyCode == CurrentKey then
                        SetState(not Toggled)
                    end
                end
            end)
            
            -- Initialize
            if Toggled and CurrentKey then
                ActiveKeybinds[Text] = {Key = CurrentKey}
                UpdateKeybindList()
            end
        end

        function Elements:Slider(Text, Min, Max, Default, Callback)
            Default = Default or Min
            Callback = Callback or function() end
            
            local SliderFrame = Create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35)
            })

            local Label = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 15),
                Font = ModernUI.Theme.Font,
                Text = Text,
                TextColor3 = ModernUI.Theme.TextColor,
                TextSize = ModernUI.Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 15),
                Font = ModernUI.Theme.Font,
                Text = tostring(Default),
                TextColor3 = ModernUI.Theme.AccentColor,
                TextSize = ModernUI.Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local SliderBg = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = ModernUI.Theme.SecondaryColor,
                Position = UDim2.new(0, 0, 0, 20),
                Size = UDim2.new(1, 0, 0, 6),
                BorderSizePixel = 0
            })
            CreateBorder(SliderBg, ModernUI.Theme.BorderColor)

            local SliderFill = Create("Frame", {
                Parent = SliderBg,
                BackgroundColor3 = ModernUI.Theme.AccentColor,
                Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                BorderSizePixel = 0
            })
            
            local Trigger = Create("TextButton", {
                Parent = SliderBg,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            local Dragging = false
            
            local function UpdateSlider(input)
                local Pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                SliderFill.Size = UDim2.new(Pos, 0, 1, 0)
                
                local Value = math.floor(((Pos * (Max - Min)) + Min) * 100) / 100
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
        
        function Elements:ColorPicker(Text, Default, Callback)
            Default = Default or Color3.fromRGB(255, 255, 255)
            Callback = Callback or function() end
            local CurrentColor = Default
            
            local PickerFrame = Create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 26)
            })
            
            local Label = Create("TextLabel", {
                Parent = PickerFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -40, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = Text,
                TextColor3 = ModernUI.Theme.TextColor,
                TextSize = ModernUI.Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ColorPreview = Create("TextButton", {
                Parent = PickerFrame,
                BackgroundColor3 = CurrentColor,
                Position = UDim2.new(1, -40, 0, 3),
                Size = UDim2.new(0, 40, 0, 20),
                Text = "",
                BorderSizePixel = 0
            })
            CreateBorder(ColorPreview, ModernUI.Theme.BorderColor)
            
            local PickerPopup = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = ModernUI.Theme.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 100),
                Visible = false,
                BorderSizePixel = 0,
                ClipsDescendants = true
            })
            CreateBorder(PickerPopup, ModernUI.Theme.BorderColor)
            
            local function UpdateColor()
                ColorPreview.BackgroundColor3 = CurrentColor
                Callback(CurrentColor)
            end
            
            local function CreateSlider(Name, YPos, ColorComponent)
                local SliderBg = Create("Frame", {
                    Parent = PickerPopup,
                    BackgroundColor3 = ModernUI.Theme.MainColor,
                    Position = UDim2.new(0, 10, 0, YPos),
                    Size = UDim2.new(1, -20, 0, 20),
                    BorderSizePixel = 0
                })
                
                local SliderFill = Create("Frame", {
                    Parent = SliderBg,
                    BackgroundColor3 = ModernUI.Theme.AccentColor,
                    Size = UDim2.new(select(ColorComponent, CurrentColor.r, CurrentColor.g, CurrentColor.b), 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                local Trigger = Create("TextButton", {
                    Parent = SliderBg,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = ""
                })
                
                local Dragging = false
                local function Update(input)
                    local Pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                    SliderFill.Size = UDim2.new(Pos, 0, 1, 0)
                    
                    local r, g, b = CurrentColor.r, CurrentColor.g, CurrentColor.b
                    if ColorComponent == 1 then r = Pos
                    elseif ColorComponent == 2 then g = Pos
                    elseif ColorComponent == 3 then b = Pos end
                    
                    CurrentColor = Color3.new(r, g, b)
                    UpdateColor()
                end
                
                Trigger.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                        Update(input)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        Update(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
                end)
            end
            
            CreateSlider("R", 10, 1)
            CreateSlider("G", 40, 2)
            CreateSlider("B", 70, 3)
            
            ColorPreview.MouseButton1Click:Connect(function()
                PickerPopup.Visible = not PickerPopup.Visible
            end)
        end

        function Elements:Keybind(Text, Default, Callback)
            Default = Default or Enum.KeyCode.RightControl
            Callback = Callback or function() end
            
            local CurrentKey = Default
            
            local KeybindFrame = Create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20)
            })
            
            local Label = Create("TextLabel", {
                Parent = KeybindFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -80, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = Text,
                TextColor3 = ModernUI.Theme.TextColor,
                TextSize = ModernUI.Theme.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local KeyButton = Create("TextButton", {
                Parent = KeybindFrame,
                BackgroundColor3 = ModernUI.Theme.SecondaryColor,
                Position = UDim2.new(1, -80, 0, 0),
                Size = UDim2.new(0, 80, 1, 0),
                Font = ModernUI.Theme.Font,
                Text = "[" .. Default.Name .. "]",
                TextColor3 = ModernUI.Theme.AccentColor,
                TextSize = 12,
                BorderSizePixel = 0
            })
            CreateBorder(KeyButton, ModernUI.Theme.BorderColor)
            
            local Listening = false
            
            KeyButton.MouseButton1Click:Connect(function()
                Listening = true
                KeyButton.Text = "[...]"
                KeyButton.TextColor3 = ModernUI.Theme.TextColor
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    Listening = false
                    CurrentKey = input.KeyCode
                    KeyButton.Text = "[" .. CurrentKey.Name .. "]"
                    KeyButton.TextColor3 = ModernUI.Theme.AccentColor
                    Callback(CurrentKey)
                end
            end)
        end

        return Elements
    end

    --// Default Settings Tab
    local SettingsTab = Window:Tab("Settings")
    SettingsTab:Section("Main")
    SettingsTab:Keybind("Toggle UI", ToggleKey, function(NewKey)
        ToggleKey = NewKey
    end)
    
    SettingsTab:Button("Unload UI", function()
        ScreenGui:Destroy()
    end)

    return Window
end

return ModernUI
