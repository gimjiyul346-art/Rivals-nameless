-- [[ 인증/팔로우/그룹가입 ZERO 언네임드 ]]
if not game:IsLoaded() then game.Loaded:Wait() end

-- 1. UI 라이브러리 (이건 인증 없는 공용 서버에서 가져옵니다)
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()

-- 2. 메뉴 생성 (실행 즉시 나타남)
local Window = Library:CreateWindow({
    Title = 'Unnamed Enhancements (No-Auth)',
    Center = true,
    AutoShow = true,
})

-- 3. 기능 구성 (영상에서 보던 에임핵/ESP)
local Main = Window:AddTab('Main')
local Visuals = Window:AddTab('Visuals')

local Combat = Main:AddLeftGroupbox('Combat')
Combat:AddToggle('SA', { Text = 'Silent Aim', Default = false })
Combat:AddSlider('FOV', { Text = 'Aim FOV', Default = 150, Min = 0, Max = 1000 })

local ESP = Visuals:AddLeftGroupbox('Visuals')
ESP:AddToggle('E', { Text = 'Enable ESP', Default = false })
ESP:AddToggle('B', { Text = 'Boxes', Default = false })

Library:Notify('인증 시스템이 제거된 버전입니다.')

