-- [[ Nameless hub | v1 - Team Check & Shift Toggle Fix ]] --
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
    TeamCheck = true, -- 팀 체크 기능 기본 활성화
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
    btn.Size = UDim2.new(0, 100, 1, 0); btn.BackgroundTransparency = 1
    btn.Text = name:upper(); btn.Font = Enum.Font.Code; btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Size = UDim2.new(1, -20, 1, -50); Page.Position = UDim2.new(0, 10, 0, 45)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
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

local function CreateSlider(parent, text, min, max, var)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 40); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 20); l.Text = text .. ": " .. _G.Config[var]; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.Font = Enum.Font.Code; l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(1, 0, 0, 4); b.Position = UDim2.new(0, 0, 0.7, 0); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.Text = ""
    local fill = Instance.new("Frame", b); fill.Size = UDim2.new((_G.Config[var]-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255); fill.BorderSizePixel = 0
    
    b.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local p = math.clamp((UserInputService:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(p, 0, 1, 0); local val = math.floor(min + (max - min) * p)
            l.Text = text .. ": " .. val; _G.Config[var] = val
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then move:Disconnect() end
        end)
    end)
end

-- 탭 구성
local Combat = CreateTab("Combat"); local Rage = CreateTab("Rage"); local Visuals = CreateTab("Visuals")
CreateToggle(Combat, "Aimbot (1P Lock)", "Aimbot")
CreateToggle(Combat, "Team Check", "TeamCheck")
CreateToggle(Combat, "Auto Shoot", "AutoShoot")
CreateToggle(Rage, "Noclip", "Noclip")
CreateToggle(Rage, "Fly", "Fly")
CreateSlider(Rage, "WalkSpeed", 16, 500, "WalkSpeed")
CreateToggle(Visuals, "ESP (Highlight)", "ESP")

-- [[ 핵심 엔진: 팀 체크 포함 ]] --
local function GetClosest()
    local t, d = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, p in pairs(Players:GetPlayers()) do
        -- 팀 체크 및 생존 여부 확인
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
            if p.Character.Humanoid.Health > 0 and (not _G.Config.TeamCheck or p.Team ~= LocalPlayer.Team) then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if m < d then t = p; d = m end
                end
            end
        end
    end
    return t
end

RunService.RenderStepped:Connect(function()
    if _G.Config.Aimbot then
        local target = GetClosest()
        if target and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            if _G.Config.AutoShoot then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end
    end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if _G.Config.WalkSpeed > 16 and char.Humanoid.MoveDirection.Magnitude > 0 then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * (_G.Config.WalkSpeed / 280))
        end
        if _G.Config.Fly then char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) end
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- [[ 고성능 Highlight ESP ]] --
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("NamelessESP")
            if _G.Config.ESP then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "NamelessESP"
                    hl.Parent = p.Character
                    hl.FillColor = Color3.fromRGB(0, 170, 255)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                end
                -- 팀에 따라 색상 변경 (선택사항)
                hl.FillColor = (p.Team == LocalPlayer.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                hl.Enabled = true
            else
                if hl then hl.Enabled = false end
            end
        end
    end
end)

-- [[ Shift 키 토글 ]] --
UserInputService.InputBegan:Connect(function(input, chat)
    if not chat and input.KeyCode == Enum.KeyCode.LeftShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- 메뉴 버튼 (모바일 겸용)
local ToggleBtn = Instance.new("ScreenGui", CoreGui)
local Btn = Instance.new("TextButton", ToggleBtn)
Btn.Size = UDim2.new(0, 50, 0, 50); Btn.Position = UDim2.new(0, 10, 0.4, 0)
Btn.Text = "N"; Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); Btn.TextColor3 = Color3.new(1,1,1); Btn.Draggable = false
Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
Btn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

UI.Pages["Combat"].Visible = true; UI.Tabs["Combat"].TextColor3 = Color3.fromRGB(0, 170, 255)
