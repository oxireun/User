-- Oxireun UI Library
-- Wizard UI tarzında, Blade Runner temasında kütüphane
-- Tüm executor'lerde çalışır

local Oxireun = {}
Oxireun.__index = Oxireun

-- Servisler
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Tema ayarları
local Theme = {
    Primary = Color3.fromRGB(0, 150, 255),
    Background = Color3.fromRGB(25, 20, 45),
    Secondary = Color3.fromRGB(30, 25, 60),
    Text = Color3.fromRGB(180, 200, 255),
    TextSecondary = Color3.fromRGB(150, 150, 180),
    Success = Color3.fromRGB(0, 200, 100),
    Error = Color3.fromRGB(240, 120, 130)
}

-- Yuvarlak köşe fonksiyonu
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Stroke efekti
local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Primary
    stroke.Thickness = thickness or 2
    stroke.Parent = parent
    return stroke
end

-- NOTIFICATION SİSTEMİ
local notificationContainer = Instance.new("ScreenGui")
notificationContainer.Name = "OxireunNotifications"
notificationContainer.ResetOnSpawn = false
notificationContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
notificationContainer.Parent = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")

local function showNotification(title, message, duration, notifType)
    duration = duration or 3
    notifType = notifType or "Info"
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 70)
    notification.Position = UDim2.new(1, 10, 0.8, 0)
    notification.BackgroundColor3 = Theme.Background
    notification.BackgroundTransparency = 0
    notification.BorderSizePixel = 0
    notification.ZIndex = 1000
    notification.Parent = notificationContainer
    
    createCorner(notification, 10)
    createStroke(notification, Theme.Primary, 3)
    
    -- Üst çizgi
    local topLine = Instance.new("Frame")
    topLine.Size = UDim2.new(1, 0, 0, 2)
    topLine.Position = UDim2.new(0, 0, 0, 0)
    topLine.BackgroundColor3 = Theme.Primary
    topLine.BorderSizePixel = 0
    topLine.Parent = notification
    
    -- İkon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 40, 1, 0)
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "🔔"
    icon.TextColor3 = Color3.fromRGB(255, 200, 100)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 20
    icon.Parent = notification
    
    -- Başlık
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.Position = UDim2.new(0, 50, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    -- Mesaj
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -60, 0, 20)
    messageLabel.Position = UDim2.new(0, 50, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(200, 220, 240)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 11
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Parent = notification
    
    -- Animasyonla gel
    notification.Position = UDim2.new(1, 10, 0.8, 0)
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -310, 0.8, 0)
    })
    tweenIn:Play()
    
    -- Süre sonunda kapan
    task.spawn(function()
        task.wait(duration)
        local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, 0.8, 0)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
    
    return notification
end

-- PENCERE SİSTEMİ
function Oxireun:NewWindow(title)
    title = title or "Oxireun UI"
    
    local window = {}
    setmetatable(window, self)
    
    -- Ana GUI
    window.gui = Instance.new("ScreenGui")
    window.gui.Name = "OxireunWindow"
    window.gui.ResetOnSpawn = false
    window.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    window.gui.Parent = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
    
    -- Ana çerçeve
    window.main = Instance.new("Frame")
    window.main.Size = UDim2.fromScale(0.4, 0.75)
    window.main.Position = UDim2.fromScale(0.03, 0.1)
    window.main.BackgroundColor3 = Theme.Background
    window.main.BackgroundTransparency = 0
    window.main.BorderSizePixel = 0
    window.main.Active = true
    window.main.Draggable = false -- Manuel sürükleme yapacağız
    window.main.Parent = window.gui
    
    createCorner(window.main, 12)
    createStroke(window.main, Theme.Primary, 3)
    
    -- Üst bar
    window.topBar = Instance.new("Frame")
    window.topBar.Size = UDim2.new(1, 0, 0, 45)
    window.topBar.Position = UDim2.new(0, 0, 0, 0)
    window.topBar.BackgroundColor3 = Theme.Secondary
    window.topBar.BackgroundTransparency = 0
    window.topBar.BorderSizePixel = 0
    window.topBar.Name = "TopBar"
    window.topBar.Parent = window.main
    
    createCorner(window.topBar, 12, 0, 0)
    
    -- Üst bar çizgisi
    local topBarLine = Instance.new("Frame")
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = Theme.Primary
    topBarLine.BorderSizePixel = 0
    topBarLine.Parent = window.topBar
    
    -- Başlık
    window.titleLabel = Instance.new("TextLabel")
    window.titleLabel.Size = UDim2.new(1, -80, 1, 0)
    window.titleLabel.Position = UDim2.new(0, 15, 0, 0)
    window.titleLabel.BackgroundTransparency = 1
    window.titleLabel.Text = title
    window.titleLabel.TextColor3 = Theme.Text
    window.titleLabel.Font = Enum.Font.GothamBold
    window.titleLabel.TextSize = 16
    window.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    window.titleLabel.Parent = window.topBar
    
    -- Kontrol butonları
    local controlButtons = Instance.new("Frame")
    controlButtons.Size = UDim2.new(0, 60, 1, 0)
    controlButtons.Position = UDim2.new(1, -65, 0, 0)
    controlButtons.BackgroundTransparency = 1
    controlButtons.Parent = window.topBar
    
    -- Minimize butonu
    window.minimizeBtn = Instance.new("TextButton")
    window.minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    window.minimizeBtn.Position = UDim2.new(0, 0, 0.5, -13)
    window.minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    window.minimizeBtn.BackgroundTransparency = 0.6
    window.minimizeBtn.BorderSizePixel = 0
    window.minimizeBtn.Text = ""
    window.minimizeBtn.Parent = controlButtons
    
    createCorner(window.minimizeBtn, 6)
    
    local minimizeLine = Instance.new("Frame")
    minimizeLine.Size = UDim2.new(0, 10, 0, 2)
    minimizeLine.Position = UDim2.new(0.5, -5, 0.5, -1)
    minimizeLine.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    minimizeLine.BorderSizePixel = 0
    minimizeLine.Parent = window.minimizeBtn
    
    -- Close butonu
    window.closeBtn = Instance.new("TextButton")
    window.closeBtn.Size = UDim2.new(0, 26, 0, 26)
    window.closeBtn.Position = UDim2.new(0, 30, 0.5, -13)
    window.closeBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 50)
    window.closeBtn.BackgroundTransparency = 0.6
    window.closeBtn.BorderSizePixel = 0
    window.closeBtn.Text = ""
    window.closeBtn.Parent = controlButtons
    
    createCorner(window.closeBtn, 6)
    
    -- Tab container
    window.tabContainer = Instance.new("Frame")
    window.tabContainer.Size = UDim2.new(1, -20, 0, 35)
    window.tabContainer.Position = UDim2.new(0, 10, 0, 50)
    window.tabContainer.BackgroundTransparency = 1
    window.tabContainer.Parent = window.main
    
    -- Content area
    window.contentArea = Instance.new("Frame")
    window.contentArea.Size = UDim2.new(1, -20, 1, -100)
    window.contentArea.Position = UDim2.new(0, 10, 0, 90)
    window.contentArea.BackgroundColor3 = Color3.fromRGB(30, 25, 55)
    window.contentArea.BackgroundTransparency = 0
    window.contentArea.BorderSizePixel = 0
    window.contentArea.ClipsDescendants = true
    window.contentArea.Parent = window.main
    
    createCorner(window.contentArea, 8)
    
    -- Section listesi
    window.sections = {}
    window.currentSection = nil
    
    -- Sürükleme işlevselliği (Tüm executor'ler için)
    window.dragging = false
    window.dragInput = nil
    window.dragStart = nil
    window.startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - window.dragStart
        window.main.Position = UDim2.new(
            window.startPos.X.Scale,
            window.startPos.X.Offset + delta.X,
            window.startPos.Y.Scale,
            window.startPos.Y.Offset + delta.Y
        )
    end
    
    window.topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            window.dragging = true
            window.dragStart = input.Position
            window.startPos = window.main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    window.dragging = false
                end
            end)
        end
    end)
    
    window.topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            window.dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == window.dragInput and window.dragging then
            updateInput(input)
        end
    end)
    
    -- Buton event'leri
    window.minimizeBtn.MouseButton1Click:Connect(function()
        window:ToggleMinimize()
    end)
    
    window.closeBtn.MouseButton1Click:Connect(function()
        window:Destroy()
    end)
    
    -- Buton hover efektleri
    window.minimizeBtn.MouseEnter:Connect(function()
        window.minimizeBtn.BackgroundTransparency = 0.4
        minimizeLine.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
    end)
    
    window.minimizeBtn.MouseLeave:Connect(function()
        window.minimizeBtn.BackgroundTransparency = 0.6
        minimizeLine.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    end)
    
    window.closeBtn.MouseEnter:Connect(function()
        window.closeBtn.BackgroundTransparency = 0.4
    end)
    
    window.closeBtn.MouseLeave:Connect(function()
        window.closeBtn.BackgroundTransparency = 0.6
    end)
    
    -- Window metodları
    function window:NewSection(name)
        local section = {}
        section.name = name
        section.elements = {}
        
        -- Section frame'i
        section.frame = Instance.new("Frame")
        section.frame.Size = UDim2.new(1, -10, 0, 40)
        section.frame.Position = UDim2.new(0, 5, 0, #window.sections * 45 + 10)
        section.frame.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
        section.frame.BackgroundTransparency = 0.2
        section.frame.BorderSizePixel = 0
        section.frame.Visible = #window.sections == 0
        section.frame.Parent = window.contentArea
        
        createCorner(section.frame, 8)
        
        -- Section başlığı
        section.title = Instance.new("TextLabel")
        section.title.Size = UDim2.new(1, -20, 0, 25)
        section.title.Position = UDim2.new(0, 10, 0, 0)
        section.title.BackgroundTransparency = 1
        section.title.Text = name
        section.title.TextColor3 = Theme.Primary
        section.title.Font = Enum.Font.GothamBold
        section.title.TextSize = 13
        section.title.TextXAlignment = Enum.TextXAlignment.Left
        section.title.Parent = section.frame
        
        -- Section alt çizgisi
        local sectionLine = Instance.new("Frame")
        sectionLine.Size = UDim2.new(1, 0, 0, 1)
        sectionLine.Position = UDim2.new(0, 0, 0, 25)
        sectionLine.BackgroundColor3 = Theme.Primary
        sectionLine.BorderSizePixel = 0
        sectionLine.Transparency = 0.3
        sectionLine.Parent = section.frame
        
        -- Element container
        section.content = Instance.new("Frame")
        section.content.Size = UDim2.new(1, 0, 1, -30)
        section.content.Position = UDim2.new(0, 0, 0, 30)
        section.content.BackgroundTransparency = 1
        section.content.Parent = section.frame
        
        -- Section metodları
        function section:CreateButton(name, callback)
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Size = UDim2.new(1, -20, 0, 30)
            buttonFrame.Position = UDim2.new(0, 10, 0, #section.elements * 35 + 5)
            buttonFrame.BackgroundTransparency = 1
            buttonFrame.Parent = section.content
            
            section.frame.Size = UDim2.new(1, -10, 0, #section.elements * 35 + 40)
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.Position = UDim2.new(0, 0, 0, 0)
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
            button.BackgroundTransparency = 0.5
            button.BorderSizePixel = 0
            button.Text = name
            button.TextColor3 = Theme.Primary
            button.Font = Enum.Font.Gotham
            button.TextSize = 12
            button.Parent = buttonFrame
            
            createCorner(button, 6)
            
            -- Hover efektleri
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
            
            table.insert(section.elements, buttonFrame)
            return button
        end
        
        function section:CreateToggle(name, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -20, 0, 30)
            toggleFrame.Position = UDim2.new(0, 10, 0, #section.elements * 35 + 5)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = section.content
            
            section.frame.Size = UDim2.new(1, -10, 0, #section.elements * 35 + 40)
            
            -- Label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Theme.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggleFrame
            
            -- Toggle background
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 45, 0, 24)
            toggleBg.Position = UDim2.new(1, -45, 0.5, -12)
            toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = toggleFrame
            
            createCorner(toggleBg, 12)
            
            -- Toggle circle
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 20, 0, 20)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0
            toggleCircle.Parent = toggleBg
            
            createCorner(toggleCircle, 10)
            
            -- Toggle button
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 45, 0, 24)
            toggleBtn.Position = UDim2.new(1, -45, 0.5, -12)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.Parent = toggleFrame
            
            local state = false
            
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                
                if state then
                    toggleBg.BackgroundColor3 = Theme.Primary
                    toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                else
                    toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                end
                
                if callback then
                    callback(state)
                end
            end)
            
            table.insert(section.elements, toggleFrame)
            return {Toggle = toggleBtn, SetState = function(newState)
                state = newState
                if state then
                    toggleBg.BackgroundColor3 = Theme.Primary
                    toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                else
                    toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                end
                if callback then
                    callback(state)
                end
            end}
        end
        
        function section:CreateSlider(name, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -20, 0, 50)
            sliderFrame.Position = UDim2.new(0, 10, 0, #section.elements * 35 + 5)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = section.content
            
            section.frame.Size = UDim2.new(1, -10, 0, #section.elements * 35 + 55)
            
            -- Label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, 0, 0, 20)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Theme.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame
            
            -- Value label
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.5, 0, 0, 20)
            valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default or min) .. "/" .. tostring(max)
            valueLabel.TextColor3 = Theme.Text
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = sliderFrame
            
            -- Slider background
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, 0, 0, 6)
            sliderBg.Position = UDim2.new(0, 0, 0, 30)
            sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = sliderFrame
            
            createCorner(sliderBg, 3)
            
            -- Slider fill
            local sliderFill = Instance.new("Frame")
            local percent = (default - min) / (max - min)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = Theme.Primary
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            
            createCorner(sliderFill, 3)
            
            -- Slider handle
            local sliderHandle = Instance.new("TextButton")
            sliderHandle.Size = UDim2.new(0, 16, 0, 16)
            sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
            sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderHandle.BorderSizePixel = 0
            sliderHandle.Text = ""
            sliderHandle.AutoButtonColor = false
            sliderHandle.Parent = sliderBg
            
            createCorner(sliderHandle, 8)
            createStroke(sliderHandle, Theme.Primary, 2)
            
            -- Slider logic
            local sliding = false
            local currentValue = default or min
            
            local function updateSlider(value)
                currentValue = math.clamp(value, min, max)
                local percent = (currentValue - min) / (max - min)
                
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
                valueLabel.Text = math.floor(currentValue) .. "/" .. tostring(max)
                
                if callback then
                    callback(currentValue)
                end
            end
            
            sliderHandle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                end
            end)
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local mouse = Player:GetMouse()
                    local sliderAbsPos = sliderBg.AbsolutePosition
                    local sliderAbsSize = sliderBg.AbsoluteSize
                    
                    local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                    local newValue = min + (max - min) * relativeX
                    updateSlider(newValue)
                    sliding = true
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mouse = Player:GetMouse()
                    local sliderAbsPos = sliderBg.AbsolutePosition
                    local sliderAbsSize = sliderBg.AbsoluteSize
                    
                    local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                    local newValue = min + (max - min) * relativeX
                    updateSlider(newValue)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
            
            -- Set initial value
            updateSlider(default or min)
            
            table.insert(section.elements, sliderFrame)
            return {SetValue = updateSlider, Value = currentValue}
        end
        
        function section:CreateDropdown(name, options, default, callback)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
            dropdownFrame.Position = UDim2.new(0, 10, 0, #section.elements * 35 + 5)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Parent = section.content
            
            section.frame.Size = UDim2.new(1, -10, 0, #section.elements * 35 + 40)
            
            -- Label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.3, 0, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Theme.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = dropdownFrame
            
            -- Dropdown button
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(0.7, 0, 1, 0)
            dropdownBtn.Position = UDim2.new(0.3, 0, 0, 0)
            dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
            dropdownBtn.BackgroundTransparency = 0.5
            dropdownBtn.BorderSizePixel = 0
            dropdownBtn.Text = options[default] or "Select"
            dropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
            dropdownBtn.Font = Enum.Font.Gotham
            dropdownBtn.TextSize = 12
            dropdownBtn.Parent = dropdownFrame
            
            createCorner(dropdownBtn, 6)
            
            -- Dropdown options
            local dropdownOptions = Instance.new("Frame")
            dropdownOptions.Size = UDim2.new(0.7, 0, 0, #options * 30 + 10)
            dropdownOptions.Position = UDim2.new(0.3, 0, 1, 5)
            dropdownOptions.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
            dropdownOptions.BackgroundTransparency = 0
            dropdownOptions.BorderSizePixel = 0
            dropdownOptions.Visible = false
            dropdownOptions.ZIndex = 100
            dropdownOptions.Parent = dropdownFrame
            
            createCorner(dropdownOptions, 8)
            createStroke(dropdownOptions, Theme.Primary, 2)
            
            -- Create options
            for i, option in ipairs(options) do
                local optionBtn = Instance.new("TextButton")
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
                optionBtn.Parent = dropdownOptions
                
                createCorner(optionBtn, 5)
                
                optionBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = option
                    dropdownOptions.Visible = false
                    if callback then
                        callback(option)
                    end
                end)
            end
            
            -- Toggle dropdown
            dropdownBtn.MouseButton1Click:Connect(function()
                dropdownOptions.Visible = not dropdownOptions.Visible
            end)
            
            -- Close dropdown when clicking elsewhere
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if dropdownOptions.Visible then
                        local mousePos = input.Position
                        local dropdownPos = dropdownOptions.AbsolutePosition
                        local dropdownSize = dropdownOptions.AbsoluteSize
                        
                        if not (mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                               mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y) then
                            dropdownOptions.Visible = false
                        end
                    end
                end
            end)
            
            table.insert(section.elements, dropdownFrame)
            return {SetOption = function(option)
                dropdownBtn.Text = option
                if callback then
                    callback(option)
                end
            end}
        end
        
        function section:CreateTextbox(name, placeholder, callback)
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Size = UDim2.new(1, -20, 0, 30)
            textboxFrame.Position = UDim2.new(0, 10, 0, #section.elements * 35 + 5)
            textboxFrame.BackgroundTransparency = 1
            textboxFrame.Parent = section.content
            
            section.frame.Size = UDim2.new(1, -10, 0, #section.elements * 35 + 40)
            
            -- Label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.3, 0, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Theme.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = textboxFrame
            
            -- Textbox
            local textbox = Instance.new("TextBox")
            textbox.Size = UDim2.new(0.7, 0, 1, 0)
            textbox.Position = UDim2.new(0.3, 0, 0, 0)
            textbox.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
            textbox.BackgroundTransparency = 0.6
            textbox.BorderSizePixel = 0
            textbox.Text = ""
            textbox.PlaceholderText = placeholder or "Enter text..."
            textbox.TextColor3 = Color3.fromRGB(220, 220, 240)
            textbox.Font = Enum.Font.Gotham
            textbox.TextSize = 12
            textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
            textbox.Parent = textboxFrame
            
            createCorner(textbox, 6)
            
            -- Focus effects
            textbox.Focused:Connect(function()
                textbox.BackgroundTransparency = 0.4
            end)
            
            textbox.FocusLost:Connect(function()
                textbox.BackgroundTransparency = 0.6
                if callback then
                    callback(textbox.Text)
                end
            end)
            
            table.insert(section.elements, textboxFrame)
            return {SetText = function(newText)
                textbox.Text = newText
                if callback then
                    callback(newText)
                end
            end}
        end
        
        table.insert(window.sections, section)
        return section
    end
    
    function window:ToggleMinimize()
        if self.minimized then
            -- Restore
            self.main.Size = UDim2.fromScale(0.4, 0.75)
            self.contentArea.Visible = true
            self.titleLabel.Text = self.titleLabel.Text
            self.minimized = false
        else
            -- Minimize
            self.main.Size = UDim2.fromScale(0.4, 0.12)
            self.contentArea.Visible = false
            self.titleLabel.Text = "[" .. self.titleLabel.Text .. "]"
            self.minimized = true
        end
    end
    
    function window:Destroy()
        self.gui:Destroy()
    end
    
    function window:Notify(title, message, duration)
        showNotification(title, message, duration)
    end
    
    -- İlk notification
    task.spawn(function()
        task.wait(1)
        showNotification("Welcome", title .. " loaded successfully!", 3)
    end)
    
    return window
end

-- Kütüphane fonksiyonu
function Oxireun:NewWindow(title)
    return self:NewWindow(title)
end

-- Kütüphaneyi dışa aktar
return Oxireun
