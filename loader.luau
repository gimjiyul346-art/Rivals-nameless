-- [[ NAMELESS HUB V1.6 : FLIGHT ENGINE REBORN ]]
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [ 전역 설정 ]
getgenv().Fly = false
getgenv().FlySpeed = 50
getgenv().Noclip = false

local Window = Rayfield:CreateWindow({
   Name = "NAMELESS HUB V1.6",
   ConfigurationSaving = { Enabled = true, FolderName = "NamelessRivals", FileName = "Config" }
})

-- [[ Movement 탭 최적화 ]]
local MoveTab = Window:CreateTab("Movement", 4483362458)

MoveTab:CreateToggle({
   Name = "Fly (비행 개선)",
   CurrentValue = false,
   Callback = function(Value) 
       getgenv().Fly = Value 
       if not Value and LP.Character then
           LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Landing)
       end
   end,
})

MoveTab:CreateToggle({
   Name = "Noclip (벽 뚫기 이동)",
   CurrentValue = false,
   Callback = function(Value) getgenv().Noclip = Value end,
})

MoveTab:CreateSlider({
   Name = "Fly Speed",
   Range = {16, 500},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value) getgenv().FlySpeed = Value end,
})

-- [[ 신규 플라이 & 노클립 엔진 ]]
RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LP.Character.HumanoidRootPart
        
        -- 노클립 로직 (벽 통과)
        if getgenv().Noclip then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end

        -- 개선된 CFrame 플라이
        if getgenv().Fly then
            HRP.Velocity = Vector3.new(0, 0, 0) -- 중력 무력화
            
            local MoveDirection = Vector3.new(0, 0, 0)
            if UserInput:IsKeyDown(Enum.KeyCode.W) then MoveDirection = MoveDirection + Camera.CFrame.LookVector end
            if UserInput:IsKeyDown(Enum.KeyCode.S) then MoveDirection = MoveDirection - Camera.CFrame.LookVector end
            if UserInput:IsKeyDown(Enum.KeyCode.A) then MoveDirection = MoveDirection - Camera.CFrame.RightVector end
            if UserInput:IsKeyDown(Enum.KeyCode.D) then MoveDirection = MoveDirection + Camera.CFrame.RightVector end
            
            -- 조이스틱/키보드 입력이 있을 때만 이동
            if MoveDirection.Magnitude > 0 then
                HRP.CFrame = HRP.CFrame + (MoveDirection * getgenv().FlySpeed / 50)
            end
            
            -- 높이 유지
            LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Physics)
        end
    end
end)

-- 전투 로직 생략 (기존 V1.5와 동일하게 유지 권장)
Rayfield:LoadConfiguration()

