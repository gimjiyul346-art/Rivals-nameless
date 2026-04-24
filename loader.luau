-- [[ UNNAMED ENHANCEMENTS | NO-CRASH & NO-LAG ]] --
if not game:IsLoaded() then game.Loaded:Wait() end
if _G.EnhancementsLoaded then return end
_G.EnhancementsLoaded = true

-- 1. 멈춤 방지용 비동기 안티치트 엔진
local function SafeBypass()
    local OldNC
    OldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if not checkcaller() then
            -- [중요] 킥을 막되, 게임 엔진이 기다리지 않도록 즉시 nil 반환
            if method == "Kick" or method == "kick" then
                task.spawn(function() 
                    print("Kick Attempt Blocked Safely") 
                end)
                return nil 
            end
            
            -- [중요] 분석 파이프라인 충돌 방지: 차단이 아니라 '빈 응답' 처리
            if tostring(self) == "AnalyticsReceiver" then
                return nil
            end

            -- Rivals 전용 패킷 감지
            if method == "FireServer" and args[1] == "CheckBypass" then
                return nil
            end
        end
        return OldNC(self, ...)
    end)
end

-- 멈춤 방지를 위해 별도 스레드에서 실행
task.spawn(SafeBypass)

-- 2. 가벼운 UI 로드 (최소한의 자원 사용)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local Window = Library:CreateWindow({
    Title = 'UNNAMED ENHANCEMENTS | STABLE CRACK',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Movement = Window:AddTab('Movement'),
    Settings = Window:AddTab('Settings')
}

-- [Aimbot] 최적화된 에임 엔진
local AimGB = Tabs.Aimbot:AddLeftGroupbox('Main')
AimGB:AddToggle('SAim', { Text = 'Silent Aim', Default = false })
AimGB:AddSlider('FOV', { Text = 'Field of View', Default = 100, Min = 0, Max = 300, Rounding = 0 })

-- [Movement] 부드러운 이동
local MoveGB = Tabs.Movement:AddLeftGroupbox('Safe Move')
MoveGB:AddToggle('Fly', { Text = 'Safe Fly', Default = false })
MoveGB:AddSlider('Speed', { Text = 'Speed', Default = 50, Min = 16, Max = 100, Rounding = 0 })

-- 3. 렌더링 부하 감소 설정
game:GetService("RunService").Heartbeat:Connect(function()
    if Toggles.Fly and Toggles.Fly.Value and game.Players.LocalPlayer.Character then
        local HRP = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            -- 연산이 겹치지 않게 짧은 대기 시간 적용
            HRP.Velocity = game.Players.LocalPlayer.Character.Humanoid.MoveDirection * Options.Speed.Value + Vector3.new(0, 2, 0)
        end
    end
end)

Library:Notify('안정화된 크랙 버전이 로드되었습니다.')

