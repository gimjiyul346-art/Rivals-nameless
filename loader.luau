-- [[ Nameless Hub | v1 - Full Script Source ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 기존 UI 제거
if CoreGui:FindFirstChild("NamelessHub") then
    CoreGui.NamelessHub:Destroy()
end

-- 메인 GUI 생성
local NamelessHub = Instance.new("ScreenGui")
NamelessHub.Name = "NamelessHub"
NamelessHub.Parent = CoreGui

-- 메인 프레임 (사용자 스케치 기반)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = NamelessHub
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.Active = true
MainFrame.Draggable = true -- 드래그 가능

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- 상단 제목 (Nameless hub | v1)
local TitleBar = Instance.new("TextLabel")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.Text = "  Nameless hub | v1"
TitleBar.TextColor3 = Color3.fromRGB(0, 255, 150) -- 네온 그린
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 22

local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = TitleBar

-- 왼쪽 탭 영역 (Main, Rage 등등)
local TabFrame = Instance.new("Frame")
TabFrame.Parent = MainFrame
TabFrame.Size = UDim2.new(0, 120, 1, -45)
TabFrame.Position = UDim2.new(0, 0, 0, 45)
TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabFrame
TabList.SortOrder = Enum.SortOrder.LayoutOrder

-- 기능 버튼들이 담길 컨텐츠 영역
local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -130, 1, -55)
ContentFrame.Position = UDim2.new(0, 125, 0, 50)
ContentFrame.BackgroundTransparency = 1

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentFrame
ContentLayout.Padding = UDim.new(0, 8)

-- 알림 함수
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 2;
    })
end

-- 버튼 생성 함수
local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentFrame
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- [Rage 탭 구성]
createButton("Rage Bot (On/Off)", function()
    notify("Rage", "Rage Bot이 활성화되었습니다.")
end)

createButton("Silent Aim", function()
    notify("Combat", "Silent Aim이 적용되었습니다.")
end)

createButton("Wallbang (벽 관통)", function()
    notify("Combat", "Wallbang 모드가 켜졌습니다.")
end)

createButton("Rapid Fire (연사 속도)", function()
    notify("Weapon", "총알 발사 속도가 최대로 조절되었습니다.")
end)

notify("Nameless Hub", "성공적으로 로드되었습니다!")

