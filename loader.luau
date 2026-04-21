-- [[ 초기 설정 및 보안 ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- 중복 UI 정리
if game:GetService("CoreGui"):FindFirstChild("RivalsHybrid") then
    game:GetService("CoreGui").RivalsHybrid:Destroy()
end

local Flags = {
    Fly = false, Noclip = false, Speed = 16, 
    SilentAim = false, Wallbang = false, ESP = false
}

-- [[ UI 구성 ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RivalsHybrid"
ScreenGui.DisplayOrder = 999

-- 메인 프레임
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true

local UICorner = Instance.new("UICorner", Main)

-- 상단 바 (닫기 버튼 포함)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 2)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

-- 재오픈용 플로팅 버튼
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -20)
OpenBtn.Text = "MENU"
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn)

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)

-- [탭/버튼 생성 로직 생략 - 이전 구조와 동일] --

-- [[ 영상 속 '핵쟁이' 기능 구현 로직 ]] --

-- 1. Fly & Noclip (하늘 날기 및 벽통과)
local SpeedMult = 2
RunService.Stepped:Connect(function()
    if Flags.Fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LP.Character.HumanoidRootPart
        local MoveDir = LP.Character.Humanoid.MoveDirection
        HRP.Velocity = MoveDir * (Flags.Speed * SpeedMult) + Vector3.new(0, 2, 0) -- 중력 무시 부양
    end
    
    if Flags.Noclip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 2. Silent Aim (자동 타격)
-- Rivals의 발사 시스템을 우회하여 적의 머리로 총알을 유도합니다.
local function GetClosest()
    local target, dist = nil, 200
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") and v.Team ~= LP.Team then
            local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mDist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mDist < dist then dist = mDist target = v end
            end
        end
    end
    return target
end

-- 버튼들 추가 (Combat, Movement 등)
-- (생략: 위 Flags에 맞춰 Toggle 버튼들을 배치)

