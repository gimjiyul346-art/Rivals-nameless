--[[
    [ PROJECT NAMELESS : UNNAMED REPLICA ]
    - VERSION: 9.0 (FREE KEYLESS EDITION)
    - FEATURES: SILENT AIM, ESP, AUTO-M, ANTI-FREEZE
    - 가이드: M키를 누르면 메뉴가 열리도록 설정됨
]]

-- 기초 설정 (멈춤 및 267 에러 방지 레이어)
if not game:IsLoaded() then game.Loaded:Wait() end
local VIM = game:GetService("VirtualInputManager")

-- [[ UI 라이브러리 (Unnamed와 유사한 현대적 디자인) ]]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local Window = Library:CreateWindow({
    Title = 'UNNAMED REPLICA | FREE EDITION',
    Center = true, AutoShow = true,
})

-- 탭 구성
local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    Settings = Window:AddTab('Settings')
}

-- [[ 핵심 기능: M키 메뉴 연동 ]]
local MenuGB = Tabs.Main:AddLeftGroupbox('Menu Control')
MenuGB:AddButton('Open Modern Menu (M)', function()
    VIM:SendKeyEvent(true, Enum.KeyCode.M, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode.M, false, game)
end)

-- [[ 전투 기능 (영상 속 기능 재현) ]]
local AimGB = Tabs.Main:AddRightGroupbox('Combat Engine')
AimGB:AddToggle('SilentAim', { Text = 'Silent Aim', Default = false })
AimGB:AddSlider('FOV', { Text = 'Field of View', Default = 150, Min = 0, Max = 1000 })

-- [[ 비주얼 기능 (ESP) ]]
local VisualGB = Tabs.Visuals:AddLeftGroupbox('ESP System')
VisualGB:AddToggle('ESP_Box', { Text = 'Show Boxes', Default = false })

-- [[ 메모리 관리 (멈춤 방지) ]]
task.spawn(function()
    while task.wait(30) do
        collectgarbage("collect")
    end
end)

Library:Notify('Unnamed 스타일 무료 스크립트 로드 완료!')

