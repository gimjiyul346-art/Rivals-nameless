-- [[ Nameless hub | Success Version - Aim & Fly & Wallbang ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- 기존 UI 제거
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    SilentAim = false,
    Wallbang = false,
    TeamCheck = true,
    ESP = false,
    Fly = false,
    FlySpeed = 50, -- 기본 비행 속도
    JumpPower = 50, -- 기본 점프력
    Noclip = false,
    VoidProof = false
}

-- [UI 레이아웃]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 420, 0, 450)
Main.Position = UDim2.new(0.5, -210, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 3
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 8)

-- [기능 생성 함수]
local function CreateToggle(text, var)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = "  "..text
    b.TextColor3 = Color3.new(0.7, 0.7, 0.7); b.Font = Enum.Font.Code; b.TextXAlignment = "Left"
    local ind = Instance.new("Frame", b); ind.Size = UDim2.new(0, 4, 1, 0); ind.Position = UDim2.new(1, -4, 0, 0); ind.BackgroundColor3 = Color3.fromRGB(50, 50, 50); ind.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        ind.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)
        b.TextColor3 = _G.Config[var] and Color3.new(1, 1, 1) or Color3.new(0.7, 0.7, 0.7)
    end)
end

local function CreateSlider(text, var, min, max)
    local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, 0, 0, 55); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0, 20); t.Text = text.." : ".._G.Config[var]; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.Code; t.BackgroundTransparency = 1
    local s = Instance.new("TextButton", f); s.Size = UDim2.new(1, -10, 0, 8); s.Position = UDim2.new(0, 5, 0, 30); s.BackgroundColor3 = Color3.fromRGB(45, 45, 45); s.Text = ""
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

-- 버튼 리스트
CreateToggle("Silent Aim (IY Engine)", "SilentAim")
CreateToggle("Wallbang (Shoot thru walls)", "Wallbang")
CreateToggle("Team Check", "TeamCheck")
CreateToggle("ESP Highlight", "ESP")
CreateToggle("Fly (Movement Direction)", "Fly")
CreateSlider("Fly Speed (Velocity)", "FlySpeed", 10, 300)
CreateSlider("Jump Power (Reset: 50)", "JumpPower", 50, 300)
CreateToggle("Noclip (Walk thru walls)", "Noclip")
CreateToggle("Void Proof (Anti-Fall)", "VoidProof")

-- [[ 타겟팅 로직 ]] --
local function GetTarget()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            if not _G.Config.TeamCheck or p.Team ~= LocalPlayer.Team then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis or _G.Config.Wallbang then
                    local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if m < dist then target = p; dist = m end
                end
            end
        end
    end
    return target
end

-- [[ 메타테이블 후킹 (IY 엔진) ]] --
local mt = getrawmetatable(game); local old = mt.__index; setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if _G.Config.SilentAim and t == Mouse and (k == "Hit" or k == "Target") then
        local t = GetTarget()
        if t then return (k == "Hit" and t.Character.Head.CFrame or t.Character.Head) end
    end
    return old(t, k)
end)

-- [[ 루프 시스템 ]] --
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        hum.JumpPower = _G.Config.JumpPower
        
        if hrp then
            -- Fly
            if _G.Config.Fly then
                hrp.Velocity = (hum.MoveDirection * _G.Config.FlySpeed) + Vector3.new(0, 2, 0)
                hum.PlatformStand = true
            else
                hum.PlatformStand = false
            end
            -- Void Proof
            if _G.Config.VoidProof and hrp.Position.Y < -50 then
                hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
            -- Noclip
            if _G.Config.Noclip then
                for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
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

-- 메뉴 버튼 (모바일/PC 공용)
local TglBtn = Instance.new("TextButton", ScreenGui); TglBtn.Size = UDim2.new(0, 50, 0, 50); TglBtn.Position = UDim2.new(0, 10, 0.45, 0); TglBtn.Text = "N"; TglBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", TglBtn).CornerRadius = UDim.new(1, 0)
TglBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
