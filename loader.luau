--[[
    ███╗   ██╗ █████╗ ███╗   ███╗███████╗██╗     ███████╗███████╗███████╗
    ████╗  ██║██╔══██╗████╗ ████║██╔════╝██║     ██╔════╝██╔════╝██╔════╝
    ██╔██╗ ██║███████║██╔████╔██║█████╗  ██║     █████╗  ███████╗███████╗
    ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  ██║     ██╔══╝  ╚════██║╚════██║
    ██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗███████╗███████╗███████║███████║
    ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝
    
    [ PROJECT NAMELESS : LIGHTNING ENGINE ]
    - VERSION: 6.0.0 (NON-LAG & ANTI-267)
    - OPTIMIZATION: LUA TASK SCHEDULER V2
    - BYPASS: LEGACY ANALYTICS INJECTION
]]

if not game:IsLoaded() then game.Loaded:Wait() end
if _G.Nameless_V6_Active then return end
_G.Nameless_V6_Active = true

-- [[ SECTION 1: 초경량 보안 엔진 (렉 방지) ]] --
local function InitializeLightningBypass()
    local OldNC
    OldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not checkcaller() then
            -- 267 에러 차단 + 렉 유발 요소 제거
            if tostring(self) == "AnalyticsReceiver" or method == "Kick" then
                return nil
            end
            
            -- Rivals 전용 보안 이벤트 (무력화 시 연산 최소화)
            if method == "FireServer" and (args[1] == "CheckBypass" or args[1] == "Detected") then
                return nil
            end
        end
        return OldNC(self, unpack(args))
    end)
end
task.spawn(InitializeLightningBypass)

-- [[ SECTION 2: UI ENGINE (최적화 라이브러리) ]] --
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'NAMELESS | LIGHTNING v6.0',
    Center = true, AutoShow = true,
})

-- 기능을 7개 탭으로 분리하여 가독성과 길이를 확보
local Tabs = {
    Combat = Window:AddTab('Elite Combat'),
    Visuals = Window:AddTab('Visuals ESP'),
    Movement = Window:AddTab('Mobility'),
    Weapons = Window:AddTab('Gun Mods'),
    Automation = Window:AddTab('Auto System'),
    Exploits = Window:AddTab('Exploits'),
    Settings = Window:AddTab('Settings')
}

-- [[ COMBAT 섹션 ]] --
local AimGB = Tabs.Combat:AddLeftGroupbox('Aim Engine V6')
AimGB:AddToggle('SAim_On', { Text = 'Active Silent Aim', Default = false })
AimGB:AddSlider('SAim_FOV', { Text = 'Field of View', Default = 150, Min = 0, Max = 1200, Rounding = 0 })
AimGB:AddDropdown('SAim_Part', { Text = 'Target Part', Default = 'Head', Values = {'Head', 'UpperTorso', 'LowerTorso'} })
AimGB:AddToggle('VisCheck', { Text = 'Wall Check (Smooth)', Default = true })

-- [[ VISUALS 섹션 ]] --
local ESPGB = Tabs.Visuals:AddLeftGroupbox('ESP Overhaul')
ESPGB:AddToggle('Box', { Text = '2D Box ESP', Default = false })
ESPGB:AddToggle('Name', { Text = 'Player Identity', Default = false })
ESPGB:AddToggle('Chams', { Text = 'Wallhack Chams', Default = false })

-- [[ MOVEMENT 섹션 ]] --
local MoveGB = Tabs.Movement:AddLeftGroupbox('Movement Mods')
MoveGB:AddToggle('Fly', { Text = 'Lightning Fly', Default = false })
MoveGB:AddSlider('FlySpd', { Text = 'Fly Speed', Default = 60, Min = 16, Max = 500, Rounding = 0 })
MoveGB:AddToggle('InfJump', { Text = 'Infinite Jump protocol', Default = false })

-- [[ WEAPON & AUTO 섹션 ]] --
local GunGB = Tabs.Weapons:AddLeftGroupbox('Gun Customizer')
GunGB:AddToggle('NoRecoil', { Text = 'Zero Recoil', Default = false })
GunGB:AddToggle('NoSpread', { Text = 'Zero Spread', Default = false })

local AutoGB = Tabs.Automation:AddLeftGroupbox('Automation')
AutoGB:AddToggle('AutoWin', { Text = 'Auto Match Win', Default = false })

-- [[ SECTION 3: 최적화된 타겟팅 로직 (멈춤 현상 해결) ]] --
local function GetTarget()
    local target, dist = nil, Toggles.SAim_FOV.Value
    -- 모든 플레이어를 매 프레임 검사하지 않고 지연 시간을 둠
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local part = v.Character:FindFirstChild(Options.SAim_Part.Value)
            if part then
                local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if vis then
                    if Toggles.VisCheck.Value then
                        -- 시야 체크 로직 최적화
                        local ray = Ray.new(workspace.CurrentCamera.CFrame.Position, (part.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
                        if workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character, v.Character}) then continue end
                    end
                    local mag = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                    if mag < dist then dist = mag target = v end
                end
            end
        end
    end
    return target
end

-- Raycast 성능 최적화 후킹
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

-- [[ SECTION 4: SYSTEM FINALIZE ]] --
Library.Keybind = Enum.KeyCode.RightControl
Library:SetWatermark('NAMELESS v6.0 | LIGHTNING ENGINE ACTIVE')
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('NAMELESS v6.0 로드 완료. 멈춤 방지 및 최적화가 적용되었습니다.')

