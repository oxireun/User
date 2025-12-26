-- Neon Mavi UI Library
-- Mobile uyumlu, küçük boyutlu

local NeonBlueUI = {}
NeonBlueUI.__index = NeonBlueUI

-- Açık mavi renk paleti
local Colors = {
    Background = Color3.fromRGB(15, 20, 35),
    SecondaryBg = Color3.fromRGB(25, 35, 55),
    Border = Color3.fromRGB(0, 150, 255), -- Açık mavi
    Accent = Color3.fromRGB(0, 180, 255), -- Daha parlak mavi
    Text = Color3.fromRGB(240, 245, 255),
    Disabled = Color3.fromRGB(100, 120, 150),
    Hover = Color3.fromRGB(0, 150, 255, 0.2),
    Button = Color3.fromRGB(40, 60, 90),
    Slider = Color3.fromRGB(0, 150, 255),
    ToggleOn = Color3.fromRGB(0, 150, 255),
    ToggleOff = Color3.fromRGB(60, 80, 110)
}

-- UI Boyutları (mobil için optimize)
local UI_SIZE = {
    Width = 320,
    Height = 400
}

-- Ana Library fonksiyonu
function NeonBlueUI.new()
    local self = setmetatable({}, NeonBlueUI)
    self.Windows = {}
    return self
end

-- Yeni pencere oluşturma
function NeonBlueUI:NewWindow(title)
    local Window = {}
    Window.Title = title or "Neon Blue UI"
    Window.Sections = {}
    Window.Elements = {} -- Tüm elementler buraya eklenecek
    
    -- Ana ekran
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeonBlueUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Ana pencere
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
    MainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Köşe yuvarlatma
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = MainFrame
    
    -- Mavi border
    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 2
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
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Kontrol butonları
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 50, 1, 0)
    Controls.Position = UDim2.new(1, -55, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar
    
    -- Kapatma butonu
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 22, 0, 22)
    CloseButton.Position = UDim2.new(0, 23, 0.5, -11)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Controls
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = CloseButton
    
    -- Küçültme butonu
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
    MinimizeButton.Position = UDim2.new(0, 0, 0.5, -11)
    MinimizeButton.BackgroundColor3 = Colors.Button
    MinimizeButton.Text = "–"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = Controls
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 5)
    minimizeCorner.Parent = MinimizeButton
    
    -- İçerik alanı
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -20, 1, -55)
    ContentFrame.Position = UDim2.new(0, 10, 0, 45)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Colors.Border
    ContentFrame.Parent = MainFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 8)
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
        if MainFrame.Size.Y.Offset == UI_SIZE.Height then
            MainFrame:TweenSize(UDim2.new(0, UI_SIZE.Width, 0, 35), "Out", "Quad", 0.2, true)
            ContentFrame.Visible = false
        else
            MainFrame:TweenSize(UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height), "Out", "Quad", 0.2, true)
            ContentFrame.Visible = true
        end
    end)
    
    -- Buton hover efektleri
    local function SetupButtonHover(button)
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
    
    SetupButtonHover(CloseButton)
    SetupButtonHover(MinimizeButton)
    
    -- Mavi tıklama efekti
    local function CreateClickEffect(button)
        local effect = Instance.new("Frame")
        effect.Name = "ClickEffect"
        effect.Size = UDim2.new(1, 0, 1, 0)
        effect.BackgroundColor3 = Colors.Accent
        effect.BackgroundTransparency = 0.7
        effect.Parent = button
        
        game:GetService("TweenService"):Create(effect, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play()
        
        delay(0.3, function()
            effect:Destroy()
        end)
    end
    
    -- Yeni section ekleme fonksiyonu
    function Window:NewSection(name)
        local Section = {}
        Section.Name = name
        
        -- Section başlığı
        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Name = name
        SectionLabel.Size = UDim2.new(1, 0, 0, 25)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = name
        SectionLabel.TextColor3 = Colors.Text
        SectionLabel.TextSize = 14
        SectionLabel.Font = Enum.Font.GothamBold
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        SectionLabel.Parent = ContentFrame
        
        -- Section container
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = name .. "_Container"
        SectionFrame.Size = UDim2.new(1, 0, 0, 0)
        SectionFrame.BackgroundColor3 = Colors.SecondaryBg
        SectionFrame.BorderSizePixel = 0
        SectionFrame.Parent = ContentFrame
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 8)
        sectionCorner.Parent = SectionFrame
        
        local sectionList = Instance.new("UIListLayout")
        sectionList.Padding = UDim.new(0, 5)
        sectionList.Parent = SectionFrame
        
        -- Element oluşturma fonksiyonları
        function Section:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Name = name
            Button.Size = UDim2.new(1, -10, 0, 35)
            Button.Position = UDim2.new(0, 5, 0, 5)
            Button.BackgroundColor3 = Colors.Button
            Button.Text = name
            Button.TextColor3 = Colors.Text
            Button.TextSize = 13
            Button.Font = Enum.Font.Gotham
            Button.AutoButtonColor = false
            Button.Parent = SectionFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = Button
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Colors.Border
            btnStroke.Thickness = 1
            btnStroke.Parent = Button
            
            SetupButtonHover(Button)
            
            Button.MouseButton1Click:Connect(function()
                CreateClickEffect(Button)
                if callback then
                    callback()
                end
            end)
            
            -- Section boyutunu güncelle
            SectionFrame.Size = UDim2.new(1, 0, 0, sectionList.AbsoluteContentSize.Y + 10)
            
            return Button
        end
        
        function Section:CreateToggle(name, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Name = name
            Toggle.Size = UDim2.new(1, -10, 0, 35)
            Toggle.Position = UDim2.new(0, 5, 0, 5)
            Toggle.BackgroundTransparency = 1
            Toggle.Parent = SectionFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Colors.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.Font = Enum.Font.Gotham
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
            
            SetupButtonHover(ToggleButton)
            
            -- Section boyutunu güncelle
            SectionFrame.Size = UDim2.new(1, 0, 0, sectionList.AbsoluteContentSize.Y + 10)
            
            return Toggle
        end
        
        function Section:CreateSlider(name, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Name = name
            Slider.Size = UDim2.new(1, -10, 0, 50)
            Slider.Position = UDim2.new(0, 5, 0, 5)
            Slider.BackgroundTransparency = 1
            Slider.Parent = SectionFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, 0, 0, 20)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name .. ": " .. default
            SliderLabel.TextColor3 = Colors.Text
            SliderLabel.TextSize = 13
            SliderLabel.Font = Enum.Font.Gotham
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
            
            -- Section boyutunu güncelle
            SectionFrame.Size = UDim2.new(1, 0, 0, sectionList.AbsoluteContentSize.Y + 10)
            
            return Slider
        end
        
        function Section:CreateDropdown(name, options, default, callback)
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = name
            Dropdown.Size = UDim2.new(1, -10, 0, 35)
            Dropdown.Position = UDim2.new(0, 5, 0, 5)
            Dropdown.BackgroundTransparency = 1
            Dropdown.ClipsDescendants = true
            Dropdown.Parent = SectionFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 35)
            DropdownButton.BackgroundColor3 = Colors.Button
            DropdownButton.Text = name .. ": " .. (options[default] or "Select")
            DropdownButton.TextColor3 = Colors.Text
            DropdownButton.TextSize = 13
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.AutoButtonColor = false
            DropdownButton.Parent = Dropdown
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = DropdownButton
            
            local open = false
            
            DropdownButton.MouseButton1Click:Connect(function()
                CreateClickEffect(DropdownButton)
                open = not open
                
                if open then
                    local OptionsFrame = Instance.new("Frame")
                    OptionsFrame.Name = "Options"
                    OptionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
                    OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
                    OptionsFrame.BackgroundColor3 = Colors.SecondaryBg
                    OptionsFrame.Parent = Dropdown
                    
                    local optionsCorner = Instance.new("UICorner")
                    optionsCorner.CornerRadius = UDim.new(0, 6)
                    optionsCorner.Parent = OptionsFrame
                    
                    for i, option in pairs(options) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Name = option
                        OptionButton.Size = UDim2.new(1, -10, 0, 25)
                        OptionButton.Position = UDim2.new(0, 5, 0, (i-1)*30 + 5)
                        OptionButton.BackgroundColor3 = Colors.Button
                        OptionButton.Text = option
                        OptionButton.TextColor3 = Colors.Text
                        OptionButton.TextSize = 12
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.AutoButtonColor = false
                        OptionButton.Parent = OptionsFrame
                        
                        local optionCorner = Instance.new("UICorner")
                        optionCorner.CornerRadius = UDim.new(0, 4)
                        optionCorner.Parent = OptionButton
                        
                        SetupButtonHover(OptionButton)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            CreateClickEffect(OptionButton)
                            DropdownButton.Text = name .. ": " .. option
                            if callback then
                                callback(option)
                            end
                            OptionsFrame:Destroy()
                            open = false
                        end)
                    end
                else
                    if Dropdown:FindFirstChild("Options") then
                        Dropdown.Options:Destroy()
                    end
                end
            end)
            
            SetupButtonHover(DropdownButton)
            
            -- Section boyutunu güncelle
            SectionFrame.Size = UDim2.new(1, 0, 0, sectionList.AbsoluteContentSize.Y + 10)
            
            return Dropdown
        end
        
        function Section:CreateTextbox(name, callback)
            local Textbox = Instance.new("Frame")
            Textbox.Name = name
            Textbox.Size = UDim2.new(1, -10, 0, 35)
            Textbox.Position = UDim2.new(0, 5, 0, 5)
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
            InputBox.Font = Enum.Font.Gotham
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.Parent = Textbox
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 6)
            inputCorner.Parent = InputBox
            
            local inputPadding = Instance.new("UIPadding")
            inputPadding.PaddingLeft = UDim.new(0, 10)
            inputPadding.Parent = InputBox
            
            InputBox.FocusLost:Connect(function()
                if callback then
                    callback(InputBox.Text)
                end
            end)
            
            -- Section boyutunu güncelle
            SectionFrame.Size = UDim2.new(1, 0, 0, sectionList.AbsoluteContentSize.Y + 10)
            
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
return NeonBlueUI.new()
