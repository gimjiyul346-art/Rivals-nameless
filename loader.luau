local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 초기화
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
if CoreGui:FindFirstChild("NamelessToggle") then CoreGui.NamelessToggle:Destroy() end

local UI = { Tabs = {}, Containers = {}, IsOpen = true }
_G.WalkSpeed = 16
_G.SilentAim = false
_G.Wallbang = false
_G.ESPEnabled = false
_G.FlyEnabled = false
_G.InfJump = false

-- [2] UI 생성 (메뉴 안 뜨는 문제 방지용 최적화)
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 360)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true

-- 상단 탭바 레이아웃
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local TabList = Instance.new("UIListLayout", TabBar)
TabList.FillDirection = Enum.FillDirection.Horizontal

-- [3] 기능 유틸리티 (Slider, Toggle)
local function AddTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 68, 1, 0)
    btn.Text = name:lower()
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.BackgroundTransparency = 1

    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -10, 1, -70)
    Container.Position = UDim2.new(0, 5, 0, 65)
    Container.Visible = false
    Container.BackgroundTransparency = 1
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(UI.Containers) do c.Visible = false end
        Container.Visible = true
    end)
    UI.Containers[name] = Container
    return Container
end

local function AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = "  " .. text; btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.TextColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(255, 255, 255)
        callback(state)
    end)
end

local function AddSlider(parent, text, min, max, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20); label.Text = text .. " : " .. min; label.TextColor3 = Color3.fromRGB(200, 200, 200)
    local slider = Instance.new("TextButton", frame)
    slider.Size = UDim2.new(0.9, 0, 0, 5); slider.Position = UDim2.new(0.05,0,0.7,0)
    slider.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local p = math.clamp((UserInputService:GetMouseLocation().X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * p)
            label.Text = text .. " : " .. val
            callback(val)
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then move:Disconnect() end
        end)
    end)
end

-- [4] 기능 배치
local Main = AddTab("Main")
local ESPTab = AddTab("ESP")
local Misc = AddTab("Misc")
UI.Containers["Main"].Visible = true

AddToggle(Main, "Silent Aim (총알 유도)", function(v) _G.SilentAim = v end)
AddToggle(Main, "Wallbang (벽뚫기 모드)", function(v) _G.Wallbang = v end)
AddToggle(ESPTab, "Box ESP", function(v) _G.ESPEnabled = v end)
AddSlider(Misc, "WalkSpeed", 16, 200, function(v) _G.WalkSpeed = v end)
AddToggle(Misc, "Fly (비행 모드)", function(v) _G.FlyEnabled = v end)
AddToggle(Misc, "Infinite Jump", function(v) _G.InfJump = v end)

-- [5] 핵심 로직 엔진 (Silent Aim & Wallbang)
local function GetClosest()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis or _G.Wallbang then -- 월뱅 시 가려진 적도 타겟
                local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if m < dist then target = p; dist = m end
            end
        end
    end
    return target
end

-- 총알 궤적 수정 (Silent Aim)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.SilentAim and method == "Raycast" and not checkcaller() then
        local t = GetClosest()
        if t and t.Character then
            args[2] = (t.Character.Head.Position - args[1]).Unit * 1000 -- 적 머리로 궤적 변경
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- 이동 및 비행 로직 (부활 대응)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = _G.WalkSpeed
        if _G.FlyEnabled then
            char.PrimaryPart.Velocity = Vector3.new(0, 2, 0) -- 간단한 공중 부양
        end
    end
    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("NamelessESP")
            if _G.ESPEnabled then
                if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "NamelessESP" end
            elseif hl then hl:Destroy() end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 모바일용 메뉴 버튼
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "Menu"
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
