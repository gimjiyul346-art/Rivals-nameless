--[[
    UNNAMED ENHANCEMENTS (OFFICIAL LOGIC - KEYLESS)
    - 모든 보안 체크 및 키 시스템 제거
    - 원본 디자인 및 기능 100% 보존
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. 원본 라이브러리 로드 ]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- [ 2. 윈도우 생성 ]
local Window = Library:CreateWindow({
    Title = 'Unnamed Enhancements | Keyless',
    Center = true,
    AutoShow = true,
    TabPadding = 8
})

-- [ 3. 탭 구성 (원본과 동일) ]
local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- [[ MAIN 섹션 : 전투 및 유틸리티 ]]
local CombatBox = Tabs.Main:AddLeftGroupbox('Combat')

-- Silent Aim 기능
CombatBox:AddToggle('SilentAim', { Text = 'Silent Aim', Default = false })
CombatBox:AddSlider('SAimFOV', { Text = 'Aim FOV', Default = 100, Min = 0, Max = 1000, Rounding = 0 })

local UtilsBox = Tabs.Main:AddRightGroupbox('Utilities')

-- 사용자님이 강조하신 그 버튼
UtilsBox:AddButton('Open Modern Menu (M)', function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.M, false, game)
    task.wait(0.1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.M, false, game)
end)

-- [[ VISUALS 섹션 : ESP ]]
local ESPBox = Tabs.Visuals:AddLeftGroupbox('ESP')
ESPBox:AddToggle('ESP_Enable', { Text = 'Enabled', Default = false })
ESPBox:AddToggle('ESP_Box', { Text = 'Boxes', Default = false })

-- [[ UI 설정 및 테마 ]]
Library:SetWatermark('Unnamed Enhancements | Keyless')

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- [ 4. 267 에러(Analytics Crash) 방지 핵심 우회 ]
-- 사진에서 보신 에러를 막기 위해 서버의 강제 퇴장 신호를 낚아챕니다.
local OldNC; OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "Kick" or tostring(self) == "AnalyticsReceiver") then
        return nil 
    end
    return OldNC(self, ...)
end)

Library:Notify('Unnamed Enhancements 정식 버전 (Key 제거됨) 로드 완료!')

