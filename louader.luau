-- [[ 1. 서버 이동 시 인증 오류 우회 ]] --
if not game:IsLoaded() then game.Loaded:Wait() end

-- 매칭 서버에서의 강제 종료 신호를 차단
local function BypassWhitelist()
    local OldNC
    OldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        -- 서버가 'Invalid Key'를 체크하려고 할 때 응답을 가로챔
        if method == "Kick" or method == "Close" then
            return nil 
        end
        return OldNC(self, ...)
    end)
end
BypassWhitelist()

-- [[ 2. UI 및 핵심 기능 (키 없이 즉시 실행) ]] --
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local Window = Library:CreateWindow({ Title = 'UNNAMED MATCHING BYPASS', Center = true, AutoShow = true })

local Tab = Window:AddTab('Main')
local Group = Tab:AddLeftGroupbox('Combat (Silent Aim)')

Group:AddToggle('SAim', { Text = 'Safe Silent Aim', Default = false })
Group:AddSlider('FOV', { Text = 'Safe FOV', Default = 100, Min = 0, Max = 400, Rounding = 0 })

-- [[ 3. 매칭 서버용 저감지 에임 로직 ]] --
local function GetSafeTarget()
    local target, dist = nil, Toggles.FOV.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            -- 팀 체크 및 가시성 체크 (매칭 서버 밴 방지 핵심)
            if v.Team ~= game.Players.LocalPlayer.Team then
                local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mDist = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                    if mDist < dist then dist = mDist target = v end
                end
            end
        end
    end
    return target
end

local OldRC; OldRC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if Toggles.SAim.Value and method == "Raycast" and not checkcaller() then
        local t = GetSafeTarget()
        if t then
            args[2] = (t.Character.Head.Position - args[1]).Unit * 1000
            return OldRC(self, unpack(args))
        end
    end
    return OldRC(self, unpack(args))
end)

Library:Notify('매칭 서버 전용 우회 모드 활성화!')

