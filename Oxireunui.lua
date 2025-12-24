-- Oxireun UI Library
-- GitHub: https://raw.githubusercontent.com/oxireun/User/main/Oxireunui.lua

local Oxireun = {}
Oxireun.__index = Oxireun

-- Servisler
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Tema renkleri
local Theme = {
    Primary = Color3.fromRGB(0, 150, 255),
    Secondary = Color3.fromRGB(35, 30, 65),
    Background = Color3.fromRGB(25, 20, 45),
    Text = Color3.fromRGB(220, 220, 240),
    DarkText = Color3.fromRGB(150, 150, 180),
    Button = Color3.fromRGB(45, 45, 70),
    ToggleOn = Color3.fromRGB(0, 150, 255),
    ToggleOff = Color3.fromRGB(180, 180, 190)
}

-- Yardımcı fonksiyonlar
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- UI elementleri oluşturma fonksiyonları
local function CreateButton(text, callback, parent)
    local buttonFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local button = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Button,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = Theme.Primary,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = buttonFrame
    })
    
    local corner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = button
    })
    
    -- Hover efekti
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.3
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0.5
    end)
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        print("[Oxireun] Button clicked: " .. text)
        if callback then
            callback()
        end
    end)
    
    return buttonFrame
end

local function CreateTextBox(label, callback, parent)
    local textboxFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local textboxLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Theme.Primary,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = textboxFrame
    })
    
    local textbox = CreateInstance("TextBox", {
        Size = UDim2.new(1, -110, 1, 0),
        Position = UDim2.new(0, 110, 0, 0),
        BackgroundColor3 = Theme.Button,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Text = "",
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        PlaceholderColor3 = Theme.DarkText,
        Parent = textboxFrame
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = textbox
    })
    
    -- Focus efekti
    textbox.Focused:Connect(function()
        textbox.BackgroundTransparency = 0.5
    end)
    
    textbox.FocusLost:Connect(function(enterPressed)
        textbox.BackgroundTransparency = 0.6
        if enterPressed then
            print("[Oxireun] TextBox value: " .. textbox.Text)
            if callback then
                callback(textbox.Text)
            end
        end
    end)
    
    return textboxFrame
end

local function CreateToggle(label, callback, parent)
    local toggleFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local toggleLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Theme.Primary,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggleFrame
    })
    
    -- Toggle background
    local toggleBg = CreateInstance("Frame", {
        Size = UDim2.new(0, 45, 0, 24),
        Position = UDim2.new(1, -50, 0.5, -12),
        BackgroundColor3 = Theme.ToggleOff,
        BorderSizePixel = 0,
        Parent = toggleFrame
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = toggleBg
    })
    
    -- Toggle circle
    local toggleCircle = CreateInstance("Frame", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 2, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = toggleBg
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = toggleCircle
    })
    
    -- Toggle butonu
    local toggleBtn = CreateInstance("TextButton", {
        Size = UDim2.new(0, 45, 0, 24),
        Position = UDim2.new(1, -50, 0.5, -12),
        BackgroundTransparency = 1,
        Text = "",
        Parent = toggleFrame
    })
    
    local toggleState = false
    
    -- Toggle fonksiyonu
    toggleBtn.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        
        if toggleState then
            -- Açık
            toggleBg.BackgroundColor3 = Theme.ToggleOn
            toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
            print("[Oxireun] Toggle ON: " .. label)
        else
            -- Kapalı
            toggleBg.BackgroundColor3 = Theme.ToggleOff
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
            print("[Oxireun] Toggle OFF: " .. label)
        end
        
        if callback then
            callback(toggleState)
        end
    end)
    
    -- Toggle hover
    toggleBtn.MouseEnter:Connect(function()
        toggleBg.BackgroundTransparency = 0.1
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        toggleBg.BackgroundTransparency = 0
    end)
    
    return toggleFrame
end

local function CreateDropdown(label, options, defaultIndex, callback, parent)
    local dropdownFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local dropdownLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Theme.Primary,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dropdownFrame
    })
    
    local dropdownBtn = CreateInstance("TextButton", {
        Size = UDim2.new(1, -110, 1, 0),
        Position = UDim2.new(0, 110, 0, 0),
        BackgroundColor3 = Theme.Button,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Text = options[defaultIndex] or "Select",
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = dropdownFrame
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = dropdownBtn
    })
    
    -- Dropdown hover efekti
    dropdownBtn.MouseEnter:Connect(function()
        dropdownBtn.BackgroundTransparency = 0.3
    end)
    
    dropdownBtn.MouseLeave:Connect(function()
        dropdownBtn.BackgroundTransparency = 0.5
    end)
    
    -- Dropdown options panel (parent GUI'ye bağlı)
    local mainGui = parent.Parent.Parent.Parent.Parent
    local dropdownOptions = CreateInstance("Frame", {
        Size = UDim2.new(0, 150, 0, 100),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Secondary,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 100,
        Parent = mainGui
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = dropdownOptions
    })
    
    local optionButtons = {}
    local optionHeight = 30
    
    for i, option in ipairs(options) do
        local optionBtn = CreateInstance("TextButton", {
            Size = UDim2.new(1, -10, 0, optionHeight - 5),
            Position = UDim2.new(0, 5, 0, (i-1) * optionHeight + 5),
            BackgroundColor3 = Theme.Button,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = option,
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            ZIndex = 101,
            Parent = dropdownOptions
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = optionBtn
        })
        
        optionBtn.MouseEnter:Connect(function()
            optionBtn.BackgroundTransparency = 0.3
            optionBtn.BackgroundColor3 = Color3.fromRGB(65, 55, 95)
        end)
        
        optionBtn.MouseLeave:Connect(function()
            optionBtn.BackgroundTransparency = 0.5
            optionBtn.BackgroundColor3 = Theme.Button
        end)
        
        optionBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            dropdownOptions.Visible = false
            print("[Oxireun] Dropdown selected: " .. option)
            if callback then
                callback(option)
            end
        end)
        
        table.insert(optionButtons, optionBtn)
    end
    
    -- Dropdown toggle
    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownOptions.Visible = not dropdownOptions.Visible
        
        if dropdownOptions.Visible then
            local btnPos = dropdownBtn.AbsolutePosition
            local mainPos = mainGui.AbsolutePosition
            local mainSize = mainGui.AbsoluteSize
            
            local relativeX = (btnPos.X - mainPos.X) / mainSize.X
            local relativeY = (btnPos.Y - mainPos.Y + dropdownBtn.AbsoluteSize.Y) / mainSize.Y
            
            dropdownOptions.Position = UDim2.new(relativeX, 0, relativeY, 0)
            dropdownOptions.Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, #options * optionHeight + 10)
        end
    end)
    
    -- Dropdown'u kapat
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local dropdownPos = dropdownOptions.AbsolutePosition
            local dropdownSize = dropdownOptions.AbsoluteSize
            
            if dropdownOptions.Visible then
                if not (mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                       mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y) then
                    dropdownOptions.Visible = false
                end
            end
        end
    end)
    
    return dropdownFrame
end

local function CreateSlider(label, min, max, defaultValue, callback, parent)
    local sliderFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local sliderLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = label .. ":",
        TextColor3 = Theme.Primary,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sliderFrame
    })
    
    -- Slider değer gösterimi
    local sliderValueLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 20),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(defaultValue),
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = sliderFrame
    })
    
    -- Slider bar background
    local sliderBg = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Color3.fromRGB(50, 50, 75),
        BorderSizePixel = 0,
        Parent = sliderFrame
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = sliderBg
    })
    
    -- Slider fill
    local sliderFill = CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = sliderBg
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = sliderFill
    })
    
    -- Slider handle (buton yapıldı - cihazlar için)
    local sliderHandle = CreateInstance("TextButton", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, -8, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = sliderBg
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = sliderHandle
    })
    
    -- Slider handle stroke
    local sliderHandleStroke = CreateInstance("UIStroke", {
        Color = Theme.Primary,
        Thickness = 2,
        Parent = sliderHandle
    })
    
    -- Slider logic
    local sliding = false
    local sliderValue = defaultValue
    local range = max - min
    
    local function updateSlider(value)
        sliderValue = math.clamp(value, min, max)
        local percent = (sliderValue - min) / range
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
        sliderValueLabel.Text = tostring(math.floor(sliderValue))
        
        if callback then
            callback(sliderValue)
        end
    end
    
    -- Slider'ı mouse/touch pozisyonuna göre güncelle
    local function updateSliderFromInput()
        if sliding then
            local mouseX = game:GetService("Players").LocalPlayer:GetMouse().X
            local sliderAbsPos = sliderBg.AbsolutePosition
            local sliderAbsSize = sliderBg.AbsoluteSize
            
            local relativeX = (mouseX - sliderAbsPos.X) / sliderAbsSize.X
            updateSlider(min + relativeX * range)
        end
    end
    
    -- Slider sürüklemeyi başlat
    local function startSliding()
        sliding = true
        local scroll = parent.Parent.Parent.Parent
        if scroll:IsA("ScrollingFrame") then
            scroll.ScrollingEnabled = false
        end
    end
    
    -- Slider sürüklemeyi durdur
    local function stopSliding()
        sliding = false
        local scroll = parent.Parent.Parent.Parent
        if scroll:IsA("ScrollingFrame") then
            scroll.ScrollingEnabled = true
        end
    end
    
    -- Mouse/Input event'leri
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startSliding()
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            local sliderAbsPos = sliderBg.AbsolutePosition
            local sliderAbsSize = sliderBg.AbsoluteSize
            
            local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
            updateSlider(min + relativeX * range)
            startSliding()
        end
    end)
    
    -- Mouse/touch bırakıldığında
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopSliding()
        end
    end)
    
    -- Sürüklerken güncelle
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if sliding then
            updateSliderFromInput()
        end
    end)
    
    -- Başlangıç değeri
    updateSlider(defaultValue)
    
    return sliderFrame
end

-- Notification fonksiyonu
function Oxireun:Notification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title or "Oxireun",
        Text = text or "Notification",
        Duration = duration or 2,
        Icon = "rbxassetid://6031082533" -- Bell icon
    })
    print("[Oxireun] Notification: " .. title .. " - " .. text)
end

-- Window class
local Window = {}
Window.__index = Window

function Window:NewSection(name)
    local Section = {}
    Section.__index = Section
    Section.name = name
    Section.elements = {}
    
    -- Section container
    Section.container = CreateInstance("Frame", {
        Size = UDim2.new(1, -10, 0, 300),
        Position = UDim2.new(0, 5, 0, 10),
        BackgroundColor3 = Theme.Secondary,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Parent = self.content
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Section.container
    })
    
    -- Section başlığı
    local sectionTitle = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name:upper(),
        TextColor3 = Theme.Primary,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Section.container
    })
    
    -- Section alt çizgisi
    local sectionLine = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Transparency = 0.3,
        Parent = Section.container
    })
    
    -- Element container
    Section.elementContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = Section.container
    })
    
    local layout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Section.elementContainer
    })
    
    function Section:CreateButton(text, callback)
        local element = CreateButton(text, callback, self.elementContainer)
        table.insert(self.elements, element)
        return element
    end
    
    function Section:CreateTextbox(label, callback)
        local element = CreateTextBox(label, callback, self.elementContainer)
        table.insert(self.elements, element)
        return element
    end
    
    function Section:CreateToggle(label, callback)
        local element = CreateToggle(label, callback, self.elementContainer)
        table.insert(self.elements, element)
        return element
    end
    
    function Section:CreateDropdown(label, options, defaultIndex, callback)
        local element = CreateDropdown(label, options, defaultIndex or 1, callback, self.elementContainer)
        table.insert(self.elements, element)
        return element
    end
    
    function Section:CreateSlider(label, min, max, defaultValue, callback)
        local element = CreateSlider(label, min, max, defaultValue or min, callback, self.elementContainer)
        table.insert(self.elements, element)
        return element
    end
    
    return Section
end

-- Main Library functions
function Oxireun:NewWindow(title)
    -- Ana GUI
    local gui = CreateInstance("ScreenGui", {
        Name = "OxireunGUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game.CoreGui
    })
    
    -- Ana çerçeve
    local main = CreateInstance("Frame", {
        Size = UDim2.fromScale(0.4, 0.75),
        Position = UDim2.fromScale(0.03, 0.1),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Parent = gui
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = main
    })
    
    CreateInstance("UIStroke", {
        Color = Theme.Primary,
        Thickness = 3,
        Transparency = 0.2,
        Parent = main
    })
    
    -- Üst bar
    local topBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(30, 25, 60),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Parent = main
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12, 0, 0),
        Parent = topBar
    })
    
    -- Üst bar alt çizgisi
    CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = topBar
    })
    
    -- Başlık
    CreateInstance("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "OXIREUN",
        TextColor3 = Color3.fromRGB(180, 200, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    -- Kontrol butonları
    local controlButtons = CreateInstance("Frame", {
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -65, 0, 0),
        BackgroundTransparency = 1,
        Parent = topBar
    })
    
    -- Close butonu
    local closeBtn = CreateInstance("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 30, 0.5, -13),
        BackgroundColor3 = Color3.fromRGB(70, 40, 50),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Text = "",
        Parent = controlButtons
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = closeBtn
    })
    
    -- Close çizgileri
    local closeLine1 = CreateInstance("Frame", {
        Size = UDim2.new(0, 12, 0, 2),
        Position = UDim2.new(0.5, -6, 0.5, -1),
        BackgroundColor3 = Color3.fromRGB(240, 120, 130),
        BorderSizePixel = 0,
        Rotation = 45,
        Parent = closeBtn
    })
    
    local closeLine2 = CreateInstance("Frame", {
        Size = UDim2.new(0, 12, 0, 2),
        Position = UDim2.new(0.5, -6, 0.5, -1),
        BackgroundColor3 = Color3.fromRGB(240, 120, 130),
        BorderSizePixel = 0,
        Rotation = -45,
        Parent = closeBtn
    })
    
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
        gui:Destroy()
    end)
    
    -- İçerik alanı
    local contentArea = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 90),
        BackgroundColor3 = Color3.fromRGB(30, 25, 55),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = main
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = contentArea
    })
    
    -- Scrolling frame
    local scroll = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Primary,
        ScrollBarImageTransparency = 0.7,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        HorizontalScrollBarInset = Enum.ScrollBarInset.None,
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
        VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = contentArea
    })
    
    local scrollContent = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = scroll
    })
    
    CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scrollContent
    })
    
    -- Window objesi
    local window = setmetatable({
        gui = gui,
        main = main,
        scroll = scroll,
        content = scrollContent,
        sections = {}
    }, Window)
    
    -- Auto resize scroll
    scrollContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        local totalHeight = 0
        for _, child in ipairs(scrollContent:GetChildren()) do
            if child:IsA("Frame") then
                totalHeight = totalHeight + child.AbsoluteSize.Y + 10
            end
        end
        scroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        scrollContent.Size = UDim2.new(1, 0, 0, totalHeight)
    end)
    
    -- Başlangıç notification'u KAPALI (senin istediğin gibi)
    
    return window
end

-- Library'yi döndür
return Oxireun
