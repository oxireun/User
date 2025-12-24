-- Oxireun UI Library (single file)
-- Version: 1.0
-- Author: for you
-- Usage: local Library = loadstring(game:HttpGet("RAW_URL"))()

local Library = {}
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local LocalPlayer = Players.LocalPlayer

    -- ------------------------------------------------------------------
    -- Utilities (safe file save/load for executors that provide these)
    local Save = {}
    do
        local has_isfile, has_readfile, has_writefile = pcall(function() return isfile ~= nil end)
        has_isfile = has_isfile and (type(isfile) == "function")
        has_readfile = pcall(function() return readfile ~= nil end) and (type(readfile) == "function")
        has_writefile = pcall(function() return writefile ~= nil end) and (type(writefile) == "function")

        function Save:SaveToFile(name, tbl)
            if not has_writefile then return false end
            local ok, encoded = pcall(function() return game:GetService("HttpService"):JSONEncode(tbl) end)
            if not ok then return false end
            pcall(function() writefile(name, encoded) end)
            return true
        end

        function Save:LoadFromFile(name)
            if not has_readfile or not has_isfile then return nil end
            if not isfile(name) then return nil end
            local content = readfile(name)
            local ok, decoded = pcall(function() return game:GetService("HttpService"):JSONDecode(content) end)
            if not ok then return nil end
            return decoded
        end
    end

    -- ------------------------------------------------------------------
    -- Core GUI container
    local CoreGuiParent = game:GetService("CoreGui")
    local rootGui = Instance.new("ScreenGui")
    rootGui.Name = "OxireunUILibrary"
    rootGui.Parent = CoreGuiParent
    rootGui.ResetOnSpawn = false
    rootGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Theme (can be exposed later)
    local THEME = {
        Background = Color3.fromRGB(25,20,45),
        Accent = Color3.fromRGB(0,150,255),
        Panel = Color3.fromRGB(35,30,65),
        Text = Color3.fromRGB(220,220,240),
        MutedText = Color3.fromRGB(150,150,180)
    }

    -- Helper: create with parent and basic properties
    local function new(class, props)
        local inst = Instance.new(class)
        if props then
            for k,v in pairs(props) do
                if k == "Parent" then inst.Parent = v
                else
                    pcall(function() inst[k] = v end)
                end
            end
        end
        return inst
    end

    -- ------------------------------------------------------------------
    -- Window management
    local windows = {}

    local function makeDraggable(frame, dragHandle)
        dragHandle = dragHandle or frame
        local dragging, dragInput, dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        dragHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        dragHandle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    -- UI element factory: creates a labeled row in a section and returns container for control
    local function createRow(sectionFrame, height)
        local row = new("Frame", {Parent=sectionFrame; Size=UDim2.new(1,0,0,height or 30); BackgroundTransparency=1})
        return row
    end

    -- Ensure a scrolling layout for a section
    local function ensureList(frame)
        if frame:FindFirstChild("ListLayout") then return end
        local layout = new("UIListLayout", {Parent = frame})
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0,8)
        layout.Name = "ListLayout"
        frame.CanvasSize = UDim2.new(0,0,0,0)
        -- update canvas size when content changes
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            frame.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 12)
        end)
    end

    -- ------------------------------------------------------------------
    -- Window constructor
    function Library:NewWindow(title, options)
        options = options or {}
        local window = {}
        window._sections = {}

        -- main window frame
        local container = new("Frame", {
            Parent = rootGui;
            Size = UDim2.fromScale(0.4, 0.75);
            Position = UDim2.fromScale(0.03, 0.1);
            BackgroundColor3 = THEME.Background;
            BorderSizePixel = 0;
            Active = true;
        })
        new("UICorner", {Parent = container; CornerRadius = UDim.new(0,12)})
        new("UIStroke", {Parent = container; Color = THEME.Accent; Thickness = 2; Transparency = 0.3})

        -- top bar
        local topBar = new("Frame", {Parent = container; Size=UDim2.new(1,0,0,45); Position=UDim2.new(0,0,0,0); BackgroundColor3 = Color3.fromRGB(30,25,60); BorderSizePixel=0})
        new("UICorner", {Parent=topBar; CornerRadius = UDim.new(0,12)})
        local titleLabel = new("TextLabel", {Parent = topBar; Size=UDim2.new(1,-100,1,0); Position=UDim2.new(0,15,0,0); BackgroundTransparency=1; Text=title or "Window"; TextColor3=THEME.Text; Font=Enum.Font.GothamBold; TextSize=16; TextXAlignment=Enum.TextXAlignment.Left})

        -- control buttons (minimize/close)
        local controlFrame = new("Frame", {Parent=topBar; Size=UDim2.new(0,60,1,0); Position=UDim2.new(1,-65,0,0); BackgroundTransparency=1})
        local minimizeBtn = new("TextButton", {Parent=controlFrame; Size=UDim2.new(0,26,0,26); Position=UDim2.new(0,0,0.5,-13); BackgroundColor3 = Color3.fromRGB(50,50,70); Text=""; BorderSizePixel = 0; AutoButtonColor=false})
        new("UICorner", {Parent=minimizeBtn; CornerRadius=UDim.new(0,6)})
        local closeBtn = new("TextButton", {Parent=controlFrame; Size=UDim2.new(0,26,0,26); Position=UDim2.new(0,30,0.5,-13); BackgroundColor3 = Color3.fromRGB(70,40,50); Text=""; BorderSizePixel=0})
        new("UICorner", {Parent=closeBtn; CornerRadius=UDim.new(0,6)})

        -- tabs area (simple; allows multiple sections horizontally if desired)
        local tabContainer = new("Frame", {Parent = container; Size = UDim2.new(1,-20,0,35); Position = UDim2.new(0,10,0,50); BackgroundTransparency = 1})
        local activeTabLine = new("Frame", {Parent=tabContainer; Size=UDim2.new(0.25,-10,0,3); Position=UDim2.new(0,5,1,-3); BackgroundColor3=THEME.Accent; BorderSizePixel=0})
        new("UICorner", {Parent=activeTabLine; CornerRadius=UDim.new(1,0)})

        -- content area
        local contentArea = new("Frame", {Parent = container; Size = UDim2.new(1,-20,1,-100); Position = UDim2.new(0,10,0,90); BackgroundColor3 = THEME.Panel; BorderSizePixel=0})
        new("UICorner", {Parent = contentArea; CornerRadius = UDim.new(0,8)})
        contentArea.ClipsDescendants = true

        -- container for sections (we'll use frames per section; only one visible at a time)
        local contentContainer = new("Frame", {Parent = contentArea; Size=UDim2.new(1,0,1,0); BackgroundTransparency=1})
        contentContainer.Name = "ContentContainer"

        -- make draggable
        makeDraggable(container, topBar)

        -- minimize logic
        local minimized = false
        minimizeBtn.MouseButton1Click:Connect(function()
            minimized = not minimized
            if minimized then
                container.Size = UDim2.fromScale(0.4, 0.12)
                contentArea.Visible = false
                tabContainer.Visible = false
            else
                container.Size = UDim2.fromScale(0.4, 0.75)
                contentArea.Visible = true
                tabContainer.Visible = true
            end
        end)

        closeBtn.MouseButton1Click:Connect(function()
            container:Destroy()
        end)

        -- Section creation
        function window:NewSection(name)
            local section = {}
            local idx = #window._sections + 1

            -- tab button
            local tabBtn = new("TextButton", {Parent = tabContainer; Size = UDim2.new(0.25, -5, 1, 0); Position = UDim2.new((idx-1)*0.25, 0, 0, 0); BackgroundTransparency = 1; BorderSizePixel=0; Text=name; Font=Enum.Font.GothamMedium; TextSize=12; TextColor3=THEME.MutedText})
            tabBtn.Name = "Tab_"..(name or idx)
            tabBtn.Active = false

            tabBtn.MouseEnter:Connect(function() if not tabBtn.Active then tabBtn.TextColor3 = Color3.fromRGB(200,220,255) end end)
            tabBtn.MouseLeave:Connect(function() if not tabBtn.Active then tabBtn.TextColor3 = THEME.MutedText end end)

            -- content frame for this section
            local secFrame = new("Frame", {Parent = contentContainer; Size = UDim2.new(1,0,1,0); BackgroundTransparency = 1; Visible = (idx==1)})
            secFrame.Name = "Section_"..(name or idx)

            -- scrolling content
            local scroll = new("ScrollingFrame", {Parent = secFrame; Size=UDim2.new(1,0,1,0); Position=UDim2.new(0,0,0,0); BackgroundTransparency=1; BorderSizePixel=0; ScrollBarThickness=6})
            scroll.ScrollingDirection = Enum.ScrollingDirection.Y
            scroll.CanvasSize = UDim2.new(0,0,0,0)
            local scrollContent = new("Frame", {Parent = scroll; Size = UDim2.new(1,0,0,10); BackgroundTransparency=1})
            scrollContent.Name = "ScrollContent"

            ensureList(scroll)

            -- switch to this section when tab clicked
            tabBtn.MouseButton1Click:Connect(function()
                for i,v in ipairs(window._sections) do
                    v.tab.Active = false
                    v.tab.TextColor3 = THEME.MutedText
                    v.frame.Visible = false
                end
                tabBtn.Active = true
                tabBtn.TextColor3 = THEME.Accent
                secFrame.Visible = true

                -- Move activeTabLine
                local targetPosition = (idx-1) * 0.25
                pcall(function()
                    activeTabLine:TweenPosition(UDim2.new(targetPosition, 5, 1, -3), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                end)
            end)

            -- API: create button
            function section:CreateButton(text, callback)
                local row = createRow(scrollContent, 34)
                local label = new("TextLabel", {Parent = row; Size=UDim2.new(0.5,0,1,0); BackgroundTransparency=1; Text=text; TextXAlignment=Enum.TextXAlignment.Left; TextColor3=THEME.Text; Font=Enum.Font.Gotham; TextSize=14})
                local btn = new("TextButton", {Parent = row; Size=UDim2.new(0.4,0,0.8,0); Position=UDim2.new(0.52,0,0.1,0); BackgroundColor3=Color3.fromRGB(45,45,70); BorderSizePixel=0; Text="Run"; TextColor3=THEME.Accent; Font=Enum.Font.Gotham; TextSize=12})
                new("UICorner",{Parent=btn; CornerRadius=UDim.new(0,6)})
                btn.MouseButton1Click:Connect(function()
                    pcall(function() callback() end)
                end)
                return btn
            end

            -- API: create label
            function section:CreateLabel(text)
                local row = createRow(scrollContent, 26)
                local lbl = new("TextLabel", {Parent=row; Size=UDim2.new(1,0,1,0); BackgroundTransparency=1; Text=text; TextColor3=THEME.Text; Font=Enum.Font.Gotham; TextSize=13; TextXAlignment=Enum.TextXAlignment.Left})
                return lbl
            end

            -- API: create toggle
            function section:CreateToggle(text, default, callback)
                default = (default == true)
                local row = createRow(scrollContent, 34)
                local lbl = new("TextLabel", {Parent=row; Size=UDim2.new(0.6,0,1,0); BackgroundTransparency=1; Text=text; TextColor3=THEME.Text; Font=Enum.Font.Gotham; TextSize=13; TextXAlignment=Enum.TextXAlignment.Left})
                local toggleBg = new("Frame", {Parent=row; Size=UDim2.new(0,45,0,24); Position=UDim2.new(1,-50,0.5,-12); BackgroundColor3 = default and THEME.Accent or Color3.fromRGB(180,180,190); BorderSizePixel=0})
                new("UICorner",{Parent=toggleBg; CornerRadius=UDim.new(1,0)})
                local toggleCircle = new("Frame", {Parent=toggleBg; Size=UDim2.new(0,20,0,20); Position = default and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10); BackgroundColor3=Color3.fromRGB(255,255,255); BorderSizePixel=0})
                new("UICorner",{Parent=toggleCircle; CornerRadius=UDim.new(1,0)})

                local state = default

                local btn = new("TextButton", {Parent=row; Size=UDim2.new(1,0,1,0); BackgroundTransparency=1; Text=""; BorderSizePixel=0})
                btn.MouseButton1Click:Connect(function()
                    state = not state
                    if state then
                        toggleBg.BackgroundColor3 = THEME.Accent
                        toggleCircle:TweenPosition(UDim2.new(1,-22,0.5,-10), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                    else
                        toggleBg.BackgroundColor3 = Color3.fromRGB(180,180,190)
                        toggleCircle:TweenPosition(UDim2.new(0,2,0.5,-10), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                    end
                    pcall(function() callback(state) end)
                end)

                return {
                    Get = function() return state end,
                    Set = function(val)
                        state = not not val
                        if state then
                            toggleBg.BackgroundColor3 = THEME.Accent
                            toggleCircle.Position = UDim2.new(1,-22,0.5,-10)
                        else
                            toggleBg.BackgroundColor3 = Color3.fromRGB(180,180,190)
                            toggleCircle.Position = UDim2.new(0,2,0.5,-10)
                        end
                        pcall(function() callback(state) end)
                    end
                }
            end

            -- API: create slider
            function section:CreateSlider(text, min, max, default, callback)
                min = min or 0; max = max or 100; default = default or min
                local value = math.clamp(default, min, max)

                local row = createRow(scrollContent, 44)
                local lbl = new("TextLabel", {Parent=row; Size=UDim2.new(0.4,0,0,20); Position=UDim2.new(0,0,0,4); BackgroundTransparency=1; Text=text; TextColor3=THEME.Text; Font=Enum.Font.Gotham; TextSize=13; TextXAlignment=Enum.TextXAlignment.Left})
                local valLbl = new("TextLabel", {Parent=row; Size=UDim2.new(0.4,0,0,20); Position=UDim2.new(0.6,0,0,4); BackgroundTransparency=1; Text=tostring(value); TextColor3=THEME.Text; Font=Enum.Font.Gotham; TextSize=13; TextXAlignment=Enum.TextXAlignment.Right})

                local barBg = new("Frame", {Parent=row; Size=UDim2.new(1,-20,0,8); Position=UDim2.new(0,10,0,26); BackgroundColor3=Color3.fromRGB(50,50,75); BorderSizePixel=0})
                new("UICorner",{Parent=barBg; CornerRadius=UDim.new(1,0)})
                local fill = new("Frame", {Parent=barBg; Size=UDim2.new((value-min)/(max-min),0,1,0); Position=UDim2.new(0,0,0,0); BackgroundColor3=THEME.Accent; BorderSizePixel=0})
                new("UICorner",{Parent=fill; CornerRadius=UDim.new(1,0)})
                local handle = new("Frame", {Parent=barBg; Size=UDim2.new(0,16,0,16); Position=UDim2.new((value-min)/(max-min), -8, 0.5, -8); BackgroundColor3=Color3.fromRGB(255,255,255); BorderSizePixel=0})
                new("UICorner",{Parent=handle; CornerRadius=UDim.new(1,0)})
                local dragging = false

                -- input helper that works for mouse & touch
                local function updateFromPosition(pos)
                    local absPos = barBg.AbsolutePosition
                    local absSize = barBg.AbsoluteSize
                    local x = pos.X - absPos.X
                    local t = math.clamp(x / absSize.X, 0, 1)
                    value = math.floor(min + (max-min)*t + 0.5)
                    fill.Size = UDim2.new(t,0,1,0)
                    handle.Position = UDim2.new(t, -8, 0.5, -8)
                    valLbl.Text = tostring(value)
                    pcall(function() callback(value) end)
                end

                barBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateFromPosition(input.Position)
                    end
                end)
                barBg.InputChanged:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
                        updateFromPosition(input.Position)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                        updateFromPosition(input.Position)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                return {
                    Get = function() return value end,
                    Set = function(v)
                        value = math.clamp(v, min, max)
                        local t = (value - min) / (max - min)
                        fill.Size = UDim2.new(t,0,1,0)
                        handle.Position = UDim2.new(t, -8, 0.5, -8)
                        valLbl.Text = tostring(value)
                        pcall(function() callback(value) end)
                    end
                }
            end

            -- API: create textbox
            function section:CreateTextbox(label, placeholder, callback)
                local row = createRow(scrollContent, 34)
                local lbl = new("TextLabel", {Parent=row; Size=UDim2.new(0.4,0,1,0); BackgroundTransparency=1; Text=label; TextColor3=THEME.Text; Font=Enum.Font.Gotham; TextSize=13; TextXAlignment=Enum.TextXAlignment.Left})
                local box = new("TextBox", {Parent=row; Size=UDim2.new(0.55,0,0.8,0); Position=UDim2.new(0.45,0,0.1,0); BackgroundColor3=Color3.fromRGB(45,40,75); BorderSizePixel=0; Text=""; TextColor3=THEME.Text; PlaceholderText = placeholder or ""; Font=Enum.Font.Gotham; TextSize=13})
                new("UICorner",{Parent=box; CornerRadius=UDim.new(0,6)})
                box.FocusLost:Connect(function(enter)
                    pcall(function() callback(box.Text) end)
                end)
                return box
            end

            -- API: create dropdown
            function section:CreateDropdown(label, options, callback)
                options = options or {}
                local row = createRow(scrollContent, 34)
                local lbl = new("TextLabel", {Parent=row; Size=UDim2.new(0.4,0,1,0); BackgroundTransparency=1; Text=label; TextColor3=THEME.Text; Font=Enum.Font.Gotham; TextSize=13; TextXAlignment=Enum.TextXAlignment.Left})
                local btn = new("TextButton", {Parent=row; Size=UDim2.new(0.55,0,0.8,0); Position=UDim2.new(0.45,0,0.1,0); BackgroundColor3=Color3.fromRGB(60,50,90); BorderSizePixel=0; Text="Select"; TextColor3=THEME.Text; Font=Enum.Font.Gotham; TextSize=13})
                new("UICorner",{Parent=btn; CornerRadius=UDim.new(0,6)})
                local panel = new("Frame", {Parent = rootGui; Size = UDim2.new(0,150,0,30); BackgroundColor3 = THEME.Panel; BorderSizePixel=0; Visible=false; ZIndex=1000})
                new("UICorner",{Parent=panel; CornerRadius=UDim.new(0,8)})

                local optionButtons = {}
                local function buildOptions()
                    for i,v in ipairs(optionButtons) do v:Destroy() end
                    optionButtons = {}
                    local h = 0
                    for i,opt in ipairs(options) do
                        local ob = new("TextButton", {Parent=panel; Size=UDim2.new(1,-10,0,28); Position=UDim2.new(0,5,0,h+5); BackgroundColor3=Color3.fromRGB(55,45,85); BorderSizePixel=0; Text=tostring(opt); TextColor3=THEME.Text; Font=Enum.Font.Gotham; TextSize=13})
                        new("UICorner",{Parent=ob; CornerRadius=UDim.new(0,5)})
                        ob.MouseButton1Click:Connect(function()
                            btn.Text = tostring(opt)
                            panel.Visible = false
                            pcall(function() callback(opt) end)
                        end)
                        table.insert(optionButtons, ob)
                        h = h + 32
                    end
                    panel.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, math.max(30, h + 10))
                end
                buildOptions()

                btn.MouseButton1Click:Connect(function()
                    panel.Visible = not panel.Visible
                    if panel.Visible then
                        local btnPos = btn.AbsolutePosition
                        panel.Position = UDim2.new(0, btnPos.X, 0, btnPos.Y + btn.AbsoluteSize.Y + 4)
                    end
                end)

                -- hide panel on outside click
                UserInputService.InputBegan:Connect(function(input, processed)
                    if processed then return end
                    if panel.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local pos = input.Position
                        local absPos = panel.AbsolutePosition
                        local absSize = panel.AbsoluteSize
                        if not (pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y) then
                            panel.Visible = false
                        end
                    end
                end)

                return {
                    SetOptions = function(newOptions) options = newOptions or {}; buildOptions() end,
                    Set = function(val) btn.Text = tostring(val) end
                }
            end

            -- expose section frame and internal nodes if needed
            section._internal = {frame = secFrame, scroll = scroll, content = scrollContent}
            section.tab = tabBtn
            section.frame = secFrame

            table.insert(window._sections, section)

            -- if first section make active
            if idx == 1 then
                tabBtn.Active = true
                tabBtn.TextColor3 = THEME.Accent
                secFrame.Visible = true
            end

            return section
        end

        windows[title or tostring(container)] = {
            window = window,
            _frame = container
        }

        return window
    end

    -- Optional: simple global save/load API for library users
    function Library:SaveConfig(name, tbl)
        if not name then return false end
        local fname = "oxireun_" .. name .. ".json"
        return Save:SaveToFile(fname, tbl)
    end
    function Library:LoadConfig(name)
        if not name then return nil end
        local fname = "oxireun_" .. name .. ".json"
        return Save:LoadFromFile(fname)
    end

    -- Expose theme adjust
    function Library:SetAccentColor(c3)
        if typeof(c3) == "Color3" then THEME.Accent = c3 end
    end
end

return Library
