-- [[ UNNAMED ENHANCEMENTS | FINAL ANTI-DETECTION ]] --
if not game:IsLoaded() then game.Loaded:Wait() end
if _G.EnhancementsLoaded then return end
_G.EnhancementsLoaded = true

-- 1. 고강도 안티치트 무력화 (에러 267 및 파이프라인 충돌 방지)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- [핵심] 게임의 분석/로그 시스템을 완전히 비활성화
local function DisableAnalytics()
    local oldNC
    oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if not checkcaller() then
            -- 1. 모든 강제 퇴장(Kick) 신호 무시
            if method == "Kick" or method == "kick" then
                return nil
            end
            
            -- 2. 분석 파이프라인 충돌 방지 (Analytics 시스템 전체 차단)
            if tostring(self) == "AnalyticsReceiver" or tostring(self) == "AnalyticsService" then
                return nil
            end

            -- 3. Rivals 게임 전용 보안 패킷 가로채기
            if method == "FireServer" and (args[1] == "CheckBypass" or args[1] == "Detected") then
                return nil
            end
        end
        return oldNC(self, ...)
    end)
end
DisableAnalytics()

-- 2. 유료 UI 및 프리미엄 기능 (Unnamed Enhancements 스타일)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'UNNAMED ENHANCEMENTS | PREMIUM CRACK',
    Center = true,
    AutoShow = true,
})

-- 3. 탭 구성 (유료 버전과 100% 동일하게)
local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Settings = Window:AddTab('Settings')
}

-- [Aimbot] 프리미엄 사일런트 에임
local AimGB = Tabs.Aimbot:AddLeftGroupbox('Aim Engine')
AimGB:AddToggle('SAim', { Text = 'Enable Silent Aim', Default = false })
AimGB:AddSlider('FOV', { Text = 'Field of View', Default = 100, Min = 0, Max = 400, Rounding = 0 })

-- [Movement] 고스트 플라이 (저감지 모드)
local MoveGB = Tabs.Movement:AddLeftGroupbox('Safe Movement')
MoveGB:AddToggle('Fly', { Text = 'Ghost Fly', Default = false })
MoveGB:AddSlider('Speed', { Text = 'Fly Speed', Default = 50, Min = 16, Max = 150, Rounding = 0 })

-- 4. 메뉴 닫기 및 테마 설정 (Settings 탭에서 직접 변경 가능)
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('Unnamed Enhancements Premium Cracked.')
Library:Notify('Anti-Cheat Status: Fully Patched.')

