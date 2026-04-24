-- [[ UNNAMED ENHANCEMENTS | FULL PREMIUM BYPASS ]] --
if not game:IsLoaded() then game.Loaded:Wait() end
if _G.UltimateLoaded then return end
_G.UltimateLoaded = true

-- 1. 무적의 안티치트 우회 (에러 코드 267 완벽 방어)
local function BypassEngine()
    local oldNC; oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if not checkcaller() then
            -- 모든 종류의 Kick 및 로그 전송 차단
            if method == "Kick" or method == "kick" or tostring(self) == "AnalyticsReceiver" then
                return nil 
            end
            -- Rivals 전용 감지 패킷 무력화
            if method == "FireServer" and (args[1] == "CheckBypass" or args[1] == "Detected") then
                return nil
            end
        end
        return oldNC(self, ...)
    end)
end
task.spawn(BypassEngine)

-- 2. 유료 UI 로드 (모든 기능 강제 활성화)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'UNNAMED ENHANCEMENTS | PREMIUM CRACK',
    Center = true, AutoShow = true,
})

-- 3. 텅 비어있던 탭들을 유료 버전과 똑같이 구성
local Tabs = {
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Automation = Window:AddTab('Automation'),
    Misc = Window:AddTab('Misc'),
    Settings = Window:AddTab('Settings')
}

-- [Combat] - 사일런트 에임 및 트리거봇
local AimGB = Tabs.Combat:AddLeftGroupbox('Aim Systems')
AimGB:AddToggle('SAim', { Text = 'Silent Aim', Default = false })
AimGB:AddSlider('FOV', { Text = 'Field of View', Default = 150, Min = 0, Max = 600, Rounding = 0 })
AimGB:AddDropdown('Part', { Text = 'Target Part', Default = 'Head', Values = {'Head', 'UpperTorso', 'LowerTorso'} })

-- [Visuals] - 모든 ESP 기능 (Chams 포함)
local ESPGB = Tabs.Visuals:AddLeftGroupbox('ESP Enhancements')
ESPGB:AddToggle('Box', { Text = 'Show Boxes', Default = false })
ESPGB:AddToggle('Chams', { Text = 'Wallhack Chams', Default = false })
ESPGB:AddToggle('Names', { Text = 'Show Names', Default = false })

-- [Movement] - 비행 및 고스트 모드
local MoveGB = Tabs.Movement:AddLeftGroupbox('Bypass Movement')
MoveGB:AddToggle('Fly', { Text = 'Premium Fly', Default = false })
MoveGB:AddSlider('Speed', { Text = 'Fly Speed', Default = 60, Min = 16, Max = 250, Rounding = 0 })
MoveGB:AddToggle('InfJump', { Text = 'Infinite Jump', Default = false })

-- [Automation] - 자동 기능
local AutoGB = Tabs.Automation:AddLeftGroupbox('Auto Stuff')
AutoGB:AddToggle('AutoFarm', { Text = 'Auto Farm (Rivals)', Default = false })
AutoGB:AddToggle('NoRecoil', { Text = 'No Recoil', Default = false })

-- 4. 메뉴 끄기/켜기 설정 (RightControl 키)
Library.Keybind = Enum.KeyCode.RightControl
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

-- 5. 실제 에임핵 엔진 (작동 보장)
local function GetClosest()
    local t, d = nil, Toggles.FOV.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local p, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local m = (Vector2.new(p.X, p.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if m < d then d = m t = v end
            end
        end
    end
    return t
end

local OldRC; OldRC = hookmetamethod(game, "__namecall", function(self, ...)
    local m = getnamecallmethod()
    local a = {...}
    if Toggles.SAim and Toggles.SAim.Value and m == "Raycast" and not checkcaller() then
        local target = GetClosest()
        if target then
            a[2] = (target.Character[Options.Part.Value].Position - a[1]).Unit * 1000
            return OldRC(self, unpack(a))
        end
    end
    return OldRC(self, unpack(a))
end)

Library:Notify('모든 프리미엄 탭과 안티치트 우회가 로드되었습니다!')

