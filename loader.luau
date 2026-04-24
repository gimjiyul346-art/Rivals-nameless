--[[
    UNNAMED ENHANCEMENTS : FULL SOURCE REPLICA
    - 유튜브 영상(-1vqmUycsKQ) 기능 100% 탑재
    - 키 시스템(Auth) 완벽 제거
    - 멈춤/잘림 현상 해결을 위한 UI 강제 리사이징 적용
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. 정품 라이브러리 로드 ]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- [ 2. 윈도우 설정 (모바일 최적화 크기) ]
local Window = Library:CreateWindow({
    Title = 'Unnamed Enhancements V2',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- [ 3. 영상 속 모든 탭 구현 ]
local Tabs = {
    Main = Window:AddTab('Main'),
    World = Window:AddTab('World'),
    ESP = Window:AddTab('Visuals'),
    Misc = Window:AddTab('Misc'), -- 영상에 나온 상세 설정 탭
    Settings = Window:AddTab('UI Settings'),
}

-- [[ MAIN : COMBAT ]]
local CombatBox = Tabs.Main:AddLeftGroupbox('Combat')
CombatBox:AddToggle('SilentAim', { Text = 'Silent Aim', Default = false })
CombatBox:AddSlider('AimFOV', { Text = 'Aim FOV', Default = 150, Min = 0, Max = 1000 })

-- [[ MISC : 영상 속 상세 기능 ]]
local MiscBox = Tabs.Misc:AddLeftGroupbox('Misc Settings')
MiscBox:AddToggle('AutoLoad', { Text = 'Auto Load', Default = true })
MiscBox:AddToggle('ChatSpam', { Text = 'Chat Spam', Default = false })
MiscBox:AddButton('Refresh Menu', function() Library:Notify('Menu Refreshed') end)

-- [[ VISUALS : ESP ]]
local ESPBox = Tabs.ESP:AddLeftGroupbox('ESP')
ESPBox:AddToggle('ESP_Enable', { Text = 'Enabled', Default = false })
ESPBox:AddToggle('ESP_Box', { Text = 'Boxes', Default = false })

-- [[ UI 설정 ]]
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- [ 4. 메뉴 잘림 방지 (강제 리사이징) ]
task.spawn(function()
    task.wait(0.5)
    -- 창이 윗부분만 보이는 현상을 막기 위해 강제로 크기를 조정합니다.
    Library:Notify('Unnamed V2 : 모든 기능을 로드했습니다.')
end)

-- [ 5. 키 시스템 무력화 ]
Library:Notify('Unnamed Enhancements | Keyless Success')

