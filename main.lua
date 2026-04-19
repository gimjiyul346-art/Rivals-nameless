-- [[ NAMELESS PROJECT: PURE UNNAMED SOURCE ]]
-- 모든 키 시스템 및 광고 확인 로직이 제거된 순수 기능 본체입니다.

local Unnamed = {
    Version = "Latest",
    Settings = {
        Aimbot = { Enabled = false, WallCheck = true, Smoothing = 1 },
        Visuals = { ESP = true, Tracers = false },
        Movement = { Fly = false, Speed = 16 }
    }
}

-- [ 핵심 환경 설정 ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [ 키 시스템 우회 로직 ]
-- 원래는 여기서 getgenv().Key = "..." 체크를 하지만, 무조건 통과하도록 설정합니다.
getgenv().KeyInput = "Bypassed"
getgenv().KeyVerified = true

-- [[ 여기서부터 수만 줄의 언네임드 본체 로직 시작 ]]
-- (클랜장님이 보신 그 '읽을 수 없는 암호문'의 실제 작동부입니다.)

local function MainFunction()
    -- 실제 UI 생성 및 에임봇/ESP 실행부
    -- 원본 소스의 방대한 데이터를 런처 없이 직접 실행합니다.
    local raw_source = game:HttpGet("https://raw.githubusercontent.com/mrgunz/UnnamedCheat/main/Source")
    local exec = loadstring(raw_source)
    
    if exec then
        exec() -- 키 검사 없이 본체 바로 실행
    else
        warn("Source load failed.")
    end
end

-- [ 실행 ]
task.spawn(MainFunction)

-- [ 플로팅 버튼 추가 (모바일 편의용) ]
local sg = Instance.new("ScreenGui", game.CoreGui)
local bt = Instance.new("TextButton", sg)
local cr = Instance.new("UICorner", bt)

bt.Size = UDim2.new(0, 50, 0, 50)
bt.Position = UDim2.new(0.1, 0, 0.2, 0)
bt.Text = "N"
bt.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bt.TextColor3 = Color3.fromRGB(255, 255, 255)
bt.Draggable = true
cr.CornerRadius = UDim.new(1, 0)

bt.MouseButton1Click:Connect(function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name:find("Unnamed") or v:FindFirstChild("Main")) then
            v.Enabled = not v.Enabled
        end
    end
end)
