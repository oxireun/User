-- Oxireun UI Library
-- Version: 1.0.0
-- GitHub: https://github.com/Oxireun/oxireun-ui

local Oxireun = {
    Themes = {
        Cyberpunk = {
            Main = Color3.fromRGB(25, 20, 45),
            TopBar = Color3.fromRGB(30, 25, 60),
            Content = Color3.fromRGB(30, 25, 55),
            Section = Color3.fromRGB(35, 30, 65),
            Accent = Color3.fromRGB(0, 150, 255),
            Text = Color3.fromRGB(180, 200, 255),
            TextSecondary = Color3.fromRGB(150, 150, 180)
        },
        Dark = {
            Main = Color3.fromRGB(20, 20, 20),
            TopBar = Color3.fromRGB(30, 30, 30),
            Content = Color3.fromRGB(25, 25, 25),
            Section = Color3.fromRGB(35, 35, 35),
            Accent = Color3.fromRGB(0, 120, 215),
            Text = Color3.fromRGB(220, 220, 220),
            TextSecondary = Color3.fromRGB(170, 170, 170)
        },
        Neon = {
            Main = Color3.fromRGB(10, 10, 30),
            TopBar = Color3.fromRGB(15, 15, 40),
            Content = Color3.fromRGB(20, 20, 35),
            Section = Color3.fromRGB(25, 25, 45),
            Accent = Color3.fromRGB(0, 255, 255),
            Text = Color3.fromRGB(200, 240, 255),
            TextSecondary = Color3.fromRGB(150, 200, 220)
        }
    }
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- YARDIMCI FONKSİYONLAR
local function createElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

local function roundCorners(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
    return corner
end

local function addStroke(object, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = transparency or 0
    stroke.Parent = object
    return stroke
end

-- ANA PENCERE SINIFI
function Oxireun:Window(options)
    options = options or {}
    
    local Window = {
        Name = options.Name or "Oxireun UI",
        Size = options.Size or UDim2.fromScale(0.4, 0.75),
        Position = options.Position or UDim2.fromScale(0.03, 0.1),
        Theme = options.Theme or "Cyberpunk",
        Tabs = {},
        CurrentTab = 1,
        Notifications = {}
    }
    
    -- Temayı yükle
    local theme = Oxireun.Themes[Window.Theme] or Oxireun.Themes.Cyberpunk
    
    -- GUI oluştur
    local gui = Instance.new("ScreenGui")
    gui.Name = Window.Name .. "_GUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if options.Parent then
        gui.Parent = options.Parent
    else
        gui.Parent = game:GetService("CoreGui")
    end
    
    -- ANA ÇERÇEVE
    local main = createElement("Frame", {
        Parent = gui,
        Size = Window.Size,
        Position = Window.Position,
        BackgroundColor3 = theme.Main,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })
    
    roundCorners(main, 12)
    addStroke(main, theme.Accent, 3, 0.2)
    
    -- ÜST BAR
    local topBar = createElement("Frame", {
        Parent = main,
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.TopBar,
        BorderSizePixel = 0
    })
    
    roundCorners(topBar, 12, 0, 0)
    
    local topBarLine = createElement("Frame", {
        Parent = topBar,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0
    })
    
    -- BAŞLIK
    local titleLabel = createElement("TextLabel", {
        Parent = topBar,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = Window.Name,
        TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- KONTROL BUTONLARI
    local controlButtons = createElement("Frame", {
        Parent = topBar,
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -65, 0, 0),
        BackgroundTransparency = 1
    })
    
    -- Minimize butonu
    local minimizeBtn = createElement("TextButton", {
        Parent = controlButtons,
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 0, 0.5, -13),
        BackgroundColor3 = Color3.fromRGB(50, 50, 70),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Text = ""
    })
    roundCorners(minimizeBtn, 6)
    
    local minimizeLine = createElement("Frame", {
        Parent = minimizeBtn,
        Size = UDim2.new(0, 10, 0, 2),
        Position = UDim2.new(0.5, -5, 0.5, -1),
        BackgroundColor3 = Color3.fromRGB(200, 200, 220),
        BorderSizePixel = 0
    })
    
    -- Close butonu
    local closeBtn = createElement("TextButton", {
        Parent = controlButtons,
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 30, 0.5, -13),
        BackgroundColor3 = Color3.fromRGB(70, 40, 50),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Text = ""
    })
    roundCorners(closeBtn, 6)
    
    local closeLine1 = createElement("Frame", {
        Parent = closeBtn,
        Size = UDim2.new(0, 12, 0, 2),
        Position = UDim2.new(0.5, -6, 0.5, -1),
        BackgroundColor3 = Color3.fromRGB(240, 120, 130),
        BorderSizePixel = 0,
        Rotation = 45
    })
    
    local closeLine2 = createElement("Frame", {
        Parent = closeBtn,
        Size = UDim2.new(0, 12, 0, 2),
        Position = UDim2.new(0.5, -6, 0.5, -1),
        BackgroundColor3 = Color3.fromRGB(240, 120, 130),
        BorderSizePixel = 0,
        Rotation = -45
    })
    
    -- TAB CONTAINER
    local tabContainer = createElement("Frame", {
        Parent = main,
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1
    })
    
    -- Aktif tab çizgisi
    local activeTabLine = createElement("Frame", {
        Parent = tabContainer,
        Size = UDim2.new(0.25, -10, 0, 3),
        Position = UDim2.new(0, 5, 1, -3),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0
    })
    roundCorners(activeTabLine, 1, 0)
    
    -- İÇERİK ALANI
    local contentArea = createElement("Frame", {
        Parent = main,
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 90),
        BackgroundColor3 = theme.Content,
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    roundCorners(contentArea, 8)
    
    -- Tab içerik container
    local contentContainer = createElement("Frame", {
        Parent = contentArea,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    })
    
    -- NOTIFICATION CONTAINER
    local notificationContainer = createElement("Frame", {
        Parent = gui,
        Size = UDim2.new(0.25, 0, 0, 70),
        Position = UDim2.new(0.75, 0, 0.75, 0),
        BackgroundColor3 = theme.Section,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 1000
    })
    roundCorners(notificationContainer, 10)
    addStroke(notificationContainer, theme.Accent, 3, 0.3)
    
    local notifTopLine = createElement("Frame", {
        Parent = notificationContainer,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0
    })
    
    local notifIcon = createElement("TextLabel", {
        Parent = notificationContainer,
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "🔔",
        TextColor3 = Color3.fromRGB(255, 200, 100),
        Font = Enum.Font.GothamBold,
        TextSize = 20
    })
    
    local notifTitle = createElement("TextLabel", {
        Parent = notificationContainer,
        Size = UDim2.new(1, -60, 0, 25),
        Position = UDim2.new(0, 50, 0, 10),
        BackgroundTransparency = 1,
        Text = "Notification",
        TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local notifMessage = createElement("TextLabel", {
        Parent = notificationContainer,
        Size = UDim2.new(1, -60, 0, 20),
        Position = UDim2.new(0, 50, 0, 35),
        BackgroundTransparency = 1,
        Text = "System notification",
        TextColor3 = Color3.fromRGB(200, 220, 240),
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- METODLAR
    function Window:Hide()
        main.Visible = false
    end
    
    function Window:Show()
        main.Visible = true
    end
    
    function Window:Destroy()
        gui:Destroy()
    end
    
    function Window:ChangeTheme(newTheme)
        if Oxireun.Themes[newTheme] then
            Window.Theme = newTheme
            local theme = Oxireun.Themes[newTheme]
            
            -- Renkleri güncelle
            main.BackgroundColor3 = theme.Main
            topBar.BackgroundColor3 = theme.TopBar
            contentArea.BackgroundColor3 = theme.Content
            topBarLine.BackgroundColor3 = theme.Accent
            activeTabLine.BackgroundColor3 = theme.Accent
            titleLabel.TextColor3 = theme.Text
            
            local stroke = main:FindFirstChild("UIStroke")
            if stroke then
                stroke.Color = theme.Accent
            end
            
            local notifStroke = notificationContainer:FindFirstChild("UIStroke")
            if notifStroke then
                notifStroke.Color = theme.Accent
            end
            notifTopLine.BackgroundColor3 = theme.Accent
            notificationContainer.BackgroundColor3 = theme.Section
            
            -- Tab'ları güncelle
            for _, tab in pairs(Window.Tabs) do
                if tab.Button then
                    tab.Button.TextColor3 = theme.TextSecondary
                    if tab.Active then
                        tab.Button.TextColor3 = theme.Accent
                    end
                end
            end
        end
    end
    
    function Window:Notification(title, message, duration)
        duration = duration or 2
        notificationContainer.Visible = true
        notifTitle.Text = title
        notifMessage.Text = message
        
        notificationContainer.Position = UDim2.new(0.75, 0, 1, 0)
        
        -- Slide up
        notificationContainer:TweenPosition(
            UDim2.new(0.75, 0, 0.75, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Back,
            0.4,
            true
        )
        
        -- Wait and slide down
        wait(duration)
        
        notificationContainer:TweenPosition(
            UDim2.new(0.75, 0, 1, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        
        wait(0.3)
        notificationContainer.Visible = false
    end
    
    -- BUTON EVENT'LERİ
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            main.Size = UDim2.fromScale(0.4, 0.12)
            contentArea.Visible = false
            tabContainer.Visible = false
            topBarLine.Visible = false
            titleLabel.Text = Window.Name
            topBar.CornerRadius = UDim.new(0, 12)
        else
            main.Size = Window.Size
            contentArea.Visible = true
            tabContainer.Visible = true
            topBarLine.Visible = true
            titleLabel.Text = Window.Name
            topBar.CornerRadius = UDim.new(0, 12, 0, 0)
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Buton hover efektleri
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
    
    -- TAB METODLARI
    function Window:Tab(name)
        local tabIndex = #Window.Tabs + 1
        
        -- Tab butonu oluştur
        local tabButton = createElement("TextButton", {
            Parent = tabContainer,
            Size = UDim2.new(1/#Window.Tabs + 1, -5, 1, 0),
            Position = UDim2.new((tabIndex-1) * (1/#Window.Tabs + 1), 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = theme.TextSecondary,
            Font = Enum.Font.GothamMedium,
            TextSize = 12
        })
        
        -- Tab içeriği frame'i
        local tabFrame = createElement("ScrollingFrame", {
            Parent = contentContainer,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new((tabIndex-1), 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = theme.Accent,
            ScrollBarImageTransparency = 0.7,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Visible = tabIndex == 1
        })
        
        local tabContent = createElement("Frame", {
            Parent = tabFrame,
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1
        })
        
        local Tab = {
            Name = name,
            Button = tabButton,
            Frame = tabFrame,
            Content = tabContent,
            Elements = {},
            Active = tabIndex == 1
        }
        
        -- Tab buton event'leri
        tabButton.MouseEnter:Connect(function()
            if not Tab.Active then
                tabButton.TextColor3 = Color3.fromRGB(200, 220, 255)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if not Tab.Active then
                tabButton.TextColor3 = theme.TextSecondary
            end
        end)
        
        tabButton.MouseButton1Click:Connect(function()
            -- Diğer tab'ları devre dışı bırak
            for i, t in ipairs(Window.Tabs) do
                t.Button.TextColor3 = theme.TextSecondary
                t.Frame.Visible = false
                t.Active = false
            end
            
            -- Bu tab'ı aktif et
            Tab.Active = true
            tabButton.TextColor3 = theme.Accent
            Tab.Frame.Visible = true
            
            -- Aktif tab çizgisini güncelle
            activeTabLine:TweenPosition(
                UDim2.new((tabIndex-1) * (1/#Window.Tabs), 5, 1, -3),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
            
            activeTabLine.Size = UDim2.new(1/#Window.Tabs, -10, 0, 3)
        end)
        
        -- İlk tab'ı ayarla
        if tabIndex == 1 then
            tabButton.TextColor3 = theme.Accent
        end
        
        -- Tab boyutlarını güncelle
        for i, t in ipairs(Window.Tabs) do
            t.Button.Size = UDim2.new(1/#Window.Tabs, -5, 1, 0)
            t.Button.Position = UDim2.new((i-1) * (1/#Window.Tabs), 0, 0, 0)
            t.Frame.Size = UDim2.new(1/#Window.Tabs, 0, 1, 0)
            t.Frame.Position = UDim2.new((i-1) * (1/#Window.Tabs), 0, 0, 0)
        end
        
        -- Tab'ı listeye ekle
        table.insert(Window.Tabs, Tab)
        
        -- ELEMENT METODLARI
        function Tab:Section(name)
            local section = createElement("Frame", {
                Parent = Tab.Content,
                Size = UDim2.new(1, -10, 0, 40),
                Position = UDim2.new(0, 5, 0, #Tab.Elements * 45 + 10),
                BackgroundColor3 = theme.Section,
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0
            })
            roundCorners(section, 8)
            
            local sectionTitle = createElement("TextLabel", {
                Parent = section,
                Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local sectionLine = createElement("Frame", {
                Parent = section,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                Transparency = 0.3
            })
            
            table.insert(Tab.Elements, section)
            
            -- Section için özel container
            local sectionContainer = createElement("Frame", {
                Parent = section,
                Size = UDim2.new(1, 0, 1, -30),
                Position = UDim2.new(0, 0, 0, 30),
                BackgroundTransparency = 1
            })
            
            local Section = {
                Frame = section,
                Container = sectionContainer,
                Elements = {}
            }
            
            -- Section element metodları
            function Section:Button(options)
                options = options or {}
                
                local button = createElement("TextButton", {
                    Parent = Section.Container,
                    Size = UDim2.new(1, -20, 0, 30),
                    Position = UDim2.new(0, 10, 0, #Section.Elements * 35 + 5),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 70),
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Text = options.Text or "Button",
                    TextColor3 = theme.Accent,
                    Font = Enum.Font.Gotham,
                    TextSize = 12
                })
                roundCorners(button, 6)
                
                -- Hover efekti
                button.MouseEnter:Connect(function()
                    button.BackgroundTransparency = 0.3
                end)
                
                button.MouseLeave:Connect(function()
                    button.BackgroundTransparency = 0.5
                end)
                
                -- Click event
                if options.Callback then
                    button.MouseButton1Click:Connect(options.Callback)
                end
                
                table.insert(Section.Elements, button)
                
                -- Section boyutunu güncelle
                local elementCount = #Section.Elements
                Section.Frame.Size = UDim2.new(1, -10, 0, 40 + elementCount * 35)
                
                return {
                    SetText = function(text)
                        button.Text = text
                    end,
                    SetVisible = function(visible)
                        button.Visible = visible
                    end
                }
            end
            
            function Section:Toggle(options)
                options = options or {}
                
                local toggleFrame = createElement("Frame", {
                    Parent = Section.Container,
                    Size = UDim2.new(1, -20, 0, 30),
                    Position = UDim2.new(0, 10, 0, #Section.Elements * 35 + 5),
                    BackgroundTransparency = 1
                })
                
                local toggleLabel = createElement("TextLabel", {
                    Parent = toggleFrame,
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = options.Text or "Toggle:",
                    TextColor3 = theme.Accent,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local toggleBg = createElement("Frame", {
                    Parent = toggleFrame,
                    Size = UDim2.new(0, 45, 0, 24),
                    Position = UDim2.new(1, -50, 0.5, -12),
                    BackgroundColor3 = Color3.fromRGB(180, 180, 190),
                    BorderSizePixel = 0
                })
                roundCorners(toggleBg, 12)
                
                local toggleCircle = createElement("Frame", {
                    Parent = toggleBg,
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                roundCorners(toggleCircle, 10)
                
                local toggleBtn = createElement("TextButton", {
                    Parent = toggleFrame,
                    Size = UDim2.new(0, 45, 0, 24),
                    Position = UDim2.new(1, -50, 0.5, -12),
                    BackgroundTransparency = 1,
                    Text = ""
                })
                
                local state = options.Default or false
                
                if state then
                    toggleBg.BackgroundColor3 = theme.Accent
                    toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                end
                
                toggleBtn.MouseButton1Click:Connect(function()
                    state = not state
                    
                    if state then
                        toggleBg.BackgroundColor3 = theme.Accent
                        toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                    else
                        toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                        toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                    end
                    
                    if options.Callback then
                        options.Callback(state)
                    end
                end)
                
                table.insert(Section.Elements, toggleFrame)
                Section.Frame.Size = UDim2.new(1, -10, 0, 40 + #Section.Elements * 35)
                
                return {
                    SetState = function(newState)
                        state = newState
                        if state then
                            toggleBg.BackgroundColor3 = theme.Accent
                            toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                        else
                            toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                            toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                        end
                    end,
                    GetState = function()
                        return state
                    end
                }
            end
            
            function Section:Slider(options)
                options = options or {}
                
                local min = options.Min or 0
                local max = options.Max or 100
                local default = options.Default or 50
                
                local sliderFrame = createElement("Frame", {
                    Parent = Section.Container,
                    Size = UDim2.new(1, -20, 0, 50),
                    Position = UDim2.new(0, 10, 0, #Section.Elements * 35 + 5),
                    BackgroundTransparency = 1
                })
                
                local sliderLabel = createElement("TextLabel", {
                    Parent = sliderFrame,
                    Size = UDim2.new(0.5, 0, 0, 20),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = options.Text or "Slider:",
                    TextColor3 = theme.Accent,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local valueLabel = createElement("TextLabel", {
                    Parent = sliderFrame,
                    Size = UDim2.new(0.5, 0, 0, 20),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(default),
                    TextColor3 = theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local sliderBg = createElement("Frame", {
                    Parent = sliderFrame,
                    Size = UDim2.new(1, 0, 0, 6),
                    Position = UDim2.new(0, 0, 0, 25),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 75),
                    BorderSizePixel = 0
                })
                roundCorners(sliderBg, 3)
                
                local sliderFill = createElement("Frame", {
                    Parent = sliderBg,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = theme.Accent,
                    BorderSizePixel = 0
                })
                roundCorners(sliderFill, 3)
                
                local sliderHandle = createElement("TextButton", {
                    Parent = sliderBg,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false
                })
                roundCorners(sliderHandle, 8)
                addStroke(sliderHandle, theme.Accent, 2, 0)
                
                local sliding = false
                local currentValue = default
                
                local function updateSlider(value)
                    currentValue = math.clamp(value, min, max)
                    local percent = (currentValue - min) / (max - min)
                    
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
                    valueLabel.Text = tostring(math.floor(currentValue))
                    
                    if options.Callback then
                        options.Callback(currentValue)
                    end
                end
                
                local function startSliding()
                    sliding = true
                    Tab.Frame.ScrollingEnabled = false
                end
                
                local function stopSliding()
                    sliding = false
                    Tab.Frame.ScrollingEnabled = true
                end
                
                sliderHandle.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                       input.UserInputType == Enum.UserInputType.Touch then
                        startSliding()
                    end
                end)
                
                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                       input.UserInputType == Enum.UserInputType.Touch then
                        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                        local absPos = sliderBg.AbsolutePosition
                        local absSize = sliderBg.AbsoluteSize
                        
                        local relativeX = (mouse.X - absPos.X) / absSize.X
                        local newValue = min + (relativeX * (max - min))
                        updateSlider(newValue)
                        startSliding()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                       input.UserInputType == Enum.UserInputType.Touch then
                        stopSliding()
                    end
                end)
                
                RunService.RenderStepped:Connect(function()
                    if sliding then
                        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                        local absPos = sliderBg.AbsolutePosition
                        local absSize = sliderBg.AbsoluteSize
                        
                        local relativeX = (mouse.X - absPos.X) / absSize.X
                        local newValue = min + (relativeX * (max - min))
                        updateSlider(newValue)
                    end
                end)
                
                table.insert(Section.Elements, sliderFrame)
                Section.Frame.Size = UDim2.new(1, -10, 0, 40 + #Section.Elements * 35)
                
                return {
                    SetValue = function(value)
                        updateSlider(value)
                    end,
                    GetValue = function()
                        return currentValue
                    end
                }
            end
            
            function Section:Dropdown(options)
                options = options or {}
                local items = options.Items or {"Option 1", "Option 2", "Option 3"}
                local selected = options.Default or items[1]
                
                local dropdownFrame = createElement("Frame", {
                    Parent = Section.Container,
                    Size = UDim2.new(1, -20, 0, 30),
                    Position = UDim2.new(0, 10, 0, #Section.Elements * 35 + 5),
                    BackgroundTransparency = 1
                })
                
                local dropdownLabel = createElement("TextLabel", {
                    Parent = dropdownFrame,
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = options.Text or "Dropdown:",
                    TextColor3 = theme.Accent,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local dropdownBtn = createElement("TextButton", {
                    Parent = dropdownFrame,
                    Size = UDim2.new(1, -110, 1, 0),
                    Position = UDim2.new(0, 110, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(60, 50, 90),
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Text = selected,
                    TextColor3 = Color3.fromRGB(220, 220, 240),
                    Font = Enum.Font.Gotham,
                    TextSize = 12
                })
                roundCorners(dropdownBtn, 6)
                
                -- Dropdown panel
                local dropdownPanel = createElement("Frame", {
                    Parent = gui,
                    Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, #items * 30 + 10),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = theme.Section,
                    BorderSizePixel = 0,
                    Visible = false,
                    ZIndex = 100
                })
                roundCorners(dropdownPanel, 8)
                addStroke(dropdownPanel, theme.Accent, 2, 0.2)
                
                -- Dropdown items
                for i, item in ipairs(items) do
                    local itemBtn = createElement("TextButton", {
                        Parent = dropdownPanel,
                        Size = UDim2.new(1, -10, 0, 25),
                        Position = UDim2.new(0, 5, 0, (i-1) * 30 + 5),
                        BackgroundColor3 = Color3.fromRGB(55, 45, 85),
                        BackgroundTransparency = 0.5,
                        BorderSizePixel = 0,
                        Text = item,
                        TextColor3 = Color3.fromRGB(220, 220, 240),
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        ZIndex = 101
                    })
                    roundCorners(itemBtn, 5)
                    
                    itemBtn.MouseButton1Click:Connect(function()
                        selected = item
                        dropdownBtn.Text = item
                        dropdownPanel.Visible = false
                        
                        if options.Callback then
                            options.Callback(item)
                        end
                    end)
                    
                    itemBtn.MouseEnter:Connect(function()
                        itemBtn.BackgroundTransparency = 0.3
                    end)
                    
                    itemBtn.MouseLeave:Connect(function()
                        itemBtn.BackgroundTransparency = 0.5
                    end)
                end
                
                dropdownBtn.MouseButton1Click:Connect(function()
                    dropdownPanel.Visible = not dropdownPanel.Visible
                    
                    if dropdownPanel.Visible then
                        local btnPos = dropdownBtn.AbsolutePosition
                        local mainPos = main.AbsolutePosition
                        
                        dropdownPanel.Position = UDim2.new(
                            0, btnPos.X - mainPos.X,
                            0, btnPos.Y - mainPos.Y + dropdownBtn.AbsoluteSize.Y
                        )
                    end
                end)
                
                -- Close dropdown when clicking outside
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mousePos = input.Position
                        local panelPos = dropdownPanel.AbsolutePosition
                        local panelSize = dropdownPanel.AbsoluteSize
                        
                        if dropdownPanel.Visible and
                           not (mousePos.X >= panelPos.X and mousePos.X <= panelPos.X + panelSize.X and
                                mousePos.Y >= panelPos.Y and mousePos.Y <= panelPos.Y + panelSize.Y) then
                            dropdownPanel.Visible = false
                        end
                    end
                end)
                
                table.insert(Section.Elements, dropdownFrame)
                Section.Frame.Size = UDim2.new(1, -10, 0, 40 + #Section.Elements * 35)
                
                return {
                    SetItems = function(newItems)
                        items = newItems
                        -- Rebuild dropdown
                    end,
                    GetSelected = function()
                        return selected
                    end
                }
            end
            
            function Section:Textbox(options)
                options = options or {}
                
                local textboxFrame = createElement("Frame", {
                    Parent = Section.Container,
                    Size = UDim2.new(1, -20, 0, 30),
                    Position = UDim2.new(0, 10, 0, #Section.Elements * 35 + 5),
                    BackgroundTransparency = 1
                })
                
                local textboxLabel = createElement("TextLabel", {
                    Parent = textboxFrame,
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = options.Text or "Textbox:",
                    TextColor3 = theme.Accent,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local textbox = createElement("TextBox", {
                    Parent = textboxFrame,
                    Size = UDim2.new(1, -110, 1, 0),
                    Position = UDim2.new(0, 110, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(45, 40, 75),
                    BackgroundTransparency = 0.6,
                    BorderSizePixel = 0,
                    Text = options.Default or "",
                    PlaceholderText = options.Placeholder or "Enter text...",
                    TextColor3 = Color3.fromRGB(220, 220, 240),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    ClearTextOnFocus = false
                })
                roundCorners(textbox, 6)
                
                textbox.Focused:Connect(function()
                    textbox.BackgroundTransparency = 0.5
                end)
                
                textbox.FocusLost:Connect(function()
                    textbox.BackgroundTransparency = 0.6
                    if options.Callback then
                        options.Callback(textbox.Text)
                    end
                end)
                
                table.insert(Section.Elements, textboxFrame)
                Section.Frame.Size = UDim2.new(1, -10, 0, 40 + #Section.Elements * 35)
                
                return {
                    SetText = function(text)
                        textbox.Text = text
                    end,
                    GetText = function()
                        return textbox.Text
                    end
                }
            end
            
            function Section:Label(text)
                local labelFrame = createElement("Frame", {
                    Parent = Section.Container,
                    Size = UDim2.new(1, -20, 0, 25),
                    Position = UDim2.new(0, 10, 0, #Section.Elements * 35 + 5),
                    BackgroundTransparency = 1
                })
                
                local label = createElement("TextLabel", {
                    Parent = labelFrame,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                table.insert(Section.Elements, labelFrame)
                Section.Frame.Size = UDim2.new(1, -10, 0, 40 + #Section.Elements * 35)
                
                return {
                    SetText = function(newText)
                        label.Text = newText
                    end
                }
            end
            
            return Section
        end
        
        -- Doğrudan element ekleme metodları (section olmadan)
        function Tab:Button(options)
            local section = Tab:Section("")
            return section:Button(options)
        end
        
        function Tab:Toggle(options)
            local section = Tab:Section("")
            return section:Toggle(options)
        end
        
        function Tab:Slider(options)
            local section = Tab:Section("")
            return section:Slider(options)
        end
        
        function Tab:Dropdown(options)
            local section = Tab:Section("")
            return section:Dropdown(options)
        end
        
        function Tab:Textbox(options)
            local section = Tab:Section("")
            return section:Textbox(options)
        end
        
        function Tab:Label(text)
            local section = Tab:Section("")
            return section:Label(text)
        end
        
        return Tab
    end
    
    -- Başlangıç notification
    spawn(function()
        wait(1)
        Window:Notification("Welcome", Window.Name .. " loaded successfully!")
    end)
    
    -- Content boyutunu güncelle
    spawn(function()
        while true do
            wait(0.1)
            local totalHeight = 0
            for _, element in pairs(Window.Tabs[Window.CurrentTab] and Window.Tabs[Window.CurrentTab].Elements or {}) do
                totalHeight = totalHeight + element.AbsoluteSize.Y + 10
            end
            Window.Tabs[Window.CurrentTab].Content.Size = UDim2.new(1, 0, 0, totalHeight + 20)
            Window.Tabs[Window.CurrentTab].Frame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
        end
    end)
    
    return Window
end

return Oxireun
