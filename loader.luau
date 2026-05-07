local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 중복 실행 방지
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
if CoreGui:FindFirstChild("NamelessToggle") then CoreGui.NamelessToggle:Destroy() end

local UI = { Tabs = {}, Containers = {}, IsOpen = true }
_G.WalkSpeed = 16
_G.SilentAim = false
_G.Wallbang = false
_G.ESPEnabled = false
_G.FlyEnabled = false
_G.Noclip = false
_G.InfJump = false

-- [2] 초기 UI 디자인 복구 (v1)
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 360)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.Active = true
MainFrame.Draggable = true

-- 상단 타이틀
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "  Nameless hub | v1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 탭 바 (모든 카테고리 복구)
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal

-- 탭 생성 함수
local function AddTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 68, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name:lower()
    btn.Font = Enum.Font.Code
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)

    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -10, 1, -70)
    Container.Position = UDim2.new(0, 5, 0, 65)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 2
    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(UI.Containers) do c.Visible = false end
        for _, b in pairs(UI.Tabs) do b.TextColor3 = Color3.fromRGB(150, 150, 150) end
        Container.Visible = true
        btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    end)
    UI.Tabs[name] = btn
    UI.Containers[name] = Container
    return Container
end

-- 기능 추가 유틸
local function AddToggle(parent, text, callback)
    local Frame = Instance.new("TextButton", parent)
    Frame.Size = UDim2.new(1, 0, 0, 30)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.Text = ""
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Code
    Label.TextXAlignment = Enum.TextXAlignment.Left
    local Box = Instance.new("Frame", Frame)
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.Position = UDim2.new(1, -28, 0.5, -9)
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local state = false
    Frame.MouseButton1Click:Connect(function()
        state = not state
        Box.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

local function AddSlider(parent, text, min, max, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame)
    Label.Text = text .. ": " .. min
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    local Bar = Instance.new("TextButton", Frame)
    Bar.Size = UDim2.new(0.9, 0, 0, 5)
    Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
    Bar.Text = ""
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Bar.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(p, 0, 1, 0)
            local val = math.floor(min + (max - min) * p)
            Label.Text = text .. ": " .. val
            callback(val)
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then move:Disconnect() end
        end)
    end)
end

-- [3] 모든 탭 및 기능 배치
local Main = AddTab("Main")
local ESPTab = AddTab("ESP")
local Misc = AddTab("Misc")
local Visuals = AddTab("Visuals")
local Character = AddTab("Character")
local Settings = AddTab("Settings")

UI.Containers["Main"].Visible = true
UI.Tabs["Main"].TextColor3 = Color3.fromRGB(0, 170, 255)

-- Main 탭
AddToggle(Main, "Silent Aim Enabled", function(v) _G.SilentAim = v end)
AddToggle(Main, "Wallbang Enabled", function(v) _G.Wallbang = v end)

-- ESP 탭
AddToggle(ESPTab, "Box ESP", function(v) _G.ESPEnabled = v end)

-- Misc 탭
AddSlider(Misc, "WalkSpeed", 16, 200, function(v) _G.WalkSpeed = v end)
AddToggle(Misc, "Fly Enabled", function(v) _G.FlyEnabled = v end)
AddToggle(Misc, "Noclip Enabled", function(v) _G.Noclip = v end)
AddToggle(Misc, "Infinite Jump", function(v) _G.InfJump = v end)

-- [4] 핵심 엔진 (튕김 방지 및 Silent Aim 정밀화)
local function GetClosest()
    local t, d = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis or _G.Wallbang then
                local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if m < d then t = p; d = m end
            end
        end
    end
    return t
end

-- 튕김 방지를 위해 Namecall만 수정 (메타테이블 인덱스 수정X)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.SilentAim and method == "Raycast" and not checkcaller() then
        local t = GetClosest()
        if t and t.Character then
            args[2] = (t.Character.Head.Position - args[1]).Unit * 1000
            if _G.Wallbang and args[3] then
                args[3].FilterDescendantsInstances = {t.Character}
                args[3].FilterType = Enum.RaycastFilterType.Include
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- 루프 엔진 (Speed, Fly, InfJump)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        -- WalkSpeed (안정적인 CFrame 밀기)
        if _G.WalkSpeed > 16 and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.WalkSpeed / 100))
        end

        -- Fly
        if _G.FlyEnabled then
            hrp.Velocity = Vector3.new(0, 2, 0)
        end

        -- Noclip
        if _G.Noclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 메뉴 버튼
local OpenBtn = Instance.new("TextButton", Instance.new("ScreenGui", CoreGui))
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "Menu"; OpenBtn.Draggable = true
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
