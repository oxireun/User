-- Oxireun UI Library - Slow RGB Border, Purple Theme (Anti-Remote Logger Version)
local OxireunUI = {}
OxireunUI.__index = OxireunUI

-- [[ ANTI-REMOTE LOGGER CORE ]]
local _FireServer = Instance.new("RemoteEvent").FireServer
local _InvokeServer = Instance.new("RemoteFunction").InvokeServer
local _Namecall = getrawmetatable(game).__namecall

-- Herhangi bir remote işlemini logger'dan gizlemek için güvenli fonksiyon
local function SecureRemoteCall(remote, ...)
    if typeof(remote) == "Instance" then
        if remote:IsA("RemoteEvent") then
            return _FireServer(remote, ...)
        elseif remote:IsA("RemoteFunction") then
            return _InvokeServer(remote, ...)
        end
    end
end

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

-- RGB renkleri
local RGBColors = {
    Color3.fromRGB(180, 50, 220),
    Color3.fromRGB(150, 50, 200),
    Color3.fromRGB(200, 60, 230),
    Color3.fromRGB(170, 40, 210),
    Color3.fromRGB(190, 70, 240),
    Color3.fromRGB(160, 30, 190)
}

local Fonts = {
    Title = Enum.Font.SciFi,
    Normal = Enum.Font.Gotham,
    Tab = Enum.Font.Gotham,
    Button = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold
}

local UI_SIZE = { Width = 260, Height = 280 }
local ELEMENT_SIZES = {
    TitleBar = 30, TabHeight = 25, ButtonHeight = 32, 
    SliderHeight = 45, ToggleHeight = 32, TextboxHeight = 32, 
    DropdownHeight = 32, SectionSpacing = 6
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
    if game.CoreGui:FindFirstChild("OxireunUI") then game.CoreGui:FindFirstChild("OxireunUI"):Destroy() end
    
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
    local rgbAnimation = game:GetService("RunService").Heartbeat:Connect(function()
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
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 8, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "Oxireun UI"
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Fonts.Bold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local Controls = Instance.new("Frame")
    Controls.Size = UDim2.new(0, 40, 1, 0)
    Controls.Position = UDim2.new(1, -45, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 18, 0, 18)
    CloseButton.Position = UDim2.new(0, 22, 0.5, -9)
    CloseButton.BackgroundColor3 = Colors.CloseButton
    CloseButton.Text = ">"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.Font = Fonts.Bold
    CloseButton.Parent = Controls
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

    CloseButton.MouseButton1Click:Connect(function()
        rgbAnimation:Disconnect()
        ScreenGui:Destroy()
    end)

    local TabsScrollFrame = Instance.new("ScrollingFrame")
    TabsScrollFrame.Size = UDim2.new(1, -16, 0, ELEMENT_SIZES.TabHeight)
    TabsScrollFrame.Position = UDim2.new(0, 8, 0, ELEMENT_SIZES.TitleBar + 5)
    TabsScrollFrame.BackgroundTransparency = 1
    TabsScrollFrame.ScrollBarThickness = 0
    TabsScrollFrame.Parent = MainFrame

    local TabsContainer = Instance.new("Frame")
    TabsContainer.Size = UDim2.new(0, 0, 1, 0)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = TabsScrollFrame
    
    local TabsList = Instance.new("UIListLayout")
    TabsList.FillDirection = Enum.FillDirection.Horizontal
    TabsList.Padding = UDim.new(0, 4)
    TabsList.Parent = TabsContainer

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -16, 1, - (ELEMENT_SIZES.TitleBar + ELEMENT_SIZES.TabHeight + 15))
    ContentArea.Position = UDim2.new(0, 8, 0, ELEMENT_SIZES.TitleBar + ELEMENT_SIZES.TabHeight + 10)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame

    local Window = {Sections = {}, CurrentSection = nil}

    function Window:NewSection(name)
        local Section = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 65, 0, 22)
        TabButton.BackgroundColor3 = Colors.TabInactive
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.Font = Fonts.Bold
        TabButton.Parent = TabsContainer
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 5)

        local SectionFrame = Instance.new("ScrollingFrame")
        SectionFrame.Size = UDim2.new(1, 0, 1, 0)
        SectionFrame.BackgroundColor3 = Colors.SectionBg
        SectionFrame.BorderSizePixel = 0
        SectionFrame.Visible = false
        SectionFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        SectionFrame.Parent = ContentArea
        Instance.new("UIListLayout", SectionFrame).Padding = UDim.new(0, ELEMENT_SIZES.SectionSpacing)
        Instance.new("UIPadding", SectionFrame).PaddingTop = UDim.new(0, 6)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentArea:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabsContainer:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Colors.TabInactive end end
            SectionFrame.Visible = true
            TabButton.BackgroundColor3 = Colors.TabActive
        end)

        if #Window.Sections == 0 then
            SectionFrame.Visible = true
            TabButton.BackgroundColor3 = Colors.TabActive
        end

        function Section:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 0, ELEMENT_SIZES.ButtonHeight)
            Button.BackgroundColor3 = Colors.Button
            Button.Text = text
            Button.TextColor3 = Colors.Text
            Button.Font = Fonts.Bold
            Button.Parent = SectionFrame
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)

            Button.MouseButton1Click:Connect(function()
                -- Callback içerisinde bir remote tetiklenirse logger yakalayamaz
                if callback then 
                    local env = getfenv(callback)
                    env.FireServer = SecureRemoteCall
                    env.InvokeServer = SecureRemoteCall
                    setfenv(callback, env)
                    callback() 
                end
            end)
        end

        function Section:CreateToggle(text, default, callback)
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1, -10, 0, ELEMENT_SIZES.ToggleHeight)
            Toggle.BackgroundColor3 = Colors.Button
            Toggle.Text = "  " .. text
            Toggle.TextColor3 = Colors.Text
            Toggle.Font = Fonts.Bold
            Toggle.TextXAlignment = Enum.TextXAlignment.Left
            Toggle.Parent = SectionFrame
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 5)
            
            local state = default or false
            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 14, 0, 14)
            Indicator.Position = UDim2.new(1, -20, 0.5, -7)
            Indicator.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
            Indicator.Parent = Toggle
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Indicator.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
                if callback then 
                    local env = getfenv(callback)
                    env.FireServer = SecureRemoteCall
                    setfenv(callback, env)
                    callback(state) 
                end
            end)
        end

        table.insert(Window.Sections, Section)
        return Section
    end

    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    return Window
end

return OxireunUI.new()
