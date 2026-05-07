local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

-- [1] 중복 실행 방지 및 초기화
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {} -- 모든 기능의 ON/OFF 및 값을 저장

-- [2] UI 프레임 디자인 (v1 고정)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 580, 0, 460)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "  Nameless hub | v1 (KICK HOOK PREMIUM MODULES)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

local Containers = Instance.new("Frame", MainFrame)
Containers.Size = UDim2.new(1, 0, 1, -65)
Containers.Position = UDim2.new(0, 0, 0, 65)
Containers.BackgroundTransparency = 1

local UI = { Tabs = {}, Pages = {} }

-- [3] UI 컴포넌트 함수
local function AddTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 82, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name:upper(); btn.Font = Enum.Font.Code; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.TextSize = 10

    local Page = Instance.new("ScrollingFrame", Containers)
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(UI.Pages) do p.Visible = false end
        for _, t in pairs(UI.Tabs) do t.TextColor3 = Color3.fromRGB(150, 150, 150) end
        Page.Visible = true; btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    end)
    UI.Tabs[name] = btn; UI.Pages[name] = Page
    return Page
end

local function AddToggle(parent, text, var)
    local f = Instance.new("TextButton", parent)
    f.Size = UDim2.new(1, -10, 0, 30); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); f.Text = ""
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.BackgroundTransparency = 1
    l.Text = text; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.Font = Enum.Font.Code; l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("Frame", f); b.Size = UDim2.new(0, 16, 0, 16); b.Position = UDim2.new(1, -26, 0.5, -8); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    _G.Config[var] = false
    f.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        b.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
    end)
end

local function AddSlider(parent, text, min, max, def, var)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 20); l.Text = text .. ": " .. def; l.TextColor3 = Color3.fromRGB(180, 180, 180); l.Font = Enum.Font.Code; l.BackgroundTransparency = 1
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.9, 0, 0, 4); b.Position = UDim2.new(0.05, 0, 0.7, 0); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.Text = ""
    local fill = Instance.new("Frame", b); fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255); fill.BorderSizePixel = 0
    _G.Config[var] = def
    b.MouseButton1Down:Connect(function()
        local m; m = RunService.RenderStepped:Connect(function()
            local p = math.clamp((UserInputService:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(p, 0, 1, 0); local val = math.floor(min + (max - min) * p)
            l.Text = text .. ": " .. val; _G.Config[var] = val
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then m:Disconnect() end
        end)
    end)
end

-- [4] 탭별 기능 팍팍 채우기
local Main = AddTab("Main")
local Rage = AddTab("Rage")
local ESPTab = AddTab("ESP")
local Misc = AddTab("Misc")
local Visuals = AddTab("Visuals")
local Character = AddTab("Character")
local Settings = AddTab("Settings")

-- Main (Combat)
AddToggle(Main, "Silent Aim", "SilentAim")
AddToggle(Main, "Wallbang", "Wallbang")
AddToggle(Main, "Auto Shoot", "AutoShoot")
AddToggle(Main, "No Recoil", "NoRecoil")
AddToggle(Main, "No Spread", "NoSpread")
AddToggle(Main, "Infinite Ammo", "InfAmmo")
AddToggle(Main, "Rapid Fire", "RapidFire")

-- Rage (Hardcore)
AddToggle(Rage, "Enable Ragebot", "RageEnabled")
AddToggle(Rage, "Spinbot", "Spinbot")
AddSlider(Rage, "Spin Speed", 1, 100, 30, "SpinSpeed")
AddToggle(Rage, "Anti-Aim (Pitch)", "AntiAim")
AddToggle(Rage, "Kill Aura", "KillAura")
AddToggle(Rage, "Auto Respawn", "AutoRespawn")

-- ESP (Visuals)
AddToggle(ESPTab, "Box ESP", "ESPBoxes")
AddToggle(ESPTab, "Tracers", "ESPTracers")
AddToggle(ESPTab, "Names", "ESPNames")
AddToggle(ESPTab, "Distance", "ESPDist")
AddToggle(ESPTab, "Health Bar", "ESPHealth")

-- Misc (Movement)
AddSlider(Misc, "Walk Speed", 16, 500, 16, "WalkSpeed")
AddSlider(Misc, "Jump Power", 50, 500, 50, "JumpPower")
AddToggle(Misc, "Fly Enabled", "FlyEnabled")
AddToggle(Misc, "Noclip", "Noclip")
AddToggle(Misc, "Infinite Jump", "InfJump")
AddToggle(Misc, "Bhop", "Bhop")

-- Visuals
AddSlider(Visuals, "Field of View", 70, 120, 70, "FOV")
AddToggle(Visuals, "FullBright", "FullBright")
AddToggle(Visuals, "No Fog", "NoFog")

-- [5] 킥훅 기반 통합 엔진 (실제 작동 로직)
local function GetTarget()
    local t, d = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis or _G.Config.Wallbang then
                local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if m < d then t = p; d = m end
            end
        end
    end
    return t
end

-- 튕김 방지 및 기능 실행 (Namecall Hook)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if not checkcaller() and method == "Raycast" and _G.Config.SilentAim then
        local t = GetTarget()
        if t then
            args[2] = (t.Character.Head.Position - args[1]).Unit * 1000
            if _G.Config.Wallbang and args[3] then
                args[3].FilterDescendantsInstances = {t.Character}
                args[3].FilterType = Enum.RaycastFilterType.Include
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- 루프 엔진 (Speed, Fly, Spinbot, FOV)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        -- Speed & Fly
        if _G.Config.WalkSpeed > 16 and char.Humanoid.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (char.Humanoid.MoveDirection * (_G.Config.WalkSpeed / 100))
        end
        if _G.Config.FlyEnabled then hrp.Velocity = Vector3.new(0, 2, 0) end
        -- Spinbot
        if _G.Config.Spinbot then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(_G.Config.SpinSpeed or 20), 0) end
        -- Noclip
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        -- Visuals
        Camera.FieldOfView = _G.Config.FOV
        if _G.Config.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 14 end
    end
end)

-- 초기 탭 활성화
UI.Pages["Main"].Visible = true; UI.Tabs["Main"].TextColor3 = Color3.fromRGB(0, 170, 255)

-- 메뉴 버튼
local OpenBtn = Instance.new("TextButton", Instance.new("ScreenGui", CoreGui))
OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0, 10, 0.4, 0); OpenBtn.Text = "Menu"; OpenBtn.Draggable = true
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
