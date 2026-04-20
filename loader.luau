-- [[ KICKHOOK ORIGINAL FLY SYSTEM ]]
local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- 킥훅 전용 전역 변수 설정
getgenv().Fly = false
getgenv().FlySpeed = 150
getgenv().VerticalSpeed = 100

-- 킥훅의 핵심: 물리 엔진 강제 오버라이드 (Stepped 단계)
RunService.Stepped:Connect(function()
    if getgenv().Fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LP.Character.HumanoidRootPart
        local Hum = LP.Character:FindFirstChild("Humanoid")
        
        -- 1. 킥훅식 물리 잠금: 서버로 보내는 속도값을 0으로 중첩시켜 추락 감지 우회
        HRP.Velocity = Vector3.new(0, 0, 0)
        
        -- 2. 방향 벡터 계산 (킥훅의 LookVector 보정값 적용)
        local moveDir = Vector3.new(0, 0, 0)
        local cf = Camera.CFrame
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cf.RightVector end
        
        -- 상승/하강 (킥훅 특유의 수직 이동 로직)
        if UIS:IsKeyDown(Enum.KeyCode.Space) then 
            moveDir = moveDir + Vector3.new(0, getgenv().VerticalSpeed / getgenv().FlySpeed, 0) 
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then 
            moveDir = moveDir - Vector3.new(0, getgenv().VerticalSpeed / getgenv().FlySpeed, 0) 
        end

        -- 3. CFrame 강제 주입 (DeltaTime 고려한 킥훅식 부드러운 이동)
        if moveDir.Magnitude > 0 then
            HRP.CFrame = HRP.CFrame + (moveDir.Unit * (getgenv().FlySpeed / 60))
        end
        
        -- 4. 킥훅의 핵심 Bypass: State 고정 및 PlatformStand 활성화
        if Hum then
            if Hum:GetState() ~= Enum.HumanoidStateType.Physics then
                Hum:ChangeState(Enum.HumanoidStateType.Physics)
            end
            Hum.PlatformStand = true
        end
    elseif LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.PlatformStand = false
    end
end)

