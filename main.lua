-- [[ Nameless v1 | Pure Performance Edition ]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [ 1. 설정값 ]
local Settings = {
    Aimbot = true,
    TeamCheck = true,
    AimPart = "Head", -- 머리 조준
    AimSmooth = 0.15, -- 부드러운 에임 (안 걸리게)
    ESP = true,
    NoRecoil = true,
    Speed = 25 -- 기본 속도보다 약간 빠름
}

-- [ 2. 핵심 기능: 에임봇 ]
local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if Settings.TeamCheck and player.Team == LocalPlayer.Team then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < shortestDistance then
                    closest = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Settings.Aimbot and LocalPlayer.Character then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(Settings.AimPart) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[Settings.AimPart].Position)
        end
    end
end)

-- [ 3. 핵심 기능: 무반동 & 스피드 ]
task.spawn(function()
    while task.wait(1) do
        if Settings.NoRecoil then
            -- 라이벌즈 총기 반동 로직 무력화 시도
            pcall(function()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Recoil") then
                    tool.Recoil:Destroy()
                end
            end)
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Settings.Speed
        end
    end
end)

-- [ 4. 핵심 기능: ESP (상대 테두리 표시) ]
local function CreateESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = "NamelessESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    
    player.CharacterAdded:Connect(function(char)
        highlight.Parent = char
    end)
    if player.Character then highlight.Parent = player.Character end
end

if Settings.ESP then
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then CreateESP(p) end
    end
    Players.PlayerAdded:Connect(CreateESP)
end

print("Nameless v1 Loaded! No Key, Full Power.")

