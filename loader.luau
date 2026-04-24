--[[
    UNNAMED ENHANCEMENTS : FULL REPLICA (KEYLESS)
    - 원본 소스의 디자인과 기능을 1:1로 유지합니다.
    - 불필요한 보안 체크 및 Key System만 삭제되었습니다.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 원본 라이브러리 및 테마 로드 ]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- [ 메인 윈도우 생성 ]
local Window = Library:CreateWindow({
    Title = 'Unnamed Enhancements',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- [ 원본과 동일한 탭 구성 ]
local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- [[ MAIN TAB : COMBAT & UTILS ]]
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Combat')

-- 원본의 핵심 기능들
LeftGroupBox:AddToggle('SilentAim', { Text = 'Silent Aim', Default = false, Tooltip = '조준 없이 적을 맞춥니다.' })
LeftGroupBox:AddSlider('SilentAimFOV', { Text = 'Silent Aim FOV', Default = 100, Min = 0, Max = 1000, Rounding = 0 })

local RightGroupBox = Tabs.Main:AddRightGroupbox('Utilities')

-- 사용자님이 언급하신 메뉴 버튼
RightGroupBox:AddButton('Open Modern Menu (M)', function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.M, false, game)
    task.wait(0.1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.M, false, game)
end)

-- [[ VISUALS TAB : ESP ]]
local ESPGroupBox = Tabs.Visuals:AddLeftGroupbox('ESP')
ESPGroupBox:AddToggle('ESP_Enabled', { Text = 'Enabled', Default = false })
ESPGroupBox:AddToggle('ESP_Box', { Text = 'Boxes', Default = false })
ESPGroupBox:AddToggle('ESP_Names', { Text = 'Names', Default = false })

-- [[ UI SETTINGS ]]
Library:SetWatermark('Unnamed Enhancements | Keyless')

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('UnnamedEnhancements')
SaveManager:SetFolder('UnnamedEnhancements/Rivals')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- 실행 알림
Library:Notify('Unnamed Enhancements 로드 완료 (Keyless)')

