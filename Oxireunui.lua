-- Oxireun UI Library - Final Fixed Version
-- All issues fixed: draggable, slider, control buttons

local OxireunUI = {}
OxireunUI.__index = OxireunUI

-- İyileştirilmiş mavi renk paleti
local Colors = {
    Background = Color3.fromRGB(20, 25, 45),
    SecondaryBg = Color3.fromRGB(35, 45, 80),
    SectionBg = Color3.fromRGB(25, 35, 65),
    Border = Color3.fromRGB(0, 180, 255),
    Accent = Color3.fromRGB(0, 200, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Disabled = Color3.fromRGB(150, 150, 180),
    Hover = Color3.fromRGB(0, 180, 255, 0.3),
    Button = Color3.fromRGB(50, 80, 140),
    Slider = Color3.fromRGB(0, 180, 255),
    ToggleOn = Color3.fromRGB(0, 180, 255),
    ToggleOff = Color3.fromRGB(80, 110, 160),
    TabActive = Color3.fromRGB(0, 180, 255),
    TabInactive = Color3.fromRGB(50, 80, 140),
    ControlButton = Color3.fromRGB(60, 90, 150),
    MinimizeButton = Color3.fromRGB(70, 100, 160), -- Minimize butonu için özel renk
    CloseButton = Color3.fromRGB(200, 70, 70) -- Kapatma butonu için özel renk
}

-- Font ayarları
local Fonts = {
    Title = Enum.Font.GothamBold,
    Normal = Enum.Font.Gotham,
    Tab = Enum.Font.Gotham,
    Button = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold
}

-- UI Boyutları
local UI_SIZE = {
    Width = 310,
    Height = 320
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
    Window.Title = title or "Oxireun UI"
    Window.Sections = {}
    Window.CurrentSection = nil
    
    -- Ana ekran
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OxireunUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Ana pencere - SOLDAN AÇILIYOR
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
    MainFrame.Position = UDim2.new(0, 20, 0.5, -UI_SIZE.Height/2)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    
    -- Köşe yuvarlatma
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = MainFrame
    
    -- Mavi border
    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 2
    border.Transparency = 0
    border.Parent = MainFrame
    
    -- Başlık çubuğu
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Colors.SecondaryBg
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10, 0, 0)
    titleCorner.Parent = TitleBar
    
    -- Başlık
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Window.Title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Fonts.Title
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Kontrol butonları - UI'ye uygun renkler
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 60, 1, 0)
    Controls.Position = UDim2.new(1, -65, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar
    
    -- Küçültme butonu - "-" simgesi, UI uygun renk
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(0, 0, 0.5, -12.5)
    MinimizeButton.BackgroundColor3 = Colors.MinimizeButton
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 22
    MinimizeButton.Font = Fonts.Normal
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = Controls
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(1, 0)
    minimizeCorner.Parent = MinimizeButton
    
    -- Kapatma butonu - ">" simgesi, UI uygun renk
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(0, 30, 0.5, -12.5)
    CloseButton.BackgroundColor3 = Colors.CloseButton
    CloseButton.Text = ">"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 18
    CloseButton.Font = Fonts.Normal
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Controls
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = CloseButton
    
    -- Tab'ler için yatay scrolling frame
    local TabsScrollFrame = Instance.new("ScrollingFrame")
    TabsScrollFrame.Name = "TabsScroll"
    TabsScrollFrame.Size = UDim2.new(1, -20, 0, 30)
    TabsScrollFrame.Position = UDim2.new(0, 10, 0, 40)
    TabsScrollFrame.BackgroundTransparency = 1
    TabsScrollFrame.BorderSizePixel = 0
    TabsScrollFrame.ScrollBarThickness = 4
    TabsScrollFrame.ScrollBarImageColor3 = Colors.Border
    TabsScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabsScrollFrame.ScrollingDirection = Enum.ScrollingDirection.X
    TabsScrollFrame.Parent = MainFrame
    
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(0, 0, 1, 0)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = TabsScrollFrame
    
    local TabsList = Instance.new("UIListLayout")
    TabsList.FillDirection = Enum.FillDirection.Horizontal
    TabsList.Padding = UDim.new(0, 5)
    TabsList.Parent = TabsContainer
    
    -- İçerik alanı
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -20, 1, -80)
    ContentArea.Position = UDim2.new(0, 10, 0, 75)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame
    
    -- TIKLAMA EFEKTİ - SADECE BUTONLAR İÇİN
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
        
        game:GetService("TweenService"):Create(effect, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play()
        
        delay(0.3, function()
            effect:Destroy()
        end)
    end
    
    -- BUTON HOVER EFEKTLERİ
    local function SetupButtonHover(button, isControlButton)
        if isControlButton then 
            local originalColor = button.BackgroundColor3
            
            button.MouseEnter:Connect(function()
                game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(
                        math.min(originalColor.R * 255 + 30, 255),
                        math.min(originalColor.G * 255 + 30, 255),
                        math.min(originalColor.B * 255 + 30, 255)
                    )
                }):Play()
            end)
            
            button.MouseLeave:Connect(function()
                game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = originalColor
                }):Play()
            end)
            return
        end
        
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Colors.Border
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Colors.Button
            }):Play()
        end)
    end
    
    SetupButtonHover(CloseButton, true)
    SetupButtonHover(MinimizeButton, true)
    
    -- DRAGGABLE FONKSİYONLUK - KESİN ÇÖZÜM
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if dragging then
            local mouse = UserInputService:GetMouseLocation()
            local delta = Vector2.new(mouse.X, mouse.Y) - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Buton event'leri
    CloseButton.MouseButton1Click:Connect(function()
        CreateClickEffect(CloseButton)
        ScreenGui:Destroy()
    end)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        CreateClickEffect(MinimizeButton)
        if not minimized then
            MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, 35)
            TabsScrollFrame.Visible = false
            ContentArea.Visible = false
            minimized = true
        else
            MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
            TabsScrollFrame.Visible = true
            ContentArea.Visible = true
            minimized = false
        end
    end)
    
    -- Yeni section ekleme fonksiyonu
    function Window:NewSection(name)
        local Section = {}
        Section.Name = name
        
        -- Tab butonu oluştur
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "_Tab"
        TabButton.Size = UDim2.new(0, 70, 0, 25)
        TabButton.BackgroundColor3 = Colors.TabInactive
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.TextSize = 12
        TabButton.Font = Fonts.Tab
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabsContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = TabButton
        
        SetupButtonHover(TabButton, false)
        
        -- Section içeriği için ScrollingFrame
        local SectionFrame = Instance.new("ScrollingFrame")
        SectionFrame.Name = name .. "_Content"
        SectionFrame.Size = UDim2.new(1, 0, 1, 0)
        SectionFrame.BackgroundColor3 = Colors.SectionBg
        SectionFrame.BackgroundTransparency = 0
        SectionFrame.BorderSizePixel = 0
        SectionFrame.ScrollBarThickness = 4
        SectionFrame.ScrollBarImageColor3 = Colors.Border
        SectionFrame.Visible = false
        SectionFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        SectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        SectionFrame.Parent = ContentArea
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 8)
        sectionCorner.Parent = SectionFrame
        
        local sectionList = Instance.new("UIListLayout")
        sectionList.Padding = UDim.new(0, 8)
        sectionList.Parent = SectionFrame
        
        local sectionPadding = Instance.new("UIPadding")
        sectionPadding.PaddingTop = UDim.new(0, 8)
        sectionPadding.PaddingBottom = UDim.new(0, 8)
        sectionPadding.PaddingLeft = UDim.new(0, 8)
        sectionPadding.PaddingRight = UDim.new(0, 8)
        sectionPadding.Parent = SectionFrame
        
        -- Canvas size güncelleme
        sectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionFrame.CanvasSize = UDim2.new(0, 0, 0, sectionList.AbsoluteContentSize.Y + 16)
        end)
        
        -- İlk section'u aktif yap
        if #Window.Sections == 0 then
            TabButton.BackgroundColor3 = Colors.TabActive
            SectionFrame.Visible = true
            Window.CurrentSection = Section
        end
        
        -- Tab değiştirme
        TabButton.MouseButton1Click:Connect(function()
            CreateClickEffect(TabButton)
            
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
            
            -- Aktif tab'i ve section'u göster
            TabButton.BackgroundColor3 = Colors.TabActive
            SectionFrame.Visible = true
            Window.CurrentSection = Section
        end)
        
        -- Element oluşturma fonksiyonları
        function Section:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Name = name
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.BackgroundColor3 = Colors.Button
            Button.Text = name
            Button.TextColor3 = Colors.Text
            Button.TextSize = 14
            Button.Font = Fonts.Button
            Button.AutoButtonColor = false
            Button.Parent = SectionFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = Button
            
            SetupButtonHover(Button, false)
            
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
            Toggle.Size = UDim2.new(1, 0, 0, 35)
            Toggle.BackgroundTransparency = 1
            Toggle.Parent = SectionFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Colors.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Fonts.Bold
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "Toggle"
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -11)
            ToggleButton.BackgroundColor3 = default and Colors.ToggleOn or Colors.ToggleOff
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = Toggle
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "Circle"
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = UDim2.new(0, default and 24 or 2, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Colors.Text
            ToggleCircle.Parent = ToggleButton
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = ToggleCircle
            
            local state = default or false
            
            ToggleButton.MouseEnter:Connect(function()
                game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and Colors.Accent or Colors.Hover
                }):Play()
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
                }):Play()
            end)
            
            ToggleButton.MouseButton1Click:Connect(function()
                CreateClickEffect(ToggleButton)
                state = not state
                local targetPos = state and 24 or 2
                
                game:GetService("TweenService"):Create(ToggleCircle, TweenInfo.new(0.2), {
                    Position = UDim2.new(0, targetPos, 0.5, -9)
                }):Play()
                
                game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
                }):Play()
                
                if callback then
                    callback(state)
                end
            end)
            
            return Toggle
        end
        
        function Section:CreateSlider(name, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Name = name
            Slider.Size = UDim2.new(1, 0, 0, 50)
            Slider.BackgroundTransparency = 1
            Slider.Parent = SectionFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, 0, 0, 20)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name .. ": " .. default
            SliderLabel.TextColor3 = Colors.Text
            SliderLabel.TextSize = 14
            SliderLabel.Font = Fonts.Bold
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = Slider
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "Track"
            SliderTrack.Size = UDim2.new(1, 0, 0, 5)
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
            SliderButton.Size = UDim2.new(0, 18, 0, 18)
            SliderButton.Position = UDim2.new(SliderFill.Size.X.Scale, -9, 0.5, -9)
            SliderButton.BackgroundColor3 = Colors.Text
            SliderButton.Text = ""
            SliderButton.AutoButtonColor = false
            SliderButton.Parent = SliderTrack
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(1, 0)
            btnCorner.Parent = SliderButton
            
            local dragging = false
            
            local function updateSlider()
                if not dragging then return end
                
                local mouse = UserInputService:GetMouseLocation()
                local relativeX = (mouse.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                local pos = math.clamp(relativeX, 0, 1)
                
                SliderButton.Position = UDim2.new(pos, -9, 0.5, -9)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                
                local value = math.floor(min + (pos * (max - min)))
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
                    local relativeX = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                    local pos = math.clamp(relativeX, 0, 1)
                    
                    SliderButton.Position = UDim2.new(pos, -9, 0.5, -9)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    
                    local value = math.floor(min + (pos * (max - min)))
                    SliderLabel.Text = name .. ": " .. value
                    
                    if callback then
                        callback(value)
                    end
                end
            end)
            
            game:GetService("RunService").Heartbeat:Connect(function()
                if dragging then
                    updateSlider()
                end
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            return Slider
        end
        
        function Section:CreateDropdown(name, options, default, callback)
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = name
            Dropdown.Size = UDim2.new(1, 0, 0, 35)
            Dropdown.BackgroundTransparency = 1
            Dropdown.ClipsDescendants = false
            Dropdown.Parent = SectionFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 35)
            DropdownButton.BackgroundColor3 = Colors.Button
            DropdownButton.Text = options[default] or options[1] or "Select"
            DropdownButton.TextColor3 = Colors.Text
            DropdownButton.TextSize = 14
            DropdownButton.Font = Fonts.Normal
            DropdownButton.AutoButtonColor = false
            DropdownButton.Parent = Dropdown
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = DropdownButton
            
            SetupButtonHover(DropdownButton, false)
            
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
                
                -- Options için ScreenGui
                local OptionsScreenGui = Instance.new("ScreenGui")
                OptionsScreenGui.Name = "DropdownOptions"
                OptionsScreenGui.ResetOnSpawn = false
                OptionsScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                OptionsScreenGui.Parent = game:GetService("CoreGui")
                
                -- Options container
                OptionsContainer = Instance.new("Frame")
                OptionsContainer.Name = "OptionsContainer"
                OptionsContainer.Size = UDim2.new(0, DropdownButton.AbsoluteSize.X, 0, #options * 25 + 10)
                OptionsContainer.Position = UDim2.new(0, DropdownButton.AbsolutePosition.X, 
                                                      0, DropdownButton.AbsolutePosition.Y + DropdownButton.AbsoluteSize.Y + 5)
                OptionsContainer.BackgroundColor3 = Colors.SectionBg
                OptionsContainer.BorderSizePixel = 0
                OptionsContainer.ZIndex = 100
                OptionsContainer.Parent = OptionsScreenGui
                
                local optionsCorner = Instance.new("UICorner")
                optionsCorner.CornerRadius = UDim.new(0, 6)
                optionsCorner.Parent = OptionsContainer
                
                for i, option in pairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option
                    OptionButton.Size = UDim2.new(1, -10, 0, 22)
                    OptionButton.Position = UDim2.new(0, 5, 0, (i-1)*25 + 5)
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
                
                -- Mouse dışında tıklayınca kapat
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
            Textbox.Size = UDim2.new(1, 0, 0, 35)
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
            InputBox.TextSize = 14
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
    
    -- Pencereyi parent'e ekle
    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    table.insert(self.Windows, Window)
    return Window
end

-- Library'yi döndür
return OxireunUI.new()
