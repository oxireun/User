-- OXI UI Library v1.0
-- By: Oxireun
-- GitHub: https://github.com/oxireun/OxiUI

local OxiUI = {}
OxiUI.__index = OxiUI

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Renk paleti
OxiUI.Colors = {
    Primary = Color3.fromRGB(0, 150, 255),
    Background = Color3.fromRGB(25, 20, 45),
    Secondary = Color3.fromRGB(30, 25, 60),
    Text = Color3.fromRGB(220, 220, 240),
    Accent = Color3.fromRGB(180, 200, 255)
}

-- Fontlar
OxiUI.Fonts = {
    Title = Enum.Font.GothamBold,
    Header = Enum.Font.GothamBold,
    Body = Enum.Font.Gotham,
    Small = Enum.Font.Gotham
}

-- Yeni Pencere oluştur
function OxiUI:NewWindow(title)
    local self = setmetatable({}, OxiUI)
    
    self.Window = self:CreateWindow(title)
    self.Tabs = {}
    self.CurrentTab = nil
    
    return self
end

-- Ana pencere oluştur
function OxiUI:CreateWindow(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "OxiUI_" .. tostring(math.random(1000, 9999))
    gui.Parent = game.CoreGui
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Ana çerçeve
    local main = Instance.new("Frame")
    main.Size = UDim2.fromScale(0.4, 0.75)
    main.Position = UDim2.fromScale(0.03, 0.1)
    main.BackgroundColor3 = self.Colors.Background
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    
    local mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, 12)
    
    local mainGlow = Instance.new("UIStroke", main)
    mainGlow.Color = self.Colors.Primary
    mainGlow.Thickness = 3
    mainGlow.Transparency = 0.2
    
    -- Üst bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = self.Colors.Secondary
    topBar.BackgroundTransparency = 0
    topBar.BorderSizePixel = 0
    topBar.Name = "TopBar"
    topBar.Parent = main
    
    local topBarCorner = Instance.new("UICorner", topBar)
    topBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    
    local topBarLine = Instance.new("Frame", topBar)
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = self.Colors.Primary
    topBarLine.BorderSizePixel = 0
    
    -- Kontrol butonları
    local controlButtons = Instance.new("Frame", topBar)
    controlButtons.Size = UDim2.new(0, 60, 1, 0)
    controlButtons.Position = UDim2.new(1, -65, 0, 0)
    controlButtons.BackgroundTransparency = 1
    
    -- Close butonu
    local closeBtn = Instance.new("TextButton", controlButtons)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(0, 30, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 50)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    
    local closeLine1 = Instance.new("Frame", closeBtn)
    closeLine1.Size = UDim2.new(0, 12, 0, 2)
    closeLine1.Position = UDim2.new(0.5, -6, 0.5, -1)
    closeLine1.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    closeLine1.BorderSizePixel = 0
    closeLine1.Rotation = 45
    
    local closeLine2 = Instance.new("Frame", closeBtn)
    closeLine2.Size = UDim2.new(0, 12, 0, 2)
    closeLine2.Position = UDim2.new(0.5, -6, 0.5, -1)
    closeLine2.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    closeLine2.BorderSizePixel = 0
    closeLine2.Rotation = -45
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Başlık
    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "OxiUI"
    titleLabel.TextColor3 = self.Colors.Accent
    titleLabel.Font = self.Fonts.Title
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
    Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 8)
    
    -- Tab container'ı
    local tabContentContainer = Instance.new("Frame", contentArea)
    tabContentContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContentContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContentContainer.BackgroundTransparency = 1
    
    return {
        GUI = gui,
        Main = main,
        TopBar = topBar,
        TabContainer = tabContainer,
        ContentArea = contentArea,
        TabContentContainer = tabContentContainer,
        TitleLabel = titleLabel
    }
end

-- Yeni Tab ekle
function OxiUI:NewTab(name)
    local tabIndex = #self.Tabs + 1
    
    -- Tab butonu
    local tabButton = Instance.new("TextButton", self.Window.TabContainer)
    tabButton.Size = UDim2.new(1/#self.Window.TabContainer:GetChildren(), -5, 1, 0)
    tabButton.Position = UDim2.new((tabIndex-1) * (1/#self.Window.TabContainer:GetChildren()), 0, 0, 0)
    tabButton.BackgroundTransparency = 1
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(150, 150, 180)
    tabButton.Font = self.Fonts.Body
    tabButton.TextSize = 12
    tabButton.Name = "Tab_" .. name
    
    -- Tab içerik frame'i
    local tabFrame = Instance.new("ScrollingFrame", self.Window.TabContentContainer)
    tabFrame.Size = UDim2.new(1/#self.Window.TabContentContainer:GetChildren(), 0, 1, 0)
    tabFrame.Position = UDim2.new((tabIndex-1) * (1/#self.Window.TabContentContainer:GetChildren()), 0, 0, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 4
    tabFrame.ScrollBarImageColor3 = self.Colors.Primary
    tabFrame.ScrollBarImageTransparency = 0.7
    tabFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    tabFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
    tabFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    tabFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.Visible = tabIndex == 1
    
    local contentLayout = Instance.new("UIListLayout", tabFrame)
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local tabData = {
        Name = name,
        Button = tabButton,
        Frame = tabFrame,
        Sections = {},
        ContentLayout = contentLayout
    }
    
    table.insert(self.Tabs, tabData)
    
    -- İlk tab'ı aktif yap
    if #self.Tabs == 1 then
        self:SwitchTab(1)
    end
    
    -- Buton event'leri
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(tabIndex)
    end)
    
    -- Hover efekti
    tabButton.MouseEnter:Connect(function()
        if tabButton.TextColor3 ~= self.Colors.Primary then
            tabButton.TextColor3 = Color3.fromRGB(200, 220, 255)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if tabButton.TextColor3 ~= self.Colors.Primary then
            tabButton.TextColor3 = Color3.fromRGB(150, 150, 180)
        end
    end)
    
    -- Tab boyutlarını güncelle
    self:UpdateTabLayout()
    
    return {
        NewSection = function(sectionName)
            return self:NewSection(tabIndex, sectionName)
        end
    }
end

-- Tab layout'u güncelle
function OxiUI:UpdateTabLayout()
    local tabCount = #self.Tabs
    if tabCount == 0 then return end
    
    for i, tab in ipairs(self.Tabs) do
        tab.Button.Size = UDim2.new(1/tabCount, -5, 1, 0)
        tab.Button.Position = UDim2.new((i-1) * (1/tabCount), 0, 0, 0)
        tab.Frame.Size = UDim2.new(1/tabCount, 0, 1, 0)
        tab.Frame.Position = UDim2.new((i-1) * (1/tabCount), 0, 0, 0)
    end
end

-- Tab değiştir
function OxiUI:SwitchTab(index)
    if self.CurrentTab then
        self.Tabs[self.CurrentTab].Button.TextColor3 = Color3.fromRGB(150, 150, 180)
        self.Tabs[self.CurrentTab].Frame.Visible = false
    end
    
    self.CurrentTab = index
    self.Tabs[index].Button.TextColor3 = self.Colors.Primary
    self.Tabs[index].Frame.Visible = true
end

-- Yeni Section ekle
function OxiUI:NewSection(tabIndex, name)
    local tab = self.Tabs[tabIndex]
    if not tab then return end
    
    -- Section container
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, -10, 0, 0) -- Height auto
    sectionFrame.Position = UDim2.new(0, 5, 0, 0)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
    sectionFrame.BackgroundTransparency = 0.2
    sectionFrame.BorderSizePixel = 0
    sectionFrame.LayoutOrder = #tab.Sections + 1
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    sectionFrame.Parent = tab.Frame
    
    local sectionCorner = Instance.new("UICorner", sectionFrame)
    sectionCorner.CornerRadius = UDim.new(0, 8)
    
    -- Section başlığı
    local titleLabel = Instance.new("TextLabel", sectionFrame)
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.TextColor3 = self.Colors.Primary
    titleLabel.Font = self.Fonts.Header
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Section alt çizgisi
    local titleLine = Instance.new("Frame", sectionFrame)
    titleLine.Size = UDim2.new(1, 0, 0, 1)
    titleLine.Position = UDim2.new(0, 0, 0, 25)
    titleLine.BackgroundColor3 = self.Colors.Primary
    titleLine.BorderSizePixel = 0
    titleLine.Transparency = 0.3
    
    -- İçerik container
    local contentFrame = Instance.new("Frame", sectionFrame)
    contentFrame.Size = UDim2.new(1, -20, 0, 0)
    contentFrame.Position = UDim2.new(0, 10, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local contentLayout = Instance.new("UIListLayout", contentFrame)
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Canvas size'ı güncelle
    tab.Frame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.AbsoluteContentSize.Y + 50)
    
    -- Section verisi
    local sectionData = {
        Name = name,
        Frame = sectionFrame,
        Content = contentFrame,
        Controls = {}
    }
    
    table.insert(tab.Sections, sectionData)
    
    -- Kontrol fonksiyonları
    local sectionControls = {}
    
    -- BUTTON
    function sectionControls:CreateButton(name, callback)
        local button = Instance.new("TextButton", contentFrame)
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
        button.BackgroundTransparency = 0.5
        button.BorderSizePixel = 0
        button.Text = name
        button.TextColor3 = self.Colors.Primary
        button.Font = self.Fonts.Body
        button.TextSize = 12
        button.LayoutOrder = #contentFrame:GetChildren()
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
        
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
        
        -- Canvas size güncelle
        task.wait()
        tab.Frame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.AbsoluteContentSize.Y + 50)
        
        return {
            SetText = function(newText)
                button.Text = newText
            end,
            SetCallback = function(newCallback)
                callback = newCallback
            end,
            Destroy = function()
                button:Destroy()
            end
        }
    end
    
    -- TOGGLE
    function sectionControls:CreateToggle(name, defaultState, callback)
        local toggleFrame = Instance.new("Frame", contentFrame)
        toggleFrame.Size = UDim2.new(1, 0, 0, 30)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.LayoutOrder = #contentFrame:GetChildren()
        
        -- Label
        local label = Instance.new("TextLabel", toggleFrame)
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name .. ":"
        label.TextColor3 = self.Colors.Primary
        label.Font = self.Fonts.Body
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Toggle background
        local toggleBg = Instance.new("Frame", toggleFrame)
        toggleBg.Size = UDim2.new(0, 45, 0, 24)
        toggleBg.Position = UDim2.new(1, -50, 0.5, -12)
        toggleBg.BackgroundColor3 = defaultState and self.Colors.Primary or Color3.fromRGB(180, 180, 190)
        toggleBg.BorderSizePixel = 0
        Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
        
        -- Toggle circle
        local toggleCircle = Instance.new("Frame", toggleBg)
        toggleCircle.Size = UDim2.new(0, 20, 0, 20)
        toggleCircle.Position = UDim2.new(defaultState and 1 or 0, defaultState and -22 or 2, 0.5, -10)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
        
        -- Toggle butonu
        local toggleBtn = Instance.new("TextButton", toggleFrame)
        toggleBtn.Size = UDim2.new(0, 45, 0, 24)
        toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
        toggleBtn.BackgroundTransparency = 1
        toggleBtn.Text = ""
        
        local state = defaultState or false
        
        -- Toggle fonksiyonu
        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            
            if state then
                toggleBg.BackgroundColor3 = self.Colors.Primary
                toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
            else
                toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
            end
            
            if callback then
                callback(state)
            end
        end)
        
        -- Canvas size güncelle
        task.wait()
        tab.Frame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.AbsoluteContentSize.Y + 50)
        
        return {
            SetState = function(newState)
                state = newState
                if state then
                    toggleBg.BackgroundColor3 = self.Colors.Primary
                    toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                else
                    toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                end
            end,
            GetState = function()
                return state
            end,
            SetCallback = function(newCallback)
                callback = newCallback
            end
        }
    end
    
    -- SLIDER
    function sectionControls:CreateSlider(name, min, max, defaultValue, callback)
        local sliderFrame = Instance.new("Frame", contentFrame)
        sliderFrame.Size = UDim2.new(1, 0, 0, 40)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.LayoutOrder = #contentFrame:GetChildren()
        
        -- Label
        local label = Instance.new("TextLabel", sliderFrame)
        label.Size = UDim2.new(0.5, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name .. ":"
        label.TextColor3 = self.Colors.Primary
        label.Font = self.Fonts.Body
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Value label
        local valueLabel = Instance.new("TextLabel", sliderFrame)
        valueLabel.Size = UDim2.new(0.5, 0, 0, 20)
        valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(defaultValue or min)
        valueLabel.TextColor3 = self.Colors.Accent
        valueLabel.Font = self.Fonts.Body
        valueLabel.TextSize = 12
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        -- Slider background
        local sliderBg = Instance.new("Frame", sliderFrame)
        sliderBg.Size = UDim2.new(1, 0, 0, 6)
        sliderBg.Position = UDim2.new(0, 0, 0, 25)
        sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
        sliderBg.BorderSizePixel = 0
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
        
        -- Slider fill
        local sliderFill = Instance.new("Frame", sliderBg)
        sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
        sliderFill.Position = UDim2.new(0, 0, 0, 0)
        sliderFill.BackgroundColor3 = self.Colors.Primary
        sliderFill.BorderSizePixel = 0
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
        
        -- Slider handle
        local sliderHandle = Instance.new("TextButton", sliderBg)
        sliderHandle.Size = UDim2.new(0, 16, 0, 16)
        sliderHandle.Position = UDim2.new((defaultValue - min) / (max - min), -8, 0.5, -8)
        sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderHandle.BorderSizePixel = 0
        sliderHandle.Text = ""
        sliderHandle.AutoButtonColor = false
        Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(1, 0)
        
        local sliderHandleStroke = Instance.new("UIStroke", sliderHandle)
        sliderHandleStroke.Color = self.Colors.Primary
        sliderHandleStroke.Thickness = 2
        
        -- Slider logic
        local sliding = false
        local currentValue = defaultValue or min
        
        local function updateSlider(value)
            currentValue = math.clamp(math.floor(value), min, max)
            local percent = (currentValue - min) / (max - min)
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
            valueLabel.Text = tostring(currentValue)
            
            if callback then
                callback(currentValue)
            end
        end
        
        local function updateFromMouse()
            if sliding then
                local mouse = game.Players.LocalPlayer:GetMouse()
                local sliderAbsPos = sliderBg.AbsolutePosition
                local sliderAbsSize = sliderBg.AbsoluteSize
                
                local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                local value = min + (max - min) * relativeX
                updateSlider(value)
            end
        end
        
        -- Mouse events
        sliderHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliding = true
                tab.Frame.ScrollingEnabled = false
            end
        end)
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = game.Players.LocalPlayer:GetMouse()
                local sliderAbsPos = sliderBg.AbsolutePosition
                local sliderAbsSize = sliderBg.AbsoluteSize
                
                local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                local value = min + (max - min) * relativeX
                updateSlider(value)
                sliding = true
                tab.Frame.ScrollingEnabled = false
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliding = false
                tab.Frame.ScrollingEnabled = true
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if sliding then
                    updateFromMouse()
                end
            end
        end)
        
        -- Başlangıç değeri
        updateSlider(defaultValue or min)
        
        -- Canvas size güncelle
        task.wait()
        tab.Frame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.AbsoluteContentSize.Y + 50)
        
        return {
            SetValue = function(value)
                updateSlider(value)
            end,
            GetValue = function()
                return currentValue
            end,
            SetCallback = function(newCallback)
                callback = newCallback
            end
        }
    end
    
    -- DROPDOWN
    function sectionControls:CreateDropdown(name, options, defaultOption, callback)
        local dropdownFrame = Instance.new("Frame", contentFrame)
        dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
        dropdownFrame.BackgroundTransparency = 1
        dropdownFrame.LayoutOrder = #contentFrame:GetChildren()
        
        -- Label
        local label = Instance.new("TextLabel", dropdownFrame)
        label.Size = UDim2.new(0, 100, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name .. ":"
        label.TextColor3 = self.Colors.Primary
        label.Font = self.Fonts.Body
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Dropdown butonu
        local dropdownBtn = Instance.new("TextButton", dropdownFrame)
        dropdownBtn.Size = UDim2.new(1, -110, 1, 0)
        dropdownBtn.Position = UDim2.new(0, 110, 0, 0)
        dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
        dropdownBtn.BackgroundTransparency = 0.5
        dropdownBtn.BorderSizePixel = 0
        dropdownBtn.Text = defaultOption or "Select"
        dropdownBtn.TextColor3 = self.Colors.Text
        dropdownBtn.Font = self.Fonts.Body
        dropdownBtn.TextSize = 12
        Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 6)
        
        -- Hover efekti
        dropdownBtn.MouseEnter:Connect(function()
            dropdownBtn.BackgroundTransparency = 0.3
        end)
        
        dropdownBtn.MouseLeave:Connect(function()
            dropdownBtn.BackgroundTransparency = 0.5
        end)
        
        -- Options panel
        local dropdownOptions = Instance.new("Frame", self.Window.GUI)
        dropdownOptions.Size = UDim2.new(0, 150, 0, 100)
        dropdownOptions.Position = UDim2.new(0, 0, 0, 0)
        dropdownOptions.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
        dropdownOptions.BackgroundTransparency = 0
        dropdownOptions.BorderSizePixel = 0
        dropdownOptions.Visible = false
        dropdownOptions.ZIndex = 100
        Instance.new("UICorner", dropdownOptions).CornerRadius = UDim.new(0, 8)
        
        local selectedOption = defaultOption
        
        -- Options list
        local optionHeight = 30
        for i, option in ipairs(options) do
            local optionBtn = Instance.new("TextButton", dropdownOptions)
            optionBtn.Size = UDim2.new(1, -10, 0, optionHeight - 5)
            optionBtn.Position = UDim2.new(0, 5, 0, (i-1) * optionHeight + 5)
            optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
            optionBtn.BackgroundTransparency = 0.5
            optionBtn.BorderSizePixel = 0
            optionBtn.Text = option
            optionBtn.TextColor3 = self.Colors.Text
            optionBtn.Font = self.Fonts.Body
            optionBtn.TextSize = 12
            optionBtn.ZIndex = 101
            Instance.new("UICorner", optionBtn).CornerRadius = UDim.new(0, 5)
            
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
                selectedOption = option
                dropdownOptions.Visible = false
                if callback then
                    callback(option)
                end
            end)
        end
        
        -- Toggle dropdown
        dropdownBtn.MouseButton1Click:Connect(function()
            dropdownOptions.Visible = not dropdownOptions.Visible
            
            if dropdownOptions.Visible then
                local btnPos = dropdownBtn.AbsolutePosition
                local guiPos = self.Window.GUI.AbsolutePosition
                local guiSize = self.Window.GUI.AbsoluteSize
                
                dropdownOptions.Position = UDim2.new(
                    (btnPos.X - guiPos.X) / guiSize.X,
                    0,
                    (btnPos.Y - guiPos.Y + dropdownBtn.AbsoluteSize.Y) / guiSize.Y,
                    0
                )
                dropdownOptions.Size = UDim2.new(
                    0, dropdownBtn.AbsoluteSize.X,
                    0, #options * optionHeight + 10
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
        
        -- Canvas size güncelle
        task.wait()
        tab.Frame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.AbsoluteContentSize.Y + 50)
        
        return {
            SetOptions = function(newOptions)
                -- Clear old options
                for _, child in ipairs(dropdownOptions:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Add new options
                for i, option in ipairs(newOptions) do
                    local optionBtn = Instance.new("TextButton", dropdownOptions)
                    optionBtn.Size = UDim2.new(1, -10, 0, optionHeight - 5)
                    optionBtn.Position = UDim2.new(0, 5, 0, (i-1) * optionHeight + 5)
                    optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
                    optionBtn.BackgroundTransparency = 0.5
                    optionBtn.BorderSizePixel = 0
                    optionBtn.Text = option
                    optionBtn.TextColor3 = self.Colors.Text
                    optionBtn.Font = self.Fonts.Body
                    optionBtn.TextSize = 12
                    optionBtn.ZIndex = 101
                    Instance.new("UICorner", optionBtn).CornerRadius = UDim.new(0, 5)
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        dropdownBtn.Text = option
                        selectedOption = option
                        dropdownOptions.Visible = false
                        if callback then
                            callback(option)
                        end
                    end)
                end
            end,
            GetSelected = function()
                return selectedOption
            end,
            SetCallback = function(newCallback)
                callback = newCallback
            end
        }
    end
    
    -- TEXTBOX
    function sectionControls:CreateTextBox(name, placeholder, callback)
        local textboxFrame = Instance.new("Frame", contentFrame)
        textboxFrame.Size = UDim2.new(1, 0, 0, 30)
        textboxFrame.BackgroundTransparency = 1
        textboxFrame.LayoutOrder = #contentFrame:GetChildren()
        
        -- Label
        local label = Instance.new("TextLabel", textboxFrame)
        label.Size = UDim2.new(0, 100, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name .. ":"
        label.TextColor3 = self.Colors.Primary
        label.Font = self.Fonts.Body
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Textbox
        local textbox = Instance.new("TextBox", textboxFrame)
        textbox.Size = UDim2.new(1, -110, 1, 0)
        textbox.Position = UDim2.new(0, 110, 0, 0)
        textbox.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
        textbox.BackgroundTransparency = 0.6
        textbox.BorderSizePixel = 0
        textbox.Text = ""
        textbox.TextColor3 = self.Colors.Text
        textbox.Font = self.Fonts.Body
        textbox.TextSize = 12
        textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
        textbox.PlaceholderText = placeholder or "Enter text..."
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
        end)
        
        -- Canvas size güncelle
        task.wait()
        tab.Frame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.AbsoluteContentSize.Y + 50)
        
        return {
            SetText = function(newText)
                textbox.Text = newText
            end,
            GetText = function()
                return textbox.Text
            end,
            SetCallback = function(newCallback)
                callback = newCallback
            end
        }
    end
    
    -- LABEL
    function sectionControls:CreateLabel(text)
        local labelFrame = Instance.new("Frame", contentFrame)
        labelFrame.Size = UDim2.new(1, 0, 0, 20)
        labelFrame.BackgroundTransparency = 1
        labelFrame.LayoutOrder = #contentFrame:GetChildren()
        
        local label = Instance.new("TextLabel", labelFrame)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = self.Colors.Accent
        label.Font = self.Fonts.Body
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        task.wait()
        tab.Frame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.AbsoluteContentSize.Y + 50)
        
        return {
            SetText = function(newText)
                label.Text = newText
            end
        }
    end
    
    -- RETURN SECTION CONTROLS
    return sectionControls
end

-- UI'yi kapat
function OxiUI:Destroy()
    if self.Window and self.Window.GUI then
        self.Window.GUI:Destroy()
    end
end

return OxiUI
