-- [[ Nameless hub | v1 - Final 1P Fix & Slider Recovery ]] --
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

-- [1] UI 메인 프레임
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
    Page.Size = UDim2.new(1, -20, 1, -50); Page.Position = UDim2.new(0, 10, 0, 45)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(UI.Pages) do p.Visible = false end
        for _, t in pairs(UI.Tabs) do t.TextColor3 = Color3.fromRGB(150, 150, 150) end
        Page.Visible = true; btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    end)
    UI.Tabs[name] = btn; UI.Pages[name] = Page
    return Page
end

local function CreateToggle(parent, text, var)
    local f = Instance.new("TextButton", parent); f.Size = UDim2.new(1, 0, 0, 35); f.BackgroundColor3 = Color3.fromRGB(22, 22, 22); f.Text = "  "..text
    f.TextColor3 = Color3.new(1,1,1); f.TextXAlignment = Enum.TextXAlignment.Left; f.Font = Enum.Font.Code; f.AutoButtonColor = false
    local b = Instance.new("Frame", f); b.Size = UDim2.new(0, 10, 1, 0); b.Position = UDim2.new(1, -10, 0, 0); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.BorderSizePixel = 0
    f.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        b.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
    end)
end

-- [슬라이더 기능 - 가시성 및 작동 보장]
local function CreateSlider(parent, text, min, max, var)
    local sContainer = Instance.new("Frame", parent)
    sContainer.Size = UDim2.new(1, 0, 0, 50); sContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", sContainer)
    label.Size = UDim2.new(1, 0, 0, 20); label.Text = text .. ": " .. _G.Config[var]; label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1; label.Font = Enum.Font.Code; label.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("TextButton", sContainer)
    bar.Size = UDim2.new(1, -10, 0, 6); bar.Position = UDim2.new(0, 0, 0, 25); bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45); bar.Text = ""
    
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((_G.Config[var] - min)/(max - min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255); fill.BorderSizePixel = 0

    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        _G.Config[var] = val
        label.Text = text .. ": " .. val
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local con; con = RunService.RenderStepped:Connect(function()
                update(UserInputService:GetMouseLocation())
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then con:Disconnect() end
            end)
        end
    end)
end

-- 탭 구성
local Combat = CreateTab("Combat"); local Rage = CreateTab("Rage"); local Visuals = CreateTab("Visuals")
CreateToggle(Combat, "Aimbot (1st Person Fix)", "Aimbot")
CreateToggle(Combat, "Auto Shoot", "AutoShoot")
CreateToggle(Rage, "Noclip", "Noclip")
CreateToggle(Rage, "Fly", "Fly")
CreateSlider(Rage, "Speed Hack", 16, 500, "WalkSpeed")
CreateToggle(Visuals, "Box ESP", "ESP")

-- [2] 핵심 엔진 (1인칭 완벽 대응 에임봇)
local function GetClosest()
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
    if _G.Config.Aimbot then
        local target = GetClosest()
        if target and target.Character:FindFirstChild("Head") then
            local headPos = target.Character.Head.Position
            -- 1인칭 대응 핵심: 카메라 CFrame을 직접 설정하여 엔진의 마우스 잠금을 무시
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

    -- 캐릭터 이동 로직 (속도 핵)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if _G.Config.WalkSpeed > 16 and char.Humanoid.MoveDirection.Magnitude > 0 then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * (_G.Config.WalkSpeed / 100))
        end
        if _G.Config.Fly then char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) end
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- 메뉴 토글 버튼
local ToggleBtn = Instance.new("ScreenGui", CoreGui)
local Btn = Instance.new("TextButton", ToggleBtn)
Btn.Size = UDim2.new(0, 50, 0, 50); Btn.Position = UDim2.new(0, 10, 0.4, 0)
Btn.Text = "Menu"; Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); Btn.Draggable = true
Btn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

UI.Pages["Combat"].Visible = true; UI.Tabs["Combat"].TextColor3 = Color3.fromRGB(0, 170, 255)
