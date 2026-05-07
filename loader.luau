local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 초기화
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
local UI = { Tabs = {}, Containers = {}, IsOpen = true }
_G.WalkSpeed = 16
_G.SilentAim = false
_G.Wallbang = false
_G.FlyEnabled = false
_G.InfJump = false

-- [2] UI 생성 (v1 디자인 유지)
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

local function AddTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Text = name; btn.TextColor3 = Color3.fromRGB(200, 200, 200); btn.BackgroundTransparency = 1
    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -10, 1, -40)
    Container.Position = UDim2.new(0, 5, 0, 35)
    Container.Visible = false; Container.BackgroundTransparency = 1
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
        btn.TextColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

local Main = AddTab("Main")
local Misc = AddTab("Misc")
UI.Containers["Main"].Visible = true

AddToggle(Main, "Silent Aim (Safe Mode)", function(v) _G.SilentAim = v end)
AddToggle(Main, "Wallbang", function(v) _G.Wallbang = v end)
AddToggle(Misc, "Fly", function(v) _G.FlyEnabled = v end)
AddToggle(Misc, "Inf Jump", function(v) _G.InfJump = v end)

-- [3] 매칭 서버 우회 엔진 (튕김 방지 로직)

local function GetClosest()
    local target, dist = nil, 500 -- 너무 먼 거리는 타겟팅 제외 (튕김 방지)
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

-- 튕김 방지를 위해 getrawmetatable 대신 우회력이 높은 hookmetamethod 사용
local oldNC
oldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Silent Aim: 총알 계산 함수(Raycast)만 가로챔
    if not checkcaller() and _G.SilentAim and method == "Raycast" then
        local t = GetClosest()
        if t and t.Character then
            -- 튕김 방지: 원래 쏘려던 방향과 적 사이의 오차를 계산해 자연스럽게 보정
            args[2] = (t.Character.Head.Position - args[1]).Unit * 1000
            return oldNC(self, unpack(args))
        end
    end
    return oldNC(self, ...)
end)

-- 이동 및 기타 루프
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if _G.FlyEnabled then
            hrp.Velocity = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then hrp.CFrame *= CFrame.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then hrp.CFrame *= CFrame.new(0,-1,0) end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 메뉴 버튼
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "Menu"
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
