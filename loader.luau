local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 초기화 및 UI 복구
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

-- [2] 메인 UI 프레임 (디자인 유지)
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

-- [3] 타이틀 및 탭 시스템
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "  Nameless hub | v1 (Kick Hook Engine)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

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
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)
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

-- [4] 기능 연결
local Main = AddTab("Main")
local Misc = AddTab("Misc")
UI.Containers["Main"].Visible = true

local function AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = "  " .. text; btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.TextColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

AddToggle(Main, "Silent Aim Enabled", function(v) _G.SilentAim = v end)
AddToggle(Main, "Wallbang Enabled", function(v) _G.Wallbang = v end)

local speedVal = 16
local slider = Instance.new("TextBox", Misc) -- 킥훅처럼 숫자로 입력하거나 조절 가능하게 변경
slider.Size = UDim2.new(1, 0, 0, 30)
slider.PlaceholderText = "WalkSpeed (Default: 16)"
slider.FocusLost:Connect(function() _G.WalkSpeed = tonumber(slider.Text) or 16 end)

AddToggle(Misc, "Fly Enabled", function(v) _G.FlyEnabled = v end)
AddToggle(Misc, "Infinite Jump", function(v) _G.InfJump = v end)

-- [5] Kick Hook 기반 핵심 엔진 이식

-- 1. 진짜 Silent Aim (시점 고정 없음, 총알 각도만 계산)
local function GetClosest()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis or _G.Wallbang then
                local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if m < dist then target = p; dist = m end
            end
        end
    end
    return target
end

local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, idx)
    if _G.SilentAim and self == Camera and idx == "CFrame" and not checkcaller() then
        local t = GetClosest()
        if t and t.Character then
            -- 화면은 그대로인데 내부 연산에서만 적을 바라보는 것처럼 속임 (Kick Hook 방식)
            return CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end
    return oldIndex(self, idx)
end)
setreadonly(mt, true)

-- 2. 강제 이동 (WalkSpeed 우회) 및 Fly
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character.Humanoid
        
        -- 이동속도 (CFrame 강제 밀기 방식)
        if _G.WalkSpeed > 16 and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.WalkSpeed / 50))
        end

        -- Fly (Kick Hook 식 위치 고정)
        if _G.FlyEnabled then
            hrp.Velocity = Vector3.new(0, 0, 0)
            local flyDir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then flyDir = flyDir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then flyDir = flyDir + Vector3.new(0,-1,0) end
            hrp.CFrame = hrp.CFrame + (flyDir * 1.5)
        end
    end
end)

-- 3. Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 메뉴 오픈 버튼
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "Menu"; OpenBtn.Draggable = true
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
