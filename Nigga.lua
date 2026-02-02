-- Oxireun UI Library - Slow RGB Border, Purple Theme
-- Anti-Remote Logger & Honey Pot Entegrasyonu
local OxireunUI = {}
OxireunUI.__index = OxireunUI

-- ANTI-REMOTE LOGGER CORE
local function SetupAntiLogger()
    local decoy = game:GetService("ReplicatedStorage"):FindFirstChild("Oxireun_Internal_Remote")
    if not decoy then
        decoy = Instance.new("RemoteEvent")
        decoy.Name = "Oxireun_Secure_Data_Stream" -- İnandırıcı bir isim
        decoy.Parent = game:GetService("ReplicatedStorage")
    end

    -- Fake Remote'u ateşleyen gizli fonksiyon
    local function FireDecoy()
        local randomHashes = {"0x8821", "0xAF12", "0xCC90", "0x112B"}
        decoy:FireServer(
            "SyncSession", 
            tick(), 
            randomHashes[math.random(1, #randomHashes)], 
            math.random(100000, 999999)
        )
    end
    return FireDecoy
end

local TriggerFakeRemote = SetupAntiLogger()

-- Mor temalı renk paleti
local Colors = {
    Background = Color3.fromRGB(30, 20, 50),
    SecondaryBg = Color3.fromRGB(40, 30, 70),
    SectionBg = Color3.fromRGB(35, 25, 65),
    Border = Color3.fromRGB(150, 50, 200),
    Accent = Color3.fromRGB(180, 70, 220),
    Text = Color3.fromRGB(255, 255, 255),
    Disabled = Color3.fromRGB(120, 100, 160),
    Hover = Color3.fromRGB(150, 50, 200, 0.3),
    Button = Color3.fromRGB(60, 40, 100),
    Slider = Color3.fromRGB(150, 50, 200),
    ToggleOn = Color3.fromRGB(150, 50, 200),
    ToggleOff = Color3.fromRGB(80, 60, 120),
    TabActive = Color3.fromRGB(150, 50, 200),
    TabInactive = Color3.fromRGB(60, 40, 100),
    ControlButton = Color3.fromRGB(70, 50, 110),
    CloseButton = Color3.fromRGB(180, 60, 60)
}

-- RGB renkleri (YAVAŞ animasyon için)
local RGBColors = {
    Color3.fromRGB(180, 50, 220),
    Color3.fromRGB(150, 50, 200),
    Color3.fromRGB(200, 60, 230),
    Color3.fromRGB(170, 40, 210),
    Color3.fromRGB(190, 70, 240),
    Color3.fromRGB(160, 30, 190)
}

-- Font ayarları
local Fonts = {
    Title = Enum.Font.SciFi,
    Normal = Enum.Font.Gotham,
    Tab = Enum.Font.Gotham,
    Button = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold
}

-- KOMPAKT UI BOYUTLARI
local UI_SIZE = {
    Width = 260,
    Height = 280
}

-- Element boyutları
local ELEMENT_SIZES = {
    TitleBar = 30,
    TabHeight = 25,
    ButtonHeight = 32,
    SliderHeight = 45,
    ToggleHeight = 32,
    TextboxHeight = 32,
    DropdownHeight = 32,
    SectionSpacing = 6
}

function OxireunUI:SendNotification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title or "Oxireun UI";
        Text = text or "Notification";
        Duration = duration or 3;
    })
end

function OxireunUI.new()
    local self = setmetatable({}, OxireunUI)
    self.Windows = {}
    return self
end

function OxireunUI:NewWindow(title)
    if game.CoreGui:FindFirstChild("OxireunUI") then
        game.CoreGui:FindFirstChild("OxireunUI"):Destroy()
    end
    
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("OxireunUI") then
        game.Players.LocalPlayer.PlayerGui:FindFirstChild("OxireunUI"):Destroy()
    end
    
    local Window = {}
    Window.Title = title or "Oxireun UI"
    Window.Sections = {}
    Window.CurrentSection = nil
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OxireunUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
    MainFrame.Position = UDim2.new(0, 10, 0.5, -UI_SIZE.Height/2)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame
    
    local rgbBorder = Instance.new("UIStroke")
    rgbBorder.Name = "RGBBorder"
    rgbBorder.Color = RGBColors[1]
    rgbBorder.Thickness = 2
    rgbBorder.Transparency = 0
    rgbBorder.Parent = MainFrame
    
    local colorIndex = 1
    local rgbAnimation
    rgbAnimation = game:GetService("RunService").Heartbeat:Connect(function()
        colorIndex = colorIndex + 0.008
        if colorIndex > #RGBColors then
            colorIndex = 1
        end
        local currentColor = RGBColors[math.floor(colorIndex)]
        local nextColor = RGBColors[math.floor(colorIndex) % #RGBColors + 1]
        local lerpFactor = colorIndex - math.floor(colorIndex)
        rgbBorder.Color = currentColor:Lerp(nextColor, lerpFactor)
    end)
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.TitleBar)
    TitleBar.BackgroundColor3 = Colors.SecondaryBg
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    titleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 8, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Window.Title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Fonts.Bold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 40, 1, 0)
    Controls.Position = UDim2.new(1, -45, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 18, 0, 18)
    MinimizeButton.Position = UDim2.new(0, 0, 0.5, -9)
    MinimizeButton.BackgroundColor3 = Colors.ControlButton
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Fonts.Bold
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = Controls
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(1, 0)
    minimizeCorner.Parent = MinimizeButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 18, 0, 18)
    CloseButton.Position = UDim2.new(0, 22, 0.5, -9)
    CloseButton.BackgroundColor3 = Colors.CloseButton
    CloseButton.Text = ">"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 14
    CloseButton.Font = Fonts.Bold
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Controls
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = CloseButton
    
    local TabsScrollFrame = Instance.new("ScrollingFrame")
    TabsScrollFrame.Name = "TabsScroll"
    TabsScrollFrame.Size = UDim2.new(1, -16, 0, ELEMENT_SIZES.TabHeight)
    TabsScrollFrame.Position = UDim2.new(0, 8, 0, ELEMENT_SIZES.TitleBar + 5)
    TabsScrollFrame.BackgroundTransparency = 1
    TabsScrollFrame.BorderSizePixel = 0
    TabsScrollFrame.ScrollBarThickness = 3
    TabsScrollFrame.ScrollBarImageColor3 = Colors.Border
    TabsScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabsScrollFrame.ScrollingDirection = Enum.ScrollingDirection.X
    TabsScrollFrame.Parent = MainFrame
    
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(0, 0, 1, 0)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = TabsScrollFrame
    
    local TabsList = Instance.new("UIListLayout")
    TabsList.FillDirection = Enum.FillDirection.Horizontal
    TabsList.Padding = UDim.new(0, 4)
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsList.Parent = TabsContainer
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -16, 1, - (ELEMENT_SIZES.TitleBar + ELEMENT_SIZES.TabHeight + 15))
    ContentArea.Position = UDim2.new(0, 8, 0, ELEMENT_SIZES.TitleBar + ELEMENT_SIZES.TabHeight + 10)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame
    
    local function CreateClickEffect(button)
        local effect = Instance.new("Frame")
        effect.Name = "ClickEffect"
        effect.Size = UDim2.new(1, 0, 1, 0)
        effect.BackgroundColor3 = Colors.Accent
        effect.BackgroundTransparency = 0.7
        effect.ZIndex = -1
        effect.Parent = button
        local effectCorner = Instance.new("UICorner")
        effectCorner.CornerRadius = button:FindFirstChildWhichIsA("UICorner") and button:FindFirstChildWhichIsA("UICorner").CornerRadius or UDim.new(0, 6)
        effectCorner.Parent = effect
        game:GetService("TweenService"):Create(effect, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
        delay(0.3, function() effect:Destroy() end)
    end
    
    local function SetupButtonHover(button, isControlButton)
        if isControlButton then
            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = (button.Name == "Close") and Color3.fromRGB(200, 80, 80) or Color3.fromRGB(90, 70, 130)
            end)
            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = (button.Name == "Close") and Colors.CloseButton or Colors.ControlButton
            end)
            return
        end
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Colors.Border }):Play()
        end)
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Colors.Button }):Play()
        end)
    end
    
    SetupButtonHover(CloseButton, true)
    SetupButtonHover(MinimizeButton, true)
    
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local dragging, dragStart, startPos = false, nil, nil
    local activeDropdowns = {}
    
    local function update(input)
        if not dragging then return end
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            local connection
            connection = RunService.Heartbeat:Connect(function() update(input) end)
            UserInputService.InputEnded:Connect(function(inputEnded)
                if inputEnded.UserInputType == input.UserInputType then
                    dragging = false
                    if connection then connection:Disconnect() end
                end
            end)
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        TriggerFakeRemote() -- Anti-Logger Trigger
        CreateClickEffect(CloseButton)
        if rgbAnimation then rgbAnimation:Disconnect() end
        ScreenGui:Destroy()
    end)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        TriggerFakeRemote() -- Anti-Logger Trigger
        CreateClickEffect(MinimizeButton)
        if not minimized then
            MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, ELEMENT_SIZES.TitleBar)
            TabsScrollFrame.Visible, ContentArea.Visible, minimized = false, false, true
        else
            MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
            TabsScrollFrame.Visible, ContentArea.Visible, minimized = true, true, false
        end
    end)
    
    function Window:NewSection(name)
        local Section = {}
        Section.Name = name
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "_Tab"
        TabButton.Size = UDim2.new(0, 65, 0, 22)
        TabButton.BackgroundColor3 = Colors.TabInactive
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.TextSize = 11
        TabButton.Font = Fonts.Bold
        TabButton.AutoButtonColor = false
        TabButton.LayoutOrder = #Window.Sections + 1
        TabButton.Parent = TabsContainer
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 5)
        SetupButtonHover(TabButton, false)
        
        local SectionFrame = Instance.new("ScrollingFrame")
        SectionFrame.Name = name .. "_Content"
        SectionFrame.Size = UDim2.new(1, 0, 1, 0)
        SectionFrame.BackgroundColor3 = Colors.SectionBg
        SectionFrame.BorderSizePixel, SectionFrame.ScrollBarThickness = 0, 3
        SectionFrame.ScrollBarImageColor3 = Colors.Border
        SectionFrame.Visible, SectionFrame.AutomaticCanvasSize = false, Enum.AutomaticSize.Y
        SectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        SectionFrame.Parent = ContentArea
        Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 6)
        
        local sectionList = Instance.new("UIListLayout", SectionFrame)
        sectionList.Padding, sectionList.SortOrder = UDim.new(0, ELEMENT_SIZES.SectionSpacing), Enum.SortOrder.LayoutOrder
        
        local sectionPadding = Instance.new("UIPadding", SectionFrame)
        sectionPadding.PaddingTop, sectionPadding.PaddingBottom, sectionPadding.PaddingLeft, sectionPadding.PaddingRight = UDim.new(0, 6), UDim.new(0, 6), UDim.new(0, 6), UDim.new(0, 6)
        
        sectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionFrame.CanvasSize = UDim2.new(0, 0, 0, sectionList.AbsoluteContentSize.Y + 12)
        end)
        
        if #Window.Sections == 0 then
            TabButton.BackgroundColor3, SectionFrame.Visible = Colors.TabActive, true
            Window.CurrentSection = Section
        end
        
        TabButton.MouseButton1Click:Connect(function()
            TriggerFakeRemote() -- Anti-Logger Trigger
            CreateClickEffect(TabButton)
            for _, tab in pairs(TabsContainer:GetChildren()) do if tab:IsA("TextButton") then tab.BackgroundColor3 = Colors.TabInactive end end
            for _, frame in pairs(ContentArea:GetChildren()) do if frame:IsA("ScrollingFrame") then frame.Visible = false end end
            TabButton.BackgroundColor3, SectionFrame.Visible = Colors.TabActive, true
            Window.CurrentSection = Section
        end)
        
        function Section:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.ButtonHeight)
            Button.BackgroundColor3, Button.Text, Button.TextColor3, Button.TextSize, Button.Font = Colors.Button, name, Colors.Text, 13, Fonts.Bold
            Button.AutoButtonColor, Button.LayoutOrder = false, #SectionFrame:GetChildren()
            Button.Parent = SectionFrame
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)
            SetupButtonHover(Button, false)
            
            Button.MouseButton1Click:Connect(function()
                TriggerFakeRemote() -- Fake Remote Fire!
                CreateClickEffect(Button)
                if callback then callback() end
            end)
            return Button
        end
        
        function Section:CreateToggle(name, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.ToggleHeight)
            Toggle.BackgroundTransparency, Toggle.LayoutOrder = 1, #SectionFrame:GetChildren()
            Toggle.Parent = SectionFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size, ToggleLabel.BackgroundTransparency, ToggleLabel.Text, ToggleLabel.TextColor3, ToggleLabel.TextSize, ToggleLabel.Font, ToggleLabel.TextXAlignment = UDim2.new(0.7, 0, 1, 0), 1, name, Colors.Text, 13, Fonts.Bold, Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size, ToggleButton.Position, ToggleButton.BackgroundColor3, ToggleButton.Text, ToggleButton.AutoButtonColor = UDim2.new(0, 40, 0, 20), UDim2.new(1, -42, 0.5, -10), default and Colors.ToggleOn or Colors.ToggleOff, "", false
            ToggleButton.Parent = Toggle
            Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size, ToggleCircle.Position, ToggleCircle.BackgroundColor3 = UDim2.new(0, 16, 0, 16), UDim2.new(0, default and 21 or 2, 0.5, -8), Colors.Text
            ToggleCircle.Parent = ToggleButton
            Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)
            
            local state = default or false
            ToggleButton.MouseButton1Click:Connect(function()
                TriggerFakeRemote() -- Fake Remote Fire!
                CreateClickEffect(ToggleButton)
                state = not state
                game:GetService("TweenService"):Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, state and 21 or 2, 0.5, -8)}):Play()
                game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff}):Play()
                if callback then callback(state) end
            end)
            return Toggle
        end
        
        function Section:CreateSlider(name, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Size, Slider.BackgroundTransparency, Slider.LayoutOrder = UDim2.new(1, 0, 0, ELEMENT_SIZES.SliderHeight), 1, #SectionFrame:GetChildren()
            Slider.Parent = SectionFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size, SliderLabel.BackgroundTransparency, SliderLabel.Text, SliderLabel.TextColor3, SliderLabel.TextSize, SliderLabel.Font, SliderLabel.TextXAlignment = UDim2.new(1, 0, 0, 18), 1, name .. ": " .. default, Colors.Text, 13, Fonts.Bold, Enum.TextXAlignment.Left
            SliderLabel.Parent = Slider
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Size, SliderTrack.Position, SliderTrack.BackgroundColor3 = UDim2.new(0, 230, 0, 4), UDim2.new(0, 0, 0, 22), Colors.ToggleOff
            SliderTrack.Parent = Slider
            Instance.new("UICorner", SliderTrack).CornerRadius = UDim.new(1, 0)
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size, SliderFill.BackgroundColor3 = UDim2.new((default - min) / (max - min), 0, 1, 0), Colors.Slider
            SliderFill.Parent = SliderTrack
            Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size, SliderButton.Position, SliderButton.BackgroundColor3, SliderButton.Text, SliderButton.AutoButtonColor = UDim2.new(0, 16, 0, 16), UDim2.new(SliderFill.Size.X.Scale, -8, 0.5, -8), Colors.Text, "", false
            SliderButton.Parent = SliderTrack
            Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(1, 0)
            
            local draggingSlider = false
            local function move(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1), -8, 0.5, -8)
                SliderButton.Position = pos
                SliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
                local value = math.floor(min + (pos.X.Scale * (max - min)))
                SliderLabel.Text = name .. ": " .. value
                if callback then callback(value) end
            end
            
            SliderButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end end)
            UserInputService.InputChanged:Connect(function(input) 
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement) then 
                    move(input)
                    TriggerFakeRemote() -- Spam önleyici ile logger'ı boğ
                end 
            end)
            return Slider
        end

        function Section:CreateDropdown(name, options, default, callback)
            local Dropdown = Instance.new("Frame")
            Dropdown.Size, Dropdown.BackgroundTransparency, Dropdown.LayoutOrder = UDim2.new(1, 0, 0, ELEMENT_SIZES.DropdownHeight), 1, #SectionFrame:GetChildren()
            Dropdown.Parent = SectionFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size, DropdownButton.BackgroundColor3, DropdownButton.Text, DropdownButton.TextColor3, DropdownButton.TextSize, DropdownButton.Font, DropdownButton.AutoButtonColor = UDim2.new(1, 0, 0, ELEMENT_SIZES.DropdownHeight), Colors.Button, options[default] or "Select", Colors.Text, 13, Fonts.Bold, false
            DropdownButton.Parent = Dropdown
            Instance.new("UICorner", DropdownButton).CornerRadius = UDim.new(0, 5)
            
            DropdownButton.MouseButton1Click:Connect(function()
                TriggerFakeRemote() -- Fake Remote Fire!
                CreateClickEffect(DropdownButton)
                -- Dropdown mantığı (Kısaltılmış/Orijinal)
            end)
            return Dropdown
        end

        function Section:CreateTextbox(name, callback)
            local Textbox = Instance.new("Frame")
            Textbox.Size, Textbox.BackgroundTransparency, Textbox.LayoutOrder = UDim2.new(1, 0, 0, ELEMENT_SIZES.TextboxHeight), 1, #SectionFrame:GetChildren()
            Textbox.Parent = SectionFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size, InputBox.BackgroundColor3, InputBox.Text, InputBox.PlaceholderText, InputBox.TextColor3, InputBox.TextSize, InputBox.Font = UDim2.new(1, 0, 1, 0), Colors.Button, "", name, Colors.Text, 13, Fonts.Bold
            InputBox.Parent = Textbox
            Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 5)
            
            InputBox.FocusLost:Connect(function()
                TriggerFakeRemote() -- Fake Remote Fire!
                if callback then callback(InputBox.Text) end
            end)
            return Textbox
        end

        table.insert(Window.Sections, Section)
        return Section
    end
    
    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    table.insert(self.Windows, Window)
    return Window
end

return OxireunUI.new()
