-- [[ Nameless hub | v1 ]] --
local cloneref = cloneref or function(o) return o end
local CoreGui = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local LocalPlayer = Players.LocalPlayer

-- 중복 실행 방지
if CoreGui:FindFirstChild("NamelessUI") then CoreGui.NamelessUI:Destroy() end

-- 설정값
getgenv().Config = {
    Aimbot = false, SilentAim = false,
    WalkSpeed = 16, JumpPower = 50, InfJump = false,
    Fly = false, NoClip = false, ESP = false
}

-- [[ UI 생성 ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0

-- 테두리 (사진 느낌)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 1.5

-- 상단 타이틀
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "  Nameless hub | v1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code; Title.TextXAlignment = Enum.TextXAlignment.Left

-- 탭 버튼 영역
local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(0, 120, 1, -35)
TabHolder.Position = UDim2.new(0, 0, 0, 35)
TabHolder.BackgroundColor3 = Color3.fromRGB(18, 18, 18)

local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 5)

-- 페이지 영역
local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -130, 1, -45)
Container.Position = UDim2.new(0, 125, 0, 40)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(Name)
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(1, 0, 0, 30)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.Text = Name; TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200); TabBtn.Font = Enum.Font.Code
    
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    Pages[Name] = Page
    return Page
end

-- 기능 토글 함수
local function AddToggle(Parent, Text, Var)
    local Btn = Instance.new("TextButton", Parent)
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = Text .. ": OFF"; Btn.TextColor3 = Color3.fromRGB(200, 200, 200); Btn.Font = Enum.Font.Code
    Btn.MouseButton1Click:Connect(function()
        getgenv().Config[Var] = not getgenv().Config[Var]
        Btn.Text = Text .. ": " .. (getgenv().Config[Var] and "ON" or "OFF")
        Btn.TextColor3 = getgenv().Config[Var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(200, 200, 200)
    end)
end

-- 탭 생성
local MainTab = CreateTab("Main")
local RageTab = CreateTab("Rage")
local CharTab = CreateTab("Character")
local MiscTab = CreateTab("Misc")
local SettTab = CreateTab("Settings")

-- 기능 추가
AddToggle(MainTab, "Aimbot", "Aimbot")
AddToggle(MainTab, "Silent Aim", "SilentAim")
AddToggle(RageTab, "Fly Mode", "Fly")
AddToggle(CharTab, "Infinite Jump", "InfJump")
AddToggle(CharTab, "No Clip", "NoClip")
AddToggle(MiscTab, "Player ESP", "ESP")

-- [[ 기능 로직 ]] --
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Config.WalkSpeed
        if getgenv().Config.NoClip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        if getgenv().Config.Fly then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if getgenv().Config.InfJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 메뉴 열기/닫기 (Insert 키)
UserInputService.InputBegan:Connect(function(Key)
    if Key.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- 드래그 기능
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

Pages["Main"].Visible = true
MainFrame.Draggable = true -- 구형 실행기 지원용

