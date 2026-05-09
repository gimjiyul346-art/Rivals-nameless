-- [[ Nameless hub | v7 - Cross-Platform (Mobile & PC) ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    SilentAim = false,
    Wallbang = false,
    TeamCheck = true,
    ESP = false,
    Fly = false,
    FlySpeed = 50,
    JumpPower = 50,
    Noclip = false,
    VoidProof = false
}

-- [UI 레이아웃 - 모바일을 위해 크기 및 가독성 최적화]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 400)
Main.Position = UDim2.new(0.5, -240, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 5 -- 모바일 터치용
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

-- [모바일/PC 통합 클릭 지원 함수]
local function CreateToggle(text, var)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.Text = "  "..text; b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.Code; b.TextXAlignment = "Left"
    local ind = Instance.new("Frame", b); ind.Size = UDim2.new(0, 6, 1, 0); ind.Position = UDim2.new(1, -6, 0, 0); ind.BackgroundColor3 = Color3.fromRGB(60, 60, 60); ind.BorderSizePixel = 0
    
    local function Toggle()
        _G.Config[var] = not _G.Config[var]
        ind.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(60, 60, 60)
        b.TextColor3 = _G.Config[var] and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8)
    end
    b.MouseButton1Click:Connect(Toggle) -- PC & 모바일 공용
end

local function CreateSlider(text, var, min, max)
    local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, 0, 0, 60); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0, 25); t.Text = text.." : ".._G.Config[var]; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.Code; t.BackgroundTransparency = 1
    local s = Instance.new("TextButton", f); s.Size = UDim2.new(1, -10, 0, 12); s.Position = UDim2.new(0, 5, 0, 35); s.BackgroundColor3 = Color3.fromRGB(45, 45, 45); s.Text = ""
    local bar = Instance.new("Frame", s); bar.Size = UDim2.new((_G.Config[var]-min)/(max-min), 0, 1, 0); bar.BackgroundColor3 = Color3.fromRGB(0, 255, 150); bar.BorderSizePixel = 0
    
    local function UpdateSlider()
        local input = UserInputService:GetMouseLocation()
        local rel = math.clamp((input.X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (rel * (max - min)))
        _G.Config[var] = val
        bar.Size = UDim2.new(rel, 0, 1, 0); t.Text = text.." : "..val
    end
    
    s.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local move; move = RunService.RenderStepped:Connect(UpdateSlider)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then move:Disconnect() end
            end)
        end
    end)
    return function(v) bar.Size = UDim2.new((v-min)/(max-min), 0, 1, 0); t.Text = text.." : "..v end
end

-- [기능 생성]
CreateToggle("Silent Aim (Cross-Platform)", "SilentAim")
CreateToggle("Wallbang", "Wallbang")
CreateToggle("ESP Highlight", "ESP")
CreateToggle("Fly (Mobile Compatible)", "Fly")
CreateSlider("Fly Speed", "FlySpeed", 10, 300)
local updateJump = CreateSlider("Jump Power", "JumpPower", 50, 500)

-- RESET 버튼 (모바일에서 꼬였을 때 대비)
local Rb = Instance.new("TextButton", Container); Rb.Size = UDim2.new(1, 0, 0, 45); Rb.BackgroundColor3 = Color3.fromRGB(150, 50, 50); Rb.Text = "RESET ALL STATS"; Rb.TextColor3 = Color3.new(1,1,1); Rb.Font = Enum.Font.CodeBold
Rb.MouseButton1Click:Connect(function()
    _G.Config.JumpPower = 50; _G.Config.FlySpeed = 50; updateJump(50)
end)

-- [[ 통합 핵심 로직 ]] --
local function GetClosestTarget()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            if not _G.Config.TeamCheck or p.Team ~= LocalPlayer.Team then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis or _G.Config.Wallbang then
                    local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if m < dist then target = p; dist = m end
                end
            end
        end
    end
    return target
end

-- 메타테이블 (PC 마우스 & 모바일 타겟팅 통합)
local mt = getrawmetatable(game); local old = mt.__index; setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if _G.Config.SilentAim and (t == Mouse or t:IsA("UserInputService")) and (k == "Hit" or k == "Target") then
        local target = GetClosestTarget()
        if target then
            if k == "Hit" then return target.Character.Head.CFrame end
            if k == "Target" then return target.Character.Head end
        end
    end
    return old(t, k)
end)

-- 이동/비행/점프 루프
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = _G.Config.JumpPower
        if _G.Config.Fly and char:FindFirstChild("HumanoidRootPart") then
            -- 모바일은 이동 방향 패드 값을 읽어오고, PC는 키보드를 읽음
            local moveDir = char.Humanoid.MoveDirection
            char.HumanoidRootPart.Velocity = (moveDir * _G.Config.FlySpeed) + Vector3.new(0, 2, 0) -- 살짝 부유 유지
            char.Humanoid.PlatformStand = true
        else
            char.Humanoid.PlatformStand = false
        end
    end
end)

-- UI 토글 버튼 (모바일용 화면 버튼)
local TglScr = Instance.new("ScreenGui", CoreGui)
local TglBtn = Instance.new("TextButton", TglScr); TglBtn.Size = UDim2.new(0, 60, 0, 60); TglBtn.Position = UDim2.new(0, 20, 0.5, 0); TglBtn.Text = "MENU"; TglBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", TglBtn).CornerRadius = UDim.new(1, 0)
TglBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- ESP 
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("NamelessESP")
            if _G.Config.ESP then
                if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "NamelessESP" end
                hl.FillColor = (p.Team == LocalPlayer.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                hl.Enabled = true
            elseif hl then hl.Enabled = false end
        end
    end
end)
