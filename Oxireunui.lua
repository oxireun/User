-- Oxireun UI Library v1.0 - Blade Runner 2049 Theme
-- GitHub: https://raw.githubusercontent.com/kullaniciadin/oxireun/main/oxireun.lua

local Oxireun = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Renk paleti
local Colors = {
    Primary = Color3.fromRGB(0, 150, 255),
    Background = Color3.fromRGB(25, 20, 45),
    Secondary = Color3.fromRGB(30, 25, 60),
    Text = Color3.fromRGB(180, 200, 255),
    TextSecondary = Color3.fromRGB(150, 150, 180),
    Accent = Color3.fromRGB(255, 50, 150)
}

-- Fonksiyonlar
function Oxireun:Tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function Oxireun:CreateNotification(title, message, duration)
    duration = duration or 3
    
    local notificationContainer = Instance.new("Frame", self.ScreenGui)
    notificationContainer.Size = UDim2.new(0.25, 0, 0, 70)
    notificationContainer.Position = UDim2.new(0.75, 0, 1, 0)
    notificationContainer.BackgroundColor3 = Colors.Secondary
    notificationContainer.BackgroundTransparency = 0
    notificationContainer.BorderSizePixel = 0
    notificationContainer.ZIndex = 1000
    Instance.new("UICorner", notificationContainer).CornerRadius = UDim.new(0, 10)
    
    local notificationGlow = Instance.new("UIStroke", notificationContainer)
    notificationGlow.Color = Colors.Primary
    notificationGlow.Thickness = 3
    notificationGlow.Transparency = 0.3
    
    local notifIcon = Instance.new("TextLabel", notificationContainer)
    notifIcon.Size = UDim2.new(0, 40, 1, 0)
    notifIcon.Position = UDim2.new(0, 10, 0, 0)
    notifIcon.BackgroundTransparency = 1
    notifIcon.Text = "🔔"
    notifIcon.TextColor3 = Color3.fromRGB(255, 200, 100)
    notifIcon.Font = Enum.Font.GothamBold
    notifIcon.TextSize = 20
    
    local notifTitle = Instance.new("TextLabel", notificationContainer)
    notifTitle.Size = UDim2.new(1, -60, 0, 25)
    notifTitle.Position = UDim2.new(0, 50, 0, 10)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = Colors.Text
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 14
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local notifMessage = Instance.new("TextLabel", notificationContainer)
    notifMessage.Size = UDim2.new(1, -60, 0, 20)
    notifMessage.Position = UDim2.new(0, 50, 0, 35)
    notifMessage.BackgroundTransparency = 1
    notifMessage.Text = message
    notifMessage.TextColor3 = Colors.TextSecondary
    notifMessage.Font = Enum.Font.Gotham
    notifMessage.TextSize = 11
    notifMessage.TextXAlignment = Enum.TextXAlignment.Left
    
    notificationContainer:TweenPosition(
        UDim2.new(0.75, 0, 0.75, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.4,
        true
    )
    
    wait(duration)
    
    notificationContainer:TweenPosition(
        UDim2.new(0.75, 0, 1, 0),
        Enum.EasingDirection.In,
        Enum.EasingStyle.Quad,
        0.3,
        true
    )
    
    wait(0.3)
    notificationContainer:Destroy()
end

-- Ana Window oluşturma fonksiyonu
function Oxireun:CreateWindow(title, size, position)
    size = size or UDim2.fromScale(0.4, 0.75)
    position = position or UDim2.fromScale(0.03, 0.1)
    
    local Window = {}
    Window.Tabs = {}
    
    -- ScreenGui oluştur
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OxireunGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    Window.ScreenGui = ScreenGui
    
    -- Ana pencere
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = size
    MainFrame.Position = position
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BackgroundTransparency = 0
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local mainCorner = Instance.new("UICorner", MainFrame)
    mainCorner.CornerRadius = UDim.new(0, 12)
    
    local mainGlow = Instance.new("UIStroke", MainFrame)
    mainGlow.Color = Colors.Primary
    mainGlow.Thickness = 3
    mainGlow.Transparency = 0.2
    
    -- Üst bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Colors.Secondary
    topBar.BackgroundTransparency = 0
    topBar.BorderSizePixel = 0
    topBar.Name = "TopBar"
    topBar.Parent = MainFrame
    
    local topBarCorner = Instance.new("UICorner", topBar)
    topBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    
    local topBarLine = Instance.new("Frame", topBar)
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = Colors.Primary
    topBarLine.BorderSizePixel = 0
    
    -- Kontrol butonları
    local controlButtons = Instance.new("Frame", topBar)
    controlButtons.Size = UDim2.new(0, 60, 1, 0)
    controlButtons.Position = UDim2.new(1, -65, 0, 0)
    controlButtons.BackgroundTransparency = 1
    
    -- Minimize butonu
    local minimizeBtn = Instance.new("TextButton", controlButtons)
    minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    minimizeBtn.Position = UDim2.new(0, 0, 0.5, -13)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    minimizeBtn.BackgroundTransparency = 0.6
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = ""
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)
    
    local minimizeLine = Instance.new("Frame", minimizeBtn)
    minimizeLine.Size = UDim2.new(0, 10, 0, 2)
    minimizeLine.Position = UDim2.new(0.5, -5, 0.5, -1)
    minimizeLine.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    minimizeLine.BorderSizePixel = 0
    
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
    
    -- Başlık
    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "OXIREUN"
    titleLabel.TextColor3 = Colors.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Tab container
    local tabContainer = Instance.new("Frame", MainFrame)
    tabContainer.Size = UDim2.new(1, -20, 0, 35)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1
    
    -- Active tab line
    local activeTabLine = Instance.new("Frame", tabContainer)
    activeTabLine.Size = UDim2.new(0.25, -10, 0, 3)
    activeTabLine.Position = UDim2.new(0, 5, 1, -3)
    activeTabLine.BackgroundColor3 = Colors.Primary
    activeTabLine.BorderSizePixel = 0
    Instance.new("UICorner", activeTabLine).CornerRadius = UDim.new(1, 0)
    
    -- Content area
    local contentArea = Instance.new("Frame", MainFrame)
    contentArea.Size = UDim2.new(1, -20, 1, -100)
    contentArea.Position = UDim2.new(0, 10, 0, 90)
    contentArea.BackgroundColor3 = Color3.fromRGB(30, 25, 55)
    contentArea.BackgroundTransparency = 0
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 8)
    
    local contentContainer = Instance.new("Frame", contentArea)
    contentContainer.Size = UDim2.new(1, 0, 1, 0)
    contentContainer.Position = UDim2.new(0, 0, 0, 0)
    contentContainer.BackgroundTransparency = 1
    
    -- Event'ler
    minimizeBtn.MouseButton1Click:Connect(function()
        local minimized = MainFrame.Size.Y.Scale == 0.12
        
        if minimized then
            MainFrame.Size = size
            contentArea.Visible = true
            tabContainer.Visible = true
            topBarLine.Visible = true
            topBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)
        else
            MainFrame.Size = UDim2.new(size.X.Scale, size.X.Offset, 0.12, 0)
            contentArea.Visible = false
            tabContainer.Visible = false
            topBarLine.Visible = false
            topBarCorner.CornerRadius = UDim.new(0, 12)
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Hover efektleri
    minimizeBtn.MouseEnter:Connect(function()
        minimizeBtn.BackgroundTransparency = 0.4
        minimizeLine.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        minimizeBtn.BackgroundTransparency = 0.6
        minimizeLine.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    end)
    
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
    
    -- Tab oluşturma fonksiyonu
    function Window:CreateTab(name)
        local Tab = {}
        Tab.Sections = {}
        Tab.Index = #self.Tabs + 1
        
        -- Tab butonu
        local tabButton = Instance.new("TextButton", tabContainer)
        tabButton.Size = UDim2.new(0.25, -5, 1, 0)
        tabButton.Position = UDim2.new((Tab.Index-1) * 0.25, 0, 0, 0)
        tabButton.BackgroundTransparency = 1
        tabButton.BorderSizePixel = 0
        tabButton.Text = name
        tabButton.TextColor3 = Colors.TextSecondary
        tabButton.Font = Enum.Font.GothamMedium
        tabButton.TextSize = 12
        
        -- Tab içerik frame'i
        local tabFrame = Instance.new("ScrollingFrame", contentContainer)
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.Position = UDim2.new((Tab.Index-1), 0, 0, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.ScrollBarThickness = 4
        tabFrame.ScrollBarImageColor3 = Colors.Primary
        tabFrame.ScrollBarImageTransparency = 0.7
        tabFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        tabFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
        tabFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        tabFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        tabFrame.Visible = Tab.Index == 1
        
        local tabContent = Instance.new("Frame", tabFrame)
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabFrame.CanvasSize = tabContent.Size
        
        Tab.Frame = tabFrame
        Tab.Content = tabContent
        Tab.Button = tabButton
        
        -- Hover efektleri
        tabButton.MouseEnter:Connect(function()
            if Tab.Index ~= Window.CurrentTab then
                tabButton.TextColor3 = Color3.fromRGB(200, 220, 255)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if Tab.Index ~= Window.CurrentTab then
                tabButton.TextColor3 = Colors.TextSecondary
            end
        end)
        
        -- Tab click event
        tabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                self.Tabs[Window.CurrentTab].Button.TextColor3 = Colors.TextSecondary
                self.Tabs[Window.CurrentTab].Frame.Visible = false
            end
            
            Window.CurrentTab = Tab.Index
            tabButton.TextColor3 = Colors.Primary
            tabFrame.Visible = true
            
            activeTabLine:TweenPosition(
                UDim2.new((Tab.Index-1) * 0.25, 5, 1, -3),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
        end)
        
        -- İlk tab'ı aktif et
        if Tab.Index == 1 then
            Window.CurrentTab = 1
            tabButton.TextColor3 = Colors.Primary
        end
        
        -- Section oluşturma fonksiyonu
        function Tab:CreateSection(name)
            local Section = {}
            Section.Elements = {}
            
            -- Section container
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, -10, 0, 100)
            sectionFrame.Position = UDim2.new(0, 5, 0, (#self.Elements * 110) + 10)
            sectionFrame.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
            sectionFrame.BackgroundTransparency = 0.2
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Parent = Tab.Content
            Instance.new("UICorner", sectionFrame).CornerRadius = UDim.new(0, 8)
            
            -- Section title
            local sectionTitle = Instance.new("TextLabel", sectionFrame)
            sectionTitle.Size = UDim2.new(1, -20, 0, 25)
            sectionTitle.Position = UDim2.new(0, 10, 0, 0)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = name
            sectionTitle.TextColor3 = Colors.Primary
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextSize = 13
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Section line
            local sectionLine = Instance.new("Frame", sectionFrame)
            sectionLine.Size = UDim2.new(1, 0, 0, 1)
            sectionLine.Position = UDim2.new(0, 0, 0, 25)
            sectionLine.BackgroundColor3 = Colors.Primary
            sectionLine.BorderSizePixel = 0
            sectionLine.Transparency = 0.3
            
            -- Content container
            local contentContainer = Instance.new("Frame", sectionFrame)
            contentContainer.Size = UDim2.new(1, 0, 1, -30)
            contentContainer.Position = UDim2.new(0, 0, 0, 30)
            contentContainer.BackgroundTransparency = 1
            contentContainer.Name = "ContentContainer"
            
            -- Boyut güncelleme fonksiyonu
            local function updateSectionSize()
                local totalHeight = 40 -- Minimum yükseklik
                for _, element in pairs(Section.Elements) do
                    totalHeight = totalHeight + element.Height
                end
                sectionFrame.Size = UDim2.new(1, -10, 0, totalHeight)
                
                -- Tab boyutunu güncelle
                local tabTotalHeight = 20
                for _, section in pairs(Tab.Sections) do
                    tabTotalHeight = tabTotalHeight + section.Frame.Size.Y.Offset + 10
                end
                Tab.Content.Size = UDim2.new(1, 0, 0, tabTotalHeight)
                Tab.Frame.CanvasSize = Tab.Content.Size
            end
            
            -- Buton ekleme
            function Section:AddButton(name, callback)
                local elementFrame = Instance.new("Frame", contentContainer)
                elementFrame.Size = UDim2.new(1, -20, 0, 30)
                elementFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 35)
                elementFrame.BackgroundTransparency = 1
                
                local button = Instance.new("TextButton", elementFrame)
                button.Size = UDim2.new(1, 0, 1, 0)
                button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
                button.BackgroundTransparency = 0.5
                button.BorderSizePixel = 0
                button.Text = name
                button.TextColor3 = Colors.Primary
                button.Font = Enum.Font.Gotham
                button.TextSize = 12
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
                    callback()
                end)
                
                table.insert(self.Elements, {Frame = elementFrame, Height = 35})
                updateSectionSize()
                
                return button
            end
            
            -- Toggle ekleme
            function Section:AddToggle(name, default, callback)
                local elementFrame = Instance.new("Frame", contentContainer)
                elementFrame.Size = UDim2.new(1, -20, 0, 30)
                elementFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 35)
                elementFrame.BackgroundTransparency = 1
                
                local toggleLabel = Instance.new("TextLabel", elementFrame)
                toggleLabel.Size = UDim2.new(1, -60, 1, 0)
                toggleLabel.Position = UDim2.new(0, 0, 0, 0)
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Text = name .. ":"
                toggleLabel.TextColor3 = Colors.Primary
                toggleLabel.Font = Enum.Font.Gotham
                toggleLabel.TextSize = 12
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local toggleBg = Instance.new("Frame", elementFrame)
                toggleBg.Size = UDim2.new(0, 45, 0, 24)
                toggleBg.Position = UDim2.new(1, -50, 0.5, -12)
                toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                toggleBg.BorderSizePixel = 0
                Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
                
                local toggleCircle = Instance.new("Frame", toggleBg)
                toggleCircle.Size = UDim2.new(0, 20, 0, 20)
                toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleCircle.BorderSizePixel = 0
                Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
                
                local toggleBtn = Instance.new("TextButton", elementFrame)
                toggleBtn.Size = UDim2.new(0, 45, 0, 24)
                toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
                toggleBtn.BackgroundTransparency = 1
                toggleBtn.Text = ""
                
                local state = default or false
                
                if state then
                    toggleBg.BackgroundColor3 = Colors.Primary
                    toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                end
                
                toggleBtn.MouseButton1Click:Connect(function()
                    state = not state
                    
                    if state then
                        toggleBg.BackgroundColor3 = Colors.Primary
                        toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                    else
                        toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                        toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                    end
                    
                    callback(state)
                end)
                
                toggleBtn.MouseEnter:Connect(function()
                    toggleBg.BackgroundTransparency = 0.1
                end)
                
                toggleBtn.MouseLeave:Connect(function()
                    toggleBg.BackgroundTransparency = 0
                end)
                
                table.insert(self.Elements, {Frame = elementFrame, Height = 35})
                updateSectionSize()
                
                return {
                    Set = function(value)
                        state = value
                        if state then
                            toggleBg.BackgroundColor3 = Colors.Primary
                            toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                        else
                            toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                        end
                        callback(state)
                    end,
                    Get = function()
                        return state
                    end
                }
            end
            
            -- Slider ekleme
            function Section:AddSlider(name, min, max, default, callback)
                local elementFrame = Instance.new("Frame", contentContainer)
                elementFrame.Size = UDim2.new(1, -20, 0, 50)
                elementFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 55)
                elementFrame.BackgroundTransparency = 1
                
                local sliderLabel = Instance.new("TextLabel", elementFrame)
                sliderLabel.Size = UDim2.new(0.5, 0, 0, 20)
                sliderLabel.Position = UDim2.new(0, 0, 0, 0)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = name .. ":"
                sliderLabel.TextColor3 = Colors.Primary
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.TextSize = 12
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local valueLabel = Instance.new("TextLabel", elementFrame)
                valueLabel.Size = UDim2.new(0.5, 0, 0, 20)
                valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(default or min)
                valueLabel.TextColor3 = Colors.Text
                valueLabel.Font = Enum.Font.Gotham
                valueLabel.TextSize = 12
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                
                local sliderBg = Instance.new("Frame", elementFrame)
                sliderBg.Size = UDim2.new(1, 0, 0, 6)
                sliderBg.Position = UDim2.new(0, 0, 0, 25)
                sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
                sliderBg.BorderSizePixel = 0
                Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
                
                local sliderFill = Instance.new("Frame", sliderBg)
                sliderFill.Size = UDim2.new(0, 0, 1, 0)
                sliderFill.Position = UDim2.new(0, 0, 0, 0)
                sliderFill.BackgroundColor3 = Colors.Primary
                sliderFill.BorderSizePixel = 0
                Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
                
                local sliderHandle = Instance.new("TextButton", sliderBg)
                sliderHandle.Size = UDim2.new(0, 16, 0, 16)
                sliderHandle.Position = UDim2.new(0, -8, 0.5, -8)
                sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderHandle.BorderSizePixel = 0
                sliderHandle.Text = ""
                sliderHandle.AutoButtonColor = false
                Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(1, 0)
                
                local sliderHandleStroke = Instance.new("UIStroke", sliderHandle)
                sliderHandleStroke.Color = Colors.Primary
                sliderHandleStroke.Thickness = 2
                
                local sliding = false
                local currentValue = default or min
                min = min or 0
                max = max or 100
                
                local function updateSlider(value)
                    currentValue = math.clamp(value, min, max)
                    local percent = (currentValue - min) / (max - min)
                    
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
                    valueLabel.Text = tostring(math.floor(currentValue))
                    
                    callback(currentValue)
                end
                
                local function startSliding()
                    sliding = true
                    Tab.Frame.ScrollingEnabled = false
                    
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if sliding then
                            local mouse = game.Players.LocalPlayer:GetMouse()
                            local sliderAbsPos = sliderBg.AbsolutePosition
                            local sliderAbsSize = sliderBg.AbsoluteSize
                            
                            local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                            updateSlider(min + (relativeX * (max - min)))
                        else
                            connection:Disconnect()
                        end
                    end)
                end
                
                local function stopSliding()
                    sliding = false
                    Tab.Frame.ScrollingEnabled = true
                end
                
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
                
                updateSlider(currentValue)
                
                table.insert(self.Elements, {Frame = elementFrame, Height = 55})
                updateSectionSize()
                
                return {
                    Set = function(value)
                        updateSlider(value)
                    end,
                    Get = function()
                        return currentValue
                    end
                }
            end
            
            -- Textbox ekleme
            function Section:AddTextbox(name, placeholder, callback)
                local elementFrame = Instance.new("Frame", contentContainer)
                elementFrame.Size = UDim2.new(1, -20, 0, 30)
                elementFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 35)
                elementFrame.BackgroundTransparency = 1
                
                local textboxLabel = Instance.new("TextLabel", elementFrame)
                textboxLabel.Size = UDim2.new(0, 100, 1, 0)
                textboxLabel.Position = UDim2.new(0, 0, 0, 0)
                textboxLabel.BackgroundTransparency = 1
                textboxLabel.Text = name .. ":"
                textboxLabel.TextColor3 = Colors.Primary
                textboxLabel.Font = Enum.Font.Gotham
                textboxLabel.TextSize = 12
                textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local textbox = Instance.new("TextBox", elementFrame)
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
                textbox.PlaceholderText = placeholder or ""
                Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 6)
                
                textbox.Focused:Connect(function()
                    textbox.BackgroundTransparency = 0.5
                end)
                
                textbox.FocusLost:Connect(function(enterPressed)
                    textbox.BackgroundTransparency = 0.6
                    if enterPressed then
                        callback(textbox.Text)
                    end
                end)
                
                table.insert(self.Elements, {Frame = elementFrame, Height = 35})
                updateSectionSize()
                
                return textbox
            end
            
            -- Dropdown ekleme
            function Section:AddDropdown(name, options, default, callback)
                local elementFrame = Instance.new("Frame", contentContainer)
                elementFrame.Size = UDim2.new(1, -20, 0, 30)
                elementFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 35)
                elementFrame.BackgroundTransparency = 1
                
                local dropdownLabel = Instance.new("TextLabel", elementFrame)
                dropdownLabel.Size = UDim2.new(0, 100, 1, 0)
                dropdownLabel.Position = UDim2.new(0, 0, 0, 0)
                dropdownLabel.BackgroundTransparency = 1
                dropdownLabel.Text = name .. ":"
                dropdownLabel.TextColor3 = Colors.Primary
                dropdownLabel.Font = Enum.Font.Gotham
                dropdownLabel.TextSize = 12
                dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local dropdownBtn = Instance.new("TextButton", elementFrame)
                dropdownBtn.Size = UDim2.new(1, -110, 1, 0)
                dropdownBtn.Position = UDim2.new(0, 110, 0, 0)
                dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
                dropdownBtn.BackgroundTransparency = 0.5
                dropdownBtn.BorderSizePixel = 0
                dropdownBtn.Text = default or "Select"
                dropdownBtn.TextColor3 = Colors.Text
                dropdownBtn.Font = Enum.Font.Gotham
                dropdownBtn.TextSize = 12
                Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 6)
                
                local dropdownOptions = Instance.new("Frame", ScreenGui)
                dropdownOptions.Size = UDim2.new(0, 150, 0, 0)
                dropdownOptions.Position = UDim2.new(0, 0, 0, 0)
                dropdownOptions.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
                dropdownOptions.BackgroundTransparency = 0
                dropdownOptions.BorderSizePixel = 0
                dropdownOptions.Visible = false
                dropdownOptions.ZIndex = 100
                Instance.new("UICorner", dropdownOptions).CornerRadius = UDim.new(0, 8)
                
                local function updateOptions()
                    for _, child in ipairs(dropdownOptions:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    dropdownOptions.Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, #options * 30 + 10)
                    
                    for i, option in ipairs(options) do
                        local optionBtn = Instance.new("TextButton", dropdownOptions)
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
                            dropdownOptions.Visible = false
                            callback(option)
                        end)
                    end
                end
                
                dropdownBtn.MouseEnter:Connect(function()
                    dropdownBtn.BackgroundTransparency = 0.3
                end)
                
                dropdownBtn.MouseLeave:Connect(function()
                    dropdownBtn.BackgroundTransparency = 0.5
                end)
                
                dropdownBtn.MouseButton1Click:Connect(function()
                    dropdownOptions.Visible = not dropdownOptions.Visible
                    
                    if dropdownOptions.Visible then
                        updateOptions()
                        local btnPos = dropdownBtn.AbsolutePosition
                        local mainPos = MainFrame.AbsolutePosition
                        local mainSize = MainFrame.AbsoluteSize
                        
                        local relativeX = (btnPos.X - mainPos.X) / mainSize.X
                        local relativeY = (btnPos.Y - mainPos.Y + dropdownBtn.AbsoluteSize.Y) / mainSize.Y
                        
                        dropdownOptions.Position = UDim2.new(relativeX, 0, relativeY, 0)
                    end
                end)
                
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
                
                table.insert(self.Elements, {Frame = elementFrame, Height = 35})
                updateSectionSize()
                
                return {
                    Set = function(option)
                        if table.find(options, option) then
                            dropdownBtn.Text = option
                            callback(option)
                        end
                    end,
                    Get = function()
                        return dropdownBtn.Text
                    end,
                    UpdateOptions = function(newOptions)
                        options = newOptions
                        updateOptions()
                    end
                }
            end
            
            -- Label ekleme
            function Section:AddLabel(text)
                local elementFrame = Instance.new("Frame", contentContainer)
                elementFrame.Size = UDim2.new(1, -20, 0, 25)
                elementFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 30)
                elementFrame.BackgroundTransparency = 1
                
                local label = Instance.new("TextLabel", elementFrame)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = Colors.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 12
                label.TextXAlignment = Enum.TextXAlignment.Left
                
                table.insert(self.Elements, {Frame = elementFrame, Height = 30})
                updateSectionSize()
                
                return label
            end
            
            -- Keybind ekleme
            function Section:AddKeybind(name, defaultKey, callback)
                local elementFrame = Instance.new("Frame", contentContainer)
                elementFrame.Size = UDim2.new(1, -20, 0, 30)
                elementFrame.Position = UDim2.new(0, 10, 0, #self.Elements * 35)
                elementFrame.BackgroundTransparency = 1
                
                local keybindLabel = Instance.new("TextLabel", elementFrame)
                keybindLabel.Size = UDim2.new(0, 100, 1, 0)
                keybindLabel.Position = UDim2.new(0, 0, 0, 0)
                keybindLabel.BackgroundTransparency = 1
                keybindLabel.Text = name .. ":"
                keybindLabel.TextColor3 = Colors.Primary
                keybindLabel.Font = Enum.Font.Gotham
                keybindLabel.TextSize = 12
                keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local keybindBtn = Instance.new("TextButton", elementFrame)
                keybindBtn.Size = UDim2.new(1, -110, 1, 0)
                keybindBtn.Position = UDim2.new(0, 110, 0, 0)
                keybindBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
                keybindBtn.BackgroundTransparency = 0.5
                keybindBtn.BorderSizePixel = 0
                keybindBtn.Text = tostring(defaultKey or "None")
                keybindBtn.TextColor3 = Colors.Text
                keybindBtn.Font = Enum.Font.Gotham
                keybindBtn.TextSize = 12
                Instance.new("UICorner", keybindBtn).CornerRadius = UDim.new(0, 6)
                
                local listening = false
                local currentKey = defaultKey
                
                keybindBtn.MouseEnter:Connect(function()
                    keybindBtn.BackgroundTransparency = 0.3
                end)
                
                keybindBtn.MouseLeave:Connect(function()
                    keybindBtn.BackgroundTransparency = 0.5
                end)
                
                keybindBtn.MouseButton1Click:Connect(function()
                    listening = true
                    keybindBtn.Text = "..."
                    keybindBtn.BackgroundColor3 = Colors.Primary
                end)
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode.Name
                            keybindBtn.Text = currentKey
                            listening = false
                            keybindBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
                            callback(currentKey)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                            currentKey = "MouseButton1"
                            keybindBtn.Text = "MB1"
                            listening = false
                            keybindBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
                            callback(currentKey)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                            currentKey = "MouseButton2"
                            keybindBtn.Text = "MB2"
                            listening = false
                            keybindBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
                            callback(currentKey)
                        end
                    elseif currentKey and input.KeyCode.Name == currentKey then
                        callback(currentKey)
                    end
                end)
                
                table.insert(self.Elements, {Frame = elementFrame, Height = 35})
                updateSectionSize()
                
                return {
                    Set = function(key)
                        currentKey = key
                        keybindBtn.Text = tostring(key)
                    end,
                    Get = function()
                        return currentKey
                    end
                }
            end
            
            Section.Frame = sectionFrame
            table.insert(Tab.Sections, Section)
            table.insert(self.Elements, Section)
            
            return Section
        end
        
        table.insert(self.Tabs, Tab)
        return Tab
    end
    
    Window.MainFrame = MainFrame
    return Window
end

return Oxireun
