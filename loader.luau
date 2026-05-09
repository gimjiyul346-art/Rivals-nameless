-- [[ Nameless hub | v4 - Ultimate Rivals Fix ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 중복 실행 방지
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

-- [UI 메인 프레임]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 380)
Main.Position = UDim2.new(0.5, -225, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "NAMELESS HUB V4 - RIVALS"
Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.Code; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -45)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

-- [UI 컴포넌트 함수]
local function CreateToggle(text, var)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = "  "..text
    b.TextColor3 = Color3.new(0.8,0.8,0.8); b.Font = Enum.Font.Code; b.TextXAlignment = "Left"; b.AutoButtonColor = false
    local indicator = Instance.new("Frame", b)
    indicator.Size = UDim2.new(0, 5, 1, 0); indicator.Position = UDim2.new(1, -5, 0, 0); indicator.BackgroundColor3 = Color3.fromRGB(60, 60, 60); indicator.BorderSizePixel = 0
    
    b.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        indicator.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(60, 60, 60)
        b.TextColor3 = _G.Config[var] and Color3.new(1,1,1) or Color3.new(0.8,0.8,0.8)
    end)
end

local function CreateSlider(text, var, min, max)
    local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, 0, 0, 50); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0, 20); t.Text = text.." : ".._G.Config[var]; t.TextColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 1; t.Font = Enum.Font.Code
    local s = Instance.new("TextButton", f); s.Size = UDim2.new(1, 0, 0, 8); s.Position = UDim2.new(0, 0, 0, 30); s.BackgroundColor3 = Color3.fromRGB(40,40,40); s.Text = ""
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

-- [버튼 생성]
CreateToggle("Silent Aim (Auto-Lock)", "SilentAim")
CreateToggle("Wallbang (Bullet Piercing)", "Wallbang")
CreateToggle("Team Check", "TeamCheck")
CreateToggle("ESP (Highlight)", "ESP")
CreateToggle("Fly (WASD)", "Fly")
CreateSlider("Fly Speed", "FlySpeed", 10, 300)
CreateToggle("Noclip", "Noclip")
CreateToggle("Void Proof", "VoidProof")

-- [[ 핵심 시스템: Silent Aim & Wallbang ]] --
local function GetTarget()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            if not _G.Config.TeamCheck or p.Team ~= LocalPlayer.Team then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis or _G.Config.Wallbang then -- 월뱅 켜지면 시야 밖도 계산
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist then target = p; dist = mag end
                end
            end
        end
    end
    return target
end

-- 조준 및 비행 로직 루프
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    -- 1. Silent Aim (클릭 시 강제 조준)
    if _G.Config.SilentAim and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local t = GetTarget()
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position) end
    end
    
    -- 2. Fly & Void Proof
    if hrp then
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
        
        if _G.Config.VoidProof and hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
            hrp.Velocity = Vector3.new(0,0,0)
        end
        
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- ESP 갱신
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

-- 단축키 (Shift)
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.LeftShift then Main.Visible = not Main.Visible end
end)
