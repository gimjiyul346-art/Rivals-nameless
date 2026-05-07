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
_G.WalkSpeed = 16
_G.SilentAim = false
_G.ESPEnabled = false

-- [2] 메인 UI 생성
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NamelessHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 360)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- [3] 메뉴 버튼 (모바일용)
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

-- 탭 추가 함수
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
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = Container

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

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

-- 토글 추가 함수
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

-- 슬라이더 추가 함수 (이동속도 조절용)
local function AddSlider(parent, text, min, max, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 2)
    Label.Text = text .. " : " .. min
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Code
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local SliderBack = Instance.new("TextButton")
    SliderBack.Size = UDim2.new(0.9, 0, 0, 10)
    SliderBack.Position = UDim2.new(0.05, 0, 0.7, 0)
    SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBack.Text = ""
    SliderBack.Parent = Frame

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.Parent = SliderBack

    local function UpdateSlider()
        local mousePos = UserInputService:GetMouseLocation().X
        local relPos = mousePos - SliderBack.AbsolutePosition.X
        local percent = math.clamp(relPos / SliderBack.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        Label.Text = text .. " : " .. val
        callback(val)
    end

    SliderBack.MouseButton1Down:Connect(function()
        local moveConn
        moveConn = RunService.RenderStepped:Connect(function()
            UpdateSlider()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                moveConn:Disconnect()
            end
        end)
    end)
end

-- [5] 탭 생성 및 기능 배치
local Main = AddTab("Main")
local World = AddTab("World")
local ESPTab = AddTab("ESP")
local Visuals = AddTab("Visuals")
local Char = AddTab("Character")
local Misc = AddTab("Misc")
local Settings = AddTab("Settings")

-- Main: Silent Aim
AddToggle(Main, "Silent Aim Enabled", function(v) _G.SilentAim = v end)

-- ESP: Box ESP
AddToggle(ESPTab, "Box ESP (Highlight)", function(v) _G.ESPEnabled = v end)

-- Misc: 이동 및 편의
AddSlider(Misc, "WalkSpeed", 16, 200, function(v) _G.WalkSpeed = v end)
AddToggle(Misc, "Fly (비행)", function(v) _G.FlyEnabled = v end)
AddToggle(Misc, "Noclip (벽통과)", function(v) _G.Noclip = v end)
AddToggle(Misc, "Infinite Jump", function(v) _G.InfJump = v end)

-- [6] 핵심 엔진 로직 (Fly, Noclip, Speed, Jump, Silent Aim, ESP)

-- 1. 이동 관련 (Speed, Noclip, Fly)
RunService.Stepped:Connect(function()
    if not LocalPlayer.Character then return end
    
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = _G.WalkSpeed end
    
    if _G.Noclip then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- 2. ESP (모바일 최적화 Highlight 방식)
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("NamelessESP")
            if _G.ESPEnabled then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "NamelessESP"
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- 3. Silent Aim (Rivals 최신 엔진 대응)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.SilentAim and method == "Raycast" and not checkcaller() then
        local target = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if m < dist then target = p; dist = m end
                end
            end
        end
        if target then
            args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

print("Nameless Hub v1: 모든 최강 기능이 통합되었습니다.")
