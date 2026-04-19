-- [[ Nameless v1 | Fixed & No Key ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Settings = {
    Aimbot = true,
    AimPart = "Head",
    Smoothness = 0.2,
    ESP = true,
    TeamCheck = true
}

-- [ 에임봇 로직 ]
local function GetClosestPlayer()
    local target = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            local screenPos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if magnitude < dist then
                    target = v
                    dist = magnitude
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(Settings.AimPart) then
            local targetPos = target.Character[Settings.AimPart].Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), Settings.Smoothness)
        end
    end
end)

-- [ ESP 로직 ]
local function AddESP(player)
    local function Apply()
        if player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
        end
    end
    player.CharacterAdded:Connect(Apply)
    Apply()
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then AddESP(p) end
end
Players.PlayerAdded:Connect(AddESP)

print("Nameless v1 successfully loaded!")

