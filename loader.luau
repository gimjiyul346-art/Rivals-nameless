local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- [1] 중복 실행 방지
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end

-- [2] 메인 설정 및 변수
local UI = {
    Tabs = {},
    Containers = {},
    CurrentTab = nil,
    IsOpen = true
}

-- [3] 메인 프레임 생성 (기본 뼈대)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NamelessHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 400) -- 확장성을 위해 조금 더 키웠습니다
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.Active = true
MainFrame.Draggable = true -- 드래그 가능
MainFrame.Parent = ScreenGui

-- 상단 타이틀
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "  Nameless hub | v1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- 탭 버튼이 들어갈 가로 바
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 25)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = TabBar

-- [4] 핵심 함수: 탭 추가하기
local function AddTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 70, 1, 0)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = name:lower()
    TabButton.Font = Enum.Font.Code
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabButton.Parent = TabBar

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -10, 1, -65)
    Container.Position = UDim2.new(0, 5, 0, 60)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.ScrollBarThickness = 2
    Container.CanvasSize = UDim2.new(0, 0, 0, 0) -- 내용 많아지면 자동 확장
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = Container
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- 자동 캔버스 크기 조절 (기능이 계속 추가되어도 스크롤 가능하게 함)
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(UI.Containers) do t.Visible = false end
        for _, b in pairs(UI.Tabs) do b.TextColor3 = Color3.fromRGB(150, 150, 150) end
        Container.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    UI.Tabs[name] = TabButton
    UI.Containers[name] = Container
    
    if not UI.CurrentTab then
        Container.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        UI.CurrentTab = name
    end
    
    return Container
end

-- [5] 핵심 함수: 기능(토글) 추가하기
local function AddToggle(parent, text, callback)
    local ToggleFrame = Instance.new("TextButton") -- 클릭 영역 확보를 위해 버튼으로 생성
    ToggleFrame.Size = UDim2.new(0.95, 0, 0, 30)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleFrame.BorderSizePixel = 1
    ToggleFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
    ToggleFrame.Text = ""
    ToggleFrame.AutoButtonColor = false
    ToggleFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Code
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 20, 0, 20)
    Indicator.Position = UDim2.new(1, -30, 0.5, -10)
    Indicator.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Indicator.BorderSizePixel = 1
    Indicator.Parent = ToggleFrame

    local enabled = false
    ToggleFrame.MouseButton1Click:Connect(function()
        enabled = not enabled
        Indicator.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
        callback(enabled)
    end)
end

-- [6] 메뉴 열고 닫기 (Insert 키)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        UI.IsOpen = not UI.IsOpen
        MainFrame.Visible = UI.IsOpen
    end
end)

-----------------------------------------------------------
-- 여기서부터 기능을 쭉쭉 이어 붙이시면 됩니다!
-----------------------------------------------------------

-- 1. 탭 만들기
local MainTab = AddTab("Main")
local WorldTab = AddTab("World")
local ESPTab = AddTab("ESP")
local VisualsTab = AddTab("Visuals")
local CharTab = AddTab("Character")
local MiscTab = AddTab("Misc")
local SettingsTab = AddTab("Settings")

-- 2. Main 탭 기능 추가 (이어 붙이기 예시)
AddToggle(MainTab, "Silent Aim", function(state)
    print("Silent Aim: ", state)
end)

AddToggle(MainTab, "Auto Shoot", function(state)
    print("Auto Shoot: ", state)
end)

-- 3. World 탭 기능 추가 예시
AddToggle(WorldTab, "Infinite Jump", function(state)
    print("Inf Jump: ", state)
end)

