-- Neon UI Library (Phone Optimized)
-- GitHub için hazırlanmıştır

local NeonUI = {}
NeonUI.__index = NeonUI

-- Açık mavi renk paleti
local Colors = {
    Background = Color3.fromRGB(245, 248, 255),
    SecondaryBg = Color3.fromRGB(230, 240, 255),
    Border = Color3.fromRGB(0, 150, 255),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(20, 20, 30),
    Disabled = Color3.fromRGB(180, 200, 220),
    Hover = Color3.fromRGB(0, 150, 255, 0.1),
    Button = Color3.fromRGB(240, 245, 255),
    Slider = Color3.fromRGB(0, 150, 255),
    ToggleOn = Color3.fromRGB(0, 150, 255),
    ToggleOff = Color3.fromRGB(210, 220, 235)
}

-- Fontlar
local Fonts = {
    Title = Enum.Font.GothamSemibold,
    Normal = Enum.Font.Gotham,
    Monospace = Enum.Font.Code
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Hafif tıklama efekti
local function ClickEffect(button)
    local originalColor = button.BackgroundColor3
    button.BackgroundColor3 = Colors.Hover
    
    task.delay(0.1, function()
        button.BackgroundColor3 = originalColor
    end)
end

-- Sürükleme fonksiyonu
local function MakeDraggable(frame, dragPart)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

-- Ana Library
function NeonUI.new()
    local self = setmetatable({}, NeonUI)
    self.Windows = {}
    return self
end

function NeonUI:NewWindow(title)
    local Window = {}
    Window.Title = title or "Neon UI"
    Window.Sections = {}
    
    -- Ana ekran
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeonUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Ana pencere (telefon boyutunda)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, 320, 0, 400) -- Daha küçük
    MainFrame.Position = UDim2.new(0, 20, 0.5, -200)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Köşe yuvarlatma
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = MainFrame
    
    -- Border
    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 1.5
    border.Parent = MainFrame
    
    -- Başlık çubuğu
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 35) -- Daha kısa
    TitleBar.BackgroundColor3 = Colors.SecondaryBg
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10, 0, 0)
    titleCorner.Parent = TitleBar
    
    -- Başlık
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 180, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Window.Title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Fonts.Title
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Kontrol butonları
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 45, 1, 0)
    Controls.Position = UDim2.new(1, -50, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar
    
    -- Kapatma butonu
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(0, 20, 0.5, -10)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 16
    CloseButton.Font = Fonts.Normal
    CloseButton.Parent = Controls
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = CloseButton
    
    -- Küçültme butonu
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Position = UDim2.new(0, 0, 0.5, -10)
    MinimizeButton.BackgroundColor3 = Colors.Button
    MinimizeButton.Text = "–"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Fonts.Normal
    MinimizeButton.Parent = Controls
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 5)
    minimizeCorner.Parent = MinimizeButton
    
    -- Section sekmeleri
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "Tabs"
    TabsContainer.Size = UDim2.new(1, -20, 0, 30) -- Daha küçük
    TabsContainer.Position = UDim2.new(0, 10, 0, 45)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = MainFrame
    
    local TabsList = Instance.new("UIListLayout")
    TabsList.FillDirection = Enum.FillDirection.Horizontal
    TabsList.Padding = UDim.new(0, 5)
    TabsList.Parent = TabsContainer
    
    -- İçerik alanı (ScrollingFrame)
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -20, 1, -85) -- Daha küçük
    ContentFrame.Position = UDim2.new(0, 10, 0, 85)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 3
    ContentFrame.ScrollBarImageColor3 = Colors.Border
    ContentFrame.Parent = MainFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 8)
    ContentList.Parent = ContentFrame
    
    -- Sürükleme özelliği
    MakeDraggable(MainFrame, TitleBar)
    
    -- Buton event'leri
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        if MainFrame.Size.Y.Offset == 400 then
            MainFrame:TweenSize(UDim2.new(0, 320, 0, 85), "Out", "Quad", 0.2, true)
            ContentFrame.Visible = false
            TabsContainer.Visible = false
        else
            MainFrame:TweenSize(UDim2.new(0, 320, 0, 400), "Out", "Quad", 0.2, true)
            ContentFrame.Visible = true
            TabsContainer.Visible = true
        end
    end)
    
    -- Buton hover efektleri
    local function SetupButton(button)
        button.MouseButton1Down:Connect(function()
            ClickEffect(button)
        end)
    end
    
    SetupButton(CloseButton)
    SetupButton(MinimizeButton)
    
    -- Yeni section ekleme
    function Window:NewSection(name)
        local Section = {}
        Section.Name = name
        
        -- Sekme butonu
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(0, 70, 0, 25) -- Daha küçük
        TabButton.BackgroundColor3 = Colors.Button
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.TextSize = 12
        TabButton.Font = Fonts.Normal
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabsContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = TabButton
        
        local tabBorder = Instance.new("UIStroke")
        tabBorder.Color = Colors.Border
        tabBorder.Thickness = 1
        tabBorder.Parent = TabButton
        
        -- Section içerik çerçevesi
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = name .. "_Content"
        SectionFrame.Size = UDim2.new(1, 0, 0, 0)
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.Visible = false
        SectionFrame.Parent = ContentFrame
        
        local sectionList = Instance.new("UIListLayout")
        sectionList.Padding = UDim.new(0, 8)
        sectionList.Parent = SectionFrame
        
        -- İlk section aktif
        if #Window.Sections == 0 then
            TabButton.BackgroundColor3 = Colors.Border
            TabButton.TextColor3 = Color3.new(1, 1, 1)
            SectionFrame.Visible = true
        end
        
        -- Sekme değiştirme
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(TabsContainer:GetChildren()) do
                if tab:IsA("TextButton") then
                    tab.BackgroundColor3 = Colors.Button
                    tab.TextColor3 = Colors.Text
                end
            end
            
            for _, frame in pairs(ContentFrame:GetChildren()) do
                if frame:IsA("Frame") and frame.Name:find("_Content") then
                    frame.Visible = false
                end
            end
            
            TabButton.BackgroundColor3 = Colors.Border
            TabButton.TextColor3 = Color3.new(1, 1, 1)
            SectionFrame.Visible = true
            
            -- Auto-size
            task.wait()
            local totalHeight = 0
            for _, child in pairs(SectionFrame:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    totalHeight += child.AbsoluteSize.Y + 8
                end
            end
            SectionFrame.Size = UDim2.new(1, 0, 0, totalHeight)
        end)
        
        SetupButton(TabButton)
        
        -- Element oluşturma fonksiyonları
        function Section:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Name = name
            Button.Size = UDim2.new(1, 0, 0, 32) -- Daha küçük
            Button.BackgroundColor3 = Colors.Button
            Button.Text = name
            Button.TextColor3 = Colors.Text
            Button.TextSize = 13
            Button.Font = Fonts.Normal
            Button.AutoButtonColor = false
            Button.Parent = SectionFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = Button
            
            local btnBorder = Instance.new("UIStroke")
            btnBorder.Color = Colors.Border
            btnBorder.Thickness = 1
            btnBorder.Parent = Button
            
            SetupButton(Button)
            
            Button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
            
            -- Auto-size update
            task.wait()
            local totalHeight = 0
            for _, child in pairs(SectionFrame:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    totalHeight += child.AbsoluteSize.Y + 8
                end
            end
            SectionFrame.Size = UDim2.new(1, 0, 0, totalHeight)
            
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
            ToggleLabel.Font = Fonts.Normal
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "Toggle"
            ToggleButton.Size = UDim2.new(0, 45, 0, 22) -- Daha küçük
            ToggleButton.Position = UDim2.new(1, -45, 0.5, -11)
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
            ToggleCircle.Position = UDim2.new(0, default and 24 or 3, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Colors.Text
            ToggleCircle.Parent = ToggleButton
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = ToggleCircle
            
            local state = default or false
            
            ToggleButton.MouseButton1Click:Connect(function()
                ClickEffect(ToggleButton)
                state = not state
                local targetPos = state and 24 or 3
                
                ToggleCircle:TweenPosition(UDim2.new(0, targetPos, 0.5, -9), "Out", "Quad", 0.15, true)
                ToggleButton.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
                
                if callback then
                    callback(state)
                end
            end)
            
            SetupButton(ToggleButton)
            
            -- Auto-size update
            task.wait()
            local totalHeight = 0
            for _, child in pairs(SectionFrame:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    totalHeight += child.AbsoluteSize.Y + 8
                end
            end
            SectionFrame.Size = UDim2.new(1, 0, 0, totalHeight)
            
            return Toggle
        end
        
        function Section:CreateSlider(name, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Name = name
            Slider.Size = UDim2.new(1, 0, 0, 50) -- Daha küçük
            Slider.BackgroundTransparency = 1
            Slider.Parent = SectionFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, 0, 0, 18)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name .. ": " .. default
            SliderLabel.TextColor3 = Colors.Text
            SliderLabel.TextSize = 13
            SliderLabel.Font = Fonts.Normal
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
            
            local function updateSlider(input)
                local pos = UDim2.new(
                    math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1),
                    -9,
                    0.5,
                    -9
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
                ClickEffect(SliderButton)
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            -- Auto-size update
            task.wait()
            local totalHeight = 0
            for _, child in pairs(SectionFrame:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    totalHeight += child.AbsoluteSize.Y + 8
                end
            end
            SectionFrame.Size = UDim2.new(1, 0, 0, totalHeight)
            
            return Slider
        end
        
        function Section:CreateDropdown(name, options, default, callback)
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = name
            Dropdown.Size = UDim2.new(1, 0, 0, 32)
            Dropdown.BackgroundTransparency = 1
            Dropdown.ClipsDescendants = true
            Dropdown.Parent = SectionFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 32)
            DropdownButton.BackgroundColor3 = Colors.Button
            DropdownButton.Text = name .. ": " .. (options[default] or "Select")
            DropdownButton.TextColor3 = Colors.Text
            DropdownButton.TextSize = 13
            DropdownButton.Font = Fonts.Normal
            DropdownButton.AutoButtonColor = false
            DropdownButton.Parent = Dropdown
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = DropdownButton
            
            local btnBorder = Instance.new("UIStroke")
            btnBorder.Color = Colors.Border
            btnBorder.Thickness = 1
            btnBorder.Parent = DropdownButton
            
            SetupButton(DropdownButton)
            
            table.insert(Window.Sections, Section)
            return Section
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
            InputBox.PlaceholderText = name
            InputBox.TextColor3 = Colors.Text
            InputBox.PlaceholderColor3 = Colors.Disabled
            InputBox.TextSize = 13
            InputBox.Font = Fonts.Normal
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.Parent = Textbox
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 6)
            inputCorner.Parent = InputBox
            
            local inputBorder = Instance.new("UIStroke")
            inputBorder.Color = Colors.Border
            inputBorder.Thickness = 1
            inputBorder.Parent = InputBox
            
            local inputPadding = Instance.new("UIPadding")
            inputPadding.PaddingLeft = UDim.new(0, 10)
            inputPadding.Parent = InputBox
            
            InputBox.FocusLost:Connect(function()
                if callback then
                    callback(InputBox.Text)
                end
            end)
            
            -- Auto-size update
            task.wait()
            local totalHeight = 0
            for _, child in pairs(SectionFrame:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    totalHeight += child.AbsoluteSize.Y + 8
                end
            end
            SectionFrame.Size = UDim2.new(1, 0, 0, totalHeight)
            
            return Textbox
        end
        
        table.insert(Window.Sections, Section)
        return Section
    end
    
    -- Auto-size için
    task.spawn(function()
        while ContentFrame.Parent do
            task.wait()
            local totalHeight = 0
            for _, child in pairs(ContentFrame:GetChildren()) do
                if child:IsA("Frame") and child.Visible then
                    totalHeight += child.AbsoluteSize.Y + 8
                end
            end
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        end
    end)
    
    -- Pencereyi ekle
    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    table.insert(self.Windows, Window)
    return Window
end

return NeonUI.new()
