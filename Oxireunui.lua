-- Oxireun UI Library - Simple & Working Version
local Oxireun = {}

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game.CoreGui
end
ScreenGui.Name = "OxireunGUI"
ScreenGui.ResetOnSpawn = false

-- Helper Functions
local function CreateInstance(className, props)
    local obj = Instance.new(className)
    for prop, val in pairs(props) do
        if prop ~= "Parent" then
            obj[prop] = val
        end
    end
    return obj
end

-- Notification System
function Oxireun:Notify(title, message)
    local notification = CreateInstance("Frame", {
        Size = UDim2.new(0.25, 0, 0, 70),
        Position = UDim2.new(0.75, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(35, 30, 65),
        BorderSizePixel = 0,
        ZIndex = 1000,
        Parent = ScreenGui
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = notification
    })
    
    CreateInstance("UIStroke", {
        Color = Color3.fromRGB(0, 150, 255),
        Thickness = 3,
        Transparency = 0.3,
        Parent = notification
    })
    
    local topLine = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 150, 255),
        BorderSizePixel = 0,
        Parent = notification
    })
    
    local icon = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "🔔",
        TextColor3 = Color3.fromRGB(255, 200, 100),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = notification
    })
    
    local titleLabel = CreateInstance("TextLabel", {
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
    
    local messageLabel = CreateInstance("TextLabel", {
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
    
    -- Animate in
    notification:TweenPosition(
        UDim2.new(0.75, 0, 0.8, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.4,
        true
    )
    
    -- Remove after 3 seconds
    task.delay(3, function()
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

-- Create Window
function Oxireun:CreateWindow(windowName)
    windowName = windowName or "Oxireun UI"
    
    -- Main Window
    local MainWindow = CreateInstance("Frame", {
        Size = UDim2.fromScale(0.4, 0.75),
        Position = UDim2.fromScale(0.03, 0.1),
        BackgroundColor3 = Color3.fromRGB(25, 20, 45),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Parent = ScreenGui
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = MainWindow
    })
    
    CreateInstance("UIStroke", {
        Color = Color3.fromRGB(0, 150, 255),
        Thickness = 3,
        Transparency = 0.2,
        Parent = MainWindow
    })
    
    -- Top Bar
    local TopBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(30, 25, 60),
        BorderSizePixel = 0,
        Parent = MainWindow
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12, 0, 0),
        Parent = TopBar
    })
    
    -- Title
    CreateInstance("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = Color3.fromRGB(180, 200, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    -- Tab Container
    local TabContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        Parent = MainWindow
    })
    
    -- Content Area
    local ContentArea = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 90),
        BackgroundColor3 = Color3.fromRGB(30, 25, 55),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = MainWindow
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = ContentArea
    })
    
    -- Window object
    local WindowObj = {
        Tabs = {},
        MainWindow = MainWindow,
        ContentArea = ContentArea,
        TabContainer = TabContainer,
        CurrentTab = nil
    }
    
    -- Add Tab function
    function WindowObj:AddTab(tabName)
        local tabId = #self.Tabs + 1
        
        -- Tab Button
        local TabButton = CreateInstance("TextButton", {
            Size = UDim2.new(0.25, -5, 1, 0),
            Position = UDim2.new((tabId-1) * 0.25, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName:upper(),
            TextColor3 = Color3.fromRGB(150, 150, 180),
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            Parent = TabContainer
        })
        
        -- Content Frame
        local ContentFrame = CreateInstance("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255),
            ScrollBarImageTransparency = 0.7,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Visible = tabId == 1,
            Parent = ContentArea
        })
        
        CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = ContentFrame
        })
        
        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            Parent = ContentFrame
        })
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(self.Tabs) do
                tab.Button.TextColor3 = Color3.fromRGB(150, 150, 180)
                tab.Content.Visible = false
            end
            
            TabButton.TextColor3 = Color3.fromRGB(0, 150, 255)
            ContentFrame.Visible = true
            self.CurrentTab = tabId
        end)
        
        -- Set first tab as active
        if tabId == 1 then
            TabButton.TextColor3 = Color3.fromRGB(0, 150, 255)
            self.CurrentTab = 1
        end
        
        -- Create tab object
        local TabObj = {
            Button = TabButton,
            Content = ContentFrame
        }
        
        -- Element functions
        function TabObj:AddLabel(text)
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.fromRGB(180, 200, 255),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 999,
                Parent = ContentFrame
            })
            
            local LabelObj = {}
            function LabelObj:Set(newText)
                Label.Text = newText
            end
            
            return LabelObj
        end
        
        function TabObj:AddButton(config)
            config = config or {}
            config.Name = config.Name or "Button"
            config.Callback = config.Callback or function() end
            
            local Button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Color3.fromRGB(45, 45, 70),
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(0, 150, 255),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                LayoutOrder = 999,
                Parent = ContentFrame
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Button
            })
            
            -- Hover effects
            Button.MouseEnter:Connect(function()
                Button.BackgroundTransparency = 0.3
            end)
            
            Button.MouseLeave:Connect(function()
                Button.BackgroundTransparency = 0.5
            end)
            
            Button.MouseButton1Click:Connect(function()
                config.Callback()
            end)
            
            local ButtonObj = {}
            function ButtonObj:Set(newText)
                Button.Text = newText
            end
            
            return ButtonObj
        end
        
        function TabObj:AddToggle(config)
            config = config or {}
            config.Name = config.Name or "Toggle"
            config.Default = config.Default or false
            config.Callback = config.Callback or function() end
            
            local toggleValue = config.Default
            local ToggleObj = {Value = toggleValue}
            
            local ToggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                LayoutOrder = 999,
                Parent = ContentFrame
            })
            
            -- Toggle background
            local ToggleBg = CreateInstance("Frame", {
                Size = UDim2.new(0, 45, 0, 24),
                Position = UDim2.new(1, -50, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(180, 180, 190),
                BorderSizePixel = 0,
                Parent = ToggleFrame
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleBg
            })
            
            -- Toggle circle
            local ToggleCircle = CreateInstance("Frame", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = toggleValue and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Parent = ToggleBg
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleCircle
            })
            
            -- Label
            CreateInstance("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(0, 150, 255),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            -- Clickable button
            local ToggleBtn = CreateInstance("TextButton", {
                Size = UDim2.new(0, 45, 0, 24),
                Position = UDim2.new(1, -50, 0.5, -12),
                BackgroundTransparency = 1,
                Text = "",
                Parent = ToggleFrame
            })
            
            local function updateToggle()
                if toggleValue then
                    ToggleBg.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                    ToggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                else
                    ToggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                end
                ToggleObj.Value = toggleValue
                config.Callback(toggleValue)
            end
            
            ToggleBtn.MouseButton1Click:Connect(function()
                toggleValue = not toggleValue
                updateToggle()
            end)
            
            -- Initialize
            updateToggle()
            
            function ToggleObj:Set(value)
                toggleValue = value
                updateToggle()
            end
            
            return ToggleObj
        end
        
        function TabObj:AddSlider(config)
            config = config or {}
            config.Name = config.Name or "Slider"
            config.Min = config.Min or 0
            config.Max = config.Max or 100
            config.Default = config.Default or 50
            config.Callback = config.Callback or function() end
            
            local sliderValue = config.Default
            local SliderObj = {Value = sliderValue}
            
            local SliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundTransparency = 1,
                LayoutOrder = 999,
                Parent = ContentFrame
            })
            
            -- Labels
            CreateInstance("TextLabel", {
                Size = UDim2.new(0.5, 0, 0, 20),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(0, 150, 255),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            local ValueLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.5, 0, 0, 20),
                Position = UDim2.new(0.5, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = sliderValue .. "",
                TextColor3 = Color3.fromRGB(180, 200, 255),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame
            })
            
            -- Slider bar
            local SliderBg = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 6),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundColor3 = Color3.fromRGB(50, 50, 75),
                BorderSizePixel = 0,
                Parent = SliderFrame
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderBg
            })
            
            local SliderFill = CreateInstance("Frame", {
                Size = UDim2.new(sliderValue/config.Max, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(0, 150, 255),
                BorderSizePixel = 0,
                Parent = SliderBg
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderFill
            })
            
            local SliderHandle = CreateInstance("TextButton", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(sliderValue/config.Max, -8, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = SliderBg
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderHandle
            })
            
            CreateInstance("UIStroke", {
                Color = Color3.fromRGB(0, 150, 255),
                Thickness = 2,
                Parent = SliderHandle
            })
            
            -- Slider logic
            local sliding = false
            
            local function updateSlider(value)
                sliderValue = math.clamp(value, config.Min, config.Max)
                local percent = (sliderValue - config.Min) / (config.Max - config.Min)
                
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
                ValueLabel.Text = sliderValue .. ""
                
                SliderObj.Value = sliderValue
                config.Callback(sliderValue)
            end
            
            local function startSliding()
                sliding = true
                ContentFrame.ScrollingEnabled = false
            end
            
            local function stopSliding()
                sliding = false
                ContentFrame.ScrollingEnabled = true
            end
            
            SliderHandle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    startSliding()
                end
            end)
            
            SliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = Player:GetMouse()
                    local absPos = SliderBg.AbsolutePosition
                    local absSize = SliderBg.AbsoluteSize
                    
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
            
            RunService.RenderStepped:Connect(function()
                if sliding then
                    local mouse = Player:GetMouse()
                    local absPos = SliderBg.AbsolutePosition
                    local absSize = SliderBg.AbsoluteSize
                    
                    local relativeX = (mouse.X - absPos.X) / absSize.X
                    updateSlider(relativeX * (config.Max - config.Min) + config.Min)
                end
            end)
            
            -- Initialize
            updateSlider(sliderValue)
            
            function SliderObj:Set(value)
                updateSlider(value)
            end
            
            return SliderObj
        end
        
        function TabObj:AddTextbox(config)
            config = config or {}
            config.Name = config.Name or "Textbox"
            config.Default = config.Default or ""
            config.Callback = config.Callback or function() end
            
            local TextboxFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                LayoutOrder = 999,
                Parent = ContentFrame
            })
            
            -- Label
            CreateInstance("TextLabel", {
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(0, 150, 255),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TextboxFrame
            })
            
            -- Textbox
            local Textbox = CreateInstance("TextBox", {
                Size = UDim2.new(1, -110, 1, 0),
                Position = UDim2.new(0, 110, 0, 0),
                BackgroundColor3 = Color3.fromRGB(45, 40, 75),
                BackgroundTransparency = 0.6,
                BorderSizePixel = 0,
                Text = config.Default,
                TextColor3 = Color3.fromRGB(220, 220, 240),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                PlaceholderColor3 = Color3.fromRGB(150, 150, 170),
                PlaceholderText = "Enter",
                Parent = TextboxFrame
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Textbox
            })
            
            Textbox.FocusLost:Connect(function()
                config.Callback(Textbox.Text)
            end)
            
            local TextboxObj = {}
            function TextboxObj:Set(value)
                Textbox.Text = value
            end
            
            return TextboxObj
        end
        
        -- Add to tabs table
        table.insert(self.Tabs, TabObj)
        
        return TabObj
    end
    
    -- Destroy function
    function WindowObj:Destroy()
        MainWindow:Destroy()
    end
    
    return WindowObj
end

-- Init function
function Oxireun:Init()
    task.wait(1)
    self:Notify("Oxireun UI", "Library loaded successfully!")
    print("Oxireun UI Library initialized!")
end

return Oxireun
