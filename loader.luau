-- [[ UI Library Load ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source.lua"))()
local Venyx = Library.new("nameless hub | v1", 5013109572)

-- [[ Theme Setting ]] --
local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Accent = Color3.fromRGB(0, 100, 255),
    SectionBackground = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255)
}

-- [[ Pages Configuration ]] --
local Main = Venyx:addPage("main")
local World = Venyx:addPage("world")
local ESP = Venyx:addPage("esp")
local Visuals = Venyx:addPage("visuals")
local Character = Venyx:addPage("character")
local Misc = Venyx:addPage("misc")
local Settings = Venyx:addPage("settings")

-- [[ Main Tab: Combat & Targeting ]] --
local SilentAimSection = Main:addSection("silent aim")
SilentAimSection:addToggle("enabled", false, function(v) _G.SilentAim = v end)
SilentAimSection:addSlider("radius", 1000, 0, 2000, function(v) _G.Radius = v end)
SilentAimSection:addSlider("hit chance", 100, 0, 100, function(v) _G.HitChance = v end)

local TargetingSection = Main:addSection("targeting")
TargetingSection:addToggle("visible only", false, function(v) end)
TargetingSection:addToggle("ignore protected", false, function(v) end)

-- [[ Character Tab: Weapons ]] --
local WeaponSection = Character:addSection("weapons")
WeaponSection:addToggle("no spread", false, function(v) end)
WeaponSection:addToggle("full auto", false, function(v) end)
WeaponSection:addSlider("firerate", 30, 0, 100, function(v) end)

-- [[ Misc Tab: Ragebot ]] --
local RageSection = Misc:addSection("ragebot")
RageSection:addToggle("enabled", false, function(v) _G.RageBot = v end)
RageSection:addSlider("attack speed", 0.02, 0, 1, function(v) end)

-- [[ Settings Tab ]] --
local ConfigSection = Settings:addSection("config")
ConfigSection:addButton("Destroy UI", function() 
    game:GetService("CoreGui"):FindFirstChild("nameless hub | v1"):Destroy() 
end)

-- [[ Notification ]] --
Library:Notification("nameless hub", "Successfully Loaded! (No Key System)", 3)

