-- [[ UNNAMED ENHANCEMENTS | PREMIUM BYPASS ]] --
-- [[ CRACKED & DISTRIBUTED ON GITHUB ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
if _G.EnhancementsLoaded then return end
_G.EnhancementsLoaded = true

-- 1. 최신 보안 우회 (Bypass) 및 후킹 엔진
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

local OldNC; OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Whitelist & Kick Bypass
    if not checkcaller() and (method == "Kick" or method == "kick") then
        return nil
    end
    
    -- Unnamed Enhancements 특유의 Raycast 변조 에임 엔진
    if Toggles and Toggles.SilentAim and Toggles.SilentAim.Value and method == "Raycast" and not checkcaller() then
        -- (에임 유도 로직...)
    end

    return OldNC(self, unpack(args))
end)

-- 2. 유료 UI 라이브러리 로드 (Enhancements 스타일)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

-- 3. 메인 윈도우 생성 (이름 변경: Unnamed Enhancements)
local Window = Library:CreateWindow({
    Title = 'UNNAMED ENHANCEMENTS | PREMIUM [v2.4.1]',
    Center = true,
    AutoShow = true,
})

-- 4. 유료 버전 전용 탭 구성
local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Automation = Window:AddTab('Automation'),
    Misc = Window:AddTab('Misc'),
    ['Settings'] = Window:AddTab('Settings')
}

-- [Aimbot] 최신 사일런트 에임 옵션
local AimGB = Tabs.Aimbot:AddLeftGroupbox('Silent Aim')
AimGB:AddToggle('SilentAim', { Text = 'Enabled', Default = false })
AimGB:AddSlider('FOV', { Text = 'Field of View', Default = 150, Min = 0, Max = 800, Rounding = 0 })
AimGB:AddDropdown('Target', { Text = 'Priority', Default = 'Head', Values = { 'Head', 'Torso', 'Nearest' } })

-- [Visuals] 유료급 ESP (Chams 포함)
local VisGB = Tabs.Visuals:AddLeftGroupbox('ESP Enhancements')
VisGB:AddToggle('Boxes', { Text = 'Enemy Boxes', Default = false })
VisGB:AddToggle('Chams', { Text = 'Wallhack Chams', Default = false })

-- [Movement] 안티치트 우회 이동
local MoveGB = Tabs.Movement:AddLeftGroupbox('Bypass Movement')
MoveGB:AddToggle('Fly', { Text = 'Enhanced Fly', Default = false })
MoveGB:AddSlider('Speed', { Text = 'Fly Speed', Default = 100, Min = 16, Max = 350, Rounding = 0 })
MoveGB:AddToggle('NoClip', { Text = 'NoClip (N)', Default = false })

-- 5. 메뉴 닫기 기능 추가 (Settings 탭)
-- 모바일 배려: Settings 탭에서 'Menu Keybind'를 통해 닫기 키를 직접 지정 가능
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

-- 6. 알림 (Premium 등급 표시)
Library:Notify('Unnamed Enhancements Premium Acquired.')
Library:Notify('Welcome, White-Listed User.')

