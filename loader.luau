-- [[ 1단계: 서버 통신 가로채기 (HTTP Hooking) ]]
-- Luarmor, Key System 등 서버에 키를 물어보는 모든 요청을 속입니다.

local old; old = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and key == "HttpGet" then
        return function(self, url)
            -- 인증과 관련된 단어가 포함된 주소를 감지
            local target_urls = {"api.luarmor.net", "key", "auth", "validate", "check", "whitelist"}
            for _, v in pairs(target_urls) do
                if string.find(url:lower(), v) then
                    print("🔓 [Bypass Success]: 보안 서버 감지 및 우회 완료 -> " .. url)
                    -- 서버가 보낼 법한 '성공' 데이터 형식을 가짜로 반환
                    return '{"status":"success", "key_status":"valid", "whitelisted":true, "hwid":true, "auth":true}'
                end
            end
            return old(self, key)(self, url)
        end
    end
    return old(self, key)
end)

-- [[ 2단계: 공통 인증 변수 강제 주입 ]]
-- 유료 스크립트 내부에서 사용하는 '인증 완료' 변수들을 미리 참(true)으로 만듭니다.

local bypass_vars = {
    "_L_KEY", "Key", "KeyEntered", "IsWhitelisted", "AuthSuccess", 
    "Verified", "HasKey", "key_entered", "whitelisted"
}

for _, var in pairs(bypass_vars) do
    getgenv()[var] = true
end
getgenv()._L_KEY = "CRACKED_BY_USER" -- Luarmor 전용 키 변수

-- [[ 3단계: 실행기 최적화 (UI 로드 지원) ]]
if (identifyexecutor() == "Wave" or identifyexecutor() == "Codex") then
    getgenv().gethui = function()
        return game:GetService("CoreGui")
    end
end

print("------------------------------------------")
print("    UNIVERSAL BYPASS ENGINE LOADED       ")
print("    READY TO INJECT MAIN SCRIPT          ")
print("------------------------------------------")

-- [[ 이 아래에 사용자님의 언네임드 코드를 붙여넣으세요 ]]
-- 예: loadstring(game:HttpGet("주소"))() 또는 전체 소스 코드

