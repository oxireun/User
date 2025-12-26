-- FightClub UI Library v1.0
-- GitHub: https://github.com/username/fightclub-ui
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/username/fightclub-ui/main/library.lua"))()

local FightClubUI = {}
FightClubUI.__index = FightClubUI

-- Tema renkleri (FightClub tarzı)
local Theme = {
    Background = Color3.fromRGB(18, 18, 18),     -- Koyu arkaplan
    Secondary = Color3.fromRGB(30, 30, 30),      -- İkincil renk
    Accent = Color3.fromRGB(220, 20, 60),        -- Kırmızı vurgu (FightClub teması)
    Text = Color3.fromRGB(240, 240, 240),        -- Açık metin
    SubText = Color3.fromRGB(180, 180, 180),     -- Alt metin
    ToggleOn = Color3.fromRGB(52, 199, 89),      -- iPhone yeşili (açık)
    ToggleOff = Color3.fromRGB(120, 120, 125),   -- iPhone gri (kapalı)
    Border = Color3.fromRGB(50, 50, 50),         -- Kenarlık
    Success = Color3.fromRGB(52, 199, 89),       -- Başarı
    Warning = Color3.fromRGB(255, 149, 0),       -- Uyarı
    Error = Color3.fromRGB(255, 59, 48),         -- Hata
}

-- Servisler
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Yardımcı fonksiyonlar
local function Create(class, props)
    local obj = Instance.new(class)
    for prop, value in pairs(props) do
        if prop == "Parent" then
            obj.Parent = value
        else
            obj[prop] = value
        end
    end
    return obj
end

-- Rounded corner fonksiyonu
local function ApplyRoundCorners(obj, radius)
    local corner = Create("UICorner", {
        CornerRadius = UDim.new(radius, 0),
        Parent = obj
    })
    return corner
end

-- Gradient oluşturma
local function CreateGradient(color1, color2)
    local gradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(1, color2)
        }),
        Rotation = 90
    })
    return gradient
end

-- Ana pencere oluşturma
function FightClubUI:CreateWindow(options)
    options = options or {}
    local window = {
        Tabs = {},
        CurrentTab = nil,
        Open = false,
        Minimized = false
    }
    
    -- Ana ekran
    local screenGui = Create("ScreenGui", {
        Name = "FightClubUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Ana çerçeve
    local mainFrame = Create("Frame", {
        Parent = screenGui,
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    ApplyRoundCorners(mainFrame, 0.08)
    
    -- Gölge efekti
    local shadow = Create("ImageLabel", {
        Parent = mainFrame,
        Name = "Shadow",
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        BackgroundTransparency = 1,
        ZIndex = 0
    })
    
    -- Başlık çubuğu
    local titleBar = Create("Frame", {
        Parent = mainFrame,
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0
    })
    ApplyRoundCorners(titleBar, 0.08)
    
    local title = Create("TextLabel", {
        Parent = titleBar,
        Name = "Title",
        Text = options.Title or "FIGHT CLUB",
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0.02, 0, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Theme.Accent,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Kontrol butonları
    local closeBtn = Create("TextButton", {
        Parent = titleBar,
        Name = "CloseButton",
        Text = "✕",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0.95, -30, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(255, 59, 48),
        TextColor3 = Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold
    })
    ApplyRoundCorners(closeBtn, 0.5)
    
    local minimizeBtn = Create("TextButton", {
        Parent = titleBar,
        Name = "MinimizeButton",
        Text = "─",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0.95, -65, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(255, 149, 0),
        TextColor3 = Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold
    })
    ApplyRoundCorners(minimizeBtn, 0.5)
    
    -- Tab container
    local tabContainer = Create("Frame", {
        Parent = mainFrame,
        Name = "TabContainer",
        Size = UDim2.new(0, 120, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0
    })
    
    local tabList = Create("ScrollingFrame", {
        Parent = tabContainer,
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, -10),
        Position = UDim2.new(0, 0, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent
    })
    
    local tabListLayout = Create("UIListLayout", {
        Parent = tabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    -- Content area
    local contentArea = Create("Frame", {
        Parent = mainFrame,
        Name = "ContentArea",
        Size = UDim2.new(1, -120, 1, -40),
        Position = UDim2.new(0, 120, 0, 40),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    
    local contentContainer = Create("ScrollingFrame", {
        Parent = contentArea,
        Name = "ContentContainer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local contentLayout = Create("UIListLayout", {
        Parent = contentContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 15)
    })
    
    local contentPadding = Create("UIPadding", {
        Parent = contentContainer,
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        PaddingTop = UDim.new(0, 15),
        PaddingBottom = UDim.new(0, 15)
    })
    
    -- Animasyonlar
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        window.Minimized = not window.Minimized
        if window.Minimized then
            mainFrame:TweenSize(UDim2.new(0, 500, 0, 40), "Out", "Quad", 0.3, true)
        else
            mainFrame:TweenSize(UDim2.new(0, 500, 0, 400), "Out", "Quad", 0.3, true)
        end
    end)
    
    -- Sürükleme fonksiyonu
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Tab oluşturma fonksiyonu
    function window:CreateTab(name, icon)
        local tab = {
            Name = name,
            Elements = {},
            Container = nil
        }
        
        -- Tab butonu
        local tabButton = Create("TextButton", {
            Parent = tabList,
            Name = name .. "Tab",
            Size = UDim2.new(1, -10, 0, 40),
            BackgroundColor3 = Theme.Background,
            Text = "  " .. name,
            TextColor3 = Theme.SubText,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        })
        ApplyRoundCorners(tabButton, 0.08)
        
        -- Tab içeriği
        local tabContent = Create("ScrollingFrame", {
            Parent = contentContainer,
            Name = name .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 0,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        
        local tabContentLayout = Create("UIListLayout", {
            Parent = tabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 15)
        })
        
        local tabContentPadding = Create("UIPadding", {
            Parent = tabContent,
            PaddingLeft = UDim.new(0, 0),
            PaddingRight = UDim.new(0, 0),
            PaddingTop = UDim.new(0, 0),
            PaddingBottom = UDim.new(0, 0)
        })
        
        tabButton.MouseButton1Click:Connect(function()
            if window.CurrentTab then
                window.CurrentTab.Button.BackgroundColor3 = Theme.Background
                window.CurrentTab.Button.TextColor3 = Theme.SubText
                window.CurrentTab.Content.Visible = false
            end
            
            tabButton.BackgroundColor3 = Theme.Accent
            tabButton.TextColor3 = Theme.Text
            tabContent.Visible = true
            
            window.CurrentTab = {
                Button = tabButton,
                Content = tabContent
            }
        end)
        
        -- İlk tab'ı aktif yap
        if #window.Tabs == 0 then
            tabButton.BackgroundColor3 = Theme.Accent
            tabButton.TextColor3 = Theme.Text
            tabContent.Visible = true
            window.CurrentTab = {
                Button = tabButton,
                Content = tabContent
            }
        end
        
        table.insert(window.Tabs, tab)
        
        -- Element oluşturma fonksiyonları
        function tab:CreateSection(title)
            local section = {}
            
            local sectionFrame = Create("Frame", {
                Parent = tabContent,
                Name = title .. "Section",
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
                ClipsDescendants = true
            })
            ApplyRoundCorners(sectionFrame, 0.08)
            
            local sectionTitle = Create("TextLabel", {
                Parent = sectionFrame,
                Name = "Title",
                Text = "  " .. string.upper(title),
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                TextColor3 = Theme.Accent,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local sectionContent = Create("Frame", {
                Parent = sectionFrame,
                Name = "Content",
                Size = UDim2.new(1, 0, 1, -35),
                Position = UDim2.new(0, 0, 0, 35),
                BackgroundTransparency = 1,
                BorderSizePixel = 0
            })
            
            local sectionLayout = Create("UIListLayout", {
                Parent = sectionContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10)
            })
            
            local sectionPadding = Create("UIPadding", {
                Parent = sectionContent,
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 15)
            })
            
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionFrame.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 50)
            end)
            
            section.Container = sectionContent
            
            -- Section element fonksiyonları
            function section:CreateLabel(text)
                local label = Create("TextLabel", {
                    Parent = sectionContent,
                    Text = text,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true
                })
                
                return label
            end
            
            function section:CreateButton(text, callback)
                local button = Create("TextButton", {
                    Parent = sectionContent,
                    Text = text,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = Theme.Background,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false
                })
                ApplyRoundCorners(button, 0.08)
                
                local buttonStroke = Create("UIStroke", {
                    Parent = button,
                    Color = Theme.Border,
                    Thickness = 1
                })
                
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    }):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Theme.Background
                    }):Play()
                end)
                
                button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                    
                    -- Animasyon efekti
                    TweenService:Create(button, TweenInfo.new(0.1), {
                        BackgroundColor3 = Theme.Accent
                    }):Play()
                    
                    wait(0.1)
                    
                    TweenService:Create(button, TweenInfo.new(0.1), {
                        BackgroundColor3 = Theme.Background
                    }):Play()
                end)
                
                return button
            end
            
            function section:CreateToggle(text, default, callback)
                local toggle = {
                    Value = default or false
                }
                
                local toggleFrame = Create("Frame", {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1
                })
                
                local label = Create("TextLabel", {
                    Parent = toggleFrame,
                    Text = text,
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                -- iPhone tarzı toggle
                local toggleContainer = Create("Frame", {
                    Parent = toggleFrame,
                    Size = UDim2.new(0, 50, 0, 25),
                    Position = UDim2.new(1, -50, 0.5, -12.5),
                    BackgroundColor3 = toggle.Value and Theme.ToggleOn or Theme.ToggleOff,
                    BorderSizePixel = 0
                })
                ApplyRoundCorners(toggleContainer, 0.5)
                
                local toggleCircle = Create("Frame", {
                    Parent = toggleContainer,
                    Size = UDim2.new(0, 21, 0, 21),
                    Position = UDim2.new(0, 2, 0.5, -10.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                ApplyRoundCorners(toggleCircle, 0.5)
                
                if toggle.Value then
                    toggleCircle.Position = UDim2.new(1, -23, 0.5, -10.5)
                end
                
                local function updateToggle()
                    TweenService:Create(toggleContainer, TweenInfo.new(0.2), {
                        BackgroundColor3 = toggle.Value and Theme.ToggleOn or Theme.ToggleOff
                    }):Play()
                    
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                        Position = toggle.Value and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
                    }):Play()
                    
                    if callback then
                        callback(toggle.Value)
                    end
                end
                
                toggleContainer.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        toggle.Value = not toggle.Value
                        updateToggle()
                    end
                end)
                
                toggle.Set = function(self, value)
                    toggle.Value = value
                    updateToggle()
                end
                
                toggle.Get = function(self)
                    return toggle.Value
                end
                
                return toggle
            end
            
            function section:CreateSlider(text, min, max, default, callback)
                local slider = {
                    Value = default or min,
                    Min = min,
                    Max = max
                }
                
                local sliderFrame = Create("Frame", {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 60),
                    BackgroundTransparency = 1
                })
                
                local label = Create("TextLabel", {
                    Parent = sliderFrame,
                    Text = text,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local valueLabel = Create("TextLabel", {
                    Parent = sliderFrame,
                    Text = tostring(default or min),
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -50, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.SubText,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local sliderTrack = Create("Frame", {
                    Parent = sliderFrame,
                    Size = UDim2.new(1, 0, 0, 5),
                    Position = UDim2.new(0, 0, 0, 30),
                    BackgroundColor3 = Theme.Secondary,
                    BorderSizePixel = 0
                })
                ApplyRoundCorners(sliderTrack, 0.5)
                
                local sliderFill = Create("Frame", {
                    Parent = sliderTrack,
                    Size = UDim2.new((slider.Value - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0
                })
                ApplyRoundCorners(sliderFill, 0.5)
                
                local sliderButton = Create("TextButton", {
                    Parent = sliderTrack,
                    Size = UDim2.new(0, 15, 0, 15),
                    Position = UDim2.new((slider.Value - min) / (max - min), -7.5, 0.5, -7.5),
                    BackgroundColor3 = Theme.Text,
                    Text = "",
                    AutoButtonColor = false
                })
                ApplyRoundCorners(sliderButton, 0.5)
                
                local dragging = false
                
                local function updateSlider(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1),
                        0, 0.5, -7.5
                    )
                    
                    sliderButton.Position = pos
                    
                    local value = math.floor(min + (pos.X.Scale * (max - min)))
                    slider.Value = value
                    valueLabel.Text = tostring(value)
                    sliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
                    
                    if callback then
                        callback(value)
                    end
                end
                
                sliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                sliderButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        updateSlider(input)
                        dragging = true
                    end
                end)
                
                sliderTrack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                slider.Set = function(self, value)
                    value = math.clamp(value, min, max)
                    slider.Value = value
                    valueLabel.Text = tostring(value)
                    
                    local pos = UDim2.new((value - min) / (max - min), -7.5, 0.5, -7.5)
                    sliderButton.Position = pos
                    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    
                    if callback then
                        callback(value)
                    end
                end
                
                slider.Get = function(self)
                    return slider.Value
                end
                
                return slider
            end
            
            function section:CreateDropdown(text, options, default, callback)
                local dropdown = {
                    Value = default or options[1],
                    Options = options,
                    Open = false
                }
                
                local dropdownFrame = Create("Frame", {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1
                })
                
                local label = Create("TextLabel", {
                    Parent = dropdownFrame,
                    Text = text,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local dropdownButton = Create("TextButton", {
                    Parent = dropdownFrame,
                    Text = dropdown.Value,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundColor3 = Theme.Background,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false
                })
                ApplyRoundCorners(dropdownButton, 0.08)
                
                local buttonStroke = Create("UIStroke", {
                    Parent = dropdownButton,
                    Color = Theme.Border,
                    Thickness = 1
                })
                
                local dropdownList = Create("ScrollingFrame", {
                    Parent = dropdownFrame,
                    Size = UDim2.new(0.5, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 1, 5),
                    BackgroundColor3 = Theme.Background,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Theme.Accent,
                    Visible = false,
                    ClipsDescendants = true
                })
                ApplyRoundCorners(dropdownList, 0.08)
                
                local listLayout = Create("UIListLayout", {
                    Parent = dropdownList,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                local function updateList()
                    for _, child in ipairs(dropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for i, option in ipairs(options) do
                        local optionButton = Create("TextButton", {
                            Parent = dropdownList,
                            Text = option,
                            Size = UDim2.new(1, 0, 0, 30),
                            BackgroundColor3 = Theme.Background,
                            TextColor3 = Theme.Text,
                            TextSize = 14,
                            Font = Enum.Font.Gotham,
                            AutoButtonColor = false
                        })
                        
                        optionButton.MouseEnter:Connect(function()
                            optionButton.BackgroundColor3 = Theme.Secondary
                        end)
                        
                        optionButton.MouseLeave:Connect(function()
                            optionButton.BackgroundColor3 = Theme.Background
                        end)
                        
                        optionButton.MouseButton1Click:Connect(function()
                            dropdown.Value = option
                            dropdownButton.Text = option
                            dropdown.Open = false
                            
                            TweenService:Create(dropdownList, TweenInfo.new(0.2), {
                                Size = UDim2.new(0.5, 0, 0, 0)
                            }):Play()
                            
                            wait(0.2)
                            dropdownList.Visible = false
                            
                            if callback then
                                callback(option)
                            end
                        end)
                    end
                    
                    dropdownList.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
                    dropdownList.Size = UDim2.new(0.5, 0, 0, math.min(#options * 30, 150))
                end
                
                updateList()
                
                dropdownButton.MouseButton1Click:Connect(function()
                    dropdown.Open = not dropdown.Open
                    
                    if dropdown.Open then
                        dropdownList.Visible = true
                        TweenService:Create(dropdownList, TweenInfo.new(0.2), {
                            Size = UDim2.new(0.5, 0, 0, math.min(#options * 30, 150))
                        }):Play()
                    else
                        TweenService:Create(dropdownList, TweenInfo.new(0.2), {
                            Size = UDim2.new(0.5, 0, 0, 0)
                        }):Play()
                        
                        wait(0.2)
                        dropdownList.Visible = false
                    end
                end)
                
                dropdown.Set = function(self, value)
                    if table.find(options, value) then
                        dropdown.Value = value
                        dropdownButton.Text = value
                        
                        if callback then
                            callback(value)
                        end
                    end
                end
                
                dropdown.Get = function(self)
                    return dropdown.Value
                end
                
                dropdown.UpdateOptions = function(self, newOptions)
                    options = newOptions
                    dropdown.Options = newOptions
                    updateList()
                end
                
                return dropdown
            end
            
            function section:CreateTextBox(text, placeholder, callback)
                local textBoxFrame = Create("Frame", {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1
                })
                
                local label = Create("TextLabel", {
                    Parent = textBoxFrame,
                    Text = text,
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local inputBox = Create("TextBox", {
                    Parent = textBoxFrame,
                    Text = "",
                    PlaceholderText = placeholder or "Type here...",
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Position = UDim2.new(0.4, 0, 0, 0),
                    BackgroundColor3 = Theme.Background,
                    TextColor3 = Theme.Text,
                    PlaceholderColor3 = Theme.SubText,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    ClearTextOnFocus = false
                })
                ApplyRoundCorners(inputBox, 0.08)
                
                local inputStroke = Create("UIStroke", {
                    Parent = inputBox,
                    Color = Theme.Border,
                    Thickness = 1
                })
                
                inputBox.Focused:Connect(function()
                    TweenService:Create(inputBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = Theme.Secondary
                    }):Play()
                    
                    TweenService:Create(inputStroke, TweenInfo.new(0.2), {
                        Color = Theme.Accent
                    }):Play()
                end)
                
                inputBox.FocusLost:Connect(function(enterPressed)
                    TweenService:Create(inputBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = Theme.Background
                    }):Play()
                    
                    TweenService:Create(inputStroke, TweenInfo.new(0.2), {
                        Color = Theme.Border
                    }):Play()
                    
                    if callback then
                        callback(inputBox.Text, enterPressed)
                    end
                end)
                
                local textbox = {}
                
                textbox.Set = function(self, value)
                    inputBox.Text = value
                end
                
                textbox.Get = function(self)
                    return inputBox.Text
                end
                
                return textbox
            end
            
            function section:CreateKeybind(text, default, callback)
                local keybind = {
                    Value = default or Enum.KeyCode.RightShift,
                    Listening = false
                }
                
                local keybindFrame = Create("Frame", {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1
                })
                
                local label = Create("TextLabel", {
                    Parent = keybindFrame,
                    Text = text,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local keyButton = Create("TextButton", {
                    Parent = keybindFrame,
                    Text = tostring(keybind.Value.Name):gsub("Control", "CTRL"),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundColor3 = Theme.Background,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false
                })
                ApplyRoundCorners(keyButton, 0.08)
                
                local buttonStroke = Create("UIStroke", {
                    Parent = keyButton,
                    Color = Theme.Border,
                    Thickness = 1
                })
                
                local function updateListening()
                    if keybind.Listening then
                        keyButton.Text = "..."
                        TweenService:Create(keyButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Theme.Accent
                        }):Play()
                    else
                        keyButton.Text = tostring(keybind.Value.Name):gsub("Control", "CTRL")
                        TweenService:Create(keyButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Theme.Background
                        }):Play()
                    end
                end
                
                keyButton.MouseButton1Click:Connect(function()
                    keybind.Listening = not keybind.Listening
                    updateListening()
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if keybind.Listening and not gameProcessed then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            keybind.Value = input.KeyCode
                            keybind.Listening = false
                            updateListening()
                            
                            if callback then
                                callback(input.KeyCode)
                            end
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                            keybind.Value = Enum.KeyCode.LeftControl
                            keybind.Listening = false
                            updateListening()
                            
                            if callback then
                                callback(Enum.KeyCode.LeftControl)
                            end
                        end
                    elseif input.KeyCode == keybind.Value and not gameProcessed and callback then
                        callback(keybind.Value)
                    end
                end)
                
                keybind.Set = function(self, value)
                    keybind.Value = value
                    keyButton.Text = tostring(value.Name):gsub("Control", "CTRL")
                end
                
                keybind.Get = function(self)
                    return keybind.Value
                end
                
                return keybind
            end
            
            return section
        end
        
        return tab
    end
    
    -- UI'yi ekrana ekle
    screenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Pencereyi döndür
    return window
end

-- Kütüphaneyi dışa aktar
return FightClubUI
