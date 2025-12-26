-- Oxireun UI Library v2
-- Compact, fully draggable, blue theme

local OxireunUI = {}
OxireunUI.__index = OxireunUI

-- Mavi renk paleti
local Colors = {
    Background = Color3.fromRGB(20, 25, 45),
    SecondaryBg = Color3.fromRGB(30, 40, 70),
    Border = Color3.fromRGB(0, 150, 255),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Disabled = Color3.fromRGB(100, 120, 150),
    Button = Color3.fromRGB(50, 70, 120),
    Slider = Color3.fromRGB(0, 150, 255),
    ToggleOn = Color3.fromRGB(0, 150, 255),
    ToggleOff = Color3.fromRGB(70, 90, 140),
    TabActive = Color3.fromRGB(0, 150, 255),
    TabInactive = Color3.fromRGB(50, 70, 120),
    CloseButton = Color3.fromRGB(255, 200, 0), -- SARI
    MinimizeButton = Color3.fromRGB(0, 255, 0) -- LİME
}

-- Font ayarları
local Fonts = {
    Title = Enum.Font.GothamBold,
    Normal = Enum.Font.Gotham,
    Button = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold
}

-- UI Boyutları - DAHA KÜÇÜK
local UI_SIZE = {
    Width = 300,
    Height = 300
}

-- Ana Library fonksiyonu
function OxireunUI.new()
    local self = setmetatable({}, OxireunUI)
    self.Windows = {}
    return self
end

-- Yeni pencere oluşturma
function OxireunUI:NewWindow(title)
    local Window = {}
    Window.Title = title or "UI"
    Window.Sections = {}
    Window.CurrentSection = nil
    
    -- Ana ekran
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OxireunUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Ana pencere
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
    MainFrame.Position = UDim2.new(0, 20, 0.5, -UI_SIZE.Height/2)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Köşe yuvarlatma
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame
    
    -- Mavi border
    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 2
    border.Parent = MainFrame
    
    -- Başlık çubuğu
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Colors.SecondaryBg
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    titleCorner.Parent = TitleBar
    
    -- Başlık
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 8, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Window.Title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 14
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
    
    -- Minimize butonu - LİME, YUVARLAK
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Position = UDim2.new(0, 5, 0.5, -10)
    MinimizeButton.BackgroundColor3 = Colors.MinimizeButton
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Siyah yazı
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.Code -- Codlama fontu
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = Controls
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(1, 0)
    minimizeCorner.Parent = MinimizeButton
    
    -- Kapatma butonu - SARI, YUVARLAK
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(0, 30, 0.5, -10)
    CloseButton.BackgroundColor3 = Colors.CloseButton
    CloseButton.Text = ">"
    CloseButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Siyah yazı
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.Code -- Codlama fontu
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Controls
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = CloseButton
    
    -- Tab'ler için container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, -16, 0, 28)
    TabsContainer.Position = UDim2.new(0, 8, 0, 35)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = MainFrame
    
    local TabsList = Instance.new("UIListLayout")
    TabsList.FillDirection = Enum.FillDirection.Horizontal
    TabsList.Padding = UDim.new(0, 5)
    TabsList.Parent = TabsContainer
    
    -- İçerik alanı
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -16, 1, -73)
    ContentArea.Position = UDim2.new(0, 8, 0, 68)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame
    
    -- DRAGGABLE FONKSİYONLUK - TÜM PENCERE
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart, startPos
    
    local function updateDrag()
        if not dragging then return end
        
        local mouse = UserInputService:GetMouseLocation()
        local delta = Vector2.new(mouse.X, mouse.Y) - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    -- Sadece boş alanlardan draggable
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Eğer tıklanan element buton değilse
            local target = input.UserInputState == Enum.UserInputState.Begin and game:GetService("UserInputService"):GetMouseLocation()
            local elements = {CloseButton, MinimizeButton}
            local isButton = false
            
            for _, btn in pairs(elements) do
                local pos = btn.AbsolutePosition
                local size = btn.AbsoluteSize
                if target.X >= pos.X and target.X <= pos.X + size.X and
                   target.Y >= pos.Y and target.Y <= pos.Y + size.Y then
                    isButton = true
                    break
                end
            end
            
            if not isButton then
                dragging = true
                dragStart = Vector2.new(input.Position.X, input.Position.Y)
                startPos = MainFrame.Position
                
                local connection
                connection = game:GetService("RunService").Heartbeat:Connect(function()
                    updateDrag()
                end)
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if connection then
                            connection:Disconnect()
                        end
                    end
                end)
            end
        end
    end)
    
    -- Buton event'leri
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        -- ANINDA KÜÇÜLTME
        if ContentArea.Visible then
            ContentArea.Visible = false
            TabsContainer.Visible = false
            MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, 30)
        else
            ContentArea.Visible = true
            TabsContainer.Visible = true
            MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
        end
    end)
    
    -- Buton hover efektleri
    local function SetupButtonHover(button)
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = button.Name == "Close" and Color3.fromRGB(255, 220, 50) or Color3.fromRGB(50, 255, 50)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = button.Name == "Close" and Colors.CloseButton or Colors.MinimizeButton
            }):Play()
        end)
    end
    
    SetupButtonHover(CloseButton)
    SetupButtonHover(MinimizeButton)
    
    -- Buton tıklama efekti
    local function CreateClickEffect(button)
        local effect = Instance.new("Frame")
        effect.Name = "ClickEffect"
        effect.Size = UDim2.new(1, 0, 1, 0)
        effect.BackgroundColor3 = Colors.Accent
        effect.BackgroundTransparency = 0.7
        effect.ZIndex = -1
        effect.Parent = button
        
        local effectCorner = Instance.new("UICorner")
        effectCorner.CornerRadius = button:FindFirstChildWhichIsA("UICorner") and button:FindFirstChildWhichIsA("UICorner").CornerRadius or UDim.new(0, 6)
        effectCorner.Parent = effect
        
        game:GetService("TweenService"):Create(effect, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        }):Play()
        
        delay(0.2, function()
            effect:Destroy()
        end)
    end
    
    -- Yeni section ekleme fonksiyonu
    function Window:NewSection(name)
        local Section = {}
        Section.Name = name
        
        -- Tab butonu
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "_Tab"
        TabButton.Size = UDim2.new(0, 65, 0, 24)
        TabButton.BackgroundColor3 = Colors.TabInactive
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.TextSize = 12
        TabButton.Font = Fonts.Button
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabsContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = TabButton
        
        -- Section içeriği
        local SectionFrame = Instance.new("ScrollingFrame")
        SectionFrame.Name = name .. "_Content"
        SectionFrame.Size = UDim2.new(1, 0, 1, 0)
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.BorderSizePixel = 0
        SectionFrame.ScrollBarThickness = 4
        SectionFrame.ScrollBarImageColor3 = Colors.Border
        SectionFrame.Visible = false
        SectionFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        SectionFrame.Parent = ContentArea
        
        local sectionList = Instance.new("UIListLayout")
        sectionList.Padding = UDim.new(0, 6)
        sectionList.Parent = SectionFrame
        
        local sectionPadding = Instance.new("UIPadding")
        sectionPadding.PaddingTop = UDim.new(0, 5)
        sectionPadding.PaddingLeft = UDim.new(0, 5)
        sectionPadding.PaddingRight = UDim.new(0, 5)
        sectionPadding.Parent = SectionFrame
        
        -- İlk section aktif
        if #Window.Sections == 0 then
            TabButton.BackgroundColor3 = Colors.TabActive
            SectionFrame.Visible = true
            Window.CurrentSection = Section
        end
        
        -- Tab değiştirme
        TabButton.MouseButton1Click:Connect(function()
            -- Tüm tab'leri pasif yap
            for _, tab in pairs(TabsContainer:GetChildren()) do
                if tab:IsA("TextButton") then
                    tab.BackgroundColor3 = Colors.TabInactive
                end
            end
            
            -- Tüm section'ları gizle
            for _, frame in pairs(ContentArea:GetChildren()) do
                if frame:IsA("ScrollingFrame") then
                    frame.Visible = false
                end
            end
            
            -- Aktif tab ve section
            TabButton.BackgroundColor3 = Colors.TabActive
            SectionFrame.Visible = true
            Window.CurrentSection = Section
        end)
        
        -- Tab hover efekti
        TabButton.MouseEnter:Connect(function()
            if TabButton.BackgroundColor3 ~= Colors.TabActive then
                TabButton.BackgroundColor3 = Colors.Border
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabButton.BackgroundColor3 ~= Colors.TabActive then
                TabButton.BackgroundColor3 = Colors.TabInactive
            end
        end)
        
        -- Element fonksiyonları
        function Section:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Name = name
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.BackgroundColor3 = Colors.Button
            Button.Text = name
            Button.TextColor3 = Colors.Text
            Button.TextSize = 13
            Button.Font = Fonts.Button
            Button.AutoButtonColor = false
            Button.Parent = SectionFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = Button
            
            Button.MouseEnter:Connect(function()
                Button.BackgroundColor3 = Colors.Border
            end)
            
            Button.MouseLeave:Connect(function()
                Button.BackgroundColor3 = Colors.Button
            end)
            
            Button.MouseButton1Click:Connect(function()
                CreateClickEffect(Button)
                if callback then
                    callback()
                end
            end)
            
            return Button
        end
        
        function Section:CreateToggle(name, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Name = name
            Toggle.Size = UDim2.new(1, 0, 0, 32)
            Toggle.BackgroundTransparency = 1
            Toggle.Parent = SectionFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Colors.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.Font = Fonts.Bold
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "Toggle"
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleButton.BackgroundColor3 = default and Colors.ToggleOn or Colors.ToggleOff
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = Toggle
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "Circle"
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = UDim2.new(0, default and 21 or 3, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Colors.Text
            ToggleCircle.Parent = ToggleButton
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = ToggleCircle
            
            local state = default or false
            
            ToggleButton.MouseEnter:Connect(function()
                ToggleButton.BackgroundColor3 = state and Colors.Accent or Colors.Border
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                ToggleButton.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
            end)
            
            ToggleButton.MouseButton1Click:Connect(function()
                state = not state
                local targetPos = state and 21 or 3
                
                game:GetService("TweenService"):Create(ToggleCircle, TweenInfo.new(0.1), {
                    Position = UDim2.new(0, targetPos, 0.5, -8)
                }):Play()
                
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
            Slider.Size = UDim2.new(1, 0, 0, 45)
            Slider.BackgroundTransparency = 1
            Slider.Parent = SectionFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, 0, 0, 18)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name .. ": " .. default
            SliderLabel.TextColor3 = Colors.Text
            SliderLabel.TextSize = 13
            SliderLabel.Font = Fonts.Bold
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = Slider
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "Track"
            SliderTrack.Size = UDim2.new(1, 0, 0, 4)
            SliderTrack.Position = UDim2.new(0, 0, 0, 25)
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
            SliderButton.Size = UDim2.new(0, 16, 0, 16)
            SliderButton.Position = UDim2.new(SliderFill.Size.X.Scale, -8, 0.5, -8)
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
                    -8,
                    0.5,
                    -8
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
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
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
            Dropdown.Size = UDim2.new(1, 0, 0, 32)
            Dropdown.BackgroundTransparency = 1
            Dropdown.ClipsDescendants = false
            Dropdown.Parent = SectionFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 32)
            DropdownButton.BackgroundColor3 = Colors.Button
            DropdownButton.Text = options[default] or options[1] or "Select"
            DropdownButton.TextColor3 = Colors.Text
            DropdownButton.TextSize = 13
            DropdownButton.Font = Fonts.Normal
            DropdownButton.AutoButtonColor = false
            DropdownButton.Parent = Dropdown
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = DropdownButton
            
            DropdownButton.MouseEnter:Connect(function()
                DropdownButton.BackgroundColor3 = Colors.Border
            end)
            
            DropdownButton.MouseLeave:Connect(function()
                DropdownButton.BackgroundColor3 = Colors.Button
            end)
            
            local open = false
            local OptionsContainer
            
            local function CloseOptions()
                if OptionsContainer then
                    OptionsContainer:Destroy()
                    OptionsContainer = nil
                end
                open = false
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                CreateClickEffect(DropdownButton)
                
                if open then
                    CloseOptions()
                    return
                end
                
                open = true
                
                local OptionsScreenGui = Instance.new("ScreenGui")
                OptionsScreenGui.Name = "DropdownOptions"
                OptionsScreenGui.ResetOnSpawn = false
                OptionsScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                OptionsScreenGui.Parent = game:GetService("CoreGui")
                
                OptionsContainer = Instance.new("Frame")
                OptionsContainer.Name = "OptionsContainer"
                OptionsContainer.Size = UDim2.new(0, DropdownButton.AbsoluteSize.X, 0, #options * 22 + 8)
                OptionsContainer.Position = UDim2.new(0, DropdownButton.AbsolutePosition.X, 
                                                      0, DropdownButton.AbsolutePosition.Y + DropdownButton.AbsoluteSize.Y + 3)
                OptionsContainer.BackgroundColor3 = Colors.SecondaryBg
                OptionsContainer.ZIndex = 100
                OptionsContainer.Parent = OptionsScreenGui
                
                local optionsCorner = Instance.new("UICorner")
                optionsCorner.CornerRadius = UDim.new(0, 6)
                optionsCorner.Parent = OptionsContainer
                
                for i, option in pairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option
                    OptionButton.Size = UDim2.new(1, -6, 0, 20)
                    OptionButton.Position = UDim2.new(0, 3, 0, (i-1)*22 + 3)
                    OptionButton.BackgroundColor3 = Colors.Button
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Colors.Text
                    OptionButton.TextSize = 12
                    OptionButton.Font = Fonts.Normal
                    OptionButton.AutoButtonColor = false
                    OptionButton.ZIndex = 101
                    OptionButton.Parent = OptionsContainer
                    
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = OptionButton
                    
                    OptionButton.MouseEnter:Connect(function()
                        OptionButton.BackgroundColor3 = Colors.Border
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        OptionButton.BackgroundColor3 = Colors.Button
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        CreateClickEffect(OptionButton)
                        DropdownButton.Text = option
                        if callback then
                            callback(option)
                        end
                        CloseOptions()
                        OptionsScreenGui:Destroy()
                    end)
                end
                
                local function checkClickOutside(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                        local buttonPos = DropdownButton.AbsolutePosition
                        local buttonSize = DropdownButton.AbsoluteSize
                        
                        if not (mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and
                               mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y) then
                            CloseOptions()
                            OptionsScreenGui:Destroy()
                        end
                    end
                end
                
                game:GetService("UserInputService").InputBegan:Connect(checkClickOutside)
            end)
            
            return Dropdown
        end
        
        function Section:CreateTextbox(name, callback)
            local Textbox = Instance.new("Frame")
            Textbox.Name = name
            Textbox.Size = UDim2.new(1, 0, 0, 32)
            Textbox.BackgroundTransparency = 1
            Textbox.Parent = SectionFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Name = "Input"
            InputBox.Size = UDim2.new(1, 0, 1, 0)
            InputBox.BackgroundColor3 = Colors.Button
            InputBox.Text = ""
            InputBox.PlaceholderText = "Enter"
            InputBox.TextColor3 = Colors.Text
            InputBox.PlaceholderColor3 = Colors.Text
            InputBox.TextSize = 13
            InputBox.Font = Fonts.Normal
            InputBox.TextXAlignment = Enum.TextXAlignment.Center
            InputBox.Parent = Textbox
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 6)
            inputCorner.Parent = InputBox
            
            InputBox.FocusLost:Connect(function()
                if callback then
                    callback(InputBox.Text)
                end
            end)
            
            return Textbox
        end
        
        table.insert(Window.Sections, Section)
        return Section
    end
    
    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    table.insert(self.Windows, Window)
    return Window
end

return OxireunUI.new()
