local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 기존 UI 제거 (중복 방지)
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
if CoreGui:FindFirstChild("NamelessToggle") then CoreGui.NamelessToggle:Destroy() end

local UI = { Tabs = {}, Containers = {}, CurrentTab = nil, IsOpen = true }

-- 전역 설정 값
_G.Aimbot = false
_G.SilentAim = false
_G.ESPEnabled = false
_G.WalkSpeed = 16
_G.InfJump = false
_G.Noclip = false

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

-- [3] 모바일용 메뉴 버튼
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

-- [4] 탭 시스템 함수
local function AddTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 68, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name:lower()
    btn.Font = Enum.Font.Code
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.TextSize = 12
    btn.Parent = MainFrame:WaitForChild("TabBar", 5) or nil -- 탭바 대기

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
    return Container
end

-- UI 상단바 및 탭바 생성
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "  Nameless hub | v1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.Parent = TabBar

-- 토글/슬라이더 함수
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

    SliderBack.MouseButton1Down:Connect(function()
        local moveConn
        moveConn = RunService.RenderStepped:Connect(function()
            local mousePos = UserInputService:GetMouseLocation().X
            local relPos = mousePos - SliderBack.AbsolutePosition.X
            local percent = math.clamp(relPos / SliderBack.AbsoluteSize.X, 0, 1)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(min + (max - min) * percent)
            Label.Text = text .. " : " .. val
            callback(val)
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then moveConn:Disconnect() end
        end)
    end)
end

-- [5] 탭 및 기능 연결
local Main = AddTab("Main")
local World = AddTab("World")
local ESPTab = AddTab("ESP")
local Misc = AddTab("Misc")
AddTab("Visuals"); AddTab("Character"); AddTab("Settings")

-- 초기 탭 설정
UI.Containers["Main"].Visible = true
UI.Tabs["Main"].TextColor3 = Color3.fromRGB(0, 170, 255)

AddToggle(Main, "Aimbot Enabled", function(v) _G.Aimbot = v end)
AddToggle(Main, "Silent Aim Enabled", function(v) _G.SilentAim = v end)

AddToggle(ESPTab, "Box ESP (Highlight)", function(v) _G.ESPEnabled = v end)

AddSlider(Misc, "WalkSpeed", 16, 200, function(v) _G.WalkSpeed = v end)
AddToggle(Misc, "Infinite Jump", function(v) _G.InfJump = v end)
AddToggle(Misc, "Noclip", function(v) _G.Noclip = v end)

-- [6] 핵심 기능 로직 (에임봇, ESP, 이동)

local function GetClosestTarget()
    local target, shortest = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mag < shortest then target = p; shortest = mag end
            end
        end
    end
    return target
end

-- 루프 실행 (Aimbot, Speed, Noclip, ESP)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        if _G.Aimbot then
            local t = GetClosestTarget()
            if t and t.Character then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position) end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = _G.WalkSpeed end
    end
    
    -- ESP 관리
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
            elseif hl then hl:Destroy() end
        end
    end
end)

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

print("Nameless Hub v1 정식 로드 완료!")
