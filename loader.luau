-- [[ Nameless hub | v5 - IY Silent Aim Engine & Full Fix ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    SilentAim = false,
    Wallbang = false,
    TeamCheck = true,
    ESP = false,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    VoidProof = false
}

-- [UI 레이아웃]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 420) -- 높이 조정
Main.Position = UDim2.new(0.5, -225, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 3
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 7)

-- [컴포넌트]
local function CreateToggle(text, var)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.Text = "  "..text
    b.TextColor3 = Color3.new(0.7, 0.7, 0.7); b.Font = Enum.Font.Code; b.TextXAlignment = "Left"
    local ind = Instance.new("Frame", b); ind.Size = UDim2.new(0, 4, 1, 0); ind.Position = UDim2.new(1, -4, 0, 0); ind.BackgroundColor3 = Color3.fromRGB(45, 45, 45); ind.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        ind.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 45, 45)
        b.TextColor3 = _G.Config[var] and Color3.new(1, 1, 1) or Color3.new(0.7, 0.7, 0.7)
    end)
end

local function CreateSlider(text, var, min, max)
    local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, 0, 0, 55); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0, 20); t.Text = text.." : ".._G.Config[var]; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.Code; t.BackgroundTransparency = 1
    local s = Instance.new("TextButton", f); s.Size = UDim2.new(1, -10, 0, 6); s.Position = UDim2.new(0, 5, 0, 30); s.BackgroundColor3 = Color3.fromRGB(40, 40, 40); s.Text = ""
    local bar = Instance.new("Frame", s); bar.Size = UDim2.new((_G.Config[var]-min)/(max-min), 0, 1, 0); bar.BackgroundColor3 = Color3.fromRGB(0, 255, 150); bar.BorderSizePixel = 0
    s.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local rel = math.clamp((UserInputService:GetMouseLocation().X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (rel * (max - min)))
            _G.Config[var] = val
            bar.Size = UDim2.new(rel, 0, 1, 0); t.Text = text.." : "..val
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then move:Disconnect() end
        end)
    end)
end

CreateToggle("Silent Aim (IY Engine)", "SilentAim")
CreateToggle("Wallbang (Bullet Piercing)", "Wallbang")
CreateToggle("Team Check", "TeamCheck")
CreateToggle("ESP Highlight", "ESP")
CreateToggle("Fly (WASD)", "Fly")
CreateSlider("Fly Speed", "FlySpeed", 10, 300)
CreateToggle("Noclip", "Noclip")
CreateToggle("Void Proof", "VoidProof")

-- [[ IY Silent Aim 타겟팅 로직 ]] --
local function GetClosestPlayer()
    local target, shortestDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            if not _G.Config.TeamCheck or p.Team ~= LocalPlayer.Team then
                local pos, visible = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if visible or _G.Config.Wallbang then
                    local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if dist < shortestDist then target = p; shortestDist = dist end
                end
            end
        end
    end
    return target
end

-- [[ 메타테이블 후킹 (IY 방식) ]] --
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if _G.Config.SilentAim and t == Mouse and (k == "Hit" or k == "Target") then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            if k == "Hit" then return target.Character.Head.CFrame end
            if k == "Target" then return target.Character.Head end
        end
    end
    return oldIndex(t, k)
end)

-- [[ 루프 시스템 ]] --
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        -- Fly
        if _G.Config.Fly then
            local dir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown("W") then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown("S") then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown("A") then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown("D") then dir = dir + Camera.CFrame.RightVector end
            hrp.Velocity = dir.Unit * _G.Config.FlySpeed
            char.Humanoid.PlatformStand = true
        else
            char.Humanoid.PlatformStand = false
        end
        -- Void Proof
        if _G.Config.VoidProof and hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
            hrp.Velocity = Vector3.new(0,0,0)
        end
        -- Noclip
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- ESP
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("NamelessESP")
            if _G.Config.ESP then
                if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "NamelessESP" end
                hl.FillColor = (p.Team == LocalPlayer.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                hl.Enabled = true
            elseif hl then hl.Enabled = false end
        end
    end
end)

-- Toggle Menu
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.LeftShift then Main.Visible = not Main.Visible end
end)
