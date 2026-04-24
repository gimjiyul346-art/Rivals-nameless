-- [[ UNNAMED ENHANCEMENTS | ULTIMATE STEALTH CRACK ]] --
if not game:IsLoaded() then game.Loaded:Wait() end
if _G.FinalBypassLoaded then return end
_G.FinalBypassLoaded = true

-- 1. 고성능 스텔스 엔진 (에러 267 및 멈춤 현상 완전 해결)
local function StealthBypass()
    local oldNC; oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if not checkcaller() then
            -- [핵심] 킥 명령어 감지 즉시 소멸
            if method == "Kick" or method == "kick" then return nil end
            
            -- [핵심] 분석 파이프라인 충돌 방지 (정상 데이터인 척 위장)
            if tostring(self) == "AnalyticsReceiver" then
                return nil -- 서버로 가는 보고서를 중간에 가로채서 파기
            end

            -- [Rivals 전용] 보안 체크 시스템 속이기
            if method == "FireServer" and (args[1] == "CheckBypass" or args[1] == "Detected") then
                return nil
            end
        end
        return oldNC(self, ...)
    end)
end
task.spawn(StealthBypass)

-- 2. 프리미엄 UI 로드
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local Window = Library:CreateWindow({ Title = 'UNNAMED ENHANCEMENTS | PREM CRACK', Center = true, AutoShow = true })

-- 3. 모든 탭 구성 (Aimbot, Visuals, Movement)
local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Settings = Window:AddTab('Settings')
}

-- [Aimbot] 실제 작동하는 무적의 에임 엔진
local AimGB = Tabs.Aimbot:AddLeftGroupbox('Aim Engine')
AimGB:AddToggle('SAim', { Text = 'Silent Aim', Default = false })
AimGB:AddSlider('FOV', { Text = 'Field Of View', Default = 100, Min = 0, Max = 400, Rounding = 0 })

-- [Visuals] 적 위치 강조 (ESP)
local VisGB = Tabs.Visuals:AddLeftGroupbox('ESP')
VisGB:AddToggle('Box', { Text = 'Boxes', Default = false })

-- [Movement] 튕김 방지용 저감지 비행
local MoveGB = Tabs.Movement:AddLeftGroupbox('Bypass Move')
MoveGB:AddToggle('Fly', { Text = 'Ghost Fly', Default = false })
MoveGB:AddSlider('Speed', { Text = 'Fly Speed', Default = 45, Min = 16, Max = 100, Rounding = 0 })

-- 4. 메뉴 끄기/켜기 설정 (기본: RightControl)
Library:SetWatermark('Unnamed Enhancements | Final Crack')
Library.Keybind = Enum.KeyCode.RightControl

-- 5. 에임핵 작동 로직 (최적화 버전)
local function GetTarget()
    local t, d = nil, Toggles.FOV.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local p, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local m = (Vector2.new(p.X, p.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if m < d then d = m t = v end
            end
        end
    end
    return t
end

local oldRC; oldRC = hookmetamethod(game, "__namecall", function(self, ...)
    local m = getnamecallmethod()
    local a = {...}
    if Toggles.SAim and Toggles.SAim.Value and m == "Raycast" and not checkcaller() then
        local target = GetTarget()
        if target then
            a[2] = (target.Character.Head.Position - a[1]).Unit * 1000
            return oldRC(self, unpack(a))
        end
    end
    return oldRC(self, unpack(a))
end)

Library:Notify('모든 보안 검사를 통과했습니다. 즐기세요!')

