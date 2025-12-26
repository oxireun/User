-- Blade Runner 2049 Neon UI Library
-- By: Your Name Here
-- GitHub: https://github.com/yourusername/bladerunner-ui

local BladerunnerUI = {}
BladerunnerUI.__index = BladerunnerUI

-- Color palette (Blade Runner 2049 theme)
local Colors = {
    Background = Color3.fromRGB(15, 15, 25),
    DarkBackground = Color3.fromRGB(8, 8, 15),
    Border = Color3.fromRGB(40, 10, 60),
    NeonPurple = Color3.fromRGB(157, 0, 255),
    NeonPink = Color3.fromRGB(255, 0, 157),
    LightPurple = Color3.fromRGB(180, 80, 255),
    Text = Color3.fromRGB(240, 240, 255),
    SubText = Color3.fromRGB(180, 180, 200),
    Shadow = Color3.fromRGB(30, 0, 50, 0.8)
}

-- Utility functions
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function CreateGradient(color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = rotation or 0
    return gradient
end

local function RippleEffect(button)
    local ripple = CreateInstance("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.8,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 5,
        Parent = button
    })
    
    local corner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {}
    goal.Size = UDim2.new(2, 0, 2, 0)
    goal.BackgroundTransparency = 1
    
    local tween = game:GetService("TweenService"):Create(ripple, tweenInfo, goal)
    tween:Play()
    
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Main Library Function
function BladerunnerUI:NewWindow(title)
    local Window = {}
    setmetatable(Window, BladerunnerUI)
    
    -- Create main screen GUI
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "BladerunnerUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    -- Main window container
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Colors.Background,
        BorderColor3 = Colors.Border,
        BorderSizePixel = 2,
        Size = UDim2.new(0, 400, 0, 500),
        Position = UDim2.new(0.5, -200, 0.5, -250),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    
    local MainCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = MainFrame
    })
    
    -- Neon glow effect
    local Glow = CreateInstance("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        Image = "rbxassetid://8992231221",
        ImageColor3 = Colors.NeonPurple,
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 900, 900),
        ZIndex = 0,
        Parent = MainFrame
    })
    
    -- Title bar
    local TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Colors.DarkBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = MainFrame
    })
    
    local TitleBarCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = TitleBar
    })
    
    local TitleText = CreateInstance("TextLabel", {
        Name = "TitleText",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0.05, 0, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = title or "BLADE RUNNER UI",
        TextColor3 = Colors.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })
    
    -- Window control buttons
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0, 10),
        Font = Enum.Font.Gotham,
        Text = "×",
        TextColor3 = Colors.Text,
        TextSize = 18,
        Parent = TitleBar
    })
    
    local CloseCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = CloseButton
    })
    
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        BackgroundColor3 = Color3.fromRGB(255, 180, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -60, 0, 10),
        Font = Enum.Font.Gotham,
        Text = "-",
        TextColor3 = Colors.Text,
        TextSize = 18,
        Parent = TitleBar
    })
    
    local MinimizeCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = MinimizeButton
    })
    
    -- Sections container (tabs)
    local SectionsContainer = CreateInstance("Frame", {
        Name = "SectionsContainer",
        BackgroundColor3 = Colors.DarkBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 40),
        Parent = MainFrame
    })
    
    local SectionsList = CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = SectionsContainer
    })
    
    -- Content container
    local ContentContainer = CreateInstance("ScrollingFrame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 100),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.NeonPurple,
        Parent = MainFrame
    })
    
    local ContentList = CreateInstance("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = ContentContainer
    })
    
    -- Window dragging functionality
    local Dragging, DragInput, DragStart, StartPos
    
    local function UpdateInput(input)
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale, 
            StartPos.X.Offset + Delta.X, 
            StartPos.Y.Scale, 
            StartPos.Y.Offset + Delta.Y
        )
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            DragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdateInput(input)
        end
    end)
    
    -- Window controls
    local Minimized = false
    local OriginalSize = MainFrame.Size
    
    MinimizeButton.MouseButton1Click:Connect(function()
        if Minimized then
            MainFrame:TweenSize(OriginalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            ContentContainer.Visible = true
        else
            MainFrame:TweenSize(UDim2.new(OriginalSize.X.Scale, OriginalSize.X.Offset, 0, 90), 
                Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            ContentContainer.Visible = false
        end
        Minimized = not Minimized
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Internal state
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    Window.SectionsContainer = SectionsContainer
    Window.ContentContainer = ContentContainer
    Window.Sections = {}
    Window.ActiveSection = nil
    
    -- Add to game
    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    return Window
end

-- Section creation
function BladerunnerUI:NewSection(name)
    local Section = {}
    Section.Name = name
    Section.Elements = {}
    
    -- Create tab button
    local TabButton = CreateInstance("TextButton", {
        Name = name .. "Tab",
        BackgroundColor3 = Colors.DarkBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 100, 0, 40),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Colors.SubText,
        TextSize = 14,
        Parent = self.SectionsContainer
    })
    
    local TabCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TabButton
    })
    
    -- Create section content frame
    local SectionFrame = CreateInstance("Frame", {
        Name = name .. "Section",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Visible = false,
        Parent = self.ContentContainer
    })
    
    local SectionList = CreateInstance("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 15),
        Parent = SectionFrame
    })
    
    -- Tab selection logic
    TabButton.MouseButton1Click:Connect(function()
        if self.ActiveSection then
            self.ActiveSection.Frame.Visible = false
            self.ActiveSection.Button.BackgroundColor3 = Colors.DarkBackground
            self.ActiveSection.Button.TextColor3 = Colors.SubText
        end
        
        SectionFrame.Visible = true
        TabButton.BackgroundColor3 = Colors.NeonPurple
        TabButton.TextColor3 = Colors.Text
        
        self.ActiveSection = {
            Frame = SectionFrame,
            Button = TabButton
        }
    end)
    
    -- Activate first section by default
    if #self.Sections == 0 then
        TabButton.BackgroundColor3 = Colors.NeonPurple
        TabButton.TextColor3 = Colors.Text
        SectionFrame.Visible = true
        self.ActiveSection = {
            Frame = SectionFrame,
            Button = TabButton
        }
    end
    
    table.insert(self.Sections, Section)
    
    -- Update content container size
    SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
        self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, SectionList.AbsoluteContentSize.Y + 20)
    end)
    
    -- Element creation methods
    function Section:CreateButton(name, callback)
        local Button = CreateInstance("TextButton", {
            Name = name,
            BackgroundColor3 = Colors.DarkBackground,
            BorderColor3 = Colors.NeonPurple,
            BorderSizePixel = 2,
            Size = UDim2.new(0.9, 0, 0, 40),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Parent = SectionFrame
        })
        
        local ButtonCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = Button
        })
        
        local ButtonGradient = CreateGradient(Colors.NeonPurple, Colors.NeonPink, 90)
        ButtonGradient.Enabled = false
        ButtonGradient.Parent = Button
        
        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
            ButtonGradient.Enabled = true
        end)
        
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Colors.DarkBackground
            ButtonGradient.Enabled = false
        end)
        
        Button.MouseButton1Click:Connect(function()
            RippleEffect(Button)
            if callback then
                callback()
            end
        end)
        
        table.insert(self.Elements, Button)
        return Button
    end
    
    function Section:CreateToggle(name, default, callback)
        local ToggleFrame = CreateInstance("Frame", {
            Name = name .. "Toggle",
            BackgroundTransparency = 1,
            Size = UDim2.new(0.9, 0, 0, 40),
            Parent = SectionFrame
        })
        
        local ToggleLabel = CreateInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(0.7, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = ToggleFrame
        })
        
        local ToggleButton = CreateInstance("Frame", {
            Name = "ToggleButton",
            BackgroundColor3 = Color3.fromRGB(60, 60, 80),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 50, 0, 25),
            Position = UDim2.new(1, -60, 0.5, -12),
            AnchorPoint = Vector2.new(1, 0.5),
            Parent = ToggleFrame
        })
        
        local ToggleCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = ToggleButton
        })
        
        local ToggleKnob = CreateInstance("Frame", {
            Name = "ToggleKnob",
            BackgroundColor3 = Color3.fromRGB(240, 240, 240),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 21, 0, 21),
            Position = UDim2.new(0, 2, 0.5, -10.5),
            AnchorPoint = Vector2.new(0, 0.5),
            Parent = ToggleButton
        })
        
        local KnobCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = ToggleKnob
        })
        
        local ToggleState = default or false
        
        local function UpdateToggle()
            if ToggleState then
                TweenService:Create(ToggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -23, 0.5, -10.5)
                }):Play()
                TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Colors.NeonPurple
                }):Play()
            else
                TweenService:Create(ToggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 2, 0.5, -10.5)
                }):Play()
                TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                }):Play()
            end
        end
        
        UpdateToggle()
        
        ToggleButton.MouseButton1Click:Connect(function()
            ToggleState = not ToggleState
            UpdateToggle()
            if callback then
                callback(ToggleState)
            end
        end)
        
        table.insert(self.Elements, ToggleFrame)
        return ToggleFrame
    end
    
    function Section:CreateSlider(name, min, max, default, callback)
        local SliderFrame = CreateInstance("Frame", {
            Name = name .. "Slider",
            BackgroundTransparency = 1,
            Size = UDim2.new(0.9, 0, 0, 60),
            Parent = SectionFrame
        })
        
        local SliderLabel = CreateInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 0),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = SliderFrame
        })
        
        local ValueLabel = CreateInstance("TextLabel", {
            Name = "ValueLabel",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 60, 0, 20),
            Position = UDim2.new(1, -60, 0, 0),
            Font = Enum.Font.Gotham,
            Text = tostring(default or min),
            TextColor3 = Colors.NeonPurple,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = SliderFrame
        })
        
        local SliderBackground = CreateInstance("Frame", {
            Name = "SliderBackground",
            BackgroundColor3 = Color3.fromRGB(40, 40, 60),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 6),
            Position = UDim2.new(0, 0, 0, 30),
            Parent = SliderFrame
        })
        
        local BackgroundCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SliderBackground
        })
        
        local SliderFill = CreateInstance("Frame", {
            Name = "SliderFill",
            BackgroundColor3 = Colors.NeonPurple,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0),
            Parent = SliderBackground
        })
        
        local FillCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SliderFill
        })
        
        local SliderKnob = CreateInstance("Frame", {
            Name = "SliderKnob",
            BackgroundColor3 = Colors.Text,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 15, 0, 15),
            Position = UDim2.new(0, 0, 0.5, -7.5),
            AnchorPoint = Vector2.new(0, 0.5),
            Parent = SliderBackground
        })
        
        local KnobCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SliderKnob
        })
        
        local KnobGlow = CreateInstance("Frame", {
            Name = "KnobGlow",
            BackgroundColor3 = Colors.NeonPurple,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 6, 1, 6),
            Position = UDim2.new(0, -3, 0, -3),
            ZIndex = 0,
            Parent = SliderKnob
        })
        
        local GlowCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = KnobGlow
        })
        
        local SliderValue = default or min
        local Dragging = false
        
        local function UpdateSlider(value)
            SliderValue = math.clamp(value, min, max)
            local percent = (SliderValue - min) / (max - min)
            
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderKnob.Position = UDim2.new(percent, 0, 0.5, -7.5)
            ValueLabel.Text = tostring(math.floor(SliderValue))
            
            if callback then
                callback(SliderValue)
            end
        end
        
        SliderBackground.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                
                local percent = (input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X
                UpdateSlider(min + (max - min) * percent)
            end
        end)
        
        SliderBackground.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = (input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X
                UpdateSlider(min + (max - min) * percent)
            end
        end)
        
        UpdateSlider(SliderValue)
        
        table.insert(self.Elements, SliderFrame)
        return SliderFrame
    end
    
    function Section:CreateDropdown(name, options, default, callback)
        local DropdownFrame = CreateInstance("Frame", {
            Name = name .. "Dropdown",
            BackgroundTransparency = 1,
            Size = UDim2.new(0.9, 0, 0, 40),
            Parent = SectionFrame
        })
        
        local DropdownLabel = CreateInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 0),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DropdownFrame
        })
        
        local DropdownButton = CreateInstance("TextButton", {
            Name = "DropdownButton",
            BackgroundColor3 = Colors.DarkBackground,
            BorderColor3 = Colors.NeonPurple,
            BorderSizePixel = 2,
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, 25),
            Font = Enum.Font.Gotham,
            Text = options[default] or "Select...",
            TextColor3 = Colors.SubText,
            TextSize = 13,
            Parent = DropdownFrame
        })
        
        local ButtonCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = DropdownButton
        })
        
        local DropdownList = CreateInstance("ScrollingFrame", {
            Name = "DropdownList",
            BackgroundColor3 = Colors.DarkBackground,
            BorderColor3 = Colors.NeonPurple,
            BorderSizePixel = 2,
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 1, 5),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Colors.NeonPurple,
            Visible = false,
            Parent = DropdownFrame
        })
        
        local ListLayout = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2),
            Parent = DropdownList
        })
        
        local ListCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = DropdownList
        })
        
        local Open = false
        
        local function ToggleDropdown()
            Open = not Open
            
            if Open then
                DropdownList.Visible = true
                DropdownList:TweenSize(UDim2.new(1, 0, 0, math.min(#options * 30, 150)), 
                    Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            else
                DropdownList:TweenSize(UDim2.new(1, 0, 0, 0), 
                    Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                wait(0.2)
                DropdownList.Visible = false
            end
        end
        
        DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
        
        for i, option in pairs(options) do
            local OptionButton = CreateInstance("TextButton", {
                Name = option,
                BackgroundColor3 = Colors.DarkBackground,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 28),
                Font = Enum.Font.Gotham,
                Text = option,
                TextColor3 = Colors.SubText,
                TextSize = 13,
                Parent = DropdownList
            })
            
            OptionButton.MouseEnter:Connect(function()
                OptionButton.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
            end)
            
            OptionButton.MouseLeave:Connect(function()
                OptionButton.BackgroundColor3 = Colors.DarkBackground
            end)
            
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = option
                if callback then
                    callback(option)
                end
                ToggleDropdown()
            end)
        end
        
        ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
        end)
        
        table.insert(self.Elements, DropdownFrame)
        return DropdownFrame
    end
    
    function Section:CreateTextbox(name, placeholder, callback)
        local TextboxFrame = CreateInstance("Frame", {
            Name = name .. "Textbox",
            BackgroundTransparency = 1,
            Size = UDim2.new(0.9, 0, 0, 60),
            Parent = SectionFrame
        })
        
        local TextboxLabel = CreateInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 0),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TextboxFrame
        })
        
        local Textbox = CreateInstance("TextBox", {
            Name = "Textbox",
            BackgroundColor3 = Colors.DarkBackground,
            BorderColor3 = Colors.NeonPurple,
            BorderSizePixel = 2,
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, 25),
            Font = Enum.Font.Gotham,
            PlaceholderText = placeholder or "Enter text...",
            PlaceholderColor3 = Color3.fromRGB(120, 120, 140),
            Text = "",
            TextColor3 = Colors.Text,
            TextSize = 14,
            ClearTextOnFocus = false,
            Parent = TextboxFrame
        })
        
        local TextboxCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = Textbox
        })
        
        Textbox.Focused:Connect(function()
            Textbox.BorderColor3 = Colors.NeonPink
        end)
        
        Textbox.FocusLost:Connect(function()
            Textbox.BorderColor3 = Colors.NeonPurple
            if callback then
                callback(Textbox.Text)
            end
        end)
        
        table.insert(self.Elements, TextboxFrame)
        return TextboxFrame
    end
    
    function Section:CreateLabel(text)
        local LabelFrame = CreateInstance("Frame", {
            Name = "LabelFrame",
            BackgroundTransparency = 1,
            Size = UDim2.new(0.9, 0, 0, 30),
            Parent = SectionFrame
        })
        
        local Label = CreateInstance("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = Colors.SubText,
            TextSize = 13,
            TextWrapped = true,
            Parent = LabelFrame
        })
        
        table.insert(self.Elements, LabelFrame)
        return LabelFrame
    end
    
    return Section
end

-- Initialize TweenService
local TweenService = game:GetService("TweenService")

-- Return the library
return BladerunnerUI
