-- [[ Nameless hub | v1 (Mobile Edition) ]] --
local cloneref = cloneref or function(o) return o end
local CoreGui = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("NamelessUI") then CoreGui.NamelessUI:Destroy() end

getgenv().Config = {
    Aimbot = false, SilentAim = false,
    WalkSpeed = 16, JumpPower = 50, InfJump = false,
    Fly = false, NoClip = false, ESP = false
}

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessUI"

-- [[ 모바일용 열기/닫기 버튼 (Floating Button) ]] --
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25) -- 화면 왼쪽 중앙
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.Text = "N" -- Nameless의 N
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.BorderSizePixel = 2
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0) -- 동그랗게

-- 드래그 가능한 버튼 (모바일에서 위치 이동 가능)
ToggleBtn.Active = true
ToggleBtn.Draggable = true

-- 메인 프레임
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 280) -- 모바일 화면에 맞춰 약간 축소
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true

-- 버튼 클릭 시 메뉴 끄고 켜기
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- (탭 및 기능 로직은 동일)
local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(0, 100, 1, -35)
TabHolder.Position = UDim2.new(0, 0, 0, 35)
TabHolder.BackgroundColor3 = Color3.fromRGB(18, 18, 18)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -110, 1, -45)
Container.Position = UDim2.new(0, 105, 0, 40)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(Name)
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(1, 0, 0, 40) -- 터치하기 편하게 크게
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.Text = Name; TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200); TabBtn.Font = Enum.Font.Code
    
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 4
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    Pages[Name] = Page
    return Page
end

-- 기능 추가 (동일)
local MainTab = CreateTab("Main")
local CharTab = CreateTab("Char")

local function AddToggle(Parent, Text, Var)
    local Btn = Instance.new("TextButton", Parent)
    Btn.Size = UDim2.new(1, -5, 0, 45) -- 모바일 터치 최적화
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = Text .. ": OFF"; Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.MouseButton1Click:Connect(function()
        getgenv().Config[Var] = not getgenv().Config[Var]
        Btn.Text = Text .. ": " .. (getgenv().Config[Var] and "ON" or "OFF")
        Btn.TextColor3 = getgenv().Config[Var] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(200, 200, 200)
    end)
end

AddToggle(MainTab, "Silent Aim", "SilentAim")
AddToggle(CharTab, "Fly Mode", "Fly")
AddToggle(CharTab, "Inf Jump", "InfJump")

Pages["Main"].Visible = true
MainFrame.Active = true
MainFrame.Draggable = true -- 모바일에서도 위치 이동 가능

-- 실행 성공 알림
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Nameless hub | v1",
    Text = "모바일 버전 로드 완료! 'N' 아이콘을 누르세요.",
    Duration = 5
})
