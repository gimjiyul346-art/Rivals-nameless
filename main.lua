-- [[ Nameless v2.5 | Unnamed Bypass - No Key ]]
-- 1. 언네임드 메인 소스 우회 로드
-- 런처를 거치지 않고 메인 기능을 직접 호출합니다.
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mrgunz/UnnamedCheat/main/Source"))()
    end)
end)

-- 2. 메뉴 토글용 플로팅 버튼 (모바일 필수)
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ToggleBtn.Name = "NamelessBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- 검은색
ToggleBtn.Position = UDim2.new(0.1, 0, 0.15, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Text = "N"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0) -- 빨간색 N
ToggleBtn.TextSize = 20
ToggleBtn.Draggable = true -- 드래그 가능

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleBtn

-- 3. 버튼 클릭 시 메뉴 껐다 켜기
ToggleBtn.MouseButton1Click:Connect(function()
    local coreGui = game:GetService("CoreGui")
    -- 언네임드 UI 이름을 찾아서 표시 상태를 반전시킵니다.
    for _, v in pairs(coreGui:GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name:find("Unnamed") or v:FindFirstChild("Main")) then
            v.Enabled = not v.Enabled
        end
    end
end)

print("Nameless v2.5 Loaded! Enjoy No-Key Unnamed.")

