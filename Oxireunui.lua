
-- Oxireun UI Library v1.0
-- Blade Runner 2049 Temalı

local Oxireun = {}
local themes = {}
local windows = {}
local notifications = {}

-- Servisler
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Tema Yönetimi
themes.BladeRunner = {
    Primary = Color3.fromRGB(0, 150, 255),
    Secondary = Color3.fromRGB(25, 20, 45),
    Background = Color3.fromRGB(30, 25, 60),
    Content = Color3.fromRGB(35, 30, 65),
    Text = Color3.fromRGB(180, 200, 255),
    TextSecondary = Color3.fromRGB(150, 150, 180),
    Success = Color3.fromRGB(0, 255, 150),
    Warning = Color3.fromRGB(255, 200, 0),
    Error = Color3.fromRGB(255, 80, 80)
}

themes.Cyberpunk = {
    Primary = Color3.fromRGB(255, 0, 150),
    Secondary = Color3.fromRGB(20, 15, 40),
    Background = Color3.fromRGB(35, 25, 65),
    Content = Color3.fromRGB(40, 30, 70),
    Text = Color3.fromRGB(255, 200, 220),
    TextSecondary = Color3.fromRGB(180, 150, 180),
    Success = Color3.fromRGB(0, 255, 150),
    Warning = Color3.fromRGB(255, 150, 0),
    Error = Color3.fromRGB(255, 50, 100)
}

themes.Matrix = {
    Primary = Color3.fromRGB(0, 255, 0),
    Secondary = Color3.fromRGB(10, 20, 10),
    Background = Color3.fromRGB(15, 25, 15),
    Content = Color3.fromRGB(20, 30, 20),
    Text = Color3.fromRGB(200, 255, 200),
    TextSecondary = Color3.fromRGB(150, 200, 150),
    Success = Color3.fromRGB(0, 255, 100),
    Warning = Color3.fromRGB(255, 255, 0),
    Error = Color3.fromRGB(255, 50, 50)
}

-- Yardımcı Fonksiyonlar
local function createRoundedFrame(parent, size, position, color, transparency, radius)
    local frame = Instance.new("Frame", parent)
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = transparency or 0
    frame.BorderSizePixel = 0
    
    if radius then
        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, radius)
    end
    
    return frame
end

local function createStroke(frame, color, thickness, transparency)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = transparency or 0
    return stroke
end

local function createTextLabel(parent, size, position, text, color, font, size, align)
    local label = Instance.new("TextLabel", parent)
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.Font = font
    label.TextSize = size
    label.TextXAlignment = align or Enum.TextXAlignment.Left
    return label
end

-- Notification Sistemi
function Oxireun:Notify(title, message, duration)
    duration = duration or 3
    
    -- Notification Container
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0.3, 0, 0, 70)
    notification.Position = UDim2.new(1, 0, 0.9, 0)
    notification.BackgroundColor3 = themes.BladeRunner.Content
    notification.BorderSizePixel = 0
    notification.ZIndex = 1000
    notification.Parent = Player.PlayerGui
    
    -- Köşe yuvarlatma
    local corner = Instance.new("UICorner", notification)
    corner.CornerRadius = UDim.new(0, 10)
    
    -- Neon Border
    local glow = createStroke(notification, themes.BladeRunner.Primary, 3, 0.3)
    
    -- Üst çizgi
    local topLine = createRoundedFrame(notification, UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 0, 0), themes.BladeRunner.Primary, 0, 0)
    
    -- İçerik
    local icon = createTextLabel(notification, UDim2.new(0, 40, 1, 0), UDim2.new(0, 10, 0, 0), "🔔", Color3.fromRGB(255, 200, 100), Enum.Font.GothamBold, 20, Enum.TextXAlignment.Center)
    
    local titleLabel = createTextLabel(notification, UDim2.new(1, -60, 0, 25), UDim2.new(0, 50, 0, 10), title, themes.BladeRunner.Text, Enum.Font.GothamBold, 14)
    
    local messageLabel = createTextLabel(notification, UDim2.new(1, -60, 0, 20), UDim2.new(0, 50, 0, 35), message, themes.BladeRunner.Text, Enum.Font.Gotham, 11)
    
    -- Animasyon
    local slideIn = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.7, 0, 0.9, 0)
    })
    
    slideIn:Play()
    
    -- Süre sonunda kapat
    task.spawn(function()
        task.wait(duration)
        local slideOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0.9, 0)
        })
        slideOut:Play()
        slideOut.Completed:Wait()
        notification:Destroy()
    end)
    
    return notification
end

-- Window Class
local Window = {}
Window.__index = Window

function Window:NewSection(name)
    local section = {}
    setmetatable(section, Section)
    
    section.name = name
    section.parent = self.contentArea
    section.elements = {}
    section.elementCount = 0
    section.elementHeight = 35
    section.spacing = 10
    
    -- Section Container
    section.container = createRoundedFrame(self.contentArea, UDim2.new(1, -20, 0, 0), UDim2.new(0, 10, 0, 10 + (#self.sections * 120)), self.theme.Content, 0.2, 8)
    
    -- Section Başlığı
    section.titleLabel = createTextLabel(section.container, UDim2.new(1, -20, 0, 25), UDim2.new(0, 10, 0, 0), name, self.theme.Primary, Enum.Font.GothamBold, 13)
    
    -- Section Çizgisi
    section.line = createRoundedFrame(section.container, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, 25), self.theme.Primary, 0.3, 0)
    
    -- Element Container
    section.elementContainer = Instance.new("Frame", section.container)
    section.elementContainer.Size = UDim2.new(1, -20, 1, -35)
    section.elementContainer.Position = UDim2.new(0, 10, 0, 35)
    section.elementContainer.BackgroundTransparency = 1
    
    -- Section'ı pencereye ekle
    table.insert(self.sections, section)
    
    -- Boyutu güncelle
    self:UpdateSize()
    
    return section
end

function Window:UpdateSize()
    local totalHeight = 90 -- Top bar + tabs + margin
    for _, section in ipairs(self.sections) do
        local sectionHeight = 35 + (section.elementCount * (section.elementHeight + section.spacing)) + 10
        section.container.Size = UDim2.new(1, -20, 0, sectionHeight)
        totalHeight = totalHeight + sectionHeight + 10
    end
    
    -- Ana pencere boyutunu güncelle
    self.mainFrame.Size = UDim2.new(0.4, 0, 0, math.min(totalHeight, 0.8))
    self.contentArea.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Section Class
local Section = {}
Section.__index = Section

function Section:CreateButton(text, callback)
    local button = Instance.new("TextButton", self.elementContainer)
    button.Size = UDim2.new(1, 0, 0, self.elementHeight)
    button.Position = UDim2.new(0, 0, 0, self.elementCount * (self.elementHeight + self.spacing))
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    button.BackgroundTransparency = 0.5
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = self.parent.parent.theme.Primary
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 6)
    
    -- Hover efekti
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.3
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0.5
    end)
    
    -- Tıklama
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
        print("[Button] " .. text .. " clicked")
    end)
    
    self.elementCount = self.elementCount + 1
    self.parent:UpdateSize()
    
    return button
end

function Section:CreateToggle(text, default, callback)
    local toggleFrame = Instance.new("Frame", self.elementContainer)
    toggleFrame.Size = UDim2.new(1, 0, 0, self.elementHeight)
    toggleFrame.Position = UDim2.new(0, 0, 0, self.elementCount * (self.elementHeight + self.spacing))
    toggleFrame.BackgroundTransparency = 1
    
    -- Toggle Label
    local label = createTextLabel(toggleFrame, UDim2.new(1, -60, 1, 0), UDim2.new(0, 0, 0, 0), text, self.parent.parent.theme.TextSecondary, Enum.Font.Gotham, 12)
    
    -- Toggle Background
    local toggleBg = createRoundedFrame(toggleFrame, UDim2.new(0, 45, 0, 24), UDim2.new(1, -50, 0.5, -12), Color3.fromRGB(180, 180, 190), 0, 12)
    
    -- Toggle Circle
    local toggleCircle = createRoundedFrame(toggleBg, UDim2.new(0, 20, 0, 20), default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10), Color3.fromRGB(255, 255, 255), 0, 10)
    
    -- Toggle Button (görünmez)
    local toggleBtn = Instance.new("TextButton", toggleFrame)
    toggleBtn.Size = UDim2.new(0, 45, 0, 24)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    
    local state = default or false
    
    -- Durumu güncelle
    local function updateState()
        state = not state
        if state then
            toggleBg.BackgroundColor3 = self.parent.parent.theme.Primary
            toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
        else
            toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
        end
        
        if callback then
            callback(state)
        end
        print("[Toggle] " .. text .. ": " .. tostring(state))
    end
    
    -- Başlangıç durumu
    if default then
        toggleBg.BackgroundColor3 = self.parent.parent.theme.Primary
    end
    
    toggleBtn.MouseButton1Click:Connect(updateState)
    
    self.elementCount = self.elementCount + 1
    self.parent:UpdateSize()
    
    return {Set = updateState, Value = function() return state end}
end

function Section:CreateTextbox(placeholder, callback)
    local textboxFrame = Instance.new("Frame", self.elementContainer)
    textboxFrame.Size = UDim2.new(1, 0, 0, self.elementHeight)
    textboxFrame.Position = UDim2.new(0, 0, 0, self.elementCount * (self.elementHeight + self.spacing))
    textboxFrame.BackgroundTransparency = 1
    
    -- Textbox
    local textbox = Instance.new("TextBox", textboxFrame)
    textbox.Size = UDim2.new(1, 0, 1, 0)
    textbox.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
    textbox.BackgroundTransparency = 0.6
    textbox.BorderSizePixel = 0
    textbox.Text = ""
    textbox.PlaceholderText = placeholder
    textbox.TextColor3 = Color3.fromRGB(220, 220, 240)
    textbox.Font = Enum.Font.Gotham
    textbox.TextSize = 12
    textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
    
    local corner = Instance.new("UICorner", textbox)
    corner.CornerRadius = UDim.new(0, 6)
    
    -- Focus efekti
    textbox.Focused:Connect(function()
        textbox.BackgroundTransparency = 0.5
    end)
    
    textbox.FocusLost:Connect(function()
        textbox.BackgroundTransparency = 0.6
        if callback then
            callback(textbox.Text)
        end
        print("[Textbox] Entered: " .. textbox.Text)
    end)
    
    self.elementCount = self.elementCount + 1
    self.parent:UpdateSize()
    
    return textbox
end

function Section:CreateDropdown(text, options, default, callback)
    local dropdownFrame = Instance.new("Frame", self.elementContainer)
    dropdownFrame.Size = UDim2.new(1, 0, 0, self.elementHeight)
    dropdownFrame.Position = UDim2.new(0, 0, 0, self.elementCount * (self.elementHeight + self.spacing))
    dropdownFrame.BackgroundTransparency = 1
    
    -- Label
    local label = createTextLabel(dropdownFrame, UDim2.new(0, 100, 1, 0), UDim2.new(0, 0, 0, 0), text, self.parent.parent.theme.TextSecondary, Enum.Font.Gotham, 12)
    
    -- Dropdown Button
    local dropdownBtn = Instance.new("TextButton", dropdownFrame)
    dropdownBtn.Size = UDim2.new(1, -110, 1, 0)
    dropdownBtn.Position = UDim2.new(0, 110, 0, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
    dropdownBtn.BackgroundTransparency = 0.5
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = options[default] or "Select"
    dropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 12
    
    local corner = Instance.new("UICorner", dropdownBtn)
    corner.CornerRadius = UDim.new(0, 6)
    
    -- Hover efekti
    dropdownBtn.MouseEnter:Connect(function()
        dropdownBtn.BackgroundTransparency = 0.3
    end)
    
    dropdownBtn.MouseLeave:Connect(function()
        dropdownBtn.BackgroundTransparency = 0.5
    end)
    
    -- Options Panel
    local dropdownOptions = Instance.new("Frame", Player.PlayerGui)
    dropdownOptions.Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, #options * 30 + 10)
    dropdownOptions.BackgroundColor3 = self.parent.parent.theme.Content
    dropdownOptions.BorderSizePixel = 0
    dropdownOptions.Visible = false
    dropdownOptions.ZIndex = 100
    
    local optionsCorner = Instance.new("UICorner", dropdownOptions)
    optionsCorner.CornerRadius = UDim.new(0, 8)
    
    -- Options
    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton", dropdownOptions)
        optionBtn.Size = UDim2.new(1, -10, 0, 25)
        optionBtn.Position = UDim2.new(0, 5, 0, (i-1) * 30 + 5)
        optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
        optionBtn.BackgroundTransparency = 0.5
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = option
        optionBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextSize = 12
        optionBtn.ZIndex = 101
        
        local optionCorner = Instance.new("UICorner", optionBtn)
        optionCorner.CornerRadius = UDim.new(0, 5)
        
        optionBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            dropdownOptions.Visible = false
            if callback then
                callback(option)
            end
            print("[Dropdown] " .. text .. ": " .. option)
        end)
    end
    
    -- Toggle Options
    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownOptions.Visible = not dropdownOptions.Visible
        
        if dropdownOptions.Visible then
            local btnPos = dropdownBtn.AbsolutePosition
            dropdownOptions.Position = UDim2.new(0, btnPos.X, 0, btnPos.Y + dropdownBtn.AbsoluteSize.Y)
        end
    end)
    
    -- Dışarı tıklayınca kapat
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local optionsPos = dropdownOptions.AbsolutePosition
            local optionsSize = dropdownOptions.AbsoluteSize
            
            if dropdownOptions.Visible then
                if not (mousePos.X >= optionsPos.X and mousePos.X <= optionsPos.X + optionsSize.X and
                       mousePos.Y >= optionsPos.Y and mousePos.Y <= optionsPos.Y + optionsSize.Y) then
                    dropdownOptions.Visible = false
                end
            end
        end
    end)
    
    self.elementCount = self.elementCount + 1
    self.parent:UpdateSize()
    
    return {Refresh = function(newOptions) 
        -- Options yenileme fonksiyonu
    end}
end

function Section:CreateSlider(text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", self.elementContainer)
    sliderFrame.Size = UDim2.new(1, 0, 0, 45)
    sliderFrame.Position = UDim2.new(0, 0, 0, self.elementCount * (self.elementHeight + self.spacing))
    sliderFrame.BackgroundTransparency = 1
    
    -- Label
    local label = createTextLabel(sliderFrame, UDim2.new(0.5, 0, 0, 20), UDim2.new(0, 0, 0, 0), text, self.parent.parent.theme.TextSecondary, Enum.Font.Gotham, 12)
    
    -- Value Label
    local valueLabel = createTextLabel(sliderFrame, UDim2.new(0.5, 0, 0, 20), UDim2.new(0.5, 0, 0, 0), default .. "%", self.parent.parent.theme.Text, Enum.Font.Gotham, 12, Enum.TextXAlignment.Right)
    
    -- Slider Background
    local sliderBg = createRoundedFrame(sliderFrame, UDim2.new(1, 0, 0, 6), UDim2.new(0, 0, 0, 25), Color3.fromRGB(50, 50, 75), 0, 3)
    
    -- Slider Fill
    local sliderFill = createRoundedFrame(sliderBg, UDim2.new((default - min) / (max - min), 0, 1, 0), UDim2.new(0, 0, 0, 0), self.parent.parent.theme.Primary, 0, 3)
    
    -- Slider Handle
    local sliderHandle = Instance.new("TextButton", sliderBg)
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Text = ""
    sliderHandle.AutoButtonColor = false
    
    local handleCorner = Instance.new("UICorner", sliderHandle)
    handleCorner.CornerRadius = UDim.new(1, 0)
    
    local handleStroke = createStroke(sliderHandle, self.parent.parent.theme.Primary, 2)
    
    -- Slider Logic
    local sliding = false
    local currentValue = default
    
    local function updateSlider(value)
        currentValue = math.clamp(value, min, max)
        local percent = (currentValue - min) / (max - min)
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
        valueLabel.Text = currentValue .. "%"
        
        if callback then
            callback(currentValue)
        end
        print("[Slider] " .. text .. ": " .. currentValue)
    end
    
    -- Sürükleme başlat
    local function startSliding()
        sliding = true
    end
    
    -- Sürükleme durdur
    local function stopSliding()
        sliding = false
    end
    
    -- Mouse hareketini dinle
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startSliding()
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = Player:GetMouse()
            local sliderAbsPos = sliderBg.AbsolutePosition
            local sliderAbsSize = sliderBg.AbsoluteSize
            
            local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
            local value = min + (relativeX * (max - min))
            updateSlider(value)
            startSliding()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = Player:GetMouse()
            local sliderAbsPos = sliderBg.AbsolutePosition
            local sliderAbsSize = sliderBg.AbsoluteSize
            
            local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
            local value = min + (relativeX * (max - min))
            updateSlider(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            stopSliding()
        end
    end)
    
    self.elementCount = self.elementCount + 1
    self.parent:UpdateSize()
    
    return {Set = updateSlider, Value = function() return currentValue end}
end

-- Ana Fonksiyonlar
function Oxireun:NewWindow(title, themeName)
    themeName = themeName or "BladeRunner"
    local theme = themes[themeName] or themes.BladeRunner
    
    -- ScreenGui
    local gui = Instance.new("ScreenGui", Player.PlayerGui)
    gui.Name = "OxireunGUI_" .. title
    gui.ResetOnSpawn = false
    
    -- Ana Pencere
    local window = {}
    setmetatable(window, Window)
    
    window.theme = theme
    window.sections = {}
    
    -- Ana Frame
    window.mainFrame = createRoundedFrame(gui, UDim2.new(0.4, 0, 0, 300), UDim2.new(0.03, 0, 0.1, 0), theme.Secondary, 0, 12)
    window.mainFrame.Active = true
    window.mainFrame.Draggable = true
    
    -- Neon Border
    createStroke(window.mainFrame, theme.Primary, 3, 0.2)
    
    -- Üst Bar
    local topBar = createRoundedFrame(window.mainFrame, UDim2.new(1, 0, 0, 45), UDim2.new(0, 0, 0, 0), theme.Background, 0, UDim.new(0, 12, 0, 0))
    
    -- Üst Bar Çizgisi
    local topBarLine = createRoundedFrame(topBar, UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 1, -2), theme.Primary, 0, 0)
    
    -- Başlık
    window.titleLabel = createTextLabel(topBar, UDim2.new(1, -80, 1, 0), UDim2.new(0, 15, 0, 0), title, theme.Text, Enum.Font.GothamBold, 16)
    
    -- Kapat Butonu
    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 50)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    
    local closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(0, 6)
    
    -- Kapat çizgileri
    local closeLine1 = createRoundedFrame(closeBtn, UDim2.new(0, 12, 0, 2), UDim2.new(0.5, -6, 0.5, -1), Color3.fromRGB(240, 120, 130), 0, 0)
    closeLine1.Rotation = 45
    
    local closeLine2 = createRoundedFrame(closeBtn, UDim2.new(0, 12, 0, 2), UDim2.new(0.5, -6, 0.5, -1), Color3.fromRGB(240, 120, 130), 0, 0)
    closeLine2.Rotation = -45
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- İçerik Alanı
    window.contentArea = Instance.new("ScrollingFrame", window.mainFrame)
    window.contentArea.Size = UDim2.new(1, -20, 1, -60)
    window.contentArea.Position = UDim2.new(0, 10, 0, 50)
    window.contentArea.BackgroundColor3 = theme.Content
    window.contentArea.BackgroundTransparency = 0
    window.contentArea.BorderSizePixel = 0
    window.contentArea.ScrollBarThickness = 4
    window.contentArea.ScrollBarImageColor3 = theme.Primary
    window.contentArea.ScrollBarImageTransparency = 0.7
    
    local contentCorner = Instance.new("UICorner", window.contentArea)
    contentCorner.CornerRadius = UDim.new(0, 8)
    
    -- Content Container
    window.contentContainer = Instance.new("Frame", window.contentArea)
    window.contentContainer.Size = UDim2.new(1, 0, 0, 0)
    window.contentContainer.BackgroundTransparency = 1
    
    window.contentArea.CanvasSize = window.contentContainer.Size
    
    -- Windows listesine ekle
    table.insert(windows, window)
    
    return window
end

-- Kullanıcıya dışa aktar
return Oxireun
