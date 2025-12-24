-- OxireunUI Library (Wizard-like)
-- Single-file UI library. Usage example at bottom.
-- Knk: Buton/toggle sadece print yapar. GUI açılırken notification yok.

local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Theme
local THEME = {
    MainBg = Color3.fromRGB(25, 20, 45),
    TopBar = Color3.fromRGB(30, 25, 60),
    Accent = Color3.fromRGB(0, 150, 255),
    SectionBg = Color3.fromRGB(35, 30, 65),
    ContentBg = Color3.fromRGB(30, 25, 55),
    Text = Color3.fromRGB(180, 200, 255),
    SecondaryText = Color3.fromRGB(200, 220, 240),
    Light = Color3.fromRGB(255,255,255)
}

-- Utility helpers
local function new(class, parent)
    local obj = Instance.new(class)
    if parent then obj.Parent = parent end
    return obj
end

local function clamp(v, a, b) return math.max(a, math.min(b, v)) end

-- Create base ScreenGui
function Library:NewWindow(title)
    local selfWindow = {}
    selfWindow.sections = {}
    setmetatable(selfWindow, {__index = Library.WindowMethods})

    -- ScreenGui
    local gui = new("ScreenGui", game.CoreGui)
    gui.Name = "OxireunUI_" .. tostring(math.random(1000,9999))
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local main = new("Frame", gui)
    main.Size = UDim2.fromScale(0.42, 0.78)
    main.Position = UDim2.fromScale(0.03, 0.08)
    main.BackgroundColor3 = THEME.MainBg
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Name = "MainWindow"

    local mainCorner = new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, 12)

    local mainGlow = new("UIStroke", main)
    mainGlow.Color = THEME.Accent
    mainGlow.Thickness = 3
    mainGlow.Transparency = 0.2

    -- Top bar
    local topBar = new("Frame", main)
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = THEME.TopBar
    topBar.BorderSizePixel = 0
    topBar.Name = "TopBar"
    local topBarCorner = new("UICorner", topBar)
    topBarCorner.CornerRadius = UDim.new(0, 12)

    local topBarLine = new("Frame", topBar)
    topBarLine.Size = UDim2.new(1, 0, 0, 2)
    topBarLine.Position = UDim2.new(0, 0, 1, -2)
    topBarLine.BackgroundColor3 = THEME.Accent
    topBarLine.BorderSizePixel = 0
    topBarLine.Name = "TopBarLine"

    -- Title
    local titleLabel = new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(0, 260, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "OXIREUN"
    titleLabel.TextColor3 = THEME.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Control buttons (minimize, close)
    local controlButtons = new("Frame", topBar)
    controlButtons.Size = UDim2.new(0, 60, 1, 0)
    controlButtons.Position = UDim2.new(1, -65, 0, 0)
    controlButtons.BackgroundTransparency = 1

    local function makeSmallBtn(parent, xPos)
        local btn = new("TextButton", parent)
        btn.Size = UDim2.new(0, 26, 0, 26)
        btn.Position = UDim2.new(0, xPos, 0.5, -13)
        btn.BackgroundColor3 = Color3.fromRGB(60,60,80)
        btn.BackgroundTransparency = 0.6
        btn.BorderSizePixel = 0
        btn.Text = ""
        local c = new("UICorner", btn); c.CornerRadius = UDim.new(0,6)
        return btn
    end

    local minimizeBtn = makeSmallBtn(controlButtons, 0)
    local closeBtn = makeSmallBtn(controlButtons, 30)

    -- Title area done

    -- Tab container (display section tabs)
    local tabContainer = new("Frame", main)
    tabContainer.Size = UDim2.new(1, -20, 0, 35)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1

    local activeTabLine = new("Frame", tabContainer)
    activeTabLine.Size = UDim2.new(0.25, -10, 0, 3)
    activeTabLine.Position = UDim2.new(0, 5, 1, -3)
    activeTabLine.BackgroundColor3 = THEME.Accent
    activeTabLine.BorderSizePixel = 0
    new("UICorner", activeTabLine).CornerRadius = UDim.new(1,0)

    -- Content area (where sections are shown)
    local contentArea = new("Frame", main)
    contentArea.Size = UDim2.new(1, -20, 1, -100)
    contentArea.Position = UDim2.new(0, 10, 0, 90)
    contentArea.BackgroundColor3 = THEME.ContentBg
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    new("UICorner", contentArea).CornerRadius = UDim.new(0,8)

    -- content container to hold section frames horizontally
    local contentContainer = new("Frame", contentArea)
    contentContainer.Size = UDim2.new(4,0,1,0) -- will expand as more sections added
    contentContainer.Position = UDim2.new(0,0,0,0)
    contentContainer.BackgroundTransparency = 1

    -- store references
    selfWindow._gui = gui
    selfWindow._main = main
    selfWindow._tabContainer = tabContainer
    selfWindow._contentArea = contentArea
    selfWindow._contentContainer = contentContainer
    selfWindow._activeTabLine = activeTabLine
    selfWindow._tabs = {}
    selfWindow._currentTab = 1

    -- Minimize logic
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            main.Size = UDim2.fromScale(0.42, 0.12)
            contentArea.Visible = false
            tabContainer.Visible = false
            topBarLine.Visible = false
        else
            main.Size = UDim2.fromScale(0.42, 0.78)
            contentArea.Visible = true
            tabContainer.Visible = true
            topBarLine.Visible = true
        end
    end)

    -- Close logic
    closeBtn.MouseButton1Click:Connect(function()
        pcall(function() gui:Destroy() end)
    end)

    -- Public method to create sections
    function selfWindow:NewSection(name)
        local index = #selfWindow.sections + 1
        local sec = {}

        -- create tab button
        local tabBtn = new("TextButton", selfWindow._tabContainer)
        tabBtn.Size = UDim2.new(0.25, -5, 1, 0)
        tabBtn.Position = UDim2.new((index-1)*0.25, 0, 0, 0)
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = name or ("Tab "..index)
        tabBtn.TextColor3 = Color3.fromRGB(150,150,180)
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 12

        tabBtn.MouseEnter:Connect(function() tabBtn.TextColor3 = Color3.fromRGB(200,220,255) end)
        tabBtn.MouseLeave:Connect(function() if not tabBtn.Active then tabBtn.TextColor3 = Color3.fromRGB(150,150,180) end end)

        -- create section frame in contentContainer
        local secFrame = new("Frame", selfWindow._contentContainer)
        secFrame.Size = UDim2.new(0.25, 0, 1, 0)
        secFrame.Position = UDim2.new((index-1)*0.25, 0, 0, 0)
        secFrame.BackgroundTransparency = 1

        -- within section, create scrolling frame for items
        local scroll = new("ScrollingFrame", secFrame)
        scroll.Size = UDim2.new(1,0,1,0)
        scroll.Position = UDim2.new(0,0,0,0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 6
        scroll.ScrollingDirection = Enum.ScrollingDirection.Y
        scroll.CanvasSize = UDim2.new(0,0,0,0)

        local scrollContent = new("Frame", scroll)
        scrollContent.Size = UDim2.new(1,0,0,10)
        scrollContent.Position = UDim2.new(0,0,0,0)
        scrollContent.BackgroundTransparency = 1
        scrollContent.LayoutOrder = 1

        local layout = new("UIListLayout", scrollContent)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0,8)

        -- helper to resize canvas
        local function refreshCanvas()
            local total = 0
            for _,v in ipairs(scrollContent:GetChildren()) do
                if v:IsA("Frame") then
                    total = total + v.Size.Y.Offset + (layout.Padding.Offset)
                end
            end
            scrollContent.Size = UDim2.new(1,0,0,total + 10)
            scroll.CanvasSize = UDim2.new(0,0,0, scrollContent.AbsoluteSize.Y)
        end

        -- SECTION API
        sec._parentWindow = selfWindow
        sec._name = name
        sec._frame = secFrame
        sec._scroll = scroll
        sec._content = scrollContent
        sec._refresh = refreshCanvas

        -- Create a titled section header inside the scroll content
        local header = new("Frame", scrollContent)
        header.Size = UDim2.new(1,-10,0,40)
        header.BackgroundTransparency = 1
        header.LayoutOrder = 1
        header.Position = UDim2.new(0,5,0,5)
        local hTitle = new("TextLabel", header)
        hTitle.Size = UDim2.new(1,0,1,0)
        hTitle.BackgroundTransparency = 1
        hTitle.Text = string.upper(name or "SECTION")
        hTitle.TextColor3 = THEME.Accent
        hTitle.Font = Enum.Font.GothamBold
        hTitle.TextSize = 14
        hTitle.TextXAlignment = Enum.TextXAlignment.Left

        -- element creators
        function sec:CreateButton(text, callback)
            local row = new("Frame", self._content)
            row.Size = UDim2.new(1, -20, 0, 34)
            row.BackgroundTransparency = 1
            row.LayoutOrder = 2

            local btn = new("TextButton", row)
            btn.Size = UDim2.new(1,0,1,0)
            btn.Position = UDim2.new(0,0,0,0)
            btn.BackgroundColor3 = Color3.fromRGB(45,45,70)
            btn.BackgroundTransparency = 0.45
            btn.BorderSizePixel = 0
            btn.Text = text or "Button"
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 13
            btn.TextColor3 = THEME.Accent
            new("UICorner", btn).CornerRadius = UDim.new(0,6)

            btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0.3 end)
            btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 0.45 end)

            btn.MouseButton1Click:Connect(function()
                -- by request: only print by default; call callback if provided
                print("[OxireunUI] Button pressed:", text)
                if type(callback) == "function" then
                    pcall(callback)
                end
            end)

            self:_refresh()
            return btn
        end

        function sec:CreateTextbox(labelText, callback)
            local row = new("Frame", self._content)
            row.Size = UDim2.new(1,-20,0,36)
            row.BackgroundTransparency = 1
            row.LayoutOrder = 3

            local lbl = new("TextLabel", row)
            lbl.Size = UDim2.new(0,110,1,0)
            lbl.Position = UDim2.new(0,0,0,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText or "Text:"
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextColor3 = THEME.Accent
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local box = new("TextBox", row)
            box.Size = UDim2.new(1,-120,1,0)
            box.Position = UDim2.new(0,120,0,0)
            box.BackgroundColor3 = Color3.fromRGB(45,40,75)
            box.BackgroundTransparency = 0.6
            box.BorderSizePixel = 0
            box.Text = ""
            box.TextColor3 = THEME.SecondaryText
            box.Font = Enum.Font.Gotham
            box.TextSize = 12
            box.PlaceholderText = "Enter"
            new("UICorner", box).CornerRadius = UDim.new(0,6)

            box.FocusLost:Connect(function(enterPressed)
                print("[OxireunUI] Textbox '"..tostring(labelText).."':", box.Text)
                if type(callback) == "function" then
                    pcall(callback, box.Text)
                end
            end)

            self:_refresh()
            return box
        end

        function sec:CreateToggle(labelText, callback)
            local row = new("Frame", self._content)
            row.Size = UDim2.new(1,-20,0,30)
            row.BackgroundTransparency = 1
            row.LayoutOrder = 4

            local lbl = new("TextLabel", row)
            lbl.Size = UDim2.new(1,-70,1,0)
            lbl.Position = UDim2.new(0,0,0,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText or "Toggle:"
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextColor3 = THEME.Accent
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local toggleBg = new("Frame", row)
            toggleBg.Size = UDim2.new(0,45,0,24)
            toggleBg.Position = UDim2.new(1, -60, 0.5, -12)
            toggleBg.BackgroundColor3 = Color3.fromRGB(180,180,190)
            toggleBg.BorderSizePixel = 0
            new("UICorner", toggleBg).CornerRadius = UDim.new(1,0)

            local toggleCircle = new("Frame", toggleBg)
            toggleCircle.Size = UDim2.new(0,20,0,20)
            toggleCircle.Position = UDim2.new(0,2,0.5,-10)
            toggleCircle.BackgroundColor3 = THEME.Light
            toggleCircle.BorderSizePixel = 0
            new("UICorner", toggleCircle).CornerRadius = UDim.new(1,0)

            local state = false
            local btn = new("TextButton", row)
            btn.Size = toggleBg.Size
            btn.Position = toggleBg.Position
            btn.BackgroundTransparency = 1
            btn.Text = ""

            btn.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    toggleBg.BackgroundColor3 = THEME.Accent
                    toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                else
                    toggleBg.BackgroundColor3 = Color3.fromRGB(180,180,190)
                    toggleCircle.Position = UDim2.new(0,2,0.5,-10)
                end
                print("[OxireunUI] Toggle '"..tostring(labelText).."':", state)
                if type(callback) == "function" then
                    pcall(callback, state)
                end
            end)

            self:_refresh()
            return {
                Set = function(_, val)
                    state = not not val
                    if state then
                        toggleBg.BackgroundColor3 = THEME.Accent
                        toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
                    else
                        toggleBg.BackgroundColor3 = Color3.fromRGB(180,180,190)
                        toggleCircle.Position = UDim2.new(0,2,0.5,-10)
                    end
                end,
                Get = function() return state end
            }
        end

        function sec:CreateDropdown(labelText, options, defaultIndex, callback)
            options = options or {}
            defaultIndex = defaultIndex or 1

            local row = new("Frame", self._content)
            row.Size = UDim2.new(1,-20,0,36)
            row.BackgroundTransparency = 1
            row.LayoutOrder = 5

            local lbl = new("TextLabel", row)
            lbl.Size = UDim2.new(0,110,1,0)
            lbl.Position = UDim2.new(0,0,0,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText or "Dropdown:"
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextColor3 = THEME.Accent
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local btn = new("TextButton", row)
            btn.Size = UDim2.new(1,-120,1,0)
            btn.Position = UDim2.new(0,120,0,0)
            btn.BackgroundColor3 = Color3.fromRGB(60,50,90)
            btn.BackgroundTransparency = 0.5
            btn.BorderSizePixel = 0
            btn.Text = tostring(options[defaultIndex] or "Select")
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.TextColor3 = THEME.SecondaryText
            new("UICorner", btn).CornerRadius = UDim.new(0,6)

            local dropdownPanel = new("Frame", self._parentWindow._main)
            dropdownPanel.Size = UDim2.new(0, 150, 0, 0)
            dropdownPanel.BackgroundColor3 = Color3.fromRGB(40,35,70)
            dropdownPanel.BorderSizePixel = 0
            dropdownPanel.Visible = false
            dropdownPanel.ZIndex = 1000
            new("UICorner", dropdownPanel).CornerRadius = UDim.new(0,8)

            local optLayout = new("UIListLayout", dropdownPanel)
            optLayout.SortOrder = Enum.SortOrder.LayoutOrder
            optLayout.Padding = UDim.new(0,4)

            local function buildOptions()
                for i,v in ipairs(dropdownPanel:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                for i,opt in ipairs(options) do
                    local ob = new("TextButton", dropdownPanel)
                    ob.Size = UDim2.new(1,-10,0,26)
                    ob.Position = UDim2.new(0,5,0,(i-1)*30 + 5)
                    ob.BackgroundColor3 = Color3.fromRGB(55,45,85)
                    ob.BackgroundTransparency = 0.5
                    ob.BorderSizePixel = 0
                    ob.Text = opt
                    ob.Font = Enum.Font.Gotham
                    ob.TextSize = 12
                    ob.TextColor3 = THEME.SecondaryText
                    new("UICorner", ob).CornerRadius = UDim.new(0,5)

                    ob.MouseEnter:Connect(function() ob.BackgroundTransparency = 0.3 ob.BackgroundColor3 = Color3.fromRGB(65,55,95) end)
                    ob.MouseLeave:Connect(function() ob.BackgroundTransparency = 0.5 ob.BackgroundColor3 = Color3.fromRGB(55,45,85) end)

                    ob.MouseButton1Click:Connect(function()
                        btn.Text = opt
                        dropdownPanel.Visible = false
                        print("[OxireunUI] Dropdown '"..tostring(labelText).."':", opt)
                        if type(callback) == "function" then pcall(callback, opt) end
                    end)
                end
                dropdownPanel.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, (#options)*30 + 10)
            end

            btn.MouseButton1Click:Connect(function()
                dropdownPanel.Visible = not dropdownPanel.Visible
                if dropdownPanel.Visible then
                    local btnPos = btn.AbsolutePosition
                    local mainPos = selfWindow._main.AbsolutePosition
                    local mainSize = selfWindow._main.AbsoluteSize
                    local relativeX = (btnPos.X - mainPos.X) / mainSize.X
                    local relativeY = (btnPos.Y - mainPos.Y + btn.AbsoluteSize.Y) / mainSize.Y
                    dropdownPanel.Position = UDim2.new(relativeX, 0, relativeY, 0)
                end
            end)

            -- close dropdown when clicking outside
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if dropdownPanel.Visible then
                        local mousePos = input.Position
                        local dpPos = dropdownPanel.AbsolutePosition
                        local dpSize = dropdownPanel.AbsoluteSize
                        if not (mousePos.X >= dpPos.X and mousePos.X <= dpPos.X + dpSize.X and mousePos.Y >= dpPos.Y and mousePos.Y <= dpPos.Y + dpSize.Y) then
                            dropdownPanel.Visible = false
                        end
                    end
                end
            end)

            buildOptions()
            self:_refresh()
            return {
                SetOptions = function(_, newOptions)
                    options = newOptions or {}
                    buildOptions()
                end,
                Set = function(_, val)
                    btn.Text = tostring(val)
                end,
                Get = function() return btn.Text end
            }
        end

        function sec:CreateSlider(labelText, minVal, maxVal, defaultVal, round, callback)
            minVal = minVal or 0
            maxVal = maxVal or 100
            defaultVal = defaultVal or minVal
            round = round and true or false

            local row = new("Frame", self._content)
            row.Size = UDim2.new(1,-20,0,48)
            row.BackgroundTransparency = 1
            row.LayoutOrder = 6

            local lbl = new("TextLabel", row)
            lbl.Size = UDim2.new(0.5,0,0,20)
            lbl.Position = UDim2.new(0,0,0,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText or "Slider"
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextColor3 = THEME.Accent
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local valueLabel = new("TextLabel", row)
            valueLabel.Size = UDim2.new(0.5,0,0,20)
            valueLabel.Position = UDim2.new(0.5,0,0,0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(defaultVal)
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextSize = 12
            valueLabel.TextColor3 = THEME.SecondaryText
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local sliderBg = new("Frame", row)
            sliderBg.Size = UDim2.new(1,0,0,6)
            sliderBg.Position = UDim2.new(0,0,0,26)
            sliderBg.BackgroundColor3 = Color3.fromRGB(50,50,75)
            sliderBg.BorderSizePixel = 0
            new("UICorner", sliderBg).CornerRadius = UDim.new(1,0)

            local sliderFill = new("Frame", sliderBg)
            sliderFill.Size = UDim2.new( (defaultVal - minVal) / math.max(1, maxVal - minVal), 0, 1, 0)
            sliderFill.Position = UDim2.new(0,0,0,0)
            sliderFill.BackgroundColor3 = THEME.Accent
            sliderFill.BorderSizePixel = 0
            new("UICorner", sliderFill).CornerRadius = UDim.new(1,0)

            local handle = new("TextButton", sliderBg)
            handle.Size = UDim2.new(0,16,0,16)
            local pct = clamp((defaultVal - minVal) / math.max(1, maxVal - minVal), 0, 1)
            handle.Position = UDim2.new(pct, -8, 0.5, -8)
            handle.BackgroundColor3 = THEME.Light
            handle.BorderSizePixel = 0
            handle.Text = ""
            handle.AutoButtonColor = false
            new("UICorner", handle).CornerRadius = UDim.new(1,0)
            new("UIStroke", handle).Color = THEME.Accent

            -- slider logic
            local sliding = false
            local currentValue = defaultVal

            local function setValueFromPercent(p)
                p = clamp(p, 0, 1)
                local val = minVal + p * (maxVal - minVal)
                if round then val = math.floor(val + 0.5) end
                currentValue = val
                local perc = (val - minVal) / math.max(1, maxVal - minVal)
                sliderFill.Size = UDim2.new(perc, 0, 1, 0)
                handle.Position = UDim2.new(perc, -8, 0.5, -8)
                valueLabel.Text = tostring(val)
                if type(callback) == "function" then pcall(callback, val) end
            end

            local dragConn
            local function startDrag()
                sliding = true
                sliderBg.Parent.Parent.ScrollingEnabled = false
                dragConn = RunService.RenderStepped:Connect(function()
                    if sliding then
                        local mouseX = LocalPlayer:GetMouse().X
                        local bgPos = sliderBg.AbsolutePosition
                        local bgSize = sliderBg.AbsoluteSize
                        local relative = (mouseX - bgPos.X) / bgSize.X
                        setValueFromPercent(relative)
                    else
                        if dragConn then dragConn:Disconnect(); dragConn = nil end
                    end
                end)
            end

            local function stopDrag()
                sliding = false
                sliderBg.Parent.Parent.ScrollingEnabled = true
                if dragConn then dragConn:Disconnect(); dragConn = nil end
            end

            handle.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    startDrag()
                end
            end)
            sliderBg.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    local mouseX = LocalPlayer:GetMouse().X
                    local bgPos = sliderBg.AbsolutePosition
                    local bgSize = sliderBg.AbsoluteSize
                    local relative = (mouseX - bgPos.X) / bgSize.X
                    setValueFromPercent(relative)
                    startDrag()
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    stopDrag()
                end
            end)

            -- initial
            setValueFromPercent(pct)
            self:_refresh()
            return {
                Set = function(_, val) setValueFromPercent((val - minVal) / math.max(1, maxVal - minVal)) end,
                Get = function() return currentValue end
            }
        end

        -- add to parent window's section list
        selfWindow.sections[index] = sec
        selfWindow._tabs[index] = {button = tabBtn, frame = secFrame}
        if index == 1 then
            -- activate first tab
            tabBtn.TextColor3 = THEME.Accent
            tabBtn.Active = true
            secFrame.Visible = true
        else
            secFrame.Visible = false
        end

        tabBtn.MouseButton1Click:Connect(function()
            -- switch visuals
            local prev = selfWindow._currentTab
            if prev and selfWindow._tabs[prev] then
                selfWindow._tabs[prev].button.TextColor3 = Color3.fromRGB(150,150,180)
                selfWindow._tabs[prev].button.Active = false
                selfWindow._tabs[prev].frame.Visible = false
            end
            selfWindow._currentTab = index
            tabBtn.TextColor3 = THEME.Accent
            tabBtn.Active = true
            secFrame.Visible = true

            local targetPos = (index-1) * 0.25
            selfWindow._activeTabLine:TweenPosition(UDim2.new(targetPos, 5, 1, -3), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end)

        -- helper to update scroll canvas as items added
        local oldChildAdded
        oldChildAdded = scrollContent.ChildAdded:Connect(function()
            wait() -- allow layouts to update
            refreshCanvas()
        end)

        return sec
    end

    -- Return the window object
    return selfWindow
end

-- Window methods (kept for backwards compatibility if needed)
Library.WindowMethods = {}

-- Example usage (like the wizard library you showed)
-- You can remove or comment this out when saving to GitHub and just keep the library.
--[[
local lib = Library
local win = lib:NewWindow("script")
local sec = win:NewSection("main")

sec:CreateButton("ugc 1", function()
    print("ugc 1 clicked (user callback)")
end)

sec:CreateTextbox("TextBox", function(text)
    print("Textbox value (callback):", text)
end)

sec:CreateToggle("togle", function(value)
    print("Toggle callback value:", value)
end)

sec:CreateDropdown("DropDown", {"Hello", "World", "Hello World"}, 2, function(text)
    print("Dropdown callback selected:", text)
end)

sec:CreateSlider("Slider", 0, 100, 15, false, function(value)
    print("Slider callback:", value)
end)
--]]

-- Expose library
return Library
