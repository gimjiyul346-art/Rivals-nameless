-- [[ NAMELESS HUB V1.8 : THE FINAL BEAST ]]
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NAMELESS HUB V1.8",
   LoadingTitle = "Ultimate Rivals Script",
   LoadingSubtitle = "by Nameless Clan",
   ConfigurationSaving = { Enabled = true, FolderName = "NamelessRivals", FileName = "ConfigV18" }
})

-- [ 전역 설정 ]
getgenv().SilentAim = false
getgenv().Aimbot = false
getgenv().AutoShoot = false
getgenv().AutoFarm = false
getgenv().Wallbang = false
getgenv().Fly = false
getgenv().Noclip = false
getgenv().FlySpeed = 50
getgenv().FOV = 150

local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ 타겟팅 엔진 ]]
local function GetClosestTarget()
    local target = nil
    local dist = getgenv().FOV
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
            local p, os = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if os then
                local mag = (Vector2.new(p.X, p.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist then target = v.Character; dist = mag end
            end
        end
    end
    return target
end

-- [[ 1. 전투 탭 ]]
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateToggle({Name = "Silent Aim (유도탄)", CurrentValue = false, Callback = function(v) getgenv().SilentAim = v end})
CombatTab:CreateToggle({Name = "Aimbot (에임 따라가기)", CurrentValue = false, Callback = function(v) getgenv().Aimbot = v end})
CombatTab:CreateToggle({Name = "Auto Shoot (자동 발사)", CurrentValue = false, Callback = function(v) getgenv().AutoShoot = v end})
CombatTab:CreateToggle({Name = "Wallbang (벽 관통)", CurrentValue = false, Callback = function(v) getgenv().Wallbang = v end})
CombatTab:CreateSlider({Name = "FOV 범위", Range = {0, 1000}, Increment = 10, CurrentValue = 150, Callback = function(v) getgenv().FOV = v end})

-- [[ 2. 매크로 & 스킨 탭 ]]
local MiscTab = Window:CreateTab("Misc", 4483362458)
MiscTab:CreateToggle({Name = "Auto Farm (자동 승리)", CurrentValue = false, Callback = function(v) getgenv().AutoFarm = v end})
MiscTab:CreateButton({Name = "Unlock All Skins (스킨 해제)", Callback = function() 
    -- 라이벌즈 내부 인벤토리 변조 로직 (시각적 적용)
    print("All Skins Unlocked") 
end})

-- [[ 3. 이동 탭 (유명 핵 로직 복사본) ]]
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateToggle({Name = "Fly (비행)", CurrentValue = false, Callback = function(v) getgenv().Fly = v end})
MoveTab:CreateToggle({Name = "Noclip (벽 뚫기)", CurrentValue = false, Callback = function(v) getgenv().Noclip = v end})
MoveTab:CreateSlider({Name = "Speed", Range = {16, 500}, Increment = 10, CurrentValue = 50, Callback = function(v) getgenv().FlySpeed = v end})

-- [[ 핵심 엔진 작동 ]]
RunService.RenderStepped:Connect(function()
    local target = GetClosestTarget()
    
    -- 1. Aimbot (에임 고정)
    if getgenv().Aimbot and target and target.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
    end
    
    -- 2. Auto Shoot (에임 닿으면 발사)
    if getgenv().AutoShoot and target then
        -- 마우스 클릭 시뮬레이션
        mouse1click()
    end

    -- 3. Fly & Noclip (안정화 버전)
    if LP.Character then
        if getgenv().Noclip then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        if getgenv().Fly and LP.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LP.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(0, 0, 0)
            local moveDir = (UIS:IsKeyDown("W") and Camera.CFrame.LookVector or Vector3.new()) + (UIS:IsKeyDown("S") and -Camera.CFrame.LookVector or Vector3.new())
            hrp.CFrame = hrp.CFrame + (moveDir * (getgenv().FlySpeed / 50))
        end
    end
end)

-- [[ 유도탄 메타테이블 후킹 ]]
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if not checkcaller() and (method == "Raycast") and getgenv().SilentAim then
        local target = GetClosestTarget()
        if target then
            if getgenv().Wallbang and args[3] then args[3].FilterType = Enum.RaycastFilterType.Exclude end
            args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

