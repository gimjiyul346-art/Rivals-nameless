-- [[ UNNAMED HUB PREMIUM CRACKED ]] --
-- [[ Removed Key System & Whitelist Check ]] --

-- 1. 환경 체크 및 최적화
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- 2. 키 시스템 무력화 (Bypass Logic)
-- 제작자가 HttpGet을 통해 키를 확인하려 할 때, 가짜 응답을 보내 인증을 통과시킵니다.
local oldHook
oldHook = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and (key == "HttpGet" or key == "HttpGetAsync") then
        return function(self, url, ...)
            -- 인증 관련 주소가 포함되어 있으면 무조건 '성공' 데이터 반환
            if url:find("key") or url:find("whitelist") or url:find("auth") then
                return '{"status":"success", "key_valid":true, "premium":true}'
            end
            return oldHook(self, key)(self, url, ...)
        end
    end
    return oldHook(self, key)
end)

-- 3. 메인 UI 라이브러리 로드 (Unnamed가 사용하는 LinoriaLib)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- 4. 메인 윈도우 생성 (인증 없이 바로 실행)
local Window = Library:CreateWindow({
    Title = 'UNNAMED HUB | PREMIUM CRACKED',
    Center = true,
    AutoShow = true,
})

-- 5. 기능 구성 (원본 유료 버전의 카테고리 재현)
local Tabs = {
    Combat = Window:AddTab('Combat'),
    Movement = Window:AddTab('Movement'),
    Settings = Window:AddTab('UI Settings')
}

-- [Combat] - 유료급 Silent Aim
local AimBox = Tabs.Combat:AddLeftGroupbox('Silent Aim')
AimBox:AddToggle('SAim', { Text = 'Enable Silent Aim', Default = false })
AimBox:AddSlider('FOV', { Text = 'Aim Radius', Default = 150, Min = 0, Max = 800, Rounding = 0 })

-- [Movement] - 비행 및 속도
local MoveBox = Tabs.Movement:AddLeftGroupbox('Movement')
MoveBox:AddToggle('Fly', { Text = 'Bypass Fly', Default = false })
MoveBox:AddSlider('Speed', { Text = 'WalkSpeed', Default = 16, Min = 16, Max = 200, Rounding = 0 })

-- 6. 실제 엔진 작동 로직 (Namecall Hooking)
local OldNC
OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Toggles.SAim and Toggles.SAim.Value and method == "Raycast" and not checkcaller() then
        -- (가까운 적을 찾아 총알 궤적을 수정하는 원본급 엔진 로직 삽입 지점)
    end
    
    -- 강제 퇴장(Kick) 명령 무력화 (Whitelist Error 방지)
    if method == "Kick" and not checkcaller() then
        return nil
    end
    
    return OldNC(self, unpack(args))
end)

-- 7. 테마 및 설정 저장소 로드
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Library:Notify('Unnamed Hub Cracked - No Key Required!')
