-- [[ Misc 탭: 이동 기능 추가 ]] --
AddToggle(Misc, "Fly (비행)", function(val)
    _G.FlyEnabled = val
    if val then StartFly() else StopFly() end
end)

AddToggle(Misc, "Noclip (벽 통과)", function(val)
    _G.Noclip = val
end)

-- [[ Main 탭: 에임봇 & 사일런트 세부 설정 ]] --
AddSectionTitle(Main, "Aim Enhancement")
AddToggle(Main, "Aimbot Enabled", function(val) _G.Aimbot = val end)
AddToggle(Main, "Silent Aim Enabled", function(val) _G.SilentAim = val end)
AddToggle(Main, "Show FOV Circle", function(val) 
    _G.ShowFOV = val
    if FOVCircle then FOVCircle.Visible = val end
end)

-----------------------------------------------------------
-- [[ 핵심 엔진 (코드 하단에 추가) ]] --
-----------------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- 1. Noclip (벽 통과) 로직
RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 2. Fly (비행) 로직
local BodyGyro, BodyVelocity
function StartFly()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    BodyGyro = Instance.new("BodyGyro", root)
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.cframe = root.CFrame
    
    BodyVelocity = Instance.new("BodyVelocity", root)
    BodyVelocity.velocity = Vector3.new(0, 0, 0)
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    task.spawn(function()
        while _G.FlyEnabled do
            local moveDir = Camera.CFrame.LookVector
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                BodyVelocity.velocity = moveDir * 50
            elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                BodyVelocity.velocity = moveDir * -50
            else
                BodyVelocity.velocity = Vector3.new(0, 0, 0)
            end
            BodyGyro.cframe = Camera.CFrame
            task.wait()
        end
    end)
end

function StopFly()
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end
end

-- 3. 고도화된 타겟팅 함수 (에임봇/사일런트 공용)
local function GetClosestTarget()
    local target = nil
    local maxDist = _G.ShowFOV and 150 or math.huge -- FOV 사용시 거리 제한
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if dist < maxDist then
                    target = p
                    maxDist = dist
                end
            end
        end
    end
    return target
end

-- 4. Aimbot (카메라 고정)
RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local target = GetClosestTarget()
        if target and target.Character then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- 5. Silent Aim (Raycast Hook - 최신 방식)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if _G.SilentAim and method == "Raycast" and not checkcaller() then
        local target = GetClosestTarget()
        if target and target.Character then
            args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

