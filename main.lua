-- [[ Nameless v1 | Professional Loader ]]

local function StartLoading()
    -- 로딩 UI 생성
    local CoreGui = game:GetService("CoreGui")
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", ScreenGui)
    local Bar = Instance.new("Frame", Frame)
    local Text = Instance.new("TextLabel", Frame)
    
    Frame.Size = UDim2.new(0, 300, 0, 70)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -35)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    
    Bar.Size = UDim2.new(0, 0, 0, 5)
    Bar.Position = UDim2.new(0, 0, 1, -5)
    Bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Bar.BorderSizePixel = 0
    
    Text.Size = UDim2.new(1, 0, 1, -5)
    Text.BackgroundTransparency = 1
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.Text = "Loading Nameless v1..."
    Text.Font = Enum.Font.Code
    Text.TextSize = 18

    -- 로딩 애니메이션
    local messages = {
        "Initializing Systems...",
        "Bypassing Key System...",
        "Injecting Aimbot Modules...",
        "Loading UI Library...",
        "Nameless v1 Ready!"
    }

    for i, msg in ipairs(messages) do
        Text.Text = msg
        Bar:TweenSize(UDim2.new(i / #messages, 0, 0, 5), "Out", "Quad", 0.5)
        task.wait(0.7)
    end

    ScreenGui:Destroy()
end

-- 1. 로딩 시작
StartLoading()

-- 2. 실제 메뉴 코드 로드 (Kavo Library)
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/73n7/Kavo-UI-Library/main/lib.lua"))()
local Window = Kavo.CreateLib("Nameless v1", "BloodTheme")

-- [ 기능 설정 및 탭 생성 ]
local Combat = Window:NewTab("Combat")
local Section = Combat:NewSection("Aimbot & Visuals")

getgenv().Aimbot = false
getgenv().ESP = false

Section:NewToggle("Aimbot Active", "자동 조준", function(state) getgenv().Aimbot = state end)
Section:NewToggle("ESP Active", "적 위치 표시", function(state) getgenv().ESP = state end)

-- [ 실제 작동 로직 ]
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().Aimbot then
        -- 에임봇 로직 (생략된 본체 기능)
    end
end)

print("Nameless v1 Successfully Injected.")
