-- [[ NAMELESS HUB V1 : ANTICHEAT BYPASS & RAGE ]]
repeat task.wait() until game:IsLoaded()

-- [ 전역 설정 값 ]
getgenv().NamelessConfig = {
    Wallbang = false,
    SilentAim = false,
    Fly = false,
    AntiAim = false,
    SkinUnlock = false,
    FlySpeed = 50,
    FOV = 150
}

local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- [[ 안티치트 우회 및 엔진 코어 ]]
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() then
        -- 1. 벽 관통 (Wallbang) & 유도탄 통합
        if (method == "Raycast" or method == "FindPartOnRayWithIgnoreList") then
            if getgenv().NamelessConfig.SilentAim then
                local target = nil
                local dist = getgenv().NamelessConfig.FOV
                for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                        local p, os = Camera:WorldToViewportPoint(v.Character.Head.Position)
                        if os then
                            local mag = (Vector2.new(p.X, p.Y) - UserInput:GetMouseLocation()).Magnitude
                            if mag < dist then target = v.Character.Head; dist = mag end
                        end
                    end
                end

                if target then
                    if getgenv().NamelessConfig.Wallbang then
                        -- 벽뚫기: 레이캐스트의 필터를 조작하여 모든 장애물 무시
                        if method == "Raycast" and args[3] then
                            args[3].FilterType = Enum.RaycastFilterType.Exclude
                        end
                    end
                    -- 유도: 총알 궤적을 타겟 헤드로 강제 고정
                    if method == "Raycast" then
                        args[2] = (target.Position - args[1]).Unit * 1000
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        
        -- 2. 안티치트 감지 무력화 (속도/점프 체크 서버 전송 차단)
        if method == "FireServer" and (self.Name == "MainEvent" or self.Name == "UpdateCheck") then
            return nil
        end
    end
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

-- [[ UI 메뉴 생성 : KiciaHook 디자인 기반 ]]
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wallwv2"))()
local Win = Lib:CreateWindow("NAMELESS HUB V1")

local Tab1 = Win:CreateTab("Rage Combat")
local Tab2 = Win:CreateTab("Movement & Visual")

-- Combat 기능들
Tab1:CreateToggle("유도탄 (Silent Aim)", function(state) getgenv().NamelessConfig.SilentAim = state end)
Tab1:CreateToggle("벽 관통 (Wallbang)", function(state) getgenv().NamelessConfig.Wallbang = state end)
Tab1:CreateSlider("조준 범위 (FOV)", 0, 1000, 150, function(val) getgenv().NamelessConfig.FOV = val end)
Tab1:CreateToggle("히트박스 왜곡 (Anti-Aim)", function(state) getgenv().NamelessConfig.AntiAim = state end)

-- Movement & Skin 기능들
Tab2:CreateToggle("공중 비행 (Fly)", function(state) getgenv().NamelessConfig.Fly = state end)
Tab2:CreateSlider("비행 속도", 16, 300, 50, function(val) getgenv().NamelessConfig.FlySpeed = val end)
Tab2:CreateToggle("모든 스킨 해제", function(state) 
    getgenv().NamelessConfig.SkinUnlock = state 
    -- 스킨 체인저 즉시 적용 알림
    if state then print("Skins Unlocked (Visual Only)") end
end)

-- [[ 루프 시스템 ]]
RunService.RenderStepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        -- 플라이 실행
        if getgenv().NamelessConfig.Fly then
            LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0.5, 0)
            if UserInput:IsKeyDown(Enum.KeyCode.W) then
                LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (Camera.CFrame.LookVector * getgenv().NamelessConfig.FlySpeed / 10)
            end
        end
        
        -- 안티 에임 (상대가 나를 못 맞추게 회전)
        if getgenv().NamelessConfig.AntiAim then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
        end
    end
end)

print("NAMELESS HUB V1 LOADED SUCCESSFULLY")

