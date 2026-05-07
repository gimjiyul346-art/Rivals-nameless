local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 기존 UI 제거
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
if CoreGui:FindFirstChild("NamelessToggle") then CoreGui.NamelessToggle:Destroy() end

local UI = { Tabs = {}, Containers = {}, CurrentTab = nil, IsOpen = true }

-- 전역 변수 초기화
_G.FlyEnabled = false
_G.Noclip = false
_G.InfJump = false
_G.Aimbot = false
_G.SilentAim = false

-- [2] 메인 UI 생성
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NamelessHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 380)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- [3] 모바일 메뉴 버튼
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "NamelessToggle"
ToggleGui.Parent = CoreGui

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.BorderSizePixel = 1
OpenBtn.BorderColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.Text = "Menu"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.Code
OpenBtn.TextSize = 12
OpenBtn.Draggable = true
OpenBtn.Parent = ToggleGui

OpenBtn.MouseButton1Click:Connect(function()
    UI.IsOpen = not UI.IsOpen
    MainFrame.Visible = UI.IsOpen
end)

-- [4] 상단바 및 탭 시스템
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "  Nameless hub | v1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabBar.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabBar

local function AddTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 68, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name:lower()
    btn.Font = Enum.Font.Code
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Parent = TabBar

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -10, 1, -70)
    Container.Position = UDim2.new(0, 5, 0, 65)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 2
    Container.CanvasSize = UDim2.new(0,0,2,0)
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = Container

    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(UI.Containers) do c.Visible = false end
        for _, b in pairs(UI.Tabs) do b.TextColor3 = Color3.fromRGB(150, 150, 150) end
        Container.Visible = true
        btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    end)

    UI.Tabs[name] = btn
    UI.Containers[name] = Container
    if not UI.CurrentTab then btn.TextColor3 = Color3.fromRGB(0, 170, 255); Container.Visible = true; UI.CurrentTab = name end
    return Container
end

local function AddToggle(parent, text, callback)
    local Frame = Instance.new("TextButton")
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 1
    Frame.BorderColor3 = Color3.fromRGB(45, 45, 45)
    Frame.Text = ""
    Frame.AutoButtonColor = false
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Code
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.Position = UDim2.new(1, -28, 0.5, -9)
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Box.Parent = Frame

    local enabled = false
    Frame.MouseButton1Click:Connect(function()
        enabled = not enabled
        Box.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
        callback(enabled)
    end)
end

-- [5] 탭 생성 및 기능 배치
local Main = AddTab("Main")
local World = AddTab("World")
local ESP = AddTab("ESP")
local Visuals = AddTab("Visuals")
local Char = AddTab("Character")
local Misc = AddTab("Misc")
local Settings = AddTab("Settings")

-- Main 기능
AddToggle(Main, "Aimbot Enabled", function(v) _G.Aimbot = v end)
AddToggle(Main, "Silent Aim Enabled", function(v) _G.SilentAim = v end)

-- Misc 기능 (요청하신 기능들)
AddToggle(Misc, "Fly (비행)", function(v) _G.FlyEnabled = v end)
AddToggle(Misc, "Noclip (벽 통과)", function(v) _G.Noclip = v end)
AddToggle(Misc, "Infinite Jump", function(v) _G.InfJump = v end)

-- [6] 핵심 기능 엔진 루프
local Speed = 50
RunService.Stepped:Connect(function()
    if not LocalPlayer.Character then return end
    
    -- Noclip 로직
    if _G.Noclip then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    -- Fly 로직 (카메라 방향 비행)
    if _G.FlyEnabled then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local moveDir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            root.Velocity = moveDir * Speed
        end
    end
end)

-- 무한 점프 (Rivals 이단점프 로직 대응)
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and root then 
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
        end
    end
end)

print("Nameless Hub v1: 모든 기능이 Misc 탭에 통합되었습니다.")
