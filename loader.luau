-- [[ Nameless hub | v9 - Wall Check, FOV Slider & Integration ]] --
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
    WallCheck = false, -- 벽 체크 추가
    TeamCheck = true,
    AimbotFOV = 100,   -- FOV 기본값
    ShowFOV = false,   -- FOV 원 표시 여부
    ESP = false,
    Fly = false,
    FlySpeed = 50,
    JumpPower = 50,
    Noclip = false,
    VoidProof = false
}

-- [FOV 원 생성]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- [UI 레이아웃]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 460, 0, 500)
Main.Position = UDim2.new(0.5, -230, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 4
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 8)

-- [UI 컴포넌트]
local function CreateToggle(text, var)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    b.Text = "  "..text; b.TextColor3 = Color3.new(0.7, 0.7, 0.7); b.Font = Enum.Font.Code; b.TextXAlignment = "Left"
    local ind = Instance.new("Frame", b); ind.Size = UDim2.new(0, 5, 1, 0); ind.Position = UDim2.new(1, -5, 0, 0); ind.BackgroundColor3 = Color3.fromRGB(50, 50, 50); ind.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        ind.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)
        b.TextColor3 = _G.Config[var] and Color3.new(1, 1, 1) or Color3.new(0.7, 0.7, 0.7)
    end)
end

local function CreateSlider(text, var, min, max)
    local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, 0, 0, 55); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0, 20); t.Text = text.." : ".._G.Config[var]; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.Code; t.BackgroundTransparency = 1
    local s = Instance.new("TextButton", f); s.Size = UDim2.new(1, -10, 0, 8); s.Position = UDim2.new(0, 5, 0, 30); s.BackgroundColor3 = Color3.fromRGB(40, 40, 40); s.Text = ""
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

-- [기능 배치]
CreateToggle("Silent Aim", "SilentAim")
CreateToggle("Wall Check (Don't aim through walls)", "WallCheck")
CreateToggle("Team Check", "TeamCheck")
CreateToggle("Show FOV Circle", "ShowFOV")
CreateSlider("Aimbot FOV Range", "AimbotFOV", 10, 800) -- FOV 조절 막대기
CreateToggle("ESP Highlight", "ESP")
CreateToggle("Fly", "Fly")
CreateSlider("Fly Speed", "FlySpeed", 10, 300)
CreateSlider("Jump Power", "JumpPower", 50, 500)
CreateToggle("Noclip", "Noclip")
CreateToggle("Void Proof", "VoidProof")

-- [[ 핵심 로직: Wall Check & FOV ]] --
local function IsVisible(targetPart)
    if not _G.Config.WallCheck then return true end
    local ray = Camera:ViewportPointToRay(Camera:WorldToViewportPoint(targetPart.Position).X, Camera:WorldToViewportPoint(targetPart.Position).Y)
    local hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(ray.Origin, ray.Direction * 1000), {LocalPlayer.Character, targetPart.Parent})
    return hit == nil
end

local function GetTarget()
    local target, dist = nil, _G.Config.AimbotFOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            if not _G.Config.TeamCheck or p.Team ~= LocalPlayer.Team then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist and IsVisible(p.Character.Head) then
                        target = p; dist = mag
                    end
                end
            end
        end
    end
    return target
end

-- [메인 루프]
RunService.RenderStepped:Connect(function()
    -- FOV 원 업데이트
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = _G.Config.AimbotFOV
    FOVCircle.Visible = _G.Config.ShowFOV

    -- ESP 및 다른 로직들 (v8과 동일하게 유지)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("NamelessESP")
            if _G.Config.ESP then
                if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "NamelessESP" end
                hl.Enabled = true
            elseif hl then hl.Enabled = false end
        end
    end
end)

-- 메타테이블 (Silent Aim)
local mt = getrawmetatable(game); local old = mt.__index; setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if _G.Config.SilentAim and t == Mouse and (k == "Hit" or k == "Target") then
        local t = GetTarget()
        if t then return (k == "Hit" and t.Character.Head.CFrame or t.Character.Head) end
    end
    return old(t, k)
end)

-- 이동/비행 (v8 로직 유지)
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = _G.Config.JumpPower
        if _G.Config.Fly and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = (char.Humanoid.MoveDirection * _G.Config.FlySpeed) + Vector3.new(0, 2, 0)
            char.Humanoid.PlatformStand = true
        else
            char.Humanoid.PlatformStand = false
        end
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- 메뉴 버튼
local TglBtn = Instance.new("TextButton", ScreenGui); TglBtn.Size = UDim2.new(0, 50, 0, 50); TglBtn.Position = UDim2.new(0, 10, 0.45, 0); TglBtn.Text = "N"; TglBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", TglBtn).CornerRadius = UDim.new(1, 0)
TglBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
