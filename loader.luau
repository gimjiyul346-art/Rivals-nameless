-- [[ Nameless hub | v1 - 1P Aimbot & Slider Fix ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 중복 제거
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
if CoreGui:FindFirstChild("NamelessToggle") then CoreGui.NamelessToggle:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    Aimbot = false,
    AutoShoot = false,
    ESP = false,
    Noclip = false,
    Fly = false,
    WalkSpeed = 16
}

-- [1] UI 생성 (메인 프레임)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 350)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0; MainFrame.Active = true; MainFrame.Draggable = true

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 35); TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

local UI = { Tabs = {}, Pages = {} }

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 80, 1, 0); btn.BackgroundTransparency = 1
    btn.Text = name:lower(); btn.Font = Enum.Font.Code; btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Size = UDim2.new(1, -10, 1, -45); Page.Position = UDim2.new(0, 5, 0, 40)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(UI.Pages) do p.Visible = false end
        Page.Visible = true
    end)
    UI.Tabs[name] = btn; UI.Pages[name] = Page
    return Page
end

local function CreateToggle(parent, text, var)
    local f = Instance.new("TextButton", parent); f.Size = UDim2.new(1, -10, 0, 35); f.BackgroundColor3 = Color3.fromRGB(22, 22, 22); f.Text = "  "..text
    f.TextColor3 = Color3.new(1,1,1); f.TextXAlignment = Enum.TextXAlignment.Left; f.Font = Enum.Font.Code
    f.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        f.TextColor3 = _G.Config[var] and Color3.fromRGB(0, 170, 255) or Color3.new(1,1,1)
    end)
end

-- [복구된 슬라이더 함수]
local function CreateSlider(parent, text, min, max, var)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 20); l.Text = text .. ": " .. _G.Config[var]
    l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.Font = Enum.Font.Code
    local bar = Instance.new("TextButton", f); bar.Size = UDim2.new(1, 0, 0, 10); bar.Position = UDim2.new(0,0,0,25)
    bar.BackgroundColor3 = Color3.fromRGB(35, 35, 35); bar.Text = ""
    local fill = Instance.new("Frame", bar); fill.Size = UDim2.new((_G.Config[var]-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255); fill.BorderSizePixel = 0

    local function move(input)
        local p = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(p, 0, 1, 0)
        local val = math.floor(min + (max - min) * p)
        l.Text = text .. ": " .. val; _G.Config[var] = val
    end
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then move(i) end end)
end

-- 탭 구성
local Main = CreateTab("Combat"); local Rage = CreateTab("Rage"); local Visual = CreateTab("Visual")
CreateToggle(Main, "Aimbot (1P/3P Fix)", "Aimbot")
CreateToggle(Main, "Auto Shoot", "AutoShoot")
CreateToggle(Rage, "Noclip", "Noclip")
CreateToggle(Rage, "Fly", "Fly")
CreateSlider(Rage, "Walk Speed", 16, 300, "WalkSpeed")
CreateToggle(Visual, "Box ESP", "ESP")

-- [2] 핵심 엔진 (1인칭 대응 에임봇 & 자동 사격)
local function GetTarget()
    local t, d = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if m < d then t = p; d = m end
            end
        end
    end
    return t
end

RunService.RenderStepped:Connect(function()
    -- 에임봇 및 1인칭 강제 고정
    if _G.Config.Aimbot then
        local target = GetTarget()
        if target and target.Character:FindFirstChild("Head") then
            local headPos = target.Character.Head.Position
            -- 1인칭에서도 엔진의 간섭을 뚫고 카메라를 고정시킵니다.
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)

            if _G.Config.AutoShoot then
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                if onScreen then
                    VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 1)
                    task.wait()
                    VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 1)
                end
            end
        end
    end

    -- 이동 기능 (속도 & 노클립)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if _G.Config.WalkSpeed > 16 then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * (_G.Config.WalkSpeed / 100))
        end
        if _G.Config.Fly then char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) end
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- 메뉴 버튼
local ToggleBtn = Instance.new("ScreenGui", CoreGui)
local Btn = Instance.new("TextButton", ToggleBtn)
Btn.Size = UDim2.new(0, 50, 0, 50); Btn.Position = UDim2.new(0, 10, 0.4, 0)
Btn.Text = "Menu"; Btn.Draggable = true; Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Btn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

UI.Pages["Combat"].Visible = true
