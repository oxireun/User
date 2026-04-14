code
Markdown
download
content_copy
expand_less
# Oxireun UI Library

Bu dokümantasyon **Oxireun UI Library**'nin kullanımı içindir.

## Booting the Library (Kütüphaneyi Yükleme)

Kütüphaneyi scriptinize dahil etmek için aşağıdaki kodu kullanın:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/oxireun/User/refs/heads/main/Oxireunuilibrary.lua"))()
Creating a Window (Pencere Oluşturma)

Ana arayüz penceresini oluşturur.

code
Lua
download
content_copy
expand_less
local Window = Library:NewWindow("Script")

--[[
Name = <string> - Pencerenin başlığı.
]]
Creating a Section (Bölüm Oluşturma)

Elementleri düzenli tutmak için pencerelerin altına bölümler ekleyebilirsiniz.

code
Lua
download
content_copy
expand_less
local MainSection = Window:NewSection("Main")

--[[
Name = <string> - Bölümün adı.
]]
UI Elements (Elementler)
Creating a Button (Buton)
code
Lua
download
content_copy
expand_less
MainSection:CreateButton("Buton Yazısı", function()
    print("Butona basıldı!")
end)

--[[
Name = <string> - Butonun üzerinde yazacak yazı.
Callback = <function> - Butona tıklandığında çalışacak fonksiyon.
]]
Creating a Toggle (Aç/Kapat)
code
Lua
download
content_copy
expand_less
MainSection:CreateToggle("Toggle", false, function(value)
    print("Toggle Durumu:", value)
end)

--[[
Name = <string> - Toggle adı.
Default = <bool> - Başlangıç değeri (true/false).
Callback = <function> - Durum değiştiğinde çalışacak fonksiyon (value döner).
]]
Creating a Textbox (Yazı Kutusu)
code
Lua
download
content_copy
expand_less
MainSection:CreateTextbox("Yazı Yaz", function(text)
    print("Girilen Yazı:", text)
end)

--[[
Name = <string> - Textbox başlığı.
Callback = <function> - Yazı girilip enterlandığında çalışacak fonksiyon (text döner).
]]
Creating a Dropdown (Açılır Menü)
code
Lua
download
content_copy
expand_less
MainSection:CreateDropdown("Dropdown", {"Seçenek 1", "Seçenek 2", "Seçenek 3"}, 1, function(selected)
    print("Seçilen:", selected)
end)

--[[
Name = <string> - Dropdown adı.
Options = <table> - Seçenek listesi.
DefaultIndex = <number> - Kaçıncı sıradakinin seçili başlayacağı.
Callback = <function> - Seçim yapıldığında çalışacak fonksiyon.
]]
Creating a Slider (Kaydırıcı)
code
Lua
download
content_copy
expand_less
MainSection:CreateSlider("Hız Ayarı", 1, 100, 50, function(value)
    print("Değer:", value)
end)

--[[
Name = <string> - Slider adı.
Min = <number> - Minimum değer.
Max = <number> - Maksimum değer.
Default = <number> - Başlangıç değeri.
Callback = <function> - Kaydırıldığında çalışacak fonksiyon.
]]
Full Example (Tam Örnek)
code
Lua
download
content_copy
expand_less
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/oxireun/User/refs/heads/main/Oxireunuilibrary.lua"))()
local Window = Library:NewWindow("Oxireun Hub")

local MainSection = Window:NewSection("Main")

MainSection:CreateButton("UGC 1", function()
    print("UGC Butonuna Basıldı")
end)

MainSection:CreateSlider("Speed", 1, 100, 50, function(v)
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
