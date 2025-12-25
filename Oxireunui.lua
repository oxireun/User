--[[
    Oxireun UI Library v1.0
    Blade Runner 2049 Temalı Roblox GUI Kütüphanesi
    GitHub: https://github.com/oxireun
    Tasarım: Blade Runner 2049 Teması
]]

local Oxireun = {}
local themes = {}
local windows = {}
local connections = {}

-- Servisler
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- TEMALAR
themes.BladeRunner = {
    Primary = Color3.fromRGB(0, 150, 255),
    Secondary = Color3.fromRGB(25, 20, 45),
    Background = Color3.fromRGB(30, 25, 60),
    Text = Color3.fromRGB(180, 200, 255),
    TextSecondary = Color3.fromRGB(150, 150, 180),
    Accent = Color3.fromRGB(0, 150, 255),
    Danger = Color3.fromRGB(240, 120, 130),
    Success = Color3.fromRGB(0, 200, 150)
}

themes.Cyberpunk = {
    Primary = Color3.fromRGB(255, 0, 150),
    Secondary = Color3.fromRGB(20, 15, 40),
    Background = Color3.fromRGB(35, 25, 65),
    Text = Color3.fromRGB(255, 200, 220),
    TextSecondary = Color3.fromRGB(180, 150, 190),
    Accent = Color3.fromRGB(255, 0, 150),
    Danger = Color3.fromRGB(255, 100, 100),
    Success = Color3.fromRGB(0, 255, 150)
}

themes.Matrix = {
    Primary = Color3.fromRGB(0, 255, 0),
    Secondary = Color3.fromRGB(10, 15, 10),
    Background = Color3.fromRGB(20, 25, 20),
    Text = Color3.fromRGB(0, 255, 0),
    TextSecondary = Color3.fromRGB(0, 200, 0),
    Accent = Color3.fromRGB(0, 255, 0),
    Danger = Color3.fromRGB(255, 50, 50),
    Success = Color3.fromRGB(0, 255, 100)
}

-- YARDIMCI FONKSİYONLAR
local function CreateInstance(className, properties)
    local obj = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            obj[prop] = value
        end
    end
    return obj
end

local function RippleEffect(button)
    local ripple = CreateInstance("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.8,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Parent = button,
        ZIndex = 10
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })
    
    local mousePos = UserInputService:GetMouseLocation()
    local buttonPos = button.AbsolutePosition
    local buttonSize = button.AbsoluteSize
    
    ripple.Position = UDim2.new(
        0, (mousePos.X - buttonPos.X),
        0, (mousePos.Y - buttonPos.Y)
    )
    
    ripple:TweenSize(
        UDim2.new(2, 0, 2, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.5,
        true,
        function()
            ripple:Destroy()
        end
    )
    
    local tween = TweenService:Create(
        ripple,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    )
    tween:Play()
end

-- ANA PENCERE SINIFI
local Window = {}
Window.__index = Window

function Window.new(title, themeName)
    local self = setmetatable({}, Window)
    
    self.Title = title or "Oxireun UI"
    self.Theme = themes[themeName] or themes.BladeRunner
    self.Sections = {}
    self.Open = true
    
    -- Ana GUI
    self.Gui = CreateInstance("ScreenGui", {
        Name = "OxireunUI_" .. title,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Ana pencere
    self.MainFrame = CreateInstance("Frame", {
        Name = "MainWindow",
        Size = UDim2.fromScale(0.4, 0.7),
        Position = UDim2.fromScale(0.03, 0.15),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Parent = self.Gui
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = self.MainFrame
    })
    
    -- Neon border
    CreateInstance("UIStroke", {
        Color = self.Theme.Primary,
        Thickness = 3,
        Transparency = 0.2,
        Parent = self.MainFrame
    })
    
    -- Üst bar
    self.TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12, 0, 0),
        Parent = self.TopBar
    })
    
    -- Üst bar çizgisi
    CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = self.Theme.Primary,
        BorderSizePixel = 0,
        Parent = self.TopBar
    })
    
    -- Başlık
    CreateInstance("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TopBar
    })
    
    -- Kontrol butonları
    local controlButtons = CreateInstance("Frame", {
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -65, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.TopBar
    })
    
    -- Close butonu
    local closeBtn = CreateInstance("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 30, 0.5, -13),
        BackgroundColor3 = Color3.fromRGB(70, 40, 50),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Text = "",
        Parent = controlButtons
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = closeBtn
    })
    
    local closeLine1 = CreateInstance("Frame", {
        Size = UDim2.new(0, 12, 0, 2),
        Position = UDim2.new(0.5, -6, 0.5, -1),
        BackgroundColor3 = Color3.fromRGB(240, 120, 130),
        BorderSizePixel = 0,
        Rotation = 45,
        Parent = closeBtn
    })
    
    local closeLine2 = CreateInstance("Frame", {
        Size = UDim2.new(0, 12, 0, 2),
        Position = UDim2.new(0.5, -6, 0.5, -1),
        BackgroundColor3 = Color3.fromRGB(240, 120, 130),
        BorderSizePixel = 0,
        Rotation = -45,
        Parent = closeBtn
    })
    
    -- Close butonu event'leri
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
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- İçerik alanı
    self.ContentArea = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -70),
        Position = UDim2.new(0, 10, 0, 60),
        BackgroundColor3 = Color3.fromRGB(30, 25, 55),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Theme.Primary,
        ScrollBarImageTransparency = 0.7,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = self.MainFrame
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = self.ContentArea
    })
    
    self.ContentList = CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = self.ContentArea
    })
    
    self.ContentPadding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = self.ContentArea
    })
    
    table.insert(windows, self)
    self.Gui.Parent = game:GetService("CoreGui")
    
    return self
end

function Window:NewSection(name)
    local section = {
        Name = name,
        Elements = {},
        Order = #self.Sections + 1
    }
    
    -- Section container
    section.Container = CreateInstance("Frame", {
        Name = name .. "_Section",
        Size = UDim2.new(1, -20, 0, 0),
        BackgroundColor3 = Color3.fromRGB(35, 30, 65),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        LayoutOrder = section.Order,
        Parent = self.ContentArea
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = section.Container
    })
    
    -- Section başlığı
    section.Title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = string.upper(name),
        TextColor3 = self.Theme.Primary,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section.Container
    })
    
    -- Section alt çizgisi
    CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = self.Theme.Primary,
        BorderSizePixel = 0,
        Transparency = 0.3,
        Parent = section.Container
    })
    
    -- Elementler için container
    section.ElementsContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Parent = section.Container
    })
    
    section.ElementsList = CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = section.ElementsContainer
    })
    
    -- Section metodları
    function section:UpdateSize()
        local totalHeight = 30 + (section.ElementsList.AbsoluteContentSize.Y)
        section.Container.Size = UDim2.new(1, -20, 0, totalHeight)
        self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, self.ContentList.AbsoluteContentSize.Y + 20)
    end
    
    -- Buton oluşturma
    function section:CreateButton(name, callback)
        local button = CreateInstance("TextButton", {
            Name = name .. "_Button",
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(45, 45, 70),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = self.Theme.Primary,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            LayoutOrder = #section.Elements + 1,
            Parent = section.ElementsContainer
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = button
        })
        
        -- Hover efekti
        button.MouseEnter:Connect(function()
            button.BackgroundTransparency = 0.3
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundTransparency = 0.5
        end)
        
        -- Tıklama efekti
        button.MouseButton1Click:Connect(function()
            RippleEffect(button)
            if callback then
                callback()
            else
                print("[" .. self.Title .. "] " .. name .. " butonuna tıklandı!")
            end
        end)
        
        table.insert(section.Elements, button)
        section:UpdateSize()
        
        return button
    end
    
    -- Textbox oluşturma
    function section:CreateTextbox(name, placeholder, callback)
        local textboxFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            LayoutOrder = #section.Elements + 1,
            Parent = section.ElementsContainer
        })
        
        local textboxLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 80, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Theme.Primary,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = textboxFrame
        })
        
        local textbox = CreateInstance("TextBox", {
            Size = UDim2.new(1, -90, 1, 0),
            Position = UDim2.new(0, 90, 0, 0),
            BackgroundColor3 = Color3.fromRGB(45, 40, 75),
            BackgroundTransparency = 0.6,
            BorderSizePixel = 0,
            Text = "",
            PlaceholderText = placeholder or "Enter text...",
            TextColor3 = Color3.fromRGB(220, 220, 240),
            PlaceholderColor3 = Color3.fromRGB(150, 150, 170),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Parent = textboxFrame
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = textbox
        })
        
        -- Focus efekti
        textbox.Focused:Connect(function()
            textbox.BackgroundTransparency = 0.5
        end)
        
        textbox.FocusLost:Connect(function(enterPressed)
            textbox.BackgroundTransparency = 0.6
            if enterPressed and callback then
                callback(textbox.Text)
            elseif enterPressed then
                print("[" .. self.Title .. "] " .. name .. " textbox: " .. textbox.Text)
            end
        end)
        
        table.insert(section.Elements, textboxFrame)
        section:UpdateSize()
        
        return textbox
    end
    
    -- Toggle oluşturma
    function section:CreateToggle(name, default, callback)
        local toggleFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            LayoutOrder = #section.Elements + 1,
            Parent = section.ElementsContainer
        })
        
        local toggleLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Theme.Primary,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = toggleFrame
        })
        
        -- Toggle background
        local toggleBg = CreateInstance("Frame", {
            Size = UDim2.new(0, 45, 0, 24),
            Position = UDim2.new(1, -50, 0.5, -12),
            BackgroundColor3 = Color3.fromRGB(180, 180, 190),
            BorderSizePixel = 0,
            Parent = toggleFrame
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = toggleBg
        })
        
        -- Toggle circle
        local toggleCircle = CreateInstance("Frame", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 2, 0.5, -10),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Parent = toggleBg
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = toggleCircle
        })
        
        -- Toggle butonu
        local toggleBtn = CreateInstance("TextButton", {
            Size = UDim2.new(0, 45, 0, 24),
            Position = UDim2.new(1, -50, 0.5, -12),
            BackgroundTransparency = 1,
            Text = "",
            Parent = toggleFrame
        })
        
        local state = default or false
        
        -- Başlangıç durumu
        if state then
            toggleBg.BackgroundColor3 = self.Theme.Primary
            toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
        end
        
        -- Toggle fonksiyonu
        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            
            if state then
                -- Açık
                toggleBg.BackgroundColor3 = self.Theme.Primary
                toggleCircle:TweenPosition(
                    UDim2.new(1, -22, 0.5, -10),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quad,
                    0.2,
                    true
                )
                if callback then
                    callback(true)
                else
                    print("[" .. self.Title .. "] " .. name .. " toggle: ON")
                end
            else
                -- Kapalı
                toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                toggleCircle:TweenPosition(
                    UDim2.new(0, 2, 0.5, -10),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quad,
                    0.2,
                    true
                )
                if callback then
                    callback(false)
                else
                    print("[" .. self.Title .. "] " .. name .. " toggle: OFF")
                end
            end
        end)
        
        -- Hover efekti
        toggleBtn.MouseEnter:Connect(function()
            toggleBg.BackgroundTransparency = 0.1
        end)
        
        toggleBtn.MouseLeave:Connect(function()
            toggleBg.BackgroundTransparency = 0
        end)
        
        table.insert(section.Elements, toggleFrame)
        section:UpdateSize()
        
        return {
            Set = function(value)
                state = value
                if state then
                    toggleBg.BackgroundColor3 = self.Theme.Primary
                    toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                else
                    toggleBg.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
                end
            end,
            Get = function()
                return state
            end
        }
    end
    
    -- Dropdown oluşturma
    function section:CreateDropdown(name, options, default, callback)
        local dropdownFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            LayoutOrder = #section.Elements + 1,
            Parent = section.ElementsContainer
        })
        
        local dropdownLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 80, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Theme.Primary,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = dropdownFrame
        })
        
        local dropdownBtn = CreateInstance("TextButton", {
            Size = UDim2.new(1, -90, 1, 0),
            Position = UDim2.new(0, 90, 0, 0),
            BackgroundColor3 = Color3.fromRGB(60, 50, 90),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = options[default or 1] or "Select",
            TextColor3 = Color3.fromRGB(220, 220, 240),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Parent = dropdownFrame
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = dropdownBtn
        })
        
        -- Dropdown arrow
        local arrow = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(1, -25, 0, 0),
            BackgroundTransparency = 1,
            Text = "▼",
            TextColor3 = self.Theme.Primary,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            Parent = dropdownBtn
        })
        
        -- Dropdown options panel
        local dropdownOptions = CreateInstance("Frame", {
            Size = UDim2.new(0, 150, 0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(40, 35, 70),
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = 100,
            Parent = self.Gui
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = dropdownOptions
        })
        
        CreateInstance("UIStroke", {
            Color = self.Theme.Primary,
            Thickness = 2,
            Transparency = 0.3,
            Parent = dropdownOptions
        })
        
        -- Options list
        local optionsList = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = dropdownOptions
        })
        
        local optionsPadding = CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            Parent = dropdownOptions
        })
        
        -- Create option buttons
        local optionButtons = {}
        for i, option in ipairs(options) do
            local optionBtn = CreateInstance("TextButton", {
                Size = UDim2.new(1, -10, 0, 25),
                BackgroundColor3 = Color3.fromRGB(55, 45, 85),
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Text = option,
                TextColor3 = Color3.fromRGB(220, 220, 240),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                LayoutOrder = i,
                ZIndex = 101,
                Parent = dropdownOptions
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 5),
                Parent = optionBtn
            })
            
            -- Hover efekti
            optionBtn.MouseEnter:Connect(function()
                optionBtn.BackgroundTransparency = 0.3
                optionBtn.BackgroundColor3 = Color3.fromRGB(65, 55, 95)
            end)
            
            optionBtn.MouseLeave:Connect(function()
                optionBtn.BackgroundTransparency = 0.5
                optionBtn.BackgroundColor3 = Color3.fromRGB(55, 45, 85)
            end)
            
            -- Click event
            optionBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                dropdownOptions.Visible = false
                arrow.Text = "▼"
                
                if callback then
                    callback(option)
                else
                    print("[" .. self.Title .. "] " .. name .. " dropdown: " .. option)
                end
            end)
            
            table.insert(optionButtons, optionBtn)
        end
        
        -- Update options size
        dropdownOptions.Size = UDim2.new(0, 150, 0, #options * 30 + 10)
        
        -- Dropdown toggle
        local dropdownOpen = false
        
        local function closeDropdown()
            dropdownOptions.Visible = false
            dropdownOpen = false
            arrow.Text = "▼"
        end
        
        dropdownBtn.MouseButton1Click:Connect(function()
            dropdownOpen = not dropdownOpen
            
            if dropdownOpen then
                local btnPos = dropdownBtn.AbsolutePosition
                local btnSize = dropdownBtn.AbsoluteSize
                
                dropdownOptions.Position = UDim2.new(
                    0, btnPos.X,
                    0, btnPos.Y + btnSize.Y + 5
                )
                dropdownOptions.Visible = true
                arrow.Text = "▲"
                
                -- Bring to front
                dropdownOptions.ZIndex = 100
                for _, btn in ipairs(optionButtons) do
                    btn.ZIndex = 101
                end
            else
                closeDropdown()
            end
        end)
        
        -- Close dropdown when clicking outside
        local closeConnection
        closeConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos = input.Position
                local dropdownPos = dropdownOptions.AbsolutePosition
                local dropdownSize = dropdownOptions.AbsoluteSize
                
                if dropdownOpen and 
                   not (mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                        mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y) and
                   not (mousePos.X >= dropdownBtn.AbsolutePosition.X and mousePos.X <= dropdownBtn.AbsolutePosition.X + dropdownBtn.AbsoluteSize.X and
                        mousePos.Y >= dropdownBtn.AbsolutePosition.Y and mousePos.Y <= dropdownBtn.AbsolutePosition.Y + dropdownBtn.AbsoluteSize.Y) then
                    closeDropdown()
                end
            end
        end)
        
        table.insert(connections, closeConnection)
        
        table.insert(section.Elements, dropdownFrame)
        section:UpdateSize()
        
        return {
            Set = function(value)
                if table.find(options, value) then
                    dropdownBtn.Text = value
                end
            end,
            Get = function()
                return dropdownBtn.Text
            end
        }
    end
    
    -- Slider oluşturma
    function section:CreateSlider(name, min, max, default, callback)
        local sliderFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 1,
            LayoutOrder = #section.Elements + 1,
            Parent = section.ElementsContainer
        })
        
        local sliderLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Theme.Primary,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = sliderFrame
        })
        
        -- Slider değer gösterimi
        local sliderValue = default or min
        local valueLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 50, 0, 20),
            Position = UDim2.new(1, -50, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(sliderValue),
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = sliderFrame
        })
        
        -- Slider background
        local sliderBg = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 6),
            Position = UDim2.new(0, 0, 0, 25),
            BackgroundColor3 = Color3.fromRGB(50, 50, 75),
            BorderSizePixel = 0,
            Parent = sliderFrame
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = sliderBg
        })
        
        -- Slider fill
        local sliderFill = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = self.Theme.Primary,
            BorderSizePixel = 0,
            Parent = sliderBg
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = sliderFill
        })
        
        -- Slider handle
        local sliderHandle = CreateInstance("TextButton", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, -8, 0.5, -8),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = sliderBg
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = sliderHandle
        })
        
        CreateInstance("UIStroke", {
            Color = self.Theme.Primary,
            Thickness = 2,
            Parent = sliderHandle
        })
        
        -- Slider logic
        local sliding = false
        
        local function updateSlider(value)
            local percent = (value - min) / (max - min)
            percent = math.clamp(percent, 0, 1)
            
            sliderValue = math.floor(value)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderHandle.Position = UDim2.new(percent, -8, 0.5, -8)
            valueLabel.Text = tostring(sliderValue)
            
            if callback then
                callback(sliderValue)
            else
                print("[" .. self.Title .. "] " .. name .. " slider: " .. sliderValue)
            end
        end
        
        -- Başlangıç değeri
        updateSlider(default or min)
        
        -- Slider drag
        local function startSliding()
            sliding = true
            
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if sliding then
                    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                    local sliderAbsPos = sliderBg.AbsolutePosition
                    local sliderAbsSize = sliderBg.AbsoluteSize
                    
                    local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                    relativeX = math.clamp(relativeX, 0, 1)
                    
                    local value = min + (relativeX * (max - min))
                    updateSlider(value)
                else
                    connection:Disconnect()
                end
            end)
        end
        
        local function stopSliding()
            sliding = false
        end
        
        sliderHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                startSliding()
            end
        end)
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local sliderAbsPos = sliderBg.AbsolutePosition
                local sliderAbsSize = sliderBg.AbsoluteSize
                
                local relativeX = (mouse.X - sliderAbsPos.X) / sliderAbsSize.X
                relativeX = math.clamp(relativeX, 0, 1)
                
                local value = min + (relativeX * (max - min))
                updateSlider(value)
                startSliding()
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                stopSliding()
            end
        end)
        
        table.insert(section.Elements, sliderFrame)
        section:UpdateSize()
        
        return {
            Set = function(value)
                updateSlider(math.clamp(value, min, max))
            end,
            Get = function()
                return sliderValue
            end
        }
    end
    
    -- Label oluşturma
    function section:CreateLabel(text)
        local label = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = self.Theme.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = #section.Elements + 1,
            Parent = section.ElementsContainer
        })
        
        table.insert(section.Elements, label)
        section:UpdateSize()
        
        return label
    end
    
    -- Notification fonksiyonu (isteğe bağlı)
    function section:Notification(title, text, duration)
        duration = duration or 3
        
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration,
            Icon = "rbxassetid://4483345998"
        })
    end
    
    table.insert(self.Sections, section)
    
    -- Auto-update section size
    section.ElementsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section:UpdateSize()
    end)
    
    return section
end

function Window:Destroy()
    for _, connection in ipairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    if self.Gui then
        self.Gui:Destroy()
    end
    
    for i, win in ipairs(windows) do
        if win == self then
            table.remove(windows, i)
            break
        end
    end
    
    self.Open = false
end

function Window:Toggle()
    self.Open = not self.Open
    self.MainFrame.Visible = self.Open
end

-- KÜTÜPHANE FONKSİYONLARI
function Oxireun:NewWindow(title, theme)
    return Window.new(title, theme)
end

function Oxireun:GetWindows()
    return windows
end

function Oxireun:CloseAll()
    for _, win in ipairs(windows) do
        win:Destroy()
    end
    table.clear(windows)
end

function Oxireun:AddTheme(name, themeTable)
    themes[name] = themeTable
end

function Oxireun:GetThemes()
    return themes
end

-- KÜTÜPHANE YÜKLEME FONKSİYONU
function Oxireun:Load()
    print("Oxireun UI Library v1.0 yüklendi!")
    print("Temalar: " .. table.concat(table.keys(themes), ", "))
    return Oxireun
end

-- GitHub raw link için dışa aktarma
return Oxireun:Load()
