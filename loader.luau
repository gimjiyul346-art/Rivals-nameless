local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 중복 실행 방지 (실행할 때마다 깨끗하게 새로 고침)
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
if CoreGui:FindFirstChild("NamelessToggle") then CoreGui.NamelessToggle:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

-- 전역 설정 테이블 (모든 기능의 ON/OFF 상태 저장)
_G.Config = {
    SilentAim = false,
    Wallbang = false,
    ESP = false,
    Noclip = false,
    Fly = false,
    WalkSpeed = 16,
    AllSkins = false
}

-- [2] 메인 UI 디자인 (v1 고정 레이아웃)
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

-- 탭 생성 함수
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

-- 토글/슬라이더 생성 유틸리티
local function CreateToggle(parent, text, var, callback)
    local f = Instance.new("TextButton", parent)
    f.Size = UDim2.new(1, -10, 0, 30); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); f.Text = ""
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.BackgroundTransparency = 1
    l.Text = text; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.Font = Enum.Font.Code; l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("Frame", f); b.Size = UDim2.new(0, 16, 0, 16); b.Position = UDim2.new(1, -26, 0.5, -8); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    f.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        b.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
        if callback then callback(_G.Config[var]) end
    end)
end

local function CreateSlider(parent, text, min, max, var)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 40); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 20); l.Text = text .. ": " .. min; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.Font = Enum.Font.Code; l.BackgroundTransparency = 1
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.9, 0, 0, 4); b.Position = UDim2.new(0.05, 0, 0.7, 0); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.Text = ""
    local fill = Instance.new("Frame", b); fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255); fill.BorderSizePixel = 0
    b.MouseButton1Down:Connect(function()
        local m; m = RunService.RenderStepped:Connect(function()
            local p = math.clamp((UserInputService:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(p, 0, 1, 0); local val = math.floor(min + (max - min) * p)
            l.Text = text .. ": " .. val; _G.Config[var] = val
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then m:Disconnect() end
        end)
    end)
end

-- [3] 탭별 기능 배치 (Rage, Main, ESP, Misc, Settings)
local Main = CreateTab("Main")
local Rage = CreateTab("Rage")
local ESPTab = CreateTab("ESP")
local Misc = CreateTab("Misc")
local Settings = CreateTab("Settings")

-- Main
CreateToggle(Main, "Silent Aim", "SilentAim")
CreateToggle(Main, "Wallbang", "Wallbang")

-- Rage
CreateToggle(Rage, "Noclip", "Noclip")
CreateToggle(Rage, "Fly Enabled", "Fly")
CreateSlider(Rage, "WalkSpeed", 16, 500, "WalkSpeed")

-- ESP
CreateToggle(ESPTab, "Box ESP", "ESP")

-- Misc
CreateToggle(Misc, "All Skins Unlock", "AllSkins", function(state)
    -- 로블록스 일반적인 게임 데이터 구조를 타겟팅 (작동 보장용 로직)
    if state then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__index
        mt.__index = newcclosure(function(t, k)
            if _G.Config.AllSkins and (k == "OwnsItem" or k == "HasPass") then return function() return true end end
            return old(t, k)
        end)
        setreadonly(mt, true)
    end
end)

-- [4] 핵심 작동 엔진 (무조건 작동 모드)
local function GetClosest()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis or _G.Config.Wallbang then
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mag < dist then target = p; dist = mag end
            end
        end
    end
    return target
end

-- Silent Aim: 레이캐스트 후킹
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.Config.SilentAim and method == "Raycast" and not checkcaller() then
        local t = GetClosest()
        if t then
            args[2] = (t.Character.Head.Position - args[1]).Unit * 1000
            if _G.Config.Wallbang and args[3] then
                args[3].FilterDescendantsInstances = {t.Character}
                args[3].FilterType = Enum.RaycastFilterType.Include
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- 이동 관련 엔진 루프
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        -- WalkSpeed (CFrame 기반으로 튕김 방지)
        if _G.Config.WalkSpeed > 16 and char.Humanoid.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (char.Humanoid.MoveDirection * (_G.Config.WalkSpeed / 100))
        end
        -- Fly
        if _G.Config.Fly then hrp.Velocity = Vector3.new(0, 2, 0) end
        -- Noclip
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- [5] 메뉴 토글 버튼
local ToggleGui = Instance.new("ScreenGui", CoreGui)
ToggleGui.Name = "NamelessToggle"
local Btn = Instance.new("TextButton", ToggleGui)
Btn.Size = UDim2.new(0, 60, 0, 30); Btn.Position = UDim2.new(0, 10, 0.4, 0)
Btn.Text = "MENU"; Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Btn.TextColor3 = Color3.fromRGB(0, 170, 255); Btn.Draggable = true
Btn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- 초기 탭 설정
UI.Pages["Main"].Visible = true; UI.Tabs["Main"].TextColor3 = Color3.fromRGB(0, 170, 255)
