-- [[ 1단계: Luarmor 보안 가로채기 (이게 핵심!) ]]
local oldHttpGet
oldHttpGet = hookmetamethod(game, "__index", function(self, index)
    if index == "HttpGet" and not checkcaller() then
        return function(self, url)
            -- Luarmor 인증 서버로 가는 요청을 감지
            if string.find(url, "api.luarmor.net") then
                print("🛡️ [Unnamed Bypass]: 보안 인증을 가로채서 통과시킵니다.")
                -- 서버에 묻지 않고 "성공" 응답을 가짜로 반환
                return '{"status":"success", "key":"CRACKED", "whitelisted":true}'
            end
            return oldHttpGet(self, index)(self, url)
        end
    end
    return oldHttpGet(self, index)
end)

-- [[ 2단계: 인증 변수 강제 설정 ]]
getgenv()._L_KEY = "KEYLESS_MODE"
getgenv().KeyEntered = true

-- [[ 3단계: 사용자님이 찾은 로더 코드 시작 ]]
if (getgenv().UC_LOADED) then
	return;
end;
getgenv().UC_LOADED = true;

if (identifyexecutor() == "Wave" or identifyexecutor() == "Codex") then
	getgenv().gethui = function()
		return game:GetService("CoreGui");
	end;	
end;

if (game.GameId == 6035872082) then
	loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/b6956594687d0095f5afdd3e2a2056ad.lua"))();
elseif (game.GameId == 1008451066) then
	loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/0326476cc171449b7563fb4e5eae0415.lua"))();
elseif (game.PlaceId == 2317712696) then
	loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/86943e213581a8598e8a38e5bba4c975.lua"))();
end;

