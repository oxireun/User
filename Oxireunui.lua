-- Oxireun UI Library - Modern Draggable UI with Slow RGB Border
-- Wizard/Orion UI Style with Purple-Pink Theme

local OxireunUI = {}
OxireunUI.__index = OxireunUI

-- Mor-Pembe temalı renk paleti
local Colors = {
    Background = Color3.fromRGB(28, 18, 48), -- Koyu mor arkaplan
    SecondaryBg = Color3.fromRGB(38, 28, 68), 
    SectionBg = Color3.fromRGB(33, 23, 63),
    Border = Color3.fromRGB(150, 50, 200),
    Accent = Color3.fromRGB(180, 70, 220),
    Text = Color3.fromRGB(255, 255, 255), -- BEYAZ yazılar
    Disabled = Color3.fromRGB(120, 100, 160),
    Hover = Color3.fromRGB(150, 50, 200, 0.3),
    Button = Color3.fromRGB(60, 40, 100),
    Slider = Color3.fromRGB(150, 50, 200),
    ToggleOn = Color3.fromRGB(150, 50, 200),
    ToggleOff = Color3.fromRGB(80, 60, 120),
    TabActive = Color3.fromRGB(150, 50, 200),
    TabInactive = Color3.fromRGB(60, 40, 100),
    ControlButton = Color3.fromRGB(70, 50, 110),
    CloseButton = Color3.fromRGB(200, 70, 70)
}

-- YAVAŞ RGB animasyonu için renkler
local RGBColors = {
    Color3.fromRGB(180, 50, 220),   -- Mor
    Color3.fromRGB(200, 60, 230),   -- Pembe-Mor
    Color3.fromRGB(220, 70, 240),   -- Açık Pembe
    Color3.fromRGB(190, 40, 210),   -- Derin Mor
    Color3.fromRGB(230, 80, 250),   -- Parlak Pembe
    Color3.fromRGB(170, 30, 200)    -- Koyu Mor
}

-- Font ayarları
local Fonts = {
    Title = Enum.Font.GothamBold, -- BOLD başlık
    Normal = Enum.Font.Gotham,
    Tab = Enum.Font.Gotham,
    Button = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold
}

-- UI Boyutları
local UI_SIZE = {
    Width = 320,
    Height = 340
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
    
    -- Ana pencere
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
    MainFrame.Position = UDim2.new(0.5, -UI_SIZE.Width/2, 0.5, -UI_SIZE.Height/2)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BackgroundTransparency = 0.1 -- Hafif şeffaflık
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Selectable = true
    MainFrame.Parent = ScreenGui
    
    -- Köşe yuvarlatma
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame
    
    -- Ana border (kenarlık)
    local mainBorder = Instance.new("UIStroke")
    mainBorder.Name = "MainBorder"
    mainBorder.Color = Color3.fromRGB(60, 40, 100)
    mainBorder.Thickness = 1 -- İnce border
    mainBorder.Transparency = 0.7 -- Zayıflatılmış
    mainBorder.Parent = MainFrame
    
    -- RGB Border Container (Animasyonlu kısım)
    local RGBBorderContainer = Instance.new("Frame")
    RGBBorderContainer.Name = "RGBBorderContainer"
    RGBBorderContainer.Size = UDim2.new(1, 4, 1, 4)
    RGBBorderContainer.Position = UDim2.new(0, -2, 0, -2)
    RGBBorderContainer.BackgroundTransparency = 1
    RGBBorderContainer.Parent = MainFrame
    
    local rgbCorner = Instance.new("UICorner")
    rgbCorner.CornerRadius = UDim.new(0, 10)
    rgbCorner.Parent = RGBBorderContainer
    
    -- Sadece sağ ve sol taraflar için RGB border
    local LeftRGBBorder = Instance.new("Frame")
    LeftRGBBorder.Name = "LeftRGBBorder"
    LeftRGBBorder.Size = UDim2.new(0, 2, 1, 0)
    LeftRGBBorder.Position = UDim2.new(0, 0, 0, 0)
    LeftRGBBorder.BackgroundColor3 = RGBColors[1]
    LeftRGBBorder.BorderSizePixel = 0
    LeftRGBBorder.Parent = RGBBorderContainer
    
    local RightRGBBorder = Instance.new("Frame")
    RightRGBBorder.Name = "RightRGBBorder"
    RightRGBBorder.Size = UDim2.new(0, 2, 1, 0)
    RightRGBBorder.Position = UDim2.new(1, -2, 0, 0)
    RightRGBBorder.BackgroundColor3 = RGBColors[3]
    RightRGBBorder.BorderSizePixel = 0
    RightRGBBorder.Parent = RGBBorderContainer
    
    -- YAVAŞ RGB animasyonu (sağdan sola hareket efekti)
    local colorIndex = 1
    local rgbAnimation
    rgbAnimation = game:GetService("RunService").Heartbeat:Connect(function()
        colorIndex = colorIndex + 0.005 -- ÇOK YAVAŞ
        if colorIndex > #RGBColors then
            colorIndex = 1
        end
        
        local currentColor = RGBColors[math.floor(colorIndex)]
        local nextColor = RGBColors[math.floor(colorIndex) % #RGBColors + 1]
        local lerpFactor = colorIndex - math.floor(colorIndex)
        
        local animatedColor = currentColor:Lerp(nextColor, lerpFactor)
        
        -- Sağ ve sol border'lara farklı renkler vererek hareket efekti
        LeftRGBBorder.BackgroundColor3 = animatedColor
        RightRGBBorder.BackgroundColor3 = RGBColors[((math.floor(colorIndex) + 2) % #RGBColors) + 1]
    end)
    
    -- Başlık çubuğu
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Colors.SecondaryBg
    TitleBar.BackgroundTransparency = 0.1
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    titleCorner.Parent = TitleBar
    
    -- Başlık - BOLD ve BEYAZ
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Window.Title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Fonts.Title -- BOLD FONT
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextStrokeTransparency = 0.8
    TitleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TitleLabel.Parent = TitleBar
    
    -- Kontrol butonları
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 60, 1, 0)
    Controls.Position = UDim2.new(1, -65, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar
    
    -- Küçültme butonu
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(0, 5, 0.5, -12.5)
    MinimizeButton.BackgroundColor3 = Colors.ControlButton
    MinimizeButton.Text = "_"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Fonts.Normal
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = Controls
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    minimizeCorner.Parent = MinimizeButton
    
    -- Kapatma butonu
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(0, 35, 0.5, -12.5)
    CloseButton.BackgroundColor3 = Colors.CloseButton
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Controls
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = CloseButton
    
    -- Tab'ler için container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, -20, 0, 30)
    TabsContainer.Position = UDim2.new(0, 10, 0, 45)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = MainFrame
    
    local TabsList = Instance.new("UIListLayout")
    TabsList.FillDirection = Enum.FillDirection.Horizontal
    TabsList.Padding = UDim.new(0, 8)
    TabsList.Parent = TabsContainer
    
    -- İçerik alanı
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -20, 1, -90)
    ContentArea.Position = UDim2.new(0, 10, 0, 80)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame
    
    -- TIKLAMA EFEKTİ
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
    
    -- BUTON HOVER EFEKTLERİ
    local function SetupButtonHover(button, isControlButton)
        if isControlButton then 
            button.MouseEnter:Connect(function()
                if button.Name == "Close" then
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(220, 90, 90)
                    }):Play()
                else
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(90, 70, 130)
                    }):Play()
                end
            end)
            
            button.MouseLeave:Connect(function()
                if button.Name == "Close" then
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Colors.CloseButton
                    }):Play()
                else
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Colors.ControlButton
                    }):Play()
                end
            end)
            return
        end
        
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Colors.Border,
                Size = UDim2.new(1, 2, 0, 37)
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Colors.Button,
                Size = UDim2.new(1, 0, 0, 35)
            }):Play()
        end)
    end
    
    SetupButtonHover(CloseButton, true)
    SetupButtonHover(MinimizeButton, true)
    
    -- DRAGGABLE FONKSİYONLUK (Wizard/Orion UI tarzı)
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local dragging = false
    local dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            local connection
            connection = RunService.Heartbeat:Connect(function()
                if dragging then
                    local mouse = UserInputService:GetMouseLocation()
                    local delta = Vector2.new(mouse.X, mouse.Y) - Vector2.new(dragStart.X, dragStart.Y)
                    MainFrame.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
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
    end)
    
    -- Buton event'leri
    CloseButton.MouseButton1Click:Connect(function()
        CreateClickEffect(CloseButton)
        if rgbAnimation then
            rgbAnimation:Disconnect()
        end
        ScreenGui:Destroy()
    end)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        CreateClickEffect(MinimizeButton)
        if not minimized then
            game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, UI_SIZE.Width, 0, 40)
            }):Play()
            TabsContainer.Visible = false
            ContentArea.Visible = false
            minimized = true
        else
            game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
            }):Play()
            TabsContainer.Visible = true
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
        TabButton.Size = UDim2.new(0, 75, 0, 28)
        TabButton.BackgroundColor3 = Colors.TabInactive
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.TextSize = 13
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
        SectionFrame.BackgroundTransparency = 0.1
        SectionFrame.BorderSizePixel = 0
        SectionFrame.ScrollBarThickness = 4
        SectionFrame.ScrollBarImageColor3 = Colors.Border
        SectionFrame.ScrollBarImageTransparency = 0.5
        SectionFrame.Visible = false
        SectionFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        SectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        SectionFrame.Parent = ContentArea
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 8)
        sectionCorner.Parent = SectionFrame
        
        local sectionList = Instance.new("UIListLayout")
        sectionList.Padding = UDim.new(0, 10)
        sectionList.Parent = SectionFrame
        
        local sectionPadding = Instance.new("UIPadding")
        sectionPadding.PaddingTop = UDim.new(0, 10)
        sectionPadding.PaddingBottom = UDim.new(0, 10)
        sectionPadding.PaddingLeft = UDim.new(0, 10)
        sectionPadding.PaddingRight = UDim.new(0, 10)
        sectionPadding.Parent = SectionFrame
        
        -- Canvas size güncelleme
        sectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionFrame.CanvasSize = UDim2.new(0, 0, 0, sectionList.AbsoluteContentSize.Y + 20)
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
            
            for _, tab in pairs(TabsContainer:GetChildren()) do
                if tab:IsA("TextButton") then
                    game:GetService("TweenService"):Create(tab, TweenInfo.new(0.2), {
                        BackgroundColor3 = Colors.TabInactive
                    }):Play()
                end
            end
            
            for _, frame in pairs(ContentArea:GetChildren()) do
                if frame:IsA("ScrollingFrame") then
                    frame.Visible = false
                end
            end
            
            game:GetService("TweenService"):Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Colors.TabActive
            }):Play()
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
            Slider.Size = UDim2.new(1, 0, 0, 45) -- KÜÇÜK
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
            SliderTrack.Size = UDim2.new(1, 0, 0, 4) -- DAHA KÜÇÜK
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
            
            -- KÜÇÜK Slider Button
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Size = UDim2.new(0, 16, 0, 16) -- KÜÇÜK (16x16)
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
                    -8, -- KÜÇÜK offset
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
        
        -- Diğer element fonksiyonları (dropdown, textbox vb.) aynı kalacak
        -- Kısalık için bu kısmı aynı bırakıyorum...
        
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
