-- Oxireun UI Library v1.0
-- Blade Runner 2049 Theme
-- GitHub: https://github.com/oxireun

local Oxireun = {}
Oxireun.__index = Oxireun

-- Servisler
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Renk paleti
local Colors = {
    Primary = Color3.fromRGB(0, 150, 255),
    Background = Color3.fromRGB(25, 20, 45),
    Secondary = Color3.fromRGB(30, 25, 55),
    Text = Color3.fromRGB(220, 220, 240),
    TextSecondary = Color3.fromRGB(150, 150, 180),
    Accent = Color3.fromRGB(255, 50, 150)
}

-- Yardımcı fonksiyonlar
local function createCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

local function createStroke(parent, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Parent = parent
    stroke.Thickness = thickness
    stroke.Color = color
    stroke.Transparency = transparency or 0
    return stroke
end

-- PENCERE SINIFI
local Window = {}
Window.__index = Window

function Window.new(title)
    local self = setmetatable({}, Window)
    self.title = title or "Oxireun UI"
    self.sections = {}
    self.open = true
    
    self:createUI()
    return self
end

function Window:createUI()
    -- Ana GUI
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "OxireunGUI"
    self.gui.ResetOnSpawn = false
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.Parent = game.CoreGui
    
    -- Ana çerçeve
    self.main = Instance.new("Frame")
    self.main.Size = UDim2.fromScale(0.4, 0.75)
    self.main.Position = UDim2.fromScale(0.03, 0.1)
    self.main.BackgroundColor3 = Colors.Background
    self.main.BorderSizePixel = 0
    self.main.Active = true
    self.main.Draggable = true
    self.main.Parent = self.gui
    
    createCorner(12).Parent = self.main
    createStroke(self.main, 3, Colors.Primary, 0.2)
    
    -- Üst bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.BackgroundColor3 = Color3.fromRGB(30, 25, 60)
    topBar.BorderSizePixel = 0
    topBar.Parent = self.main
    
    local topBarCorner = createCorner(12)
    topBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    topBarCorner.Parent = topBar
    
    -- Üst bar çizgisi
    local topBarLine = Instance.new("Frame")
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = Colors.Primary
    topBarLine.BorderSizePixel = 0
    topBarLine.Parent = topBar
    
    -- Başlık
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.title
    titleLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    
    -- Kontrol butonları
    local controlButtons = Instance.new("Frame")
    controlButtons.Size = UDim2.new(0, 60, 1, 0)
    controlButtons.Position = UDim2.new(1, -65, 0, 0)
    controlButtons.BackgroundTransparency = 1
    controlButtons.Parent = topBar
    
    -- Kapat butonu
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(0, 30, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 50)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.Parent = controlButtons
    
    createCorner(6).Parent = closeBtn
    
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
        self.gui:Destroy()
        self.open = false
    end)
    
    -- İçerik alanı
    self.contentArea = Instance.new("ScrollingFrame")
    self.contentArea.Size = UDim2.new(1, -20, 1, -70)
    self.contentArea.Position = UDim2.new(0, 10, 0, 60)
    self.contentArea.BackgroundTransparency = 1
    self.contentArea.BorderSizePixel = 0
    self.contentArea.ScrollBarThickness = 4
    self.contentArea.ScrollBarImageColor3 = Colors.Primary
    self.contentArea.ScrollBarImageTransparency = 0.7
    self.contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.contentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.contentArea.Parent = self.main
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = self.contentArea
    
    self.sectionContainer = Instance.new("Frame")
    self.sectionContainer.Size = UDim2.new(1, 0, 0, 0)
    self.sectionContainer.BackgroundTransparency = 1
    self.sectionContainer.Parent = self.contentArea
    
    self.sectionLayout = Instance.new("UIListLayout")
    self.sectionLayout.Padding = UDim.new(0, 10)
    self.sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.sectionLayout.Parent = self.sectionContainer
    
    -- Notification sistemi
    self:createNotificationSystem()
end

function Window:createNotificationSystem()
    self.notificationContainer = Instance.new("Frame")
    self.notificationContainer.Size = UDim2.new(0.25, 0, 0, 70)
    self.notificationContainer.Position = UDim2.new(0.75, 0, 1, 0)
    self.notificationContainer.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
    self.notificationContainer.BorderSizePixel = 0
    self.notificationContainer.Visible = false
    self.notificationContainer.ZIndex = 1000
    self.notificationContainer.Parent = self.gui
    
    createCorner(10).Parent = self.notificationContainer
    createStroke(self.notificationContainer, 3, Colors.Primary, 0.3)
    
    -- Üst çizgi
    local notifTopLine = Instance.new("Frame")
    notifTopLine.Size = UDim2.new(1, 0, 0, 2)
    notifTopLine.BackgroundColor3 = Colors.Primary
    notifTopLine.BorderSizePixel = 0
    notifTopLine.Parent = self.notificationContainer
    
    -- İkon
    local notifIcon = Instance.new("TextLabel")
    notifIcon.Size = UDim2.new(0, 40, 1, 0)
    notifIcon.Position = UDim2.new(0, 10, 0, 0)
    notifIcon.BackgroundTransparency = 1
    notifIcon.Text = "🔔"
    notifIcon.TextColor3 = Color3.fromRGB(255, 200, 100)
    notifIcon.Font = Enum.Font.GothamBold
    notifIcon.TextSize = 20
    notifIcon.Parent = self.notificationContainer
    
    -- Başlık
    self.notifTitle = Instance.new("TextLabel")
    self.notifTitle.Size = UDim2.new(1, -60, 0, 25)
    self.notifTitle.Position = UDim2.new(0, 50, 0, 10)
    self.notifTitle.BackgroundTransparency = 1
    self.notifTitle.Text = "Notification"
    self.notifTitle.TextColor3 = Color3.fromRGB(180, 200, 255)
    self.notifTitle.Font = Enum.Font.GothamBold
    self.notifTitle.TextSize = 14
    self.notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    self.notifTitle.Parent = self.notificationContainer
    
    -- Mesaj
    self.notifMessage = Instance.new("TextLabel")
    self.notifMessage.Size = UDim2.new(1, -60, 0, 20)
    self.notifMessage.Position = UDim2.new(0, 50, 0, 35)
    self.notifMessage.BackgroundTransparency = 1
    self.notifMessage.Text = "System notification"
    self.notifMessage.TextColor3 = Color3.fromRGB(200, 220, 240)
    self.notifMessage.Font = Enum.Font.Gotham
    self.notifMessage.TextSize = 11
    self.notifMessage.TextXAlignment = Enum.TextXAlignment.Left
    self.notifMessage.Parent = self.notificationContainer
end

function Window:ShowNotification(title, message, duration)
    duration = duration or 2
    local isNotifying = false
    
    if isNotifying then return end
    
    isNotifying = true
    
    self.notificationContainer.Position = UDim2.new(0.75, 0, 1, 0)
    self.notificationContainer.Visible = true
    
    self.notifTitle.Text = title
    self.notifMessage.Text = message
    
    -- Slide-up animasyonu
    self.notificationContainer:TweenPosition(
        UDim2.new(0.75, 0, 0.75, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.4,
        true
    )
    
    -- Bekle ve kapat
    spawn(function()
        wait(duration)
        
        -- Slide-down animasyonu
        self.notificationContainer:TweenPosition(
            UDim2.new(0.75, 0, 1, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        
        wait(0.3)
        self.notificationContainer.Visible = false
        isNotifying = false
    end)
end

function Window:NewSection(name)
    local section = {
        name = name,
        elements = {},
        order = 0
    }
    
    -- Section container
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, 0, 0, 0)
    sectionFrame.BackgroundColor3 = Colors.Secondary
    sectionFrame.BackgroundTransparency = 0.2
    sectionFrame.BorderSizePixel = 0
    sectionFrame.LayoutOrder = #self.sections + 1
    sectionFrame.Parent = self.sectionContainer
    
    createCorner(8).Parent = sectionFrame
    
    -- Section başlığı
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, -20, 0, 25)
    sectionTitle.Position = UDim2.new(0, 10, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = name:upper()
    sectionTitle.TextColor3 = Colors.Primary
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextSize = 13
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = sectionFrame
    
    -- Section alt çizgisi
    local sectionLine = Instance.new("Frame")
    sectionLine.Size = UDim2.new(1, 0, 0, 1)
    sectionLine.Position = UDim2.new(0, 0, 0, 25)
    sectionLine.BackgroundColor3 = Colors.Primary
    sectionLine.BorderSizePixel = 0
    sectionLine.Transparency = 0.3
    sectionLine.Parent = sectionFrame
    
    -- Elementler için container
    local elementsContainer = Instance.new("Frame")
    elementsContainer.Size = UDim2.new(1, -20, 0, 0)
    elementsContainer.Position = UDim2.new(0, 10, 0, 30)
    elementsContainer.BackgroundTransparency = 1
    elementsContainer.Parent = sectionFrame
    
    local elementsLayout = Instance.new("UIListLayout")
    elementsLayout.Padding = UDim.new(0, 10)
    elementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    elementsLayout.Parent = elementsContainer
    
    -- Section metotları
    function section:CreateButton(name, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
        button.BackgroundTransparency = 0.5
        button.BorderSizePixel = 0
        button.Text = name
        button.TextColor3 = Colors.Primary
        button.Font = Enum.Font.Gotham
        button.TextSize = 12
        button.LayoutOrder = #self.elements + 1
        button.Parent = elementsContainer
        
        createCorner(6).Parent = button
        
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
            print("[Button] " .. name .. " clicked")
        end)
        
        table.insert(self.elements, button)
        
        -- Container boyutunu güncelle
        elementsContainer.Size = UDim2.new(1, 0, 0, (#self.elements * 40))
        sectionFrame.Size = UDim2.new(1, 0, 0, 40 + (#self.elements * 40))
        
        return button
    end
    
    function section:CreateTextbox(name, callback, placeholder)
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Size = UDim2.new(1, 0, 0, 30)
        textboxFrame.BackgroundTransparency = 1
        textboxFrame.LayoutOrder = #self.elements + 1
        textboxFrame.Parent = elementsContainer
        
        local textboxLabel = Instance.new("TextLabel")
        textboxLabel.Size = UDim2.new(0, 100, 1, 0)
        textboxLabel.BackgroundTransparency = 1
        textboxLabel.Text = name .. ":"
        textboxLabel.TextColor3 = Colors.Primary
        textboxLabel.Font = Enum.Font.Gotham
        textboxLabel.TextSize = 12
        textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        textboxLabel.Parent = textboxFrame
        
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(1, -110, 1, 0)
        textbox.Position = UDim2.new(0, 110, 0, 0)
        textbox.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
        textbox.BackgroundTransparency = 0.6
        textbox.BorderSizePixel = 0
        textbox.Text = ""
        textbox.TextColor3 = Colors.Text
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 12
        textbox.PlaceholderColor3 = Colors.TextSecondary
        textbox.PlaceholderText = placeholder or "Enter text"
        textbox.Parent = textboxFrame
        
        createCorner(6).Parent = textbox
        
        -- Focus efekti
        textbox.Focused:Connect(function()
            textbox.BackgroundTransparency = 0.5
        end)
        
        textbox.FocusLost:Connect(function(enterPressed)
            textbox.BackgroundTransparency = 0.6
            if enterPressed and callback then
                callback(textbox.Text)
            end
            print("[Textbox] " .. name .. ": " .. textbox.Text)
        end)
        
        table.insert(self.elements, textboxFrame)
        
        -- Container boyutunu güncelle
        elementsContainer.Size = UDim2.new(1, 0, 0, (#self.elements * 40))
        sectionFrame.Size = UDim2.new(1, 0, 0, 40 + (#self.elements * 40))
        
        return textbox
    end
    
    function section:CreateToggle(name, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 30)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.LayoutOrder = #self.elements + 1
        toggleFrame.Parent = elementsContainer
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = name .. ":"
        toggleLabel.TextColor3 = Colors.Primary
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 12
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        -- Toggle arkaplan
        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.new(0, 45, 0, 24)
        toggleBg.Position = UDim2.new(1, -50, 0.5, -12)
        toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
        toggleBg.BorderSizePixel = 0
        toggleBg.Parent = toggleFrame
        
        createCorner(12).Parent = toggleBg
        
        -- Toggle daire
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 20, 0, 20)
        toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleBg
        
        createCorner(10).Parent = toggleCircle
        
        -- Toggle butonu
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 45, 0, 24)
        toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
        toggleBtn.BackgroundTransparency = 1
        toggleBtn.Text = ""
        toggleBtn.Parent = toggleFrame
        
        local toggleState = false
        
        -- Toggle fonksiyonu
        toggleBtn.MouseButton1Click:Connect(function()
            toggleState = not toggleState
            
            if toggleState then
                -- Açık
                toggleBg.BackgroundColor3 = Colors.Primary
                toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                if callback then
                    callback(true)
                end
                print("[Toggle] " .. name .. ": ON")
            else
                -- Kapalı
                toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                if callback then
                    callback(false)
                end
                print("[Toggle] " .. name .. ": OFF")
            end
        end)
        
        -- Hover efekti
        toggleBtn.MouseEnter:Connect(function()
            toggleBg.BackgroundTransparency = 0.1
        end)
        
        toggleBtn.MouseLeave:Connect(function()
            toggleBg.BackgroundTransparency = 0
        end)
        
        table.insert(self.elements, toggleFrame)
        
        -- Container boyutunu güncelle
        elementsContainer.Size = UDim2.new(1, 0, 0, (#self.elements * 40))
        sectionFrame.Size = UDim2.new(1, 0, 0, 40 + (#self.elements * 40))
        
        return {Toggle = toggleBtn, Set = function(state)
            toggleState = state
            if state then
                toggleBg.BackgroundColor3 = Colors.Primary
                toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
            else
                toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
            end
        end}
    end
    
    function section:CreateDropdown(name, options, default, callback)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
        dropdownFrame.BackgroundTransparency = 1
        dropdownFrame.LayoutOrder = #self.elements + 1
        dropdownFrame.Parent = elementsContainer
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Size = UDim2.new(0, 100, 1, 0)
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Text = name .. ":"
        dropdownLabel.TextColor3 = Colors.Primary
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.TextSize = 12
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.Parent = dropdownFrame
        
        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Size = UDim2.new(1, -110, 1, 0)
        dropdownBtn.Position = UDim2.new(0, 110, 0, 0)
        dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
        dropdownBtn.BackgroundTransparency = 0.5
        dropdownBtn.BorderSizePixel = 0
        dropdownBtn.Text = options[default or 1] or "Select"
        dropdownBtn.TextColor3 = Colors.Text
        dropdownBtn.Font = Enum.Font.Gotham
        dropdownBtn.TextSize = 12
        dropdownBtn.Parent = dropdownFrame
        
        createCorner(6).Parent = dropdownBtn
        
        -- Hover efekti
        dropdownBtn.MouseEnter:Connect(function()
            dropdownBtn.BackgroundTransparency = 0.3
        end)
        
        dropdownBtn.MouseLeave:Connect(function()
            dropdownBtn.BackgroundTransparency = 0.5
        end)
        
        -- Dropdown panel
        local dropdownOptions = Instance.new("Frame")
        dropdownOptions.Size = UDim2.new(0, 150, 0, 0)
        dropdownOptions.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
        dropdownOptions.BackgroundTransparency = 0
        dropdownOptions.BorderSizePixel = 0
        dropdownOptions.Visible = false
        dropdownOptions.ZIndex = 100
        dropdownOptions.Parent = self.main
        
        createCorner(8).Parent = dropdownOptions
        
        local optionsLayout = Instance.new("UIListLayout")
        optionsLayout.Padding = UDim.new(0, 5)
        optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        optionsLayout.Parent = dropdownOptions
        
        -- Seçenekler
        for i, option in ipairs(options) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Size = UDim2.new(1, -10, 0, 25)
            optionBtn.Position = UDim2.new(0, 5, 0, (i-1) * 30 + 5)
            optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
            optionBtn.BackgroundTransparency = 0.5
            optionBtn.BorderSizePixel = 0
            optionBtn.Text = option
            optionBtn.TextColor3 = Colors.Text
            optionBtn.Font = Enum.Font.Gotham
            optionBtn.TextSize = 12
            optionBtn.ZIndex = 101
            optionBtn.Parent = dropdownOptions
            
            createCorner(5).Parent = optionBtn
            
            optionBtn.MouseEnter:Connect(function()
                optionBtn.BackgroundTransparency = 0.3
                optionBtn.BackgroundColor3 = Color3.fromRGB(65, 55, 95)
            end)
            
            optionBtn.MouseLeave:Connect(function()
                optionBtn.BackgroundTransparency = 0.5
                optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
            end)
            
            optionBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                dropdownOptions.Visible = false
                if callback then
                    callback(option)
                end
                print("[Dropdown] " .. name .. ": " .. option)
            end)
        end
        
        -- Dropdown boyutunu ayarla
        dropdownOptions.Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, #options * 30 + 10)
        
        -- Dropdown toggle
        dropdownBtn.MouseButton1Click:Connect(function()
            dropdownOptions.Visible = not dropdownOptions.Visible
            
            if dropdownOptions.Visible then
                local btnPos = dropdownBtn.AbsolutePosition
                local mainPos = self.main.AbsolutePosition
                
                local relativeX = (btnPos.X - mainPos.X) / self.main.AbsoluteSize.X
                local relativeY = (btnPos.Y - mainPos.Y + dropdownBtn.AbsoluteSize.Y) / self.main.AbsoluteSize.Y
                
                dropdownOptions.Position = UDim2.new(relativeX, 0, relativeY, 0)
            end
        end)
        
        -- Dışarı tıklayınca kapat
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
        
        table.insert(self.elements, dropdownFrame)
        
        -- Container boyutunu güncelle
        elementsContainer.Size = UDim2.new(1, 0, 0, (#self.elements * 40))
        sectionFrame.Size = UDim2.new(1, 0, 0, 40 + (#self.elements * 40))
        
        return {Dropdown = dropdownBtn, Set = function(option)
            dropdownBtn.Text = option
        end}
    end
    
    function section:CreateSlider(name, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 40)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.LayoutOrder = #self.elements + 1
        sliderFrame.Parent = elementsContainer
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(0.5, 0, 0, 20)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = name .. ":"
        sliderLabel.TextColor3 = Colors.Primary
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 12
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local sliderValueLabel = Instance.new("TextLabel")
        sliderValueLabel.Size = UDim2.new(0.5, 0, 0, 20)
        sliderValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
        sliderValueLabel.BackgroundTransparency = 1
        sliderValueLabel.Text = default .. ""
        sliderValueLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
        sliderValueLabel.Font = Enum.Font.Gotham
        sliderValueLabel.TextSize = 12
        sliderValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        sliderValueLabel.Parent = sliderFrame
        
        -- Slider bar
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, 0, 0, 6)
        sliderBg.Position = UDim2.new(0, 0, 0, 25)
        sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = sliderFrame
        
        createCorner(3).Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Colors.Primary
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        
        createCorner(3).Parent = sliderFill
        
        -- Slider handle
        local sliderHandle = Instance.new("TextButton")
        sliderHandle.Size = UDim2.new(0, 16, 0, 16)
        sliderHandle.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
        sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderHandle.BorderSizePixel = 0
        sliderHandle.Text = ""
        sliderHandle.AutoButtonColor = false
        sliderHandle.Parent = sliderBg
        
        createCorner(8).Parent = sliderHandle
        createStroke(sliderHandle, 2, Colors.Primary)
        
        -- Slider logic
        local sliding = false
        local currentValue = default or min
        
        local function updateSlider(value)
            currentValue = math.clamp(math.floor(value), min, max)
            local percent = (currentValue - min) / (max - min)
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
            sliderValueLabel.Text = currentValue .. ""
            
            if callback then
                callback(currentValue)
            end
            print("[Slider] " .. name .. ": " .. currentValue)
        end
        
        -- Sürükleme fonksiyonları
        local function startSliding()
            sliding = true
        end
        
        local function stopSliding()
            sliding = false
        end
        
        local function updateFromMouse()
            if sliding then
                local mouse = game.Players.LocalPlayer:GetMouse()
                local sliderAbsPos = sliderBg.AbsolutePosition
                local sliderAbsSize = sliderBg.AbsoluteSize
                
                local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                updateSlider(min + (relativeX * (max - min)))
            end
        end
        
        -- Event'ler
        sliderHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                startSliding()
            end
        end)
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local mouse = game.Players.LocalPlayer:GetMouse()
                local sliderAbsPos = sliderBg.AbsolutePosition
                local sliderAbsSize = sliderBg.AbsoluteSize
                
                local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                updateSlider(min + (relativeX * (max - min)))
                startSliding()
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                stopSliding()
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if sliding then
                    updateFromMouse()
                end
            end
        end)
        
        table.insert(self.elements, sliderFrame)
        
        -- Container boyutunu güncelle
        elementsContainer.Size = UDim2.new(1, 0, 0, (#self.elements * 40))
        sectionFrame.Size = UDim2.new(1, 0, 0, 40 + (#self.elements * 40))
        
        return {Slider = sliderBg, Set = function(value)
            updateSlider(value)
        end}
    end
    
    table.insert(self.sections, section)
    return section
end

-- OXIREUN KÜTÜPHANESİ METOTLARI
function Oxireun:NewWindow(title)
    local window = Window.new(title)
    return window
end

function Oxireun:SendNotification(title, text, duration)
    duration = duration or 2
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration;
    })
end

-- Kütüphaneyi döndür
return Oxireun
