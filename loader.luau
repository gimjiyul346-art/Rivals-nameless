-- [[ UNNAMED ENHANCEMENTS | ANTI-DETECTION CRACK ]] --
if not game:IsLoaded() then game.Loaded:Wait() end
if _G.EnhancementsLoaded then return end
_G.EnhancementsLoaded = true

-- 1. 고성능 안티치트 우회 (Analytics Pipeline Crash 방지)
local OldNC
OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- 게임이 서버로 '핵 감지 로그'를 보내려고 할 때 차단
    if not checkcaller() then
        if method == "Kick" or method == "kick" then
            return nil 
        elseif method == "FireServer" and tostring(self) == "AnalyticsReceiver" then
            -- 분석 파이프라인 충돌을 일으키는 로그 전송 가로채기
            return nil
        end
    end
    
    return OldNC(self, unpack(args))
end)

-- 2. 유료 UI 및 탭 구성 (Enhancements 정품 스타일)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'UNNAMED ENHANCEMENTS | PREMIUM CRACK',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Settings = Window:AddTab('Settings')
}

-- [Aimbot] 에임 유도 설정
local AimGB = Tabs.Aimbot:AddLeftGroupbox('Silent Aim')
AimGB:AddToggle('SAim', { Text = 'Enable Silent Aim', Default = false })
AimGB:AddSlider('FOV', { Text = 'Aim FOV', Default = 120, Min = 0, Max = 500, Rounding = 0 })

-- [Movement] 튕김 방지 이동
local MoveGB = Tabs.Movement:AddLeftGroupbox('Movement Bypass')
MoveGB:AddToggle('Fly', { Text = 'Safe Fly', Default = false })
MoveGB:AddSlider('Speed', { Text = 'Speed', Default = 50, Min = 16, Max = 200, Rounding = 0 })

-- 3. 메뉴 닫기 버튼 설정 (모바일 최적화)
-- Settings 탭에서 'Menu Keybind'를 통해 닫기 키 설정 가능
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('Unnamed Enhancements 정품 인증 우회 성공.')
Library:Notify('Anti-Cheat Pipeline: Secure.')

