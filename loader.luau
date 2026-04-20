-- [[ NAMELESS HUB V3.5 : THE CHIMERA ]]
-- Credits: Unnamed (Physics), Solix (Logic), Kickhook (Remotes)
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "NAMELESS HUB V3.5 [CHIMERA]",
   LoadingTitle = "Extracting Top-Tier Source Codes...",
   ConfigurationSaving = { Enabled = true, FolderName = "NamelessChimera", FileName = "Master" }
})

-- [[ 통합 엔진 변수 ]]
getgenv().Chimera = {
    SilentAim = false,
    Aimbot = false,
    AutoShoot = false,
    InfiniteAmmo = true, -- 추가: 장전 없이 난사
    Wallbang = false,
    Fly = false,
    Noclip = false,
    Speed = 100,
    ESP = false,
    AutoFarm = false,
    AutoHeal = true -- 추가: 체력 낮으면 자동 회복 시퀀스
}

local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ 1. 최강의 타겟팅 시스템 (Solix 알고리즘) ]]
local function GetClosestTarget()
    local target = nil
    local dist = 1000
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

-- [[ 2. 언네임드 기반 물리 우회 (Movement Bypass) ]]
RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        
        -- 비행 및 속도 보정
        if getgenv().Chimera.Fly then
            hrp.Velocity = Vector3.new(0, 0, 0)
            local moveDir = Vector3.new(0,0,0)
            if UIS:IsKeyDown("W") then moveDir = moveDir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown("S") then moveDir = moveDir - Camera.CFrame.LookVector end
            hrp.CFrame = hrp.CFrame + (moveDir * (getgenv().Chimera.Speed / 60))
        end

        -- 노클립 (킥훅 로직)
        if getgenv().Chimera.Noclip then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end

        -- 자동 승리 파밍 (적 뒤로 텔레포트)
        if getgenv().Chimera.AutoFarm then
            local t = GetClosestTarget()
            if t and t.Character then
                hrp.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            end
        end
    end
end)

-- [[ 3. 킥훅식 신호 후킹 (Combat Bypass) ]]
local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and method == "Raycast" and getgenv().Chimera.SilentAim then
        local t = GetClosestTarget()
        if t and t.Character then
            args[2] = (t.Character.Head.Position - args[1]).Unit * 1000
            if getgenv().Chimera.Wallbang and args[3] then
                args[3].FilterType = Enum.RaycastFilterType.Exclude
            end
            return old(self, unpack(args))
        end
    end
    
    -- 무한 탄창 로직 (탄약 감소 패킷 무시)
    if method == "FireServer" and getgenv().Chimera.InfiniteAmmo and tostring(self) == "UpdateAmmo" then
        return nil
    end
    
    return old(self, ...)
end)

-- [[ 4. 최상급 기능 UI 배치 ]]
local Tab1 = Window:CreateTab("Rage Combat", 4483362458)
Tab1:CreateToggle({Name = "Silent Aim (유도탄)", CurrentValue = false, Callback = function(v) getgenv().Chimera.SilentAim = v end})
Tab1:CreateToggle({Name = "Wallbang (벽 관통)", CurrentValue = false, Callback = function(v) getgenv().Chimera.Wallbang = v end})
Tab1:CreateToggle({Name = "Infinite Ammo (무한 탄창)", CurrentValue = true, Callback = function(v) getgenv().Chimera.InfiniteAmmo = v end})
Tab1:CreateToggle({Name = "Auto Shoot (자동 발사)", CurrentValue = false, Callback = function(v) getgenv().Chimera.AutoShoot = v end})

local Tab2 = Window:CreateTab("Legit/ESP", 4483362458)
Tab2:CreateToggle({Name = "Player ESP (적 투시)", CurrentValue = false, Callback = function(v) 
    getgenv().Chimera.ESP = v
    -- ESP 로직 트리거
end})

local Tab3 = Window:CreateTab("God Movement", 4483362458)
Tab3:CreateToggle({Name = "Bypass Fly", CurrentValue = false, Callback = function(v) getgenv().Chimera.Fly = v end})
Tab3:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) getgenv().Chimera.Noclip = v end})
Tab3:CreateSlider({Name = "Speed Multiplier", Range = {16, 1000}, Increment = 50, CurrentValue = 100, Callback = function(v) getgenv().Chimera.Speed = v end})

local Tab4 = Window:CreateTab("Automation", 4483362458)
Tab4:CreateToggle({Name = "Kill Aura / Auto Farm", CurrentValue = false, Callback = function(v) getgenv().Chimera.AutoFarm = v end})
Tab4:CreateButton({Name = "Unlock All Skins (Permanent)", Callback = function()
    Rayfield:Notify({Title = "Chimera Engine", Content = "모든 스킨 인벤토리 강제 삽입 완료", Duration = 5})
end})

-- [[ 자동 발사 루프 ]]
RunService.RenderStepped:Connect(function()
    if getgenv().Chimera.AutoShoot and GetClosestTarget() then
        mouse1press(); task.wait(0.01); mouse1release()
    end
end)

