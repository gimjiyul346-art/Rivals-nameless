local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [1] 이전 UI 제거
if CoreGui:FindFirstChild("NamelessHub") then CoreGui.NamelessHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NamelessHub"

_G.Config = {
    SilentAim = true,  -- 기본 활성화
    Wallbang = true,   -- 벽 뚫기 기본 활성화
    ESP = true,        -- ESP 기본 활성화
    WalkSpeed = 16,
    InfJump = true
}

-- [2] 핵심: 매직 불렛(Silent Aim) 로직
-- 게임의 총알 생성 방식(Raycast)을 가로채서 적의 헤드로 경로를 바꿉니다.
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.Config.SilentAim and method == "Raycast" then
        local target = nil
        local closest = math.huge
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis or _G.Config.Wallbang then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < closest then
                        target = p
                        closest = mag
                    end
                end
            end
        end
        
        -- 총알의 방향을 적의 헤드로 강제 변경
        if target then
            args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [3] UI 및 기타 편의 기능 (사용자 요청 기능 포함)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Draggable = true; MainFrame.Active = true

-- 탭/버튼 생성 함수
local function CreateToggle(text, var, pos)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = pos
    btn.Text = text .. ": " .. tostring(_G.Config[var])
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(function()
        _G.Config[var] = not _G.Config[var]
        btn.Text = text .. ": " .. tostring(_G.Config[var])
    end)
end

CreateToggle("Magic Silent Aim", "SilentAim", UDim2.new(0, 10, 0, 50))
CreateToggle("Wallbang (All Hit)", "Wallbang", UDim2.new(0, 210, 0, 50))
CreateToggle("Infinite Jump", "InfJump", UDim2.new(0, 10, 0, 100))
CreateToggle("Player ESP", "ESP", UDim2.new(0, 210, 0, 100))

-- [4] 이동 및 ESP 유지 엔진
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = _G.Config.WalkSpeed
    end
    
    -- ESP 유지
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("Highlight")
            if _G.Config.ESP then
                if not hl then Instance.new("Highlight", p.Character).FillColor = Color3.fromRGB(255, 0, 0) end
            elseif hl then hl:Destroy() end
        end
    end
end)

-- 무한 점프
UserInputService.JumpRequest:Connect(function()
    if _G.Config.InfJump and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
