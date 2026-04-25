--[[
    UNNAMED ENHANCEMENTS : NO-AUTH BYPASS
    - 팔로우 인증 및 외부 게이트 시스템 100% 제거
    - 최신 라이벌 업데이트 대응 킥훅(Kick-Hook) 내장
    - 메뉴 빈 화면 및 잘림 현상 방지 최적화
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. 킥훅 및 안티치트 우회 (최우선 실행) ]
local rawmt = getrawmetatable(game)
local oldNamecall = rawmt.__namecall
setreadonly(rawmt, false)

rawmt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" or tostring(self) == "AnalyticsReceiver" then
        return nil -- 킥 시도를 무시합니다.
    end
    return oldNamecall(self, ...)
end)
setreadonly(rawmt, true)

-- [ 2. 라이브러리 및 언네임드 핵심 엔진 로드 ]
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()

-- [ 3. 윈도우 생성 (인증 없이 바로 실행) ]
local Window = Library:CreateWindow({
    Title = 'Unnamed Enhancements | Cracked & Keyless',
    Center = true,
    AutoShow = true,
    TabPadding = 8
})

-- [ 4. 기능 탭 구성 (원본 그대로) ]
local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    Settings = Window:AddTab('UI Settings'),
}

-- [[ MAIN : COMBAT ]]
local Combat = Tabs.Main:AddLeftGroupbox('Combat')
Combat:AddToggle('SA', { Text = 'Silent Aim', Default = false })
Combat:AddSlider('FOV', { Text = 'Aim FOV', Default = 150, Min = 0, Max = 1000 })

-- [[ VISUALS : ESP ]]
local ESP = Tabs.Visuals:AddLeftGroupbox('Visuals')
ESP:AddToggle('ESP', { Text = 'Enabled', Default = false })
ESP:AddToggle('Box', { Text = 'Boxes', Default = false })

-- [ 5. UI 안정화 로직 ]
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('인증 시스템 우회 완료 - 즉시 사용 가능')

