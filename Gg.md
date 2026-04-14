code
Markdown
download
content_copy
expand_less
# Oxireun UI Library

This documentation is for the stable release of the Oxireun UI Library.

## Booting the Library

To load the library into your script, use the following code:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/oxireun/User/refs/heads/main/Oxireunuilibrary.lua"))()
Creating a Window

This function creates the main window for your script.

code
Lua
download
content_copy
expand_less
local Window = Library:NewWindow("Script Title")

--[[
Name = <string> - The title displayed on the UI window.
]]
Creating a Section

Sections are used to group different elements within the window.

code
Lua
download
content_copy
expand_less
local MainSection = Window:NewSection("Main")

--[[
Name = <string> - The name of the section.
]]
UI Elements
Creating a Button
code
Lua
download
content_copy
expand_less
MainSection:CreateButton("Button Name", function()
    print("Button clicked!")
end)

--[[
Name = <string> - The text displayed on the button.
Callback = <function> - The function to execute when the button is pressed.
]]
Creating a Toggle
code
Lua
download
content_copy
expand_less
MainSection:CreateToggle("Toggle Name", false, function(value)
    print("Toggle State:", value)
end)

--[[
Name = <string> - The name of the toggle.
DefaultIndex = <bool> - The initial state (true or false).
Callback = <function> - The function to execute when the toggle state changes.
]]
Creating a Textbox
code
Lua
download
content_copy
expand_less
MainSection:CreateTextbox("Textbox Name", function(text)
    print("Inputted Text:", text)
end)

--[[
Name = <string> - The placeholder or label for the textbox.
Callback = <function> - The function to execute when text is entered and confirmed.
]]
Creating a Dropdown
code
Lua
download
content_copy
expand_less
MainSection:CreateDropdown("Dropdown Name", {"Option 1", "Option 2", "Option 3"}, 1, function(selected)
    print("Selected Option:", selected)
end)

--[[
Name = <string> - The name of the dropdown.
Options = <table> - A list of strings for the dropdown choices.
DefaultIndex = <number> - The index of the option selected by default.
Callback = <function> - The function to execute when an option is selected.
]]
Creating a Slider
code
Lua
download
content_copy
expand_less
MainSection:CreateSlider("Slider Name", 1, 100, 50, function(value)
    print("Slider Value:", value)
end)

--[[
Name = <string> - The name of the slider.
Min = <number> - The minimum value.
Max = <number> - The maximum value.
Default = <number> - The starting value.
Callback = <function> - The function to execute when the slider is moved.
]]
Full Usage Example
code
Lua
download
content_copy
expand_less
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/oxireun/User/refs/heads/main/Oxireunuilibrary.lua"))()
local Window = Library:NewWindow("Oxireun Hub")

local MainSection = Window:NewSection("Main")

MainSection:CreateButton("UGC 1", function()
    -- Your code here
end)

MainSection:CreateSlider("WalkSpeed", 16, 200, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

local CreditsSection = Window:NewSection("Credits")

CreditsSection:CreateButton("Copy Discord", function()
    setclipboard("https://discord.gg/M2Xq55wC8Z")
end)
code
Code
download
content_copy
expand_less
