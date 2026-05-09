-- [[ Nameless hub | v10 - Anti-Lag & Stability Fix ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- 중복 제거
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    SilentAim = false,
    WallCheck = false,
    TeamCheck = true,
    AimbotFOV = 100,
    ShowFOV = false,
    ESP = false,
    Fly = false,
    FlySpeed = 50,
    JumpPower = 50,
    Noclip = false,
    VoidProof = false
}

-- [FOV 원 생성 - 오류 방지를 위해 존재 여부 확인]
local FOVCircle = nil
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(0, 255, 150)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 1
    FOVCircle.Visible = false
end)

-- [UI 및 슬라이더 로직 - 성능 최적화]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 440, 0, 450)
Main.Position = UDim2.new(0.5, -220, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 3
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 7)

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

-- 버튼 배치
CreateToggle("Silent Aim", "SilentAim")
CreateToggle("Wall Check", "WallCheck")
CreateToggle("Show FOV", "ShowFOV")
CreateSlider("FOV Size", "AimbotFOV", 10, 600)
CreateToggle("ESP Highlight", "ESP")
CreateToggle("Fly", "Fly")
CreateSlider("Fly Speed", "FlySpeed", 10, 300)
CreateSlider("Jump Power", "JumpPower", 50, 200) -- 점프력은 낮게 설정 권장
CreateToggle("Noclip", "Noclip")

-- [[ 타겟팅 로직 최적화 ]] --
local Target = nil
task.spawn(function()
    while task.wait(0.1) do -- 0.1초마다 타겟 갱신 (무한루프 방지)
        local closest, dist = nil, _G.Config.AimbotFOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                if not _G.Config.TeamCheck or p.Team ~= LocalPlayer.Team then
                    local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if vis then
                        local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if mag < dist then
                            if _G.Config.WallCheck then
                                local ray = Ray.new(Camera.CFrame.Position, (p.Character.Head.Position - Camera.CFrame.Position).Unit * 1000)
                                local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, p.Character})
                                if not hit then closest = p; dist = mag end
                            else
                                closest = p; dist = mag
                            end
                        end
                    end
                end
            end
        end
        Target = closest
    end
end)

-- 메타테이블 후킹 (최소 연산)
local mt = getrawmetatable(game); local old = mt.__index; setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if _G.Config.SilentAim and t == Mouse and (k == "Hit" or k == "Target") then
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            return (k == "Hit" and Target.Character.Head.CFrame or Target.Character.Head)
        end
    end
    return old(t, k)
end)

-- 이동 및 기타 루프
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = _G.Config.JumpPower
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and _G.Config.Fly then
            hrp.Velocity = (char.Humanoid.MoveDirection * _G.Config.FlySpeed) + Vector3.new(0, 2, 0)
            char.Humanoid.PlatformStand = true
        else
            char.Humanoid.PlatformStand = false
        end
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
    -- FOV 원 업데이트
    if FOVCircle then
        FOVCircle.Visible = _G.Config.ShowFOV
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = _G.Config.AimbotFOV
    end
end)

-- 메뉴 버튼
local TglBtn = Instance.new("TextButton", ScreenGui); TglBtn.Size = UDim2.new(0, 50, 0, 50); TglBtn.Position = UDim2.new(0, 10, 0.45, 0); TglBtn.Text = "N"; TglBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", TglBtn).CornerRadius = UDim.new(1, 0)
TglBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
