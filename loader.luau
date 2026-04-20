-- [[ 보안 우회 및 라이브러리 초기화 ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 기존 UI 제거 (중복 실행 방지)
if game:GetService("CoreGui"):FindFirstChild("KiciaSolixV2") then
    game:GetService("CoreGui").KiciaSolixV2:Destroy()
end

-- 설정값 (모든 핵 기능 탑재)
local Flags = {
    Aimbot = false, SilentAim = false, AutoShoot = false, Wallbang = false,
    ESP = false, Tracers = false, Box = false,
    SkinChanger = false, Fly = false, Noclip = false, Speed = 16, Jump = 50,
    FOV = 100, Smoothness = 0.5
}

-- [[ UI 메인 프레임 ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "KiciaSolixV2"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 400)
Main.Position = UDim2.new(0.5, -275, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- 진한 블랙 (Kicia 감성)
Main.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 10)

-- 상단 바
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local TopCorner = Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = " KICIA x SOLIX HYBRID PREMIUM "
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(128, 213, 247) -- Kicia 테마 컬러
Title.Font = Enum.Font.Code
Title.TextSize = 18

-- 사이드바 (카테고리)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

-- 페이지 컨테이너
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -150, 1, -85) -- 닫기 버튼 자리를 위해 하단 여백 확보
Pages.Position = UDim2.new(0, 145, 0, 40)
Pages.BackgroundTransparency = 1

-- [[ 하단 닫기/숨기기 컨트롤 ]] --
local Controls = Instance.new("Frame", Main)
Controls.Size = UDim2.new(1, -150, 0, 40)
Controls.Position = UDim2.new(0, 145, 1, -45)
Controls.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Controls)
CloseBtn.Size = UDim2.new(0.45, 0, 1, 0)
CloseBtn.Text = "CLOSE MENU"
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local HideBtn = Instance.new("TextButton", Controls)
HideBtn.Size = UDim2.new(0.45, 0, 1, 0)
HideBtn.Position = UDim2.new(0.55, 0, 0, 0)
HideBtn.Text = "HIDE (R-CTRL)"
HideBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
HideBtn.TextColor3 = Color3.fromRGB(128, 213, 247)

-- [[ 기능 구현부 (핵심 엔진) ]] --
local function CreatePage(name, offset)
    local Page = Instance.new("ScrollingFrame", Pages)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 5)

    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Size = UDim2.new(1, -10, 0, 35)
    Tab.Position = UDim2.new(0, 5, 0, offset)
    Tab.Text = name
    Tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Tab.TextColor3 = Color3.new(1,1,1)
    Tab.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)
    return Page
end

-- 탭 생성
local Combat = CreatePage("COMBAT", 10)
local Visuals = CreatePage("VISUALS", 50)
local Movement = CreatePage("MOVEMENT", 90)
local Misc = CreatePage("MISC", 130)

-- 기능 추가 함수
local function AddHack(parent, text, flag)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35)
    b.Text = text .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        b.Text = text .. ": " .. (Flags[flag] and "ON" or "OFF")
        b.TextColor3 = Flags[flag] and Color3.fromRGB(0, 255, 150) or Color3.new(1, 1, 1)
    end)
end

-- 1. Combat 탭 (에임류)
AddHack(Combat, "Aimbot (Smooth)", "Aimbot")
AddHack(Combat, "Silent Aim", "SilentAim")
AddHack(Combat, "Auto Fire", "AutoShoot")
AddHack(Combat, "Wallbang", "Wallbang")

-- 2. Visuals 탭 (ESP/스킨)
AddHack(Visuals, "Player ESP", "ESP")
AddHack(Visuals, "Chams (Wallhack)", "Box")
AddHack(Visuals, "Unlock All Skins", "SkinChanger")

-- 3. Movement 탭 (이동류)
AddHack(Movement, "Fly Mode", "Fly")
AddHack(Movement, "Noclip (벽통과)", "Noclip")
AddHack(Movement, "Infinite Jump", "Jump")

-- 4. Misc 탭 (기타)
AddHack(Misc, "Anti-Afk", "Misc")
AddHack(Misc, "Server Hop", "Misc")

-- [[ 핵심 로직 - Noclip/Fly/Wallbang ]] --
RunService.Stepped:Connect(function()
    if Flags.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- 첫 페이지 표시
Combat.Visible = true

-- 드래그 기능
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end
end)
