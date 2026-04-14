# Oxireun UI Library

This documentation provides a guide on how to implement and use the Oxireun UI Library for your scripts.

## Booting the Library
To start the library, use the following code:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/oxireun/User/refs/heads/main/Oxireunuilibrary.lua"))()
Creating a Window

This creates the main GUI container.

code
Lua
download
content_copy
expand_less
local Window = Library:NewWindow("Script")

--[[
Name = <string> - The title displayed at the top of the window.
]]
Creating a Section

Sections are used to group different UI elements together within a window.

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

A standard clickable button.

code
Lua
download
content_copy
expand_less
MainSection:CreateButton("button", function()
    print("clicked")
end)

--[[
Name = <string> - The text displayed on the button.
Callback = <function> - The function to execute when clicked.
]]
Creating a Toggle

A switch that can be turned on or off.

code
Lua
download
content_copy
expand_less
MainSection:CreateToggle("Toggle", false, function(value)
    print("Toggle:", value)
end)

--[[
Name = <string> - The name of the toggle.
Default = <bool> - The initial state (true/false).
Callback = <function> - Returns the new state (true/false).
]]
Creating a Textbox

Allows users to input custom text.

code
Lua
download
content_copy
expand_less
MainSection:CreateTextbox("Text box", function(text)
    print("Entered Text:", text)
end)

--[[
Name = <string> - The placeholder or label for the textbox.
Callback = <function> - Returns the text entered by the user.
]]
Creating a Dropdown

A menu for selecting a single option from a list.

code
Lua
download
content_copy
expand_less
MainSection:CreateDropdown("Dropdown", {"Hello", "World", "Hello World"}, 1, function(selected)
    print("Selected Option:", selected)
end)

--[[
Name = <string> - The name of the dropdown.
Options = <table> - A list of items to choose from.
Default = <number> - The index of the item selected by default.
Callback = <function> - Returns the selected item name.
]]
Creating a Slider

Allows users to select a value within a specific range.

code
Lua
download
content_copy
expand_less
MainSection:CreateSlider("Speed", 1, 100, 50, function(value)
    print("Current Value:", value)
end)

--[[
Name = <string> - The name of the slider.
Min = <number> - The minimum value.
Max = <number> - The maximum value.
Default = <number> - The initial value.
Callback = <function> - Returns the selected value.
]]
Credits & Socials

Example of how to create a credits section with functional buttons.

code
Lua
download
content_copy
expand_less
local CreditsSection = Window:NewSection("Credits")

CreditsSection:CreateButton("Copy YouTube", function()
    setclipboard("https://youtube.com/@oxireun?si=dnaRt4zcDvmnrUu_")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Copied!",
        Text = "YouTube link copied to clipboard!",
        Duration = 2
    })
end)

CreditsSection:CreateButton("Copy Discord", function()
    setclipboard("https://discord.gg/M2Xq55wC8Z")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Copied!",
        Text = "Discord invite copied to clipboard!",
        Duration = 2
    })
end)
