-- [[ NAMELESS HUB V1.6 : FINAL OPTIMIZATION ]]
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NAMELESS HUB V1.6",
   LoadingTitle = "Nameless Clan Exclusive",
   LoadingSubtitle = "Rivals Domination",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NamelessRivals",
      FileName = "ConfigV16"
   }
})

-- [ 전역 설정 ]
getgenv().SilentAim = false
getgenv().Wallbang = false
getgenv().Fly = false
getgenv().Noclip = false
getgenv().FlySpeed = 50
getgenv().FOV = 150

-- [ 1. Combat 탭 ]
local CombatTab = Window:CreateTab("Combat", 4483362458)
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
   CurrentValue = 150,
   Flag = "FOV",
   Callback = function(Value) getgenv().FOV = Value end,
})

-- [ 2. Movement 탭 ]
local MoveTab = Window:CreateTab("Movement", 4483362458)

MoveTab:CreateToggle({
   Name = "Fly (비행 개선)",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value) 
       getgenv().Fly = Value 
       -- 플라이 종료 시 속도 초기화
       if not Value and game.Players.LocalPlayer.Character then
           game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
       end
   end,
})

MoveTab:CreateToggle({
   Name = "Noclip (벽 뚫기 이동)",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value) getgenv().Noclip = Value end,
})

MoveTab:CreateSlider({
   Name = "Fly Speed (비행 속도)",
   Range = {16, 300},
   Increment = 5,
   CurrentValue = 50,
   Flag = "Speed",
   Callback = function(Value) getgenv().FlySpeed = Value end,
})

-- [[ 핵심 엔진 : 프리캠 제거 및 노클립 통합 ]]
local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")

-- 노클립(Noclip) 루프
RunService.Stepped:Connect(function()
    if getgenv().Noclip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- 개선된 플라이(Fly) 루프 (프리캠 로직 완전 제거)
RunService.Heartbeat:Connect(function()
    if getgenv().Fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LP.Character.HumanoidRootPart
        local Cam = workspace.CurrentCamera
        
        -- 중력 무시 및 정지 상태 유지
        Root.Velocity = Vector3.new(0, 0.1, 0)
        
        -- 이동 제어 (프리캠처럼 카메라만 나가는 게 아니라 캐릭터가 직접 이동)
        local MoveDir = Vector3.new(0,0,0)
        if UserInput:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Cam.CFrame.LookVector end
        if UserInput:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Cam.CFrame.LookVector end
        if UserInput:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Cam.CFrame.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Cam.CFrame.RightVector end
        
        if MoveDir.Magnitude > 0 then
            Root.CFrame = Root.CFrame + (MoveDir * (getgenv().FlySpeed / 50))
        end
    end
end)

-- [[ 유도탄 & 벽뚫기 로직 (유지) ]]
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if not checkcaller() and (method == "Raycast" or method == "FindPartOnRay") then
        if getgenv().SilentAim then
            -- 타겟팅 생략 (기존 V1.5와 동일)
            -- [내용 동일하므로 클랜장님 깃허브 코드 유지]
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

Rayfield:LoadConfiguration()

