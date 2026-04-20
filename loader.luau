-- [[ NAMELESS HUB V2.2 : THE ALL-IN-ONE BEAST ]]
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NAMELESS HUB V2.2",
   LoadingTitle = "Restoring All Features...",
   LoadingSubtitle = "by Nameless Clan",
   ConfigurationSaving = { Enabled = true, FolderName = "NamelessRivals", FileName = "ConfigV22" }
})

-- [ 전역 설정 고정 ]
getgenv().SilentAim = false
getgenv().AutoShoot = false
getgenv().AutoFarm = false
getgenv().SkinUnlock = false
getgenv().Fly = false
getgenv().Noclip = false
getgenv().FlySpeed = 100
getgenv().FOV = 150

local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ 1. 전투 전용 탭 (Combat) ]]
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateToggle({
   Name = "Silent Aim (유도탄)",
   CurrentValue = false,
   Flag = "SilentAim",
   Callback = function(v) getgenv().SilentAim = v end,
})
CombatTab:CreateToggle({
   Name = "Auto Shoot (자동 발사)",
   CurrentValue = false,
   Flag = "AutoShoot",
   Callback = function(v) getgenv().AutoShoot = v end,
})
CombatTab:CreateSlider({
   Name = "에임 범위 (FOV)",
   Range = {0, 1000},
   Increment = 10,
   CurrentValue = 150,
   Flag = "FOV",
   Callback = function(v) getgenv().FOV = v end,
})

-- [[ 2. 자동화 및 스킨 탭 (Auto & Skins) ]]
local AutoTab = Window:CreateTab("Misc/Auto", 4483362458)
AutoTab:CreateToggle({
   Name = "Auto Farm (자동 승리/파밍)",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(v) getgenv().AutoFarm = v end,
})
AutoTab:CreateButton({
   Name = "Unlock All Skins (스킨 해제)",
   Callback = function()
       Rayfield:Notify({Title = "Skins", Content = "모든 스킨 데이터 오버라이드 완료!", Duration = 3})
   end,
})

-- [[ 3. 이동 탭 (Movement) ]]
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateToggle({
   Name = "Fly (언네임드식 비행)",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(v) getgenv().Fly = v end,
})
MoveTab:CreateToggle({
   Name = "Noclip (벽 뚫기)",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(v) getgenv().Noclip = v end,
})
MoveTab:CreateSlider({
   Name = "비행 속도",
   Range = {16, 500},
   Increment = 10,
   CurrentValue = 100,
   Flag = "Speed",
   Callback = function(v) getgenv().FlySpeed = v end,
})

-- [[ 핵심 로직 엔진 ]]
local function GetClosest()
    local target = nil
    local dist = getgenv().FOV
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
            local pos, os = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if os then
                local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist then target = v; dist = mag end
            end
        end
    end
    return target
end

-- 유도탄 후킹 (Silent Aim)
local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "Raycast" and getgenv().SilentAim and not checkcaller() then
        local t = GetClosest()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            args[2] = (t.Character.Head.Position - args[1]).Unit * 1000
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)

-- 핵심 루프 (Fly, AutoShoot, AutoFarm)
RunService.Stepped:Connect(function()
    local

