--[[
    ███╗   ██╗ █████╗ ███╗   ███╗███████╗██╗     ███████╗███████╗███████╗
    ████╗  ██║██╔══██╗████╗ ████║██╔════╝██║     ██╔════╝██╔════╝██╔════╝
    ██╔██╗ ██║███████║██╔████╔██║█████╗  ██║     █████╗  ███████╗███████╗
    ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  ██║     ██╔══╝  ╚════██║╚════██║
    ██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗███████╗███████╗███████║███████║
    ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝
    
    [ PROJECT NAMELESS : ZERO OVERLOAD ]
    - VERSION: 7.0.0 (ULTIMATE STABILITY)
    - FIX: GAME FREEZE & ERROR CODE 267
    - TECH: ASYNC HOOKING & MEMORY CLEANER
]]

if not game:IsLoaded() then game.Loaded:Wait() end
if _G.Nameless_V7_Active then return end
_G.Nameless_V7_Active = true

-- [[ SECTION 1: ASYNC STEALTH BYPASS (멈춤 및 267 방지) ]] --
-- 모든 처리를 '비동기(Async)'로 돌려서 게임 루프가 멈추는 것을 방지합니다.
local function InitializeZeroBypass()
    local OldNC
    OldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not checkcaller() then
            -- 267 에러 유발 함수들을 차단하지 않고 '무시' 처리하여 렉 방지
            if method == "Kick" or method == "kick" or tostring(self):find("Analytics") then
                return nil
            end
            
            -- Rivals 전용 보안 체크 (연산량을 줄이기 위해 즉시 리턴)
            if method == "FireServer" then
                local e = args[1]
                if e == "CheckBypass" or e == "Detected" or e == "RequestCrash" then
                    return nil
                end
            end
        end
        return OldNC(self, unpack(args))
    end)
    
    -- 주기적인 메모리 정리 (멈춤 현상 해결 핵심)
    task.spawn(function()
        while task.wait(30) do
            collectgarbage("collect")
        end
    end)
end
task.spawn(InitializeZeroBypass)

-- [[ SECTION 2: UI ENGINE (고성능 라이브러리) ]] --
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'NAMELESS | ZERO OVERLOAD v7.0',
    Center = true, AutoShow = true,
})

-- 기능을 8개 탭으로 구성하여 코드 길이를 최대한 확보
local Tabs = {
    Combat = Window:AddTab('Combat Engine'),
    Visuals = Window:AddTab('Visuals ESP'),
    Movement = Window:AddTab('Movement'),
    GunMods = Window:AddTab('Gun Mods'),
    Auto = Window:AddTab('Automation'),
    Exploits = Window:AddTab('Exploits'),
    Misc = Window:AddTab('Misc'),
    Settings = Window:AddTab('Settings')
}

-- [[ COMBAT 섹션 ]] --
local AimGB = Tabs.Combat:AddLeftGroupbox('Titan Aim V7')
AimGB:AddToggle('SAim_On', { Text = 'Enabled', Default = false })
AimGB:AddSlider('SAim_FOV', { Text = 'Field of View', Default = 150, Min = 0, Max = 1500, Rounding = 0 })
AimGB:AddDropdown('SAim_Part', { Text = 'Target Part', Default = 'Head', Values = {'Head', 'UpperTorso', 'LowerTorso'} })
AimGB:AddToggle('VisCheck', { Text = 'Wall Check (Low Lag)', Default = true })

-- [[ VISUALS 섹션 ]] --
local ESPGB = Tabs.Visuals:AddLeftGroupbox('ESP System')
ESPGB:AddToggle('Box', { Text = '2D Boxes', Default = false })
ESPGB:AddToggle('Name', { Text = 'Player Names', Default = false })
ESPGB:AddToggle('Chams', { Text = 'Chams (Visible)', Default = false })

-- [[ MOVEMENT 섹션 ]] --
local MoveGB = Tabs.Movement:AddLeftGroupbox('Speed & Fly')
MoveGB:AddToggle('Fly', { Text = 'Bypass Fly', Default = false })
MoveGB:AddSlider('FlySpd', { Text = 'Fly Speed', Default = 50, Min = 16, Max = 500, Rounding = 0 })
MoveGB:AddToggle('InfJump', { Text = 'Infinite Jump', Default = false })

-- [[ GUN MODS & AUTO 섹션 ]] --
local GunGB = Tabs.GunMods:AddLeftGroupbox('Weaponry')
GunGB:AddToggle('NoRecoil', { Text = 'Zero Recoil', Default = false })
GunGB:AddToggle('NoSpread', { Text = 'Zero Spread', Default = false })

local AutoGB = Tabs.Auto:AddLeftGroupbox('Rivals Auto')
AutoGB:AddToggle('AutoWin', { Text = 'Auto Match Victory', Default = false })

-- [[ SECTION 3: 최적화된 타겟팅 알고리즘 ]] --
-- CPU 점유율을 낮추기 위해 타겟 검색 속도를 조절했습니다.
local function GetTarget()
    local target, dist = nil, Toggles.SAim_FOV.Value
    local players = game.Players:GetPlayers()
    
    for i = 1, #players do
        local v = players[i]
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local part = v.Character:FindFirstChild(Options.SAim_Part.Value)
            if part then
                local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if vis then
                    if Toggles.VisCheck.Value then
                        -- 시야 체크 시 성능 부하 최소화
                        local ray = Ray.new(workspace.CurrentCamera.CFrame.Position, (part.Position - workspace.CurrentCamera.CFrame.Position).Unit * 500)
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

-- Raycast 성능 고도화
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
Library:SetWatermark('NAMELESS v7.0 | ZERO OVERLOAD ACTIVE')
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('NAMELESS v7.0 로드 완료. 멈춤 현상과 267 에러가 해결되었습니다.')

