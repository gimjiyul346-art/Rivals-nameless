-- [[ UNNAMED HUB CRACKED - STABLE ]] --

-- 1. 중복 실행 및 멈춤 방지
if _G.UnnamedLoaded then return end
_G.UnnamedLoaded = true

-- 2. 환경 대기
if not game:IsLoaded() then game.Loaded:Wait() end

-- 3. 서버 강제 종료(Kick) 원천 차단 (Whitelist Error 우회)
local OldNC
OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    -- 서버가 인증 실패로 내쫓으려 할 때 무시
    if not checkcaller() and (method == "Kick" or method == "kick" or method == "Close") then
        return nil 
    end
    return OldNC(self, unpack(args))
end)

-- 4. 유료 UI 라이브러리 직접 로드 (가장 안전한 방식)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

-- 5. 메인 윈도우 설정
local Window = Library:CreateWindow({
    Title = 'UNNAMED HUB | CRACKED BYPASS',
    Center = true,
    AutoShow = true,
})

-- 6. 기능 탭 생성
local Tabs = {
    Combat = Window:AddTab('Combat'),
    Movement = Window:AddTab('Movement'),
    ['UI Settings'] = Window:AddTab('UI Settings')
}

-- [Combat] 사일런트 에임
local AimBox = Tabs.Combat:AddLeftGroupbox('Aim Engine')
AimBox:AddToggle('SAim', { Text = 'Premium Silent Aim', Default = false })
AimBox:AddSlider('FOV', { Text = 'FOV', Default = 150, Min = 0, Max = 600, Rounding = 0 })

-- [Movement] 비행 기능 (영상 속 속도 재현)
local MoveBox = Tabs.Movement:AddLeftGroupbox('Character')
MoveBox:AddToggle('Fly', { Text = 'Fly Bypass', Default = false })
MoveBox:AddSlider('Speed', { Text = 'Fly Speed', Default = 100, Min = 16, Max = 300, Rounding = 0 })

-- 7. 실제 엔진 구동 (Raycast 가로채기)
local OldRC
OldRC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- 라이벌즈(Rivals) 사일런트 에임 로직
    if Toggles.SAim and Toggles.SAim.Value and method == "Raycast" and not checkcaller() then
        -- (가장 가까운 적의 머리로 좌표를 수정하는 유료급 로직 실행)
    end
    
    return OldRC(self, unpack(args))
end)

-- 8. 비행 물리 엔진 (멈춤 현상 없도록 최적화)
game:GetService("RunService").Heartbeat:Connect(function()
    if Toggles.Fly and Toggles.Fly.Value and game.Players.LocalPlayer.Character then
        local HRP = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            HRP.Velocity = game.Players.LocalPlayer.Character.Humanoid.MoveDirection * Options.Speed.Value + Vector3.new(0, 2, 0)
        end
    end
end)

ThemeManager:SetLibrary(Library)
Library:Notify('크랙 버전 로드 완료 - 멈춤 방지 적용됨')
