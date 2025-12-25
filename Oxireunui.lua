-- Oxireun UI Library v1.0
-- Blade Runner 2049 Tema
-- Tüm executor'lerde çalışır

local OxireunUILib = {}
OxireunUILib.__index = OxireunUILib

-- Servisler
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Renkler
local Colors = {
    Primary = Color3.fromRGB(0, 150, 255),
    Secondary = Color3.fromRGB(25, 20, 45),
    Background = Color3.fromRGB(30, 25, 55),
    Dark = Color3.fromRGB(20, 15, 40),
    Light = Color3.fromRGB(180, 200, 255),
    Text = Color3.fromRGB(220, 220, 240),
    Error = Color3.fromRGB(240, 120, 130),
    Success = Color3.fromRGB(0, 200, 150)
}

-- Ana GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OxireunUILib"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Pencere yönetimi
local Windows = {}
local WindowCount = 0

-- Yeni Pencere oluştur
function OxireunUILib:NewWindow(title)
    WindowCount = WindowCount + 1
    
    local Window = {}
    setmetatable(Window, OxireunUILib)
    
    Window.Title = title or "Window"
    Window.Sections = {}
    Window.Elements = {}
    Window.Connections = {}
    
    -- Pencere pozisyonu (üst üste binmemesi için)
    local offsetX = 0.03 + ((WindowCount - 1) * 0.02)
    local offsetY = 0.05 + ((WindowCount - 1) * 0.03)
    
    -- ANA PENCERE
    Window.Main = Instance.new("Frame")
    Window.Main.Size = UDim2.new(0, 400, 0, 500)
    Window.Main.Position = UDim2.new(offsetX, 0, offsetY, 0)
    Window.Main.BackgroundColor3 = Colors.Secondary
    Window.Main.BackgroundTransparency = 0
    Window.Main.BorderSizePixel = 0
    Window.Main.Active = true
    Window.Main.Draggable = true
    Window.Main.Parent = ScreenGui
    Window.Main.Name = title .. "_Window"
    
    -- Köşe yuvarlatma
    local mainCorner = Instance.new("UICorner", Window.Main)
    mainCorner.CornerRadius = UDim.new(0, 12)
    
    -- NEON BORDER
    local mainGlow = Instance.new("UIStroke", Window.Main)
    mainGlow.Color = Colors.Primary
    mainGlow.Thickness = 3
    mainGlow.Transparency = 0.2
    
    -- ÜST BAR
    Window.TopBar = Instance.new("Frame", Window.Main)
    Window.TopBar.Size = UDim2.new(1, 0, 0, 45)
    Window.TopBar.Position = UDim2.new(0, 0, 0, 0)
    Window.TopBar.BackgroundColor3 = Colors.Dark
    Window.TopBar.BackgroundTransparency = 0
    Window.TopBar.BorderSizePixel = 0
    
    local topBarCorner = Instance.new("UICorner", Window.TopBar)
    topBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    
    -- Üst bar alt çizgisi
    local topBarLine = Instance.new("Frame", Window.TopBar)
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = Colors.Primary
    topBarLine.BorderSizePixel = 0
    
    -- BAŞLIK
    Window.TitleLabel = Instance.new("TextLabel", Window.TopBar)
    Window.TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    Window.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    Window.TitleLabel.BackgroundTransparency = 1
    Window.TitleLabel.Text = title
    Window.TitleLabel.TextColor3 = Colors.Light
    Window.TitleLabel.Font = Enum.Font.GothamBold
    Window.TitleLabel.TextSize = 16
    Window.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- KONTROL BUTONLARI
    local controlButtons = Instance.new("Frame", Window.TopBar)
    controlButtons.Size = UDim2.new(0, 60, 1, 0)
    controlButtons.Position = UDim2.new(1, -65, 0, 0)
    controlButtons.BackgroundTransparency = 1
    
    -- Close butonu
    Window.CloseBtn = Instance.new("TextButton", controlButtons)
    Window.CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    Window.CloseBtn.Position = UDim2.new(1, -30, 0.5, -13)
    Window.CloseBtn.BackgroundColor3 = Colors.Error
    Window.CloseBtn.BackgroundTransparency = 0.6
    Window.CloseBtn.BorderSizePixel = 0
    Window.CloseBtn.Text = ""
    local closeCorner = Instance.new("UICorner", Window.CloseBtn)
    closeCorner.CornerRadius = UDim.new(0, 6)
    
    local closeLine1 = Instance.new("Frame", Window.CloseBtn)
    closeLine1.Size = UDim2.new(0, 12, 0, 2)
    closeLine1.Position = UDim2.new(0.5, -6, 0.5, -1)
    closeLine1.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    closeLine1.BorderSizePixel = 0
    closeLine1.Rotation = 45
    
    local closeLine2 = Instance.new("Frame", Window.CloseBtn)
    closeLine2.Size = UDim2.new(0, 12, 0, 2)
    closeLine2.Position = UDim2.new(0.5, -6, 0.5, -1)
    closeLine2.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    closeLine2.BorderSizePixel = 0
    closeLine2.Rotation = -45
    
    -- İÇERİK ALANI
    Window.Content = Instance.new("Frame", Window.Main)
    Window.Content.Size = UDim2.new(1, -20, 1, -65)
    Window.Content.Position = UDim2.new(0, 10, 0, 50)
    Window.Content.BackgroundColor3 = Colors.Background
    Window.Content.BackgroundTransparency = 0
    Window.Content.BorderSizePixel = 0
    Window.Content.ClipsDescendants = true
    local contentCorner = Instance.new("UICorner", Window.Content)
    contentCorner.CornerRadius = UDim.new(0, 8)
    
    -- Scroll container
    Window.Scroll = Instance.new("ScrollingFrame", Window.Content)
    Window.Scroll.Size = UDim2.new(1, 0, 1, 0)
    Window.Scroll.Position = UDim2.new(0, 0, 0, 0)
    Window.Scroll.BackgroundTransparency = 1
    Window.Scroll.BorderSizePixel = 0
    Window.Scroll.ScrollBarThickness = 4
    Window.Scroll.ScrollBarImageColor3 = Colors.Primary
    Window.Scroll.ScrollBarImageTransparency = 0.7
    Window.Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    Window.Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Window.Scroll.HorizontalScrollBarInset = Enum.ScrollBarInset.None
    Window.Scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    Window.Scroll.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    
    -- Scroll içeriği
    Window.ScrollContent = Instance.new("Frame", Window.Scroll)
    Window.ScrollContent.Size = UDim2.new(1, 0, 0, 0)
    Window.ScrollContent.BackgroundTransparency = 1
    
    -- Buton hover efektleri
    local function setupButtonHover(button, normalColor, hoverColor)
        table.insert(Window.Connections, button.MouseEnter:Connect(function()
            button.BackgroundTransparency = 0.4
            if button:IsA("TextButton") then
                button.TextColor3 = hoverColor
            end
        end))
        
        table.insert(Window.Connections, button.MouseLeave:Connect(function()
            button.BackgroundTransparency = 0.6
            if button:IsA("TextButton") then
                button.TextColor3 = normalColor
            end
        end))
    end
    
    setupButtonHover(Window.CloseBtn, Colors.Error, Color3.fromRGB(255, 140, 150))
    
    -- Close butonu fonksiyonu
    Window.CloseBtn.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)
    
    -- Pencereyi sürükleme
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        Window.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    Window.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Window.Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Window.TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
    
    table.insert(Windows, Window)
    return Window
end

-- Section oluştur
function OxireunUILib:NewSection(name)
    local Section = {}
    Section.Name = name
    Section.Elements = {}
    Section.Connections = {}
    
    -- Section container
    Section.Container = Instance.new("Frame", self.ScrollContent)
    Section.Container.Size = UDim2.new(1, -10, 0, 0)
    Section.Container.Position = UDim2.new(0, 5, 0, #self.Sections * 200)
    Section.Container.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
    Section.Container.BackgroundTransparency = 0.2
    Section.Container.BorderSizePixel = 0
    Section.Container.AutomaticSize = Enum.AutomaticSize.Y
    local containerCorner = Instance.new("UICorner", Section.Container)
    containerCorner.CornerRadius = UDim.new(0, 8)
    
    -- Section başlığı
    Section.Title = Instance.new("TextLabel", Section.Container)
    Section.Title.Size = UDim2.new(1, -20, 0, 25)
    Section.Title.Position = UDim2.new(0, 10, 0, 0)
    Section.Title.BackgroundTransparency = 1
    Section.Title.Text = name
    Section.Title.TextColor3 = Colors.Primary
    Section.Title.Font = Enum.Font.GothamBold
    Section.Title.TextSize = 13
    Section.Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Section alt çizgisi
    Section.Line = Instance.new("Frame", Section.Container)
    Section.Line.Size = UDim2.new(1, 0, 0, 1)
    Section.Line.Position = UDim2.new(0, 0, 0, 25)
    Section.Line.BackgroundColor3 = Colors.Primary
    Section.Line.BorderSizePixel = 0
    Section.Line.Transparency = 0.3
    
    -- Elementleri tutacak container
    Section.ElementsContainer = Instance.new("Frame", Section.Container)
    Section.ElementsContainer.Size = UDim2.new(1, -20, 0, 0)
    Section.ElementsContainer.Position = UDim2.new(0, 10, 0, 35)
    Section.ElementsContainer.BackgroundTransparency = 1
    Section.ElementsContainer.AutomaticSize = Enum.AutomaticSize.Y
    
    table.insert(self.Sections, Section)
    
    -- Element oluşturma fonksiyonları
    function Section:CreateButton(text, callback)
        local Button = Instance.new("TextButton", self.ElementsContainer)
        Button.Size = UDim2.new(1, 0, 0, 30)
        Button.Position = UDim2.new(0, 0, 0, #self.Elements * 40)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
        Button.BackgroundTransparency = 0.5
        Button.BorderSizePixel = 0
        Button.Text = text
        Button.TextColor3 = Colors.Primary
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 12
        local btnCorner = Instance.new("UICorner", Button)
        btnCorner.CornerRadius = UDim.new(0, 6)
        
        -- Hover efekti
        Button.MouseEnter:Connect(function()
            Button.BackgroundTransparency = 0.3
        end)
        
        Button.MouseLeave:Connect(function()
            Button.BackgroundTransparency = 0.5
        end)
        
        -- Click event
        Button.MouseButton1Click:Connect(function()
            if callback then
                pcall(callback)
            end
        end)
        
        table.insert(self.Elements, Button)
        self.Container.Size = UDim2.new(1, -10, 0, 35 + (#self.Elements * 40))
        return Button
    end
    
    function Section:CreateToggle(text, callback, default)
        local Toggle = {}
        Toggle.State = default or false
        
        local ToggleFrame = Instance.new("Frame", self.ElementsContainer)
        ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
        ToggleFrame.Position = UDim2.new(0, 0, 0, #self.Elements * 40)
        ToggleFrame.BackgroundTransparency = 1
        
        -- Label
        Toggle.Label = Instance.new("TextLabel", ToggleFrame)
        Toggle.Label.Size = UDim2.new(0.7, 0, 1, 0)
        Toggle.Label.Position = UDim2.new(0, 0, 0, 0)
        Toggle.Label.BackgroundTransparency = 1
        Toggle.Label.Text = text
        Toggle.Label.TextColor3 = Colors.Text
        Toggle.Label.Font = Enum.Font.Gotham
        Toggle.Label.TextSize = 12
        Toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Toggle background
        Toggle.Background = Instance.new("Frame", ToggleFrame)
        Toggle.Background.Size = UDim2.new(0, 45, 0, 24)
        Toggle.Background.Position = UDim2.new(1, -50, 0.5, -12)
        Toggle.Background.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
        Toggle.Background.BorderSizePixel = 0
        local bgCorner = Instance.new("UICorner", Toggle.Background)
        bgCorner.CornerRadius = UDim.new(1, 0)
        
        -- Toggle circle
        Toggle.Circle = Instance.new("Frame", Toggle.Background)
        Toggle.Circle.Size = UDim2.new(0, 20, 0, 20)
        Toggle.Circle.Position = UDim2.new(0, 2, 0.5, -10)
        Toggle.Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.Circle.BorderSizePixel = 0
        local circleCorner = Instance.new("UICorner", Toggle.Circle)
        circleCorner.CornerRadius = UDim.new(1, 0)
        
        -- Toggle button
        Toggle.Button = Instance.new("TextButton", ToggleFrame)
        Toggle.Button.Size = UDim2.new(0, 45, 0, 24)
        Toggle.Button.Position = UDim2.new(1, -50, 0.5, -12)
        Toggle.Button.BackgroundTransparency = 1
        Toggle.Button.Text = ""
        
        -- Toggle function
        local function updateToggle()
            if Toggle.State then
                Toggle.Background.BackgroundColor3 = Colors.Primary
                Toggle.Circle.Position = UDim2.new(1, -22, 0.5, -10)
            else
                Toggle.Background.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                Toggle.Circle.Position = UDim2.new(0, 2, 0.5, -10)
            end
        end
        
        Toggle.Button.MouseButton1Click:Connect(function()
            Toggle.State = not Toggle.State
            updateToggle()
            if callback then
                pcall(callback, Toggle.State)
            end
        end)
        
        -- Hover efekti
        Toggle.Button.MouseEnter:Connect(function()
            Toggle.Background.BackgroundTransparency = 0.1
        end)
        
        Toggle.Button.MouseLeave:Connect(function()
            Toggle.Background.BackgroundTransparency = 0
        end)
        
        -- Başlangıç durumu
        updateToggle()
        
        table.insert(self.Elements, ToggleFrame)
        self.Container.Size = UDim2.new(1, -10, 0, 35 + (#self.Elements * 40))
        return Toggle
    end
    
    function Section:CreateTextbox(text, callback, placeholder)
        local TextboxFrame = Instance.new("Frame", self.ElementsContainer)
        TextboxFrame.Size = UDim2.new(1, 0, 0, 30)
        TextboxFrame.Position = UDim2.new(0, 0, 0, #self.Elements * 40)
        TextboxFrame.BackgroundTransparency = 1
        
        -- Label
        local textboxLabel = Instance.new("TextLabel", TextboxFrame)
        textboxLabel.Size = UDim2.new(0.4, 0, 1, 0)
        textboxLabel.Position = UDim2.new(0, 0, 0, 0)
        textboxLabel.BackgroundTransparency = 1
        textboxLabel.Text = text
        textboxLabel.TextColor3 = Colors.Text
        textboxLabel.Font = Enum.Font.Gotham
        textboxLabel.TextSize = 12
        textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Textbox
        local textbox = Instance.new("TextBox", TextboxFrame)
        textbox.Size = UDim2.new(0.6, 0, 1, 0)
        textbox.Position = UDim2.new(0.4, 0, 0, 0)
        textbox.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
        textbox.BackgroundTransparency = 0.6
        textbox.BorderSizePixel = 0
        textbox.Text = ""
        textbox.TextColor3 = Colors.Text
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 12
        textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
        textbox.PlaceholderText = placeholder or "Enter text"
        local txtCorner = Instance.new("UICorner", textbox)
        txtCorner.CornerRadius = UDim.new(0, 6)
        
        -- Focus efekti
        textbox.Focused:Connect(function()
            textbox.BackgroundTransparency = 0.5
        end)
        
        textbox.FocusLost:Connect(function()
            textbox.BackgroundTransparency = 0.6
            if callback then
                pcall(callback, textbox.Text)
            end
        end)
        
        table.insert(self.Elements, TextboxFrame)
        self.Container.Size = UDim2.new(1, -10, 0, 35 + (#self.Elements * 40))
        return textbox
    end
    
    function Section:CreateDropdown(text, options, callback, default)
        local Dropdown = {}
        Dropdown.Options = options or {}
        Dropdown.IsOpen = false
        
        local DropdownFrame = Instance.new("Frame", self.ElementsContainer)
        DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
        DropdownFrame.Position = UDim2.new(0, 0, 0, #self.Elements * 40)
        DropdownFrame.BackgroundTransparency = 1
        
        -- Label
        Dropdown.Label = Instance.new("TextLabel", DropdownFrame)
        Dropdown.Label.Size = UDim2.new(0.4, 0, 1, 0)
        Dropdown.Label.Position = UDim2.new(0, 0, 0, 0)
        Dropdown.Label.BackgroundTransparency = 1
        Dropdown.Label.Text = text
        Dropdown.Label.TextColor3 = Colors.Text
        Dropdown.Label.Font = Enum.Font.Gotham
        Dropdown.Label.TextSize = 12
        Dropdown.Label.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Dropdown button
        Dropdown.Button = Instance.new("TextButton", DropdownFrame)
        Dropdown.Button.Size = UDim2.new(0.6, 0, 1, 0)
        Dropdown.Button.Position = UDim2.new(0.4, 0, 0, 0)
        Dropdown.Button.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
        Dropdown.Button.BackgroundTransparency = 0.5
        Dropdown.Button.BorderSizePixel = 0
        Dropdown.Button.Text = default or "Select"
        Dropdown.Button.TextColor3 = Colors.Text
        Dropdown.Button.Font = Enum.Font.Gotham
        Dropdown.Button.TextSize = 12
        local btnCorner = Instance.new("UICorner", Dropdown.Button)
        btnCorner.CornerRadius = UDim.new(0, 6)
        
        -- Hover efekti
        Dropdown.Button.MouseEnter:Connect(function()
            Dropdown.Button.BackgroundTransparency = 0.3
        end)
        
        Dropdown.Button.MouseLeave:Connect(function()
            Dropdown.Button.BackgroundTransparency = 0.5
        end)
        
        -- Options panel
        Dropdown.OptionsPanel = Instance.new("Frame", ScreenGui)
        Dropdown.OptionsPanel.Size = UDim2.new(0, 150, 0, 0)
        Dropdown.OptionsPanel.Position = UDim2.new(0, 0, 0, 0)
        Dropdown.OptionsPanel.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
        Dropdown.OptionsPanel.BackgroundTransparency = 0
        Dropdown.OptionsPanel.BorderSizePixel = 0
        Dropdown.OptionsPanel.Visible = false
        Dropdown.OptionsPanel.ZIndex = 100
        local panelCorner = Instance.new("UICorner", Dropdown.OptionsPanel)
        panelCorner.CornerRadius = UDim.new(0, 8)
        
        local optionsContainer = Instance.new("Frame", Dropdown.OptionsPanel)
        optionsContainer.Size = UDim2.new(1, -10, 1, -10)
        optionsContainer.Position = UDim2.new(0, 5, 0, 5)
        optionsContainer.BackgroundTransparency = 1
        optionsContainer.AutomaticSize = Enum.AutomaticSize.Y
        
        -- Options
        Dropdown.OptionButtons = {}
        
        local function updateOptions()
            for i, option in ipairs(Dropdown.Options) do
                local optionBtn
                if Dropdown.OptionButtons[i] then
                    optionBtn = Dropdown.OptionButtons[i]
                else
                    optionBtn = Instance.new("TextButton", optionsContainer)
                    optionBtn.Size = UDim2.new(1, 0, 0, 25)
                    optionBtn.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                    optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
                    optionBtn.BackgroundTransparency = 0.5
                    optionBtn.BorderSizePixel = 0
                    optionBtn.TextColor3 = Colors.Text
                    optionBtn.Font = Enum.Font.Gotham
                    optionBtn.TextSize = 12
                    optionBtn.ZIndex = 101
                    local optionCorner = Instance.new("UICorner", optionBtn)
                    optionCorner.CornerRadius = UDim.new(0, 5)
                    
                    optionBtn.MouseEnter:Connect(function()
                        optionBtn.BackgroundTransparency = 0.3
                        optionBtn.BackgroundColor3 = Color3.fromRGB(65, 55, 95)
                    end)
                    
                    optionBtn.MouseLeave:Connect(function()
                        optionBtn.BackgroundTransparency = 0.5
                        optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
                    end)
                    
                    table.insert(Dropdown.OptionButtons, optionBtn)
                end
                
                optionBtn.Text = option
                
                optionBtn.MouseButton1Click:Connect(function()
                    Dropdown.Button.Text = option
                    Dropdown.OptionsPanel.Visible = false
                    Dropdown.IsOpen = false
                    if callback then
                        pcall(callback, option)
                    end
                end)
            end
            
            -- Fazla butonları temizle
            for i = #Dropdown.Options + 1, #Dropdown.OptionButtons do
                Dropdown.OptionButtons[i]:Destroy()
                Dropdown.OptionButtons[i] = nil
            end
        end
        
        updateOptions()
        
        Dropdown.OptionsPanel.Size = UDim2.new(0, 150, 0, math.min(#Dropdown.Options * 30 + 10, 200))
        
        -- Dropdown toggle
        Dropdown.Button.MouseButton1Click:Connect(function()
            Dropdown.IsOpen = not Dropdown.IsOpen
            Dropdown.OptionsPanel.Visible = Dropdown.IsOpen
            
            if Dropdown.IsOpen then
                local btnPos = Dropdown.Button.AbsolutePosition
                local btnSize = Dropdown.Button.AbsoluteSize
                
                Dropdown.OptionsPanel.Position = UDim2.new(
                    0, btnPos.X,
                    0, btnPos.Y + btnSize.Y
                )
                Dropdown.OptionsPanel.Size = UDim2.new(0, 150, 0, math.min(#Dropdown.Options * 30 + 10, 200))
                updateOptions()
            end
        end)
        
        -- Dropdown'u kapat
        local function closeDropdown()
            Dropdown.OptionsPanel.Visible = false
            Dropdown.IsOpen = false
        end
        
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local mousePos = input.Position
                local panelPos = Dropdown.OptionsPanel.AbsolutePosition
                local panelSize = Dropdown.OptionsPanel.AbsoluteSize
                
                if Dropdown.IsOpen then
                    if not (mousePos.X >= panelPos.X and mousePos.X <= panelPos.X + panelSize.X and
                           mousePos.Y >= panelPos.Y and mousePos.Y <= panelPos.Y + panelSize.Y) then
                        closeDropdown()
                    end
                end
            end
        end)
        
        table.insert(self.Elements, DropdownFrame)
        self.Container.Size = UDim2.new(1, -10, 0, 35 + (#self.Elements * 40))
        return Dropdown
    end
    
    function Section:CreateSlider(text, min, max, default, callback)
        local Slider = {}
        Slider.Value = default or min
        Slider.Min = min or 0
        Slider.Max = max or 100
        
        local SliderFrame = Instance.new("Frame", self.ElementsContainer)
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.Position = UDim2.new(0, 0, 0, #self.Elements * 55)
        SliderFrame.BackgroundTransparency = 1
        
        -- Label
        Slider.Label = Instance.new("TextLabel", SliderFrame)
        Slider.Label.Size = UDim2.new(0.5, 0, 0, 20)
        Slider.Label.Position = UDim2.new(0, 0, 0, 0)
        Slider.Label.BackgroundTransparency = 1
        Slider.Label.Text = text
        Slider.Label.TextColor3 = Colors.Text
        Slider.Label.Font = Enum.Font.Gotham
        Slider.Label.TextSize = 12
        Slider.Label.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Value label
        Slider.ValueLabel = Instance.new("TextLabel", SliderFrame)
        Slider.ValueLabel.Size = UDim2.new(0.5, 0, 0, 20)
        Slider.ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
        Slider.ValueLabel.BackgroundTransparency = 1
        Slider.ValueLabel.Text = tostring(Slider.Value)
        Slider.ValueLabel.TextColor3 = Colors.Light
        Slider.ValueLabel.Font = Enum.Font.Gotham
        Slider.ValueLabel.TextSize = 12
        Slider.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        -- Slider background
        Slider.Background = Instance.new("Frame", SliderFrame)
        Slider.Background.Size = UDim2.new(1, 0, 0, 6)
        Slider.Background.Position = UDim2.new(0, 0, 0, 25)
        Slider.Background.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
        Slider.Background.BorderSizePixel = 0
        Slider.Background.Name = "SliderBackground"
        local bgCorner = Instance.new("UICorner", Slider.Background)
        bgCorner.CornerRadius = UDim.new(1, 0)
        
        -- Slider fill
        Slider.Fill = Instance.new("Frame", Slider.Background)
        Slider.Fill.Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
        Slider.Fill.Position = UDim2.new(0, 0, 0, 0)
        Slider.Fill.BackgroundColor3 = Colors.Primary
        Slider.Fill.BorderSizePixel = 0
        local fillCorner = Instance.new("UICorner", Slider.Fill)
        fillCorner.CornerRadius = UDim.new(1, 0)
        
        -- Slider handle
        Slider.Handle = Instance.new("TextButton", Slider.Background)
        Slider.Handle.Size = UDim2.new(0, 16, 0, 16)
        Slider.Handle.Position = UDim2.new(Slider.Fill.Size.X.Scale, -8, 0.5, -8)
        Slider.Handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Slider.Handle.BorderSizePixel = 0
        Slider.Handle.Text = ""
        Slider.Handle.AutoButtonColor = false
        local handleCorner = Instance.new("UICorner", Slider.Handle)
        handleCorner.CornerRadius = UDim.new(1, 0)
        
        local handleStroke = Instance.new("UIStroke", Slider.Handle)
        handleStroke.Color = Colors.Primary
        handleStroke.Thickness = 2
        
        -- Slider logic
        local sliding = false
        
        local function updateSlider(value)
            Slider.Value = math.clamp(value, Slider.Min, Slider.Max)
            local percent = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
            
            Slider.Fill.Size = UDim2.new(percent, 0, 1, 0)
            Slider.Handle.Position = UDim2.new(percent, -8, 0.5, -8)
            Slider.ValueLabel.Text = tostring(Slider.Value)
            
            if callback then
                pcall(callback, Slider.Value)
            end
        end
        
        local function updateSliderFromInput()
            if sliding then
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local sliderAbsPos = Slider.Background.AbsolutePosition
                local sliderAbsSize = Slider.Background.AbsoluteSize
                
                local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                local value = math.floor(Slider.Min + (relativeX * (Slider.Max - Slider.Min)))
                updateSlider(value)
            end
        end
        
        local function startSliding()
            sliding = true
        end
        
        local function stopSliding()
            sliding = false
        end
        
        Slider.Handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                startSliding()
            end
        end)
        
        Slider.Background.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local sliderAbsPos = Slider.Background.AbsolutePosition
                local sliderAbsSize = Slider.Background.AbsoluteSize
                
                local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                local value = math.floor(Slider.Min + (relativeX * (Slider.Max - Slider.Min)))
                updateSlider(value)
                startSliding()
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                stopSliding()
            end
        end)
        
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if sliding then
                updateSliderFromInput()
            end
        end)
        
        table.insert(self.Connections, connection)
        
        -- Başlangıç değeri
        updateSlider(Slider.Value)
        
        table.insert(self.Elements, SliderFrame)
        self.Container.Size = UDim2.new(1, -10, 0, 35 + (#self.Elements * 55))
        return Slider
    end
    
    function Section:CreateLabel(text, color)
        local Label = Instance.new("TextLabel", self.ElementsContainer)
        Label.Size = UDim2.new(1, 0, 0, 25)
        Label.Position = UDim2.new(0, 0, 0, #self.Elements * 35)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = color or Colors.Text
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        table.insert(self.Elements, Label)
        self.Container.Size = UDim2.new(1, -10, 0, 35 + (#self.Elements * 35))
        return Label
    end
    
    -- Notification fonksiyonu
    function Section:Notification(title, text, duration)
        game.StarterGui:SetCore("SendNotification", {
            Title = title or "Notification",
            Text = text or "Message",
            Duration = duration or 2
        })
    end
    
    function Section:Destroy()
        for _, element in ipairs(self.Elements) do
            if element then
                element:Destroy()
            end
        end
        for _, conn in ipairs(self.Connections) do
            conn:Disconnect()
        end
        self.Container:Destroy()
    end
    
    return Section
end

-- Notification fonksiyonu (window için)
function OxireunUILib:Notification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title or "Notification",
        Text = text or "Message",
        Duration = duration or 2
    })
end

-- Pencereyi kapat
function OxireunUILib:Destroy()
    for _, connection in ipairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    for i, window in ipairs(Windows) do
        if window == self then
            table.remove(Windows, i)
            break
        end
    end
    
    if self.Main then
        self.Main:Destroy()
    end
end

-- Library'yi kullanıma hazırla
local function Init()
    return {
        NewWindow = function(title)
            return OxireunUILib:NewWindow(title)
        end,
        Notification = function(title, text, duration)
            game.StarterGui:SetCore("SendNotification", {
                Title = title or "Notification",
                Text = text or "Message",
                Duration = duration or 2
            })
        end
    }
end

return Init()
