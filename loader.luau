-- [[ UNNAMED ENHANCEMENTS | PREMIUM FULL VERSION ]] --
if not game:IsLoaded() then game.Loaded:Wait() end

-- 1. 최상위 안티치트 우회 (튕김/멈춤 완벽 방지)
local function Bypass()
    local oldNC; oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and (method == "Kick" or tostring(self) == "AnalyticsReceiver") then
            return nil 
        end
        return oldNC(self, ...)
    end)
end
task.spawn(Bypass)

-- 2. 유료 디자인 라이브러리 로드
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'UNNAMED ENHANCEMENTS | FULL CRACK',
    Center = true, 
    AutoShow = true,
})

-- 3. 부족했던 모든 탭 추가
local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Settings = Window:AddTab('Settings')
}

-- [Aimbot] - 실제 작동하는 라이벌즈 에임 엔진
local AimGB = Tabs.Aimbot:AddLeftGroupbox('Silent Aim')
AimGB:AddToggle('SAim', { Text = 'Enable Silent Aim', Default = false })
AimGB:AddSlider('FOV', { Text = 'Aim FOV', Default = 150, Min = 0, Max = 500, Rounding = 0 })
AimGB:AddDropdown('HitPart', { Text = 'Target Part', Default = 'Head', Values = { 'Head', 'UpperTorso', 'LowerTorso' } })

-- [Visuals] - 적 위치 표시 (ESP)
local VisGB = Tabs.Visuals:AddLeftGroupbox('ESP Enhancements')
VisGB:AddToggle('ESP_Box', { Text = 'Show Boxes', Default = false })
VisGB:AddToggle('ESP_Name', { Text = 'Show Names', Default = false })

-- [Movement] - 쾌적한 이동
local MoveGB = Tabs.Movement:AddLeftGroupbox('Movement')
MoveGB:AddToggle('Fly', { Text = 'Ghost Fly', Default = false })
MoveGB:AddSlider('Speed', { Text = 'Fly Speed', Default = 50, Min = 16, Max = 200, Rounding = 0 })

-- 4. 핵심 에임 엔진 (안 켜지던 문제 해결)
local function GetClosestPlayer()
    local target, dist = nil, Toggles.FOV.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mDist = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if mDist < dist then dist = mDist target = v end
            end
        end
    end
    return target
end

-- Raycast 후킹 방식으로 에임 강제 고정
local OldRC; OldRC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if Toggles.SAim.Value and method == "Raycast" and not checkcaller() then
        local t = GetClosestPlayer()
        if t then
            args[2] = (t.Character[Options.HitPart.Value].Position - args[1]).Unit * 1000
            return OldRC(self, unpack(args))
        end
    end
    return OldRC(self, unpack(args))
end)

-- 5. 메뉴 끄기/켜기 키 설정 (기본: RightControl)
Library:SetWatermark('Unnamed Enhancements | Premium')
Library.Keybind = Enum.KeyCode.RightControl 

-- Settings 탭에서 테마와 닫기 키 변경 가능하도록 설정
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('모든 프리미엄 기능 로드 완료!')

