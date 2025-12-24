-- OXIREUN UI Library
-- GitHub için hazırlanmıştır

local Library = {}
Library.__index = Library

-- Ana UI renkleri
local COLORS = {
    Background = Color3.fromRGB(25, 20, 45),
    Secondary = Color3.fromRGB(30, 25, 55),
    Accent = Color3.fromRGB(0, 150, 255),
    Text = Color3.fromRGB(220, 220, 240)
}

-- CoreGui değişkeni
local CoreGui = game:GetService("CoreGui")

-- Yeni Window oluşturma fonksiyonu
function Library:NewWindow(title)
    local window = {}
    setmetatable(window, Library)
    
    -- ScreenGui oluştur
    window.Gui = Instance.new("ScreenGui")
    window.Gui.Name = title .. "GUI"
    window.Gui.ResetOnSpawn = false
    window.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    window.Gui.Parent = CoreGui
    
    -- Ana çerçeve
    window.MainFrame = Instance.new("Frame")
    window.MainFrame.Size = UDim2.fromScale(0.4, 0.75)
    window.MainFrame.Position = UDim2.fromScale(0.03, 0.1)
    window.MainFrame.BackgroundColor3 = COLORS.Background
    window.MainFrame.BorderSizePixel = 0
    window.MainFrame.Active = true
    window.MainFrame.Draggable = true
    window.MainFrame.Parent = window.Gui
    
    -- Köşe yuvarlatma
    Instance.new("UICorner", window.MainFrame).CornerRadius = UDim.new(0, 12)
    
    -- Neon border
    local glow = Instance.new("UIStroke", window.MainFrame)
    glow.Color = COLORS.Accent
    glow.Thickness = 3
    glow.Transparency = 0.2
    
    -- Üst bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(30, 25, 60)
    topBar.BorderSizePixel = 0
    topBar.Parent = window.MainFrame
    
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12, 0, 0)
    
    -- Üst bar çizgisi
    local topBarLine = Instance.new("Frame")
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = COLORS.Accent
    topBarLine.BorderSizePixel = 0
    topBarLine.Parent = topBar
    
    -- Başlık
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    
    -- Kapatma butonu
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 50)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.Parent = topBar
    
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    
    local closeLine1 = Instance.new("Frame")
    closeLine1.Size = UDim2.new(0, 12, 0, 2)
    closeLine1.Position = UDim2.new(0.5, -6, 0.5, -1)
    closeLine1.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    closeLine1.BorderSizePixel = 0
    closeLine1.Rotation = 45
    closeLine1.Parent = closeBtn
    
    local closeLine2 = Instance.new("Frame")
    closeLine2.Size = UDim2.new(0, 12, 0, 2)
    closeLine2.Position = UDim2.new(0.5, -6, 0.5, -1)
    closeLine2.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    closeLine2.BorderSizePixel = 0
    closeLine2.Rotation = -45
    closeLine2.Parent = closeBtn
    
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundTransparency = 0.4
        closeLine1.BackgroundColor3 = Color3.fromRGB(255, 140, 150)
        closeLine2.BackgroundColor3 = Color3.fromRGB(255, 140, 150)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundTransparency = 0.6
        closeLine1.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
        closeLine2.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        window.Gui:Destroy()
    end)
    
    -- Section container
    window.SectionContainer = Instance.new("ScrollingFrame")
    window.SectionContainer.Size = UDim2.new(1, -20, 1, -60)
    window.SectionContainer.Position = UDim2.new(0, 10, 0, 50)
    window.SectionContainer.BackgroundColor3 = COLORS.Secondary
    window.SectionContainer.BackgroundTransparency = 0
    window.SectionContainer.BorderSizePixel = 0
    window.SectionContainer.ScrollBarThickness = 4
    window.SectionContainer.ScrollBarImageColor3 = COLORS.Accent
    window.SectionContainer.ScrollBarImageTransparency = 0.7
    window.SectionContainer.Parent = window.MainFrame
    
    Instance.new("UICorner", window.SectionContainer).CornerRadius = UDim.new(0, 8)
    
    -- Sections list
    window.Sections = {}
    
    -- NewSection metodu
    function window:NewSection(name)
        local section = {}
        section.Name = name
        
        -- Section frame
        section.Frame = Instance.new("Frame")
        section.Frame.Size = UDim2.new(1, -10, 0, 50)
        section.Frame.Position = UDim2.new(0, 5, 0, (#window.Sections * 60) + 10)
        section.Frame.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
        section.Frame.BackgroundTransparency = 0.2
        section.Frame.BorderSizePixel = 0
        section.Frame.Parent = window.SectionContainer
        
        Instance.new("UICorner", section.Frame).CornerRadius = UDim.new(0, 8)
        
        -- Section title
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = name
        title.TextColor3 = COLORS.Accent
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = section.Frame
        
        -- Section line
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 0, 25)
        line.BackgroundColor3 = COLORS.Accent
        line.BorderSizePixel = 0
        line.Transparency = 0.3
        line.Parent = section.Frame
        
        -- Elements container
        section.ElementsFrame = Instance.new("Frame")
        section.ElementsFrame.Size = UDim2.new(1, 0, 1, -30)
        section.ElementsFrame.Position = UDim2.new(0, 0, 0, 30)
        section.ElementsFrame.BackgroundTransparency = 1
        section.ElementsFrame.Parent = section.Frame
        
        -- Element yükseklik sayacı
        section.ElementYOffset = 0
        
        -- CreateButton metodu
        function section:CreateButton(name, callback)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -20, 0, 30)
            button.Position = UDim2.new(0, 10, 0, section.ElementYOffset)
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
            button.BackgroundTransparency = 0.5
            button.BorderSizePixel = 0
            button.Text = name
            button.TextColor3 = COLORS.Accent
            button.Font = Enum.Font.Gotham
            button.TextSize = 12
            button.Parent = section.ElementsFrame
            
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            
            -- Hover efekti
            button.MouseEnter:Connect(function()
                button.BackgroundTransparency = 0.3
            end)
            
            button.MouseLeave:Connect(function()
                button.BackgroundTransparency = 0.5
            end)
            
            -- Tıklama event'i
            button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
                print("Button clicked: " .. name)
            end)
            
            -- Yükseklik güncelleme
            section.ElementYOffset = section.ElementYOffset + 35
            section.Frame.Size = UDim2.new(1, -10, 0, math.max(50, 30 + section.ElementYOffset))
            
            return button
        end
        
        -- CreateTextbox metodu
        function section:CreateTextbox(name, callback)
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Size = UDim2.new(1, -20, 0, 30)
            textboxFrame.Position = UDim2.new(0, 10, 0, section.ElementYOffset)
            textboxFrame.BackgroundTransparency = 1
            textboxFrame.Parent = section.ElementsFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 80, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name .. ":"
            label.TextColor3 = COLORS.Accent
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = textboxFrame
            
            local textbox = Instance.new("TextBox")
            textbox.Size = UDim2.new(1, -90, 1, 0)
            textbox.Position = UDim2.new(0, 90, 0, 0)
            textbox.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
            textbox.BackgroundTransparency = 0.6
            textbox.BorderSizePixel = 0
            textbox.Text = ""
            textbox.TextColor3 = COLORS.Text
            textbox.Font = Enum.Font.Gotham
            textbox.TextSize = 12
            textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
            textbox.PlaceholderText = "Enter text"
            textbox.Parent = textboxFrame
            
            Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 6)
            
            -- Focus efekti
            textbox.Focused:Connect(function()
                textbox.BackgroundTransparency = 0.5
            end)
            
            textbox.FocusLost:Connect(function()
                textbox.BackgroundTransparency = 0.6
                if callback then
                    callback(textbox.Text)
                end
                print("Textbox value changed: " .. textbox.Text)
            end)
            
            -- Yükseklik güncelleme
            section.ElementYOffset = section.ElementYOffset + 35
            section.Frame.Size = UDim2.new(1, -10, 0, math.max(50, 30 + section.ElementYOffset))
            
            return textbox
        end
        
        -- CreateToggle metodu
        function section:CreateToggle(name, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -20, 0, 30)
            toggleFrame.Position = UDim2.new(0, 10, 0, section.ElementYOffset)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = section.ElementsFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name .. ":"
            label.TextColor3 = COLORS.Accent
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggleFrame
            
            -- Toggle background
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 45, 0, 24)
            toggleBg.Position = UDim2.new(1, -50, 0.5, -12)
            toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = toggleFrame
            
            Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
            
            -- Toggle circle
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 20, 0, 20)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0
            toggleCircle.Parent = toggleBg
            
            Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
            
            -- Toggle butonu
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 45, 0, 24)
            toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.Parent = toggleFrame
            
            -- Toggle state
            local state = false
            
            -- Toggle fonksiyonu
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                
                if state then
                    -- Açık
                    toggleBg.BackgroundColor3 = COLORS.Accent
                    toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                else
                    -- Kapalı
                    toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                end
                
                if callback then
                    callback(state)
                end
                print("Toggle " .. name .. ": " .. tostring(state))
            end)
            
            -- Hover efekti
            toggleBtn.MouseEnter:Connect(function()
                toggleBg.BackgroundTransparency = 0.1
            end)
            
            toggleBtn.MouseLeave:Connect(function()
                toggleBg.BackgroundTransparency = 0
            end)
            
            -- Yükseklik güncelleme
            section.ElementYOffset = section.ElementYOffset + 35
            section.Frame.Size = UDim2.new(1, -10, 0, math.max(50, 30 + section.ElementYOffset))
            
            return {Button = toggleBtn, State = state}
        end
        
        -- CreateDropdown metodu
        function section:CreateDropdown(name, options, default, callback)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
            dropdownFrame.Position = UDim2.new(0, 10, 0, section.ElementYOffset)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Parent = section.ElementsFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 80, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name .. ":"
            label.TextColor3 = COLORS.Accent
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = dropdownFrame
            
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(1, -90, 1, 0)
            dropdownBtn.Position = UDim2.new(0, 90, 0, 0)
            dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
            dropdownBtn.BackgroundTransparency = 0.5
            dropdownBtn.BorderSizePixel = 0
            dropdownBtn.Text = default or "Select"
            dropdownBtn.TextColor3 = COLORS.Text
            dropdownBtn.Font = Enum.Font.Gotham
            dropdownBtn.TextSize = 12
            dropdownBtn.Parent = dropdownFrame
            
            Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 6)
            
            -- Dropdown options panel
            local dropdownOptions = Instance.new("Frame")
            dropdownOptions.Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, (#options * 30) + 10)
            dropdownOptions.Position = UDim2.new(0, 0, 1, 5)
            dropdownOptions.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
            dropdownOptions.BackgroundTransparency = 0
            dropdownOptions.BorderSizePixel = 0
            dropdownOptions.Visible = false
            dropdownOptions.ZIndex = 100
            dropdownOptions.Parent = dropdownBtn
            
            Instance.new("UICorner", dropdownOptions).CornerRadius = UDim.new(0, 8)
            
            -- Options
            for i, option in ipairs(options) do
                local optionBtn = Instance.new("TextButton")
                optionBtn.Size = UDim2.new(1, -10, 0, 25)
                optionBtn.Position = UDim2.new(0, 5, 0, (i-1) * 30 + 5)
                optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
                optionBtn.BackgroundTransparency = 0.5
                optionBtn.BorderSizePixel = 0
                optionBtn.Text = option
                optionBtn.TextColor3 = COLORS.Text
                optionBtn.Font = Enum.Font.Gotham
                optionBtn.TextSize = 12
                optionBtn.ZIndex = 101
                optionBtn.Parent = dropdownOptions
                
                Instance.new("UICorner", optionBtn).CornerRadius = UDim.new(0, 5)
                
                optionBtn.MouseEnter:Connect(function()
                    optionBtn.BackgroundTransparency = 0.3
                end)
                
                optionBtn.MouseLeave:Connect(function()
                    optionBtn.BackgroundTransparency = 0.5
                end)
                
                optionBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = option
                    dropdownOptions.Visible = false
                    
                    if callback then
                        callback(option)
                    end
                    print("Dropdown selected: " .. option)
                end)
            end
            
            -- Dropdown toggle
            dropdownBtn.MouseButton1Click:Connect(function()
                dropdownOptions.Visible = not dropdownOptions.Visible
            end)
            
            -- Hover efekti
            dropdownBtn.MouseEnter:Connect(function()
                dropdownBtn.BackgroundTransparency = 0.3
            end)
            
            dropdownBtn.MouseLeave:Connect(function()
                dropdownBtn.BackgroundTransparency = 0.5
            end)
            
            -- CanvasSize güncelleme
            window.SectionContainer.CanvasSize = UDim2.new(0, 0, 0, (#window.Sections * 60) + section.ElementYOffset + 50)
            
            -- Yükseklik güncelleme
            section.ElementYOffset = section.ElementYOffset + 35
            section.Frame.Size = UDim2.new(1, -10, 0, math.max(50, 30 + section.ElementYOffset))
            
            return dropdownBtn
        end
        
        -- CreateSlider metodu
        function section:CreateSlider(name, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -20, 0, 40)
            sliderFrame.Position = UDim2.new(0, 10, 0, section.ElementYOffset)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = section.ElementsFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, 0, 0, 20)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name .. ":"
            label.TextColor3 = COLORS.Accent
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.5, 0, 0, 20)
            valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = sliderFrame
            
            -- Slider bar
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, 0, 0, 6)
            sliderBg.Position = UDim2.new(0, 0, 0, 25)
            sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = sliderFrame
            
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
            
            -- Slider fill
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = COLORS.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            
            Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
            
            -- Slider handle
            local sliderHandle = Instance.new("TextButton")
            sliderHandle.Size = UDim2.new(0, 16, 0, 16)
            sliderHandle.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
            sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderHandle.BorderSizePixel = 0
            sliderHandle.Text = ""
            sliderHandle.AutoButtonColor = false
            sliderHandle.Parent = sliderBg
            
            Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(1, 0)
            
            local sliderHandleStroke = Instance.new("UIStroke", sliderHandle)
            sliderHandleStroke.Color = COLORS.Accent
            sliderHandleStroke.Thickness = 2
            
            -- Slider logic
            local UserInputService = game:GetService("UserInputService")
            local RunService = game:GetService("RunService")
            local sliding = false
            local currentValue = default
            
            local function updateSlider(value)
                currentValue = math.clamp(value, min, max)
                local percent = (currentValue - min) / (max - min)
                
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
                valueLabel.Text = tostring(currentValue)
                
                if callback then
                    callback(currentValue)
                end
            end
            
            -- Mouse events
            sliderHandle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                end
            end)
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                    local sliderAbsPos = sliderBg.AbsolutePosition
                    local sliderAbsSize = sliderBg.AbsoluteSize
                    
                    local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                    local value = min + (relativeX * (max - min))
                    updateSlider(value)
                    sliding = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if sliding then
                    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                    local sliderAbsPos = sliderBg.AbsolutePosition
                    local sliderAbsSize = sliderBg.AbsoluteSize
                    
                    local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                    local value = min + (relativeX * (max - min))
                    updateSlider(value)
                end
            end)
            
            -- Başlangıç değeri
            updateSlider(default)
            
            -- Yükseklik güncelleme
            section.ElementYOffset = section.ElementYOffset + 45
            section.Frame.Size = UDim2.new(1, -10, 0, math.max(50, 30 + section.ElementYOffset))
            
            return {Value = currentValue, Update = updateSlider}
        end
        
        -- Section'ı listeye ekle
        table.insert(window.Sections, section)
        
        -- CanvasSize güncelle
        window.SectionContainer.CanvasSize = UDim2.new(0, 0, 0, (#window.Sections * 60) + section.ElementYOffset + 50)
        
        return section
    end
    
    return window
end

-- Notification fonksiyonu
function Library:SendNotification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2,
        Icon = "🔔"
    })
end

-- Library'yi döndür
return Library
