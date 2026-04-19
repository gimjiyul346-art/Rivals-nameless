-- [[ Nameless v2.1 | Unnamed Bypass ]]
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleBtn.Text = "N"
ToggleBtn.Draggable = true

-- 영상에서 보신 그 암호화된 소스를 직접 실행
task.spawn(function()
    loadstring(game:HttpGet("영상에서_들어갔던_그_사이트_주소"))()
end)

ToggleBtn.MouseButton1Click:Connect(function()
    -- 메뉴 토글 로직
    local unnamed = game.CoreGui:FindFirstChild("UnnamedGui") or game.CoreGui:FindFirstChild("ScreenGui")
    if unnamed then unnamed.Enabled = not unnamed.Enabled end
end)

