-- Oxireun UI Library
local Oxireun = {
    Elements = {},
    Flags = {},
    Connections = {},
    Theme = {
        Main = Color3.fromRGB(25, 20, 45),
        Second = Color3.fromRGB(30, 25, 60),
        Stroke = Color3.fromRGB(0, 150, 255),
        Divider = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(180, 200, 255),
        TextDark = Color3.fromRGB(150, 150, 180)
    },
    ConfigFolder = "OxireunConfig",
    SaveConfig = false
}

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Ekran GUI
local ScreenGui = Instance.new("ScreenGui")
if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game.CoreGui
end
ScreenGui.Name = "OxireunUI"
ScreenGui.ResetOnSpawn = false

-- Temel fonksiyonlar
local function Create(className, properties, children)
    local obj = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        obj[prop] = value
    end
    for _, child in pairs(children or {}) do
        child.Parent = obj
    end
    return obj
end

local function AddConnection(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(Oxireun.Connections, conn)
    return conn
end

-- Notification sistemi
function Oxireun:Notify(title, message, duration)
    duration = duration or 5
    
    local notification = Create("Frame", {
        Size = UDim2.new(0.25, 0, 0, 70),
        Position = UDim2.new(0.75, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(35, 30, 65),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 1000,
        Parent = ScreenGui
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        Create("UIStroke", {
            Color = Color3.fromRGB(0, 150, 255),
            Thickness = 3,
            Transparency = 0.3
        }),
        Create("Frame", {
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(0, 150, 255),
            BorderSizePixel = 0
        }),
        Create("TextLabel", {
            Size = UDim2.new(0, 40, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = "🔔",
            TextColor3 = Color3.fromRGB(255, 200, 100),
            Font = Enum.Font.GothamBold,
            TextSize = 20,
            Name = "Icon"
        }),
        Create("TextLabel", {
            Size = UDim2.new(1, -60, 0, 25),
            Position = UDim2.new(0, 50, 0, 10),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Color3.fromRGB(180, 200, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Name = "Title"
        }),
        Create("TextLabel", {
            Size = UDim2.new(1, -60, 0, 20),
            Position = UDim2.new(0, 50, 0, 35),
            BackgroundTransparency = 1,
            Text = message,
            TextColor3 = Color3.fromRGB(200, 220, 240),
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Name = "Message"
        })
    })
    
    -- Animasyon
    notification:TweenPosition(
        UDim2.new(0.75, 0, 0.75, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.4,
        true
    )
    
    task.delay(duration, function()
        notification:TweenPosition(
            UDim2.new(0.75, 0, 1, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        task.wait(0.3)
        notification:Destroy()
    end)
end

-- Pencere oluşturma
function Oxireun:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "Oxireun"
    config.SaveConfig = config.SaveConfig or false
    config.ConfigFolder = config.ConfigFolder or "OxireunConfig"
    
    Oxireun.ConfigFolder = config.ConfigFolder
    Oxireun.SaveConfig = config.SaveConfig
    
    -- ANA PENCERE
    local mainWindow = Create("Frame", {
        Size = UDim2.fromScale(0.4, 0.75),
        Position = UDim2.fromScale(0.03, 0.1),
        BackgroundColor3 = Oxireun.Theme.Main,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Parent = ScreenGui
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Create("UIStroke", {
            Color = Oxireun.Theme.Stroke,
            Thickness = 3,
            Transparency = 0.2
        })
    })
    
    -- ÜST BAR
    local topBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Oxireun.Theme.Second,
        BorderSizePixel = 0,
        Name = "TopBar",
        Parent = mainWindow
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 12, 0, 0)})
    })
    
    -- Başlık
    Create("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name,
        TextColor3 = Oxireun.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    -- Tab Container
    local tabContainer = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        Parent = mainWindow
    })
    
    -- Active Tab Line
    local activeTabLine = Create("Frame", {
        Size = UDim2.new(0.25, -10, 0, 3),
        Position = UDim2.new(0, 5, 1, -3),
        BackgroundColor3 = Oxireun.Theme.Stroke,
        BorderSizePixel = 0,
        Parent = tabContainer
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Content Area
    local contentArea = Create("Frame", {
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 90),
        BackgroundColor3 = Color3.fromRGB(30, 25, 55),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = mainWindow
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    local currentTab = 1
    local tabs = {}
    local tabFrames = {}
    
    -- Tab Functions
    local TabFunctions = {}
    
    function TabFunctions:AddTab(tabName)
        local tabIndex = #tabs + 1
        
        -- Tab Button
        local tabButton = Create("TextButton", {
            Size = UDim2.new(0.25, -5, 1, 0),
            Position = UDim2.new((tabIndex-1) * 0.25, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName:upper(),
            TextColor3 = Oxireun.Theme.TextDark,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            Parent = tabContainer
        })
        
        -- Tab Content Frame
        local tabFrame = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Oxireun.Theme.Stroke,
            ScrollBarImageTransparency = 0.7,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Visible = tabIndex == 1,
            Parent = contentArea
        }, {
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10)
            })
        })
        
        tabs[tabIndex] = {
            button = tabButton,
            frame = tabFrame,
            name = tabName
        }
        
        tabFrames[tabName] = tabFrame
        
        -- Tab Click Event
        tabButton.MouseButton1Click:Connect(function()
            for i, tab in ipairs(tabs) do
                tab.button.TextColor3 = Oxireun.Theme.TextDark
                tab.frame.Visible = false
            end
            
            currentTab = tabIndex
            tabButton.TextColor3 = Oxireun.Theme.Stroke
            tabFrame.Visible = true
            
            -- Move active line
            activeTabLine:TweenPosition(
                UDim2.new((tabIndex-1) * 0.25, 5, 1, -3),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
        end)
        
        -- First tab active
        if tabIndex == 1 then
            tabButton.TextColor3 = Oxireun.Theme.Stroke
        end
        
        -- Element Functions
        local ElementFunctions = {}
        
        -- Section
        function ElementFunctions:AddSection(sectionName)
            local sectionFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(35, 30, 65),
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                LayoutOrder = 999,
                Parent = tabFrame
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                Create("TextLabel", {
                    Size = UDim2.new(1, -20, 0, 25),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = sectionName:upper(),
                    TextColor3 = Oxireun.Theme.Stroke,
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 0, 25),
                    BackgroundColor3 = Oxireun.Theme.Stroke,
                    BorderSizePixel = 0,
                    Transparency = 0.3
                })
            })
            
            -- Section içinde elementler için container
            local sectionContainer = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundTransparency = 1,
                Parent = sectionFrame
            }, {
                Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 10)
                })
            })
            
            local SectionElementFunctions = {}
            
            -- Add Label
            function SectionElementFunctions:AddLabel(text)
                local label = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Oxireun.Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LayoutOrder = 1,
                    Parent = sectionContainer
                })
                
                local labelFunc = {}
                function labelFunc:Set(newText)
                    label.Text = newText
                end
                
                return labelFunc
            end
            
            -- Add Paragraph
            function SectionElementFunctions:AddParagraph(title, content)
                local paragraphFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    Parent = sectionContainer
                }, {
                    Create("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 20),
                        BackgroundTransparency = 1,
                        Text = title,
                        TextColor3 = Oxireun.Theme.Stroke,
                        Font = Enum.Font.GothamBold,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Create("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 30),
                        Position = UDim2.new(0, 0, 0, 20),
                        BackgroundTransparency = 1,
                        Text = content,
                        TextColor3 = Oxireun.Theme.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextWrapped = true
                    })
                })
                
                local paraFunc = {}
                function paraFunc:Set(newTitle, newContent)
                    paragraphFrame:FindFirstChildOfClass("TextLabel").Text = newTitle
                    paragraphFrame:FindFirstChildWhichIsA("TextLabel", true).Text = newContent
                end
                
                return paraFunc
            end
            
            -- Add Button
            function SectionElementFunctions:AddButton(config)
                config = config or {}
                config.Name = config.Name or "Button"
                config.Callback = config.Callback or function() end
                
                local button = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 70),
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Stroke,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    LayoutOrder = 3,
                    Parent = sectionContainer
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 6)})
                })
                
                -- Hover effects
                button.MouseEnter:Connect(function()
                    button.BackgroundTransparency = 0.3
                end)
                
                button.MouseLeave:Connect(function()
                    button.BackgroundTransparency = 0.5
                end)
                
                button.MouseButton1Click:Connect(function()
                    config.Callback()
                end)
                
                local buttonFunc = {}
                function buttonFunc:Set(newText)
                    button.Text = newText
                end
                
                return buttonFunc
            end
            
            -- Add Toggle
            function SectionElementFunctions:AddToggle(config)
                config = config or {}
                config.Name = config.Name or "Toggle"
                config.Default = config.Default or false
                config.Callback = config.Callback or function() end
                config.Flag = config.Flag or nil
                config.Save = config.Save or false
                
                local toggleValue = config.Default
                local Toggle = {Value = toggleValue, Type = "Toggle", Save = config.Save}
                
                local toggleFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    LayoutOrder = 4,
                    Parent = sectionContainer
                })
                
                -- Toggle Background
                local toggleBg = Create("Frame", {
                    Size = UDim2.new(0, 45, 0, 24),
                    Position = UDim2.new(1, -50, 0.5, -12),
                    BackgroundColor3 = Color3.fromRGB(180, 180, 190),
                    BorderSizePixel = 0,
                    Parent = toggleFrame
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                -- Toggle Circle
                local toggleCircle = Create("Frame", {
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Parent = toggleBg
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                -- Toggle Label
                Create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Stroke,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleFrame
                })
                
                -- Toggle Button
                local toggleBtn = Create("TextButton", {
                    Size = UDim2.new(0, 45, 0, 24),
                    Position = UDim2.new(1, -50, 0.5, -12),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = toggleFrame
                })
                
                -- Toggle function
                local function updateToggle()
                    if toggleValue then
                        toggleBg.BackgroundColor3 = Oxireun.Theme.Stroke
                        toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                    else
                        toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                        toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                    end
                    Toggle.Value = toggleValue
                    config.Callback(toggleValue)
                    
                    if Oxireun.SaveConfig then
                        Oxireun:SaveConfig()
                    end
                end
                
                toggleBtn.MouseButton1Click:Connect(function()
                    toggleValue = not toggleValue
                    updateToggle()
                end)
                
                -- Hover
                toggleBtn.MouseEnter:Connect(function()
                    toggleBg.BackgroundTransparency = 0.1
                end)
                
                toggleBtn.MouseLeave:Connect(function()
                    toggleBg.BackgroundTransparency = 0
                end)
                
                -- Initial state
                updateToggle()
                
                -- Set function
                function Toggle:Set(value)
                    toggleValue = value
                    updateToggle()
                end
                
                -- Save to flags
                if config.Flag then
                    Oxireun.Flags[config.Flag] = Toggle
                end
                
                return Toggle
            end
            
            -- Add Slider
            function SectionElementFunctions:AddSlider(config)
                config = config or {}
                config.Name = config.Name or "Slider"
                config.Min = config.Min or 0
                config.Max = config.Max or 100
                config.Default = config.Default or 50
                config.Increment = config.Increment or 1
                config.Callback = config.Callback or function() end
                config.Flag = config.Flag or nil
                config.Save = config.Save or false
                
                local sliderValue = config.Default
                local Slider = {Value = sliderValue, Type = "Slider", Save = config.Save}
                
                local sliderFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundTransparency = 1,
                    LayoutOrder = 5,
                    Parent = sectionContainer
                })
                
                -- Labels
                Create("TextLabel", {
                    Size = UDim2.new(0.5, 0, 0, 20),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Stroke,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sliderFrame
                })
                
                local valueLabel = Create("TextLabel", {
                    Size = UDim2.new(0.5, 0, 0, 20),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = sliderValue .. "%",
                    TextColor3 = Oxireun.Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = sliderFrame
                })
                
                -- Slider Background
                local sliderBg = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 6),
                    Position = UDim2.new(0, 0, 0, 25),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 75),
                    BorderSizePixel = 0,
                    Parent = sliderFrame
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                -- Slider Fill
                local sliderFill = Create("Frame", {
                    Size = UDim2.new(sliderValue/100, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Oxireun.Theme.Stroke,
                    BorderSizePixel = 0,
                    Parent = sliderBg
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                -- Slider Handle
                local sliderHandle = Create("TextButton", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(sliderValue/100, -8, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = sliderBg
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Create("UIStroke", {
                        Color = Oxireun.Theme.Stroke,
                        Thickness = 2
                    })
                })
                
                -- Slider Logic
                local sliding = false
                
                local function updateSlider(value)
                    local percent = math.clamp(value, config.Min, config.Max) / config.Max
                    sliderValue = math.floor(percent * config.Max)
                    
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
                    valueLabel.Text = sliderValue .. "%"
                    
                    Slider.Value = sliderValue
                    config.Callback(sliderValue)
                    
                    if Oxireun.SaveConfig then
                        Oxireun:SaveConfig()
                    end
                end
                
                local function startSliding()
                    sliding = true
                    tabFrame.ScrollingEnabled = false
                    
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if sliding then
                            local mouse = Player:GetMouse()
                            local sliderAbsPos = sliderBg.AbsolutePosition
                            local sliderAbsSize = sliderBg.AbsoluteSize
                            
                            local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                            updateSlider(relativeX * config.Max)
                        else
                            connection:Disconnect()
                        end
                    end)
                end
                
                local function stopSliding()
                    sliding = false
                    tabFrame.ScrollingEnabled = true
                end
                
                sliderHandle.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        startSliding()
                    end
                end)
                
                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mouse = Player:GetMouse()
                        local sliderAbsPos = sliderBg.AbsolutePosition
                        local sliderAbsSize = sliderBg.AbsoluteSize
                        
                        local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                        updateSlider(relativeX * config.Max)
                        startSliding()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        stopSliding()
                    end
                end)
                
                -- Set function
                function Slider:Set(value)
                    updateSlider(value)
                end
                
                -- Save to flags
                if config.Flag then
                    Oxireun.Flags[config.Flag] = Slider
                end
                
                return Slider
            end
            
            -- Add Dropdown
            function SectionElementFunctions:AddDropdown(config)
                config = config or {}
                config.Name = config.Name or "Dropdown"
                config.Options = config.Options or {"Option 1", "Option 2", "Option 3"}
                config.Default = config.Default or config.Options[1]
                config.Callback = config.Callback or function() end
                config.Flag = config.Flag or nil
                config.Save = config.Save or false
                
                local selectedValue = config.Default
                local Dropdown = {Value = selectedValue, Options = config.Options, Type = "Dropdown", Save = config.Save}
                
                local dropdownFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    LayoutOrder = 6,
                    Parent = sectionContainer
                })
                
                -- Label
                Create("TextLabel", {
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Stroke,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = dropdownFrame
                })
                
                -- Dropdown Button
                local dropdownBtn = Create("TextButton", {
                    Size = UDim2.new(1, -110, 1, 0),
                    Position = UDim2.new(0, 110, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(60, 50, 90),
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Text = selectedValue,
                    TextColor3 = Oxireun.Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = dropdownFrame
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 6)})
                })
                
                -- Dropdown Panel
                local dropdownPanel = Create("Frame", {
                    Size = UDim2.new(0, 150, 0, 100),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(40, 35, 70),
                    BorderSizePixel = 0,
                    Visible = false,
                    ZIndex = 100,
                    Parent = mainWindow
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                    Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 5)
                    }),
                    Create("UIPadding", {
                        PaddingTop = UDim.new(0, 5),
                        PaddingBottom = UDim.new(0, 5),
                        PaddingLeft = UDim.new(0, 5),
                        PaddingRight = UDim.new(0, 5)
                    })
                })
                
                -- Options
                for _, option in ipairs(config.Options) do
                    local optionBtn = Create("TextButton", {
                        Size = UDim2.new(1, -10, 0, 25),
                        BackgroundColor3 = Color3.fromRGB(55, 45, 85),
                        BackgroundTransparency = 0.5,
                        BorderSizePixel = 0,
                        Text = option,
                        TextColor3 = Oxireun.Theme.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        ZIndex = 101,
                        Parent = dropdownPanel
                    }, {
                        Create("UICorner", {CornerRadius = UDim.new(0, 5)})
                    })
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        selectedValue = option
                        dropdownBtn.Text = option
                        dropdownPanel.Visible = false
                        Dropdown.Value = selectedValue
                        config.Callback(selectedValue)
                        
                        if Oxireun.SaveConfig then
                            Oxireun:SaveConfig()
                        end
                    end)
                end
                
                -- Toggle Panel
                dropdownBtn.MouseButton1Click:Connect(function()
                    dropdownPanel.Visible = not dropdownPanel.Visible
                    
                    if dropdownPanel.Visible then
                        local btnPos = dropdownBtn.AbsolutePosition
                        local mainPos = mainWindow.AbsolutePosition
                        local mainSize = mainWindow.AbsoluteSize
                        
                        local relativeX = (btnPos.X - mainPos.X) / mainSize.X
                        local relativeY = (btnPos.Y - mainPos.Y + dropdownBtn.AbsoluteSize.Y) / mainSize.Y
                        
                        dropdownPanel.Position = UDim2.new(relativeX, 0, relativeY, 0)
                        dropdownPanel.Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, #config.Options * 30 + 10)
                    end
                end)
                
                -- Close panel when clicking outside
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mousePos = input.Position
                        local panelPos = dropdownPanel.AbsolutePosition
                        local panelSize = dropdownPanel.AbsoluteSize
                        
                        if dropdownPanel.Visible then
                            if not (mousePos.X >= panelPos.X and mousePos.X <= panelPos.X + panelSize.X and
                                   mousePos.Y >= panelPos.Y and mousePos.Y <= panelPos.Y + panelSize.Y) then
                                dropdownPanel.Visible = false
                            end
                        end
                    end
                end)
                
                -- Set function
                function Dropdown:Set(value)
                    if table.find(config.Options, value) then
                        selectedValue = value
                        dropdownBtn.Text = value
                        Dropdown.Value = value
                        config.Callback(value)
                    end
                end
                
                -- Refresh function
                function Dropdown:Refresh(newOptions, clear)
                    if clear then
                        for _, child in ipairs(dropdownPanel:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        config.Options = {}
                    end
                    
                    for _, option in ipairs(newOptions) do
                        table.insert(config.Options, option)
                        
                        local optionBtn = Create("TextButton", {
                            Size = UDim2.new(1, -10, 0, 25),
                            BackgroundColor3 = Color3.fromRGB(55, 45, 85),
                            BackgroundTransparency = 0.5,
                            BorderSizePixel = 0,
                            Text = option,
                            TextColor3 = Oxireun.Theme.Text,
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            ZIndex = 101,
                            Parent = dropdownPanel
                        }, {
                            Create("UICorner", {CornerRadius = UDim.new(0, 5)})
                        })
                        
                        optionBtn.MouseButton1Click:Connect(function()
                            selectedValue = option
                            dropdownBtn.Text = option
                            dropdownPanel.Visible = false
                            Dropdown.Value = selectedValue
                            config.Callback(selectedValue)
                        end)
                    end
                end
                
                -- Save to flags
                if config.Flag then
                    Oxireun.Flags[config.Flag] = Dropdown
                end
                
                return Dropdown
            end
            
            -- Add Textbox
            function SectionElementFunctions:AddTextbox(config)
                config = config or {}
                config.Name = config.Name or "Textbox"
                config.Default = config.Default or ""
                config.TextDisappear = config.TextDisappear or false
                config.Callback = config.Callback or function() end
                config.Flag = config.Flag or nil
                config.Save = config.Save or false
                
                local textValue = config.Default
                local Textbox = {Value = textValue, Type = "Textbox", Save = config.Save}
                
                local textboxFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    LayoutOrder = 7,
                    Parent = sectionContainer
                })
                
                -- Label
                Create("TextLabel", {
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Stroke,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = textboxFrame
                })
                
                -- Textbox
                local textbox = Create("TextBox", {
                    Size = UDim2.new(1, -110, 1, 0),
                    Position = UDim2.new(0, 110, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(45, 40, 75),
                    BackgroundTransparency = 0.6,
                    BorderSizePixel = 0,
                    Text = textValue,
                    TextColor3 = Oxireun.Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    PlaceholderColor3 = Color3.fromRGB(150, 150, 170),
                    PlaceholderText = "Enter",
                    Parent = textboxFrame
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 6)})
                })
                
                -- Focus effects
                textbox.Focused:Connect(function()
                    textbox.BackgroundTransparency = 0.5
                end)
                
                textbox.FocusLost:Connect(function(enterPressed)
                    textValue = textbox.Text
                    Textbox.Value = textValue
                    textbox.BackgroundTransparency = 0.6
                    
                    config.Callback(textValue)
                    
                    if config.TextDisappear then
                        textbox.Text = ""
                    end
                    
                    if Oxireun.SaveConfig then
                        Oxireun:SaveConfig()
                    end
                end)
                
                -- Set function
                function Textbox:Set(value)
                    textbox.Text = value
                    textValue = value
                    Textbox.Value = value
                end
                
                -- Save to flags
                if config.Flag then
                    Oxireun.Flags[config.Flag] = Textbox
                end
                
                return Textbox
            end
            
            -- Add Bind
            function SectionElementFunctions:AddBind(config)
                config = config or {}
                config.Name = config.Name or "Bind"
                config.Default = config.Default or Enum.KeyCode.E
                config.Hold = config.Hold or false
                config.Callback = config.Callback or function() end
                config.Flag = config.Flag or nil
                config.Save = config.Save or false
                
                local bindValue = config.Default
                local binding = false
                local holding = false
                local Bind = {Value = bindValue, Type = "Bind", Save = config.Save}
                
                local bindFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    LayoutOrder = 8,
                    Parent = sectionContainer
                })
                
                -- Label
                Create("TextLabel", {
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Stroke,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = bindFrame
                })
                
                -- Bind Button
                local bindBtn = Create("TextButton", {
                    Size = UDim2.new(1, -110, 1, 0),
                    Position = UDim2.new(0, 110, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(60, 50, 90),
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Text = tostring(bindValue):gsub("Enum.KeyCode.", ""),
                    TextColor3 = Oxireun.Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = bindFrame
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 6)})
                })
                
                -- Bind logic
                bindBtn.MouseButton1Click:Connect(function()
                    binding = true
                    bindBtn.Text = "..."
                end)
                
                local function setBind(key)
                    bindValue = key
                    Bind.Value = key
                    bindBtn.Text = tostring(key):gsub("Enum.KeyCode.", "")
                    binding = false
                    
                    if Oxireun.SaveConfig then
                        Oxireun:SaveConfig()
                    end
                end
                
                UserInputService.InputBegan:Connect(function(input)
                    if binding then
                        local key = input.KeyCode
                        if key ~= Enum.KeyCode.Unknown then
                            setBind(key)
                        end
                    else
                        if input.KeyCode == bindValue then
                            if config.Hold then
                                holding = true
                                config.Callback(true)
                            else
                                config.Callback()
                            end
                        end
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode == bindValue then
                        if config.Hold and holding then
                            holding = false
                            config.Callback(false)
                        end
                    end
                end)
                
                -- Set function
                function Bind:Set(key)
                    setBind(key)
                end
                
                -- Save to flags
                if config.Flag then
                    Oxireun.Flags[config.Flag] = Bind
                end
                
                return Bind
            end
            
            -- Update section size
            AddConnection(sectionContainer:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                sectionFrame.Size = UDim2.new(1, 0, 0, sectionContainer.AbsoluteContentSize.Y + 40)
            end)
            
            return SectionElementFunctions
        end
        
        -- Return ElementFunctions for direct use (without section)
        local DirectElements = {}
        
        function DirectElements:AddLabel(text)
            local label = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Oxireun.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 1,
                Parent = tabFrame
            })
            
            local labelFunc = {}
            function labelFunc:Set(newText)
                label.Text = newText
            end
            
            return labelFunc
        end
        
        function DirectElements:AddButton(config)
            return ElementFunctions:AddSection(""):AddButton(config)
        end
        
        function DirectElements:AddToggle(config)
            return ElementFunctions:AddSection(""):AddToggle(config)
        end
        
        function DirectElements:AddSlider(config)
            return ElementFunctions:AddSection(""):AddSlider(config)
        end
        
        function DirectElements:AddDropdown(config)
            return ElementFunctions:AddSection(""):AddDropdown(config)
        end
        
        function DirectElements:AddTextbox(config)
            return ElementFunctions:AddSection(""):AddTextbox(config)
        end
        
        function DirectElements:AddBind(config)
            return ElementFunctions:AddSection(""):AddBind(config)
        end
        
        function DirectElements:AddParagraph(title, content)
            return ElementFunctions:AddSection(""):AddParagraph(title, content)
        end
        
        return setmetatable(DirectElements, {
            __index = function(_, key)
                if key == "AddSection" then
                    return function(_, sectionName)
                        return ElementFunctions:AddSection(sectionName)
                    end
                end
            end
        })
    end
    
    return TabFunctions
end

-- Config functions
function Oxireun:SaveConfig()
    if not self.SaveConfig then return end
    
    local data = {}
    for flagName, flag in pairs(self.Flags) do
        if flag.Save then
            if flag.Type == "Toggle" or flag.Type == "Slider" or flag.Type == "Textbox" then
                data[flagName] = flag.Value
            elseif flag.Type == "Dropdown" then
                data[flagName] = flag.Value
            elseif flag.Type == "Bind" then
                data[flagName] = flag.Value
            end
        end
    end
    
    if not isfolder(self.ConfigFolder) then
        makefolder(self.ConfigFolder)
    end
    
    writefile(self.ConfigFolder .. "/config.json", HttpService:JSONEncode(data))
end

function Oxireun:LoadConfig()
    if not self.SaveConfig then return end
    
    if isfile(self.ConfigFolder .. "/config.json") then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(self.ConfigFolder .. "/config.json"))
        end)
        
        if success then
            for flagName, value in pairs(data) do
                if self.Flags[flagName] then
                    if self.Flags[flagName].Type == "Toggle" then
                        self.Flags[flagName]:Set(value)
                    elseif self.Flags[flagName].Type == "Slider" then
                        self.Flags[flagName]:Set(value)
                    elseif self.Flags[flagName].Type == "Dropdown" then
                        self.Flags[flagName]:Set(value)
                    elseif self.Flags[flagName].Type == "Textbox" then
                        self.Flags[flagName]:Set(value)
                    elseif self.Flags[flagName].Type == "Bind" then
                        self.Flags[flagName]:Set(value)
                    end
                end
            end
        end
    end
end

function Oxireun:Init()
    self:LoadConfig()
    self:Notify("Oxireun UI", "Library Loaded Successfully", 3)
end

return Oxireun
