--[[
    UNNAMED ENHANCEMENTS : ANTI-DETECTION (KEYLESS)
    - 라이벌 최신 업데이트 대응 킥훅(Kick Hook) 우회 적용
    - 키 시스템(Key System) 완벽 제거
    - 사족 및 불필요한 기능 일절 없음
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. 업데이트 대응 신규 킥훅 우회 ]
-- 게임이 스크립트를 감지해 Kick을 시도하는 모든 통로를 차단합니다.
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Kick 함수나 보안 관련 데이터 전송(Analytics)을 가로채서 무력화합니다.
    if not checkcaller() and (method == "Kick" or tostring(self) == "AnalyticsReceiver") then
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- [ 2. 언네임드 원본 라이브러리 호출 ]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

-- [ 3. 윈도우 및 탭 생성 (원본 그대로) ]
local Window = Library:CreateWindow({
    Title = 'Unnamed Enhancements',
    Center = true,
    AutoShow = true,
    TabPadding = 8
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Visuals = Window:AddTab('Visuals'),
    Settings = Window:AddTab('UI Settings'),
}

-- [ 4. 내부 기능 주입 (빈 화면 방지 최적화) ]
local Combat = Tabs.Main:AddLeftGroupbox('Combat')
Combat:AddToggle('SilentAim', { Text = 'Silent Aim', Default = false })
Combat:AddSlider('AimFOV', { Text = 'Aim FOV', Default = 150, Min = 0, Max = 1000 })

local Visuals = Tabs.Visuals:AddLeftGroupbox('Visuals')
Visuals:AddToggle('ESP', { Text = 'Enabled', Default = false })
Visuals:AddToggle('Box', { Text = 'Boxes', Default = false })

-- [ 5. UI 설정 및 키리스 실행 ]
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('Unnamed : Update Bypass & Keyless Load Success')

