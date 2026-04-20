repeat task.wait() until game:IsLoaded()

local Unnamed_Engine = {
    Environment = {
        LPH_NO_VIRTUALIZE = function(f) return f end,
        LPH_JIT_MAX = function(f) return f end
    },
    Settings = {
        SilentAim = true,
        BulletTP = true,
        FOV = 150,
        WalkSpeed = 100,
        Noclip = true
    }
}

local function GetTarget()
    local Target = nil
    local Closest = Unnamed_Engine.Settings.FOV
    local LP = game:GetService("Players").LocalPlayer
    local Camera = workspace.CurrentCamera
    
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
            local pos, os = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if os then
                local mag = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if mag < Closest then
                    Target = v.Character.Head
                    Closest = mag
                end
            end
        end
    end
    return Target
end

local mt = getrawmetatable(game)
local old_nc = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and (method == "Raycast" or method == "FindPartOnRay") then
        if Unnamed_Engine.Settings.SilentAim or Unnamed_Engine.Settings.BulletTP then
            local T = GetTarget()
            if T then
                if method == "Raycast" then
                    args[2] = (T.Position - args[1]).Unit * 1000
                else
                    args[1] = Ray.new(workspace.CurrentCamera.CFrame.Position, (T.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
                end
                return old_nc(self, unpack(args))
            end
        end
    end
    return old_nc(self, ...)
end)
setreadonly(mt, true)

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wallwv2"))()
local Win = Lib:CreateWindow("Unnamed | Nameless Hub")
local Tab = Win:CreateTab("Combat")
local Tab2 = Win:CreateTab("Movement")

Tab:CreateToggle("Silent Aim", function(s) Unnamed_Engine.Settings.SilentAim = s end)
Tab:CreateToggle("Bullet TP", function(s) Unnamed_Engine.Settings.BulletTP = s end)
Tab:CreateSlider("FOV", 0, 1000, 150, function(v) Unnamed_Engine.Settings.FOV = v end)

Tab2:CreateSlider("Speed", 16, 500, 100, function(v) Unnamed_Engine.Settings.WalkSpeed = v end)
Tab2:CreateToggle("Noclip", function(s) Unnamed_Engine.Settings.Noclip = s end)

game:GetService("RunService").Heartbeat:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = Unnamed_Engine.Settings.WalkSpeed
        if Unnamed_Engine.Settings.Noclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

local GameModule = "https://raw.githubusercontent.com/mrgunz/UnnamedCheat/main/Games/" .. game.PlaceId .. ".lua"
pcall(function() loadstring(game:HttpGet(GameModule))() end)

print("Unnamed Full Engine Loaded. Key Bypass Active.")

