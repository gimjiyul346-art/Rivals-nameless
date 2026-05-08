-- [[ Nameless hub | v1 - Auto Shoot & 1P Fix Edition ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 가상 마우스 클릭을 위한 변수
local VirtualInputManager = game:GetService("VirtualInputManager")

if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
if CoreGui:FindFirstChild("NamelessToggle") then CoreGui.NamelessToggle:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    Aimbot = false,
    AutoShoot = false, -- 오토 슛 추가
    ESP = false,
    Noclip = false,
    Fly = false,
    WalkSpeed = 16,
    AimbotSmoothness = 0.05 -- 1인칭 대응을 위해 좀 더 즉각적으로 조절
}

-- [UI 구성]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Active = true; MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35); Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "  Nameless hub | v1"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.Code; Title.TextXAlignment = Enum.TextXAlignment.Left

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30); TabBar.Position = UDim2.new(0, 0, 0, 35); TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

local UI = { Tabs = {}, Pages = {} }

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 100, 1, 0); btn.BackgroundTransparency = 1; btn.Text = name:lower(); btn.Font = Enum.Font.Code; btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Size = UDim2.new(1, -10, 1, -80); Page.Position = UDim2.new(0, 5, 0, 75); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2
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
    local f = Instance.new("TextButton", parent); f.Size = UDim2.new(1, -10, 0, 30); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); f.Text = ""
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.BackgroundTransparency = 1
    l.Text = text; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.Font = Enum.Font.Code; l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("Frame", f); b.Size = UDim2.new(0, 16, 0, 16); b.Position = UDim2.new(1, -26, 0.5, -8); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    f.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        b.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
    end)
end

local Main = CreateTab("Main"); local Rage = CreateTab("Rage"); local ESPTab = CreateTab("ESP")

CreateToggle(Main, "Aimbot (1P Fix)", "Aimbot")
CreateToggle(Main, "Auto Shoot (자동 발사)", "AutoShoot")
CreateToggle(Rage, "Noclip", "Noclip")
CreateToggle(Rage, "Fly Enabled", "Fly")
CreateToggle(ESPTab, "Box ESP", "ESP")

-- [[ 엔진 로직 ]] --

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
    -- 1. 에임봇 및 오토슛
    if _G.Config.Aimbot then
        local target = GetClosest()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            -- 1인칭 대응: CFrame을 직접 수정하지 않고 델타만큼 마우스 회전
            local targetPos = target.Character.Head.Position
            local lookAt = CFrame.new(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(lookAt, _G.Config.AimbotSmoothness)

            -- 오토 슛 로직
            if _G.Config.AutoShoot then
                -- 타겟이 조준점 근처에 있는지 확인
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
                local mouseLocation = UserInputService:GetMouseLocation()
                local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
                
                if onScreen and distToCenter < 50 then -- 조준선 근처 50픽셀 이내일 때 발사
                    VirtualInputManager:SendMouseButtonEvent(mouseLocation.X, mouseLocation.Y, 0, true, game, 1)
                    task.wait()
                    VirtualInputManager:SendMouseButtonEvent(mouseLocation.X, mouseLocation.Y, 0, false, game, 1)
                end
            end
        end
    end

    -- 2. ESP
    if _G.Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local esp = p.Character:FindFirstChild("NamelessESP")
                if not esp then
                    esp = Instance.new("BoxHandleAdornment", p.Character)
                    esp.Name = "NamelessESP"; esp.Adornee = p.Character.HumanoidRootPart
                    esp.AlwaysOnTop = true; esp.ZIndex = 10; esp.Transparency = 0.5; esp.Color3 = Color3.fromRGB(0, 170, 255)
                end
                esp.Size = p.Character:GetExtentsSize()
            end
        end
    end
end)

-- 캐릭터 이동
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if _G.Config.Fly then char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) end
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- 메뉴 버튼
local ToggleBtn = Instance.new("ScreenGui", CoreGui)
local Btn = Instance.new("TextButton", ToggleBtn)
Btn.Size = UDim2.new(0, 50, 0, 50); Btn.Position = UDim2.new(0, 10, 0.4, 0); Btn.Text = "Menu"; Btn.Draggable = true
Btn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

UI.Pages["Main"].Visible = true; UI.Tabs["Main"].TextColor3 = Color3.fromRGB(0, 170, 255)
