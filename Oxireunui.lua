-- BladeRunner UI Library
-- GitHub: https://raw.githubusercontent.com/yourusername/bladerunner-ui/main/library.lua

if game:GetService("RunService"):IsClient() then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "BladeRunner UI Loaded",
        Text = "Library initialized successfully",
        Duration = 3
    })
end

local BladeRunner = {}
BladeRunner.__index = BladeRunner

-- Color palette inspired by Blade Runner 2049
local Colors = {
    Background = Color3.fromRGB(15, 20, 30),
    Secondary = Color3.fromRGB(25, 35, 50),
    Accent = Color3.fromRGB(255, 50, 100),
    SecondaryAccent = Color3.fromRGB(0, 200, 255),
    Text = Color3.fromRGB(240, 240, 240),
    DarkText = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(50, 70, 100),
    Success = Color3.fromRGB(0, 255, 150),
    Warning = Color3.fromRGB(255, 200, 0)
}

-- Tweening service for smooth animations
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create rounded corners
local function createCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

-- Create stroke
local function createStroke(thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    return stroke
end

-- Create glow effect
local function createGlow(parent, color)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.Image = "rbxassetid://4996891970"
    glow.ImageColor3 = color
    glow.ImageTransparency = 0.8
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(49, 49, 450, 450)
    glow.Parent = parent
    return glow
end

function BladeRunner:NewWindow(title)
    local Window = {}
    setmetatable(Window, BladeRunner)
    
    -- Main GUI container
    Window.ScreenGui = Instance.new("ScreenGui")
    if syn and syn.protect_gui then
        syn.protect_gui(Window.ScreenGui)
    end
    Window.ScreenGui.Name = "BladeRunnerUI"
    Window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Window.ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main window frame
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Name = "MainWindow"
    Window.MainFrame.Size = UDim2.new(0, 400, 0, 450)
    Window.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
    Window.MainFrame.BackgroundColor3 = Colors.Background
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.Parent = Window.ScreenGui
    
    -- Add glow effect
    createGlow(Window.MainFrame, Colors.SecondaryAccent)
    
    -- Corner
    createCorner(8).Parent = Window.MainFrame
    createStroke(1, Colors.Border).Parent = Window.MainFrame
    
    -- Top bar
    Window.TopBar = Instance.new("Frame")
    Window.TopBar.Name = "TopBar"
    Window.TopBar.Size = UDim2.new(1, 0, 0, 40)
    Window.TopBar.Position = UDim2.new(0, 0, 0, 0)
    Window.TopBar.BackgroundColor3 = Colors.Secondary
    Window.TopBar.BorderSizePixel = 0
    Window.TopBar.Parent = Window.MainFrame
    
    createCorner(8, 8, 0, 0).Parent = Window.TopBar
    
    -- Title
    Window.TitleLabel = Instance.new("TextLabel")
    Window.TitleLabel.Name = "Title"
    Window.TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    Window.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    Window.TitleLabel.BackgroundTransparency = 1
    Window.TitleLabel.Text = title or "BladeRunner UI"
    Window.TitleLabel.TextColor3 = Colors.Text
    Window.TitleLabel.Font = Enum.Font.GothamBold
    Window.TitleLabel.TextSize = 18
    Window.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    Window.TitleLabel.Parent = Window.TopBar
    
    -- Control buttons
    local buttonSize = 30
    local buttonSpacing = 10
    
    -- Minimize button
    Window.MinimizeButton = Instance.new("TextButton")
    Window.MinimizeButton.Name = "Minimize"
    Window.MinimizeButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    Window.MinimizeButton.Position = UDim2.new(1, -(buttonSize * 3 + buttonSpacing * 3), 0, 5)
    Window.MinimizeButton.BackgroundColor3 = Colors.Warning
    Window.MinimizeButton.Text = "_"
    Window.MinimizeButton.TextColor3 = Colors.Text
    Window.MinimizeButton.Font = Enum.Font.GothamBold
    Window.MinimizeButton.TextSize = 16
    Window.MinimizeButton.Parent = Window.TopBar
    createCorner(buttonSize/2).Parent = Window.MinimizeButton
    
    -- Close button
    Window.CloseButton = Instance.new("TextButton")
    Window.CloseButton.Name = "Close"
    Window.CloseButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    Window.CloseButton.Position = UDim2.new(1, -(buttonSize + buttonSpacing), 0, 5)
    Window.CloseButton.BackgroundColor3 = Colors.Accent
    Window.CloseButton.Text = "X"
    Window.CloseButton.TextColor3 = Colors.Text
    Window.CloseButton.Font = Enum.Font.GothamBold
    Window.CloseButton.TextSize = 14
    Window.CloseButton.Parent = Window.TopBar
    createCorner(buttonSize/2).Parent = Window.CloseButton
    
    -- Tab container
    Window.TabContainer = Instance.new("Frame")
    Window.TabContainer.Name = "TabContainer"
    Window.TabContainer.Size = UDim2.new(1, -20, 0, 40)
    Window.TabContainer.Position = UDim2.new(0, 10, 0, 45)
    Window.TabContainer.BackgroundTransparency = 1
    Window.TabContainer.Parent = Window.MainFrame
    
    -- Content container
    Window.ContentContainer = Instance.new("Frame")
    Window.ContentContainer.Name = "Content"
    Window.ContentContainer.Size = UDim2.new(1, -20, 1, -100)
    Window.ContentContainer.Position = UDim2.new(0, 10, 0, 90)
    Window.ContentContainer.BackgroundTransparency = 1
    Window.ContentContainer.Parent = Window.MainFrame
    
    -- Scrolling frame for content
    Window.ScrollingFrame = Instance.new("ScrollingFrame")
    Window.ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    Window.ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    Window.ScrollingFrame.BackgroundTransparency = 1
    Window.ScrollingFrame.BorderSizePixel = 0
    Window.ScrollingFrame.ScrollBarThickness = 3
    Window.ScrollingFrame.ScrollBarImageColor3 = Colors.SecondaryAccent
    Window.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    Window.ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Window.ScrollingFrame.Parent = Window.ContentContainer
    
    -- UIListLayout for scrolling frame
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 10)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = Window.ScrollingFrame
    
    -- Window state
    Window.Minimized = false
    Window.OriginalSize = Window.MainFrame.Size
    Window.Sections = {}
    Window.CurrentSection = nil
    
    -- Dragging functionality
    local dragging = false
    local dragInput, dragStart, startPos
    
    Window.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Window.TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            Window.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Button events
    Window.CloseButton.MouseButton1Click:Connect(function()
        Window.ScreenGui:Destroy()
    end)
    
    Window.MinimizeButton.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Window.MainFrame:TweenSize(
                UDim2.new(Window.MainFrame.Size.X.Scale, Window.MainFrame.Size.X.Offset, 0, 40),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
            Window.MinimizeButton.Text = "+"
        else
            Window.MainFrame:TweenSize(
                Window.OriginalSize,
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
            Window.MinimizeButton.Text = "_"
        end
    end)
    
    -- Create section method
    function Window:NewSection(name)
        local Section = {}
        Section.Name = name
        Section.Elements = {}
        Section.ContentFrame = Instance.new("Frame")
        Section.ContentFrame.Name = name .. "Content"
        Section.ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        Section.ContentFrame.BackgroundTransparency = 1
        Section.ContentFrame.Visible = false
        Section.ContentFrame.Parent = Window.ScrollingFrame
        
        -- Tab button
        Section.TabButton = Instance.new("TextButton")
        Section.TabButton.Name = name .. "Tab"
        Section.TabButton.Size = UDim2.new(0, 100, 1, 0)
        Section.TabButton.BackgroundColor3 = Colors.Secondary
        Section.TabButton.Text = name
        Section.TabButton.TextColor3 = Colors.DarkText
        Section.TabButton.Font = Enum.Font.Gotham
        Section.TabButton.TextSize = 14
        Section.TabButton.Parent = Window.TabContainer
        
        createCorner(6).Parent = Section.TabButton
        createStroke(1, Colors.Border).Parent = Section.TabButton
        
        -- Position tab
        local tabCount = #Window.Sections
        Section.TabButton.Position = UDim2.new(0, (100 + 5) * tabCount, 0, 0)
        
        -- Tab selection
        Section.TabButton.MouseButton1Click:Connect(function()
            Window:SwitchSection(Section)
        end)
        
        -- Add to sections table
        table.insert(Window.Sections, Section)
        
        -- If this is the first section, make it active
        if #Window.Sections == 1 then
            Window:SwitchSection(Section)
        end
        
        -- Methods for creating UI elements
        function Section:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text .. "Button"
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Colors.Secondary
            Button.Text = text
            Button.TextColor3 = Colors.Text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.AutoButtonColor = false
            Button.Parent = self.ContentFrame
            
            createCorner(8).Parent = Button
            createStroke(1, Colors.Border).Parent = Button
            
            -- Hover effects
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 50, 70)}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Secondary}):Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                -- Click animation
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Accent}):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Secondary}):Play()
                
                -- Call callback
                if callback then
                    callback()
                end
            end)
            
            table.insert(self.Elements, Button)
            return Button
        end
        
        function Section:CreateToggle(text, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Name = text .. "Toggle"
            Toggle.Size = UDim2.new(1, 0, 0, 40)
            Toggle.BackgroundTransparency = 1
            Toggle.Parent = self.ContentFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "Label"
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Colors.Text
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "Toggle"
            ToggleButton.Size = UDim2.new(0, 50, 0, 25)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
            ToggleButton.BackgroundColor3 = Colors.Secondary
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = Toggle
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "Circle"
            ToggleCircle.Size = UDim2.new(0, 21, 0, 21)
            ToggleCircle.Position = UDim2.new(0, 2, 0.5, -10.5)
            ToggleCircle.BackgroundColor3 = Colors.DarkText
            ToggleCircle.Parent = ToggleButton
            
            -- Corners
            createCorner(12).Parent = ToggleButton
            createCorner(21/2).Parent = ToggleCircle
            createStroke(1, Colors.Border).Parent = ToggleButton
            
            local isToggled = false
            
            ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                
                if isToggled then
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Success}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                        Position = UDim2.new(1, -23, 0.5, -10.5),
                        BackgroundColor3 = Colors.Text
                    }):Play()
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Secondary}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, 2, 0.5, -10.5),
                        BackgroundColor3 = Colors.DarkText
                    }):Play()
                end
                
                if callback then
                    callback(isToggled)
                end
            end)
            
            table.insert(self.Elements, Toggle)
            return Toggle
        end
        
        function Section:CreateSlider(text, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Name = text .. "Slider"
            Slider.Size = UDim2.new(1, 0, 0, 60)
            Slider.BackgroundTransparency = 1
            Slider.Parent = self.ContentFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "Label"
            SliderLabel.Size = UDim2.new(1, 0, 0, 20)
            SliderLabel.Position = UDim2.new(0, 0, 0, 0)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = text .. ": " .. tostring(default)
            SliderLabel.TextColor3 = Colors.Text
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = Slider
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "Track"
            SliderTrack.Size = UDim2.new(1, 0, 0, 6)
            SliderTrack.Position = UDim2.new(0, 0, 0, 30)
            SliderTrack.BackgroundColor3 = Colors.Secondary
            SliderTrack.Parent = Slider
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.Position = UDim2.new(0, 0, 0, 0)
            SliderFill.BackgroundColor3 = Colors.Accent
            SliderFill.Parent = SliderTrack
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Size = UDim2.new(0, 20, 0, 20)
            SliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
            SliderButton.BackgroundColor3 = Colors.Text
            SliderButton.Text = ""
            SliderButton.AutoButtonColor = false
            SliderButton.Parent = SliderTrack
            
            -- Corners
            createCorner(3).Parent = SliderTrack
            createCorner(3).Parent = SliderFill
            createCorner(10).Parent = SliderButton
            
            local dragging = false
            
            local function updateSlider(input)
                local relativeX = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                local value = math.floor(min + (max - min) * math.clamp(relativeX, 0, 1))
                
                SliderFill.Size = UDim2.new(math.clamp(relativeX, 0, 1), 0, 1, 0)
                SliderButton.Position = UDim2.new(math.clamp(relativeX, 0, 1), -10, 0.5, -10)
                SliderLabel.Text = text .. ": " .. tostring(value)
                
                if callback then
                    callback(value)
                end
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateSlider(input)
                    dragging = true
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            table.insert(self.Elements, Slider)
            return Slider
        end
        
        function Section:CreateTextbox(text, placeholder, callback)
            local Textbox = Instance.new("Frame")
            Textbox.Name = text .. "Textbox"
            Textbox.Size = UDim2.new(1, 0, 0, 60)
            Textbox.BackgroundTransparency = 1
            Textbox.Parent = self.ContentFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Name = "Label"
            TextboxLabel.Size = UDim2.new(1, 0, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 0, 0, 0)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = text
            TextboxLabel.TextColor3 = Colors.Text
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextSize = 14
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = Textbox
            
            local TextboxInput = Instance.new("TextBox")
            TextboxInput.Name = "Input"
            TextboxInput.Size = UDim2.new(1, 0, 0, 30)
            TextboxInput.Position = UDim2.new(0, 0, 0, 25)
            TextboxInput.BackgroundColor3 = Colors.Secondary
            TextboxInput.TextColor3 = Colors.Text
            TextboxInput.PlaceholderText = placeholder or "Type here..."
            TextboxInput.PlaceholderColor3 = Colors.DarkText
            TextboxInput.Font = Enum.Font.Gotham
            TextboxInput.TextSize = 14
            TextboxInput.Text = ""
            TextboxInput.ClearTextOnFocus = false
            TextboxInput.Parent = Textbox
            
            createCorner(6).Parent = TextboxInput
            createStroke(1, Colors.Border).Parent = TextboxInput
            
            TextboxInput.Focused:Connect(function()
                TweenService:Create(TextboxInput, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 50, 70)}):Play()
            end)
            
            TextboxInput.FocusLost:Connect(function()
                TweenService:Create(TextboxInput, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Secondary}):Play()
                if callback then
                    callback(TextboxInput.Text)
                end
            end)
            
            table.insert(self.Elements, Textbox)
            return Textbox
        end
        
        function Section:CreateDropdown(text, options, default, callback)
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = text .. "Dropdown"
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            Dropdown.BackgroundTransparency = 1
            Dropdown.ClipsDescendants = true
            Dropdown.Parent = self.ContentFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundColor3 = Colors.Secondary
            DropdownButton.Text = text .. ": " .. (options[default] or "Select")
            DropdownButton.TextColor3 = Colors.Text
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 14
            DropdownButton.AutoButtonColor = false
            DropdownButton.Parent = Dropdown
            
            createCorner(6).Parent = DropdownButton
            createStroke(1, Colors.Border).Parent = DropdownButton
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "DropdownList"
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
            DropdownList.Position = UDim2.new(0, 0, 0, 45)
            DropdownList.BackgroundColor3 = Colors.Secondary
            DropdownList.Visible = false
            DropdownList.Parent = Dropdown
            
            createCorner(6).Parent = DropdownList
            createStroke(1, Colors.Border).Parent = DropdownList
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = DropdownList
            
            local open = false
            local selected = default
            
            local function toggleDropdown()
                open = not open
                if open then
                    DropdownList.Visible = true
                    DropdownList:TweenSize(
                        UDim2.new(1, 0, 0, #options * 30),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                else
                    DropdownList:TweenSize(
                        UDim2.new(1, 0, 0, 0),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true,
                        function()
                            DropdownList.Visible = false
                        end
                    )
                end
            end
            
            DropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option .. "Option"
                OptionButton.Size = UDim2.new(1, 0, 0, 28)
                OptionButton.BackgroundColor3 = Colors.Secondary
                OptionButton.Text = option
                OptionButton.TextColor3 = Colors.Text
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 14
                OptionButton.AutoButtonColor = false
                OptionButton.LayoutOrder = i
                OptionButton.Parent = DropdownList
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 50, 70)}):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Secondary}):Play()
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected = i
                    DropdownButton.Text = text .. ": " .. option
                    toggleDropdown()
                    
                    if callback then
                        callback(option, i)
                    end
                end)
            end
            
            table.insert(self.Elements, Dropdown)
            return Dropdown
        end
        
        function Section:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = text .. "Label"
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Colors.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = self.ContentFrame
            
            table.insert(self.Elements, Label)
            return Label
        end
        
        return Section
    end
    
    -- Section switching method
    function Window:SwitchSection(section)
        if self.CurrentSection then
            -- Reset old tab button
            TweenService:Create(self.CurrentSection.TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Colors.Secondary,
                TextColor3 = Colors.DarkText
            }):Play()
            self.CurrentSection.ContentFrame.Visible = false
        end
        
        -- Highlight new tab button
        TweenService:Create(section.TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Colors.Accent,
            TextColor3 = Colors.Text
        }):Play()
        section.ContentFrame.Visible = true
        
        self.CurrentSection = section
    end
    
    return Window
end

-- Make library accessible
return BladeRunner
