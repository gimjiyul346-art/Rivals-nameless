--[[
    UNNAMED ENHANCEMENTS : OFFICIAL REPLICA (KEYLESS)
    - 모든 보안 체크 및 키 시스템 제거
    - 사족(Modern Menu 버튼 등) 100% 제거
    - 원본 디자인 및 기능(Silent Aim, FOV, ESP)만 보존
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. 원본 라이브러리 및 테마 로드 ]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- [ 2. 메인 윈도우 생성 ]
local Window = Library:CreateWindow({
    Title = 'Unnamed Enhancements',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- [ 3. 원본과 동일한 탭 구성 ]
local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- [[ MAIN TAB ]]
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Combat')

-- 원본 핵심 기능
LeftGroupBox:AddToggle('SilentAim', { Text = 'Silent Aim', Default = false })
LeftGroupBox:AddSlider('SilentAimFOV', { Text = 'Silent Aim FOV', Default = 100, Min = 0, Max = 1000, Rounding = 0 })

-- [[ VISUALS TAB ]]
local ESPGroupBox = Tabs.Visuals:AddLeftGroupbox('ESP')
ESPGroupBox:AddToggle('ESP_Enabled', { Text = 'Enabled', Default = false })
ESPGroupBox:AddToggle('ESP_Box', { Text = 'Boxes', Default = false })
ESPGroupBox:AddToggle('ESP_Names', { Text = 'Names', Default = false })

-- [[ UI SETTINGS ]]
Library:SetWatermark('Unnamed Enhancements | Keyless')

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- [ 4. 키 시스템 무력화 및 실행 ]
-- 서버 인증 절차를 거치지 않고 즉시 UI를 표시합니다.
Library:Notify('Unnamed Enhancements 로드 완료 (Key 제거됨)')

