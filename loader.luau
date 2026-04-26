-- [[ 1단계: CRACKER'S ULTIMATE BYPASS ENGINE ]]
if not getgenv().KEYLESS_BYPASS_EXECUTED then
    local g = getgenv()
    g._L_KEY = "CRACKED_BY_GEMINI"
    g.Key = "CRACKED"
    g.KeyEntered = true
    g.IsWhitelisted = true
    g.AuthSuccess = true
    g.Script_Key = "KEYLESS"
    g.Verified = true
    
    local old; old = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and key == "HttpGet" then
            return function(self, url)
                local u = url:lower()
                if u:find("luarmor") or u:find("key") or u:find("auth") or u:find("validate") then
                    print("🔓 [Bypass]: 보안 서버 응답을 가로채서 인증 성공으로 위조합니다.")
                    return '{"status":"success", "key_status":"valid", "whitelisted":true, "auth":true, "hwid":true}'
                end
                return old(self, key)(self, url)
            end
        end
        return old(self, key)
    end)

    local oldKick; oldKick = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and not checkcaller() then
            print("🚫 [Bypass]: 인증 실패로 인한 킥 시도를 차단했습니다.")
            return nil
        end
        return oldKick(self, ...)
    end)
    getgenv().KEYLESS_BYPASS_EXECUTED = true
end

-- [[ 2단계: 언네임드 로더 실행부 (코덱스 최적화 완료) ]]
if (getgenv().UC_LOADED) then return end;
getgenv().UC_LOADED = true;

-- Wave뿐만 아니라 Codex 등에서도 UI가 잘 뜨도록 수정함
if (identifyexecutor() == "Wave" or identifyexecutor() == "Codex" or identifyexecutor() == "Arcis") then
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

