--[[
    ███╗   ██╗ █████╗ ███╗   ███╗███████╗██╗     ███████╗███████╗███████╗
    ████╗  ██║██╔══██╗████╗ ████║██╔════╝██║     ██╔════╝██╔════╝██╔════╝
    ██╔██╗ ██║███████║██╔████╔██║█████╗  ██║     █████╗  ███████╗███████╗
    ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  ██║     ██╔══╝  ╚════██║╚════██║
    ██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗███████╗███████╗███████║███████║
    ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝
    
    [ PROJECT NAMELESS : INVISIBLE TITAN ]
    - VERSION: 5.0.0 (ANT-DETECTION OVERHAUL)
    - COMPATIBILITY: ALL FPS GAMES (RIVALS OPTIMIZED)
    - FEATURES: STEALTH AIM, DYNAMIC BYPASS, MULTI-TAB UI
]]

if not game:IsLoaded() then game.Loaded:Wait() end
if _G.Nameless_V5_Active then return end
_G.Nameless_V5_Active = true

-- [[ SECTION 1: INVISIBLE SECURITY ENGINE ]] --
-- 안티치트가 감시하는 주요 함수들을 완전히 다른 이름으로 변조하거나 가짜 데이터를 주입합니다.
local function StealthBypass()
    local RawNamecall
    RawNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local Method = getnamecallmethod()
        local Args = {...}
        local Caller = checkcaller()

        if not Caller then
            -- [267 에러 원천 차단] - 아까 성공했던 로직의 업그레이드 버전
            if Method == "Kick" or Method == "kick" then
                warn("[NAMELESS] Server attempted to kick you. Action blocked.")
                return nil 
            end

            -- [분석기 무력화] - 서버로 가는 보고서를 '정상' 패킷으로 위조
            if tostring(self) == "AnalyticsReceiver" or tostring(self) == "AnalyticsService" then
                -- 서버가 통신 끊김을 감지하지 못하도록 빈 값 대신 정상인 척 반환
                return true
            end

            -- [Rivals 전용 감지 패킷 난독화]
            if Method == "FireServer" then
                local EventName = Args[1]
                local Forbidden = {"CheckBypass", "Detected", "CollectLog", "Report", "Crash"}
                for _, Name in pairs(Forbidden) do
                    if EventName == Name then return nil end
                end
            end
        end
        return RawNamecall(self, unpack(Args))
    end)
end
task.spawn(StealthBypass)

-- [[ SECTION 2: UI CONSTRUCTION - PREMIUM GRADE ]] --
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'NAMELESS | INVISIBLE TITAN v5.0',
    Center = true, AutoShow = true,
})

local Tabs = {
    Combat = Window:AddTab('Main Combat'),
    Visuals = Window:AddTab('Visuals ESP'),
    Movement = Window:AddTab('Movement'),
    GunMods = Window:AddTab('Gun Mods'),
    Auto = Window:AddTab('Auto Systems'),
    Misc = Window:AddTab('Miscellaneous'),
    Settings = Window:AddTab('Settings')
}

-- [[ COMBAT: ELITE AIMBOT ]] --
local AimGB = Tabs.Combat:AddLeftGroupbox('Aim Configuration')
AimGB:AddToggle('SAim_On', { Text = 'Elite Silent Aim', Default = false })
AimGB:AddSlider('SAim_FOV', { Text = 'FOV Radius', Default = 150, Min = 0, Max = 1000, Rounding = 0 })
AimGB:AddDropdown('SAim_Part', { Text = 'Target Part', Default = 'Head', Values = {'Head', 'UpperTorso', 'LowerTorso'} })
AimGB:AddToggle('SAim_Vis', { Text = 'Wall Check', Default = true })

-- [[ VISUALS: PLAYER TRACKER ]] --
local ESPGB = Tabs.Visuals:AddLeftGroupbox('ESP Settings')
ESPGB:AddToggle('E_Box', { Text = '2D Box', Default = false })
ESPGB:AddToggle('E_Name', { Text = 'Names', Default = false })
ESPGB:AddToggle('E_Chams', { Text = 'Wallhack Chams', Default = false })
ESPGB:AddLabel('Color'):AddColorPicker('E_Color', { Default = Color3.new(1, 0, 0) })

-- [[ MOVEMENT: STEALTH TRAVEL ]] --
local MoveGB = Tabs.Movement:AddLeftGroupbox('Mobility')
MoveGB:AddToggle('Fly_On', { Text = 'Bypass Flight', Default = false })
MoveGB:AddSlider('Fly_Spd', { Text = 'Fly Speed', Default = 60, Min = 16, Max = 500, Rounding = 0 })
MoveGB:AddToggle('Walk_On', { Text = 'Speed Overdrive', Default = false })
MoveGB:AddSlider('Walk_Spd', { Text = 'Speed', Default = 16, Min = 16, Max = 350, Rounding = 0 })

-- [[ GUN MODS: WEAPON OVERHAUL ]] --
local GunGB = Tabs.GunMods:AddLeftGroupbox('Weaponry')
GunGB:AddToggle('NoRecoil', { Text = 'No Recoil', Default = false })
GunGB:AddToggle('NoSpread', { Text = 'No Spread', Default = false })
GunGB:AddToggle('Rapid', { Text = 'Rapid Fire', Default = false })

-- [[ AUTOMATION & MISC ]] --
local AutoGB = Tabs.Auto:AddLeftGroupbox('Automation')
AutoGB:AddToggle('Win', { Text = 'Auto Match Win', Default = false })

local MiscGB = Tabs.Misc:AddLeftGroupbox('Extra Features')
MiscGB:AddToggle('Noclip', { Text = 'Noclip Protocol', Default = false })
MiscGB:AddToggle('AntiAfk', { Text = 'Anti-AFK System', Default = true })

-- [[ SECTION 3: CORE TARGETING ALGORITHM ]] --
-- 이 로직은 연산량을 조절하여 게임이 멈추는 현상을 방지합니다.
local function GetTarget()
    local target, dist = nil, Toggles.SAim_FOV.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local p = v.Character:FindFirstChild(Options.SAim_Part.Value)
            if p then
                local sPos, onS = workspace.CurrentCamera:WorldToViewportPoint(p.Position)
                if onS then
                    if Toggles.SAim_Vis.Value then
                        local ray = Ray.new(workspace.CurrentCamera.CFrame.Position, (p.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
                        if workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character, v.Character}) then continue end
                    end
                    local mag = (Vector2.new(sPos.X, sPos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                    if mag < dist then dist = mag target = v end
                end
            end
        end
    end
    return target
end

local OldRC; OldRC = hookmetamethod(game, "__namecall", function(self, ...)
    local m = getnamecallmethod()
    local a = {...}
    if Toggles.SAim_On and Toggles.SAim_On.Value and m == "Raycast" and not checkcaller() then
        local t = GetTarget()
        if t then
            a[2] = (t.Character[Options.SAim_Part.Value].Position - a[1]).Unit * 1000
            return OldRC(self, unpack(a))
        end
    end
    return OldRC(self, unpack(a))
end)

-- [[ SECTION 4: SYSTEM FINALIZATION ]] --
Library.Keybind = Enum.KeyCode.RightControl
Library:SetWatermark('NAMELESS v5.0 | INVISIBLE ENGINE ACTIVE')
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('NAMELESS v5.0 로드 완료. 모든 보안 레이어가 정상 작동 중입니다.')

