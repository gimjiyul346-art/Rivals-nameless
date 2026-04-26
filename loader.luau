-- [[ 1. SECURITY BYPASS ENGINE ]]
-- 이 엔진이 Luarmor 보안 서버의 응답을 가짜로 만들어 키 입력을 건너뜁니다.

if not getgenv().BYPASS_EXECUTED then
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, index)
        if index == "HttpGet" and not checkcaller() then
            return function(self, url)
                -- 보안 서버(Luarmor) 주소를 가로채서 무조건 '성공' 메시지를 보냄
                if string.find(url, "api.luarmor.net") or string.find(url, "check") then
                    print("🛡️ [Unnamed Bypass]: Security check bypassed successfully.")
                    return '{"status":"success", "key":"valid", "whitelisted":true, "hwid":true}'
                end
                return oldIndex(self, index)(self, url)
            end
        end
        return oldIndex(self, index)
    end)
    
    -- 전역 변수 강제 활성화 (인증 통과 상태로 만듦)
    getgenv()._L_KEY = "CRACKED_BY_USER"
    getgenv().KeyEntered = true
    getgenv().IsWhitelisted = true
    getgenv().BYPASS_EXECUTED = true
end

-- [[ 2. LOADSTRING OPTIMIZATION ]]
-- 실행기(Codex 등)가 UI를 제대로 그리도록 설정합니다.

if (identifyexecutor() == "Wave" or identifyexecutor() == "Codex") then
    getgenv().gethui = function()
        return game:GetService("CoreGui")
    end
end

-- [[ 3. UNNAMED LOADER EXECUTION ]]
-- 사용자님이 찾으신 원본 로더 코드입니다.

if (getgenv().UC_LOADED) then
    return
end
getgenv().UC_LOADED = true

-- 게임별 로드 (Rivals 등 자동 감지)
if (game.GameId == 6035872082) then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/b6956594687d0095f5afdd3e2a2056ad.lua"))()
elseif (game.GameId == 1008451066) then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/0326476cc171449b7563fb4e5eae0415.lua"))()
elseif (game.PlaceId == 2317712696) then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/86943e213581a8598e8a38e5bba4c975.lua"))()
end

print("------------------------------------------")
print(" UNNAMED ENHANCEMENTS: BYPASS ACTIVE ")
print(" STATUS: KEYLESS MODE ")
print("------------------------------------------")

