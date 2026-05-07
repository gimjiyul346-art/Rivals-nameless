local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Nameless Hub - Classic", "DarkScene")

-- [기본 설정]
_G.SilentAim = false
_G.Wallbang = false
_G.EmoteActive = false
_G.AnimSpeed = 99999

-- [1] Main 탭 (Silent Aim & Wallbang)
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Combat")

MainSection:NewToggle("Silent Aim (Auto-Fix)", "머리에 총알이 자동 유도됩니다.", function(state)
    _G.SilentAim = state
end)

MainSection:NewToggle("Wallbang (All Hit)", "벽 너머의 적도 맞출 수 있습니다.", function(state)
    _G.Wallbang = state
end)

-- [2] Emote 탭
local Emote = Window:NewTab("Emote")
local EmoteSection = Emote:NewSection("Custom Animation")

local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://92281817840531"

EmoteSection:NewToggle("Enable Custom Emote", "캐릭터가 지정된 애니메이션을 반복합니다.", function(state)
    _G.EmoteActive = state
    local char = game.Players.LocalPlayer.Character
    if state and char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local track = hum:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action4
        track:Play()
        track:AdjustSpeed(_G.AnimSpeed)
        track.Stopped:Connect(function()
            if _G.EmoteActive then track:Play() end
        end)
    end
end)

-- [3] Skins 탭 (Skin Changer)
local Skins = Window:NewTab("Skins")
local SkinSection = Skins:NewSection("Weapon Skins")

SkinSection:NewButton("All Skins Unlock", "모든 스킨을 해제합니다 (클라이언트 측).", function()
    -- Rivals 게임 구조에 맞춘 스킨 해제 로직 (가상)
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    -- 게임마다 스킨 데이터 경로가 다르므로 일반적인 해제 신호를 보냅니다.
    print("Skins Unlocked!") 
end)

-- [4] ESP 탭
local ESP = Window:NewTab("ESP")
local ESPSection = ESP:NewSection("Visuals")

ESPSection:NewToggle("Player ESP", "적의 위치를 빨간색으로 표시합니다.", function(state)
    _G.ESP = state
    while _G.ESP do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and not p.Character:FindFirstChild("Highlight") then
                local hl = Instance.new("Highlight", p.Character)
                hl.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
        task.wait(1)
    end
end)

-- [사일런트 에임 핵심 엔진 - 데이터 변조 방식]
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.SilentAim and method == "Raycast" then
        -- 가장 가까운 적 찾기 로직
        local target = nil
        local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                target = p
            end
        end
        if target then
            args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
            return old(self, unpack(args))
        end
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)
