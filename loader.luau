-- [[ 초기 설정 및 안티치트 보안 ]] --
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- 기존 UI 제거
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "KiciaSolixMenu" then v:Destroy() end
end

-- 설정값 저장소
local Config = {
    Aimbot = { Enabled = false, Smoothness = 0.4, TargetPart = "Head", TeamCheck = true, FOV = 100 },
    Visuals = { ESP = false, Tracers = false, Box = false },
    Misc = { WalkSpeed = 16, JumpPower = 50 }
}

-- [[ UI 생성 시작 ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "KiciaSolixMenu"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0

-- 둥근 모서리 및 그림자 (Kicia 스타일)
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 8)

-- 사이드바 (탭 메뉴 전용)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BorderSizePixel = 0
local SidebarCorner = Instance.new("UICorner", Sidebar)

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0

local UIList = Instance.new("UIListLayout", TabContainer)
UIList.Padding = UDim.new(0, 5)

-- 메인 컨텐츠 영역
local PageContainer = Instance.new("Frame", Main)
PageContainer.Size = UDim2.new(1, -130, 1, -10)
PageContainer.Position = UDim2.new(0, 125, 0, 5)
PageContainer.BackgroundTransparency = 1

-- [[ 기능 로직: 에임봇 (Solix 기반) ]] --
local function getClosestPlayer()
    local target = nil
    local dist = Config.Aimbot.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Config.Aimbot.TargetPart) then
            if Config.Aimbot.TeamCheck and v.Team == LocalPlayer.Team then continue end
            local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character[Config.Aimbot.TargetPart].Position)
            if vis then
                local mouseDist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mouseDist < dist then
                    dist = mouseDist
                    target = v
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if Config.Aimbot.Enabled then
        local target = getClosestPlayer()
        if target and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local pos = workspace.CurrentCamera:WorldToViewportPoint(target.Character[Config.Aimbot.TargetPart].Position)
            local mousePos = UserInputService:GetMouseLocation()
            -- mousemoverel은 메모리 변조를 하지 않아 밴 위험이 적습니다.
            mousemoverel((pos.X - mousePos.X) * Config.Aimbot.Smoothness, (pos.Y - mousePos.Y) * Config.Aimbot.Smoothness)
        end
    end
    
    -- Misc 기능 적용
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Misc.WalkSpeed
    end
end)

-- [[ UI 구성 요소 생성 함수 ]] --
local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding = UDim.new(0, 8)
    
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(1, -10, 0, 30)
    TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.Code
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    
    Pages[name] = Page
    return Page
end

local function CreateToggle(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = text .. ": OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    Btn.Font = Enum.Font.Code
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. ": " .. (state and "ON" or "OFF")
        Btn.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(state)
    end)
end

-- [[ 메뉴 탭 구성 ]] --
local MainTab = CreatePage("COMBAT")
local VisualTab = CreatePage("VISUALS")
local MiscTab = CreatePage("MISC")

-- 컴뱃 설정
CreateToggle(MainTab, "Aimbot", function(v) Config.Aimbot.Enabled = v end)
CreateToggle(MainTab, "Team Check", function(v) Config.Aimbot.TeamCheck = v end)

-- 비주얼 설정
CreateToggle(VisualTab, "Player ESP", function(v) Config.Visuals.ESP = v end)

-- 기타 설정
CreateToggle(MiscTab, "Speed Hack", function(v) 
    Config.Misc.WalkSpeed = v and 50 or 16 
end)

-- 초기 페이지 설정
Pages["COMBAT"].Visible = true

-- UI 드래그 기능 (보안 버전)
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- 토글 단축키: RightShift
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("Kicia-Solix Hybrid Loaded!")

