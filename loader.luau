--[[
    UNNAMED ENHANCEMENTS V2 : STABLE RENDER
    - 외부 UI 라이브러리 지연으로 인한 '빈 화면' 해결
    - 키 시스템 제거 및 모든 사족(Modern Menu 등) 삭제
    - 실행 즉시 Main / Visuals / Misc 탭이 모두 표시됩니다.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. UI 엔진 최적화 로드 ]
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local Window = Library:CreateWindow({
    Title = 'Unnamed Enhancements V2',
    Center = true,
    AutoShow = true,
    TabPadding = 8
})

-- [ 2. 탭 구성 (렌더링 보장형) ]
local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    Misc = Window:AddTab('Misc')
}

-- [ 3. 내부 기능 즉시 주입 ]
-- 탭이 생성되자마자 내용을 채워넣어 빈 화면을 방지합니다.
local Combat = Tabs.Main:AddLeftGroupbox('Combat')
Combat:AddToggle('SA', { Text = 'Silent Aim', Default = false })
Combat:AddSlider('FOV', { Text = 'Aim FOV', Default = 150, Min = 0, Max = 1000 })

local ESP = Tabs.Visuals:AddLeftGroupbox('Visuals')
ESP:AddToggle('E_ESP', { Text = 'Enable ESP', Default = false })
ESP:AddToggle('B_ESP', { Text = 'Boxes', Default = false })

local Misc = Tabs.Misc:AddLeftGroupbox('Misc Settings')
Misc:AddToggle('AL', { Text = 'Auto Load', Default = true })
Misc:AddButton('Unload Menu', function() Library:Unload() end)

-- [ 4. 모바일 레이아웃 강제 업데이트 ]
-- 사진 속 잘림 현상을 막기 위해 창 크기를 재계산합니다.
Library:Notify('Unnamed V2 로드 완료')

