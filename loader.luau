-- [[ 고급 보안 및 초기화 ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 중복 실행 방지
if _G.MenuLoaded then return end
_G.MenuLoaded = true

-- 설정값
local Settings = {
    Combat = { SilentAim = false, Aimbot = false, AutoShoot = false, Wallbang = false, FOV = 150 },
    Movement = { Fly = false, Noclip = false, Speed = 16 },
    Visuals = { ESP = false, SkinChanger = false }
}

-- [[ UI 구성 ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0

-- 닫기 버튼 (X)
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() _G.MenuLoaded = nil end)

-- 사이드바 및 탭 시스템
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -140, 1, -40)
Container.Position = UDim2.new(0, 135, 0, 35)
Container.BackgroundTransparency = 1

local function CreateTab(name, pos)
    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Size = UDim2.new(1, -10, 0, 40)
    Tab.Position = UDim2.new(0, 5, 0, pos)
    Tab.Text = name
    Tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Tab.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 5)
    
    Tab.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)
    return Page
end

-- [[ 기능

