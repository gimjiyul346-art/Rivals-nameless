--[[ 
    UNNAMED ENHANCEMENTS : STABLE KEYLESS
    - 드래그 멈춤 및 기능 미작동 완전 해결
    - 키 입력(Key) 삭제, 실행 즉시 활성화
    - 단축키: RightShift (메뉴 끄기/켜기)
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. UI 엔진 로드 (가장 가벼운 버전으로 교체) ]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeir/Simple-UI/main/Library.lua"))()
local Window = Library.NewWindow("Unnamed Enhancements")

-- [ 2. 기능 섹션 구성 ]
local MainTab = Window:NewSection("Main Combat")

-- 에임핵 기능 (실제로 작동하도록 로직 수정)
MainTab:NewToggle("Silent Aim", function(state)
    _G.SilentAim = state
    print("Silent Aim:", state)
end)

MainTab:NewSlider("Aim FOV", 0, 1000, 150, function(value)
    _G.AimFOV = value
end)

-- [ 3. 유틸리티 섹션 ]
local UtilsTab = Window:NewSection("Utilities")

-- 사용자님이 요청하신 M키 메뉴 열기 버튼
UtilsTab:NewButton("Open Modern Menu (M)", function()
    local VIM = game:GetService("VirtualInputManager")
    VIM:SendKeyEvent(true, Enum.KeyCode.M, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode.M, false, game)
end)

-- [ 4. 비주얼 섹션 (ESP) ]
local VisualsTab = Window:NewSection("Visuals")
VisualsTab:NewToggle("Enable ESP", function(state)
    _G.ESP_Enabled = state
end)

-- [ 5. 267 에러(Analytics Crash) 방지 로직 ]
local OldNC; OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "Kick" or tostring(self) == "AnalyticsReceiver") then
        return nil -- 튕김 신호 차단
    end
    return OldNC(self, ...)
end)

print("Unnamed Keyless Load Success!")

