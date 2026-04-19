-- [[ Nameless v1 | Ultimate Rage Edition ]]
-- Targets: Rivals (Roblox)
-- Features: Silent Aim, Bullet TP, Movement Hacks, Visuals, Server Crashing logic

getgenv().Settings = {
    Combat = {
        SilentAim = true,
        FOVSettings = {Enabled = true, Size = 150, Color = Color3.fromRGB(255, 0, 0)},
        BulletTP = true,
        HitPart = "Head",
        TeamCheck = true,
        VisibilityCheck = false
    },
    Movement = {
        Speed = 50,
        JumpPower = 100,
        Fly = false,
        NoClip = false,
        FlySpeed = 50
    },
    Visuals = {
        ESP_Boxes = true,
        ESP_Names = true,
        ESP_Distance = true,
        ESP_Color = Color3.fromRGB(255, 0, 0)
    }
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- UI Library (Vape/Kavo Hybrid Style)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wallwv2"))()
local Window = Library:CreateWindow("Nameless v1")

local Tab1 = Window:CreateTab("Combat")
local Tab2 = Window:CreateTab("Movement")
local Tab3 = Window:CreateTab("Visuals")
local Tab4 = Window:CreateTab("Misc")

-- [[ Combat Tab ]]
Tab1:CreateToggle("Silent Aim", function(state) getgenv().Settings.Combat.SilentAim = state end)
Tab1:CreateToggle("Bullet TP", function(state) getgenv().Settings.Combat.BulletTP = state end)
Tab1:CreateSlider("FOV Size", 0, 800, 150, function(val) getgenv().Settings.Combat.FOVSettings.Size = val end)
Tab1:CreateToggle("Team Check", function(state) getgenv().Settings.Combat.TeamCheck = state end)

-- [[ Movement Tab ]]
Tab2:CreateSlider("WalkSpeed", 16, 200, 50, function(val) getgenv().Settings.Movement.Speed = val end)
Tab2:CreateToggle("Noclip", function(state) getgenv().Settings.Movement.NoClip = state end)
Tab2:CreateButton("Void TP (Escape)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(99999, 99999, 99999)
    end
end)

-- [[ Functions ]]
local function GetClosestTarget()
    local Target = nil
    local MaxDist = getgenv().Settings.Combat.FOVSettings.Size

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if getgenv().Settings.Combat.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character[getgenv().Settings.Combat.HitPart].Position)
            if OnScreen then
                local MouseDist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if MouseDist < MaxDist then
                    Target = v
                    MaxDist = MouseDist
                end
            end
        end
    end
    return Target
end

-- [[ MetaMethod Hook (Silent Aim / Bullet TP) ]]
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = {...}
    local Method = getnamecallmethod()

    if not checkcaller() and getgenv().Settings.Combat.SilentAim and (Method == "FindPartOnRayWithIgnoreList" or Method == "Raycast") then
        local T = GetClosestTarget()
        if T then
            if Method == "Raycast" then
                Args[2] = (T.Character[getgenv().Settings.Combat.HitPart].Position - Args[1]).Unit * 1000
            else
                Args[1] = Ray.new(Camera.CFrame.Position, (T.Character[getgenv().Settings.Combat.HitPart].Position - Camera.CFrame.Position).Unit * 1000)
            end
            return OldNamecall(self, unpack(Args))
        end
    end
    return OldNamecall(self, ...)
end)

-- [[ Main Loop ]]
RunService.RenderStepped:Connect(function()
    -- Speed Hack
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Settings.Movement.Speed
    end

    -- NoClip
    if getgenv().Settings.Movement.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- [[ ESP ]]
local function CreateESP(Player)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "Nameless_ESP"
    Highlight.FillTransparency = 0.5
    Highlight.FillColor = getgenv().Settings.Visuals.ESP_Color
    Highlight.OutlineColor = Color3.new(1, 1, 1)

    local function Update()
        if Player.Character then
            Highlight.Parent = Player.Character
        end
    end

    Player.CharacterAdded:Connect(Update)
    Update()
end

for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then CreateESP(v) end
end
Players.PlayerAdded:Connect(CreateESP)

print("Nameless v1 successfully injected.")
