--[[
    Blade Runner 2049 Theme UI Library - Güncellenmiş
    GitHub: https://raw.githubusercontent.com/username/blade-ui/main/main.lua
    Tasarım: Neon mor, yuvarlak köşeler, Blade Runner 2049 tarzı
]]

local BladesRunnerUI = {}
BladesRunnerUI.__index = BladesRunnerUI

-- Tema renkleri
local Theme = {
    Background = Color3.fromRGB(15, 15, 25),
    Secondary = Color3.fromRGB(25, 20, 35),
    Accent = Color3.fromRGB(138, 43, 226), -- Mor neon
    Accent2 = Color3.fromRGB(186, 85, 211), -- Açık mor
    Text = Color3.fromRGB(240, 240, 255),
    TextSecondary = Color3.fromRGB(180, 180, 200),
    Border = Color3.fromRGB(138, 43, 226),
    Success = Color3.fromRGB(46, 204, 113),
    Danger = Color3.fromRGB(231, 76, 60)
}

-- Servisler
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Yardımcı fonksiyonlar
local function CreateShadow(frame)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame
    return shadow
end

local function RippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local mouse = button:FindFirstAncestorOfClass("ScreenGui"):GetMouse()
    ripple.Position = UDim2.new(0, mouse.X - button.AbsolutePosition.X, 0, mouse.Y - button.AbsolutePosition.Y)
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(ripple, tweenInfo, {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Ana Library fonksiyonu
function BladesRunnerUI:NewWindow(title)
    local screenGui = Instance.new("ScreenGui")
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
    screenGui.Name = "BladesRunnerUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Ana pencere
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 400, 0, 450)
    mainWindow.Position = UDim2.new(0, 50, 0.5, -225)
    mainWindow.BackgroundColor3 = Theme.Background
    mainWindow.BorderSizePixel = 0
    mainWindow.ZIndex = 10
    mainWindow.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainWindow
    
    -- Neon border efekti
    local borderGlow = Instance.new("Frame")
    borderGlow.Name = "BorderGlow"
    borderGlow.Size = UDim2.new(1, 4, 1, 4)
    borderGlow.Position = UDim2.new(0, -2, 0, -2)
    borderGlow.BackgroundColor3 = Theme.Accent
    borderGlow.BackgroundTransparency = 0.8
    borderGlow.ZIndex = 9
    borderGlow.Parent = mainWindow
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 14)
    glowCorner.Parent = borderGlow
    
    -- Başlık barı
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Theme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 11
    titleBar.Parent = mainWindow
    
    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    titleBarCorner.Parent = titleBar
    
    -- Başlık
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Blades Runner UI"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 12
    titleLabel.Parent = titleBar
    
    -- Kontrol butonları (küçük ve yuvarlak)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 22, 0, 22) -- Daha küçük
    closeButton.Position = UDim2.new(1, -32, 0.5, -11) -- Pozisyon güncellendi
    closeButton.AnchorPoint = Vector2.new(1, 0.5)
    closeButton.BackgroundColor3 = Theme.Danger
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextSize = 16 -- Daha küçük yazı
    closeButton.Font = Enum.Font.GothamBold
    closeButton.ZIndex = 12
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0) -- Tam yuvarlak
    closeCorner.Parent = closeButton
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 22, 0, 22) -- Daha küçük
    minimizeButton.Position = UDim2.new(1, -59, 0.5, -11) -- Pozisyon güncellendi
    minimizeButton.AnchorPoint = Vector2.new(1, 0.5)
    minimizeButton.BackgroundColor3 = Theme.Accent2
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    minimizeButton.TextSize = 16 -- Daha küçük yazı
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.ZIndex = 12
    minimizeButton.Parent = titleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(1, 0) -- Tam yuvarlak
    minimizeCorner.Parent = minimizeButton
    
    -- Sekme konteyneri
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -30, 0, 35)
    tabContainer.Position = UDim2.new(0, 15, 0, 45)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ZIndex = 11
    tabContainer.Parent = mainWindow
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabContainer
    
    -- İçerik konteyneri
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -30, 1, -95)
    contentContainer.Position = UDim2.new(0, 15, 0, 90)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ClipsDescendants = true
    contentContainer.ZIndex = 10
    contentContainer.Parent = mainWindow
    
    -- Sürükleme işlevselliği - DÜZGÜN ÇALIŞAN VERSİYON
    local dragging = false
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    local dragConnection
    
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainWindow.Position
            
            dragConnection = UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
        end
    end
    
    local function endDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            if dragConnection then
                dragConnection:Disconnect()
                dragConnection = nil
            end
        end
    end
    
    titleBar.InputBegan:Connect(startDrag)
    titleBar.InputEnded:Connect(endDrag)
    
    -- Buton event'leri
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    local minimized = false
    local originalSize = mainWindow.Size
    local originalContentSize = contentContainer.Size
    
    minimizeButton.MouseButton1Click:Connect(function()
        if not minimized then
            minimized = true
            mainWindow:TweenSize(
                UDim2.new(mainWindow.Size.X.Scale, mainWindow.Size.X.Offset, 0, 35),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2
            )
            contentContainer.Visible = false
            tabContainer.Visible = false
        else
            minimized = false
            mainWindow:TweenSize(
                originalSize,
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2
            )
            contentContainer.Visible = true
            tabContainer.Visible = true
        end
    end)
    
    -- Buton hover efektleri
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(192, 57, 43)}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Danger}):Play()
    end)
    
    minimizeButton.MouseEnter:Connect(function()
        TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(142, 68, 173)}):Play()
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent2}):Play()
    end)
    
    -- Window objesini oluştur
    local window = {
        ScreenGui = screenGui,
        MainWindow = mainWindow,
        TabContainer = tabContainer,
        ContentContainer = contentContainer,
        Tabs = {},
        CurrentTab = nil
    }
    
    setmetatable(window, self)
    
    function window:NewSection(name)
        local section = {}
        
        -- Sekme butonu
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(0, 80, 0, 30)
        tabButton.BackgroundColor3 = Theme.Secondary
        tabButton.Text = name
        tabButton.TextColor3 = Theme.TextSecondary
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.Gotham
        tabButton.AutoButtonColor = false
        tabButton.ZIndex = 12
        tabButton.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        -- Sekme içeriği
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Name = name .. "Content"
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.Position = UDim2.new(0, 0, 0, 0)
        contentFrame.BackgroundTransparency = 1
        contentFrame.BorderSizePixel = 0
        contentFrame.ScrollBarThickness = 3
        contentFrame.ScrollBarImageColor3 = Theme.Accent
        contentFrame.Visible = false
        contentFrame.ZIndex = 10
        contentFrame.Parent = contentContainer
        
        local contentListLayout = Instance.new("UIListLayout")
        contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentListLayout.Padding = UDim.new(0, 10)
        contentListLayout.Parent = contentFrame
        
        contentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Sekme seçimi
        table.insert(self.Tabs, {
            Button = tabButton,
            Content = contentFrame,
            Name = name
        })
        
        tabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Theme.Secondary,
                    TextColor3 = Theme.TextSecondary
                }):Play()
            end
            
            contentFrame.Visible = true
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Accent,
                TextColor3 = Color3.new(1, 1, 1)
            }):Play()
            
            self.CurrentTab = name
        end)
        
        -- İlk sekmeyi aktif yap
        if #self.Tabs == 1 then
            tabButton.BackgroundColor3 = Theme.Accent
            tabButton.TextColor3 = Color3.new(1, 1, 1)
            contentFrame.Visible = true
            self.CurrentTab = name
        end
        
        -- Buton efektleri
        tabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= name then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 35, 50)}):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= name then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}):Play()
            end
        end)
        
        -- Bileşen oluşturma fonksiyonları
        function section:CreateButton(name, callback)
            local button = Instance.new("TextButton")
            button.Name = name
            button.Size = UDim2.new(1, 0, 0, 35)
            button.BackgroundColor3 = Theme.Secondary
            button.Text = name
            button.TextColor3 = Theme.Text
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.AutoButtonColor = false
            button.ZIndex = 11
            button.Parent = contentFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 8)
            buttonCorner.Parent = button
            
            local buttonBorder = Instance.new("Frame")
            buttonBorder.Name = "Border"
            buttonBorder.Size = UDim2.new(1, 2, 1, 2)
            buttonBorder.Position = UDim2.new(0, -1, 0, -1)
            buttonBorder.BackgroundColor3 = Theme.Accent
            buttonBorder.BackgroundTransparency = 0.7
            buttonBorder.ZIndex = 10
            buttonBorder.Parent = button
            
            local borderCorner = Instance.new("UICorner")
            borderCorner.CornerRadius = UDim.new(0, 9)
            borderCorner.Parent = buttonBorder
            
            -- Hover efektleri
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 35, 50)}):Play()
                TweenService:Create(buttonBorder, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}):Play()
                TweenService:Create(buttonBorder, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
            end)
            
            -- Tıklama efekti
            button.MouseButton1Click:Connect(function()
                RippleEffect(button)
                if callback then
                    callback()
                end
            end)
            
            return button
        end
        
        function section:CreateToggle(name, callback)
            local toggle = Instance.new("Frame")
            toggle.Name = name
            toggle.Size = UDim2.new(1, 0, 0, 35)
            toggle.BackgroundTransparency = 1
            toggle.ZIndex = 10
            toggle.Parent = contentFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Name = "Label"
            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.Position = UDim2.new(0, 0, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = name
            toggleLabel.TextColor3 = Theme.Text
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.ZIndex = 11
            toggleLabel.Parent = toggle
            
            -- iPhone tarzı toggle
            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "Toggle"
            toggleButton.Size = UDim2.new(0, 50, 0, 25)
            toggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
            toggleButton.AnchorPoint = Vector2.new(1, 0.5)
            toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
            toggleButton.AutoButtonColor = false
            toggleButton.Text = ""
            toggleButton.ZIndex = 11
            toggleButton.Parent = toggle
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggleButton
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Name = "Circle"
            toggleCircle.Size = UDim2.new(0, 21, 0, 21)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10.5)
            toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
            toggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
            toggleCircle.ZIndex = 12
            toggleCircle.Parent = toggleButton
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
            
            local state = false
            
            local function updateToggle()
                if state then
                    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10.5)}):Play()
                else
                    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 80)}):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10.5)}):Play()
                end
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                updateToggle()
                if callback then
                    callback(state)
                end
            end)
            
            -- Hover efekti
            toggleButton.MouseEnter:Connect(function()
                TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 90, 100)}):Play()
            end)
            
            toggleButton.MouseLeave:Connect(function()
                if not state then
                    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 80)}):Play()
                end
            end)
            
            return {
                Set = function(value)
                    state = value
                    updateToggle()
                end,
                Get = function()
                    return state
                end
            }
        end
        
        function section:CreateSlider(name, min, max, default, callback)
            local slider = Instance.new("Frame")
            slider.Name = name
            slider.Size = UDim2.new(1, 0, 0, 60)
            slider.BackgroundTransparency = 1
            slider.ZIndex = 10
            slider.Parent = contentFrame
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Name = "Label"
            sliderLabel.Size = UDim2.new(1, 0, 0, 20)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = name .. ": " .. tostring(default)
            sliderLabel.TextColor3 = Theme.Text
            sliderLabel.TextSize = 14
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.ZIndex = 11
            sliderLabel.Parent = slider
            
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Name = "Track"
            sliderTrack.Size = UDim2.new(1, 0, 0, 8)
            sliderTrack.Position = UDim2.new(0, 0, 0, 30)
            sliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            sliderTrack.ZIndex = 11
            sliderTrack.Parent = slider
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = sliderTrack
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "Fill"
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Theme.Accent
            sliderFill.ZIndex = 12
            sliderFill.Parent = sliderTrack
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = sliderFill
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Name = "SliderButton"
            sliderButton.Size = UDim2.new(0, 18, 0, 18) -- Daha küçük yap
            sliderButton.Position = UDim2.new(sliderFill.Size.X.Scale, -9, 0.5, -9) -- Pozisyon ayarlandı
            sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
            sliderButton.AutoButtonColor = false
            sliderButton.Text = ""
            sliderButton.ZIndex = 13
            sliderButton.Parent = sliderTrack
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(1, 0)
            buttonCorner.Parent = sliderButton
            
            local dragging = false
            local value = default
            local sliderDragConnection
            
            local function updateSlider(input)
                if not input then return end
                
                local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                relativeX = math.clamp(relativeX, 0, 1)
                
                value = math.floor(min + (max - min) * relativeX)
                
                sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                sliderButton.Position = UDim2.new(relativeX, -9, 0.5, -9) -- Pozisyon güncellendi
                sliderLabel.Text = name .. ": " .. tostring(value)
                
                if callback then
                    callback(value)
                end
            end
            
            local function startSlide(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    
                    sliderDragConnection = UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            updateSlider(input)
                        end
                    end)
                end
            end
            
            local function endSlide(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    if sliderDragConnection then
                        sliderDragConnection:Disconnect()
                        sliderDragConnection = nil
                    end
                end
            end
            
            sliderButton.InputBegan:Connect(startSlide)
            sliderTrack.InputBegan:Connect(startSlide)
            
            sliderButton.InputEnded:Connect(endSlide)
            sliderTrack.InputEnded:Connect(endSlide)
            
            return {
                Set = function(newValue)
                    value = math.clamp(newValue, min, max)
                    local relativeX = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    sliderButton.Position = UDim2.new(relativeX, -9, 0.5, -9)
                    sliderLabel.Text = name .. ": " .. tostring(value)
                    
                    if callback then
                        callback(value)
                    end
                end,
                Get = function()
                    return value
                end
            }
        end
        
        function section:CreateTextbox(name, callback)
            local textbox = Instance.new("Frame")
            textbox.Name = name
            textbox.Size = UDim2.new(1, 0, 0, 35)
            textbox.BackgroundTransparency = 1
            textbox.ZIndex = 10
            textbox.Parent = contentFrame
            
            local textboxLabel = Instance.new("TextLabel")
            textboxLabel.Name = "Label"
            textboxLabel.Size = UDim2.new(0.3, 0, 1, 0)
            textboxLabel.BackgroundTransparency = 1
            textboxLabel.Text = name
            textboxLabel.TextColor3 = Theme.Text
            textboxLabel.TextSize = 14
            textboxLabel.Font = Enum.Font.Gotham
            textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            textboxLabel.ZIndex = 11
            textboxLabel.Parent = textbox
            
            local inputFrame = Instance.new("Frame")
            inputFrame.Name = "InputFrame"
            inputFrame.Size = UDim2.new(0.7, 0, 1, 0)
            inputFrame.Position = UDim2.new(0.3, 0, 0, 0)
            inputFrame.BackgroundColor3 = Theme.Secondary
            inputFrame.ZIndex = 11
            inputFrame.Parent = textbox
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 8)
            inputCorner.Parent = inputFrame
            
            local inputBorder = Instance.new("Frame")
            inputBorder.Name = "Border"
            inputBorder.Size = UDim2.new(1, 2, 1, 2)
            inputBorder.Position = UDim2.new(0, -1, 0, -1)
            inputBorder.BackgroundColor3 = Theme.Accent
            inputBorder.BackgroundTransparency = 0.7
            inputBorder.ZIndex = 10
            inputBorder.Parent = inputFrame
            
            local borderCorner = Instance.new("UICorner")
            borderCorner.CornerRadius = UDim.new(0, 9)
            borderCorner.Parent = inputBorder
            
            local textBoxInput = Instance.new("TextBox")
            textBoxInput.Name = "TextBox"
            textBoxInput.Size = UDim2.new(1, -10, 1, -10)
            textBoxInput.Position = UDim2.new(0, 5, 0, 5)
            textBoxInput.BackgroundTransparency = 1
            textBoxInput.TextColor3 = Theme.Text
            textBoxInput.TextSize = 14
            textBoxInput.Font = Enum.Font.Gotham
            textBoxInput.PlaceholderText = "Type here..."
            textBoxInput.PlaceholderColor3 = Theme.TextSecondary
            textBoxInput.Text = ""
            textBoxInput.ZIndex = 12
            textBoxInput.Parent = inputFrame
            
            textBoxInput.Focused:Connect(function()
                TweenService:Create(inputBorder, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
            end)
            
            textBoxInput.FocusLost:Connect(function()
                TweenService:Create(inputBorder, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
                if callback then
                    callback(textBoxInput.Text)
                end
            end)
            
            return textBoxInput
        end
        
        function section:CreateDropdown(name, options, default, callback)
            local dropdown = Instance.new("Frame")
            dropdown.Name = name
            dropdown.Size = UDim2.new(1, 0, 0, 35)
            dropdown.BackgroundTransparency = 1
            dropdown.ClipsDescendants = true
            dropdown.ZIndex = 10
            dropdown.Parent = contentFrame
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Name = "DropdownButton"
            dropdownButton.Size = UDim2.new(1, 0, 0, 35)
            dropdownButton.BackgroundColor3 = Theme.Secondary
            dropdownButton.Text = name .. ": " .. tostring(options[default] or options[1] or "Select")
            dropdownButton.TextColor3 = Theme.Text
            dropdownButton.TextSize = 14
            dropdownButton.Font = Enum.Font.Gotham
            dropdownButton.AutoButtonColor = false
            dropdownButton.ZIndex = 11
            dropdownButton.Parent = dropdown
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 8)
            buttonCorner.Parent = dropdownButton
            
            local dropdownBorder = Instance.new("Frame")
            dropdownBorder.Name = "Border"
            dropdownBorder.Size = UDim2.new(1, 2, 1, 2)
            dropdownBorder.Position = UDim2.new(0, -1, 0, -1)
            dropdownBorder.BackgroundColor3 = Theme.Accent
            dropdownBorder.BackgroundTransparency = 0.7
            dropdownBorder.ZIndex = 10
            dropdownBorder.Parent = dropdownButton
            
            local borderCorner = Instance.new("UICorner")
            borderCorner.CornerRadius = UDim.new(0, 9)
            borderCorner.Parent = dropdownBorder
            
            local dropdownList = Instance.new("Frame")
            dropdownList.Name = "DropdownList"
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
            dropdownList.Position = UDim2.new(0, 0, 1, 5)
            dropdownList.BackgroundColor3 = Theme.Secondary
            dropdownList.ZIndex = 20
            dropdownList.Visible = false
            dropdownList.Parent = dropdown
            
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 8)
            listCorner.Parent = dropdownList
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = dropdownList
            
            local open = false
            local selected = options[default] or options[1]
            
            local function toggleDropdown()
                open = not open
                if open then
                    dropdownList.Visible = true
                    dropdownList:TweenSize(
                        UDim2.new(1, 0, 0, #options * 30),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2
                    )
                    TweenService:Create(dropdownBorder, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
                else
                    dropdownList:TweenSize(
                        UDim2.new(1, 0, 0, 0),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true,
                        function()
                            dropdownList.Visible = false
                        end
                    )
                    TweenService:Create(dropdownBorder, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
                end
            end
            
            dropdownButton.MouseButton1Click:Connect(function()
                toggleDropdown()
            end)
            
            -- Hover efekti
            dropdownButton.MouseEnter:Connect(function()
                TweenService:Create(dropdownButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 35, 50)}):Play()
            end)
            
            dropdownButton.MouseLeave:Connect(function()
                TweenService:Create(dropdownButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}):Play()
            end)
            
            -- Seçenekleri oluştur
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = option
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.BackgroundColor3 = Theme.Secondary
                optionButton.Text = option
                optionButton.TextColor3 = Theme.Text
                optionButton.TextSize = 14
                optionButton.Font = Enum.Font.Gotham
                optionButton.AutoButtonColor = false
                optionButton.ZIndex = 21
                optionButton.LayoutOrder = i
                optionButton.Parent = dropdownList
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 6)
                optionCorner.Parent = optionButton
                
                optionButton.MouseButton1Click:Connect(function()
                    selected = option
                    dropdownButton.Text = name .. ": " .. option
                    toggleDropdown()
                    
                    if callback then
                        callback(option)
                    end
                end)
                
                optionButton.MouseEnter:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 45, 60)}):Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}):Play()
                end)
            end
            
            return {
                Set = function(option)
                    selected = option
                    dropdownButton.Text = name .. ": " .. option
                    if callback then
                        callback(option)
                    end
                end,
                Get = function()
                    return selected
                end
            }
        end
        
        return section
    end
    
    return window
end

-- Loadstring için dışa aktarım
return BladesRunnerUI
