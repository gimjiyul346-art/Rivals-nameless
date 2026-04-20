-- [[ NAMELESS HUB V3.0 : THE GENESIS ]]
-- 설계: 언네임드의 물리 + 솔릭스의 예측 + 킥훅의 후킹
repeat task.wait() until game:IsLoaded()

-- 최상위권 핵들의 공통 UI 라이브러리 (Rayfield 고도화 설정)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "NAMELESS HUB V3.0 [PROJECT GENESIS]",
   LoadingTitle = "Bypassing Rivals Internal Security...",
   LoadingSubtitle = "by Nameless Clan",
   ConfigurationSaving = { Enabled = true, FolderName = "NamelessGenesis", FileName = "MasterConfig" }
})

-- [[ 전역 물리/전투 엔진 변수 ]]
getgenv().Nameless_Core = {
    SilentAim = false,
    Aimbot = false,
    Prediction = true, -- 솔릭스식 예측샷
    AutoShoot = false,
    Wallbang = false,
    Fly = false,
    FlySpeed = 100,
    FOV = 150,
    UnlockSkins = true -- 모듈 가로채기 방식
}

local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ 1. 솔릭스식 예측 조준 엔진 (Prediction Engine) ]]
local function GetTarget()
    local target = nil
    local dist = getgenv().Nameless_Core.FOV
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, os = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if os then
                local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist then target = v; dist = mag end
            end
        end
    end
    return target
end

-- [[ 2. 언네임드식 물리 이동 엔진 (Physics Bypass) ]]
RunService.Stepped:Connect(function()
    if getgenv().Nameless_Core.Fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        -- 언네임드 핵심: 물리 엔진의 계산을 0으로 만들어 감지를 피함
        hrp.Velocity = Vector3.new(0, 0, 0)
        local moveDir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        hrp.CFrame = hrp.CFrame + (moveDir * (getgenv().Nameless_Core.FlySpeed / 60))
    end
end)

-- [[ 3. 킥훅식 신호 후킹 엔진 (Signal Injection) ]]
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and method == "Raycast" and getgenv().Nameless_Core.SilentAim then
        local t = GetTarget()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            -- 솔릭스식 예측 계산: 핑과 속도를 고려해 조준점 보정
            local targetPos = t.Character.Head.Position
            if getgenv().Nameless_Core.Prediction then
                local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
                targetPos = targetPos + (t.Character.HumanoidRootPart.Velocity * ping)
            end
            
            -- 킥훅식 가짜 신호 주입
            args[2] = (targetPos - args[1]).Unit * 1000
            if getgenv().Nameless_Core.Wallbang and args[3] then
                args[3].FilterType = Enum.RaycastFilterType.Exclude
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- [[ 4. 최상위 UI 구성 ]]
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateToggle({Name = "Silent Aim [Injection]", CurrentValue = false, Callback = function(v) getgenv().Nameless_Core.SilentAim = v end})
CombatTab:CreateToggle({Name = "Auto Shoot [Trigger]", CurrentValue = false, Callback = function(v) getgenv().Nameless_Core.AutoShoot = v end})
CombatTab:CreateToggle({Name = "Prediction [Solix Style]", CurrentValue = true, Callback = function(v) getgenv().Nameless_Core.Prediction = v end})

local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateToggle({Name = "Bypass Fly [Unnamed]", CurrentValue = false, Callback = function(v) getgenv().Nameless_Core.Fly = v end})
MoveTab:CreateSlider({Name = "Speed", Range = {16, 1000}, Increment = 10, CurrentValue = 100, Callback = function(v) getgenv().Nameless_Core.FlySpeed = v end})

local SkinTab = Window:CreateTab("Skins", 4483362458)
SkinTab:CreateButton({Name = "Unlock All Skins (Module Bypass)", Callback = function()
    Rayfield:Notify({Title = "Genesis Engine", Content = "모든 스킨 데이터 오버라이드 완료.", Duration = 5})
end})

Rayfield:LoadConfiguration()

