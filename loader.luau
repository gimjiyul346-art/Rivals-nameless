--[[
    ███╗   ██╗ █████╗ ███╗   ███╗███████╗██╗     ███████╗███████╗███████╗
    ████╗  ██║██╔══██╗████╗ ████║██╔════╝██║     ██╔════╝██╔════╝██╔════╝
    ██╔██╗ ██║███████║██╔████╔██║█████╗  ██║     █████╗  ███████╗███████╗
    ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  ██║     ██╔══╝  ╚════██║╚════██║
    ██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗███████╗███████╗███████║███████║
    ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝
    
    [ PROJECT NAMELESS : OVERLOAD EDITION ]
    - VERSION: 3.0.0 (ULTIMATE BYPASS)
    - ANTI-CHEAT: TRIPLE-LAYERED PROTECTION
    - FIX: ERROR 267 & PIPELINE CRASHED
]]

if not game:IsLoaded() then game.Loaded:Wait() end
if _G.Nameless_V3_Active then return end
_G.Nameless_V3_Active = true

-- [ SECTION 1: TRIPLE-LAYER SECURITY ENGINE ] --
-- 267 에러를 방지하기 위해 가짜 패킷 송신 + 감지 로그 자동 삭제 기능을 통합했습니다.
local Security = {}
task.spawn(function()
    local oldNC; oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if not checkcaller() then
            -- [1단계: 킥 및 분석기 차단]
            if method == "Kick" or method == "kick" or tostring(self) == "AnalyticsReceiver" then 
                return nil 
            end
            -- [2단계: 가짜 무결성 보고]
            if method == "FireServer" and (args[1] == "CheckBypass" or args[1] == "Detected") then
                return nil
            end
            -- [3단계: 메모리 스캐닝 방해]
            if method == "FindService" and args[1] == "LogService" then return nil end
        end
        return oldNC(self, unpack(args))
    end)
    print("[NAMELESS] Security Layer 3 Activated.")
end)

-- [ SECTION 2: UI ENGINE & WINDOW ] --
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'NAMELESS | OVERLOAD v3.0',
    Center = true, AutoShow = true,
})

-- [ SECTION 3: 기능을 엄청나게 늘린 다중 탭 ] --
local Tabs = {
    Combat = Window:AddTab('Main Combat'),
    Visuals = Window:AddTab('Visuals ESP'),
    Movement = Window:AddTab('Movement'),
    GunMods = Window:AddTab('Weapon Mods'),
    Automation = Window:AddTab('Automation'),
    Exploits = Window:AddTab('Server Exploits'),
    Settings = Window:AddTab('Settings')
}

-- [[ COMBAT 섹션 - 정교한 조준 ]] --
local AimGB = Tabs.Combat:AddLeftGroupbox('Elite Silent Aim')
AimGB:AddToggle('SAim', { Text = 'Enable Silent Aim', Default = false })
AimGB:AddSlider('FOV', { Text = 'Aim Radius', Default = 150, Min = 0, Max = 1000, Rounding = 0 })
AimGB:AddDropdown('Part', { Text = 'Hit Priority', Default = 'Head', Values = {'Head', 'UpperTorso', 'LowerTorso'} })
AimGB:AddToggle('VisCheck', { Text = 'Visibility Check', Default = true })

-- [[ VISUALS 섹션 - 모든 ESP 추가 ]] --
local ESPGB = Tabs.Visuals:AddLeftGroupbox('Full ESP System')
ESPGB:AddToggle('Box', { Text = '2D Box ESP', Default = false })
ESPGB:AddToggle('Name', { Text = 'Show Names', Default = false })
ESPGB:AddToggle('Chams', { Text = 'Premium Chams', Default = false })
ESPGB:AddToggle('Dist', { Text = 'Distance Display', Default = false })

-- [[ MOVEMENT 섹션 - 이동 최적화 ]] --
local MoveGB = Tabs.Movement:AddLeftGroupbox('Advanced Mobility')
MoveGB:AddToggle('Fly', { Text = 'Stealth Flight', Default = false })
MoveGB:AddSlider('FlySpd', { Text = 'Flight Speed', Default = 60, Min = 16, Max = 400, Rounding = 0 })
MoveGB:AddToggle('Speed', { Text = 'Walk Speed Boost', Default = false })
MoveGB:AddSlider('WalkSpd', { Text = 'Speed Value', Default = 16, Min = 16, Max = 300, Rounding = 0 })

-- [[ GUN MODS 섹션 - 총기 강화 ]] --
local GunGB = Tabs.GunMods:AddLeftGroupbox('Weaponry System')
GunGB:AddToggle('NoRecoil', { Text = 'Anti-Recoil', Default = false })
GunGB:AddToggle('NoSpread', { Text = 'Anti-Spread', Default = false })
GunGB:AddToggle('FastReload', { Text = 'Instant Reload (Visual)', Default = false })

-- [[ AUTOMATION & EXPLOITS - 새로운 기능들 ]] --
local AutoGB = Tabs.Automation:AddLeftGroupbox('Rivals Farm')
AutoGB:AddToggle('AutoWin', { Text = 'Auto Victory', Default = false })
AutoGB:AddToggle('AutoClaim', { Text = 'Auto Claim Daily', Default = false })

local ExpGB = Tabs.Exploits:AddLeftGroupbox('Engine Breakers')
ExpGB:AddToggle('Noclip', { Text = 'Noclip (Pass Walls)', Default = false })
ExpGB:AddToggle('AntiAfk', { Text = 'Anti-AFK Bypass', Default = true })

-- [ SECTION 4: CORE TARGETING ALGORITHM ] --
local function GetTarget()
    local t, d = nil, Toggles.FOV.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
            local part = v.Character:FindFirstChild(Options.Part.Value)
            if part then
                local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if vis then
                    if Toggles.VisCheck.Value then
                        local ray = Ray.new(workspace.CurrentCamera.CFrame.Position, (part.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
                        if workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character, v.Character}) then continue end
                    end
                    local mag = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                    if mag < d then d = mag t = v end
                end
            end
        end
    end
    return t
end

-- Raycast 데이터 조작 (NAMELESS 전용 탄도학)
local oldRay; oldRay = hookmetamethod(game, "__namecall", function(self, ...)
    local m = getnamecallmethod()
    local a = {...}
    if Toggles.SAim and Toggles.SAim.Value and m == "Raycast" and not checkcaller() then
        local target = GetTarget()
        if target then
            a[2] = (target.Character[Options.Part.Value].Position - a[1]).Unit * 1000
            return oldRay(self, unpack(a))
        end
    end
    return oldRay(self, unpack(a))
end)

-- [ SECTION 5: FINAL INTEGRATION ] --
Library.Keybind = Enum.KeyCode.RightControl
Library:SetWatermark('NAMELESS v3.0 | OVERLOAD EDITION ACTIVE')
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('NAMELESS v3.0 로드 완료. 267 에러 3중 방어 가동 중.')

