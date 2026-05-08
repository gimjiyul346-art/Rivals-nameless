-- [[ Nameless hub | v1 - Ultimate Mobile Edition ]] --
local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 기존 UI 제거
if game:GetService("CoreGui"):FindFirstChild("NamelessUI") then game:GetService("CoreGui").NamelessUI:Destroy() end

-- 설정 변수
getgenv().Config = {
    Aimbot = false,
    SilentAim = false,
    WalkSpeed = 16,
    Fly = false,
    FlySpeed = 50,
    InfJump = false,
    NoClip = false,
    ESP = false,
    TargetPart = "HumanoidRootPart"
}

-- [[ UI 구성 ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "NamelessUI"

-- 토글 버튼
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 45, 0, 45); Toggle.Position = UDim2.new(0, 10, 0.5, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255); Toggle.Text = "N"; Toggle.Draggable = true
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

-- 메인 프레임
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 420, 0, 280); Main.Position = UDim2.new(0.5, -210, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- 탭 & 컨테이너
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(0, 100, 1, 0); Tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIListLayout", Tabs)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -110, 1, -10); Container.Position = UDim2.new(0, 105, 0, 5); Container.BackgroundTransparency = 1

local function NewTab(name)
    local b = Instance.new("TextButton", Tabs)
    b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(1,1,1)
    local p = Instance.new("ScrollingFrame", Container)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,2,0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        p.Visible = true
    end)
    return p
end

-- 기능 컴포넌트
local function AddToggle(parent, text, var)
    local t = Instance.new("TextButton", parent)
    t.Size = UDim2.new(1, -5, 0, 35); t.BackgroundColor3 = Color3.fromRGB(30,30,30); t.Text = text .. ": OFF"; t.TextColor3 = Color3.new(1,1,1)
    t.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        t.Text = text .. ": " .. (getgenv().Config[var] and "ON" or "OFF")
        t.TextColor3 = getgenv().Config[var] and Color3.fromRGB(0, 170, 255) or Color3.new(1,1,1)
    end)
end

-- 이동속도 슬라이더 (바 형식)
local function AddSlider(parent, text, var, min, max)
    local sFrame = Instance.new("Frame", parent)
    sFrame.Size = UDim2.new(1, -5, 0, 50); sFrame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", sFrame)
    label.Size = UDim2.new(1, 0, 0, 20); label.Text = text .. ": " .. getgenv().Config[var]; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1
    local bar = Instance.new("TextButton", sFrame)
    bar.Size = UDim2.new(1, 0, 0, 20); bar.Position = UDim2.new(0, 0, 0, 25); bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); bar.Text = ""
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((getgenv().Config[var] - min)/(max - min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255); fill.BorderSizePixel = 0

    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        getgenv().Config[var] = val
        label.Text = text .. ": " .. val
    end

    bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then update(input) end end)
end

-- 탭 구성
local TMain = NewTab("Main")
local TRage = NewTab("Rage")
local TChar = NewTab("Character")

AddToggle(TMain, "Aimbot (Follow)", "Aimbot")
AddToggle(TMain, "Silent Aim", "SilentAim")
AddToggle(TRage, "Fly Mode", "Fly")
AddSlider(TChar, "Walk Speed", "WalkSpeed", 16, 250)
AddToggle(TChar, "Infinite Jump", "InfJump")
AddToggle(TChar, "No Clip", "NoClip")

-- [[ 엔진 로직 ]] --
local function GetClosest()
    local target, dist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mag < dist then target = v; dist = mag end
            end
        end
    end
    return target
end

-- 에임봇 (적을 직접 따라감)
RunService.RenderStepped:Connect(function()
    if getgenv().Config.Aimbot then
        local t = GetClosest()
        if t and t.Character then
            local targetPos = Camera:WorldToScreenPoint(t.Character[getgenv().Config.TargetPart].Position)
            local mousePos = UserInputService:GetMouseLocation()
            TweenService:Create(Camera, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Camera.CFrame.Position, t.Character[getgenv().Config.TargetPart].Position)}):Play()
        end
    end
end)

-- 캐릭터 속도 강제 적용 (작동 안 됨 해결)
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Config.WalkSpeed
        if getgenv().Config.NoClip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

TMain.Visible = true
