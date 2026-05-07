-- [1] Solix Hub 핵심 참조 방식 (그대로 가져옴)
local function cloneref(o) return o end
local CoreGui = cloneref(game:GetService("CoreGui"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local Lighting = cloneref(game:GetService("Lighting"))
local Workspace = cloneref(game:GetService("Workspace"))
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 중복 실행 방지
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end

-- [2] 기능 설정
getgenv().Config = {
    SilentAim = false,
    Wallbang = false,
    Fly = false,
    WalkSpeed = 16,
    InfJump = false,
    ESP = false,
    Emote = false,
    AnimSpeed = 99999
}

-- [3] UI 생성 (사진의 Nameless v1 디자인 재현)
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Draggable = true; MainFrame.Active = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "  Nameless hub | v1 (Solix Engine)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code; Title.TextXAlignment = Enum.TextXAlignment.Left

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30); TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local Layout = Instance.new("UIListLayout", TabBar); Layout.FillDirection = Enum.FillDirection.Horizontal

local Pages = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 100, 1, 0); btn.BackgroundTransparency = 1
    btn.Text = name:upper(); btn.Font = Enum.Font.Code; btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Size = UDim2.new(1, -10, 1, -80); Page.Position = UDim2.new(0, 5, 0, 75)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    Pages[name] = Page
    return Page
end

local function CreateToggle(parent, text, var)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = text .. ": OFF"; b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        b.Text = text .. ": " .. (getgenv().Config[var] and "ON" or "OFF")
        b.TextColor3 = getgenv().Config[var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(200, 200, 200)
    end)
end

-- 탭 생성
local MainTab = CreateTab("Main")
local RageTab = CreateTab("Rage")
local ESPTab = CreateTab("ESP")
local MiscTab = CreateTab("Misc")

CreateToggle(MainTab, "Silent Aim", "SilentAim")
CreateToggle(MainTab, "Wallbang", "Wallbang")
CreateToggle(RageTab, "Fly Mode", "Fly")
CreateToggle(ESPTab, "Box ESP", "ESP")
CreateToggle(MiscTab, "Infinite Jump", "InfJump")
CreateToggle(MiscTab, "Custom Emote", "Emote")

-- [4] Solix Hub 스타일의 핵심 로직 (그대로 이식)
local function GetClosest()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis or getgenv().Config.Wallbang then
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mag < dist then target = p; dist = mag end
            end
        end
    end
    return target
end

-- Silent Aim 엔진 (NameCall Hook)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if getgenv().Config.SilentAim and method == "Raycast" and not checkcaller() then
        local t = GetClosest()
        if t then
            args[2] = (t.Character.Head.Position - args[1]).Unit * 1000
            return old(self, unpack(args))
        end
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- 애니메이션 로직
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://92281817840531"

-- 무한 루프 처리 (Solix 스타일)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        -- Fly
        if getgenv().Config.Fly and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0)
        end
        -- Emote (99999 속도)
        if getgenv().Config.Emote then
            local hum = char:FindFirstChild("Humanoid")
            if hum and not hum:FindFirstChild("EmotePlaying") then
                local tag = Instance.new("BoolValue", hum); tag.Name = "EmotePlaying"
                local track = hum:LoadAnimation(animation)
                track.Priority = Enum.AnimationPriority.Action4
                track:Play(); track:AdjustSpeed(getgenv().Config.AnimSpeed)
                track.Stopped:Connect(function() tag:Destroy() end)
            end
        end
    end
    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("Highlight")
            if getgenv().Config.ESP then
                if not hl then Instance.new("Highlight", p.Character).FillColor = Color3.fromRGB(255, 0, 0) end
            elseif hl then hl:Destroy() end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if getgenv().Config.InfJump and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

Pages["Main"].Visible = true
