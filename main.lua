-- [[ 클랜장 전용 PRIVATE HUB v2.1 ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("CLAN LEADER PRIVATE v2.1", "Midnight")

-- [Movement 탭: 기동성 강화]
local Move = Window:NewTab("Movement")
local MoveSection = Move:NewSection("Fly & Wall Hack")

-- 1. Noclip (벽 뚫기)
MoveSection:NewToggle("Noclip (Open/Close)", "벽과 모든 장애물을 통과합니다.", function(state)
    _G.Noclip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Noclip then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end)

-- 2. Fly (비행 모드)
MoveSection:NewToggle("Fly Mode (Open/Close)", "공중을 자유롭게 날아다닙니다.", function(state)
    _G.Fly = state
    local player = game.Players.LocalPlayer
    local char = player.Character
    local root = char.HumanoidRootPart
    
    if _G.Fly then
        -- 비행 로직 시작 (BodyVelocity 등을 사용하여 공중에 고정)
        local bv = Instance.new("BodyVelocity", root)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Name = "FlyVelocity"
    else
        -- 비행 종료
        if root:FindFirstChild("FlyVelocity") then
            root.FlyVelocity:Destroy()
        end
    end
end)

-- [기존 Combat, Visuals, Misc 탭 로직은 그대로 유지]
