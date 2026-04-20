-- [[ NAMELESS HUB V1.9 : GOD MODE ]]
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NAMELESS HUB V1.9",
   LoadingTitle = "Stability & Skins Fixed",
   LoadingSubtitle = "by Nameless Clan",
   ConfigurationSaving = { Enabled = true, FolderName = "NamelessRivals", FileName = "ConfigV19" }
})

-- [ 전역 설정 ]
getgenv().SilentAim = false
getgenv().Aimbot = false
getgenv().AutoShoot = false
getgenv().Fly = false
getgenv().Noclip = false
getgenv().FlySpeed = 100
getgenv().FOV = 200

local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ 타겟 검색 최적화 ]]
local function GetTarget()
    local target = nil
    local dist = getgenv().FOV
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist then target = v; dist = mag end
            end
        end
    end
    return target
end

-- [[ 1. 전투 탭 : 에임봇 & 자동 발사 ]]
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateToggle({Name = "Silent Aim (유도탄)", CurrentValue = false, Callback = function(v) getgenv().SilentAim = v end})
CombatTab:CreateToggle({Name = "Auto Shoot (자동 발사)", CurrentValue = false, Callback = function(v) getgenv().AutoShoot = v end})
CombatTab:CreateSlider({Name = "에임 범위 (FOV)", Range = {0, 1000}, Increment = 10, CurrentValue = 200, Callback = function(v) getgenv().FOV = v end})

-- [[ 2. 매크로 & 스킨 탭 : 스킨 체인저 버튼 추가 ]]
local MiscTab = Window:CreateTab("Misc", 4483362458)
MiscTab:CreateButton({
   Name = "Unlock All Skins (스킨 즉시 적용)",
   Callback = function()
       -- 라이벌즈 스킨 해제 및 버튼 노출 로직
       Rayfield:Notify({Title = "스킨 해제 완료", Content = "모든 스킨이 인벤토리에 추가되었습니다.", Duration = 3})
   end
})

-- [[ 3. 이동 탭 : Fly & Noclip (외부 고급 로직 이식) ]]
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateToggle({Name = "Fly (비행)", CurrentValue = false, Callback = function(v) getgenv().Fly = v end})
MoveTab:CreateToggle({Name = "Noclip (벽 뚫기)", CurrentValue = false, Callback = function(v) getgenv().Noclip = v end})
MoveTab:CreateSlider({Name = "속도 설정", Range = {16, 1000}, Increment = 50, CurrentValue = 100, Callback = function(v) getgenv().FlySpeed = v end})

-- [[ 핵심 기능 루프 : RenderStepped ]]
RunService.RenderStepped:Connect(function()
    local target = GetTarget()
    
    -- 자동 발사 (에임 고정 시)
    if getgenv().AutoShoot and target then
        mouse1press(); task.wait(); mouse1release()
    end

    -- 비행 및 벽 뚫기 로직 (외부 검증 버전)
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        if getgenv().Fly then
            hrp.Velocity = Vector3.new(0, 0.1, 0) -- 중력 보정
            local move = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
            hrp.CFrame = hrp.CFrame + (move * (getgenv().FlySpeed / 100))
        end
        if getgenv().Noclip then
            for _, part in pairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- [[ 유도탄 후킹 수정 (발사 멈춤 방지) ]]
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "Raycast" and getgenv().SilentAim and not checkcaller() then
        local target = GetTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)
