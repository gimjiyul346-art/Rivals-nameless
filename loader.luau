-- [[ Nameless hub | v8 - Full Feature Restore & Multi-Platform Fix ]] --
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

-- [UI 구성]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 460, 0, 480)
Main.Position = UDim2.new(0.5, -230, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 4
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 8)

-- [공용 컴포넌트]
local function CreateToggle(text, var)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 42); b.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    b.Text = "  "..text; b.TextColor3 = Color3.new(0.7, 0.7, 0.7); b.Font = Enum.Font.Code; b.TextXAlignment = "Left"
    local ind = Instance.new("Frame", b); ind.Size = UDim2.new(0, 5, 1, 0); ind.Position = UDim2.new(1, -5, 0, 0); ind.BackgroundColor3 = Color3.fromRGB(50, 50, 50); ind.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        ind.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)
        b.TextColor3 = _G.Config[var] and Color3.new(1, 1, 1) or Color3.new(0.7, 0.7, 0.7)
    end)
end

local function CreateSlider(text, var, min, max)
    local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, 0, 0, 60); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0, 25); t.Text = text.." : ".._G.Config[var]; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.Code; t.BackgroundTransparency = 1
    local s = Instance.new("TextButton", f); s.Size = UDim2.new(1, -10, 0, 8); s.Position = UDim2.new(0, 5, 0, 35); s.BackgroundColor3 = Color3.fromRGB(40, 40, 40); s.Text = ""
    local bar = Instance.new("Frame", s); bar.Size = UDim2.new((_G.Config[var]-min)/(max-min), 0, 1, 0); bar.BackgroundColor3 = Color3.fromRGB(0, 255, 150); bar.BorderSizePixel = 0
    s.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local rel = math.clamp((UserInputService:GetMouseLocation().X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (rel * (max - min)))
            _G.Config[var] = val
            bar.Size = UDim2.new(rel, 0, 1, 0); t.Text = text.." : "..val
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then move:Disconnect() end
        end)
    end)
    return function(v) bar.Size = UDim2.new((v-min)/(max-min), 0, 1, 0); t.Text = text.." : "..v end
end

-- [기능 리스트 복구]
CreateToggle("Silent Aim (Strong)", "SilentAim")
CreateToggle("Wallbang (Pierce)", "Wallbang")
CreateToggle("Team Check", "TeamCheck")
CreateToggle("ESP Highlight", "ESP")
CreateToggle("Fly", "Fly")
CreateSlider("Fly Speed", "FlySpeed", 10, 300)
local updateJump = CreateSlider("Jump Power", "JumpPower", 50, 500
