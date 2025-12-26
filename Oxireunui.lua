-- Blade Runner 2049 Neon UI Library
-- GitHub için hazırlanmıştır

local BladeRunnerUI = {}
BladeRunnerUI.__index = BladeRunnerUI

-- Renk paleti (Blade Runner 2049 neon mor temalı)
local Colors = {
    Background = Color3.fromRGB(10, 10, 15),
    SecondaryBg = Color3.fromRGB(20, 20, 30),
    Border = Color3.fromRGB(138, 43, 226), -- Neon mor
    Accent = Color3.fromRGB(148, 0, 211), -- Daha parlak mor
    Text = Color3.fromRGB(240, 240, 255),
    Disabled = Color3.fromRGB(100, 100, 120),
    Hover = Color3.fromRGB(138, 43, 226, 0.3),
    Button = Color3.fromRGB(30, 30, 45),
    Slider = Color3.fromRGB(138, 43, 226),
    ToggleOn = Color3.fromRGB(138, 43, 226),
    ToggleOff = Color3.fromRGB(60, 60, 80)
}

-- Fontlar
local Fonts = {
    Title = Enum.Font.SciFi,
    Normal = Enum.Font.Gotham,
    Monospace = Enum.Font.Code
}

-- Animasyon servisi
local TweenService = game:GetService("TweenService")

-- Yardımcı fonksiyonlar
local function RippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.7
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local tween = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function CreateGlow(frame, color)
    local glow = Instance.new("UIStroke")
    glow.Name = "Glow"
    glow.Color = color
    glow.Thickness = 2
    glow.Transparency = 0.7
    glow.Parent = frame
    
    local glowTween = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.3
    })
    glowTween:Play()
    
    return glow
end

-- Ana Library fonksiyonu
function BladeRunnerUI.new()
    local self = setmetatable({}, BladeRunnerUI)
    self.Windows = {}
    return self
end

-- Yeni pencere oluşturma
function BladeRunnerUI:NewWindow(title)
    local Window = {}
    Window.Title = title or "Blade Runner UI"
    Window.Sections = {}
    Window.CurrentSection = nil
    
    -- Ana ekran
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BladeRunnerUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    -- Ana pencere
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0, 20, 0.5, -250)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Köşe yuvarlatma
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = MainFrame
    
    -- Neon border
    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 2
    border.Parent = MainFrame
    
    -- Başlık çubuğu
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Colors.SecondaryBg
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    titleCorner.Parent = TitleBar
    
    -- Başlık
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Window.Title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Fonts.Title
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Kontrol butonları
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 60, 1, 0)
    Controls.Position = UDim2.new(1, -65, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar
    
    -- Kapatma butonu
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(0, 30, 0.5, -12.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 20
    CloseButton.Font = Fonts.Normal
    CloseButton.Parent = Controls
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = CloseButton
    
    -- Küçültme butonu
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(0, 0, 0.5, -12.5)
    MinimizeButton.BackgroundColor3 = Colors.Button
    MinimizeButton.Text = "–"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Fonts.Normal
    MinimizeButton.Parent = Controls
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    minimizeCorner.Parent = MinimizeButton
    
    -- Section sekmeleri
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "Tabs"
    TabsContainer.Size = UDim2.new(1, -30, 0, 40)
    TabsContainer.Position = UDim2.new(0, 15, 0, 50)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = MainFrame
    
    local TabsList = Instance.new("UIListLayout")
    TabsList.FillDirection = Enum.FillDirection.Horizontal
    TabsList.Padding = UDim.new(0, 5)
    TabsList.Parent = TabsContainer
    
    -- İçerik alanı
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -30, 1, -110)
    ContentFrame.Position = UDim2.new(0, 15, 0, 100)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 10)
    ContentList.Parent = ContentFrame
    
    -- Sürükleme fonksiyonelliği
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                          startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Buton event'leri
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        if MainFrame.Size.Y.Offset == 500 then
            MainFrame:TweenSize(UDim2.new(0, 400, 0, 100), "Out", "Quad", 0.3, true)
            ContentFrame.Visible = false
            TabsContainer.Visible = false
        else
            MainFrame:TweenSize(UDim2.new(0, 400, 0, 500), "Out", "Quad", 0.3, true)
            ContentFrame.Visible = true
            TabsContainer.Visible = true
        end
    end)
    
    -- Buton hover efektleri
    local function SetupButtonHover(button)
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Colors.Border
            CreateGlow(button, Colors.Accent)
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Colors.Button
            if button:FindFirstChild("Glow") then
                button.Glow:Destroy()
            end
        end)
    end
    
    SetupButtonHover(CloseButton)
    SetupButtonHover(MinimizeButton)
    
    -- Yeni section ekleme fonksiyonu
    function Window:NewSection(name)
        local Section = {}
        Section.Name = name
        Section.Elements = {}
        
        -- Sekme butonu
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(0, 80, 0, 30)
        TabButton.BackgroundColor3 = Colors.Button
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.TextSize = 14
        TabButton.Font = Fonts.Normal
        TabButton.Parent = TabsContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = TabButton
        
        -- Sekme içerik çerçevesi
        local SectionFrame = Instance.new("ScrollingFrame")
        SectionFrame.Name = name .. "_Content"
        SectionFrame.Size = UDim2.new(1, 0, 1, 0)
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.BorderSizePixel = 0
        SectionFrame.ScrollBarThickness = 4
        SectionFrame.ScrollBarImageColor3 = Colors.Border
        SectionFrame.Visible = false
        SectionFrame.Parent = ContentFrame
        
        local sectionList = Instance.new("UIListLayout")
        sectionList.Padding = UDim.new(0, 8)
        sectionList.Parent = SectionFrame
        
        -- İlk section'u aktif yap
        if #Window.Sections == 0 then
            TabButton.BackgroundColor3 = Colors.Border
            SectionFrame.Visible = true
            Window.CurrentSection = Section
        end
        
        -- Sekme değiştirme
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(TabsContainer:GetChildren()) do
                if tab:IsA("TextButton") then
                    tab.BackgroundColor3 = Colors.Button
                end
            end
            
            for _, frame in pairs(ContentFrame:GetChildren()) do
                if frame:IsA("ScrollingFrame") then
                    frame.Visible = false
                end
            end
            
            TabButton.BackgroundColor3 = Colors.Border
            SectionFrame.Visible = true
            Window.CurrentSection = Section
        end)
        
        SetupButtonHover(TabButton)
        
        -- Element oluşturma fonksiyonları
        function Section:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Name = name
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Colors.Button
            Button.Text = name
            Button.TextColor3 = Colors.Text
            Button.TextSize = 14
            Button.Font = Fonts.Normal
            Button.AutoButtonColor = false
            Button.Parent = SectionFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = Button
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Colors.Border
            btnStroke.Thickness = 1
            btnStroke.Parent = Button
            
            SetupButtonHover(Button)
            
            Button.MouseButton1Click:Connect(function()
                RippleEffect(Button)
                if callback then
                    callback()
                end
            end)
            
            return Button
        end
        
        function Section:CreateToggle(name, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Name = name
            Toggle.Size = UDim2.new(1, 0, 0, 40)
            Toggle.BackgroundTransparency = 1
            Toggle.Parent = SectionFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Colors.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Fonts.Normal
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "Toggle"
            ToggleButton.Size = UDim2.new(0, 50, 0, 25)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
            ToggleButton.BackgroundColor3 = default and Colors.ToggleOn or Colors.ToggleOff
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = Toggle
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "Circle"
            ToggleCircle.Size = UDim2.new(0, 19, 0, 19)
            ToggleCircle.Position = UDim2.new(0, default and 27 or 3, 0.5, -9.5)
            ToggleCircle.BackgroundColor3 = Colors.Text
            ToggleCircle.Parent = ToggleButton
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = ToggleCircle
            
            local state = default or false
            
            ToggleButton.MouseButton1Click:Connect(function()
                state = not state
                local targetPos = state and 27 or 3
                
                ToggleCircle:TweenPosition(UDim2.new(0, targetPos, 0.5, -9.5), "Out", "Quad", 0.2, true)
                ToggleButton.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
                
                if callback then
                    callback(state)
                end
            end)
            
            return Toggle
        end
        
        function Section:CreateSlider(name, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Name = name
            Slider.Size = UDim2.new(1, 0, 0, 60)
            Slider.BackgroundTransparency = 1
            Slider.Parent = SectionFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, 0, 0, 20)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name .. ": " .. default
            SliderLabel.TextColor3 = Colors.Text
            SliderLabel.TextSize = 14
            SliderLabel.Font = Fonts.Normal
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = Slider
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "Track"
            SliderTrack.Size = UDim2.new(1, 0, 0, 6)
            SliderTrack.Position = UDim2.new(0, 0, 0, 30)
            SliderTrack.BackgroundColor3 = Colors.ToggleOff
            SliderTrack.Parent = Slider
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = SliderTrack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Colors.Slider
            SliderFill.Parent = SliderTrack
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Size = UDim2.new(0, 20, 0, 20)
            SliderButton.Position = UDim2.new(SliderFill.Size.X.Scale, -10, 0.5, -10)
            SliderButton.BackgroundColor3 = Colors.Text
            SliderButton.Text = ""
            SliderButton.AutoButtonColor = false
            SliderButton.Parent = SliderTrack
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(1, 0)
            btnCorner.Parent = SliderButton
            
            local dragging = false
            
            local function updateSlider(input)
                local pos = UDim2.new(
                    math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1),
                    -10,
                    0.5,
                    -10
                )
                SliderButton.Position = pos
                SliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
                
                local value = math.floor(min + (pos.X.Scale * (max - min)))
                SliderLabel.Text = name .. ": " .. value
                
                if callback then
                    callback(value)
                end
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            return Slider
        end
        
        function Section:CreateDropdown(name, options, default, callback)
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = name
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            Dropdown.BackgroundTransparency = 1
            Dropdown.ClipsDescendants = true
            Dropdown.Parent = SectionFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundColor3 = Colors.Button
            DropdownButton.Text = name .. ": " .. (options[default] or "Select")
            DropdownButton.TextColor3 = Colors.Text
            DropdownButton.TextSize = 14
            DropdownButton.Font = Fonts.Normal
            DropdownButton.AutoButtonColor = false
            DropdownButton.Parent = Dropdown
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = DropdownButton
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Name = "Options"
            OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
            OptionsFrame.Position = UDim2.new(0, 0, 0, 45)
            OptionsFrame.BackgroundColor3 = Colors.SecondaryBg
            OptionsFrame.Parent = Dropdown
            
            local optionsCorner = Instance.new("UICorner")
            optionsCorner.CornerRadius = UDim.new(0, 8)
            optionsCorner.Parent = OptionsFrame
            
            local OptionsList = Instance.new("UIListLayout")
            OptionsList.Parent = OptionsFrame
            
            local open = false
            
            for i, option in pairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Colors.Button
                OptionButton.Text = option
                OptionButton.TextColor3 = Colors.Text
                OptionButton.TextSize = 14
                OptionButton.Font = Fonts.Normal
                OptionButton.AutoButtonColor = false
                OptionButton.Visible = false
                OptionButton.Parent = OptionsFrame
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 6)
                optionCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = name .. ": " .. option
                    if callback then
                        callback(option)
                    end
                    
                    DropdownButton.BackgroundColor3 = Colors.Button
                    Dropdown:TweenSize(UDim2.new(1, 0, 0, 40), "Out", "Quad", 0.2, true)
                    wait(0.2)
                    for _, btn in pairs(OptionsFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.Visible = false
                        end
                    end
                    open = false
                end)
                
                SetupButtonHover(OptionButton)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                open = not open
                
                if open then
                    DropdownButton.BackgroundColor3 = Colors.Border
                    local optionCount = 0
                    for _, btn in pairs(OptionsFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            optionCount = optionCount + 1
                        end
                    end
                    
                    Dropdown:TweenSize(UDim2.new(1, 0, 0, 40 + (optionCount * 35)), "Out", "Quad", 0.2, true)
                    wait(0.2)
                    for _, btn in pairs(OptionsFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.Visible = true
                        end
                    end
                else
                    DropdownButton.BackgroundColor3 = Colors.Button
                    Dropdown:TweenSize(UDim2.new(1, 0, 0, 40), "Out", "Quad", 0.2, true)
                    wait(0.2)
                    for _, btn in pairs(OptionsFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.Visible = false
                        end
                    end
                end
            end)
            
            SetupButtonHover(DropdownButton)
            
            return Dropdown
        end
        
        function Section:CreateTextbox(name, placeholder, callback)
            local Textbox = Instance.new("Frame")
            Textbox.Name = name
            Textbox.Size = UDim2.new(1, 0, 0, 40)
            Textbox.BackgroundTransparency = 1
            Textbox.Parent = SectionFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(0.3, 0, 1, 0)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = name
            TextboxLabel.TextColor3 = Colors.Text
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Fonts.Normal
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = Textbox
            
            local InputBox = Instance.new("TextBox")
            InputBox.Name = "Input"
            InputBox.Size = UDim2.new(0.7, 0, 0, 40)
            InputBox.Position = UDim2.new(0.3, 0, 0, 0)
            InputBox.BackgroundColor3 = Colors.Button
            InputBox.Text = ""
            InputBox.PlaceholderText = placeholder or "Enter text..."
            InputBox.TextColor3 = Colors.Text
            InputBox.PlaceholderColor3 = Colors.Disabled
            InputBox.TextSize = 14
            InputBox.Font = Fonts.Normal
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.Parent = Textbox
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 8)
            inputCorner.Parent = InputBox
            
            local inputPadding = Instance.new("UIPadding")
            inputPadding.PaddingLeft = UDim.new(0, 10)
            inputPadding.Parent = InputBox
            
            InputBox.Focused:Connect(function()
                CreateGlow(InputBox, Colors.Accent)
            end)
            
            InputBox.FocusLost:Connect(function()
                if InputBox:FindFirstChild("Glow") then
                    InputBox.Glow:Destroy()
                end
                
                if callback then
                    callback(InputBox.Text)
                end
            end)
            
            return Textbox
        end
        
        table.insert(Window.Sections, Section)
        return Section
    end
    
    -- Pencereyi parent'e ekle
    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    table.insert(self.Windows, Window)
    return Window
end

-- Library'yi döndür
return BladeRunnerUI.new()
