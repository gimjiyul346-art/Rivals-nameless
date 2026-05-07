-- [1] 초기화 및 클론 참조 (Solix 로직 적용)
local function cloneref(o) return o end
local CoreGui = cloneref(game:GetService("CoreGui"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 중복 제거
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end

-- [2] 설정값 (전역)
_G.Config = {
    SilentAim = false,
    Wallbang = false,
    Fly = false,
    WalkSpeed = 16,
    Emote = false,
    ESP = false,
    AllSkins = false,
    AnimSpeed = 99999
}

-- [3] UI 생성 (사진 속 Nameless v1 스타일)
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Draggable = true; MainFrame.Active = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "  Nameless hub | Rivals Edition"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code; Title.TextXAlignment = Enum.TextXAlignment.Left

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

local UI = { Pages = {} }

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 100, 1, 0); btn.BackgroundTransparency = 1
    btn.Text = name:upper(); btn.Font = Enum.Font.Code; btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Size = UDim2.new(1, -10, 1, -80); Page.Position = UDim2.new(0, 5, 0, 75)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(UI.Pages) do p.Visible = false end
        Page.Visible = true
    end)
    UI.Pages[name] = Page
    return Page
end

local function CreateToggle(parent, text, var)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = text .. ": OFF"; b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        b.Text = text .. ": " .. (_G.Config[var] and "ON" or "OFF")
        b.TextColor3 = _G.Config[var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(200, 200, 200)
    end)
end

-- [4] 탭 구성
local MainTab = CreateTab("Main")
local RageTab = CreateTab("Rage")
local VisualTab = CreateTab("Visuals")
local MiscTab = CreateTab("Misc")

-- Main: 전투 기능
CreateToggle(MainTab, "Silent Aim", "SilentAim")
CreateToggle(MainTab, "Wallbang", "Wallbang")

-- Rage: 강력한 이동
CreateToggle(RageTab, "Fly Mode", "Fly")
CreateToggle(RageTab, "Infinite Jump", "InfJump")

-- Visuals: 시각 기능
CreateToggle(VisualTab, "Box ESP", "ESP")

-- Misc: 기타 기능
CreateToggle(MiscTab, "Custom Emote", "Emote")
CreateToggle(MiscTab, "Skin Changer", "AllSkins")

-- [5] 핵심 엔진 로직 (Solix + Silent Aim 통합)
local function GetTarget()
    local t, d = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis or _G.Config.Wallbang then
                local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if m < d then t = p; d = m end
            end
        end
    end
    return t
end

-- Silent Aim: Raycast 변조
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.Config.SilentAim and method == "Raycast" and not checkcaller() then
        local target = GetTarget()
        if target then
            args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
            return old(self, unpack(args))
        end
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- 애니메이션 설정
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://92281817840531"

-- 루프 엔진 (ESP, Fly, Emote)
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        -- Fly & Move
        if _G.Config.Fly and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(0, 1, 0) -- 공중 부양
        end
        
        -- Emote 로직
        if _G.Config.Emote then
            local hum = char:FindFirstChild("Humanoid")
            if hum and not hum:FindFirstChild("EmotePlaying") then
                local tag = Instance.new("BoolValue", hum); tag.Name = "EmotePlaying"
                local track = hum:LoadAnimation(anim)
                track.Priority = Enum.AnimationPriority.Action4
                track:Play(); track:AdjustSpeed(_G.Config.AnimSpeed)
                track.Stopped:Connect(function() tag:Destroy() end)
            end
        end
    end

    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("Highlight")
            if _G.Config.ESP then
                if not hl then Instance.new("Highlight", p.Character).FillColor = Color3.fromRGB(255, 0, 0) end
            elseif hl then hl:Destroy() end
        end
    end
end)

-- 무한 점프
UserInputService.JumpRequest:Connect(function()
    if _G.Config.InfJump and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

UI.Pages["Main"].Visible = true

