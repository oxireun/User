-- BladeRunnerUI.lua -- Neon Blade Runner 2049 style UI library -- Single-file Roblox UI library intended to be uploaded to GitHub and used with loadstring -- Usage example (same API as you used): -- local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/USERNAME/REPO/main/BladeRunnerUI.lua"))() -- local win = Library:NewWindow("script") -- local sec = win:NewSection("main") -- sec:CreateButton("Hello", function() print("clicked") end)

-- Lightweight, responsive, draggable, minimizable, closeable -- Tabs (sections) appear on top. Controls append to the active section. -- Aesthetic: neon purple border, rounded corners, subtle blur (if available).

local Library = {} Library.__index = Library

local TweenService = game:GetService("TweenService") local UserInputService = game:GetService("UserInputService") local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local CoreGui = game:GetService("CoreGui")

-- helper local function new(class, props) local obj = Instance.new(class) for k,v in pairs(props or {}) do if k == "Parent" then obj.Parent = v else obj[k] = v end end return obj end

local function round(num) return math.floor(num+0.5) end local function isDescendant(a,b) return a and b and a:IsDescendantOf(b) end

-- Colors local NEON = Color3.fromRGB(173, 68, 255) -- neon purple local BG = Color3.fromRGB(20,20,28) local PANEL = Color3.fromRGB(26,26,36) local ACCENT = NEON

-- create main screengui local function createBase(name) local gui = Instance.new("ScreenGui") gui.Name = name or "BladeRunnerUI" gui.ResetOnSpawn = false gui.DisplayOrder = 9999 gui.IgnoreGuiInset = true gui.Parent = CoreGui return gui end

-- round corners helper local function addUICorner(inst, radius) local c = new("UICorner", {Parent = inst, CornerRadius = UDim.new(0, radius or 8)}) return c end

-- neon stroke helper local function addNeonStroke(inst, thickness) local s = new("UIStroke", {Parent = inst, Thickness = thickness or 2, Color = NEON, Transparency = 0.05}) -- subtle glow using duplicate strokes return s end

-- create a small icon label (for minimize/close) without symbol inside as user wanted small local function makeSmallIcon(text) local btn = new("TextButton", { Size = UDim2.new(0,18,0,18), BackgroundTransparency = 1, Text = text or "", AutoButtonColor = false, Font = Enum.Font.SourceSans, TextSize = 14, }) return btn end

-- Draggable local function makeDraggable(frame, handle) handle = handle or frame local dragging = false local dragStart, startPos local function onInputBegan(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = frame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end local function onInputChanged(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then local delta = input.Position - dragStart frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end handle.InputBegan:Connect(onInputBegan) UserInputService.InputChanged:Connect(onInputChanged) end

-- Main Window factory function Library:NewWindow(title) local self = setmetatable({}, {__index = Library}) self._gui = createBase("BladeRunnerUI")

-- main container
local main = new("Frame", {
    Name = "Window",
    Parent = self._gui,
    Size = UDim2.fromOffset(520, 360),
    Position = UDim2.new(0.02,0,0.2,0),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
})
addUICorner(main, 14)

-- backdrop with neon stroke on edges
addNeonStroke(main, 1.6)

-- left panel (thin neon border left)
local left = new("Frame", {Parent = main, Size = UDim2.new(0,8,1,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = ACCENT, BorderSizePixel = 0})
addUICorner(left, 8)

-- top bar (holds title and tabs)
local top = new("Frame", {Parent = main, Size = UDim2.new(1,-16,0,44), Position = UDim2.new(0,12,0,8), BackgroundTransparency = 1})

-- title label
local titleLabel = new("TextLabel", {Parent = top, Size = UDim2.new(0.4,0,1,0), BackgroundTransparency = 1, Text = title or "Window", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0,8,0,0)})

-- controls (minimize, close) right
local controls = new("Frame", {Parent = top, Size = UDim2.new(0.25, -8,1,0), Position = UDim2.new(0.75,0,0,0), BackgroundTransparency = 1})
local minBtn = makeSmallIcon("-")
minBtn.Parent = controls
minBtn.Position = UDim2.new(1, -44, 0.5, -9)
local closeBtn = makeSmallIcon("x")
closeBtn.Parent = controls
closeBtn.Position = UDim2.new(1, -20, 0.5, -9)

-- tabs container
local tabsFrame = new("Frame", {Parent = main, Size = UDim2.new(1,-24,0,36), Position = UDim2.new(0,12,0,56), BackgroundTransparency = 1})
local tabsLayout = new("UIListLayout", {Parent = tabsFrame, FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Left, Padding = UDim.new(0,8)})

-- content area
local content = new("Frame", {Parent = main, Size = UDim2.new(1,-24,1,-120), Position = UDim2.new(0,12,0,100), BackgroundColor3 = PANEL})
addUICorner(content, 10)
addNeonStroke(content, 1)

-- inside content scrolling area
local scroll = new("ScrollingFrame", {Parent = content, Size = UDim2.new(1, -12, 1, -12), Position = UDim2.new(0,6,0,6), BackgroundTransparency = 1, ScrollBarThickness = 6})
local scrollLayout = new("UIListLayout", {Parent = scroll, FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,10)})
scroll.CanvasSize = UDim2.new(0,0,0,0)
scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0, scrollLayout.AbsoluteContentSize.Y + 12)
end)

-- store internals
self._main = main
self._tabsFrame = tabsFrame
self._content = scroll
self._sections = {}
self._activeSection = nil

-- behavior: minimize
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        main.Size = UDim2.fromOffset(240, 44)
        content.Visible = false
        tabsFrame.Visible = false
    else
        main.Size = UDim2.fromOffset(520, 360)
        content.Visible = true
        tabsFrame.Visible = true
    end
end)

-- close
closeBtn.MouseButton1Click:Connect(function()
    self._gui:Destroy()
end)

-- dragging
makeDraggable(main, top)

-- return window object
local window = {}
function window:NewSection(name)
    name = name or "Section"
    local sec = {Name = name, Controls = {}}

    -- create tab
    local tabBtn = new("TextButton", {Parent = tabsFrame, Text = name, BackgroundTransparency = 1, Size = UDim2.new(0,100,1,0), AutoButtonColor = false, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(0.9,0.9,0.95)})
    addUICorner(tabBtn, 8)
    addNeonStroke(tabBtn, 0.8)

    -- tab selection handler
    local function selectSection()
        -- clear content
        for _,v in pairs(self._content:GetChildren()) do
            if v:IsA("Frame") or v:IsA("UIListLayout") or v:IsA("TextLabel") or v:IsA("ScrollingFrame") then
                -- we'll only use our internal scroll, so just clear added controls
            end
        end
        -- mark active
        self._activeSection = sec
        -- visually highlight tabs
        for _, child in pairs(tabsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundTransparency = (child==tabBtn) and 0.06 or 1
            end
        end
    end
    tabBtn.MouseButton1Click:Connect(selectSection)

    -- add content container (we will add controls to the main scroll)
    function sec:CreateButton(text, callback)
        local btn = new("TextButton", {Parent = self._content, Size = UDim2.new(1, -12, 0, 36), BackgroundColor3 = Color3.fromRGB(40,40,52), AutoButtonColor = true, Text = text, Font = Enum.Font.Gotham, TextSize = 15, TextColor3 = Color3.new(1,1,1)})
        addUICorner(btn, 8)
        addNeonStroke(btn, 0.6)
        btn.MouseButton1Click:Connect(function()
            pcall(function() callback(true) end)
        end)
        return btn
    end

    function sec:CreateTextbox(placeholder, callback)
        local frame = new("Frame", {Parent = self._content, Size = UDim2.new(1, -12, 0, 40), BackgroundTransparency = 1})
        local box = new("TextBox", {Parent = frame, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(35,35,44), Text = "", PlaceholderText = placeholder or "...", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1,1,1)})
        addUICorner(box, 8)
        addNeonStroke(box, 0.5)
        box.FocusLost:Connect(function(enter)
            pcall(function() callback(box.Text) end)
        end)
        return box
    end

    function sec:CreateToggle(text, callback, default)
        local frame = new("Frame", {Parent = self._content, Size = UDim2.new(1, -12, 0, 34), BackgroundTransparency = 1})
        local lbl = new("TextLabel", {Parent = frame, Size = UDim2.new(0.78,0,1,0), BackgroundTransparency = 1, Text = text or "Toggle", Font = Enum.Font.Gotham, TextSize = 15, TextColor3 = Color3.new(1,1,1), TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0,8,0,0)})
        local togg = new("Frame", {Parent = frame, Size = UDim2.new(0,54,0,26), Position = UDim2.new(1,-62,0.5,-13), BackgroundColor3 = Color3.fromRGB(60,60,73)})
        addUICorner(togg, 16)
        addNeonStroke(togg, 0.6)
        local knob = new("Frame", {Parent = togg, Size = UDim2.new(0,22,0,22), Position = UDim2.new(0,4,0.5,-11), BackgroundColor3 = Color3.fromRGB(240,240,240)})
        addUICorner(knob, 12)
        local state = default and true or false
        local function updateVisual()
            if state then
                TweenService:Create(togg, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(110,60,255)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(1,-26,0.5,-11)}):Play()
            else
                TweenService:Create(togg, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(60,60,73)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(0,4,0.5,-11)}):Play()
            end
        end
        updateVisual()
        local btn = new("TextButton", {Parent = togg, BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Text = "", AutoButtonColor = false})
        btn.MouseButton1Click:Connect(function()
            state = not state
            updateVisual()
            pcall(function() callback(state) end)
        end)
        return {Set = function(v) state = v; updateVisual() end, Get = function() return state end}
    end

    function sec:CreateDropdown(text, options, defaultIndex, callback)
        local frame = new("Frame", {Parent = self._content, Size = UDim2.new(1, -12, 0, 36), BackgroundTransparency = 1})
        local label = new("TextLabel", {Parent = frame, Size = UDim2.new(0.4,0,1,0), BackgroundTransparency = 1, Text = text or "Dropdown", Font = Enum.Font.Gotham, TextSize = 15, TextColor3 = Color3.new(1,1,1), TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0,8,0,0)})
        local holder = new("Frame", {Parent = frame, Size = UDim2.new(0.54,0,1,0), Position = UDim2.new(1,-(0.54*frame.AbsoluteSize.X)-12,0,0), BackgroundColor3 = Color3.fromRGB(36,36,48)})
        addUICorner(holder, 8)
        addNeonStroke(holder, 0.6)
        local selected = new("TextLabel", {Parent = holder, Size = UDim2.new(1,-12,1,0), Position = UDim2.new(0,6,0,0), BackgroundTransparency = 1, Text = options[defaultIndex] or "Select", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1,1,1), TextXAlignment = Enum.TextXAlignment.Left})
        local arrow = new("TextLabel", {Parent = holder, Size = UDim2.new(0,18,1,0), Position = UDim2.new(1,-24,0,0), BackgroundTransparency = 1, Text = "v", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1,1,1)})

        local dropdown = new("Frame", {Parent = frame, Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,4), BackgroundTransparency = 1, Visible = false})
        local list = new("Frame", {Parent = dropdown, Size = UDim2.new(1,0,0,0), BackgroundColor3 = Color3.fromRGB(28,28,38)})
        addUICorner(list, 8)
        local listScroll = new("ScrollingFrame", {Parent = list, Size = UDim2.new(1,1,0,120), BackgroundTransparency = 1, ScrollBarThickness = 6})
        local listLayout = new("UIListLayout", {Parent = listScroll, FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,4)})
        listScroll.CanvasSize = UDim2.new(0,0,0,0)
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            listScroll.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y + 6)
            list.Size = UDim2.new(1,0,0, math.clamp(listLayout.AbsoluteContentSize.Y + 8, 0, 200))
            dropdown.Size = UDim2.new(1,0,0,list.Size.Y.Offset)
        end)

        local function populate()
            for i,opt in ipairs(options or {}) do
                local b = new("TextButton", {Parent = listScroll, Size = UDim2.new(1,-12,0,28), BackgroundTransparency = 1, Text = opt, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1,1,1)})
                addUICorner(b, 6)
                b.MouseButton1Click:Connect(function()
                    selected.Text = opt
                    dropdown.Visible = false
                    pcall(function() callback(opt) end)
                end)
            end
        end
        populate()

        holder.MouseButton1Click = nil
        local holderBtn = new("TextButton", {Parent = holder, Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = ""})
        holderBtn.MouseButton1Click:Connect(function()
            dropdown.Visible = not dropdown.Visible
        end)
        return {Set = function(val) selected.Text = val end, Get = function() return selected.Text end}
    end

    function sec:CreateSlider(text, min, max, default, whole, callback)
        min = min or 0; max = max or 100; default = default or min
        local frame = new("Frame", {Parent = self._content, Size = UDim2.new(1,-12,0,40), BackgroundTransparency = 1})
        local label = new("TextLabel", {Parent = frame, Size = UDim2.new(0.5,0,1,0), BackgroundTransparency = 1, Text = text or "Slider", Font = Enum.Font.Gotham, TextSize = 15, TextColor3 = Color3.new(1,1,1), TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0,8,0,0)})
        local valLbl = new("TextLabel", {Parent = frame, Size = UDim2.new(0,0,1,0), Position = UDim2.new(1,-64,0,0), BackgroundTransparency = 1, Text = tostring(default), Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(1,1,1)})
        local bar = new("Frame", {Parent = frame, Size = UDim2.new(1,-84,0,12), Position = UDim2.new(0,84,0,14), BackgroundColor3 = Color3.fromRGB(45,45,58)})
        addUICorner(bar, 8)
        addNeonStroke(bar, 0.4)
        local fill = new("Frame", {Parent = bar, Size = UDim2.new((default-min)/(max-min),0,1,0), BackgroundColor3 = NEON})
        addUICorner(fill, 6)
        local knob = new("ImageButton", {Parent = bar, Size = UDim2.new(0,0,1,0), BackgroundTransparency = 1, Image = "rbxassetid://3570695787"})
        knob.Size = UDim2.new(0,16,0,16)
        knob.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8)

        local dragging = false
        local function updateFromPos(x)
            local relative = math.clamp((x - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
            local value = min + (max-min)*relative
            if whole then value = round(value) end
            fill.Size = UDim2.new(relative, 0, 1, 0)
            knob.Position = UDim2.new(relative, -8, 0.5, -8)
            valLbl.Text = tostring(round(value*100)/100)
            pcall(function() callback(value) end)
        end
        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        knob.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateFromPos(input.Position.X)
            end
        end)
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateFromPos(input.Position.X)
            end
        end)
        return {Set = function(v) updateFromPos(bar.AbsolutePosition.X + bar.AbsoluteSize.X * ((v-min)/(max-min))) end, Get = function() return tonumber(valLbl.Text) end}
    end

    -- attach to main window internals
    table.insert(self._sections, sec)
    -- if first section, auto-select
    if #self._sections == 1 then
        self._activeSection = sec
        tabBtn.BackgroundTransparency = 0.06
    end
    return sec
end

return window

end

return setmetatable(Library, {__call = function(_,...) return Library:NewWindow(...) end})
