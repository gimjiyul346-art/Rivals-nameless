-- [[ 1. 핵심 엔진 및 라이브러리 로드 ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- 중복 실행 방지
if game:GetService("CoreGui"):FindFirstChild("KiciaFullVersion") then
    game:GetService("CoreGui").KiciaFullVersion:Destroy()
end

-- 설정값 (모든 기능 변수)
_G.Settings = {
    Aimbot = false, SilentAim = false, Wallbang = false, AutoShoot = false,
    Fly = false, Noclip = false, Speed = 16, Jump = 50,
    ESP = false, SkinChanger = false, FOV = 150
}

-- [[ 2. UI 메인 프레임 디자인 ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "KiciaFullVersion"
ScreenGui.DisplayOrder = 999

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 380) -- 기능을 다 담기 위해 크기를 키웠습니다.
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)

-- 상단바 (닫기 버튼)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- 사이드바 (카테고리)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

-- 페이지 컨테이너 (스크롤 가능)
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -150, 1, -50)
Pages.Position = UDim2.new(0, 145, 0, 45)
Pages.BackgroundTransparency = 1

-- [[ 3. 기능 추가 함수 (코드 길어짐의 주범) ]] --
local function CreatePage(name, offset)
    local Page = Instance.new("ScrollingFrame", Pages)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 8)

    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Size = UDim2.new(1, -10, 0, 40)
    Tab.Position = UDim2.new(0, 5, 0, offset)
    Tab.Text = name
    Tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Tab.TextColor3 = Color3.new(1, 1, 1)
    Tab.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)
    return Page
end

local function AddToggle(parent, text, flag)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Text = text .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(function()
        _G.Settings[flag] = not _G.Settings[flag]
        b.Text = text .. ": " .. (_G.Settings[flag] and "ON" or "OFF")
        b.BackgroundColor3 = _G.Settings[flag] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35)
    end)
end

-- 탭 구성
local Combat = CreatePage("COMBAT", 10)
local Movement = CreatePage("MOVEMENT", 60)
local Visuals = CreatePage("VISUALS", 110)
local Misc = CreatePage("MISC", 160)

-- 기능 배치
AddToggle(Combat, "Silent Aim", "SilentAim")
AddToggle(Combat, "Aimbot", "Aimbot")
AddToggle(Combat, "Wallbang", "Wallbang")
AddToggle(Combat, "Auto Shoot", "AutoShoot")

AddToggle(Movement, "Fly (핵쟁이 비행)", "Fly")
AddToggle(Movement, "Noclip", "Noclip")

AddToggle(Visuals, "Player ESP", "ESP")
AddToggle(Visuals, "Unlock Skins", "SkinChanger")

-- [[ 4. 실제 작동 엔진 (영상 속 그 기능들) ]] --
local function GetTarget()
    local target, dist = nil, _G.Settings.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") and v.Team ~= LP.Team then
            local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mDist < dist then dist = mDist target = v end
            end
        end
    end
    return target
end

-- 무한 루프 감시 엔진
RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        -- Fly & Noclip
        if _G.Settings.Fly then
            LP.Character.HumanoidRootPart.Velocity = LP.Character.Humanoid.MoveDirection * _G.Settings.Speed + Vector3.new(0, 2, 0)
        end
        if _G.Settings.Noclip then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

Combat.Visible = true
print("Kicia Full Hybrid Loaded!")

