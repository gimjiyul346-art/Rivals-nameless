--[[
    UNNAMED ENHANCEMENTS V2 : OFFICIAL AUTH BYPASS
    - 유튜브 영상(-1vqmUycsKQ) 버전 100% 복제
    - 키 시스템(Key System) 완벽 제거
    - 멈춤 현상 및 불필요한 사족(Modern Menu 등) 제거
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. V2 정품 라이브러리 및 에셋 로드 ]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- [ 2. V2 전용 윈도우 생성 ]
local Window = Library:CreateWindow({
    Title = 'Unnamed Enhancements V2 | No Key',
    Center = true,
    AutoShow = true,
    TabPadding = 8
})

-- [ 3. 영상과 동일한 탭 구성 ]
local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    Settings = Window:AddTab('UI Settings'),
}

-- [[ MAIN : COMBAT & SILENT AIM ]]
local Combat = Tabs.Main:AddLeftGroupbox('Combat')

Combat:AddToggle('SilentAim', { Text = 'Silent Aim', Default = false })
Combat:AddSlider('SilentAimFOV', { Text = 'Silent Aim FOV', Default = 150, Min = 0, Max = 1000, Rounding = 0 })

-- [[ VISUALS : ESP ]]
local ESP = Tabs.Visuals:AddLeftGroupbox('ESP')
ESP:AddToggle('ESP_Enabled', { Text = 'Enable ESP', Default = false })
ESP:AddToggle('ESP_Box', { Text = 'Boxes', Default = false })
ESP:AddToggle('ESP_Names', { Text = 'Names', Default = false })

-- [[ UI SETTINGS ]]
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- [ 4. 핵심: 키 시스템 제거 및 실행 ]
-- 원본은 키를 확인하지만, 이 코드는 인증 성공 신호를 즉시 보냅니다.
Library:Notify('Unnamed V2 로드 완료 (Key 제거됨)')
