Oxireun UI Library

This documentation is for the stable release of Oxireun UI Library.

Booting the Library
code
Lua
download
content_copy
expand_less
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/oxireun/User/refs/heads/main/Oxireunuilibrary.lua"))()
Creating a Window
code
Lua
download
content_copy
expand_less
local Window = Library:NewWindow("Script")

--[[
Name = <string> - The title of the library window.
]]
Creating a Section
code
Lua
download
content_copy
expand_less
local MainSection = Window:NewSection("Main")

--[[
Name = <string> - The name of the section to group elements.
]]
Creating a Button
code
Lua
download
content_copy
expand_less
MainSection:CreateButton("button", function()
    print("clicked")
end)

--[[
Name = <string> - The name of the button.
Callback = <function> - The function to execute when the button is clicked.
]]
Creating a Toggle
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
Default = <bool> - The default value of the toggle (true/false).
Callback = <function> - Returns the current state of the toggle.
]]
Creating a Textbox
code
Lua
download
content_copy
expand_less
MainSection:CreateTextbox("Text box", function(text)
    print("text", text)
end)

--[[
Name = <string> - The name/placeholder of the textbox.
Callback = <function> - Returns the text entered in the textbox.
]]
Creating a Dropdown
code
Lua
download
content_copy
expand_less
MainSection:CreateDropdown("Dropdown", {"Hello", "World", "Hello World"}, 1, function(selected)
    print("Selected:", selected)
end)

--[[
Name = <string> - The name of the dropdown.
Options = <table> - The list of options available.
Default = <number> - The index of the default selected item.
Callback = <function> - Returns the selected option string.
]]
Creating a Slider
code
Lua
download
content_copy
expand_less
MainSection:CreateSlider("Speed", 1, 100, 50, function(value)
    print("Speed:", value)
end)

--[[
Name = <string> - The name of the slider.
Min = <number> - The minimum value of the slider.
Max = <number> - The maximum value of the slider.
Default = <number> - The initial value of the slider.
Callback = <function> - Returns the current slider value.
]]
Credits & Notifications

You can create sections for social links and use Roblox notifications as follows:

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
