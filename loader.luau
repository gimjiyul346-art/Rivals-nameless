-- [[ NAMELESS HUB V1.5 : RAGE & STABLE ]]
repeat task.wait() until game:IsLoaded()

-- [ UI 라이브러리 호출 ] 
-- 처음에 메뉴가 떴던 라이브러리보다 더 가볍고 모바일에 최적화된 소스입니다.
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NAMELESS HUB V1.5",
   LoadingTitle = "Bypassing Anticheat...",
   LoadingSubtitle = "by Nameless Clan",
   ConfigurationSaving = {
      Enabled = true, -- 여기에 Auto Load 기능이 내장되어 있습니다!
      FolderName = "NamelessRivals",
      FileName = "Config"
   }
})

-- [ 전역 설정 ]
getgenv().SilentAim = false
getgenv().Wallbang = false
getgenv().Fly = false
getgenv().FlySpeed = 50

-- [ 1. 전투 탭 ]
local CombatTab = Window:CreateTab("Combat", 4483362458) -- 아이콘 포함
local CombatSection = CombatTab:CreateSection("Main Rage")

CombatTab:CreateToggle({
   Name = "Silent Aim (유도탄)",
   CurrentValue = false,
   Flag = "SilentAim", 
   Callback = function(Value) getgenv().SilentAim = Value end,
})

CombatTab:CreateToggle({
   Name = "Wallbang (벽 관통)",
   CurrentValue = false,
   Flag = "Wallbang",
   Callback = function(Value) getgenv().Wallbang = Value end,
})

CombatTab:CreateSlider({
   Name = "FOV 범위",
   Range = {0, 1000},
   Increment = 10,
   Suffix = "Range",
   CurrentValue = 150,
   Flag = "FOV",
   Callback = function(Value) getgenv().FOV = Value end,
})

-- [ 2. 이동 탭 ]
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateToggle({
   Name = "Fly (비행)",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value) getgenv().Fly = Value end,
})

MoveTab:CreateSlider({
   Name = "Fly Speed",
   Range = {16, 300},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "Speed",
   Callback = function(Value) getgenv().FlySpeed = Value end,
})

-- [[ 핵심 엔진 (총기 전용 유도 & 벽뚫기) ]]
local LP = game:GetService("Players").LocalPlayer
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() and (method == "Raycast" or method == "FindPartOnRay") then
        if getgenv().SilentAim then
            local target = nil
            local dist = getgenv().FOV or 150
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    local p, os = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                    if os then
                        local mag = (Vector2.new(p.X, p.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                        if mag < dist then target = v.Character.Head; dist = mag end
                    end
                end
            end

            if target then
                if getgenv().Wallbang and args[3] then
                    args[3].FilterType = Enum.RaycastFilterType.Exclude
                end
                if method == "Raycast" then
                    args[2] = (target.Position - args[1]).Unit * 1000
                end
                return old(self, unpack(args))
            end
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- [[ 비행 루프 ]]
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().Fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0)
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (workspace.CurrentCamera.CFrame.LookVector * getgenv().FlySpeed / 15)
        end
    end
end)

Rayfield:LoadConfiguration() -- 여기서 저장된 설정을 자동으로 불러옵니다!

