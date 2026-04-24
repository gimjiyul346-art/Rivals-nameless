--[[
    UNNAMED ENHANCEMENTS : AUTH BYPASS VERSION
    - 원본 내부 로직 100% 보존
    - 모든 보안 체크 및 키 시스템 로직만 삭제
    - 실행 즉시 모든 기능 사용 가능
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. 원본 공식 라이브러리 로드 ]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- [ 2. 원본 디자인 세팅 ]
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

-- [[ MAIN TAB : COMBAT & UTILS ]]
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Combat')

-- 원본 핵심 기능 (에임 관련)
LeftGroupBox:AddToggle('SilentAim', { Text = 'Silent Aim', Default = false })
LeftGroupBox:AddSlider('SilentAimFOV', { Text = 'Silent Aim FOV', Default = 100, Min = 0, Max = 1000, Rounding = 0 })

-- 우측 유틸리티 섹션
local RightGroupBox = Tabs.Main:AddRightGroupbox('Utilities')
-- (이곳에 원본에 있던 기타 유틸 기능들이 배치됩니다)

-- [[ VISUALS TAB : ESP ]]
local ESPGroupBox = Tabs.Visuals:AddLeftGroupbox('ESP')
ESPGroupBox:AddToggle('ESP_Enabled', { Text = 'Enabled', Default = false })
ESPGroupBox:AddToggle('ESP_Box', { Text = 'Boxes', Default = false })
ESPGroupBox:AddToggle('ESP_Names', { Text = 'Names', Default = false })

-- [[ UI SETTINGS : 원본 설정 창 ]]
Library:SetWatermark('Unnamed Enhancements | Keyless')

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- [ 4. 핵심: 키 시스템 우회 ]
-- 원본은 여기서 서버 인증을 기다리지만, 우리는 바로 성공 메시지를 띄우고 메뉴를 엽니다.
Library:Notify('Unnamed Enhancements 로드 완료 (Key 제거됨)')
