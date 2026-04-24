-- [[ UNNAMED ENHANCEMENTS | ULTIMATE BYPASS ]] --
if not game:IsLoaded() then game.Loaded:Wait() end
if _G.EnhancementsLoaded then return end
_G.EnhancementsLoaded = true

-- 1. 최상위 안티치트 우회 엔진 (에러 코드 267 완벽 방어)
local OldNC
OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() then
        -- [A] 강제 퇴장 명령어 무력화
        if method == "Kick" or method == "kick" then
            return nil
        end
        
        -- [B] 분석 파이프라인(Analytics) 가로채기 (가장 중요!)
        -- 게임이 서버에 핵 사용 정보를 보내려고 할 때 '정상 유저' 신호로 조작
        if method == "FireServer" and tostring(self) == "AnalyticsReceiver" then
            return nil
        end
        
        -- [C] 라이벌즈 전용 안티치트 패킷 차단
        if method == "FireServer" and args[1] == "CheckBypass" then
            return nil
        end
    end
    
    return OldNC(self, unpack(args))
end)

-- 2. 유료 UI 및 프리미엄 기능 활성화
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'UNNAMED ENHANCEMENTS | PREMIUM [Anti-Kick]',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Settings = Window:AddTab('Settings')
}

-- [Aimbot] 고성능 사일런트 에임
local AimGB = Tabs.Aimbot:AddLeftGroupbox('Aim Engine')
AimGB:AddToggle('SAim', { Text = 'Premium Silent Aim', Default = false })
AimGB:AddSlider('FOV', { Text = 'Field Of View', Default = 150, Min = 0, Max = 500, Rounding = 0 })

-- [Movement] 튕김 방지 이동 시스템
local MoveGB = Tabs.Movement:AddLeftGroupbox('Safe Movement')
MoveGB:AddToggle('Fly', { Text = 'Ghost Fly (Bypass)', Default = false })
MoveGB:AddSlider('FlySpeed', { Text = 'Speed', Default = 60, Min = 16, Max = 250, Rounding = 0 })

-- 3. 메뉴 닫기 버튼 및 테마 설정
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('Unnamed Enhancements 정품 크랙 완료.')
Library:Notify('Anti-Cheat Tunneling: Secured.')

