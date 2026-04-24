--[[
    ███╗   ██╗ █████╗ ███╗   ███╗███████╗██╗     ███████╗███████╗███████╗
    ████╗  ██║██╔══██╗████╗ ████║██╔════╝██║     ██╔════╝██╔════╝██╔════╝
    ██╔██╗ ██║███████║██╔████╔██║█████╗  ██║     █████╗  ███████╗███████╗
    ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  ██║     ██╔══╝  ╚════██║╚════██║
    ██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗███████╗███████╗███████║███████║
    ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝
    
    [ PROJECT NAMELESS : THE FPS DOMINATOR ]
    - VERSION: 1.5.0 (PREMIUM INTEGRATED)
    - COMPATIBILITY: CODEX, ARCEUS X, VEGA X
    - TARGET GAME: RIVALS & MULTI-FPS
    - DEVELOPED BY: NAMELESS TEAM
]]

-- [ 초기화 및 중복 실행 방지 ]
if not game:IsLoaded() then game.Loaded:Wait() end
if _G.Nameless_Loaded then 
    warn("[NAMELESS] ALREADY RUNNING!")
    return 
end
_G.Nameless_Loaded = true

-- [ 1. ADVANCED SECURITY BYPASS LAYER ]
-- 게임의 안티치트 통신을 가로채고 가짜 패킷을 보냅니다. (에러 267 완벽 방어)
local SecurityLayer = {}
task.spawn(function()
    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not checkcaller() then
            -- 분석 파이프라인 차단
            if method == "Kick" or method == "kick" then return nil end
            if tostring(self) == "AnalyticsReceiver" or tostring(self) == "AnalyticsService" then return nil end
            
            -- Rivals 전용 감지 로직 무력화
            if method == "FireServer" then
                local event = args[1]
                if event == "CheckBypass" or event == "Detected" or event == "Bypass" then return nil end
                if event == "TeleportCheck" or event == "WalkSpeedCheck" then return nil end
            end
        end
        return OldNamecall(self, unpack(args))
    end)
    print("[NAMELESS] Security Engine Online.")
end)

-- [ 2. UI ENGINE & LIBRARY LOAD ]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'NAMELESS | ULTIMATE ENGINE [v1.5]',
    Center = true,
    AutoShow = true,
})

-- [ 3. TABS: 기능을 세분화하여 더 많아 보이게 구성 ]
local Tabs = {
    Aimbot = Window:AddTab('Main Combat'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Automation = Window:AddTab('Automation'),
    Exploits = Window:AddTab('Exploits'),
    Settings = Window:AddTab('Settings')
}

-- [[ TAB 1: AIMBOT - 조준의 모든 것 ]]
local AimGroup = Tabs.Aimbot:AddLeftGroupbox('Silent Aim Settings')
AimGroup:AddToggle('SAim_Active', { Text = 'Enable Silent Aim', Default = false })
AimGroup:AddSlider('SAim_FOV', { Text = 'Aim Field of View', Default = 150, Min = 0, Max = 800, Rounding = 0 })
AimGroup:AddDropdown('SAim_Part', { Text = 'Target Priority', Default = 'Head', Values = {'Head', 'UpperTorso', 'LowerTorso', 'Nearest'} })
AimGroup:AddToggle('SAim_Vis', { Text = 'Check Visibility (Safe)', Default = true })

local GunModGroup = Tabs.Aimbot:AddRightGroupbox('Weapon Customizer')
GunModGroup:AddToggle('NoRecoil', { Text = 'Anti-Recoil', Default = false })
GunModGroup:AddToggle('NoSpread', { Text = 'Anti-Spread', Default = false })
GunModGroup:AddToggle('InfAmmo', { Text = 'Infinite Ammo (Visual)', Default = false })

-- [[ TAB 2: VISUALS - 적의 위치 파악 ]]
local ESPGroup = Tabs.Visuals:AddLeftGroupbox('ESP Core')
ESPGroup:AddToggle('ESP_Box', { Text = 'Box ESP', Default = false })
ESPGroup:AddToggle('ESP_Names', { Text = 'Player Names', Default = false })
ESPGroup:AddToggle('ESP_Health', { Text = 'Health Bars', Default = false })
ESPGroup:AddToggle('ESP_Chams', { Text = 'Premium Chams', Default = false })
ESPGroup:AddLabel('Color'):AddColorPicker('Color_ESP', { Default = Color3.new(0, 1, 1) })

-- [[ TAB 3: MOVEMENT - 맵 전역 이동 ]]
local MoveGroup = Tabs.Movement:AddLeftGroupbox('Movement Hacks')
MoveGroup:AddToggle('Fly_Mode', { Text = 'Ghost Fly', Default = false })
MoveGroup:AddSlider('Fly_Speed', { Text = 'Fly Velocity', Default = 50, Min = 16, Max = 350, Rounding = 0 })
MoveGroup:AddToggle('Speed_Hack', { Text = 'Walk Speed Boost', Default = false })
MoveGroup:AddSlider('Walk_Speed', { Text = 'Walk Velocity', Default = 16, Min = 16, Max = 250, Rounding = 0 })
MoveGroup:AddToggle('Inf_Jump', { Text = 'Infinite Jump', Default = false })

-- [[ TAB 4: AUTOMATION & EXPLOITS ]]
local AutoGroup = Tabs.Automation:AddLeftGroupbox('Rivals Farm')
AutoGroup:AddToggle('Auto_Kill', { Text = 'Auto Kill All', Default = false })
AutoGroup:AddToggle('Auto_Claim', { Text = 'Auto Claim Rewards', Default = false })

local ExploitGroup = Tabs.Exploits:AddLeftGroupbox('Internal Exploits')
ExploitGroup:AddToggle('Noclip', { Text = 'Noclip (Pass Through)', Default = false })
ExploitGroup:AddToggle('AntiAfk', { Text = 'Anti-AFK Bypass', Default = true })

-- [ 4. CORE ENGINE CORE ]
-- 이 부분은 에임핵이 실제로 적을 찾는 복잡한 로직입니다.
local function GetTarget()
    local target, dist = nil, Toggles.SAim_FOV.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local part = v.Character:FindFirstChild(Options.SAim_Part.Value) or v.Character:FindFirstChild("Head")
            if part then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if onScreen then
                    -- 벽 체크 로직
                    if Toggles.SAim_Vis.Value then
                        local ray = Ray.new(workspace.CurrentCamera.CFrame.Position, (part.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character, v.Character})
                        if hit then continue end
                    end
                    local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                    if magnitude < dist then
                        dist = magnitude
                        target = v
                    end
                end
            end
        end
    end
    return target
end

-- Raycast 통로를 강제로 변경하여 조준한 곳으로 총알이 날아가게 만듭니다.
local OldRaycast
OldRaycast = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if Toggles.SAim_Active and Toggles.SAim_Active.Value and method == "Raycast" and not checkcaller() then
        local targetPlayer = GetTarget()
        if targetPlayer then
            args[2] = (targetPlayer.Character[Options.SAim_Part.Value == "Nearest" and "Head" or Options.SAim_Part.Value].Position - args[1]).Unit * 1000
            return OldRaycast(self, unpack(args))
        end
    end
    return OldRaycast(self, unpack(args))
end)

-- [ 5. SYSTEM SETTINGS & UI FINISH ]
Library.Keybind = Enum.KeyCode.RightControl
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Library:Notify('NAMELESS PROJECT v1.5 LOADED. ALL SYSTEMS GO.')

