local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source.lua"))()
local Venyx = Library.new("unnamed hub | v1", 5013109572)

local themes = {
    Background = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 150, 255),
    SectionBackground = Color3.fromRGB(25, 25, 25),
    Text = Color3.fromRGB(255, 255, 255)
}

local Main = Venyx:addPage("main")
local World = Venyx:addPage("world")
local ESP = Venyx:addPage("esp")
local Visuals = Venyx:addPage("visuals")
local Character = Venyx:addPage("character")
local Misc = Venyx:addPage("misc")
local Settings = Venyx:addPage("settings")

local SilentAimSection = Main:addSection("silent aim")
SilentAimSection:addToggle("enabled", false, function(v) _G.SilentAim = v end)
SilentAimSection:addSlider("radius", 1000, 0, 2000, function(v) _G.Radius = v end)
SilentAimSection:addSlider("hit chance", 100, 0, 100, function(v) _G.HitChance = v end)

local TargetingSection = Main:addSection("targeting")
TargetingSection:addToggle("visible only", false, function(v) end)

local WeaponSection = Character:addSection("weapons")
WeaponSection:addToggle("no spread", false, function(v) end)
WeaponSection:addToggle("full auto", false, function(v) end)
WeaponSection:addSlider("firerate", 30, 0, 100, function(v) end)

local RageSection = Misc:addSection("ragebot")
RageSection:addToggle("enabled", false, function(v) _G.RageBot = v end)

local ConfigSection = Settings:addSection("config")
ConfigSection:addButton("Destroy UI", function() Venyx:toggle() end)

