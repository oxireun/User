-- Blade Runner 2049 UI Library
-- By Oxireun
-- Github: https://github.com/oxireun

local Library = {}
Library.__index = Library

-- Servisler
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Renk paleti
local Theme = {
    Primary = Color3.fromRGB(0, 150, 255),
    Background = Color3.fromRGB(25, 20, 45),
    Secondary = Color3.fromRGB(30, 25, 60),
    Text = Color3.fromRGB(180, 200, 255),
    Accent = Color3.fromRGB(0, 150, 255),
    Dark = Color3.fromRGB(20, 15, 40),
    Light = Color3.fromRGB(220, 220, 240)
}

-- Yardımcı fonksiyonlar
local function createNotification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- UI element oluşturma fonksiyonları
local function createRoundedFrame(parent, size, position, transparency)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = Theme.Background
    frame.BackgroundTransparency = transparency or 0
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    return frame
end

local function createStroke(frame, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Primary
    stroke.Thickness = thickness or 2
    stroke.Transparency = 0.2
    stroke.Parent = frame
    
    return stroke
end

-- Window oluşturma
function Library:NewWindow(title)
    local window = {}
    setmetatable(window, Library)
    
    -- Ana GUI
    window.gui = Instance.new("ScreenGui")
    window.gui.Name = "OxireunUI"
    window.gui.Parent = game.CoreGui
    window.gui.ResetOnSpawn = false
    window.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Ana pencere
    window.main = createRoundedFrame(window.gui, UDim2.fromScale(0.4, 0.75), UDim2.fromScale(0.03, 0.1))
    window.main.Active = true
    window.main.Draggable = true
    
    -- Neon border
    window.mainGlow = createStroke(window.main, Theme.Primary, 3)
    
    -- Üst bar
    window.topBar = Instance.new("Frame")
    window.topBar.Size = UDim2.new(1, 0, 0, 45)
    window.topBar.Position = UDim2.new(0, 0, 0, 0)
    window.topBar.BackgroundColor3 = Theme.Secondary
    window.topBar.BorderSizePixel = 0
    window.topBar.Parent = window.main
    
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    topBarCorner.Parent = window.topBar
    
    -- Üst bar çizgisi
    local topBarLine = Instance.new("Frame")
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = Theme.Primary
    topBarLine.BorderSizePixel = 0
    topBarLine.Parent = window.topBar
    
    -- Başlık
    window.titleLabel = Instance.new("TextLabel")
    window.titleLabel.Size = UDim2.new(0, 200, 1, 0)
    window.titleLabel.Position = UDim2.new(0, 15, 0, 0)
    window.titleLabel.BackgroundTransparency = 1
    window.titleLabel.Text = title or "OXIREUN"
    window.titleLabel.TextColor3 = Theme.Text
    window.titleLabel.Font = Enum.Font.GothamBold
    window.titleLabel.TextSize = 16
    window.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    window.titleLabel.Parent = window.topBar
    
    -- Kapatma butonu
    window.closeBtn = Instance.new("TextButton")
    window.closeBtn.Size = UDim2.new(0, 26, 0, 26)
    window.closeBtn.Position = UDim2.new(1, -35, 0.5, -13)
    window.closeBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 50)
    window.closeBtn.BackgroundTransparency = 0.6
    window.closeBtn.BorderSizePixel = 0
    window.closeBtn.Text = ""
    window.closeBtn.Parent = window.topBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = window.closeBtn
    
    -- Kapatma simgesi
    local closeLine1 = Instance.new("Frame")
    closeLine1.Size = UDim2.new(0, 12, 0, 2)
    closeLine1.Position = UDim2.new(0.5, -6, 0.5, -1)
    closeLine1.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    closeLine1.BorderSizePixel = 0
    closeLine1.Rotation = 45
    closeLine1.Parent = window.closeBtn
    
    local closeLine2 = Instance.new("Frame")
    closeLine2.Size = UDim2.new(0, 12, 0, 2)
    closeLine2.Position = UDim2.new(0.5, -6, 0.5, -1)
    closeLine2.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    closeLine2.BorderSizePixel = 0
    closeLine2.Rotation = -45
    closeLine2.Parent = window.closeBtn
    
    -- Kapatma butonu event
    window.closeBtn.MouseButton1Click:Connect(function()
        window.gui:Destroy()
    end)
    
    -- Hover efekti
    window.closeBtn.MouseEnter:Connect(function()
        window.closeBtn.BackgroundTransparency = 0.4
        closeLine1.BackgroundColor3 = Color3.fromRGB(255, 140, 150)
        closeLine2.BackgroundColor3 = Color3.fromRGB(255, 140, 150)
    end)
    
    window.closeBtn.MouseLeave:Connect(function()
        window.closeBtn.BackgroundTransparency = 0.6
        closeLine1.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
        closeLine2.BackgroundColor3 = Color3.fromRGB(240, 120, 130)
    end)
    
    -- Tab container
    window.tabContainer = Instance.new("Frame")
    window.tabContainer.Size = UDim2.new(1, -20, 0, 35)
    window.tabContainer.Position = UDim2.new(0, 10, 0, 50)
    window.tabContainer.BackgroundTransparency = 1
    window.tabContainer.Parent = window.main
    
    -- Aktif tab çizgisi
    window.activeTabLine = Instance.new("Frame")
    window.activeTabLine.Size = UDim2.new(0, 80, 0, 3)
    window.activeTabLine.Position = UDim2.new(0, 10, 1, -3)
    window.activeTabLine.BackgroundColor3 = Theme.Primary
    window.activeTabLine.BorderSizePixel = 0
    window.activeTabLine.Parent = window.tabContainer
    
    local tabLineCorner = Instance.new("UICorner")
    tabLineCorner.CornerRadius = UDim.new(1, 0)
    tabLineCorner.Parent = window.activeTabLine
    
    -- Content area
    window.contentArea = createRoundedFrame(window.main, UDim2.new(1, -20, 1, -100), UDim2.new(0, 10, 0, 90))
    window.contentArea.BackgroundColor3 = Color3.fromRGB(30, 25, 55)
    
    -- Tab yönetimi
    window.tabs = {}
    window.sections = {}
    window.currentTab = 1
    
    -- Tab switch fonksiyonu
    function window:SwitchTab(index)
        if window.tabs[self.currentTab] then
            window.tabs[self.currentTab].button.TextColor3 = Color3.fromRGB(150, 150, 180)
            window.tabs[self.currentTab].content.Visible = false
        end
        
        self.currentTab = index
        window.tabs[index].button.TextColor3 = Theme.Primary
        window.tabs[index].content.Visible = true
        
        -- Tab çizgisini animasyonla hareket ettir
        local targetX = (index - 1) * 90 + 10
        window.activeTabLine:TweenPosition(
            UDim2.new(0, targetX, 1, -3),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.2,
            true
        )
    end
    
    -- Yeni section oluşturma
    function window:NewSection(name)
        local section = {}
        section.name = name
        section.elements = {}
        
        -- Tab butonu oluştur (eğer ilk section ise)
        if #window.tabs == 0 then
            -- Content container
            window.contentContainer = Instance.new("Frame")
            window.contentContainer.Size = UDim2.new(#window.tabs + 1, 0, 1, 0)
            window.contentContainer.Position = UDim2.new(0, 0, 0, 0)
            window.contentContainer.BackgroundTransparency = 1
            window.contentContainer.Parent = window.contentArea
            
            -- Scrolling frame
            window.scrollFrame = Instance.new("ScrollingFrame")
            window.scrollFrame.Size = UDim2.new(1, 0, 1, 0)
            window.scrollFrame.Position = UDim2.new(0, 0, 0, 0)
            window.scrollFrame.BackgroundTransparency = 1
            window.scrollFrame.BorderSizePixel = 0
            window.scrollFrame.ScrollBarThickness = 4
            window.scrollFrame.ScrollBarImageColor3 = Theme.Primary
            window.scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
            window.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            window.scrollFrame.Parent = window.contentContainer
            
            -- Scroll content
            window.scrollContent = Instance.new("Frame")
            window.scrollContent.Size = UDim2.new(1, 0, 0, 0)
            window.scrollContent.BackgroundTransparency = 1
            window.scrollContent.Parent = window.scrollFrame
        end
        
        -- Tab butonu
        local tabIndex = #window.tabs + 1
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 80, 1, 0)
        tabButton.Position = UDim2.new(0, (tabIndex - 1) * 90, 0, 0)
        tabButton.BackgroundTransparency = 1
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(150, 150, 180)
        tabButton.Font = Enum.Font.GothamMedium
        tabButton.TextSize = 12
        tabButton.Parent = window.tabContainer
        
        -- Tab content frame
        local contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1 / (tabIndex), 0, 1, 0)
        contentFrame.Position = UDim2.new((tabIndex - 1) * (1 / tabIndex), 0, 0, 0)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Visible = tabIndex == 1
        contentFrame.Parent = window.contentContainer
        
        -- Section container
        section.container = Instance.new("Frame")
        section.container.Size = UDim2.new(1, -20, 0, 0)
        section.container.Position = UDim2.new(0, 10, 0, 10)
        section.container.BackgroundTransparency = 1
        section.container.Parent = contentFrame
        
        -- Section başlığı
        section.title = Instance.new("TextLabel")
        section.title.Size = UDim2.new(1, 0, 0, 25)
        section.title.Position = UDim2.new(0, 0, 0, 0)
        section.title.BackgroundTransparency = 1
        section.title.Text = name
        section.title.TextColor3 = Theme.Primary
        section.title.Font = Enum.Font.GothamBold
        section.title.TextSize = 14
        section.title.TextXAlignment = Enum.TextXAlignment.Left
        section.title.Parent = section.container
        
        -- Section alt çizgisi
        section.line = Instance.new("Frame")
        section.line.Size = UDim2.new(1, 0, 0, 1)
        section.line.Position = UDim2.new(0, 0, 0, 25)
        section.line.BackgroundColor3 = Theme.Primary
        section.line.BorderSizePixel = 0
        section.line.Transparency = 0.3
        section.line.Parent = section.container
        
        -- Element container
        section.elementContainer = Instance.new("Frame")
        section.elementContainer.Size = UDim2.new(1, 0, 0, 0)
        section.elementContainer.Position = UDim2.new(0, 0, 0, 35)
        section.elementContainer.BackgroundTransparency = 1
        section.elementContainer.Parent = section.container
        
        -- Tab butonu event
        tabButton.MouseButton1Click:Connect(function()
            window:SwitchTab(tabIndex)
        end)
        
        -- Hover efekti
        tabButton.MouseEnter:Connect(function()
            if window.currentTab ~= tabIndex then
                tabButton.TextColor3 = Color3.fromRGB(200, 220, 255)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if window.currentTab ~= tabIndex then
                tabButton.TextColor3 = Color3.fromRGB(150, 150, 180)
            end
        end)
        
        -- Tab'ı kaydet
        window.tabs[tabIndex] = {
            button = tabButton,
            content = contentFrame,
            section = section
        }
        
        -- Element oluşturma fonksiyonları
        function section:CreateButton(name, callback)
            local button = {}
            
            -- Button frame
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Size = UDim2.new(1, 0, 0, 30)
            buttonFrame.Position = UDim2.new(0, 0, 0, #self.elements * 40)
            buttonFrame.BackgroundTransparency = 1
            buttonFrame.Parent = self.elementContainer
            
            -- Button
            local buttonBtn = Instance.new("TextButton")
            buttonBtn.Size = UDim2.new(1, 0, 1, 0)
            buttonBtn.Position = UDim2.new(0, 0, 0, 0)
            buttonBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
            buttonBtn.BackgroundTransparency = 0.5
            buttonBtn.BorderSizePixel = 0
            buttonBtn.Text = name
            buttonBtn.TextColor3 = Theme.Primary
            buttonBtn.Font = Enum.Font.Gotham
            buttonBtn.TextSize = 12
            buttonBtn.Parent = buttonFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = buttonBtn
            
            -- Hover efekti
            buttonBtn.MouseEnter:Connect(function()
                buttonBtn.BackgroundTransparency = 0.3
            end)
            
            buttonBtn.MouseLeave:Connect(function()
                buttonBtn.BackgroundTransparency = 0.5
            end)
            
            -- Click event
            buttonBtn.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
            
            -- Container boyutunu güncelle
            self.elementContainer.Size = UDim2.new(1, 0, 0, (#self.elements + 1) * 40 + 10)
            window.scrollContent.Size = UDim2.new(1, 0, 0, math.max(400, (#window.sections + 1) * 200))
            window.scrollFrame.CanvasSize = window.scrollContent.Size
            
            table.insert(self.elements, button)
            return button
        end
        
        function section:CreateTextbox(name, callback)
            local textbox = {}
            
            -- Textbox frame
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Size = UDim2.new(1, 0, 0, 30)
            textboxFrame.Position = UDim2.new(0, 0, 0, #self.elements * 40)
            textboxFrame.BackgroundTransparency = 1
            textboxFrame.Parent = self.elementContainer
            
            -- Label
            local textboxLabel = Instance.new("TextLabel")
            textboxLabel.Size = UDim2.new(0, 100, 1, 0)
            textboxLabel.Position = UDim2.new(0, 0, 0, 0)
            textboxLabel.BackgroundTransparency = 1
            textboxLabel.Text = name .. ":"
            textboxLabel.TextColor3 = Theme.Primary
            textboxLabel.Font = Enum.Font.Gotham
            textboxLabel.TextSize = 12
            textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            textboxLabel.Parent = textboxFrame
            
            -- TextBox
            local textboxInput = Instance.new("TextBox")
            textboxInput.Size = UDim2.new(1, -110, 1, 0)
            textboxInput.Position = UDim2.new(0, 110, 0, 0)
            textboxInput.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
            textboxInput.BackgroundTransparency = 0.6
            textboxInput.BorderSizePixel = 0
            textboxInput.Text = ""
            textboxInput.TextColor3 = Theme.Light
            textboxInput.Font = Enum.Font.Gotham
            textboxInput.TextSize = 12
            textboxInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
            textboxInput.PlaceholderText = "Enter"
            textboxInput.Parent = textboxFrame
            
            local textboxCorner = Instance.new("UICorner")
            textboxCorner.CornerRadius = UDim.new(0, 6)
            textboxCorner.Parent = textboxInput
            
            -- Focus efekti
            textboxInput.Focused:Connect(function()
                textboxInput.BackgroundTransparency = 0.5
            end)
            
            textboxInput.FocusLost:Connect(function()
                textboxInput.BackgroundTransparency = 0.6
                if callback then
                    callback(textboxInput.Text)
                end
            end)
            
            -- Container boyutunu güncelle
            self.elementContainer.Size = UDim2.new(1, 0, 0, (#self.elements + 1) * 40 + 10)
            window.scrollContent.Size = UDim2.new(1, 0, 0, math.max(400, (#window.sections + 1) * 200))
            window.scrollFrame.CanvasSize = window.scrollContent.Size
            
            table.insert(self.elements, textbox)
            return textbox
        end
        
        function section:CreateToggle(name, callback)
            local toggle = {}
            toggle.state = false
            
            -- Toggle frame
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 30)
            toggleFrame.Position = UDim2.new(0, 0, 0, #self.elements * 40)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = self.elementContainer
            
            -- Label
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(1, -60, 1, 0)
            toggleLabel.Position = UDim2.new(0, 0, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = name .. ":"
            toggleLabel.TextColor3 = Theme.Primary
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextSize = 12
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            -- Toggle background
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 45, 0, 24)
            toggleBg.Position = UDim2.new(1, -50, 0.5, -12)
            toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = toggleFrame
            
            local toggleBgCorner = Instance.new("UICorner")
            toggleBgCorner.CornerRadius = UDim.new(1, 0)
            toggleBgCorner.Parent = toggleBg
            
            -- Toggle circle
            toggle.circle = Instance.new("Frame")
            toggle.circle.Size = UDim2.new(0, 20, 0, 20)
            toggle.circle.Position = UDim2.new(0, 2, 0.5, -10)
            toggle.circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggle.circle.BorderSizePixel = 0
            toggle.circle.Parent = toggleBg
            
            local toggleCircleCorner = Instance.new("UICorner")
            toggleCircleCorner.CornerRadius = UDim.new(1, 0)
            toggleCircleCorner.Parent = toggle.circle
            
            -- Toggle button
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 45, 0, 24)
            toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.Parent = toggleFrame
            
            -- Toggle fonksiyonu
            toggleBtn.MouseButton1Click:Connect(function()
                toggle.state = not toggle.state
                
                if toggle.state then
                    toggleBg.BackgroundColor3 = Theme.Primary
                    toggle.circle.Position = UDim2.new(1, -22, 0.5, -10)
                    if callback then
                        callback(true)
                    end
                else
                    toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                    toggle.circle.Position = UDim2.new(0, 2, 0.5, -10)
                    if callback then
                        callback(false)
                    end
                end
            end)
            
            -- Hover efekti
            toggleBtn.MouseEnter:Connect(function()
                toggleBg.BackgroundTransparency = 0.1
            end)
            
            toggleBtn.MouseLeave:Connect(function()
                toggleBg.BackgroundTransparency = 0
            end)
            
            -- Container boyutunu güncelle
            self.elementContainer.Size = UDim2.new(1, 0, 0, (#self.elements + 1) * 40 + 10)
            window.scrollContent.Size = UDim2.new(1, 0, 0, math.max(400, (#window.sections + 1) * 200))
            window.scrollFrame.CanvasSize = window.scrollContent.Size
            
            table.insert(self.elements, toggle)
            return toggle
        end
        
        function section:CreateDropdown(name, options, default, callback)
            local dropdown = {}
            dropdown.options = options
            dropdown.selected = default
            
            -- Dropdown frame
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
            dropdownFrame.Position = UDim2.new(0, 0, 0, #self.elements * 40)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Parent = self.elementContainer
            
            -- Label
            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Size = UDim2.new(0, 100, 1, 0)
            dropdownLabel.Position = UDim2.new(0, 0, 0, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = name .. ":"
            dropdownLabel.TextColor3 = Theme.Primary
            dropdownLabel.Font = Enum.Font.Gotham
            dropdownLabel.TextSize = 12
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame
            
            -- Dropdown button
            dropdown.button = Instance.new("TextButton")
            dropdown.button.Size = UDim2.new(1, -110, 1, 0)
            dropdown.button.Position = UDim2.new(0, 110, 0, 0)
            dropdown.button.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
            dropdown.button.BackgroundTransparency = 0.5
            dropdown.button.BorderSizePixel = 0
            dropdown.button.Text = options[default] or "Select"
            dropdown.button.TextColor3 = Theme.Light
            dropdown.button.Font = Enum.Font.Gotham
            dropdown.button.TextSize = 12
            dropdown.button.Parent = dropdownFrame
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 6)
            dropdownCorner.Parent = dropdown.button
            
            -- Hover efekti
            dropdown.button.MouseEnter:Connect(function()
                dropdown.button.BackgroundTransparency = 0.3
            end)
            
            dropdown.button.MouseLeave:Connect(function()
                dropdown.button.BackgroundTransparency = 0.5
            end)
            
            -- Options panel
            dropdown.optionsPanel = Instance.new("Frame")
            dropdown.optionsPanel.Size = UDim2.new(0, 150, 0, 0)
            dropdown.optionsPanel.Position = UDim2.new(0, 0, 0, 0)
            dropdown.optionsPanel.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
            dropdown.optionsPanel.BackgroundTransparency = 0
            dropdown.optionsPanel.BorderSizePixel = 0
            dropdown.optionsPanel.Visible = false
            dropdown.optionsPanel.ZIndex = 100
            dropdown.optionsPanel.Parent = window.gui
            
            local optionsCorner = Instance.new("UICorner")
            optionsCorner.CornerRadius = UDim.new(0, 8)
            optionsCorner.Parent = dropdown.optionsPanel
            
            -- Options
            local optionButtons = {}
            for i, option in ipairs(options) do
                local optionBtn = Instance.new("TextButton")
                optionBtn.Size = UDim2.new(1, -10, 0, 25)
                optionBtn.Position = UDim2.new(0, 5, 0, (i-1) * 30 + 5)
                optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
                optionBtn.BackgroundTransparency = 0.5
                optionBtn.BorderSizePixel = 0
                optionBtn.Text = option
                optionBtn.TextColor3 = Theme.Light
                optionBtn.Font = Enum.Font.Gotham
                optionBtn.TextSize = 12
                optionBtn.ZIndex = 101
                optionBtn.Parent = dropdown.optionsPanel
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 5)
                optionCorner.Parent = optionBtn
                
                -- Hover efekti
                optionBtn.MouseEnter:Connect(function()
                    optionBtn.BackgroundTransparency = 0.3
                    optionBtn.BackgroundColor3 = Color3.fromRGB(65, 55, 95)
                end)
                
                optionBtn.MouseLeave:Connect(function()
                    optionBtn.BackgroundTransparency = 0.5
                    optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
                end)
                
                -- Click event
                optionBtn.MouseButton1Click:Connect(function()
                    dropdown.button.Text = option
                    dropdown.selected = i
                    dropdown.optionsPanel.Visible = false
                    
                    if callback then
                        callback(option)
                    end
                end)
                
                table.insert(optionButtons, optionBtn)
            end
            
            -- Panel boyutunu ayarla
            dropdown.optionsPanel.Size = UDim2.new(0, 150, 0, #options * 30 + 10)
            
            -- Dropdown toggle
            dropdown.button.MouseButton1Click:Connect(function()
                dropdown.optionsPanel.Visible = not dropdown.optionsPanel.Visible
                
                if dropdown.optionsPanel.Visible then
                    local btnPos = dropdown.button.AbsolutePosition
                    local guiPos = window.gui.AbsolutePosition
                    
                    dropdown.optionsPanel.Position = UDim2.new(
                        0, btnPos.X - guiPos.X,
                        0, btnPos.Y - guiPos.Y + dropdown.button.AbsoluteSize.Y
                    )
                end
            end)
            
            -- Panel dışına tıklayınca kapat
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mousePos = input.Position
                    local panelPos = dropdown.optionsPanel.AbsolutePosition
                    local panelSize = dropdown.optionsPanel.AbsoluteSize
                    
                    if dropdown.optionsPanel.Visible then
                        if not (mousePos.X >= panelPos.X and mousePos.X <= panelPos.X + panelSize.X and
                               mousePos.Y >= panelPos.Y and mousePos.Y <= panelPos.Y + panelSize.Y) then
                            dropdown.optionsPanel.Visible = false
                        end
                    end
                end
            end)
            
            -- Container boyutunu güncelle
            self.elementContainer.Size = UDim2.new(1, 0, 0, (#self.elements + 1) * 40 + 10)
            window.scrollContent.Size = UDim2.new(1, 0, 0, math.max(400, (#window.sections + 1) * 200))
            window.scrollFrame.CanvasSize = window.scrollContent.Size
            
            table.insert(self.elements, dropdown)
            return dropdown
        end
        
        function section:CreateSlider(name, min, max, default, callback)
            local slider = {}
            slider.value = default or min
            
            -- Slider frame
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 50)
            sliderFrame.Position = UDim2.new(0, 0, 0, #self.elements * 55)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = self.elementContainer
            
            -- Label
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Size = UDim2.new(0.5, 0, 0, 20)
            sliderLabel.Position = UDim2.new(0, 0, 0, 0)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = name .. ":"
            sliderLabel.TextColor3 = Theme.Primary
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextSize = 12
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            -- Value label
            slider.valueLabel = Instance.new("TextLabel")
            slider.valueLabel.Size = UDim2.new(0.5, 0, 0, 20)
            slider.valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
            slider.valueLabel.BackgroundTransparency = 1
            slider.valueLabel.Text = tostring(default or min)
            slider.valueLabel.TextColor3 = Theme.Text
            slider.valueLabel.Font = Enum.Font.Gotham
            slider.valueLabel.TextSize = 12
            slider.valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            slider.valueLabel.Parent = sliderFrame
            
            -- Slider background
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, 0, 0, 6)
            sliderBg.Position = UDim2.new(0, 0, 0, 30)
            sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = sliderFrame
            
            local sliderBgCorner = Instance.new("UICorner")
            sliderBgCorner.CornerRadius = UDim.new(1, 0)
            sliderBgCorner.Parent = sliderBg
            
            -- Slider fill
            slider.fill = Instance.new("Frame")
            slider.fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            slider.fill.Position = UDim2.new(0, 0, 0, 0)
            slider.fill.BackgroundColor3 = Theme.Primary
            slider.fill.BorderSizePixel = 0
            slider.fill.Parent = sliderBg
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = slider.fill
            
            -- Slider handle
            slider.handle = Instance.new("TextButton")
            slider.handle.Size = UDim2.new(0, 16, 0, 16)
            slider.handle.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
            slider.handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            slider.handle.BorderSizePixel = 0
            slider.handle.Text = ""
            slider.handle.AutoButtonColor = false
            slider.handle.Parent = sliderBg
            
            local handleCorner = Instance.new("UICorner")
            handleCorner.CornerRadius = UDim.new(1, 0)
            handleCorner.Parent = slider.handle
            
            local handleStroke = Instance.new("UIStroke")
            handleStroke.Color = Theme.Primary
            handleStroke.Thickness = 2
            handleStroke.Parent = slider.handle
            
            -- Slider logic
            local sliding = false
            
            local function updateSlider(value)
                local percent = (value - min) / (max - min)
                percent = math.clamp(percent, 0, 1)
                
                slider.value = math.floor(min + (max - min) * percent)
                slider.valueLabel.Text = tostring(slider.value)
                slider.fill.Size = UDim2.new(percent, 0, 1, 0)
                slider.handle.Position = UDim2.new(percent, -8, 0.5, -8)
                
                if callback then
                    callback(slider.value)
                end
            end
            
            local function startSliding()
                sliding = true
                window.scrollFrame.ScrollingEnabled = false
            end
            
            local function stopSliding()
                sliding = false
                window.scrollFrame.ScrollingEnabled = true
            end
            
            -- Update from mouse position
            local function updateFromMouse()
                if sliding then
                    local mouse = Player:GetMouse()
                    local bgPos = sliderBg.AbsolutePosition
                    local bgSize = sliderBg.AbsoluteSize
                    
                    local relativeX = (mouse.X - bgPos.X) / bgSize.X
                    relativeX = math.clamp(relativeX, 0, 1)
                    
                    local value = min + (max - min) * relativeX
                    updateSlider(value)
                end
            end
            
            -- Input events
            slider.handle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    startSliding()
                end
            end)
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = Player:GetMouse()
                    local bgPos = sliderBg.AbsolutePosition
                    local bgSize = sliderBg.AbsoluteSize
                    
                    local relativeX = (mouse.X - bgPos.X) / bgSize.X
                    relativeX = math.clamp(relativeX, 0, 1)
                    
                    local value = min + (max - min) * relativeX
                    updateSlider(value)
                    startSliding()
                end
            end)
            
            -- Mouse movement
            local connection
            slider.handle.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    connection = RunService.RenderStepped:Connect(function()
                        if sliding then
                            updateFromMouse()
                        else
                            connection:Disconnect()
                        end
                    end)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    stopSliding()
                end
            end)
            
            -- Container boyutunu güncelle
            self.elementContainer.Size = UDim2.new(1, 0, 0, (#self.elements + 1) * 55 + 10)
            window.scrollContent.Size = UDim2.new(1, 0, 0, math.max(400, (#window.sections + 1) * 200))
            window.scrollFrame.CanvasSize = window.scrollContent.Size
            
            table.insert(self.elements, slider)
            return slider
        end
        
        -- Section'ı kaydet
        table.insert(window.sections, section)
        
        -- Container boyutunu güncelle
        window.contentContainer.Size = UDim2.new(#window.tabs, 0, 1, 0)
        
        return section
    end
    
    -- İlk tab'ı aktif yap
    if #window.tabs > 0 then
        window:SwitchTab(1)
    end
    
    return window
end

-- Library'yi döndür
return Library
