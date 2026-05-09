-- [[ Nameless hub | v11 - Zero-Lag & Performance Focus ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 기존 UI 제거
local old = game:GetService("CoreGui"):FindFirstChild("NamelessHub")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "NamelessHub"

_G.Config = {
    Aimbot = false,
    WallCheck = false,
    TeamCheck = true,
    FOV = 150,
    Fly = false,
    FlySpeed = 50,
    JumpPower = 50,
    ESP = false
}

-- [UI 레이아웃 - 더 단순하게]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 400, 0, 400)
Main.Position = UDim2.new(0.5, -200, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true; Main.Draggable = true

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

-- [최적화된 컴포넌트]
local function CreateToggle(text, var)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.Text = text; b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        b.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 40)
    end)
end

local function CreateSlider(text, var, min, max)
    local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, 0, 0, 50); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0, 20); t.Text = text.." : ".._G.Config[var]; t.TextColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 1
    local s = Instance.new("TextButton", f); s.Size = UDim2.new(1, -10, 0, 10); s.Position = UDim2.new(0, 5, 0, 25); s.Text = ""
    s.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local rel = math.clamp((UserInputService:GetMouseLocation().X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (rel * (max - min)))
            _G.Config[var] = val
            t.Text = text.." : "..val
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then move:Disconnect() end
        end)
    end)
end

-- 버튼 배치
CreateToggle("Aimbot (Lock-On)", "Aimbot")
CreateToggle("Wall Check", "WallCheck")
CreateSlider("FOV Range", "FOV", 50, 500)
CreateToggle("ESP", "ESP")
CreateToggle("Fly", "Fly")
CreateSlider("Fly Speed", "FlySpeed", 10, 200)
CreateSlider("Jump Power", "JumpPower", 50, 150)

-- [[ 초경량 타겟팅 엔진 ]] --
local function GetClosestTarget()
    local target, dist = nil, _G.Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            if not _G.Config.TeamCheck or p.Team ~= LocalPlayer.Team then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist then
                        if _G.Config.WallCheck then
                            local parts = Camera:GetPartsObscuringTarget({p.Character.Head.Position}, {LocalPlayer.Character, p.Character})
                            if #parts == 0 then target = p; dist = mag end
                        else
                            target = p; dist = mag
                        end
                    end
                end
            end
        end
    end
    return target
end

-- [[ 통합 루프 (가장 안전한 방식) ]] --
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- 1. Aimbot (카메라 직접 조작 - 메타테이블 미사용으로 렉 방지)
    if _G.Config.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local t = GetClosestTarget()
        if t then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end

    -- 2. Fly & Jump
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hum then hum.JumpPower = _G.Config.JumpPower end
    if hrp and _G.Config.Fly then
        hrp.Velocity = (hum.MoveDirection * _G.Config.FlySpeed) + Vector3.new(0, 2, 0)
        hum.PlatformStand = true
    elseif hum then
        hum.PlatformStand = false
    end
    
    -- 3. ESP (간단한 Highlight 방식)
    if _G.Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("ESPHL")
                if not hl then 
                    hl = Instance.new("Highlight", p.Character); hl.Name = "ESPHL"
                    hl.FillTransparency = 0.5; hl.OutlineColor = Color3.new(1,1,1)
                end
                hl.Enabled = true
            end
        end
    end
end)

-- 메뉴 버튼
local TglBtn = Instance.new("TextButton", ScreenGui); TglBtn.Size = UDim2.new(0, 45, 0, 45); TglBtn.Position = UDim2.new(0, 10, 0.5, 0); TglBtn.Text = "N"
TglBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
