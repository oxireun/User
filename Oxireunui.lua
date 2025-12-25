-- Oxireun UI Library v1.0
-- GitHub: https://github.com/oxireun

local Oxireun = {}
Oxireun.__index = Oxireun

-- Servisler
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Renk Paleti
local Colors = {
    Primary = Color3.fromRGB(0, 150, 255),
    Secondary = Color3.fromRGB(30, 25, 60),
    Background = Color3.fromRGB(25, 20, 45),
    Text = Color3.fromRGB(200, 220, 255),
    DarkText = Color3.fromRGB(150, 150, 180),
    Success = Color3.fromRGB(0, 200, 100),
    Warning = Color3.fromRGB(255, 150, 0),
    Error = Color3.fromRGB(255, 50, 50)
}

-- Fontlar
local Fonts = {
    Title = Enum.Font.GothamBold,
    Header = Enum.Font.GothamBold,
    Body = Enum.Font.Gotham,
    Button = Enum.Font.GothamMedium
}

-- Animasyonlar
local TweenInfo = {
    Default = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}

-- Window oluşturma
function Oxireun:NewWindow(title)
    local window = {}
    setmetatable(window, Oxireun)
    
    -- Main GUI
    window.gui = Instance.new("ScreenGui")
    window.gui.Name = "OxireunUI"
    window.gui.ResetOnSpawn = false
    window.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Ana Çerçeve
    window.main = Instance.new("Frame")
    window.main.Size = UDim2.fromScale(0.35, 0.6)
    window.main.Position = UDim2.fromScale(0.5, 0.5)
    window.main.AnchorPoint = Vector2.new(0.5, 0.5)
    window.main.BackgroundColor3 = Colors.Background
    window.main.BackgroundTransparency = 0
    window.main.BorderSizePixel = 0
    window.main.Active = true
    window.main.Draggable = true
    window.main.Parent = window.gui
    
    -- Köşe yuvarlatma
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = window.main
    
    -- Neon Border
    local mainGlow = Instance.new("UIStroke")
    mainGlow.Color = Colors.Primary
    mainGlow.Thickness = 3
    mainGlow.Transparency = 0.2
    mainGlow.Parent = window.main
    
    -- Üst Bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Colors.Secondary
    topBar.BackgroundTransparency = 0
    topBar.BorderSizePixel = 0
    topBar.Name = "TopBar"
    topBar.Parent = window.main
    
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    topBarCorner.Parent = topBar
    
    -- Üst bar alt çizgisi
    local topBarLine = Instance.new("Frame")
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = Colors.Primary
    topBarLine.BorderSizePixel = 0
    topBarLine.Name = "TopBarLine"
    topBarLine.Parent = topBar
    
    -- Kapatma Butonu
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -13)
    closeBtn.AnchorPoint = Vector2.new(0, 0.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 50)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.Parent = topBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
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
    
    -- Başlık
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "OXIREUN UI"
    titleLabel.TextColor3 = Colors.Text
    titleLabel.Font = Fonts.Title
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    
    -- İçerik Alanı
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -20, 1, -70)
    contentArea.Position = UDim2.new(0, 10, 0, 60)
    contentArea.BackgroundColor3 = Colors.Secondary
    contentArea.BackgroundTransparency = 0.1
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    contentArea.Parent = window.main
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentArea
    
    -- Scrolling Frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Colors.Primary
    scrollFrame.ScrollBarImageTransparency = 0.7
    scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = contentArea
    
    local scrollContent = Instance.new("UIListLayout")
    scrollContent.SortOrder = Enum.SortOrder.LayoutOrder
    scrollContent.Padding = UDim.new(0, 10)
    scrollContent.Parent = scrollFrame
    
    -- Hover efekti
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.Default, {BackgroundTransparency = 0.4}):Play()
        TweenService:Create(closeLine1, TweenInfo.Default, {BackgroundColor3 = Color3.fromRGB(255, 140, 150)}):Play()
        TweenService:Create(closeLine2, TweenInfo.Default, {BackgroundColor3 = Color3.fromRGB(255, 140, 150)}):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.Default, {BackgroundTransparency = 0.6}):Play()
        TweenService:Create(closeLine1, TweenInfo.Default, {BackgroundColor3 = Color3.fromRGB(240, 120, 130)}):Play()
        TweenService:Create(closeLine2, TweenInfo.Default, {BackgroundColor3 = Color3.fromRGB(240, 120, 130)}):Play()
    end)
    
    -- Kapatma
    closeBtn.MouseButton1Click:Connect(function()
        window:Destroy()
    end)
    
    -- Bileşenleri sakla
    window.scrollFrame = scrollFrame
    window.sections = {}
    
    -- GUI'yi ana parçaya ata
    window.gui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    return window
end

-- Section oluşturma
function Oxireun:NewSection(name)
    local section = {}
    section.name = name
    section.elements = {}
    
    -- Section container
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, -10, 0, 0)
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    sectionFrame.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
    sectionFrame.BackgroundTransparency = 0.2
    sectionFrame.BorderSizePixel = 0
    sectionFrame.LayoutOrder = #self.sections + 1
    sectionFrame.Parent = self.scrollFrame
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = sectionFrame
    
    -- Section başlığı
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -20, 0, 30)
    sectionLabel.Position = UDim2.new(0, 10, 0, 5)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = name
    sectionLabel.TextColor3 = Colors.Primary
    sectionLabel.Font = Fonts.Header
    sectionLabel.TextSize = 14
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame
    
    -- Section alt çizgisi
    local sectionLine = Instance.new("Frame")
    sectionLine.Size = UDim2.new(1, -20, 0, 1)
    sectionLine.Position = UDim2.new(0, 10, 0, 35)
    sectionLine.BackgroundColor3 = Colors.Primary
    sectionLine.BorderSizePixel = 0
    sectionLine.Transparency = 0.3
    sectionLine.Parent = sectionFrame
    
    -- Elementler için container
    local elementsContainer = Instance.new("Frame")
    elementsContainer.Size = UDim2.new(1, -20, 0, 0)
    elementsContainer.Position = UDim2.new(0, 10, 0, 40)
    elementsContainer.AutomaticSize = Enum.AutomaticSize.Y
    elementsContainer.BackgroundTransparency = 1
    elementsContainer.Parent = sectionFrame
    
    local elementsLayout = Instance.new("UIListLayout")
    elementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    elementsLayout.Padding = UDim.new(0, 8)
    elementsLayout.Parent = elementsContainer
    
    -- Section'ı kaydet
    section.frame = sectionFrame
    section.container = elementsContainer
    table.insert(self.sections, section)
    
    -- Element oluşturma fonksiyonları
    function section:CreateButton(name, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
        button.BackgroundTransparency = 0.5
        button.BorderSizePixel = 0
        button.Text = name
        button.TextColor3 = Colors.Text
        button.Font = Fonts.Button
        button.TextSize = 12
        button.AutoButtonColor = false
        button.LayoutOrder = #self.elements + 1
        button.Parent = self.container
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Hover efektleri
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.Default, {
                BackgroundTransparency = 0.3,
                TextColor3 = Colors.Primary
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.Default, {
                BackgroundTransparency = 0.5,
                TextColor3 = Colors.Text
            }):Play()
        end)
        
        -- Tıklama
        button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
            print("Button clicked:", name)
        end)
        
        table.insert(self.elements, button)
        return button
    end
    
    function section:CreateToggle(name, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 30)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.LayoutOrder = #self.elements + 1
        toggleFrame.Parent = self.container
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = name
        toggleLabel.TextColor3 = Colors.Text
        toggleLabel.Font = Fonts.Body
        toggleLabel.TextSize = 12
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        -- Toggle background
        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.new(0, 45, 0, 24)
        toggleBg.Position = UDim2.new(1, -45, 0.5, -12)
        toggleBg.AnchorPoint = Vector2.new(0, 0.5)
        toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
        toggleBg.BorderSizePixel = 0
        toggleBg.Parent = toggleFrame
        
        local toggleBgCorner = Instance.new("UICorner")
        toggleBgCorner.CornerRadius = UDim.new(1, 0)
        toggleBgCorner.Parent = toggleBg
        
        -- Toggle circle
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 20, 0, 20)
        toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
        toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleBg
        
        local toggleCircleCorner = Instance.new("UICorner")
        toggleCircleCorner.CornerRadius = UDim.new(1, 0)
        toggleCircleCorner.Parent = toggleCircle
        
        -- Toggle button
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 45, 0, 24)
        toggleBtn.Position = UDim2.new(1, -45, 0.5, -12)
        toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
        toggleBtn.BackgroundTransparency = 1
        toggleBtn.Text = ""
        toggleBtn.Parent = toggleFrame
        
        local state = false
        
        -- Toggle fonksiyonu
        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            
            if state then
                TweenService:Create(toggleBg, TweenInfo.Default, {BackgroundColor3 = Colors.Primary}):Play()
                TweenService:Create(toggleCircle, TweenInfo.Default, {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
            else
                TweenService:Create(toggleBg, TweenInfo.Default, {BackgroundColor3 = Color3.fromRGB(180, 180, 190)}):Play()
                TweenService:Create(toggleCircle, TweenInfo.Default, {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
            end
            
            if callback then
                callback(state)
            end
            print("Toggle changed:", name, state)
        end)
        
        -- Hover efekti
        toggleBtn.MouseEnter:Connect(function()
            TweenService:Create(toggleBg, TweenInfo.Default, {BackgroundTransparency = 0.1}):Play()
        end)
        
        toggleBtn.MouseLeave:Connect(function()
            TweenService:Create(toggleBg, TweenInfo.Default, {BackgroundTransparency = 0}):Play()
        end)
        
        table.insert(self.elements, toggleFrame)
        return {Toggle = toggleBtn, State = false, SetState = function(self, value)
            state = value
            if value then
                toggleBg.BackgroundColor3 = Colors.Primary
                toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
            else
                toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
            end
        end}
    end
    
    function section:CreateSlider(name, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.LayoutOrder = #self.elements + 1
        sliderFrame.Parent = self.container
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = name .. ": " .. default
        sliderLabel.TextColor3 = Colors.Text
        sliderLabel.Font = Fonts.Body
        sliderLabel.TextSize = 12
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        -- Slider background
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, 0, 0, 6)
        sliderBg.Position = UDim2.new(0, 0, 0, 25)
        sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = sliderFrame
        
        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(1, 0)
        sliderBgCorner.Parent = sliderBg
        
        -- Slider fill
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Colors.Primary
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(1, 0)
        sliderFillCorner.Parent = sliderFill
        
        -- Slider handle
        local sliderHandle = Instance.new("TextButton")
        sliderHandle.Size = UDim2.new(0, 16, 0, 16)
        sliderHandle.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
        sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderHandle.BorderSizePixel = 0
        sliderHandle.Text = ""
        sliderHandle.AutoButtonColor = false
        sliderHandle.Parent = sliderBg
        
        local sliderHandleCorner = Instance.new("UICorner")
        sliderHandleCorner.CornerRadius = UDim.new(1, 0)
        sliderHandleCorner.Parent = sliderHandle
        
        local sliderHandleStroke = Instance.new("UIStroke")
        sliderHandleStroke.Color = Colors.Primary
        sliderHandleStroke.Thickness = 2
        sliderHandleStroke.Parent = sliderHandle
        
        local dragging = false
        local currentValue = default
        
        -- Slider güncelleme
        local function updateSlider(value)
            currentValue = math.clamp(value, min, max)
            local percent = (currentValue - min) / (max - min)
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
            sliderLabel.Text = name .. ": " .. currentValue
            
            if callback then
                callback(currentValue)
            end
        end
        
        -- Sürükleme işlemleri
        sliderHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local sliderAbsPos = sliderBg.AbsolutePosition
                local sliderAbsSize = sliderBg.AbsoluteSize
                
                local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                updateSlider(min + (max - min) * relativeX)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local sliderAbsPos = sliderBg.AbsolutePosition
                local sliderAbsSize = sliderBg.AbsoluteSize
                
                local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                updateSlider(min + (max - min) * relativeX)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        table.insert(self.elements, sliderFrame)
        return {Value = currentValue, SetValue = function(self, value)
            updateSlider(value)
        end}
    end
    
    function section:CreateTextbox(name, placeholder, callback)
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Size = UDim2.new(1, 0, 0, 50)
        textboxFrame.BackgroundTransparency = 1
        textboxFrame.LayoutOrder = #self.elements + 1
        textboxFrame.Parent = self.container
        
        local textboxLabel = Instance.new("TextLabel")
        textboxLabel.Size = UDim2.new(1, 0, 0, 20)
        textboxLabel.BackgroundTransparency = 1
        textboxLabel.Text = name
        textboxLabel.TextColor3 = Colors.Text
        textboxLabel.Font = Fonts.Body
        textboxLabel.TextSize = 12
        textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        textboxLabel.Parent = textboxFrame
        
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(1, 0, 0, 30)
        textbox.Position = UDim2.new(0, 0, 0, 20)
        textbox.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
        textbox.BackgroundTransparency = 0.6
        textbox.BorderSizePixel = 0
        textbox.Text = ""
        textbox.PlaceholderText = placeholder or "Enter text..."
        textbox.TextColor3 = Colors.Text
        textbox.PlaceholderColor3 = Colors.DarkText
        textbox.Font = Fonts.Body
        textbox.TextSize = 12
        textbox.ClearTextOnFocus = false
        textbox.Parent = textboxFrame
        
        local textboxCorner = Instance.new("UICorner")
        textboxCorner.CornerRadius = UDim.new(0, 6)
        textboxCorner.Parent = textbox
        
        -- Focus efekti
        textbox.Focused:Connect(function()
            TweenService:Create(textbox, TweenInfo.Default, {BackgroundTransparency = 0.5}):Play()
        end)
        
        textbox.FocusLost:Connect(function(enterPressed)
            TweenService:Create(textbox, TweenInfo.Default, {BackgroundTransparency = 0.6}):Play()
            
            if callback and (enterPressed or not textbox:IsFocused()) then
                callback(textbox.Text)
            end
            print("Textbox changed:", name, textbox.Text)
        end)
        
        table.insert(self.elements, textboxFrame)
        return {TextBox = textbox, GetText = function() return textbox.Text end, SetText = function(self, text)
            textbox.Text = text
        end}
    end
    
    function section:CreateDropdown(name, options, default, callback)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, 50)
        dropdownFrame.BackgroundTransparency = 1
        dropdownFrame.LayoutOrder = #self.elements + 1
        dropdownFrame.Parent = self.container
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Size = UDim2.new(1, 0, 0, 20)
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Text = name
        dropdownLabel.TextColor3 = Colors.Text
        dropdownLabel.Font = Fonts.Body
        dropdownLabel.TextSize = 12
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.Parent = dropdownFrame
        
        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Size = UDim2.new(1, 0, 0, 30)
        dropdownBtn.Position = UDim2.new(0, 0, 0, 20)
        dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
        dropdownBtn.BackgroundTransparency = 0.5
        dropdownBtn.BorderSizePixel = 0
        dropdownBtn.Text = options[default] or "Select"
        dropdownBtn.TextColor3 = Colors.Text
        dropdownBtn.Font = Fonts.Body
        dropdownBtn.TextSize = 12
        dropdownBtn.AutoButtonColor = false
        dropdownBtn.Parent = dropdownFrame
        
        local dropdownBtnCorner = Instance.new("UICorner")
        dropdownBtnCorner.CornerRadius = UDim.new(0, 6)
        dropdownBtnCorner.Parent = dropdownBtn
        
        -- Dropdown options
        local dropdownOptions = Instance.new("Frame")
        dropdownOptions.Size = UDim2.new(1, 0, 0, 0)
        dropdownOptions.Position = UDim2.new(0, 0, 1, 0)
        dropdownOptions.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
        dropdownOptions.BorderSizePixel = 0
        dropdownOptions.ClipsDescendants = true
        dropdownOptions.Visible = false
        dropdownOptions.Parent = dropdownBtn
        
        local optionsCorner = Instance.new("UICorner")
        optionsCorner.CornerRadius = UDim.new(0, 6)
        optionsCorner.Parent = dropdownOptions
        
        local optionsLayout = Instance.new("UIListLayout")
        optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        optionsLayout.Padding = UDim.new(0, 2)
        optionsLayout.Parent = dropdownOptions
        
        -- Option butonları oluştur
        for i, option in ipairs(options) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Size = UDim2.new(1, 0, 0, 28)
            optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
            optionBtn.BackgroundTransparency = 0.5
            optionBtn.BorderSizePixel = 0
            optionBtn.Text = option
            optionBtn.TextColor3 = Colors.Text
            optionBtn.Font = Fonts.Body
            optionBtn.TextSize = 12
            optionBtn.AutoButtonColor = false
            optionBtn.LayoutOrder = i
            optionBtn.Parent = dropdownOptions
            
            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 4)
            optionCorner.Parent = optionBtn
            
            -- Hover efekti
            optionBtn.MouseEnter:Connect(function()
                TweenService:Create(optionBtn, TweenInfo.Default, {
                    BackgroundTransparency = 0.3,
                    BackgroundColor3 = Color3.fromRGB(65, 55, 95)
                }):Play()
            end)
            
            optionBtn.MouseLeave:Connect(function()
                TweenService:Create(optionBtn, TweenInfo.Default, {
                    BackgroundTransparency = 0.5,
                    BackgroundColor3 = Color3.fromRGB(55, 45, 85)
                }):Play()
            end)
            
            -- Seçim
            optionBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                dropdownOptions.Visible = false
                TweenService:Create(dropdownOptions, TweenInfo.Default, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                
                if callback then
                    callback(option)
                end
                print("Dropdown selected:", name, option)
            end)
        end
        
        -- Dropdown toggle
        local dropdownOpen = false
        dropdownBtn.MouseButton1Click:Connect(function()
            dropdownOpen = not dropdownOpen
            dropdownOptions.Visible = dropdownOpen
            
            if dropdownOpen then
                local totalHeight = #options * 30 + (#options - 1) * 2
                TweenService:Create(dropdownOptions, TweenInfo.Smooth, {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
            else
                TweenService:Create(dropdownOptions, TweenInfo.Smooth, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            end
        end)
        
        -- Hover efekti
        dropdownBtn.MouseEnter:Connect(function()
            TweenService:Create(dropdownBtn, TweenInfo.Default, {BackgroundTransparency = 0.3}):Play()
        end)
        
        dropdownBtn.MouseLeave:Connect(function()
            TweenService:Create(dropdownBtn, TweenInfo.Default, {BackgroundTransparency = 0.5}):Play()
        end)
        
        -- Dışarı tıklayınca kapat
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdownOpen then
                local mousePos = input.Position
                local btnPos = dropdownBtn.AbsolutePosition
                local btnSize = dropdownBtn.AbsoluteSize
                
                if not (mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X and
                       mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y + dropdownOptions.AbsoluteSize.Y) then
                    dropdownOpen = false
                    TweenService:Create(dropdownOptions, TweenInfo.Smooth, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    
                    spawn(function()
                        wait(0.3)
                        dropdownOptions.Visible = false
                    end)
                end
            end
        end)
        
        table.insert(self.elements, dropdownFrame)
        return {Dropdown = dropdownBtn, Options = options, SetOption = function(self, option)
            if table.find(options, option) then
                dropdownBtn.Text = option
            end
        end}
    end
    
    function section:CreateLabel(text)
        local labelFrame = Instance.new("Frame")
        labelFrame.Size = UDim2.new(1, 0, 0, 30)
        labelFrame.BackgroundTransparency = 1
        labelFrame.LayoutOrder = #self.elements + 1
        labelFrame.Parent = self.container
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Colors.DarkText
        label.Font = Fonts.Body
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = labelFrame
        
        table.insert(self.elements, labelFrame)
        return label
    end
    
    -- Section'ı döndür
    self.container.AutomaticSize = Enum.AutomaticSize.Y
    return section
end

-- Notification fonksiyonu (isteğe bağlı)
function Oxireun:Notification(title, message, duration)
    duration = duration or 3
    
    -- Notification container
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0.25, 0, 0, 70)
    notification.Position = UDim2.new(0.75, 0, 1, 0)
    notification.AnchorPoint = Vector2.new(0.5, 0)
    notification.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
    notification.BorderSizePixel = 0
    notification.ZIndex = 1000
    notification.Parent = self.gui
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 10)
    notificationCorner.Parent = notification
    
    local notificationGlow = Instance.new("UIStroke")
    notificationGlow.Color = Colors.Primary
    notificationGlow.Thickness = 3
    notificationGlow.Transparency = 0.3
    notificationGlow.Parent = notification
    
    -- İçerik
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -20, 0, 25)
    notifTitle.Position = UDim2.new(0, 10, 0, 10)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = Colors.Text
    notifTitle.Font = Fonts.Header
    notifTitle.TextSize = 14
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.Parent = notification
    
    local notifMessage = Instance.new("TextLabel")
    notifMessage.Size = UDim2.new(1, -20, 0, 20)
    notifMessage.Position = UDim2.new(0, 10, 0, 35)
    notifMessage.BackgroundTransparency = 1
    notifMessage.Text = message
    notifMessage.TextColor3 = Colors.DarkText
    notifMessage.Font = Fonts.Body
    notifMessage.TextSize = 12
    notifMessage.TextXAlignment = Enum.TextXAlignment.Left
    notifMessage.Parent = notification
    
    -- Animasyon
    notification.Visible = true
    TweenService:Create(notification, TweenInfo.Bounce, {
        Position = UDim2.new(0.75, 0, 0.85, 0)
    }):Play()
    
    -- Otomatik kapanma
    spawn(function()
        wait(duration)
        TweenService:Create(notification, TweenInfo.Smooth, {
            Position = UDim2.new(0.75, 0, 1, 0)
        }):Play()
        wait(0.3)
        notification:Destroy()
    end)
end

-- UI'yi kaldırma
function Oxireun:Destroy()
    if self.gui then
        self.gui:Destroy()
    end
end

-- Library'yi döndür
return Oxireun
