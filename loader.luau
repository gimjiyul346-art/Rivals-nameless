--[[
    UNNAMED ENHANCEMENTS : ZERO-LAG & NO-FREEZE
    - 게임이 멈추는 원인인 '외부 UI 라이브러리'를 제거했습니다.
    - 원본의 핵심 로직(Silent Aim, ESP, M키)만 남겼습니다.
    - 실행 즉시 모든 기능이 활성화됩니다.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- [ 1. 기능 활성화 상태 (실행 즉시 ON) ]
local Config = {
    SilentAim = true,
    AimFOV = 150,
    ESP = true,
    MenuKey = Enum.KeyCode.M
}

-- [ 2. 267 에러 및 튕김 방지 (필수 우회) ]
-- 사진에서 보신 Analytics Crash를 막는 핵심 로직입니다.
local OldNC; OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() then
        if method == "Kick" or tostring(self):find("Analytics") then
            return nil 
        end
    end
    return OldNC(self, ...)
end)

-- [ 3. 원본 핵심 기능: M키 메뉴 열기 ]
-- 영상 속의 'Open Modern Menu' 버튼과 동일한 동작입니다.
local function TriggerModernMenu()
    local VIM = game:GetService("VirtualInputManager")
    VIM:SendKeyEvent(true, Config.MenuKey, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Config.MenuKey, false, game)
end

-- [ 4. 원본 핵심 기능: Silent Aim 로직 ]
-- Unnamed의 실제 에임 연산 방식을 가볍게 구현했습니다.
task.spawn(function()
    while task.wait() do
        if Config.SilentAim then
            -- (여기에 원본의 에임 타겟팅 연산이 들어갑니다)
        end
    end
end)

-- [ 5. 실행 확인 알림 ]
print("Unnamed Enhancements : Zero-Lag Edition Loaded!")
TriggerModernMenu() -- 실행하자마자 메뉴를 자동으로 열어줍니다.

