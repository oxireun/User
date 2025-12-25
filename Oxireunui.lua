-- OxireunUI Library v2.0
-- Author: @oxireun
-- Blade Runner 2049 Temalı Modern UI Library

local OxireunUI = {}
OxireunUI.__index = OxireunUI

-- Tema ayarları
OxireunUI.Theme = {
    Primary = Color3.fromRGB(0, 150, 255),   -- Neon mavi
    Secondary = Color3.fromRGB(25, 20, 45),  -- Koyu arkaplan
    Background = Color3.fromRGB(30, 25, 55), -- İçerik arkaplanı
    Text = Color3.fromRGB(220, 220, 240),    -- Açık text
    Accent = Color3.fromRGB(255, 100, 100),  -- Kırmızı aksan
    Success = Color3.fromRGB(100, 255, 100), -- Yeşil
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold
}

-- Utilities
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or OxireunUI.Theme.Primary
    stroke.Thickness = thickness or 2
    stroke.Parent = parent
    return stroke
end

-- Window Class
function OxireunUI:CreateWindow(config)
    config = config or {}
    local window = setmetatable({}, self)
    
    window.Title = config.Title or "OXIREUN UI"
    window.Size = config.Size or UDim2.fromScale(0.4, 0.75)
    window.Position = config.Position or UDim2.fromScale(0.03, 0.1)
    window.Theme = config.Theme or OxireunUI.Theme
    window.Tabs = {}
    window.CurrentTab = 1
    
    -- Ana GUI
    window.Gui = Instance.new("ScreenGui", game.CoreGui)
    window.Gui.Name = "OxireunUIGui"
    window.Gui.ResetOnSpawn = false
    window.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Ana frame
    window.Main = Instance.new("Frame", window.Gui)
    window.Main.Size = window.Size
    window.Main.Position = window.Position
    window.Main.BackgroundColor3 = window.Theme.Secondary
    window.Main.BackgroundTransparency = 0
    window.Main.BorderSizePixel = 0
    window.Main.Active = true
    window.Main.Draggable = true
    
    createCorner(window.Main, 12)
    createStroke(window.Main, window.Theme.Primary, 3).Transparency = 0.2
    
    -- Üst bar
    window.TopBar = Instance.new("Frame", window.Main)
    window.TopBar.Size = UDim2.new(1, 0, 0, 45)
    window.TopBar.Position = UDim2.new(0, 0, 0, 0)
    window.TopBar.BackgroundColor3 = Color3.fromRGB(30, 25, 60)
    window.TopBar.BackgroundTransparency = 0
    window.TopBar.BorderSizePixel = 0
    
    createCorner(window.TopBar, 12, 0, 0)
    
    -- Üst bar çizgisi
    local topBarLine = Instance.new("Frame", window.TopBar)
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = window.Theme.Primary
    topBarLine.BorderSizePixel = 0
    
    -- Başlık
    window.TitleLabel = Instance.new("TextLabel", window.TopBar)
    window.TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    window.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    window.TitleLabel.BackgroundTransparency = 1
    window.TitleLabel.Text = window.Title
    window.TitleLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
    window.TitleLabel.Font = window.Theme.FontBold
    window.TitleLabel.TextSize = 16
    window.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Kontrol butonları
    window.ControlButtons = Instance.new("Frame", window.TopBar)
    window.ControlButtons.Size = UDim2.new(0, 60, 1, 0)
    window.ControlButtons.Position = UDim2.new(1, -65, 0, 0)
    window.ControlButtons.BackgroundTransparency = 1
    
    -- Kapat butonu
    window.CloseButton = Instance.new("TextButton", window.ControlButtons)
    window.CloseButton.Size = UDim2.new(0, 26, 0, 26)
    window.CloseButton.Position = UDim2.new(0, 30, 0.5, -13)
    window.CloseButton.BackgroundColor3 = Color3.fromRGB(70, 40, 50)
    window.CloseButton.BackgroundTransparency = 0.6
    window.CloseButton.BorderSizePixel = 0
    window.CloseButton.Text = ""
    createCorner(window.CloseButton, 6)
    
    -- X işareti
    local closeLine1 = Instance.new("Frame", window.CloseButton)
    closeLine1.Size = UDim2.new(0, 12, 0, 2)
    closeLine1.Position = UDim2.new(0.5, -6, 0.5, -1)
    closeLine1.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    closeLine1.BorderSizePixel = 0
    closeLine1.Rotation = 45
    
    local closeLine2 = Instance.new("Frame", window.CloseButton)
    closeLine2.Size = UDim2.new(0, 12, 0, 2)
    closeLine2.Position = UDim2.new(0.5, -6, 0.5, -1)
    closeLine2.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    closeLine2.BorderSizePixel = 0
    closeLine2.Rotation = -45
    
    -- Hover efekti
    window.CloseButton.MouseEnter:Connect(function()
        window.CloseButton.BackgroundTransparency = 0.4
        closeLine1.BackgroundColor3 = Color3.fromRGB(255, 140, 150)
        closeLine2.BackgroundColor3 = Color3.fromRGB(255, 140, 150)
    end)
    
    window.CloseButton.MouseLeave:Connect(function()
        window.CloseButton.BackgroundTransparency = 0.6
        closeLine1.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
        closeLine2.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    end)
    
    -- Kapatma işlevi
    window.CloseButton.MouseButton1Click:Connect(function()
        window.Gui:Destroy()
    end)
    
    -- Tab container
    window.TabContainer = Instance.new("Frame", window.Main)
    window.TabContainer.Size = UDim2.new(1, -20, 0, 35)
    window.TabContainer.Position = UDim2.new(0, 10, 0, 50)
    window.TabContainer.BackgroundTransparency = 1
    
    -- Aktif tab çizgisi
    window.ActiveTabLine = Instance.new("Frame", window.TabContainer)
    window.ActiveTabLine.Size = UDim2.new(0.2, -10, 0, 3)
    window.ActiveTabLine.Position = UDim2.new(0, 5, 1, -3)
    window.ActiveTabLine.BackgroundColor3 = window.Theme.Primary
    window.ActiveTabLine.BorderSizePixel = 0
    createCorner(window.ActiveTabLine, 1, 0)
    
    -- İçerik alanı
    window.ContentArea = Instance.new("Frame", window.Main)
    window.ContentArea.Size = UDim2.new(1, -20, 1, -100)
    window.ContentArea.Position = UDim2.new(0, 10, 0, 90)
    window.ContentArea.BackgroundColor3 = window.Theme.Background
    window.ContentArea.BackgroundTransparency = 0
    window.ContentArea.BorderSizePixel = 0
    window.ContentArea.ClipsDescendants = true
    createCorner(window.ContentArea, 8)
    
    -- Tab içerik container
    window.ContentContainer = Instance.new("Frame", window.ContentArea)
    window.ContentContainer.Size = UDim2.new(5, 0, 1, 0)
    window.ContentContainer.Position = UDim2.new(0, 0, 0, 0)
    window.ContentContainer.BackgroundTransparency = 1
    
    -- Notification sistemi
    window.NotificationContainer = Instance.new("Frame", window.Gui)
    window.NotificationContainer.Size = UDim2.new(0.25, 0, 0, 70)
    window.NotificationContainer.Position = UDim2.new(0.75, 0, 0.75, 0)
    window.NotificationContainer.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
    window.NotificationContainer.BackgroundTransparency = 0
    window.NotificationContainer.BorderSizePixel = 0
    window.NotificationContainer.Visible = false
    window.NotificationContainer.ZIndex = 1000
    createCorner(window.NotificationContainer, 10)
    createStroke(window.NotificationContainer, window.Theme.Primary, 3).Transparency = 0.3
    
    -- Notification içeriği
    local notifTopLine = Instance.new("Frame", window.NotificationContainer)
    notifTopLine.Size = UDim2.new(1, 0, 0, 2)
    notifTopLine.Position = UDim2.new(0, 0, 0, 0)
    notifTopLine.BackgroundColor3 = window.Theme.Primary
    notifTopLine.BorderSizePixel = 0
    
    window.NotifIcon = Instance.new("TextLabel", window.NotificationContainer)
    window.NotifIcon.Size = UDim2.new(0, 40, 1, 0)
    window.NotifIcon.Position = UDim2.new(0, 10, 0, 0)
    window.NotifIcon.BackgroundTransparency = 1
    window.NotifIcon.Text = "🔔"
    window.NotifIcon.TextColor3 = Color3.fromRGB(255, 200, 100)
    window.NotifIcon.Font = window.Theme.FontBold
    window.NotifIcon.TextSize = 20
    
    window.NotifTitle = Instance.new("TextLabel", window.NotificationContainer)
    window.NotifTitle.Size = UDim2.new(1, -60, 0, 25)
    window.NotifTitle.Position = UDim2.new(0, 50, 0, 10)
    window.NotifTitle.BackgroundTransparency = 1
    window.NotifTitle.Text = "Notification"
    window.NotifTitle.TextColor3 = Color3.fromRGB(180, 200, 255)
    window.NotifTitle.Font = window.Theme.FontBold
    window.NotifTitle.TextSize = 14
    window.NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    window.NotifMessage = Instance.new("TextLabel", window.NotificationContainer)
    window.NotifMessage.Size = UDim2.new(1, -60, 0, 20)
    window.NotifMessage.Position = UDim2.new(0, 50, 0, 35)
    window.NotifMessage.BackgroundTransparency = 1
    window.NotifMessage.Text = "System notification"
    window.NotifMessage.TextColor3 = Color3.fromRGB(200, 220, 240)
    window.NotifMessage.Font = window.Theme.Font
    window.NotifMessage.TextSize = 11
    window.NotifMessage.TextXAlignment = Enum.TextXAlignment.Left
    
    return window
end

-- Tab ekleme
function OxireunUI:AddTab(name)
    local tabIndex = #self.Tabs + 1
    local tab = {
        Name = name,
        Index = tabIndex,
        Sections = {}
    }
    
    -- Tab butonu
    local tabButton = Instance.new("TextButton", self.TabContainer)
    tabButton.Size = UDim2.new(0.2, -5, 1, 0)
    tabButton.Position = UDim2.new((tabIndex-1) * 0.2, 0, 0, 0)
    tabButton.BackgroundTransparency = 1
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(150, 150, 180)
    tabButton.Font = self.Theme.Font
    tabButton.TextSize = 12
    
    -- Tab içerik frame
    local contentFrame = Instance.new("Frame", self.ContentContainer)
    contentFrame.Size = UDim2.new(0.2, 0, 1, 0)
    contentFrame.Position = UDim2.new((tabIndex-1) * 0.2, 0, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = tabIndex == 1
    
    -- Scroll container
    local scroll = Instance.new("ScrollingFrame", contentFrame)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.Position = UDim2.new(0, 0, 0, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = self.Theme.Primary
    scroll.ScrollBarImageTransparency = 0.7
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local scrollContent = Instance.new("Frame", scroll)
    scrollContent.Size = UDim2.new(1, 0, 0, 0)
    scrollContent.BackgroundTransparency = 1
    scrollContent.Name = "ScrollContent"
    
    tab.Button = tabButton
    tab.Frame = contentFrame
    tab.Scroll = scroll
    tab.ScrollContent = scrollContent
    
    -- Hover efekti
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= tabIndex then
            tabButton.TextColor3 = Color3.fromRGB(200, 220, 255)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabIndex then
            tabButton.TextColor3 = Color3.fromRGB(150, 150, 180)
        end
    end)
    
    -- Click event
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(tabIndex)
    end)
    
    table.insert(self.Tabs, tab)
    
    -- İlk tab aktif
    if tabIndex == 1 then
        tabButton.TextColor3 = self.Theme.Primary
        tabButton.Active = true
    end
    
    -- Tab fonksiyonlarını ekle
    local tabMethods = {}
    
    function tabMethods:AddSection(title)
        local section = Instance.new("Frame", scrollContent)
        section.Size = UDim2.new(1, -10, 0, 40) -- Başlangıç yüksekliği
        section.Position = UDim2.new(0, 5, 0, (#scrollContent:GetChildren() * 45) + 10)
        section.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
        section.BackgroundTransparency = 0.2
        section.BorderSizePixel = 0
        createCorner(section, 8)
        
        -- Section başlığı
        local sectionTitle = Instance.new("TextLabel", section)
        sectionTitle.Size = UDim2.new(1, -20, 0, 25)
        sectionTitle.Position = UDim2.new(0, 10, 0, 0)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Text = title
        sectionTitle.TextColor3 = self.Theme.Primary
        sectionTitle.Font = self.Theme.FontBold
        sectionTitle.TextSize = 13
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Section çizgisi
        local sectionLine = Instance.new("Frame", section)
        sectionLine.Size = UDim2.new(1, 0, 0, 1)
        sectionLine.Position = UDim2.new(0, 0, 0, 25)
        sectionLine.BackgroundColor3 = self.Theme.Primary
        sectionLine.BorderSizePixel = 0
        sectionLine.Transparency = 0.3
        
        -- İçerik container
        local contentContainer = Instance.new("Frame", section)
        contentContainer.Size = UDim2.new(1, 0, 1, -30)
        contentContainer.Position = UDim2.new(0, 0, 0, 30)
        contentContainer.BackgroundTransparency = 1
        contentContainer.Name = "ContentContainer"
        
        -- Yükseklik update fonksiyonu
        local function updateHeight()
            local totalHeight = 30
            for _, child in ipairs(contentContainer:GetChildren()) do
                if child:IsA("Frame") then
                    totalHeight += child.Size.Y.Offset + 5
                end
            end
            section.Size = UDim2.new(1, -10, 0, totalHeight + 10)
            
            -- Scroll canvas size güncelle
            local scrollHeight = 10
            for _, sect in ipairs(scrollContent:GetChildren()) do
                if sect:IsA("Frame") then
                    scrollHeight += sect.Size.Y.Offset + 5
                end
            end
            scrollContent.Size = UDim2.new(1, 0, 0, scrollHeight)
            scroll.CanvasSize = scrollContent.Size
        end
        
        local sectionMethods = {}
        
        function sectionMethods:AddButton(config)
            config = config or {}
            local buttonFrame = Instance.new("Frame", contentContainer)
            buttonFrame.Size = UDim2.new(1, -20, 0, 30)
            buttonFrame.Position = UDim2.new(0, 10, 0, #contentContainer:GetChildren() * 35)
            buttonFrame.BackgroundTransparency = 1
            
            local button = Instance.new("TextButton", buttonFrame)
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
            button.BackgroundTransparency = 0.5
            button.BorderSizePixel = 0
            button.Text = config.Text or "Button"
            button.TextColor3 = config.Color or self.Theme.Primary
            button.Font = self.Theme.Font
            button.TextSize = 12
            createCorner(button, 6)
            
            -- Hover efekti
            button.MouseEnter:Connect(function()
                button.BackgroundTransparency = 0.3
            end)
            
            button.MouseLeave:Connect(function()
                button.BackgroundTransparency = 0.5
            end)
            
            -- Click event
            if config.Callback then
                button.MouseButton1Click:Connect(config.Callback)
            end
            
            updateHeight()
            
            local buttonMethods = {}
            
            function buttonMethods:SetText(text)
                button.Text = text
            end
            
            function buttonMethods:SetCallback(callback)
                button.MouseButton1Click:Disconnect()
                button.MouseButton1Click:Connect(callback)
            end
            
            return buttonMethods
        end
        
        function sectionMethods:AddLabel(text, color)
            local labelFrame = Instance.new("Frame", contentContainer)
            labelFrame.Size = UDim2.new(1, -20, 0, 25)
            labelFrame.Position = UDim2.new(0, 10, 0, #contentContainer:GetChildren() * 30)
            labelFrame.BackgroundTransparency = 1
            
            local label = Instance.new("TextLabel", labelFrame)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = text or "Label"
            label.TextColor3 = color or self.Theme.Text
            label.Font = self.Theme.Font
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            updateHeight()
            
            local labelMethods = {}
            
            function labelMethods:SetText(newText)
                label.Text = newText
            end
            
            return labelMethods
        end
        
        function sectionMethods:AddToggle(config)
            config = config or {}
            local toggleFrame = Instance.new("Frame", contentContainer)
            toggleFrame.Size = UDim2.new(1, -20, 0, 30)
            toggleFrame.Position = UDim2.new(0, 10, 0, #contentContainer:GetChildren() * 35)
            toggleFrame.BackgroundTransparency = 1
            
            -- Label
            local toggleLabel = Instance.new("TextLabel", toggleFrame)
            toggleLabel.Size = UDim2.new(1, -60, 1, 0)
            toggleLabel.Position = UDim2.new(0, 0, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = config.Text or "Toggle"
            toggleLabel.TextColor3 = self.Theme.Text
            toggleLabel.Font = self.Theme.Font
            toggleLabel.TextSize = 12
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Toggle background
            local toggleBg = Instance.new("Frame", toggleFrame)
            toggleBg.Size = UDim2.new(0, 45, 0, 24)
            toggleBg.Position = UDim2.new(1, -50, 0.5, -12)
            toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
            toggleBg.BorderSizePixel = 0
            createCorner(toggleBg, 12)
            
            -- Toggle circle
            local toggleCircle = Instance.new("Frame", toggleBg)
            toggleCircle.Size = UDim2.new(0, 20, 0, 20)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0
            createCorner(toggleCircle, 10)
            
            -- Toggle butonu
            local toggleBtn = Instance.new("TextButton", toggleFrame)
            toggleBtn.Size = UDim2.new(0, 45, 0, 24)
            toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            
            -- State
            local state = config.Default or false
            
            -- Update görünüm
            local function updateToggle()
                if state then
                    toggleBg.BackgroundColor3 = self.Theme.Primary
                    toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                else
                    toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                end
            end
            
            -- Toggle fonksiyonu
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                updateToggle()
                if config.Callback then
                    config.Callback(state)
                end
            end)
            
            -- Hover efekti
            toggleBtn.MouseEnter:Connect(function()
                toggleBg.BackgroundTransparency = 0.1
            end)
            
            toggleBtn.MouseLeave:Connect(function()
                toggleBg.BackgroundTransparency = 0
            end)
            
            -- Başlangıç state'i
            updateToggle()
            
            updateHeight()
            
            local toggleMethods = {}
            
            function toggleMethods:SetState(newState)
                state = newState
                updateToggle()
            end
            
            function toggleMethods:GetState()
                return state
            end
            
            return toggleMethods
        end
        
        function sectionMethods:AddSlider(config)
            config = config or {}
            local sliderFrame = Instance.new("Frame", contentContainer)
            sliderFrame.Size = UDim2.new(1, -20, 0, 40)
            sliderFrame.Position = UDim2.new(0, 10, 0, #contentContainer:GetChildren() * 45)
            sliderFrame.BackgroundTransparency = 1
            
            -- Label
            local sliderLabel = Instance.new("TextLabel", sliderFrame)
            sliderLabel.Size = UDim2.new(0.5, 0, 0, 20)
            sliderLabel.Position = UDim2.new(0, 0, 0, 0)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = config.Text or "Slider"
            sliderLabel.TextColor3 = self.Theme.Text
            sliderLabel.Font = self.Theme.Font
            sliderLabel.TextSize = 12
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Değer label
            local valueLabel = Instance.new("TextLabel", sliderFrame)
            valueLabel.Size = UDim2.new(0.5, 0, 0, 20)
            valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = config.Default or 50 .. "%"
            valueLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
            valueLabel.Font = self.Theme.Font
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            -- Slider background
            local sliderBg = Instance.new("Frame", sliderFrame)
            sliderBg.Size = UDim2.new(1, 0, 0, 6)
            sliderBg.Position = UDim2.new(0, 0, 0, 25)
            sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
            sliderBg.BorderSizePixel = 0
            createCorner(sliderBg, 3)
            
            -- Slider fill
            local sliderFill = Instance.new("Frame", sliderBg)
            sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = self.Theme.Primary
            sliderFill.BorderSizePixel = 0
            createCorner(sliderFill, 3)
            
            -- Slider handle
            local sliderHandle = Instance.new("TextButton", sliderBg)
            sliderHandle.Size = UDim2.new(0, 16, 0, 16)
            sliderHandle.Position = UDim2.new(0.5, -8, 0.5, -8)
            sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderHandle.BorderSizePixel = 0
            sliderHandle.Text = ""
            sliderHandle.AutoButtonColor = false
            createCorner(sliderHandle, 8)
            createStroke(sliderHandle, self.Theme.Primary, 2)
            
            -- Slider logic
            local min = config.Min or 0
            local max = config.Max or 100
            local defaultValue = config.Default or 50
            local currentValue = defaultValue
            local sliding = false
            
            local function updateSlider(value)
                currentValue = math.clamp(value, min, max)
                local percent = (currentValue - min) / (max - min)
                
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
                valueLabel.Text = tostring(math.floor(currentValue)) .. (config.Suffix or "")
                
                if config.Callback then
                    config.Callback(currentValue)
                end
            end
            
            -- Sürükleme fonksiyonları
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            
            local function startSliding()
                sliding = true
                tab.Scroll.ScrollingEnabled = false
            end
            
            local function stopSliding()
                sliding = false
                tab.Scroll.ScrollingEnabled = true
            end
            
            local function updateSliderFromInput()
                if sliding then
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local sliderAbsPos = sliderBg.AbsolutePosition
                    local sliderAbsSize = sliderBg.AbsoluteSize
                    
                    local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                    updateSlider(min + (relativeX * (max - min)))
                end
            end
            
            -- Input event'leri
            sliderHandle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    startSliding()
                end
            end)
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local sliderAbsPos = sliderBg.AbsolutePosition
                    local sliderAbsSize = sliderBg.AbsoluteSize
                    
                    local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                    updateSlider(min + (relativeX * (max - min)))
                    startSliding()
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    stopSliding()
                end
            end)
            
            -- Sürüklerken güncelle
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if sliding then
                    updateSliderFromInput()
                else
                    connection:Disconnect()
                end
            end)
            
            -- Başlangıç değeri
            updateSlider(defaultValue)
            
            updateHeight()
            
            local sliderMethods = {}
            
            function sliderMethods:SetValue(value)
                updateSlider(value)
            end
            
            function sliderMethods:GetValue()
                return currentValue
            end
            
            return sliderMethods
        end
        
        function sectionMethods:AddTextBox(config)
            config = config or {}
            local textboxFrame = Instance.new("Frame", contentContainer)
            textboxFrame.Size = UDim2.new(1, -20, 0, 30)
            textboxFrame.Position = UDim2.new(0, 10, 0, #contentContainer:GetChildren() * 35)
            textboxFrame.BackgroundTransparency = 1
            
            -- Label
            local textboxLabel = Instance.new("TextLabel", textboxFrame)
            textboxLabel.Size = UDim2.new(0, 100, 1, 0)
            textboxLabel.Position = UDim2.new(0, 0, 0, 0)
            textboxLabel.BackgroundTransparency = 1
            textboxLabel.Text = config.Text or "Text:"
            textboxLabel.TextColor3 = self.Theme.Text
            textboxLabel.Font = self.Theme.Font
            textboxLabel.TextSize = 12
            textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            -- TextBox
            local textbox = Instance.new("TextBox", textboxFrame)
            textbox.Size = UDim2.new(1, -110, 1, 0)
            textbox.Position = UDim2.new(0, 110, 0, 0)
            textbox.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
            textbox.BackgroundTransparency = 0.6
            textbox.BorderSizePixel = 0
            textbox.Text = config.Default or ""
            textbox.TextColor3 = self.Theme.Text
            textbox.Font = self.Theme.Font
            textbox.TextSize = 12
            textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
            textbox.PlaceholderText = config.Placeholder or "Enter text..."
            createCorner(textbox, 6)
            
            -- Focus efekti
            textbox.Focused:Connect(function()
                textbox.BackgroundTransparency = 0.5
            end)
            
            textbox.FocusLost:Connect(function(enterPressed)
                textbox.BackgroundTransparency = 0.6
                if config.Callback then
                    config.Callback(textbox.Text, enterPressed)
                end
            end)
            
            updateHeight()
            
            local textboxMethods = {}
            
            function textboxMethods:SetText(text)
                textbox.Text = text
            end
            
            function textboxMethods:GetText()
                return textbox.Text
            end
            
            return textboxMethods
        end
        
        function sectionMethods:AddDropdown(config)
            config = config or {}
            local dropdownFrame = Instance.new("Frame", contentContainer)
            dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
            dropdownFrame.Position = UDim2.new(0, 10, 0, #contentContainer:GetChildren() * 35)
            dropdownFrame.BackgroundTransparency = 1
            
            -- Label
            local dropdownLabel = Instance.new("TextLabel", dropdownFrame)
            dropdownLabel.Size = UDim2.new(0, 100, 1, 0)
            dropdownLabel.Position = UDim2.new(0, 0, 0, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = config.Text or "Options:"
            dropdownLabel.TextColor3 = self.Theme.Text
            dropdownLabel.Font = self.Theme.Font
            dropdownLabel.TextSize = 12
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Dropdown butonu
            local dropdownBtn = Instance.new("TextButton", dropdownFrame)
            dropdownBtn.Size = UDim2.new(1, -110, 1, 0)
            dropdownBtn.Position = UDim2.new(0, 110, 0, 0)
            dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
            dropdownBtn.BackgroundTransparency = 0.5
            dropdownBtn.BorderSizePixel = 0
            dropdownBtn.Text = config.Default or "Select"
            dropdownBtn.TextColor3 = self.Theme.Text
            dropdownBtn.Font = self.Theme.Font
            dropdownBtn.TextSize = 12
            createCorner(dropdownBtn, 6)
            
            -- Hover efekti
            dropdownBtn.MouseEnter:Connect(function()
                dropdownBtn.BackgroundTransparency = 0.3
            end)
            
            dropdownBtn.MouseLeave:Connect(function()
                dropdownBtn.BackgroundTransparency = 0.5
            end)
            
            -- Dropdown options panel
            local dropdownOptions = Instance.new("Frame", self.Gui)
            dropdownOptions.Size = UDim2.new(0, 150, 0, 100)
            dropdownOptions.Position = UDim2.new(0, 0, 0, 0)
            dropdownOptions.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
            dropdownOptions.BackgroundTransparency = 0
            dropdownOptions.BorderSizePixel = 0
            dropdownOptions.Visible = false
            dropdownOptions.ZIndex = 100
            createCorner(dropdownOptions, 8)
            
            -- Options
            local options = config.Options or {"Option 1", "Option 2", "Option 3"}
            
            -- Options container
            local optionsContainer = Instance.new("Frame", dropdownOptions)
            optionsContainer.Size = UDim2.new(1, 0, 1, 0)
            optionsContainer.BackgroundTransparency = 1
            
            local UIListLayout = Instance.new("UIListLayout", optionsContainer)
            UIListLayout.Padding = UDim.new(0, 5)
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            -- Create option buttons
            local optionButtons = {}
            
            for i, option in ipairs(options) do
                local optionBtn = Instance.new("TextButton", optionsContainer)
                optionBtn.Size = UDim2.new(1, -10, 0, 25)
                optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
                optionBtn.BackgroundTransparency = 0.5
                optionBtn.BorderSizePixel = 0
                optionBtn.Text = option
                optionBtn.TextColor3 = self.Theme.Text
                optionBtn.Font = self.Theme.Font
                optionBtn.TextSize = 12
                optionBtn.ZIndex = 101
                createCorner(optionBtn, 5)
                
                optionBtn.MouseEnter:Connect(function()
                    optionBtn.BackgroundTransparency = 0.3
                end)
                
                optionBtn.MouseLeave:Connect(function()
                    optionBtn.BackgroundTransparency = 0.5
                end)
                
                optionBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = option
                    dropdownOptions.Visible = false
                    if config.Callback then
                        config.Callback(option)
                    end
                end)
                
                table.insert(optionButtons, optionBtn)
            end
            
            -- Update dropdown panel size
            local optionHeight = 30
            dropdownOptions.Size = UDim2.new(0, 150, 0, #options * optionHeight + 10)
            
            -- Dropdown toggle
            dropdownBtn.MouseButton1Click:Connect(function()
                dropdownOptions.Visible = not dropdownOptions.Visible
                
                if dropdownOptions.Visible then
                    local btnPos = dropdownBtn.AbsolutePosition
                    dropdownOptions.Position = UDim2.new(
                        0, btnPos.X,
                        0, btnPos.Y + dropdownBtn.AbsoluteSize.Y
                    )
                end
            end)
            
            -- Close dropdown when clicking outside
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
            
            updateHeight()
            
            local dropdownMethods = {}
            
            function dropdownMethods:SetOptions(newOptions)
                options = newOptions
                -- Clear old buttons
                for _, btn in ipairs(optionButtons) do
                    btn:Destroy()
                end
                optionButtons = {}
                
                -- Create new buttons
                for i, option in ipairs(options) do
                    local optionBtn = Instance.new("TextButton", optionsContainer)
                    optionBtn.Size = UDim2.new(1, -10, 0, 25)
                    optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
                    optionBtn.BackgroundTransparency = 0.5
                    optionBtn.BorderSizePixel = 0
                    optionBtn.Text = option
                    optionBtn.TextColor3 = self.Theme.Text
                    optionBtn.Font = self.Theme.Font
                    optionBtn.TextSize = 12
                    optionBtn.ZIndex = 101
                    createCorner(optionBtn, 5)
                    
                    optionBtn.MouseEnter:Connect(function()
                        optionBtn.BackgroundTransparency = 0.3
                    end)
                    
                    optionBtn.MouseLeave:Connect(function()
                        optionBtn.BackgroundTransparency = 0.5
                    end)
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        dropdownBtn.Text = option
                        dropdownOptions.Visible = false
                        if config.Callback then
                            config.Callback(option)
                        end
                    end)
                    
                    table.insert(optionButtons, optionBtn)
                end
                
                -- Update size
                dropdownOptions.Size = UDim2.new(0, 150, 0, #options * optionHeight + 10)
            end
            
            function dropdownMethods:SetSelected(option)
                dropdownBtn.Text = option
            end
            
            return dropdownMethods
        end
        
        table.insert(self.Sections, sectionMethods)
        return sectionMethods
    end
    
    table.insert(self.Tabs, tab)
    return tabMethods
end

-- Tab değiştirme fonksiyonu
function OxireunUI:SwitchTab(tabIndex)
    if tabIndex < 1 or tabIndex > #self.Tabs then return end
    
    -- Eski tab'ı deaktif et
    if self.CurrentTab and self.Tabs[self.CurrentTab] then
        self.Tabs[self.CurrentTab].Button.TextColor3 = Color3.fromRGB(150, 150, 180)
        self.Tabs[self.CurrentTab].Button.Active = false
        self.Tabs[self.CurrentTab].Frame.Visible = false
    end
    
    -- Yeni tab'ı aktif et
    self.CurrentTab = tabIndex
    self.Tabs[tabIndex].Button.TextColor3 = self.Theme.Primary
    self.Tabs[tabIndex].Button.Active = true
    self.Tabs[tabIndex].Frame.Visible = true
    
    -- Tab çizgisini güncelle
    self.ActiveTabLine:TweenPosition(
        UDim2.new((tabIndex-1) * 0.2, 5, 1, -3),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.2,
        true
    )
    
    return true
end

-- Notification fonksiyonu
function OxireunUI:Notify(title, message)
    if self.IsNotifying then return end
    
    self.IsNotifying = true
    
    self.NotificationContainer.Position = UDim2.new(0.75, 0, 1, 0)
    self.NotificationContainer.Visible = true
    
    self.NotifTitle.Text = title
    self.NotifMessage.Text = message
    
    -- Slide-up animasyon
    self.NotificationContainer:TweenPosition(
        UDim2.new(0.75, 0, 0.75, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.4,
        true
    )
    
    -- Yanıp sönme efekti
    spawn(function()
        for i = 1, 2 do
            wait(0.2)
            self.NotifIcon.TextColor3 = Color3.fromRGB(255, 255, 150)
            wait(0.2)
            self.NotifIcon.TextColor3 = Color3.fromRGB(255, 200, 100)
        end
    end)
    
    -- 2 saniye bekle ve kapat
    wait(2)
    
    self.NotificationContainer:TweenPosition(
        UDim2.new(0.75, 0, 1, 0),
        Enum.EasingDirection.In,
        Enum.EasingStyle.Quad,
        0.3,
        true
    )
    
    wait(0.3)
    self.NotificationContainer.Visible = false
    self.IsNotifying = false
end

-- GUI'yi kapat
function OxireunUI:Destroy()
    self.Gui:Destroy()
end

-- GUI'yi göster/gizle
function OxireunUI:SetVisible(visible)
    self.Gui.Enabled = visible
end

-- Global export
return OxireunUI
