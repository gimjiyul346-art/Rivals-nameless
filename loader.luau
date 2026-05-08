local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 중복 실행 방지
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
if CoreGui:FindFirstChild("NamelessToggle") then CoreGui.NamelessToggle:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

-- 설정값 저장용
_G.Config = {
    Aimbot = false, -- 에임봇으로 교체
    ESP = false,
    Noclip = false,
    Fly = false,
    WalkSpeed = 16,
    AimbotSmoothness = 0.1 -- 에임봇 부드러움 조절
}

-- [2] UI 디자인
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Draggable = true; MainFrame.Active = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "  Nameless hub | v1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code; Title.TextXAlignment = Enum.TextXAlignment.Left

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

local UI = { Tabs = {}, Pages = {} }

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name:lower(); btn.Font = Enum.Font.Code; btn.TextColor3 = Color3.fromRGB(150, 150, 150)

    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Size = UDim2.new(1, -10, 1, -80)
    Page.Position = UDim2.new(0, 5, 0, 75)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(UI.Pages) do p.Visible = false end
        for _, t in pairs(UI.Tabs) do t.TextColor3 = Color3.fromRGB(150, 150, 150) end
        Page.Visible = true; btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    end)
    UI.Tabs[name] = btn; UI.Pages[name] = Page
    return Page
end

local function CreateToggle(parent, text, var)
    local f = Instance.new("TextButton", parent)
    f.Size = UDim2.new(1, -10, 0, 30); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); f.Text = ""
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.BackgroundTransparency = 1
    l.Text = text; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.Font = Enum.Font.Code; l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("Frame", f); b.Size = UDim2.new(0, 16, 0, 16); b.Position = UDim2.new(1, -26, 0.5, -8); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    f.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        b.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
    end)
end

local function CreateSlider(parent, text, min, max, var)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 40); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 20); l.Text = text .. ": " .. _G.Config[var]; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.Font = Enum.Font.Code; l.BackgroundTransparency = 1
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.9, 0, 0, 4); b.Position = UDim2.new(0.05, 0, 0.7, 0); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.Text = ""
    local fill = Instance.new("Frame", b); fill.Size = UDim2.new((_G.Config[var]-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255); fill.BorderSizePixel = 0
    b.MouseButton1Down:Connect(function()
        local m; m = RunService.RenderStepped:Connect(function()
            local p = math.clamp((UserInputService:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(p, 0, 1, 0); local val = math.floor(min + (max - min) * p)
            l.Text = text .. ": " .. val; _G.Config[var] = val
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then m:Disconnect() end
        end)
    end)
end

-- [3] 기능 배치
local Main = CreateTab("Main")
local Rage = CreateTab("Rage")
local ESPTab = CreateTab("ESP")
local Settings = CreateTab("Settings")

CreateToggle(Main, "Aimbot", "Aimbot") -- 사일런트 에임에서 교체
CreateToggle(Rage, "Noclip", "Noclip")
CreateToggle(Rage, "Fly Enabled", "Fly")
CreateSlider(Rage, "WalkSpeed", 16, 500, "WalkSpeed")
CreateToggle(ESPTab, "Box ESP", "ESP")

-- [4] 기능 엔진

-- 타겟팅 로직
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

-- ESP 엔진
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local esp = p.Character:FindFirstChild("NamelessESP")
            
            if _G.Config.ESP then
                if not esp then
                    esp = Instance.new("BoxHandleAdornment")
                    esp.Name = "NamelessESP"
                    esp.Parent = p.Character
                    esp.Adornee = hrp
                    esp.AlwaysOnTop = true
                    esp.ZIndex = 10
                    esp.Transparency = 0.5
                    esp.Color3 = Color3.fromRGB(0, 170, 255)
                end
                -- 플레이어 크기에 맞춰 박스 크기 자동 조절
                esp.Size = p.Character:GetExtentsSize()
            else
                if esp then esp:Destroy() end
            end
        end
    end
end)

-- 에임봇 엔진 (적을 직접 따라가는 방식)
RunService.RenderStepped:Connect(function()
    if _G.Config.Aimbot then
        local target = GetClosest()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            -- Tween을 사용하여 부드럽게 카메라를 타겟 방향으로 회전
            local lookAt = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            Camera.CFrame = Camera.CFrame:Lerp(lookAt, _G.Config.AimbotSmoothness)
        end
    end
end)

-- 이동 기능 엔진
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if _G.Config.WalkSpeed > 16 and char.Humanoid.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (char.Humanoid.MoveDirection * (_G.Config.WalkSpeed / 100))
        end
        if _G.Config.Fly then hrp.Velocity = Vector3.new(0, 2, 0) end
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- [5] 메뉴 버튼
local ToggleBtn = Instance.new("ScreenGui", CoreGui)
ToggleBtn.Name = "NamelessToggle"
local Btn = Instance.new("TextButton", ToggleBtn)
Btn.Size = UDim2.new(0, 50, 0, 50); Btn.Position = UDim2.new(0, 10, 0.4, 0)
Btn.Text = "Menu"; Btn.Draggable = true
Btn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

UI.Pages["Main"].Visible = true; UI.Tabs["Main"].TextColor3 = Color3.fromRGB(0, 170, 255)
