-- Oxireun Wizard UI Library
local Oxireun = {
    Windows = {},
    Tabs = {},
    Elements = {},
    Flags = {},
    Notifications = {},
    Config = {
        AutoSave = false,
        Folder = "OxireunConfigs"
    },
    Theme = {
        Main = Color3.fromRGB(25, 20, 45),
        Secondary = Color3.fromRGB(30, 25, 60),
        Accent = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(180, 200, 255),
        TextDark = Color3.fromRGB(150, 150, 180)
    }
}

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Helper functions
local function Create(className, properties)
    local obj = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            obj[prop] = value
        end
    end
    return obj
end

local function AddCorner(parent, radius)
    local corner = Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = Create("UIStroke", {
        Color = color or Color3.fromRGB(255, 255, 255),
        Thickness = thickness or 1,
        Parent = parent
    })
    return stroke
end

-- Notification System
function Oxireun:Notify(title, message, duration)
    duration = duration or 3
    
    local notification = Create("Frame", {
        Size = UDim2.new(0.3, 0, 0, 70),
        Position = UDim2.new(0.7, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(35, 30, 65),
        BorderSizePixel = 0,
        ZIndex = 1000
    })
    
    AddCorner(notification, 10)
    AddStroke(notification, Color3.fromRGB(0, 150, 255), 3)
    
    local topLine = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 150, 255),
        BorderSizePixel = 0,
        Parent = notification
    })
    
    local icon = Create("TextLabel", {
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "🔔",
        TextColor3 = Color3.fromRGB(255, 200, 100),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = notification
    })
    
    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 25),
        Position = UDim2.new(0, 50, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(180, 200, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    local messageLabel = Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 20),
        Position = UDim2.new(0, 50, 0, 35),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Color3.fromRGB(200, 220, 240),
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    -- Insert into game
    if gethui then
        notification.Parent = gethui()
    else
        notification.Parent = game.CoreGui
    end
    
    -- Animate in
    notification:TweenPosition(
        UDim2.new(0.7, 0, 0.8, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.4,
        true
    )
    
    -- Wait and animate out
    task.delay(duration, function()
        notification:TweenPosition(
            UDim2.new(0.7, 0, 1, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        task.wait(0.3)
        notification:Destroy()
    end)
    
    return notification
end

-- Window Creation
function Oxireun:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "Oxireun UI"
    config.AutoSave = config.AutoSave or false
    config.Theme = config.Theme or "Default"
    
    local windowId = #Oxireun.Windows + 1
    local window = {}
    window.Id = windowId
    window.Tabs = {}
    window.Config = config
    
    -- Main GUI
    local gui = Create("ScreenGui", {
        Name = "OxireunGUI_" .. windowId,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    if gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game.CoreGui
    end
    
    -- Main Frame
    local main = Create("Frame", {
        Size = UDim2.fromScale(0.4, 0.75),
        Position = UDim2.fromScale(0.03, 0.1),
        BackgroundColor3 = Oxireun.Theme.Main,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Parent = gui
    })
    
    AddCorner(main, 12)
    AddStroke(main, Oxireun.Theme.Accent, 3)
    
    -- Top Bar
    local topBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Oxireun.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = main
    })
    
    AddCorner(topBar, 12)
    topBar.Corner.CornerRadius = UDim.new(0, 12, 0, 0)
    
    -- Title
    local titleLabel = Create("TextLabel", {
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
        Parent = main
    })
    
    -- Active Tab Indicator
    local activeTabLine = Create("Frame", {
        Size = UDim2.new(0.25, -10, 0, 3),
        Position = UDim2.new(0, 5, 1, -3),
        BackgroundColor3 = Oxireun.Theme.Accent,
        BorderSizePixel = 0,
        Parent = tabContainer
    })
    
    AddCorner(activeTabLine, 10)
    
    -- Content Area
    local contentArea = Create("Frame", {
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 90),
        BackgroundColor3 = Color3.fromRGB(30, 25, 55),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = main
    })
    
    AddCorner(contentArea, 8)
    
    -- Window Functions
    function window:AddTab(tabName)
        local tabId = #window.Tabs + 1
        local tab = {}
        tab.Id = tabId
        tab.Name = tabName
        tab.Elements = {}
        
        -- Tab Button
        local tabButton = Create("TextButton", {
            Size = UDim2.new(0.25, -5, 1, 0),
            Position = UDim2.new((tabId-1) * 0.25, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName:upper(),
            TextColor3 = Oxireun.Theme.TextDark,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            Parent = tabContainer
        })
        
        -- Content Frame
        local contentFrame = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new((tabId-1), 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Oxireun.Theme.Accent,
            ScrollBarImageTransparency = 0.7,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Visible = tabId == 1,
            Parent = contentArea
        })
        
        local contentList = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = contentFrame
        })
        
        local contentPadding = Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            Parent = contentFrame
        })
        
        -- Tab switching
        local function switchToTab()
            for _, t in pairs(window.Tabs) do
                if t.Button then
                    t.Button.TextColor3 = Oxireun.Theme.TextDark
                end
                if t.Content then
                    t.Content.Visible = false
                end
            end
            
            tabButton.TextColor3 = Oxireun.Theme.Accent
            contentFrame.Visible = true
            
            -- Move indicator
            activeTabLine:TweenPosition(
                UDim2.new((tabId-1) * 0.25, 5, 1, -3),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
        end
        
        tabButton.MouseButton1Click:Connect(switchToTab)
        
        -- Store references
        tab.Button = tabButton
        tab.Content = contentFrame
        
        -- Tab Functions
        function tab:AddSection(sectionName)
            local section = {}
            
            local sectionFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(35, 30, 65),
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                LayoutOrder = 999,
                Parent = contentFrame
            })
            
            AddCorner(sectionFrame, 8)
            
            local title = Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = sectionName:upper(),
                TextColor3 = Oxireun.Theme.Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionFrame
            })
            
            local line = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundColor3 = Oxireun.Theme.Accent,
                BorderSizePixel = 0,
                Transparency = 0.3,
                Parent = sectionFrame
            })
            
            -- Section Elements Container
            local elementsContainer = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundTransparency = 1,
                Parent = sectionFrame
            })
            
            local elementsList = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                Parent = elementsContainer
            })
            
            -- Update section size
            elementsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionFrame.Size = UDim2.new(1, 0, 0, elementsContainer.AbsoluteContentSize.Y + 45)
            end)
            
            -- Section Functions
            function section:AddLabel(text)
                local label = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Oxireun.Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LayoutOrder = 1,
                    Parent = elementsContainer
                })
                
                local function setLabel(newText)
                    label.Text = newText
                end
                
                return {
                    Set = setLabel
                }
            end
            
            function section:AddButton(config)
                config = config or {}
                config.Name = config.Name or "Button"
                config.Callback = config.Callback or function() end
                
                local button = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 70),
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Accent,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    LayoutOrder = 2,
                    Parent = elementsContainer
                })
                
                AddCorner(button, 6)
                
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
                
                local function setButton(newText)
                    button.Text = newText
                end
                
                return {
                    Set = setButton
                }
            end
            
            function section:AddToggle(config)
                config = config or {}
                config.Name = config.Name or "Toggle"
                config.Default = config.Default or false
                config.Callback = config.Callback or function() end
                config.Flag = config.Flag or nil
                
                local toggleValue = config.Default
                local toggle = {
                    Value = toggleValue,
                    Type = "Toggle",
                    Set = function(self, value)
                        toggleValue = value
                        updateToggle()
                    end
                }
                
                local toggleFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    LayoutOrder = 3,
                    Parent = elementsContainer
                })
                
                local toggleBg = Create("Frame", {
                    Size = UDim2.new(0, 45, 0, 24),
                    Position = UDim2.new(1, -50, 0.5, -12),
                    BackgroundColor3 = Color3.fromRGB(180, 180, 190),
                    BorderSizePixel = 0,
                    Parent = toggleFrame
                })
                
                AddCorner(toggleBg, 12)
                
                local toggleCircle = Create("Frame", {
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = toggleValue and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Parent = toggleBg
                })
                
                AddCorner(toggleCircle, 10)
                
                Create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Accent,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleFrame
                })
                
                local toggleBtn = Create("TextButton", {
                    Size = UDim2.new(0, 45, 0, 24),
                    Position = UDim2.new(1, -50, 0.5, -12),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = toggleFrame
                })
                
                local function updateToggle()
                    if toggleValue then
                        toggleBg.BackgroundColor3 = Oxireun.Theme.Accent
                        toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                    else
                        toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                        toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                    end
                    toggle.Value = toggleValue
                    config.Callback(toggleValue)
                    
                    if config.Flag then
                        Oxireun.Flags[config.Flag] = toggle
                    end
                end
                
                toggleBtn.MouseButton1Click:Connect(function()
                    toggleValue = not toggleValue
                    updateToggle()
                end)
                
                updateToggle()
                return toggle
            end
            
            function section:AddSlider(config)
                config = config or {}
                config.Name = config.Name or "Slider"
                config.Min = config.Min or 0
                config.Max = config.Max or 100
                config.Default = config.Default or 50
                config.Callback = config.Callback or function() end
                config.Flag = config.Flag or nil
                
                local sliderValue = config.Default
                local slider = {
                    Value = sliderValue,
                    Type = "Slider",
                    Set = function(self, value)
                        updateSlider(value)
                    end
                }
                
                local sliderFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundTransparency = 1,
                    LayoutOrder = 4,
                    Parent = elementsContainer
                })
                
                local label = Create("TextLabel", {
                    Size = UDim2.new(0.5, 0, 0, 20),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Accent,
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
                
                local sliderBg = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 6),
                    Position = UDim2.new(0, 0, 0, 25),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 75),
                    BorderSizePixel = 0,
                    Parent = sliderFrame
                })
                
                AddCorner(sliderBg, 3)
                
                local sliderFill = Create("Frame", {
                    Size = UDim2.new(sliderValue/100, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Oxireun.Theme.Accent,
                    BorderSizePixel = 0,
                    Parent = sliderBg
                })
                
                AddCorner(sliderFill, 3)
                
                local sliderHandle = Create("TextButton", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(sliderValue/100, -8, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = sliderBg
                })
                
                AddCorner(sliderHandle, 8)
                AddStroke(sliderHandle, Oxireun.Theme.Accent, 2)
                
                local sliding = false
                
                local function updateSlider(value)
                    sliderValue = math.clamp(value, config.Min, config.Max)
                    local percent = (sliderValue - config.Min) / (config.Max - config.Min)
                    
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
                    valueLabel.Text = sliderValue
                    
                    slider.Value = sliderValue
                    config.Callback(sliderValue)
                    
                    if config.Flag then
                        Oxireun.Flags[config.Flag] = slider
                    end
                end
                
                local function startSliding()
                    sliding = true
                    contentFrame.ScrollingEnabled = false
                    
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if sliding then
                            local mouse = Player:GetMouse()
                            local absPos = sliderBg.AbsolutePosition
                            local absSize = sliderBg.AbsoluteSize
                            
                            local relativeX = (mouse.X - absPos.X) / absSize.X
                            updateSlider(relativeX * (config.Max - config.Min) + config.Min)
                        else
                            connection:Disconnect()
                        end
                    end)
                end
                
                local function stopSliding()
                    sliding = false
                    contentFrame.ScrollingEnabled = true
                end
                
                sliderHandle.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        startSliding()
                    end
                end)
                
                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mouse = Player:GetMouse()
                        local absPos = sliderBg.AbsolutePosition
                        local absSize = sliderBg.AbsoluteSize
                        
                        local relativeX = (mouse.X - absPos.X) / absSize.X
                        updateSlider(relativeX * (config.Max - config.Min) + config.Min)
                        startSliding()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        stopSliding()
                    end
                end)
                
                updateSlider(sliderValue)
                return slider
            end
            
            function section:AddDropdown(config)
                config = config or {}
                config.Name = config.Name or "Dropdown"
                config.Options = config.Options or {"Option 1", "Option 2", "Option 3"}
                config.Default = config.Default or config.Options[1]
                config.Callback = config.Callback or function() end
                config.Flag = config.Flag or nil
                
                local selected = config.Default
                local dropdown = {
                    Value = selected,
                    Type = "Dropdown",
                    Set = function(self, value)
                        selected = value
                        dropdownBtn.Text = value
                        config.Callback(value)
                        if config.Flag then
                            Oxireun.Flags[config.Flag] = dropdown
                        end
                    end,
                    Refresh = function(self, newOptions)
                        config.Options = newOptions
                        -- Recreate dropdown options
                    end
                }
                
                local dropdownFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    LayoutOrder = 5,
                    Parent = elementsContainer
                })
                
                Create("TextLabel", {
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Accent,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = dropdownFrame
                })
                
                local dropdownBtn = Create("TextButton", {
                    Size = UDim2.new(1, -110, 1, 0),
                    Position = UDim2.new(0, 110, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(60, 50, 90),
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Text = selected,
                    TextColor3 = Oxireun.Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = dropdownFrame
                })
                
                AddCorner(dropdownBtn, 6)
                
                dropdownBtn.MouseButton1Click:Connect(function()
                    -- Simple dropdown implementation
                    -- You can extend this with a proper dropdown menu
                    local optionsStr = table.concat(config.Options, ", ")
                    Oxireun:Notify("Options", "Available: " .. optionsStr, 2)
                end)
                
                if config.Flag then
                    Oxireun.Flags[config.Flag] = dropdown
                end
                
                return dropdown
            end
            
            function section:AddTextbox(config)
                config = config or {}
                config.Name = config.Name or "Textbox"
                config.Default = config.Default or ""
                config.Callback = config.Callback or function() end
                config.Flag = config.Flag or nil
                
                local textValue = config.Default
                local textbox = {
                    Value = textValue,
                    Type = "Textbox",
                    Set = function(self, value)
                        textboxInput.Text = value
                        textValue = value
                        config.Callback(value)
                        if config.Flag then
                            Oxireun.Flags[config.Flag] = textbox
                        end
                    end
                }
                
                local textboxFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    LayoutOrder = 6,
                    Parent = elementsContainer
                })
                
                Create("TextLabel", {
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Accent,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = textboxFrame
                })
                
                local textboxInput = Create("TextBox", {
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
                })
                
                AddCorner(textboxInput, 6)
                
                textboxInput.FocusLost:Connect(function()
                    textValue = textboxInput.Text
                    textbox.Value = textValue
                    config.Callback(textValue)
                    if config.Flag then
                        Oxireun.Flags[config.Flag] = textbox
                    end
                end)
                
                if config.Flag then
                    Oxireun.Flags[config.Flag] = textbox
                end
                
                return textbox
            end
            
            function section:AddBind(config)
                config = config or {}
                config.Name = config.Name or "Bind"
                config.Default = config.Default or Enum.KeyCode.E
                config.Callback = config.Callback or function() end
                config.Flag = config.Flag or nil
                
                local bindValue = config.Default
                local binding = false
                local bind = {
                    Value = bindValue,
                    Type = "Bind",
                    Set = function(self, value)
                        bindValue = value
                        bindBtn.Text = tostring(value):gsub("Enum.KeyCode.", "")
                        if config.Flag then
                            Oxireun.Flags[config.Flag] = bind
                        end
                    end
                }
                
                local bindFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    LayoutOrder = 7,
                    Parent = elementsContainer
                })
                
                Create("TextLabel", {
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = config.Name,
                    TextColor3 = Oxireun.Theme.Accent,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = bindFrame
                })
                
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
                })
                
                AddCorner(bindBtn, 6)
                
                bindBtn.MouseButton1Click:Connect(function()
                    binding = true
                    bindBtn.Text = "..."
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if binding then
                        local key = input.KeyCode
                        if key ~= Enum.KeyCode.Unknown then
                            bindValue = key
                            bindBtn.Text = tostring(key):gsub("Enum.KeyCode.", "")
                            binding = false
                            bind.Value = bindValue
                            if config.Flag then
                                Oxireun.Flags[config.Flag] = bind
                            end
                        end
                    elseif input.KeyCode == bindValue then
                        config.Callback()
                    end
                end)
                
                if config.Flag then
                    Oxireun.Flags[config.Flag] = bind
                end
                
                return bind
            end
            
            return section
        end
        
        -- Direct element functions (without section)
        function tab:AddLabel(text)
            local section = self:AddSection("")
            return section:AddLabel(text)
        end
        
        function tab:AddButton(config)
            local section = self:AddSection("")
            return section:AddButton(config)
        end
        
        function tab:AddToggle(config)
            local section = self:AddSection("")
            return section:AddToggle(config)
        end
        
        function tab:AddSlider(config)
            local section = self:AddSection("")
            return section:AddSlider(config)
        end
        
        function tab:AddDropdown(config)
            local section = self:AddSection("")
            return section:AddDropdown(config)
        end
        
        function tab:AddTextbox(config)
            local section = self:AddSection("")
            return section:AddTextbox(config)
        end
        
        function tab:AddBind(config)
            local section = self:AddSection("")
            return section:AddBind(config)
        end
        
        window.Tabs[tabId] = tab
        return tab
    end
    
    function window:Destroy()
        gui:Destroy()
        Oxireun.Windows[windowId] = nil
    end
    
    -- Set first tab as active
    if #window.Tabs > 0 then
        window.Tabs[1].Button.TextColor3 = Oxireun.Theme.Accent
    end
    
    Oxireun.Windows[windowId] = window
    return window
end

-- Initialize function
function Oxireun:Init()
    -- Auto-load configs
    if self.Config.AutoSave then
        if not isfolder(self.Config.Folder) then
            makefolder(self.Config.Folder)
        end
    end
    
    -- Welcome notification
    task.spawn(function()
        wait(1)
        self:Notify("Oxireun UI", "Library initialized successfully!", 3)
    end)
    
    print("Oxireun UI Library loaded!")
end

return Oxireun
