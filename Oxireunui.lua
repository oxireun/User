-- Oxireun UI Library
-- GitHub: https://raw.githubusercontent.com/[username]/[repo]/main/OxireunUI.lua

local OxireunUI = {}
OxireunUI.__index = OxireunUI

-- Servisler
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Ana GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "OxireunGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Pencere listesi
local windows = {}

-- Renk paleti
local colors = {
    background = Color3.fromRGB(25, 20, 45),
    topbar = Color3.fromRGB(30, 25, 60),
    section = Color3.fromRGB(35, 30, 65),
    accent = Color3.fromRGB(0, 150, 255),
    text = Color3.fromRGB(180, 200, 255),
    textSecondary = Color3.fromRGB(150, 150, 180)
}

-- Yardımcı fonksiyonlar
local function roundCorners(instance, radius)
    local corner = Instance.new("UICorner", instance)
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

local function createStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke", instance)
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = transparency or 0.2
    return stroke
end

-- Yeni pencere oluştur
function OxireunUI:NewWindow(title)
    local window = {}
    setmetatable(window, self)
    
    -- Pencere ID'si
    local windowId = #windows + 1
    
    -- Ana frame
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromScale(0.4, 0.75)
    main.Position = UDim2.fromScale(0.03 + (windowId-1)*0.43, 0.1)
    main.BackgroundColor3 = colors.background
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Name = "Window" .. windowId
    
    roundCorners(main, 12)
    createStroke(main, colors.accent, 3, 0.2)
    
    -- Üst bar
    local topBar = Instance.new("Frame", main)
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = colors.topbar
    topBar.BorderSizePixel = 0
    roundCorners(topBar, 12, 0, 0)
    
    -- Üst bar çizgisi
    local topBarLine = Instance.new("Frame", topBar)
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = colors.accent
    topBarLine.BorderSizePixel = 0
    
    -- Kontrol butonları
    local controlButtons = Instance.new("Frame", topBar)
    controlButtons.Size = UDim2.new(0, 60, 1, 0)
    controlButtons.Position = UDim2.new(1, -65, 0, 0)
    controlButtons.BackgroundTransparency = 1
    
    -- Başlık
    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Oxireun"
    titleLabel.TextColor3 = colors.text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Tab container
    local tabContainer = Instance.new("Frame", main)
    tabContainer.Size = UDim2.new(1, -20, 0, 35)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1
    
    -- İçerik alanı
    local contentArea = Instance.new("Frame", main)
    contentArea.Size = UDim2.new(1, -20, 1, -100)
    contentArea.Position = UDim2.new(0, 10, 0, 90)
    contentArea.BackgroundColor3 = Color3.fromRGB(30, 25, 55)
    contentArea.BackgroundTransparency = 0
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    roundCorners(contentArea, 8)
    
    -- Section container
    local sectionContainer = Instance.new("ScrollingFrame", contentArea)
    sectionContainer.Size = UDim2.new(1, 0, 1, 0)
    sectionContainer.Position = UDim2.new(0, 0, 0, 0)
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.BorderSizePixel = 0
    sectionContainer.ScrollBarThickness = 4
    sectionContainer.ScrollBarImageColor3 = colors.accent
    sectionContainer.ScrollBarImageTransparency = 0.7
    sectionContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    sectionContainer.HorizontalScrollBarInset = Enum.ScrollBarInset.None
    sectionContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    sectionContainer.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    
    -- Section listesi
    window.sections = {}
    window.main = main
    window.contentArea = contentArea
    window.sectionContainer = sectionContainer
    window.tabContainer = tabContainer
    window.topBar = topBar
    window.controlButtons = controlButtons
    window.titleLabel = titleLabel
    
    -- Pencere listesine ekle
    table.insert(windows, window)
    
    return window
end

-- Pencere metodları
local Window = {}
Window.__index = Window

function Window:NewSection(name)
    local section = {}
    setmetatable(section, self)
    
    -- Section ID
    local sectionId = #self.sections + 1
    
    -- Section frame
    local sectionFrame = Instance.new("Frame", self.sectionContainer)
    sectionFrame.Size = UDim2.new(1, -10, 0, 300)
    sectionFrame.Position = UDim2.new(0, 5, 0, 10 + ((sectionId-1) * 310))
    sectionFrame.BackgroundColor3 = colors.section
    sectionFrame.BackgroundTransparency = 0.2
    sectionFrame.BorderSizePixel = 0
    roundCorners(sectionFrame, 8)
    
    -- Section başlığı
    local sectionTitle = Instance.new("TextLabel", sectionFrame)
    sectionTitle.Size = UDim2.new(1, -20, 0, 25)
    sectionTitle.Position = UDim2.new(0, 10, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = name or "Section"
    sectionTitle.TextColor3 = colors.accent
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextSize = 13
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Section alt çizgisi
    local sectionLine = Instance.new("Frame", sectionFrame)
    sectionLine.Size = UDim2.new(1, 0, 0, 1)
    sectionLine.Position = UDim2.new(0, 0, 0, 25)
    sectionLine.BackgroundColor3 = colors.accent
    sectionLine.BorderSizePixel = 0
    sectionLine.Transparency = 0.3
    
    -- Element container
    local elementContainer = Instance.new("Frame", sectionFrame)
    elementContainer.Size = UDim2.new(1, -20, 1, -35)
    elementContainer.Position = UDim2.new(0, 10, 0, 35)
    elementContainer.BackgroundTransparency = 1
    
    -- Element listesi
    section.elements = {}
    section.elementCount = 0
    section.frame = sectionFrame
    section.elementContainer = elementContainer
    
    -- Section'ı pencereye ekle
    table.insert(self.sections, section)
    
    -- CanvasSize güncelle
    self.sectionContainer.CanvasSize = UDim2.new(0, 0, 0, 10 + (sectionId * 310))
    
    return section
end

-- Section metodları
local Section = {}
Section.__index = Section

function Section:CreateButton(text, callback)
    local elementId = #self.elements + 1
    local yPosition = (elementId - 1) * 35
    
    local button = Instance.new("TextButton", self.elementContainer)
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, yPosition)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    button.BackgroundTransparency = 0.5
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = colors.accent
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    roundCorners(button, 6)
    
    -- Hover efekti
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.3
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0.5
    end)
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    -- Elementi kaydet
    local element = {
        instance = button,
        type = "Button",
        value = nil
    }
    
    table.insert(self.elements, element)
    self.elementCount = elementId
    
    return element
end

function Section:CreateToggle(text, default, callback)
    local elementId = #self.elements + 1
    local yPosition = (elementId - 1) * 35
    
    -- Toggle frame
    local toggleFrame = Instance.new("Frame", self.elementContainer)
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPosition)
    toggleFrame.BackgroundTransparency = 1
    
    -- Toggle label
    local toggleLabel = Instance.new("TextLabel", toggleFrame)
    toggleLabel.Size = UDim2.new(1, -60, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text .. ":"
    toggleLabel.TextColor3 = colors.accent
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 12
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle background
    local toggleBg = Instance.new("Frame", toggleFrame)
    toggleBg.Size = UDim2.new(0, 45, 0, 24)
    toggleBg.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
    toggleBg.BorderSizePixel = 0
    roundCorners(toggleBg, 12)
    
    -- Toggle circle
    local toggleCircle = Instance.new("Frame", toggleBg)
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    roundCorners(toggleCircle, 10)
    
    -- Toggle butonu
    local toggleBtn = Instance.new("TextButton", toggleFrame)
    toggleBtn.Size = UDim2.new(0, 45, 0, 24)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    
    -- Toggle state
    local toggleState = default or false
    
    -- Toggle fonksiyonu
    local function updateToggle()
        if toggleState then
            toggleBg.BackgroundColor3 = colors.accent
            toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
        else
            toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
        end
        
        if callback then
            callback(toggleState)
        end
    end
    
    -- Initial state
    updateToggle()
    
    -- Toggle click
    toggleBtn.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        updateToggle()
    end)
    
    -- Hover efekti
    toggleBtn.MouseEnter:Connect(function()
        toggleBg.BackgroundTransparency = 0.1
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        toggleBg.BackgroundTransparency = 0
    end)
    
    -- Elementi kaydet
    local element = {
        instance = toggleFrame,
        type = "Toggle",
        value = toggleState,
        get = function() return toggleState end,
        set = function(state)
            toggleState = state
            updateToggle()
        end
    }
    
    table.insert(self.elements, element)
    self.elementCount = elementId
    
    return element
end

function Section:CreateSlider(text, min, max, default, callback)
    local elementId = #self.elements + 1
    local yPosition = (elementId - 1) * 45
    
    -- Slider frame
    local sliderFrame = Instance.new("Frame", self.elementContainer)
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPosition)
    sliderFrame.BackgroundTransparency = 1
    
    -- Slider label
    local sliderLabel = Instance.new("TextLabel", sliderFrame)
    sliderLabel.Size = UDim2.new(0.5, 0, 0, 20)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text .. ":"
    sliderLabel.TextColor3 = colors.accent
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextSize = 12
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Slider value label
    local sliderValueLabel = Instance.new("TextLabel", sliderFrame)
    sliderValueLabel.Size = UDim2.new(0.5, 0, 0, 20)
    sliderValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
    sliderValueLabel.BackgroundTransparency = 1
    sliderValueLabel.Text = tostring(default or min) .. " / " .. tostring(max)
    sliderValueLabel.TextColor3 = colors.textSecondary
    sliderValueLabel.Font = Enum.Font.Gotham
    sliderValueLabel.TextSize = 12
    sliderValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    -- Slider bar background
    local sliderBg = Instance.new("Frame", sliderFrame)
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    sliderBg.BorderSizePixel = 0
    roundCorners(sliderBg, 3)
    
    -- Slider fill
    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = colors.accent
    sliderFill.BorderSizePixel = 0
    roundCorners(sliderFill, 3)
    
    -- Slider handle
    local sliderHandle = Instance.new("TextButton", sliderBg)
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new(0, -8, 0.5, -8)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Text = ""
    sliderHandle.AutoButtonColor = false
    roundCorners(sliderHandle, 8)
    createStroke(sliderHandle, colors.accent, 2)
    
    -- Slider logic
    local sliding = false
    local sliderValue = default or min
    
    -- Update slider fonksiyonu
    local function updateSlider(value, fromInput)
        local oldValue = sliderValue
        sliderValue = math.clamp(value, min, max)
        
        local percent = (sliderValue - min) / (max - min)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
        sliderValueLabel.Text = math.floor(sliderValue) .. " / " .. tostring(max)
        
        if fromInput and callback and sliderValue ~= oldValue then
            callback(sliderValue)
        end
    end
    
    -- Slider sürükleme
    local function startSliding()
        sliding = true
    end
    
    local function stopSliding()
        sliding = false
    end
    
    -- Mouse/touch input
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startSliding()
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local mouse = Players.LocalPlayer:GetMouse()
            local sliderAbsPos = sliderBg.AbsolutePosition
            local sliderAbsSize = sliderBg.AbsoluteSize
            
            local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
            local value = min + (relativeX * (max - min))
            updateSlider(value, true)
            startSliding()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopSliding()
        end
    end)
    
    -- Real-time update
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if sliding then
            local mouse = Players.LocalPlayer:GetMouse()
            local sliderAbsPos = sliderBg.AbsolutePosition
            local sliderAbsSize = sliderBg.AbsoluteSize
            
            local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
            local value = min + (relativeX * (max - min))
            updateSlider(value, true)
        else
            connection:Disconnect()
        end
    end)
    
    -- Initial value
    updateSlider(sliderValue, false)
    
    -- Elementi kaydet
    local element = {
        instance = sliderFrame,
        type = "Slider",
        value = sliderValue,
        get = function() return sliderValue end,
        set = function(value)
            updateSlider(value, false)
        end
    }
    
    table.insert(self.elements, element)
    self.elementCount = elementId
    
    return element
end

function Section:CreateDropdown(text, options, default, callback)
    local elementId = #self.elements + 1
    local yPosition = (elementId - 1) * 35
    
    -- Dropdown frame
    local dropdownFrame = Instance.new("Frame", self.elementContainer)
    dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
    dropdownFrame.Position = UDim2.new(0, 0, 0, yPosition)
    dropdownFrame.BackgroundTransparency = 1
    
    -- Dropdown label
    local dropdownLabel = Instance.new("TextLabel", dropdownFrame)
    dropdownLabel.Size = UDim2.new(0, 100, 1, 0)
    dropdownLabel.Position = UDim2.new(0, 0, 0, 0)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Text = text .. ":"
    dropdownLabel.TextColor3 = colors.accent
    dropdownLabel.Font = Enum.Font.Gotham
    dropdownLabel.TextSize = 12
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Dropdown button
    local dropdownBtn = Instance.new("TextButton", dropdownFrame)
    dropdownBtn.Size = UDim2.new(1, -110, 1, 0)
    dropdownBtn.Position = UDim2.new(0, 110, 0, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
    dropdownBtn.BackgroundTransparency = 0.5
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = default or options[1] or "Select"
    dropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 12
    roundCorners(dropdownBtn, 6)
    
    -- Dropdown options panel
    local dropdownOptions = Instance.new("Frame", gui)
    dropdownOptions.Size = UDim2.new(0, 150, 0, 100)
    dropdownOptions.Position = UDim2.new(0, 0, 0, 0)
    dropdownOptions.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
    dropdownOptions.BackgroundTransparency = 0
    dropdownOptions.BorderSizePixel = 0
    dropdownOptions.Visible = false
    dropdownOptions.ZIndex = 100
    roundCorners(dropdownOptions, 8)
    
    -- Options butonları
    local optionButtons = {}
    local optionHeight = 30
    local selectedOption = default or options[1]
    
    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton", dropdownOptions)
        optionBtn.Size = UDim2.new(1, -10, 0, optionHeight - 5)
        optionBtn.Position = UDim2.new(0, 5, 0, (i-1) * optionHeight + 5)
        optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
        optionBtn.BackgroundTransparency = 0.5
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = option
        optionBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextSize = 12
        optionBtn.ZIndex = 101
        roundCorners(optionBtn, 5)
        
        optionBtn.MouseEnter:Connect(function()
            optionBtn.BackgroundTransparency = 0.3
        end)
        
        optionBtn.MouseLeave:Connect(function()
            optionBtn.BackgroundTransparency = 0.5
        end)
        
        optionBtn.MouseButton1Click:Connect(function()
            selectedOption = option
            dropdownBtn.Text = option
            dropdownOptions.Visible = false
            
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
            local mainPos = gui.AbsolutePosition
            
            local relativeX = (btnPos.X - mainPos.X) / gui.AbsoluteSize.X
            local relativeY = (btnPos.Y - mainPos.Y + dropdownBtn.AbsoluteSize.Y) / gui.AbsoluteSize.Y
            
            dropdownOptions.Position = UDim2.new(relativeX, 0, relativeY, 0)
            dropdownOptions.Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, #options * optionHeight + 10)
        end
    end)
    
    -- Dropdown'u kapat
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    
    -- Hover efekti
    dropdownBtn.MouseEnter:Connect(function()
        dropdownBtn.BackgroundTransparency = 0.3
    end)
    
    dropdownBtn.MouseLeave:Connect(function()
        dropdownBtn.BackgroundTransparency = 0.5
    end)
    
    -- Elementi kaydet
    local element = {
        instance = dropdownFrame,
        type = "Dropdown",
        value = selectedOption,
        get = function() return selectedOption end,
        set = function(option)
            selectedOption = option
            dropdownBtn.Text = option
            if callback then
                callback(option)
            end
        end
    }
    
    table.insert(self.elements, element)
    self.elementCount = elementId
    
    return element
end

function Section:CreateTextbox(text, placeholder, callback)
    local elementId = #self.elements + 1
    local yPosition = (elementId - 1) * 35
    
    -- Textbox frame
    local textboxFrame = Instance.new("Frame", self.elementContainer)
    textboxFrame.Size = UDim2.new(1, 0, 0, 30)
    textboxFrame.Position = UDim2.new(0, 0, 0, yPosition)
    textboxFrame.BackgroundTransparency = 1
    
    -- Textbox label
    local textboxLabel = Instance.new("TextLabel", textboxFrame)
    textboxLabel.Size = UDim2.new(0, 100, 1, 0)
    textboxLabel.Position = UDim2.new(0, 0, 0, 0)
    textboxLabel.BackgroundTransparency = 1
    textboxLabel.Text = text .. ":"
    textboxLabel.TextColor3 = colors.accent
    textboxLabel.Font = Enum.Font.Gotham
    textboxLabel.TextSize = 12
    textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Textbox
    local textbox = Instance.new("TextBox", textboxFrame)
    textbox.Size = UDim2.new(1, -110, 1, 0)
    textbox.Position = UDim2.new(0, 110, 0, 0)
    textbox.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
    textbox.BackgroundTransparency = 0.6
    textbox.BorderSizePixel = 0
    textbox.Text = ""
    textbox.TextColor3 = Color3.fromRGB(220, 220, 240)
    textbox.Font = Enum.Font.Gotham
    textbox.TextSize = 12
    textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
    textbox.PlaceholderText = placeholder or "Enter text"
    roundCorners(textbox, 6)
    
    -- Focus efekti
    textbox.Focused:Connect(function()
        textbox.BackgroundTransparency = 0.5
    end)
    
    textbox.FocusLost:Connect(function()
        textbox.BackgroundTransparency = 0.6
        
        if callback then
            callback(textbox.Text)
        end
    end)
    
    -- Elementi kaydet
    local element = {
        instance = textboxFrame,
        type = "Textbox",
        value = "",
        get = function() return textbox.Text end,
        set = function(value)
            textbox.Text = value
            if callback then
                callback(value)
            end
        end
    }
    
    table.insert(self.elements, element)
    self.elementCount = elementId
    
    return element
end

function Section:CreateLabel(text)
    local elementId = #self.elements + 1
    local yPosition = (elementId - 1) * 25
    
    local label = Instance.new("TextLabel", self.elementContainer)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, yPosition)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = colors.accent
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Elementi kaydet
    local element = {
        instance = label,
        type = "Label",
        value = text
    }
    
    table.insert(self.elements, element)
    self.elementCount = elementId
    
    return element
end

-- Metatable bağlantıları
Window.__index = Section
OxireunUI.__index = Window

return OxireunUI
