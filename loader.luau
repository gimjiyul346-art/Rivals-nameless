-- [[ 보안 및 중복 실행 방지 ]] --
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "KiciaHybridFinal" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "KiciaHybridFinal"
ScreenGui.DisplayOrder = 999

-- 설정 저장소
local Flags = {
    SilentAim = false, Aimbot = false, AutoShoot = false, Wallbang = false,
    ESP = false, SkinChanger = false, Fly = false, Noclip = false, Speed = 16
}

-- [[ 메인 UI 구성 ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true

local UICorner = Instance.new("UICorner", Main)

-- 상단 바 (드래그 및 닫기 버튼 포함)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "KICIA x SOLIX HYBRID v2.5 (Premium)"
Title.TextColor3 = Color3.fromRGB(128, 213, 247)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Code

-- ★ 닫기 버튼 ★
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 2)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold

-- ★ 재오픈 버튼 (닫았을 때 다시 열기용) ★
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 40)
OpenBtn.Position = UDim2.new(0, 5, 0.5, -20)
OpenBtn.Text = "MENU"
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.TextColor3 = Color3.fromRGB(128, 213, 247)
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)

-- 사이드바 (카테고리)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)

-- 페이지 컨테이너
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -140, 1, -50)
Pages.Position = UDim2.new(0, 135, 0, 45)
Pages.BackgroundTransparency = 1

-- [[ 탭 및 버튼 생성 함수 ]] --
local function CreatePage(name, offset)
    local Page = Instance.new("ScrollingFrame", Pages)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 8)

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(1, -10, 0, 40)
    TabBtn.Position = UDim2.new(0, 5, 0, offset)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.TextColor3 = Color3.new(1, 1, 1)
    TabBtn.Font = Enum.Font.SourceSansBold
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)
    return Page
end

local function AddToggle(parent, text, flag)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    
    btn.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        btn.Text = text .. ": " .. (Flags[flag] and "ON" or "OFF")
        btn.TextColor3 = Flags[flag] and Color3.fromRGB(100, 255, 150) or Color3.new(0.8, 0.8, 0.8)
    end)
end

-- [[ 기능 탭 구성 ]] --
local Combat = CreatePage("COMBAT", 10)
local Visuals = CreatePage("VISUALS", 60)
local Movement = CreatePage("MOVEMENT", 110)
local Misc = CreatePage("MISC", 160)

-- 1. COMBAT (에임봇, 사일런트, 월뱅)
AddToggle(Combat, "Silent Aim", "SilentAim")
AddToggle(Combat, "Aimbot", "Aimbot")
AddToggle(Combat, "Auto Fire", "AutoShoot")
AddToggle(Combat, "Wallbang", "Wallbang")

-- 2. VISUALS (ESP, 스킨체인저)
AddToggle(Visuals, "ESP", "ESP")
AddToggle(Visuals, "Unlock Skins", "SkinChanger")

-- 3. MOVEMENT (플라이, 노클립)
AddToggle(Movement, "Fly", "Fly")
AddToggle(Movement, "Noclip", "Noclip")

-- [[ 핵심 핵 로직 구현 ]] --
game:GetService("RunService").Stepped:Connect(function()
    if Flags.Noclip and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 첫 페이지 표시
Combat.Visible = true

-- 드래그 기능 추가 (모바일 대응)
local UIS = game:GetService("UserInputService")
local dragStart, startPos, dragging
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = i.Position startPos = Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(i) dragging = false end)

