repeat task.wait() until game:IsLoaded()

local Unnamed_Framework = {
    Environment = {
        LPH_NO_VIRTUALIZE = function(f) return f end,
        LPH_JIT_MAX = function(f) return f end,
        Bypass_Instance = nil,
        Secure_Signals = {}
    },
    Storage = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        HttpService = game:GetService("HttpService"),
        StarterGui = game:GetService("StarterGui"),
        LocalPlayer = game:GetService("Players").LocalPlayer,
        Camera = workspace.CurrentCamera,
        Mouse = game:GetService("Players").LocalPlayer:GetMouse()
    },
    Settings = {
        Combat = {
            SilentAim = true,
            BulletTP = true,
            HitPart = "Head",
            FOV = 150,
            Smoothing = 0,
            TeamCheck = true,
            WallCheck = false
        },
        Movement = {
            WalkSpeed = 100,
            JumpPower = 50,
            Noclip = true,
            InfiniteJump = true,
            Fly = false,
            FlySpeed = 50
        },
        Visuals = {
            ESP_Enabled = true,
            ESP_Boxes = true,
            ESP_Names = true,
            ESP_Color = Color3.fromRGB(255, 0, 0)
        }
    }
}

local function GetTarget()
    local CurrentTarget = nil
    local MaxDistance = Unnamed_Framework.Settings.Combat.FOV
    
    for _, Player in pairs(Unnamed_Framework.Storage.Players:GetPlayers()) do
        if Player ~= Unnamed_Framework.Storage.LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
            if Unnamed_Framework.Settings.Combat.TeamCheck and Player.Team == Unnamed_Framework.Storage.LocalPlayer.Team then continue end
            
            local ScreenPos, OnScreen = Unnamed_Framework.Storage.Camera:WorldToViewportPoint(Player.Character[Unnamed_Framework.Settings.Combat.HitPart].Position)
            if OnScreen then
                local MouseDist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Unnamed_Framework.Storage.UserInputService:GetMouseLocation()).Magnitude
                if MouseDist < MaxDistance then
                    if Unnamed_Framework.Settings.Combat.WallCheck then
                        local RayParams = RaycastParams.new()
                        RayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        RayParams.FilterDescendantsInstances = {Unnamed_Framework.Storage.LocalPlayer.Character, Player.Character}
                        local Result = workspace:Raycast(Unnamed_Framework.Storage.Camera.CFrame.Position, (Player.Character[Unnamed_Framework.Settings.Combat.HitPart].Position - Unnamed_Framework.Storage.Camera.CFrame.Position).Unit * 1000, RayParams)
                        if Result then continue end
                    end
                    CurrentTarget = Player.Character[Unnamed_Framework.Settings.Combat.HitPart]
                    MaxDistance = MouseDist
                end
            end
        end
    end
    return CurrentTarget
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    
    if not checkcaller() then
        if Method == "Raycast" or Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRay" then
            if Unnamed_Framework.Settings.Combat.SilentAim or Unnamed_Framework.Settings.Combat.BulletTP then
                local Target = GetTarget()
                if Target then
                    if Method == "Raycast" then
                        Args[2] = (Target.Position - Args[1]).Unit * 1000
                    elseif Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRay" then
                        Args[1] = Ray.new(Unnamed_Framework.Storage.Camera.CFrame.Position, (Target.Position - Unnamed_Framework.Storage.Camera.CFrame.Position).Unit * 1000)
                    end
                    return oldNamecall(self, unpack(Args))
                end
            end
        end
        if Method == "FireServer" and Unnamed_Framework.Environment.Secure_Signals[self.Name] then
            return nil
        end
    end
    return oldNamecall(self, ...)
end)

mt.__index = newcclosure(function(self, idx)
    if not checkcaller() and self:IsA("Humanoid") and (idx == "WalkSpeed" or idx == "JumpPower") then
        return (idx == "WalkSpeed" and 16 or 50)
    end
    return oldIndex(self, idx)
end)
setreadonly(mt, true)

local UI_Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wallwv2"))()
local Main_UI = UI_Lib:CreateWindow("NAMELESS HUB V1")

local Combat_Tab = Main_UI:CreateTab("Rage Combat")
local God_Tab = Main_UI:CreateTab("God Movement")
local Visual_Tab = Main_UI:CreateTab("Visuals")

Combat_Tab:CreateToggle("Silent Aim", function(state) Unnamed_Framework.Settings.Combat.SilentAim = state end)
Combat_Tab:CreateToggle("Bullet Teleport", function(state) Unnamed_Framework.Settings.Combat.BulletTP = state end)
Combat_Tab:CreateSlider("FOV Circle", 0, 1000, 150, function(val) Unnamed_Framework.Settings.Combat.FOV = val end)
Combat_Tab:CreateToggle("Wall Check", function(state) Unnamed_Framework.Settings.Combat.WallCheck = state end)

God_Tab:CreateSlider("Speed Multiplier", 16, 500, 100, function(val) Unnamed_Framework.Settings.Movement.WalkSpeed = val end)
God_Tab:CreateToggle("Phase (Noclip)", function(state) Unnamed_Framework.Settings.Movement.Noclip = state end)
God_Tab:CreateToggle("Infinite Jump", function(state) Unnamed_Framework.Settings.Movement.InfiniteJump = state end)
God_Tab:CreateButton("Void Escape (TP)", function()
    if Unnamed_Framework.Storage.LocalPlayer.Character then
        Unnamed_Framework.Storage.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10000, 0)
    end
end)

Unnamed_Framework.Storage.RunService.Heartbeat:Connect(function()
    local Character = Unnamed_Framework.Storage.LocalPlayer.Character
    if Character and Character:FindFirstChild("Humanoid") then
        Character.Humanoid.WalkSpeed = Unnamed_Framework.Settings.Movement.WalkSpeed
        if Unnamed_Framework.Settings.Movement.Noclip then
            for _, Part in pairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") then Part.CanCollide = false end
            end
        end
    end
end)

Unnamed_Framework.Storage.UserInputService.JumpRequest:Connect(function()
    if Unnamed_Framework.Settings.Movement.InfiniteJump and Unnamed_Framework.Storage.LocalPlayer.Character then
        Unnamed_Framework.Storage.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

print("NAMELESS HUB V1: ALL UNNAMED MODULES LOADED")

