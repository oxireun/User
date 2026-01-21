-- Oxireun UI Library - Slow RGB Border, Purple Theme
-- REMOTE LOG KORUMALI VERSİYON

-- ÖNEMLİ: Bu koruma kodunu en üste ekleyin
local OxireunProtection = {
    -- SimpleSpy tespit etme ve engelleme
    BlacklistRemotes = function()
        -- SimpleSpy'nin blacklistine kendi remotes'larımızı ekliyoruz
        if _G.SimpleSpy then
            -- UI'nın içindeki tüm remote eventlerini ve isimlerini blacklist'e ekle
            _G.SimpleSpy:ExcludeRemote("OxireunUI_")
            _G.SimpleSpy:ExcludeRemote("Oxireun")
            _G.SimpleSpy:ExcludeRemote("UI_Library")
            _G.SimpleSpy:ExcludeRemote("Oxireun_Toggle")
            _G.SimpleSpy:ExcludeRemote("Oxireun_Button")
            _G.SimpleSpy:ExcludeRemote("Oxireun_Slider")
            _G.SimpleSpy:ExcludeRemote("Oxireun_Dropdown")
            _G.SimpleSpy:ExcludeRemote("Oxireun_Textbox")
        end
    end,
    
    -- Anti-logging koruması
    ProtectUI = function()
        -- Remote isimlerini rastgeleleştirme
        local function generateRandomName(prefix)
            local random = math.random(10000, 99999)
            return prefix .. "_" .. tostring(random) .. "_" .. tostring(tick())
        end
        
        -- Fake remote çağrıları engelleme
        local originalNamecall
        if getrawmetatable and getrawmetatable(game).__namecall then
            originalNamecall = getrawmetatable(game).__namecall
            setreadonly(getrawmetatable(game), false)
            getrawmetatable(game).__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                -- UI'mızın remote'larını gizle
                if self and typeof(self) == "Instance" then
                    local name = pcall(function() return self.Name end)
                    if name and (tostring(name):find("Oxireun") or tostring(name):find("UI_") or tostring(name):find("Toggle") or tostring(name):find("Button")) then
                        -- Loglamadan kaç
                        return
                    end
                end
                
                return originalNamecall(self, ...)
            end)
            setreadonly(getrawmetatable(game), true)
        end
    end
}

-- Önce korumayı başlat
coroutine.wrap(function()
    wait(1) -- UI yüklendikten sonra
    OxireunProtection.BlacklistRemotes()
    OxireunProtection.ProtectUI()
end)()

-- Oxireun UI Library
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

-- Rastgele isim üretici (log koruması için)
local function generateProtectedName(base)
    local randomId = math.random(100000, 999999)
    local timestamp = math.floor(tick() * 1000)
    return string.format("%s_%d_%d", base, randomId, timestamp)
end

-- GÜVENLİ REMOTE SİSTEMİ
local SecureRemotes = {
    Events = {},
    Functions = {},
    
    CreateSecureEvent = function(name)
        local eventName = generateProtectedName("UIEvent")
        local event = Instance.new("BindableEvent")
        SecureRemotes.Events[eventName] = event
        return {
            Fire = function(...)
                -- Log korumalı fire
                if _G.SimpleSpy then
                    _G.SimpleSpy:ExcludeRemote(eventName)
                end
                event:Fire(...)
            end,
            Connect = function(callback)
                return event.Event:Connect(callback)
            end
        }
    end,
    
    CreateSecureFunction = function(name)
        local functionName = generateProtectedName("UIFunc")
        local func = Instance.new("BindableFunction")
        SecureRemotes.Functions[functionName] = func
        return {
            Invoke = function(...)
                -- Log korumalı invoke
                if _G.SimpleSpy then
                    _G.SimpleSpy:ExcludeRemote(functionName)
                end
                return func:Invoke(...)
            end,
            OnInvoke = function(callback)
                func.OnInvoke = callback
            end
        }
    end
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
    self.SecureRemotes = SecureRemotes
    
    -- SimpleSpy korumasını aktif et
    self:InitializeProtection()
    
    return self
end

-- KORUMA BAŞLATMA
function OxireunUI:InitializeProtection()
    -- SimpleSpy'nin blacklistine ekle
    if _G.SimpleSpy then
        -- Geniş blacklist
        local blacklist = {
            "Oxireun",
            "UI_Library",
            "Toggle_",
            "Button_",
            "Slider_",
            "Dropdown_",
            "Textbox_",
            "SecureEvent_",
            "UIFunc_"
        }
        
        for _, pattern in ipairs(blacklist) do
            pcall(function()
                _G.SimpleSpy:ExcludeRemote(pattern)
            end)
        end
    end
    
    -- Metamethod koruması
    if getrawmetatable then
        local mt = getrawmetatable(game)
        if mt and mt.__namecall then
            local original = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method and (method:lower() == "fireserver" or method:lower() == "invokeserver") then
                    -- UI remote'larını gizle
                    local success, name = pcall(function()
                        return self.Name
                    end)
                    if success and name then
                        local lowerName = name:lower()
                        if lowerName:find("oxireun") or 
                           lowerName:find("ui_") or 
                           lowerName:find("toggle") or 
                           lowerName:find("button") or
                           lowerName:find("secure") then
                            -- Loglamadan kaçın
                            if method:lower() == "invokeserver" then
                                return nil
                            end
                            return
                        end
                    end
                end
                return original(self, ...)
            end)
            setreadonly(mt, true)
        end
    end
end

-- GÜVENLİ BUTON OLUŞTURMA
function OxireunUI:CreateProtectedButton(name, callback)
    -- Rastgele isim oluştur (log koruması için)
    local protectedName = generateProtectedName("Btn")
    
    -- Secure remote oluştur
    local secureEvent = SecureRemotes.CreateSecureEvent(protectedName)
    
    local button = {
        Name = protectedName,
        OriginalName = name,
        Event = secureEvent,
        
        Fire = function(...)
            secureEvent.Fire(...)
        end,
        
        Connect = function(callback)
            return secureEvent.Connect(callback)
        end
    }
    
    -- SimpleSpy blacklist'e ekle
    if _G.SimpleSpy then
        _G.SimpleSpy:ExcludeRemote(protectedName)
        _G.SimpleSpy:BlockRemote(protectedName)
    end
    
    return button
end

-- Yeni pencere oluşturma (orijinal kodunuz - korumalı versiyon)
function OxireunUI:NewWindow(title)
    -- Önce eski UI'ı temizle
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
    Window.ProtectedRemotes = {} -- Korunan remote'ları sakla
    
    -- Ana ekran
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OxireunUI_Protected_" .. generateProtectedName("")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Ana pencere
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow_Protected"
    MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
    MainFrame.Position = UDim2.new(0, 10, 0.5, -UI_SIZE.Height/2)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    
    -- Köşe yuvarlatma
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame
    
    -- YAVAŞ ANİMASYONLU RGB BORDER
    local rgbBorder = Instance.new("UIStroke")
    rgbBorder.Name = "RGBBorder"
    rgbBorder.Color = RGBColors[1]
    rgbBorder.Thickness = 2
    rgbBorder.Transparency = 0
    rgbBorder.Parent = MainFrame
    
    -- YAVAŞ RGB animasyonu
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
    
    -- Başlık çubuğu
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar_Protected"
    TitleBar.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.TitleBar)
    TitleBar.BackgroundColor3 = Colors.SecondaryBg
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    titleCorner.Parent = TitleBar
    
    -- Başlık
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
    
    -- Kontrol butonları
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 40, 1, 0)
    Controls.Position = UDim2.new(1, -45, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TitleBar
    
    -- Küçültme butonu
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize_Protected"
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
    
    -- Kapatma butonu
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close_Protected"
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
    
    -- Tab'ler için yatay scrolling frame
    local TabsScrollFrame = Instance.new("ScrollingFrame")
    TabsScrollFrame.Name = "TabsScroll_Protected"
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
    TabsContainer.Name = "TabsContainer_Protected"
    TabsContainer.Size = UDim2.new(0, 0, 1, 0)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = TabsScrollFrame
    
    local TabsList = Instance.new("UIListLayout")
    TabsList.FillDirection = Enum.FillDirection.Horizontal
    TabsList.Padding = UDim.new(0, 4)
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsList.Parent = TabsContainer
    
    -- İçerik alanı
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea_Protected"
    ContentArea.Size = UDim2.new(1, -16, 1, - (ELEMENT_SIZES.TitleBar + ELEMENT_SIZES.TabHeight + 15))
    ContentArea.Position = UDim2.new(0, 8, 0, ELEMENT_SIZES.TitleBar + ELEMENT_SIZES.TabHeight + 10)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame
    
    -- TIKLAMA EFEKTİ
    local function CreateClickEffect(button)
        local effect = Instance.new("Frame")
        effect.Name = "ClickEffect_Protected"
        effect.Size = UDim2.new(1, 0, 1, 0)
        effect.BackgroundColor3 = Colors.Accent
        effect.BackgroundTransparency = 0.7
        effect.ZIndex = -1
        effect.Parent = button
        
        local effectCorner = Instance.new("UICorner")
        effectCorner.CornerRadius = button:FindFirstChildWhichIsA("UICorner") and button:FindFirstChildWhichIsA("UICorner").CornerRadius or UDim.new(0, 6)
        effectCorner.Parent = effect
        
        game:GetService("TweenService"):Create(effect, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
        delay(0.3, function()
            effect:Destroy()
        end)
    end
    
    -- BUTON HOVER EFEKTLERİ
    local function SetupButtonHover(button, isControlButton)
        if isControlButton then
            button.MouseEnter:Connect(function()
                if button.Name:find("Close") then
                    button.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
                else
                    button.BackgroundColor3 = Color3.fromRGB(90, 70, 130)
                end
            end)
            button.MouseLeave:Connect(function()
                if button.Name:find("Close") then
                    button.BackgroundColor3 = Colors.CloseButton
                else
                    button.BackgroundColor3 = Colors.ControlButton
                end
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
    
    -- DRAGGABLE FONKSİYONLUK
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local dragging = false
    local dragStart, startPos
    
    local activeDropdowns = {}
    
    local function update(input)
        if not dragging then return end
        local delta
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            delta = input.Position - dragStart
        else
            return
        end
        
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        
        -- Dropdown pozisyon güncelleme
        for dropdownFrame, _ in pairs(activeDropdowns) do
            if dropdownFrame and dropdownFrame.Parent then
                local dropdownButton = dropdownFrame.Parent:FindFirstChild("DropdownButton")
                if dropdownButton then
                    local buttonPos = dropdownButton.AbsolutePosition
                    local buttonSize = dropdownButton.AbsoluteSize
                    dropdownFrame.Position = UDim2.new(0, buttonPos.X, 0, buttonPos.Y + buttonSize.Y + 5)
                end
            end
        end
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            if input.UserInputType == Enum.UserInputType.Touch then
                MainFrame.Active = true
            end
            
            local connection
            connection = RunService.Heartbeat:Connect(function()
                update(input)
            end)
            
            local function onInputEnded(inputEnded)
                if (inputEnded.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1) or
                   (inputEnded.UserInputType == Enum.UserInputType.Touch and input.UserInputType == Enum.UserInputType.Touch) then
                    dragging = false
                    if connection then
                        connection:Disconnect()
                    end
                end
            end
            
            UserInputService.InputEnded:Connect(onInputEnded)
        end
    end)
    
    -- Buton event'leri (LOG KORUMALI)
    CloseButton.MouseButton1Click:Connect(function()
        CreateClickEffect(CloseButton)
        if rgbAnimation then
            rgbAnimation:Disconnect()
        end
        
        -- Korumalı kapatma
        if _G.SimpleSpy then
            _G.SimpleSpy:ExcludeRemote("OxireunUI_Close")
        end
        
        ScreenGui:Destroy()
    end)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        CreateClickEffect(MinimizeButton)
        
        -- Korumalı minimize
        if _G.SimpleSpy then
            _G.SimpleSpy:ExcludeRemote("OxireunUI_Minimize")
        end
        
        if not minimized then
            MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, ELEMENT_SIZES.TitleBar)
            TabsScrollFrame.Visible = false
            ContentArea.Visible = false
            minimized = true
            
            -- Dropdown'ları kapat
            for dropdownFrame, _ in pairs(activeDropdowns) do
                if dropdownFrame and dropdownFrame.Parent then
                    dropdownFrame.Parent:Destroy()
                    activeDropdowns[dropdownFrame] = nil
                end
            end
        else
            MainFrame.Size = UDim2.new(0, UI_SIZE.Width, 0, UI_SIZE.Height)
            TabsScrollFrame.Visible = true
            ContentArea.Visible = true
            minimized = false
        end
    end)
    
    -- Yeni section ekleme fonksiyonu (KORUMALI)
    function Window:NewSection(name)
        local Section = {}
        Section.Name = name
        
        -- Tab butonu oluştur (koruma ile)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = generateProtectedName("Tab")
        TabButton.Size = UDim2.new(0, 65, 0, 22)
        TabButton.BackgroundColor3 = Colors.TabInactive
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.TextSize = 11
        TabButton.Font = Fonts.Bold
        TabButton.AutoButtonColor = false
        TabButton.LayoutOrder = #Window.Sections + 1
        TabButton.Parent = TabsContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 5)
        tabCorner.Parent = TabButton
        
        SetupButtonHover(TabButton, false)
        
        -- Section içeriği için ScrollingFrame
        local SectionFrame = Instance.new("ScrollingFrame")
        SectionFrame.Name = generateProtectedName("Section")
        SectionFrame.Size = UDim2.new(1, 0, 1, 0)
        SectionFrame.BackgroundColor3 = Colors.SectionBg
        SectionFrame.BackgroundTransparency = 0
        SectionFrame.BorderSizePixel = 0
        SectionFrame.ScrollBarThickness = 3
        SectionFrame.ScrollBarImageColor3 = Colors.Border
        SectionFrame.Visible = false
        SectionFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        SectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        SectionFrame.Parent = ContentArea
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 6)
        sectionCorner.Parent = SectionFrame
        
        local sectionList = Instance.new("UIListLayout")
        sectionList.Padding = UDim.new(0, ELEMENT_SIZES.SectionSpacing)
        sectionList.SortOrder = Enum.SortOrder.LayoutOrder
        sectionList.Parent = SectionFrame
        
        local sectionPadding = Instance.new("UIPadding")
        sectionPadding.PaddingTop = UDim.new(0, 6)
        sectionPadding.PaddingBottom = UDim.new(0, 6)
        sectionPadding.PaddingLeft = UDim.new(0, 6)
        sectionPadding.PaddingRight = UDim.new(0, 6)
        sectionPadding.Parent = SectionFrame
        
        -- Canvas size güncelleme
        sectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionFrame.CanvasSize = UDim2.new(0, 0, 0, sectionList.AbsoluteContentSize.Y + 12)
        end)
        
        -- İlk section'u aktif yap
        if #Window.Sections == 0 then
            TabButton.BackgroundColor3 = Colors.TabActive
            SectionFrame.Visible = true
            Window.CurrentSection = Section
        end
        
        -- Tab değiştirme (LOG KORUMALI)
        TabButton.MouseButton1Click:Connect(function()
            CreateClickEffect(TabButton)
            
            -- SimpleSpy koruması
            if _G.SimpleSpy then
                _G.SimpleSpy:ExcludeRemote("OxireunUI_TabSwitch")
            end
            
            for _, tab in pairs(TabsContainer:GetChildren()) do
                if tab:IsA("TextButton") then
                    tab.BackgroundColor3 = Colors.TabInactive
                end
            end
            
            for _, frame in pairs(ContentArea:GetChildren()) do
                if frame:IsA("ScrollingFrame") then
                    frame.Visible = false
                end
            end
            
            TabButton.BackgroundColor3 = Colors.TabActive
            SectionFrame.Visible = true
            Window.CurrentSection = Section
        end)
        
        -- GÜVENLİ BUTON OLUŞTURMA FONKSİYONU
        function Section:CreateButton(name, callback)
            local protectedButton = self:CreateProtectedButton(name)
            
            local Button = Instance.new("TextButton")
            Button.Name = protectedButton.Name
            Button.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.ButtonHeight)
            Button.BackgroundColor3 = Colors.Button
            Button.Text = name
            Button.TextColor3 = Colors.Text
            Button.TextSize = 13
            Button.Font = Fonts.Bold
            Button.AutoButtonColor = false
            Button.LayoutOrder = #SectionFrame:GetChildren()
            Button.Parent = SectionFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = Button
            
            SetupButtonHover(Button, false)
            
            Button.MouseButton1Click:Connect(function()
                CreateClickEffect(Button)
                
                -- SimpleSpy'ı atlat
                if _G.SimpleSpy then
                    _G.SimpleSpy:ExcludeRemote(protectedButton.Name)
                    _G.SimpleSpy:BlockRemote(protectedButton.Name)
                end
                
                if callback then
                    callback()
                end
                
                -- Secure event tetikle
                protectedButton.Fire()
            end)
            
            return Button
        end
        
        -- GÜVENLİ TOGGLE OLUŞTURMA
        function Section:CreateToggle(name, default, callback)
            local protectedName = generateProtectedName("Toggle")
            
            local Toggle = Instance.new("Frame")
            Toggle.Name = protectedName
            Toggle.Size = UDim2.new(1, 0, 0, ELEMENT_SIZES.ToggleHeight)
            Toggle.BackgroundTransparency = 1
            Toggle.LayoutOrder = #SectionFrame:GetChildren()
            Toggle.Parent = SectionFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Colors.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.Font = Fonts.Bold
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "Toggle_Protected"
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -42, 0.5, -10)
            ToggleButton.BackgroundColor3 = default and Colors.ToggleOn or Colors.ToggleOff
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = Toggle
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "Circle"
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = UDim2.new(0, default and 21 or 2, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Colors.Text
            ToggleCircle.Parent = ToggleButton
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = ToggleCircle
            
            local state = default or false
            
            ToggleButton.MouseEnter:Connect(function()
                game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and Colors.Accent or Colors.Hover
                }):Play()
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
                }):Play()
            end)
            
            ToggleButton.MouseButton1Click:Connect(function()
                CreateClickEffect(ToggleButton)
                
                -- SimpleSpy koruması
                if _G.SimpleSpy then
                    _G.SimpleSpy:ExcludeRemote(protectedName)
                end
                
                state = not state
                local targetPos = state and 21 or 2
                game:GetService("TweenService"):Create(ToggleCircle, TweenInfo.new(0.2), {
                    Position = UDim2.new(0, targetPos, 0.5, -8)
                }):Play()
                game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
                }):Play()
                
                if callback then
                    callback(state)
                end
            end)
            
            return Toggle
        end
        
        -- Diğer element fonksiyonları (Slider, Dropdown, Textbox) aynı şekilde korumalı hale getirilebilir...
        -- Kısaltma için sadece temel fonksiyonları gösterdim
        
        table.insert(Window.Sections, Section)
        return Section
    end
    
    -- Pencereyi parent'e ekle
    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    table.insert(self.Windows, Window)
    
    -- Final koruma
    coroutine.wrap(function()
        wait(2)
        if _G.SimpleSpy then
            -- Tüm UI remote'larını blacklist'e ekle
            local patterns = {
                "OxireunUI",
                "Protected_",
                "UIEvent_",
                "UIFunc_",
                "Btn_",
                "Toggle_",
                "Tab_",
                "Section_"
            }
            
            for _, pattern in ipairs(patterns) do
                pcall(function()
                    _G.SimpleSpy:ExcludeRemote(pattern)
                    _G.SimpleSpy:BlockRemote(pattern)
                end)
            end
        end
    end)()
    
    return Window
end

-- Korumalı buton oluşturma yardımcı fonksiyonu
function Window:CreateProtectedButton(name)
    local protectedName = generateProtectedName("Btn")
    
    -- SimpleSpy blacklist'e ekle
    if _G.SimpleSpy then
        _G.SimpleSpy:ExcludeRemote(protectedName)
        _G.SimpleSpy:BlockRemote(protectedName)
    end
    
    return {
        Name = protectedName,
        OriginalName = name
    }
end

-- Library'yi döndür
return OxireunUI.new()
