local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 중복 실행 방지 및 초기화
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
if CoreGui:FindFirstChild("NamelessToggle") then CoreGui.NamelessToggle:Destroy() end

local UI = { Tabs = {}, Containers = {}, CurrentTab = nil, IsOpen = true }
_G.FlyEnabled = false
_G.Noclip = false

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

-- [3] 모바일 전용 메뉴 버튼 (Menu 버튼이 안 뜨면 안 되니까!)
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "NamelessToggle"
ToggleGui.Parent = CoreGui

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Text = "Menu"
OpenBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.Draggable = true
OpenBtn.Parent = ToggleGui

OpenBtn.MouseButton1Click:Connect(function()
    UI.IsOpen = not UI.IsOpen
    MainFrame.Visible = UI.IsOpen
end)

-- [4] 상단바 및 탭 바
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

-- [5] 탭/기능 추가 함수
local function AddTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 68, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name:lower()
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.Code
    btn.Parent = TabBar

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -10, 1, -70)
    Container.Position = UDim2.new(0, 5, 0, 65)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 2
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
    Frame.Size = UDim2.new(1, 0, 0, 30)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.Text = ""
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

-- [6] 기능 배치
local Main = AddTab("Main")
local Misc = AddTab("Misc")
AddTab("World"); AddTab("ESP"); AddTab("Visuals"); AddTab("Character"); AddTab("Settings")

AddToggle(Main, "Aimbot Enabled", function(v) _G.Aimbot = v end)
AddToggle(Main, "Silent Aim Enabled", function(v) _G.SilentAim = v end)

AddToggle(Misc, "Fly (비행)", function(v) _G.FlyEnabled = v end)
AddToggle(Misc, "Noclip (벽 통과)", function(v) _G.Noclip = v end)
AddToggle(Misc, "Infinite Jump", function(v) _G.InfJump = v end)

-- [7] 루프 엔진 (Noclip, Fly, Jump)
RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("Nameless Hub Loaded!")
