-- [[ Nameless hub | v3 - Wallbang, Speed, Void Proof & Silent Aim Fix ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    SilentAim = false,
    Wallbang = false,
    TeamCheck = true,
    ESP = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    VoidProof = false
}

-- [UI 생성 로직]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0; MainFrame.Active = true; MainFrame.Draggable = true

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 40); TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal

local UI = { Tabs = {}, Pages = {} }

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 125, 1, 0); btn.BackgroundTransparency = 1
    btn.Text = name:upper(); btn.Font = Enum.Font.Code; btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    local Page = Instance.new("ScrollingFrame", MainFrame)
    Page.Size = UDim2.new(1, -20, 1, -60); Page.Position = UDim2.new(0, 10, 0, 50)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(UI.Pages) do p.Visible = false end
        for _, t in pairs(UI.Tabs) do t.TextColor3 = Color3.fromRGB(150, 150, 150) end
        Page.Visible = true; btn.TextColor3 = Color3.fromRGB(0, 255, 150)
    end)
    UI.Tabs[name] = btn; UI.Pages[name] = Page
    return Page
end

local function CreateToggle(parent, text, var)
    local f = Instance.new("TextButton", parent); f.Size = UDim2.new(1, 0, 0, 40); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); f.Text = "  "..text
    f.TextColor3 = Color3.new(1,1,1); f.TextXAlignment = Enum.TextXAlignment.Left; f.Font = Enum.Font.Code; f.AutoButtonColor = false
    local b = Instance.new("Frame", f); b.Size = UDim2.new(0, 12, 1, 0); b.Position = UDim2.new(1, -12, 0, 0); b.BackgroundColor3 = Color3.fromRGB(50, 50, 50); b.BorderSizePixel = 0
    f.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        b.BackgroundColor3 = _G.Config[var] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)
    end)
end

local function CreateSlider(parent, text, var, min, max)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 50); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0, 20); t.Text = text.." : ".._G.Config[var]; t.TextColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 1; t.Font = Enum.Font.Code
    local s = Instance.new("TextButton", f); s.Size = UDim2.new(1, 0, 0, 10); s.Position = UDim2.new(0, 0, 0, 25); s.BackgroundColor3 = Color3.fromRGB(40,40,40); s.Text = ""
    local bar = Instance.new("Frame", s); bar.Size = UDim2.new((_G.Config[var]-min)/(max-min), 0, 1, 0); bar.BackgroundColor3 = Color3.fromRGB(0, 255, 150); bar.BorderSizePixel = 0
    s.MouseButton1Down:Connect(function()
        local move = RunService.RenderStepped:Connect(function()
            local mousePos = UserInputService:GetMouseLocation().X
            local relPos = math.clamp((mousePos - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (relPos * (max - min)))
            _G.Config[var] = val
            bar.Size = UDim2.new(relPos, 0, 1, 0)
            t.Text = text.." : "..val
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
        end)
    end)
end

-- [탭 설정]
local MainTab = CreateTab("Main")
local VisualTab = CreateTab("Visuals")
local MiscTab = CreateTab("Misc")

CreateToggle(MainTab, "Silent Aim (Target Closest)", "SilentAim")
CreateToggle(MainTab, "Wallbang (Shoot through walls)", "Wallbang")
CreateToggle(MainTab, "Team Check", "TeamCheck")

CreateToggle(VisualTab, "ESP Highlight", "ESP")

CreateToggle(MiscTab, "Fly (WASD)", "Fly")
CreateSlider(MiscTab, "Fly Speed", "FlySpeed", 10, 200)
CreateToggle(MiscTab, "Noclip", "Noclip")
CreateToggle(MiscTab, "Void Proof (Anti-Fall)", "VoidProof")

-- [[ 핵심 기능 ]] --

-- 1. Wallbang & Silent Aim Fix
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if _G.Config.Wallbang and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        -- 벽 충돌 판정 레이캐스트를 조작하여 모든 벽을 통과하도록 수정
        return oldNamecall(self, table.unpack(args))
    end
    return oldNamecall(self, ...)
end)

-- 2. Fly & Void Proof
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        -- Void Proof
        if _G.Config.VoidProof and hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
            hrp.Velocity = Vector3.new(0,0,0)
        end
        
        -- Fly
        if _G.Config.Fly then
            local move = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
            hrp.Velocity = move.Unit * _G.Config.FlySpeed
            hrp.Anchored = false
            char.Humanoid.PlatformStand = true
        else
            char.Humanoid.PlatformStand = false
        end
        
        -- Noclip
        if _G.Config.Noclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- 3. ESP & Silent Aim Target
RunService.RenderStepped:Connect(function()
    local closest, dist = nil, 2000
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            -- ESP
            local hl = p.Character:FindFirstChild("NamelessESP")
            if _G.Config.ESP then
                if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "NamelessESP" end
                hl.FillColor = (p.Team == LocalPlayer.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                hl.Enabled = true
            elseif hl then hl.Enabled = false end
            
            -- Target Tracking
            if _G.Config.SilentAim and (not _G.Config.TeamCheck or p.Team ~= LocalPlayer.Team) then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mag < dist then closest = p; dist = mag end
            end
        end
    end
    
    if _G.Config.SilentAim and closest and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
    end
end)

-- UI Toggle
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.LeftShift then MainFrame.Visible = not MainFrame.Visible end
end)

UI.Pages["Main"].Visible = true; UI.Tabs["Main"].TextColor3 = Color3.fromRGB(0, 255, 150)

