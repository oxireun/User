# Oxireun UI Library

This documentation is for the stable release of the **Oxireun UI Library**.

## Booting the Library
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/oxireun/User/refs/heads/main/Oxireunuilibrary.lua"))()
```
## Creating a Window
```lua
local Window = Library:NewWindow("Script Title")
```
## Creating a Section
```lua
local MainSection = Window:NewSection("Main")
```
## UI Elements

# Button
```lua
MainSection:CreateButton("Button Name", function()
    print("Button clicked!")
end)
```
# Toggle

MainSection:CreateToggle("Toggle Name", false, function(value)
    print("Toggle State:", value)
end)

# Textbox
```lua
MainSection:CreateTextbox("Textbox Name", function(text)
    print("Inputted Text:", text)
end)
```
# Dropdown
```lua
MainSection:CreateDropdown("Dropdown Name", {"Option 1", "Option 2", "Option 3"}, 1, function(selected)
    print("Selected Option:", selected)
end)
```
# Slider
```lua
MainSection:CreateSlider("Slider Name", 1, 100, 50, function(value)
    print("Slider Value:", value)
end)
```
## Full Usage Example
```lua
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
```
