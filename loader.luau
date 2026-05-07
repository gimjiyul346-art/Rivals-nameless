local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 초기화 (중복 방지)
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

-- [2] 메인 UI 프레임
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

-- [3] 상단 타이틀 & 탭 바
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "  Nameless hub | v2 (Rivals)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal

-- [4] 탭 생성 함수
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

-- [5] 기능 추가용 유틸 (Toggle, Slider)
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
    local enabled = false
    Frame.MouseButton1Click:Connect(function()
        enabled = not enabled
        Box.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
        callback(enabled)
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
    local SliderBtn = Instance.new("TextButton", Frame)
    SliderBtn.Size = UDim2.new(0.9, 0, 0, 5)
    SliderBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
    SliderBtn.Text = ""
    local Fill = Instance.new("Frame", SliderBtn)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderBtn.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local percent = math.clamp((UserInputService:GetMouseLocation().X - SliderBtn.AbsolutePosition.X) / SliderBtn.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(min + (max - min) * percent)
            Label.Text = text .. ": " .. val
            callback(val)
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then move:Disconnect() end
        end)
    end)
end

-- [6] 탭 배치 및 기능 연결
local Main = AddTab("Main")
local ESPTab = AddTab("ESP")
local Misc = AddTab("Misc")
AddTab("Visuals"); AddTab("Character"); AddTab("Settings")

UI.Containers["Main"].Visible = true
UI.Tabs["Main"].TextColor3 = Color3.fromRGB(0, 170, 255)

AddToggle(Main, "Silent Aim (총알 꺾임)", function(v) _G.SilentAim = v end)
AddToggle(Main, "Wallbang (벽뚫기)", function(v) _G.Wallbang = v end)

AddToggle(ESPTab, "Box ESP", function(v) _G.ESPEnabled = v end)

AddSlider(Misc, "WalkSpeed", 16, 200, function(v) _G.WalkSpeed = v end)
AddToggle(Misc, "Fly (비행)", function(v) _G.FlyEnabled = v end)
AddToggle(Misc, "Noclip (벽통과)", function(v) _G.Noclip = v end)
AddToggle(Misc, "Infinite Jump", function(v) _G.InfJump = v end)

-- [7] 핵심 로직 엔진
local function GetClosestTarget()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis or _G.Wallbang then -- 월뱅 켜져있으면 안보여도 타겟팅
                local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if m < dist then target = p; dist = m end
            end
        end
    end
    return target
end

-- Silent Aim & Wallbang (Rivals 전용 Raycast Hook)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.SilentAim and method == "Raycast" and not checkcaller() then
        local t = GetClosestTarget()
        if t and t.Character then
            args[2] = (t.Character.Head.Position - args[1]).Unit * 1000
            -- Wallbang 로직: RaycastParams 수정하여 장애물 무시
            if _G.Wallbang and args[3] then
                args[3].FilterDescendantsInstances = {t.Character}
                args[3].FilterType = Enum.RaycastFilterType.Include
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- 이동 및 ESP 루프
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeed
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("NamelessESP")
            if _G.ESPEnabled then
                if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "NamelessESP" end
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

-- 모바일 메뉴 버튼 (성공했던 디자인)
local OpenBtn = Instance.new("TextButton", Instance.new("ScreenGui", CoreGui))
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "Menu"; OpenBtn.Draggable = true
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
