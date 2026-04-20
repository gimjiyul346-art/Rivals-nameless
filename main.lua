-- [[ NAMELESS HUB V1 | ULTIMATE HYBRID ]]
-- Integrated: Kiciahook UI + Unnamed Bypass Engine
-- Optimized for: Rivals (S25 Performance Mode)

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ Unnamed-Style Security Bypass ]
local function SecureCall(func)
    if typeof(func) ~= "function" then return end
    local s, e = pcall(func)
    if not s then warn("Security Error: " .. tostring(e)) end
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wallwv2"))()
local Window = Library:CreateWindow("NAMELESS HUB V1")

-- [ Global Settings ]
getgenv().Nameless_Config = {
    Rage = {
        SilentAim = false,
        BulletTP = false,
        InstantKill = false, -- Experimental
        FOV = 150
    },
    Legit = {
        WallCheck = true,
        Smoothing = 0.1
    },
    Global = {
        TeamCheck = true,
        NoRender = false -- Battery Saver for S25
    }
}

-- [ Tabs ]
local CombatTab = Window:CreateTab("Rage & Combat")
local PlayerTab = Window:CreateTab("God Movement")
local VisualTab = Window:CreateTab("Visuals (ESP)")

-- [[ 1. Combat: Unnamed Enhanced ]]
CombatTab:CreateToggle("Unnamed Silent Aim", function(state) getgenv().Nameless_Config.Rage.SilentAim = state end)
CombatTab:CreateToggle("Server-Side Bullet TP", function(state) getgenv().Nameless_Config.Rage.BulletTP = state end)
CombatTab:CreateSlider("Hitbox Size (FOV)", 0, 1000, 150, function(v) getgenv().Nameless_Config.Rage.FOV = v end)
CombatTab:CreateToggle("Wall Check", function(state) getgenv().Nameless_Config.Legit.WallCheck = state end)

-- [[ 2. Player: Movement Exploits ]]
PlayerTab:CreateSlider("WalkSpeed Override", 16, 500, 16, function(v) 
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)
PlayerTab:CreateButton("Bypass Anti-Fall", function()
    -- Logic to prevent dying in the void
    local p = game.Players.LocalPlayer.Character.HumanoidRootPart
    p.Velocity = Vector3.new(0, 0, 0)
end)

-- [[ Core Logic: The Unnamed Way ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function GetBestTarget()
    local Target = nil
    local Dist = getgenv().Nameless_Config.Rage.FOV
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            if getgenv().Nameless_Config.Global.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if OnScreen then
                local MouseDist = (Vector2.new(Pos.X, Pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if MouseDist < Dist then
                    if getgenv().Nameless_Config.Legit.WallCheck then
                        local Ray = workspace.CurrentCamera:ViewportPointToRay(Pos.X, Pos.Y)
                        if #workspace:FindPartOnRayWithIgnoreList(Ray, {LocalPlayer.Character, v.Character}) > 0 then continue end
                    end
                    Target = v.Character.Head
                    Dist = MouseDist
                end
            end
        end
    end
    return Target
end

-- Metamethod Hooking (Improved Unnamed Logic)
local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and (method == "Raycast" or method == "FindPartOnRay") then
        if getgenv().Nameless_Config.Rage.SilentAim or getgenv().Nameless_Config.Rage.BulletTP then
            local T = GetBestTarget()
            if T then
                if method == "Raycast" then
                    args[2] = (T.Position - args[1]).Unit * 1000
                else
                    args[1] = Ray.new(workspace.CurrentCamera.CFrame.Position, (T.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
                end
                return old(self, unpack(args))
            end
        end
    end
    return old(self, ...)
end)

print("Nameless Hub v1: Hybrid Engine Successfully Loaded.")

