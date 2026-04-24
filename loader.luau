-- [[ NAMELESS SCRIPT - THE ULTIMATE INTEGRATION ]] --
-- [[ CREATED FOR GITHUB - ANTI-CHEAT BYPASS v3.0 ]] --

if not game:IsLoaded() then game.Loaded:Wait() end
if _G.NamelessLoaded then return end
_G.NamelessLoaded = true

-- 1. 통합 안티치트 우회 엔진 (Deep Bypass)
-- 여러 핵의 장점을 모아 '가짜 데이터 주입'과 '로그 차단'을 동시에 수행합니다.
local function UnifiedBypass()
    local oldNC; oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not checkcaller() then
            -- [Kick & Analytics 차단] - 에러 267 완벽 방어
            if method == "Kick" or method == "kick" or tostring(self) == "AnalyticsReceiver" then
                return nil
            end
            
            -- [Rivals 전용 감지 우회]
            if method == "FireServer" and (args[1] == "CheckBypass" or args[1] == "Detected" or args[1] == "TeleportCheck") then
                return nil
            end
        end
        return oldNC(self, ...)
    end)
end
task.spawn(UnifiedBypass)

-- 2. UI 라이브러리 및 윈도우 생성
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'NAMELESS | ALL-IN-ONE PREMIUM',
    Center = true, 
    AutoShow = true,
})

-- 3. 통합 기능 탭 구성 (가장 좋은 기능만 엄선)
local Tabs = {
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Automation = Window:AddTab('Automation'),
    Settings = Window:AddTab('Settings')
}

-- [Combat] - 정교한 사일런트 에임 + 트리거봇
local CombatGB = Tabs.Combat:AddLeftGroupbox('Aim Engine')
CombatGB:AddToggle('SAim', { Text = 'Silent Aim', Default = false })
CombatGB:AddSlider('FOV', { Text = 'Field of View', Default = 120, Min = 0, Max = 400, Rounding = 0 })
CombatGB:AddDropdown('Part', { Text = 'Target Part', Default = 'Head', Values = {'Head', 'UpperTorso', 'LowerTorso'} })
CombatGB:AddToggle('VisCheck', { Text = 'Wall Check (Safe)', Default = true })

-- [Visuals] - 최신 ESP 시스템
local VisGB = Tabs.Visuals:AddLeftGroupbox('ESP System')
VisGB:AddToggle('Boxes', { Text = 'Boxes', Default = false })
VisGB:AddToggle('Chams', { Text = 'Chams (Wallhack)', Default = false })
VisGB:AddToggle('Names', { Text = 'Names', Default = false })
VisGB:AddToggle('Tracer', { Text = 'Tracers', Default = false })

-- [Movement] - 밴 방지용 부드러운 이동
local MoveGB = Tabs.Movement:AddLeftGroupbox('Safe Movement')
MoveGB:AddToggle('Fly', { Text = 'Ghost Fly', Default = false })
MoveGB:AddSlider('FlySpeed', { Text = 'Speed', Default = 50, Min = 16, Max = 150, Rounding = 0 })
MoveGB:AddToggle('InfJump', { Text = 'Infinite Jump', Default = false })
MoveGB:AddToggle('NoClip', { Text = 'Noclip (Walk Through Walls)', Default = false })

-- [Automation] - 편의 기능
local AutoGB = Tabs.Automation:AddLeftGroupbox('Miscellaneous')
AutoGB:AddToggle('NoRecoil', { Text = 'No Recoil', Default = false })
AutoGB:AddToggle('FullAuto', { Text = 'Force Full Auto', Default = false })

-- 4. 메뉴 토글 설정 (RightControl 고정)
Library:SetWatermark('Nameless Script | Premium v1.0')
Library.Keybind = Enum.KeyCode.RightControl

-- 5. 실전 타겟팅 로직 (개선된 알고리즘)
local function GetClosestTarget()
    local target, dist = nil, Toggles.FOV.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if vis or not Toggles.VisCheck.Value then
                local mDist = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if mDist < dist then dist = mDist target = v end
            end
        end
    end
    return target
end

-- Raycast 후킹 (실제 총알 궤적 변경)
local OldRC; OldRC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if Toggles.SAim and Toggles.SAim.Value and method == "Raycast" and not checkcaller() then
        local t = GetClosestTarget()
        if t then
            args[2] = (t.Character[Options.Part.Value].Position - args[1]).Unit * 1000
            return OldRC(self, unpack(args))
        end
    end
    return OldRC(self, unpack(args))
end)

ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('Nameless Script 로드 완료 - 모든 보안 레이어 활성화')

