-- [[ Nameless hub | v1 Final Mobile ]] --
local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- 기존 UI 제거
if game:GetService("CoreGui"):FindFirstChild("NamelessUI") then game:GetService("CoreGui").NamelessUI:Destroy() end

getgenv().Config = {
    SilentAim = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    Fly = false,
    NoClip = false,
    ESP = false
}

-- [[ UI 구성 (모바일 최적화) ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "NamelessUI"

-- 플로팅 버튼 (메뉴 끄기/켜기)
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 45, 0, 45)
Toggle.Position = UDim2.new(0, 150, 0, 10)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Toggle.Text = "N"
Toggle.Draggable = true
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 250)
Main.Position = UDim2.new(0.5, -175, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- 탭 구성 (Main, Rage, Character, Misc, Setting)
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(0, 80, 1, 0)
Tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local TabList = Instance.new("UIListLayout", Tabs)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -90, 1, -10)
Container.Position = UDim2.new(0, 85, 0, 5)
Container.BackgroundTransparency = 1

local function NewTab(name)
    local b = Instance.new("TextButton", Tabs)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(1,1,1)
    local p = Instance.new("ScrollingFrame", Container)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,2,0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        p.Visible = true
    end)
    return p
end

local TMain = NewTab("Main")
local TRage = NewTab("Rage")
local TChar = NewTab("Char")
local TMisc = NewTab("Misc")

local function AddToggle(parent, text, var)
    local t = Instance.new("TextButton", parent)
    t.Size = UDim2.new(1, -5, 0, 35)
    t.BackgroundColor3 = Color3.fromRGB(30,30,30); t.Text = text .. ": OFF"; t.TextColor3 = Color3.new(1,1,1)
    t.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        t.Text = text .. ": " .. (getgenv().Config[var] and "ON" or "OFF")
        t.TextColor3 = getgenv().Config[var] and Color3.fromRGB(0, 170, 255) or Color3.new(1,1,1)
    end)
end

-- 기능 배치
AddToggle(TMain, "Silent Aim", "SilentAim")
AddToggle(TRage, "Fly Mode", "Fly")
AddToggle(TChar, "Infinite Jump", "InfJump")
AddToggle(TChar, "No Clip", "NoClip")
AddToggle(TMisc, "Player ESP", "ESP")

-- [[ 핵심 엔진 (작동 보장) ]] --
local function GetTarget()
    local target, maxDist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < maxDist then target = v; maxDist = mag end
            end
        end
    end
    return target
end

-- Silent Aim: 모든 총알의 방향을 강제로 타겟으로 고정
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if getgenv().Config.SilentAim and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local t = GetTarget()
        if t and t.Character then
            if method == "Raycast" then
                args[2] = (t.Character.HumanoidRootPart.Position - args[1]).Unit * 1000
            else
                args[1] = Ray.new(Camera.CFrame.Position, (t.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Unit * 1000)
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- Character & Misc
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if getgenv().Config.Fly then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 5, 0)
        end
        if getgenv().Config.NoClip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().Config.InfJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

TMain.Visible = true
print("Nameless hub | v1 Loaded")
