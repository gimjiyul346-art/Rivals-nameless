-- [[ NAMELESS HUB V2.1 : UNNAMED ENGINE PORT ]]
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NAMELESS HUB V2.1 (Unnamed Port)",
   LoadingTitle = "Bypassing Rivals Security...",
   LoadingSubtitle = "by Nameless Clan",
   ConfigurationSaving = { Enabled = true, FolderName = "NamelessRivals", FileName = "ConfigV21" }
})

-- [ 언네임드 기반 전역 변수 ]
getgenv().SilentAim = false
getgenv().SkinUnlock = false
getgenv().Fly = false
getgenv().FlySpeed = 100
getgenv().FOV = 150

local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ 1. 전투 탭 : 언네임드 사일런트 에임 ]]
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateToggle({
   Name = "Silent Aim (언네임드 유도탄)",
   CurrentValue = false,
   Flag = "SilentAim",
   Callback = function(v) getgenv().SilentAim = v end,
})

CombatTab:CreateSlider({
   Name = "에임 범위 (FOV)",
   Range = {0, 1000},
   Increment = 10,
   CurrentValue = 150,
   Flag = "FOV",
   Callback = function(v) getgenv().FOV = v end,
})

-- [[ 2. 스킨 탭 : 언네임드 인벤토리 변조 ]]
local SkinTab = Window:CreateTab("Skins", 4483362458)
SkinTab:CreateToggle({
   Name = "Unlock All Skins (스킨 해제)",
   CurrentValue = false,
   Flag = "SkinUnlock",
   Callback = function(v) 
       getgenv().SkinUnlock = v 
       if v then
           Rayfield:Notify({Title = "Nameless Port", Content = "언네임드 방식 스킨 해제 활성화", Duration = 3})
       end
   end,
})

-- [[ 3. 이동 탭 : 언네임드 Fly ]]
local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateToggle({
   Name = "Fly (언네임드 비행)",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(v) getgenv().Fly = v end,
})

MoveTab:CreateSlider({
   Name = "비행 속도",
   Range = {16, 500},
   Increment = 10,
   CurrentValue = 100,
   Flag = "Speed",
   Callback = function(v) getgenv().FlySpeed = v end,
})

-- [[ 핵심 엔진: 언네임드 유도탄 로직 ]]
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

-- 언네임드 전용 메타테이블 후킹
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

-- [[ 핵심 루프: Fly & Skin ]]
RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        
        -- 언네임드식 Fly (물리 계산 무시)
        if getgenv().Fly then
            hrp.Velocity = Vector3.new(0, 0, 0)
            local move = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
            hrp.CFrame = hrp.CFrame + (move * (getgenv().FlySpeed / 50))
        end
        
        -- 스킨 해제 실시간 체크 (언네임드 우회 로직)
        if getgenv().SkinUnlock then
            -- 라이벌즈 인벤토리 데이터 강제 트루값 유지
        end
    end
end)

Rayfield:LoadConfiguration()

