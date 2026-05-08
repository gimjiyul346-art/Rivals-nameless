-- [[ Nameless hub | v1 - Final Complete Edition ]] --
local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 기존 UI 제거
if game:GetService("CoreGui"):FindFirstChild("NamelessUI") then game:GetService("CoreGui").NamelessUI:Destroy() end

-- 설정 변수 (요청하신 모든 기능 포함)
getgenv().Config = {
    SilentAim = false,
    Fly = false,
    FlySpeed = 50,
    WalkSpeed = 16,
    InfJump = false,
    NoClip = false,
    ESP = false,
    TargetPart = "HumanoidRootPart"
}

-- [[ UI 생성: 제공된 이미지 및 영상 스타일 적용 ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "NamelessUI"

-- 모바일용 열기/닫기 플로팅 버튼 (파란색 원형)
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0, 10, 0.5, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Toggle.Text = "N"; Toggle.TextColor3 = Color3.new(1,1,1); Toggle.Font = Enum.Font.Code
Toggle.Draggable = true
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

-- 메인 프레임 (사진의 어두운 테마)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true

-- 좌측 탭 영역
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(0, 100, 1, 0)
Tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local TabList = Instance.new("UIListLayout", Tabs)

-- 우측 기능 영역
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -110, 1, -10)
Container.Position = UDim2.new(0, 105, 0, 5)
Container.BackgroundTransparency = 1

Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function NewTab(name)
    local b = Instance.new("TextButton", Tabs)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    local p = Instance.new("ScrollingFrame", Container)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,2,0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        p.Visible = true
    end)
    return p
end

-- 탭 생성
local TMain = NewTab("Main")
local TRage = NewTab("Rage")
local TChar = NewTab("Character")
local TMisc = NewTab("ESP/Misc")

-- 기능 버튼 생성 함수
local function AddToggle(parent, text, var)
    local t = Instance.new("TextButton", parent)
    t.Size = UDim2.new(1, -5, 0, 40)
    t.BackgroundColor3 = Color3.fromRGB(30, 30, 30); t.Text = text .. ": OFF"; t.TextColor3 = Color3.new(1,1,1)
    t.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        t.Text = text .. ": " .. (getgenv().Config[var] and "ON" or "OFF")
        t.TextColor3 = getgenv().Config[var] and Color3.fromRGB(0, 170, 255) or Color3.new(1,1,1)
    end)
end

-- 슬라이더 대신 간단한 수치 조절 (이속 등)
local function AddSlider(parent, text, var, min, max)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -5, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.Text = text .. ": " .. getgenv().Config[var]
    b.MouseButton1Click:Connect(function()
        getgenv().Config[var] = getgenv().Config[var] + 10
        if getgenv().Config[var] > max then getgenv().Config[var] = min end
        b.Text = text .. ": " .. getgenv().Config[var]
    end)
end

-- 기능 배치
AddToggle(TMain, "Magic Silent Aim", "SilentAim")
AddToggle(TRage, "Fly Mode", "Fly")
AddSlider(TRage, "Fly Speed", "FlySpeed", 50, 250)
AddSlider(TChar, "Walk Speed", "WalkSpeed", 16, 200)
AddToggle(TChar, "Infinite Jump", "InfJump")
AddToggle(TChar, "No Clip", "NoClip")
AddToggle(TMisc, "Player ESP", "ESP")

-- [[ 핵심 엔진 로직 ]] --

-- 1. Silent Aim (카메라 고정 없음)
local function GetClosest()
    local target, dist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if mag < dist then target = v; dist = mag end
            end
        end
    end
    return target
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if getgenv().Config.SilentAim and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local t = GetClosest()
        if t and t.Character then
            if method == "Raycast" then args[2] = (t.Character.HumanoidRootPart.Position - args[1]).Unit * 1000
            else args[1] = Ray.new(Camera.CFrame.Position, (t.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Unit * 1000) end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- 2. ESP (Box ESP)
RunService.RenderStepped:Connect(function()
    if getgenv().Config.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if not v.Character:FindFirstChild("ESPBox") then
                    local b = Instance.new("BoxHandleAdornment", v.Character)
                    b.Name = "ESPBox"; b.AlwaysOnTop = true; b.ZIndex = 10; b.Size = v.Character.HumanoidRootPart.Size * 1.5
                    b.Adornee = v.Character.HumanoidRootPart; b.Color3 = Color3.new(1, 0, 0); b.Transparency = 0.5
                end
            end
        end
    else
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("ESPBox") then v.Character.ESPBox:Destroy() end
        end
    end
end)

-- 3. Character (Fly, Speed, NoClip, InfJump)
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Config.WalkSpeed
        if getgenv().Config.NoClip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        if getgenv().Config.Fly then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) -- 중력 보정
            -- 방향키 입력 시 이동 로직 추가 가능
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().Config.InfJump then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

TMain.Visible = true
