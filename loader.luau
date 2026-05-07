local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] UI 초기화
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    SilentAim = false,
    Wallbang = false,
    ESP = false,
    WalkSpeed = 16,
    Emote = false, -- 에모트 온/오프
    AnimSpeed = 99999
}

-- 애니메이션 로직 준비
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://92281817840531"

local function playCustomAnim(character)
    if not _G.Config.Emote then return end
    local Hum = character:FindFirstChildWhichIsA("Humanoid")
    if Hum then
        for _, track in next, Hum:GetPlayingAnimationTracks() do track:Stop() end
        local anim = Hum:LoadAnimation(animation)
        anim.Priority = Enum.AnimationPriority.Action4
        anim:Play()
        anim:AdjustSpeed(_G.Config.AnimSpeed)
        anim.Stopped:Connect(function() 
            if _G.Config.Emote then playCustomAnim(character) end 
        end)
    end
end

-- [2] UI 프레임 및 탭
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Draggable = true; MainFrame.Active = true

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

local UI = { Pages = {} }

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 80, 1, 0); btn.Text = name; btn.BackgroundTransparency = 1
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Size = UDim2.new(1, -10, 1, -40); Page.Position = UDim2.new(0, 5, 0, 35)
    Page.Visible = false; Page.BackgroundTransparency = 1
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(UI.Pages) do p.Visible = false end
        Page.Visible = true
    end)
    UI.Pages[name] = Page
    return Page
end

local function CreateToggle(parent, text, var, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30); btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        btn.Text = text .. ": " .. (_G.Config[var] and "ON" or "OFF")
        if callback then callback(_G.Config[var]) end
    end)
end

-- [3] 기능 배치
local Main = CreateTab("Main")
local EmoteTab = CreateTab("Emote")
local ESPTab = CreateTab("ESP")

CreateToggle(Main, "Silent Aim (Bullet Fix)", "SilentAim")
CreateToggle(Main, "Wallbang", "Wallbang")

-- 에모트 토글
CreateToggle(EmoteTab, "Enable Custom Emote", "Emote", function(state)
    if state and LocalPlayer.Character then
        playCustomAnim(LocalPlayer.Character)
    else
        local Hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Hum then for _, v in next, Hum:GetPlayingAnimationTracks() do v:Stop() end end
    end
end)

CreateToggle(ESPTab, "Box ESP", "ESP")

-- [4] Silent Aim 엔진 (카메라 고정 없음 - 총알만 유도)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.Config.SilentAim and method == "Raycast" then
        local target = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis or _G.Config.Wallbang then
                    local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if m < dist then target = p; dist = m end
                end
            end
        end
        if target then
            args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
            return old(self, unpack(args))
        end
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- ESP 및 이동
RunService.RenderStepped:Connect(function()
    if _G.Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", p.Character).FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

UI.Pages["Main"].Visible = true
