local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- 기존 UI 제거 (중복 실행 방지)
if CoreGui:FindFirstChild("NamelessHub") then
    CoreGui.NamelessHub:Destroy()
end

-- 메인 컨테이너
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NamelessHub"
ScreenGui.Parent = CoreGui

-- 메인 프레임 (외곽선 및 배경)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60) -- 얇은 회색 테두리
MainFrame.Active = true
MainFrame.Draggable = true -- 모바일/PC 드래그 가능
MainFrame.Parent = ScreenGui

-- 상단 타이틀 바
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.BorderSizePixel = 0
Title.Text = "  Nameless hub | v1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.Parent = MainFrame

-- 탭 바 (Main, Rage 등등)
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, 25)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabBar

-- 탭 버튼 생성 함수
local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    btn.Parent = TabBar
    return btn
end

CreateTab("Main")
CreateTab("Rage")
CreateTab("Visuals")

-- 중앙 구분선 (스케치 반영)
local MidLine = Instance.new("Frame")
MidLine.Name = "MidLine"
MidLine.Size = UDim2.new(0, 1, 1, -55)
MidLine.Position = UDim2.new(0.5, 0, 0, 55)
MidLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MidLine.BorderSizePixel = 0
MidLine.Parent = MainFrame

-- 왼쪽/오른쪽 기능 영역
local LeftArea = Instance.new("Frame")
LeftArea.Size = UDim2.new(0.5, -10, 1, -65)
LeftArea.Position = UDim2.new(0, 5, 0, 60)
LeftArea.BackgroundTransparency = 1
LeftArea.Parent = MainFrame

local RightArea = Instance.new("Frame")
RightArea.Size = UDim2.new(0.5, -10, 1, -65)
RightArea.Position = UDim2.new(0.5, 5, 0, 60)
RightArea.BackgroundTransparency = 1
RightArea.Parent = MainFrame

print("Nameless Hub UI Loaded Successfully!")

