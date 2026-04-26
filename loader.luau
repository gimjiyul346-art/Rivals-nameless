-- [[ UNNAMED NO-KEY DIRECT LOAD ]]

-- 1. 언네임드 UI 라이브러리 직접 호출 (보안 없음)
local UnnamedLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-upsfor-luas/main/unnamed%20esp"))()

-- 2. 실행기 최적화 (코덱스 등에서 UI가 잘 보이게 설정)
if (identifyexecutor() == "Wave" or identifyexecutor() == "Codex") then
    getgenv().gethui = function()
        return game:GetService("CoreGui")
    end
end

-- 3. 메뉴 생성 및 기능 실행
-- 라이브러리가 로드되면 자동으로 기본 메뉴와 ESP 기능이 활성화됩니다.
print("------------------------------------------")
print("   UNNAMED DIRECT LIBRARY LOADED         ")
print("   STATUS: KEYLESS / NO AUTH             ")
print("------------------------------------------")

-- 만약 특정 게임(Rivals 등) 전용 기능을 더 넣고 싶다면 이 아래에 추가하면 됩니다.
UnnamedLib:Watermark("Unnamed | Keyless Mode")

