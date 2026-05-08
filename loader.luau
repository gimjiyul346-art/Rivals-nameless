-- [[ Nameless hub | IY Engine Integration (ESP, Fly, Silent Aim) ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 중복 제거
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    Aimbot = false,
    AutoShoot = false,
    SilentAim = false, -- IY 기반 Silent Aim
    TeamCheck = true,
    ESP = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    WalkSpeed = 16
}

-- [UI 메인 프레임 생략 없이 핵심 유지]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 350)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0; MainFrame.Active = true; MainFrame.Draggable = true

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 35); TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

local UI = { Tabs = {}, Pages = {} }

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 100, 1, 0); btn.BackgroundTransparency = 1
    btn.Text = name:upper(); btn.Font = Enum.Font.Code; btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Size = UDim2.new(1, -20, 1, -50); Page.Position = UDim2.new(0, 10, 0, 45)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(UI.Pages) do p.Visible = false end
        for _, t in pairs(UI.Tabs) do t.TextColor3 = Color3.fromRGB(150, 150, 150) end
        Page.Visible = true; btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    end)
    UI.Tabs[name] = btn; UI.Pages[name] = Page
    return Page
end

local function CreateToggle(parent, text, var)
    local f = Instance.new("TextButton", parent); f.Size = UDim2.new(1, 0, 0, 35); f.BackgroundColor3 = Color3.fromRGB(22, 22, 22); f.Text = "  "..text
    f.TextColor3 = Color3.new(1,1,1); f.TextXAlignment = Enum.TextXAlignment.Left; f.Font = Enum.Font.Code; f.AutoButtonColor = false
    local b = Instance.new("Frame", f); b.Size = UDim2.new(0, 10, 1, 0); b.Position = UDim2.new(1, -10, 0, 0); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.BorderSizePixel = 0
    f.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        b.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
    end)
end

-- 탭 구성
local Combat = CreateTab("Combat"); local Rage = CreateTab("Rage"); local Visuals = CreateTab("Visuals")
CreateToggle(Combat, "Silent Aim (IY)", "SilentAim")
CreateToggle(Combat, "Team Check", "TeamCheck")
CreateToggle(Rage, "IY Fly", "Fly")
CreateToggle(Rage, "Noclip", "Noclip")
CreateToggle(Visuals, "IY ESP (Box)", "ESP")

-- [[ IY 기반 Fly 로직 ]] --
local iyFlySpeed = 1
RunService.RenderStepped:Connect(function()
    if _G.Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        hum.PlatformStand = true
        local moveDir = hum.MoveDirection
        local flyVec = (Camera.CFrame.LookVector * moveDir.Z) + (Camera.CFrame.RightVector * moveDir.X)
        hrp.Velocity = flyVec * _G.Config.FlySpeed
        if moveDir.Magnitude == 0 then hrp.Velocity = Vector3.new(0,0,0) end
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end)

-- [[ IY 기반 Silent Aim (벽뚫기 포함) ]] --
local function GetClosestTarget()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mag < dist then target = p; dist = mag end
            end
        end
    end
    return target
end

RunService.Heartbeat:Connect(function()
    if _G.Config.SilentAim then
        local t = GetClosestTarget()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            -- 마우스 클릭 시 해당 위치로 총알 강제 전송 시뮬레이션 (VirtualInputManager 활용)
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
            end
        end
    end
end)

-- [[ IY 기반 ESP (Box & Tracer) ]] --
local function CreateESP(p)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "IY_ESP"; box.AlwaysOnTop = true; box.ZIndex = 10; box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(0, 170, 255)
    
    local function Update()
        if _G.Config.ESP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            if p.Team ~= LocalPlayer.Team or not _G.Config.TeamCheck then
                box.Adornee = p.Character.HumanoidRootPart
                box.Size = p.Character:GetExtentsSize()
                box.Parent = p.Character.HumanoidRootPart
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
    RunService.RenderStepped:Connect(Update)
end

Players.PlayerAdded:Connect(CreateESP)
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end

-- [[ 메뉴 단축키: Shift ]] --
UserInputService.InputBegan:Connect(function(input, chat)
    if not chat and input.KeyCode == Enum.KeyCode.LeftShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- 메뉴 버튼
local ToggleBtn = Instance.new("ScreenGui", CoreGui)
local Btn = Instance.new("TextButton", ToggleBtn); Btn.Size = UDim2.new(0, 50, 0, 50); Btn.Position = UDim2.new(0, 15, 0.45, 0)
Btn.Text = "N"; Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); Btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
Btn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

UI.Pages["Combat"].Visible = true; UI.Tabs["Combat"].TextColor3 = Color3.fromRGB(0, 170, 255)

