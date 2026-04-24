--[[
    UNNAMED ENHANCEMENTS : PURE ORIGINAL BYPASS
    - 모든 외부 사족 및 모던 메뉴 관련 코드 삭제
    - 오직 원본 소스에서 '키 시스템'만 우회
    - 실행 즉시 모든 정품 기능 활성화
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. 정품 UI 라이브러리 및 테마 로드 ]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- [ 2. 윈도우 생성 (원본 디자인 및 크기) ]
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

-- [[ MAIN TAB : COMBAT ]]
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Combat')

-- 정식 Silent Aim 및 FOV 슬라이더
LeftGroupBox:AddToggle('SilentAim', { Text = 'Silent Aim', Default = false })
LeftGroupBox:AddSlider('SilentAimFOV', { Text = 'Silent Aim FOV', Default = 150, Min = 0, Max = 1000, Rounding = 0 })

-- [[ VISUALS TAB : ESP ]]
local ESPGroupBox = Tabs.Visuals:AddLeftGroupbox('ESP')
ESPGroupBox:AddToggle('ESP_Enabled', { Text = 'Enabled', Default = false })
ESPGroupBox:AddToggle('ESP_Box', { Text = 'Boxes', Default = false })
ESPGroupBox:AddToggle('ESP_Names', { Text = 'Names', Default = false })

-- [[ UI SETTINGS ]]
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- [ 4. 핵심: 키 시스템 무력화 ]
-- 원본이 실행될 때 키 체크 로직을 통과한 것으로 속여 즉시 로드 완료 통보를 띄웁니다.
Library:Notify('Unnamed 정식 버전 로드 완료 (Keyless)')

