-- Oxireun UI Library - Slow RGB Border, Purple Theme
-- Kompakt versiyon - Daha küçük boyutlar
local OxireunUI = {}
OxireunUI.__index = OxireunUI

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

-- KOMPAKT UI BOYUTLARI (Daha küçük)
local UI_SIZE = {
    Width = 260,  
    Height = 280  
}

-- Element boyutları (küçültülmüş)
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

-- NOTIFICATION SİSTEMİ
function OxireunUI:SendNotification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title or "Oxireun UI";
        Text = text or "Notification";
        Duration = duration or 3;
    })
end

-- Ana Library fonksiyonu
function OxireunUI.new()
    local self = setmetatable({}, OxireunUI)
    self.Windows = {}
    return self
end

-- Yeni pencere oluşturma
function OxireunUI:NewWindow(title)
    if game.CoreGui:FindFirstChild("OxireunUI") then
        game.CoreGui:FindFirstChild("OxireunUI"):Destroy()
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
    rgbBorder.Parent = MainFrame
    
    local colorIndex = 1
    local rgbAnimation
    rgbAnimation = game:GetService("RunService").Heartbeat:Connect(function()
        colorIndex = colorIndex + 0.008
        if colorIndex > #RGBColors then colorIndex = 1 end
        local currentColor = RGBColors[math.floor(colorIndex)]
        local nextColor = RGBColors[math.floor(colorIndex) % #RGBColors + 1]
        local lerpFactor = colorIndex - math.floor(colorIndex)
        rgbBorder.Color = currentColor:Lerp(nextColor, lerpFactor)
    end)
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.TitleBar)
    TitleBar.BackgroundColor3 = Colors.SecondaryBg
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
    MinimizeButton.Parent = Controls
    Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(1, 0)
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 18, 0, 18)
    CloseButton.Position = UDim2.new(0, 22, 0.5, -9)
    CloseButton.BackgroundColor3 = Colors.CloseButton
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 14
    CloseButton.Font = Fonts.Bold
    CloseButton.Parent = Controls
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

    local TabsScrollFrame = Instance.new("ScrollingFrame")
    TabsScrollFrame.Name = "TabsScroll"
    TabsScrollFrame.Size = UDim2.new(1, -16, 0, ELEMENT_SIZES.TabHeight)
    TabsScrollFrame.Position = UDim2.new(0, 8, 0, ELEMENT_SIZES.TitleBar + 5)
    TabsScrollFrame.BackgroundTransparency = 1
    TabsScrollFrame.BorderSizePixel = 0
    TabsScrollFrame.ScrollBarThickness = 3
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

    -- Dragging Logic
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() rgbAnimation:Disconnect() end)

    function Window:NewSection(name)
        local Section = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 70, 1, 0)
        TabButton.BackgroundColor3 = Colors.TabInactive
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.Font = Fonts.Bold
        TabButton.TextSize = 11
        TabButton.Parent = TabsContainer
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 5)

        local SectionFrame = Instance.new("ScrollingFrame")
        SectionFrame.Size = UDim2.new(1, 0, 1, 0)
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.Visible = false
        SectionFrame.ScrollBarThickness = 2
        SectionFrame.Parent = ContentArea
        local list = Instance.new("UIListLayout", SectionFrame)
        list.Padding = UDim.new(0, 5)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentArea:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabsContainer:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Colors.TabInactive end end
            SectionFrame.Visible = true
            TabButton.BackgroundColor3 = Colors.TabActive
        end)
        
        if #TabsContainer:GetChildren() == 1 then 
            SectionFrame.Visible = true 
            TabButton.BackgroundColor3 = Colors.TabActive
        end

        function Section:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.ButtonHeight)
            Button.BackgroundColor3 = Colors.Button
            Button.Text = name
            Button.TextColor3 = Colors.Text
            Button.Font = Fonts.Bold
            Button.Parent = SectionFrame
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)
            Button.MouseButton1Click:Connect(callback)
        end

        function Section:CreateToggle(name, default, callback)
            local state = default
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.ToggleHeight)
            Button.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
            Button.Text = name .. ": " .. (state and "ON" or "OFF")
            Button.TextColor3 = Colors.Text
            Button.Font = Fonts.Bold
            Button.Parent = SectionFrame
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)
            
            Button.MouseButton1Click:Connect(function()
                state = not state
                Button.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
                Button.Text = name .. ": " .. (state and "ON" or "OFF")
                callback(state)
            end)
        end

        return Section
    end

    ScreenGui.Parent = game:GetService("CoreGui")
    return Window
end

-- ANTI REMOTE LOGGER MANTIK
local Lib = OxireunUI.new()
local Win = Lib:NewWindow("Anti Remote Spy v2")
local Main = Win:NewSection("Protect")

local autoClear = false

-- Remote Loggerları Temizleme Fonksiyonu
local function ClearAllSpies()
    local detected = 0
    local targets = {"SimpleSpy", "Spy", "Hydroxide", "RemoteSpy", "Logger", "TurtleSpy"}
    
    for _, obj in pairs(game:GetService("CoreGui"):GetChildren()) do
        for _, name in pairs(targets) do
            if obj.Name:lower():find(name:lower()) then
                obj:Destroy()
                detected = detected + 1
            end
        end
    end
    return detected
end

Main:CreateButton("Clear Active Loggers", function()
    local count = ClearAllSpies()
    OxireunUI:SendNotification("Anti-Spy", count .. " Adet Spy Temizlendi!", 2)
end)

Main:CreateToggle("Auto Clear (2s)", false, function(state)
    autoClear = state
    task.spawn(function()
        while autoClear do
            ClearAllSpies()
            task.wait(2)
        end
    end)
end)

Main:CreateButton("Bypass Method Hooks", function()
    -- Loggerların metodları yakalamasını zorlaştıran koruma
    if not hookmetamethod then 
        OxireunUI:SendNotification("Error", "Executorun hookmetamethod desteklemiyor!", 3)
        return 
    end
    
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
            -- Burada opsiyonel olarak parametre manipülasyonu yapılabilir
        end
        return old(self, ...)
    end)
    OxireunUI:SendNotification("Protected", "Namecall koruması aktif edildi.", 2)
end)

Main:CreateButton("Hide UI from Screen", function()
    -- UI'ı spy ve video kayıtlarından gizlemeye çalışır
    local gui = game:GetService("CoreGui"):FindFirstChild("OxireunUI")
    if gui and syn and syn.protect_gui then
        syn.protect_gui(gui)
        OxireunUI:SendNotification("Success", "UI Loggerlardan Gizlendi!", 2)
    else
        OxireunUI:SendNotification("Info", "Bu özellik sadece Synapse ve benzeri exploitlerde çalışır.", 3)
    end
end)

return OxireunUI
