-- [[ Nameless hub | v1 - Mobile Performance Edition ]] --
local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 기존 UI 제거 및 설정 초기화
if game:GetService("CoreGui"):FindFirstChild("NamelessUI") then game:GetService("CoreGui").NamelessUI:Destroy() end

getgenv().Config = {
    SilentAim = false,
    Fly = false,
    InfJump = false,
    NoClip = false,
    ESP = false,
    TargetPart = "HumanoidRootPart"
}

-- [[ UI 구성: 사진의 어두운 테마와 레이아웃 적용 ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "NamelessUI"

-- 열기/닫기용 파란색 원형 버튼
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.Text = "N"; ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.Font = Enum.Font.Code
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- 메인 프레임 (사진의 좌측 탭 + 우측 기능 구조)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 420, 0, 280)
Main.Position = UDim2.new(0.5, -210, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true

local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(0, 110, 1, 0)
TabHolder.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
local TabList = Instance.new("UIListLayout", TabHolder)

local PageHolder = Instance.new("Frame", Main)
PageHolder.Size = UDim2.new(1, -120, 1, -10)
PageHolder.Position = UDim2.new(0, 115, 0, 5)
PageHolder.BackgroundTransparency = 1

ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- 탭 생성 함수
local function CreateTab(name)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Text = name; btn.TextColor3 = Color3.new(0.8, 0.8, 0.8); btn.Font = Enum.Font.Code
    
    local page = Instance.new("ScrollingFrame", PageHolder)
    page.Size = UDim2.new(1, 0, 1, 0); page.Visible = false; page.BackgroundTransparency = 1
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PageHolder:GetChildren()) do p.Visible = false end
        page.Visible = true
    end)
    return page
end

-- 기능 토글 함수
local function AddToggle(parent, text, var)
    local t = Instance.new("TextButton", parent)
    t.Size = UDim2.new(1, -5, 0, 45)
    t.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    t.Text = text .. ": OFF"; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.Code
    t.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        t.Text = text .. ": " .. (getgenv().Config[var] and "ON" or "OFF")
        t.TextColor3 = getgenv().Config[var] and Color3.fromRGB(0, 170, 255) or Color3.new(1,1,1)
    end)
end

-- 탭 구성 (요청하신 순서대로)
local MainTab = CreateTab("Main")
local RageTab = CreateTab("Rage")
local CharTab = CreateTab("Character")
local MiscTab = CreateTab("Misc")
local SettTab = CreateTab("Settings")

-- 기능 배치
AddToggle(MainTab, "Magic Silent Aim", "SilentAim")
AddToggle(RageTab, "Auto Fly", "Fly")
AddToggle(CharTab, "Infinite Jump", "InfJump")
AddToggle(CharTab, "No Clip", "NoClip")
AddToggle(MiscTab, "Player ESP", "ESP")

-- [[ 핵심: 카메라 고정 없는 Silent Aim 엔진 ]] --
local function GetClosest()
    local target, dist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().Config.TargetPart) then
            local pos, vis = Camera:WorldToViewportPoint(v.Character[getgenv().Config.TargetPart].Position)
            if vis then
                local mPos = game:GetService("UserInputService"):GetMouseLocation()
                local mag = (Vector2.new(pos.X, pos.Y) - mPos).Magnitude
                if mag < dist then target = v; dist = mag end
            end
        end
    end
    return target
end

-- 카메라 조작 대신 총알 발사 로직(Raycast)을 가로챕니다.
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if getgenv().Config.SilentAim and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local t = GetClosest()
        if t and t.Character then
            if method == "Raycast" then
                args[2] = (t.Character[getgenv().Config.TargetPart].Position - args[1]).Unit * 1000
            else
                args[1] = Ray.new(Camera.CFrame.Position, (t.Character[getgenv().Config.TargetPart].Position - Camera.CFrame.Position).Unit * 1000)
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- 캐릭터 무브먼트 (Fly, NoClip, InfJump)
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if getgenv().Config.NoClip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        if getgenv().Config.Fly then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 4, 0)
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().Config.InfJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

MainTab.Visible = true
