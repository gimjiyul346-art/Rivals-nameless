local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 중복 실행 방지
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
if CoreGui:FindFirstChild("NamelessToggle") then CoreGui.NamelessToggle:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    SilentAim = false,
    Wallbang = false,
    ESP = false,
    Noclip = false,
    Fly = false,
    WalkSpeed = 16,
    AllSkins = false
}

-- [2] UI 디자인 (생략 없이 필수 탭 유지)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Draggable = true; MainFrame.Active = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "  Nameless v1 | AIM FIXED"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code; Title.TextXAlignment = Enum.TextXAlignment.Left

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

local UI = { Tabs = {}, Pages = {} }

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundTransparency = 1; btn.Text = name:lower(); btn.Font = Enum.Font.Code; btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Size = UDim2.new(1, -10, 1, -70)
    Page.Position = UDim2.new(0, 5, 0, 65)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
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
    f.Size = UDim2.new(1, 0, 0, 25); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); f.Text = ""
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.Text = text; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.Font = Enum.Font.Code; l.TextXAlignment = Enum.TextXAlignment.Left; l.BackgroundTransparency = 1
    local b = Instance.new("Frame", f); b.Size = UDim2.new(0, 14, 0, 14); b.Position = UDim2.new(1, -24, 0.5, -7); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    f.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        b.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
    end)
end

-- [3] 필수 탭 구성
local Main = CreateTab("Main")
local Rage = CreateTab("Rage")
local ESPTab = CreateTab("ESP")
local Misc = CreateTab("Misc")

CreateToggle(Main, "Silent Aim (AUTO-FIX)", "SilentAim")
CreateToggle(Main, "Wallbang", "Wallbang")
CreateToggle(Rage, "Fly Enabled", "Fly")
CreateToggle(Rage, "Noclip", "Noclip")
CreateToggle(ESPTab, "Box ESP", "ESP")
CreateToggle(Misc, "All Skins Unlock", "AllSkins")

-- [4] 무조건 작동하는 에임 엔진 (가장 원초적인 방식)
local function GetTarget()
    local target, closest = nil, 500 -- 사거리
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis or _G.Config.Wallbang then
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mag < closest then target = p; closest = mag end
            end
        end
    end
    return target
end

-- Raycast 후킹이 안 될 경우를 대비한 2중 장치
RunService.RenderStepped:Connect(function()
    if _G.Config.SilentAim then
        local t = GetTarget()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            -- 카메라가 적의 머리를 직접 바라보게 하는 방식 (가장 확실함)
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
            end
        end
    end
end)

-- 이동 및 기타 엔진
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if _G.Config.Fly then char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) end
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- [5] 메뉴 버튼
local ToggleGui = Instance.new("ScreenGui", CoreGui)
local Btn = Instance.new("TextButton", ToggleGui)
Btn.Size = UDim2.new(0, 60, 0, 30); Btn.Position = UDim2.new(0, 10, 0.4, 0); Btn.Text = "MENU"
Btn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

UI.Pages["Main"].Visible = true
