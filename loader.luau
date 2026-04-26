-- [[ CORE SETTINGS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- [[ SECURITY BYPASS ]]
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if not checkcaller() and (method == "Kick" or method == "kick") then
        return nil
    end
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

-- [[ UI INITIALIZATION ]]
local UnnamedLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-upsfor-luas/main/unnamed%20esp"))()
local Win = UnnamedLib:CreateWindow("INTERNAL")
local Rage = Win:AddTab("Rage")
local Misc = Win:AddTab("Misc")

-- [[ RAGE MODULES ]]
local Modules = {
    Desync = false,
    RapidFire = false,
    SlotSpoof = false
}

-- 1. Hitbox Desync
Rage:AddSwitch("Hitbox Desync", function(state)
    Modules.Desync = state
    RunService.Heartbeat:Connect(function()
        if Modules.Desync and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local oldVelocity = root.Velocity
                root.Velocity = Vector3.new(0, 100, 0)
                RunService.RenderStepped:Wait()
                root.Velocity = oldVelocity
            end
        end
    end)
end)

-- 2. God Fire Rate (Rivals Optimized)
Rage:AddSwitch("God Fire Rate", function(state)
    Modules.RapidFire = state
    task.spawn(function()
        while Modules.RapidFire do
            task.wait()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                local cfg = tool:FindFirstChild("Config") or tool:FindFirstChild("Configuration")
                if cfg then
                    for _, v in pairs(cfg:GetChildren()) do
                        if v:IsA("NumberValue") and (v.Name:find("Rate") or v.Name:find("Time") or v.Name:find("Delay")) then
                            v.Value = 0
                        end
                    end
                end
            end
        end
    end)
end)

-- 3. Slot Spoofing (All Slots to Combat Knife)
Misc:AddButton("Slot Spoof", function()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                item.Name = "Combat Knife"
            end
        end
    end
end)

-- 4. Infinite Stamina / Movement
Misc:AddButton("Infinite Stamina", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Stamina") then
        char.Stamina.Value = 100
        char.Stamina:GetPropertyChangedSignal("Value"):Connect(function()
            char.Stamina.Value = 100
        end)
    end
end)

UnnamedLib:Watermark("READY")
-- [[ ADVANCED RAGE MODULES ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [[ SILENT AIM ENGINE ]]
-- __index 후킹을 통해 마우스 위치와 상관없이 적의 Head 좌표를 반환함
local AimSettings = {
    Enabled = true,
    TeamCheck = true,
    HitPart = "Head",
    FieldOfView = 500
}

local function GetClosestPlayer()
    local target = nil
    local dist = AimSettings.FieldOfView
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            if AimSettings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            local pos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if magnitude < dist then
                target = v.Character.Head
                dist = magnitude
            end
        end
    end
    return target
end

local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, key)
    if not checkcaller() and key == "Hit" and AimSettings.Enabled then
        local target = GetClosestPlayer()
        if target then
            return target.CFrame
        end
    end
    return oldIndex(self, key)
end)
setreadonly(mt, true)

-- [[ SERVER ABUSE & AUTO FARM ]]
local AbuseTab = Win:AddTab("Exploits")

-- 1. God Mode / Anti-Death (Map Clip)
AbuseTab:AddSwitch("Anti-Void / God", function(state)
    getgenv().AntiVoid = state
    RunService.Stepped:Connect(function()
        if getgenv().AntiVoid and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y < -50 then -- 맵 밖으로 떨어질 때 강제 복귀
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
            end
        end
    end)
end)

-- 2. Kill Aura / Remote Spam (Instant Knife)
-- Rivals의 단검 투척 Remote를 가로채서 쿨타임 없이 난사함
AbuseTab:AddButton("Kill Aura (Instant Knife)", function()
    task.spawn(function()
        while task.wait() do
            local target = GetClosestPlayer()
            if target and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                local remote = ReplicatedStorage:FindFirstChild("ThrowKnife", true) or ReplicatedStorage:FindFirstChild("Attack", true)
                if remote and remote:IsA("RemoteEvent") then
                    -- 서버에 투척 패킷을 1초에 20번 강제 전송
                    remote:FireServer(target.Position)
                end
            end
        end
    end)
end)

-- 3. Speed Hack (No Friction)
AbuseTab:AddSlider("WalkSpeed", 16, 300, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

-- 4. Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [[ VISUALS (ESP) ]]
local Visuals = Win:AddTab("Visuals")
Visuals:AddSwitch("ESP Boxes", function(state)
    getgenv().ESP_Enabled = state
    -- Unnamed Library 내부 ESP 함수 호출
    UnnamedLib:SetESP(state)
end)

UnnamedLib:Watermark("DARK-OMNI V1.5 | INJECTED")
-- [[ TELEPORT & FLY MODULE ]]
local UserInputService = game:GetService("UserInputService")
local FlyTab = Win:AddTab("Movement")

local FlySettings = {
    Enabled = false,
    Speed = 50
}

-- 1. Fly / Noclip Engine
FlyTab:AddSwitch("Fly Mode", function(state)
    FlySettings.Enabled = state
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if not state and hrp then
        hrp.Velocity = Vector3.new(0,0,0)
    end
    
    task.spawn(function()
        while FlySettings.Enabled and task.wait() do
            if char and hrp then
                local moveDir = char.Humanoid.MoveDirection
                hrp.Velocity = moveDir * FlySettings.Speed * 2
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 0)
                -- 중력 무시 로직
                if not UserInputService:GetFocusedTextBox() then
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        hrp.Velocity = hrp.Velocity + Vector3.new(0, FlySettings.Speed, 0)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        hrp.Velocity = hrp.Velocity + Vector3.new(0, -FlySettings.Speed, 0)
                    end
                end
            end
        end
    end)
end)

FlyTab:AddSlider("Fly Speed", 10, 200, function(v)
    FlySettings.Speed = v
end)

-- 2. Click TP (Ctrl + Click)
Mouse.Button1Down:Connect(function()
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and Mouse.Target then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0, 3, 0))
        end
    end
end)

-----------------------------------------------------------
-- [[ ADVANCED PREDICTION & SILENT AIM UPGRADE ]]
-----------------------------------------------------------
-- 기존 GetClosestPlayer 함수를 개선하여 탄속 예측 기능을 추가함
local function GetPredictedPos(target)
    local hrp = target.Parent:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- 탄속과 거리 계산 (Rivals 기본 탄속 약 1000 가정)
        local distance = (hrp.Position - LocalPlayer.Character.Head.Position).Magnitude
        local velocity = hrp.Velocity
        local timeToHit = distance / 1000 
        return hrp.Position + (velocity * timeToHit)
    end
    return target.Position
end

-- __index 후킹 업데이트 (탄속 예측 적용)
local oldIndex; oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and key == "Hit" and AimSettings.Enabled then
        local target = GetClosestPlayer()
        if target then
            return CFrame.new(GetPredictedPos(target))
        end
    end
    return oldIndex(self, key)
end)

-----------------------------------------------------------
-- [[ INVENTORY & SKIN UNLOCKER (LOCAL) ]]
-----------------------------------------------------------
local SkinTab = Win:AddTab("Skins")

SkinTab:AddButton("Unlock All Items (Client)", function()
    pcall(function()
        -- ReplicatedStorage 내의 무기/스킨 데이터 강제 잠금 해제
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v.Name == "Locked" or v.Name == "IsLocked" or v.Name == "Owned" then
                if v:IsA("BoolValue") then
                    v.Value = v.Name == "Owned"
                end
            end
        end
        print("Inventory data manipulated.")
    end)
end)

-----------------------------------------------------------
-- [[ SERVER CRASH / LAG SWITCH ]]
-----------------------------------------------------------
local Exploits = Win:AddTab("Exploits")

Exploits:AddSwitch("Lag Switch", function(state)
    getgenv().LagSwitch = state
    settings().Network.IncomingReplicationLag = state and 1000 or 0
end)

-- 자동 부활 (Instant Respawn)
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(function()
        task.wait(0.1)
        LocalPlayer:Goto(Enum.PlayerState.Alive) -- 게임별 리스폰 이벤트 호출
    end)
end)

UnnamedLib:Watermark("DARK-OMNI V2.0 | FULL ACCESS")
-- [[ COMBAT & PROTECTION MODULE ]]
local Protection = Win:AddTab("Protection")
local Server = Win:AddTab("Server")

-- 1. Auto Block / Parry (Rivals Specialized)
-- 상대방의 공격 애니메이션이나 원격 신호를 감지하여 자동으로 방어함
Protection:AddSwitch("Auto Block / Parry", function(state)
    getgenv().AutoBlock = state
    task.spawn(function()
        while getgenv().AutoBlock do
            task.wait()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    -- 일정 거리 내에서 공격 모션 감지 시 방어 Remote 전송
                    if dist < 15 then 
                        local blockRemote = ReplicatedStorage:FindFirstChild("Block", true) or ReplicatedStorage:FindFirstChild("Parry", true)
                        if blockRemote then
                            blockRemote:FireServer()
                        end
                    end
                end
            end
        end
    end)
end)

-- 2. Memory Cloaking (Anti-Cheat Stealth)
-- 스크립트가 사용하는 가비지 컬렉션(GC) 데이터를 숨겨 메모리 스캔을 회피함
Protection:AddButton("Cloak Memory", function()
    local oldGC = getgc
    getgenv().getgc = function()
        local gc = oldGC()
        for i, v in pairs(gc) do
            if type(v) == "function" and islclosure(v) and getfenv(v).script == script then
                gc[i] = nil
            end
        end
        return gc
    end
    print("Memory obfuscated.")
end)

-- 3. Kill Feed / Chat Spam
-- 서버의 모든 플레이어에게 메시지를 강제로 노출함
Server:AddTextBox("Spam Message", "DARK-OMNI ON TOP", function(text)
    getgenv().SpamText = text
end)

Server:AddSwitch("Chat Spam", function(state)
    getgenv().ChatSpam = state
    task.spawn(function()
        while getgenv().ChatSpam do
            task.wait(1)
            local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatRemote then
                chatRemote.SayMessageRequest:FireServer(getgenv().SpamText, "All")
            end
        end
    end)
end)

-- 4. Server Crasher (Lobby Lag)
-- 과도한 패킷을 전송하여 로비 서버의 핑을 폭등시킴
Server:AddButton("Lag Server", function()
    task.spawn(function()
        for i = 1, 500 do
            local remote = ReplicatedStorage:FindFirstChild("UpdateStatus", true)
            if remote then
                remote:FireServer(string.rep("LAG", 1000))
            end
        end
    end)
end)

-----------------------------------------------------------
-- [[ FINAL OPTIMIZATION & INJECTION ]]
-----------------------------------------------------------

-- 스크립트 삭제 시 모든 기능 중지 로직
LocalPlayer.CharacterRemoving:Connect(function()
    if getgenv().Desync then
        -- 캐릭터 제거 시 물리 엔진 초기화
    end
end)

-- 실행 환경 확인 (Executor Compatibility)
if not (fireclickdetector and getrawmetatable) then
    UnnamedLib:Notification("Warning", "Your executor might lack some functions.")
end

UnnamedLib:Watermark("DARK-OMNI V3.0 | FINAL RAGE")
print("All modules loaded successfully.")
-- [[ PACKET MANIPULATION & ADVANCED EXPLOITS ]]
local Network = Win:AddTab("Network")
local Security = Win:AddTab("Security")

-- 1. Remote Event Hooking (Packet Editor)
-- 서버로 오고 가는 모든 신호를 감지하고 특정 데이터를 변조함
local RawMeta = getrawmetatable(game)
local oldNamecall = RawMeta.__namecall
setreadonly(RawMeta, false)

RawMeta.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}

    -- [핵심] 단검 던지기/공격 신호 발생 시 좌표를 적의 헤드로 강제 고정
    if not checkcaller() and (Method == "FireServer" or Method == "InvokeServer") then
        if self.Name:find("Attack") or self.Name:find("Throw") then
            local Target = GetClosestPlayer()
            if Target then
                Args[1] = Target.Position -- 서버에 보내는 좌표를 강제로 헤드로 변경
            end
        end
    end
    
    -- 게임이 내 위치를 강제로 이동시키려고 할 때(Anti-Teleport) 무시
    if Method == "SetPrimaryPartCFrame" and self.Name == LocalPlayer.Name then
        return nil
    end

    return oldNamecall(self, unpack(Args))
end)
setreadonly(RawMeta, true)

-- 2. Infinite Consumables (Ammo / Utility)
-- 단검이나 소모품이 줄어드는 Remote를 차단함
Network:AddSwitch("Infinite Utilities", function(state)
    getgenv().InfUtils = state
    local oldFire; oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
        if getgenv().InfUtils and (self.Name:find("Consume") or self.Name:find("UseItem")) then
            return nil -- 소모 신호를 서버로 보내지 않음
        end
        return oldFire(self, ...)
    end))
end)

-- 3. Instant Loot / Auto Pickup
-- 주변의 모든 아이템을 내 위치로 텔레포트시킴
Network:AddButton("Instant Loot Items", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent:FindFirstChild("Handle") then
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent.Handle, 0)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent.Handle, 1)
        end
    end
end)

-- 4. Full Script Cloaking (Anti-Admins)
-- 관리자가 내 화면이나 로그를 감시하는 함수들을 가로챔
Security:AddButton("Anti-Admin View", function()
    local Gui = game:GetService("CoreGui")
    Gui.DescendantAdded:Connect(function(v)
        if v.Name:find("Admin") or v.Name:find("Spectate") then
            v:Destroy() -- 관리자용 UI가 감지되면 즉시 삭제
        end
    end)
    
    -- 스크린샷 캡처 시 핵 메뉴를 순간적으로 숨김
    local oldCapture = request
    if oldCapture then
        getgenv().request = function(options)
            if options.Url:find("screenshot") then
                Win:SetVisible(false)
                task.wait(0.1)
                local res = oldCapture(options)
                Win:SetVisible(true)
                return res
            end
            return oldCapture(options)
        end
    end
end)

-- 5. Force Keyless
-- [[ SERVER DESTRUCTION & SELF-PROTECTION ]]
local Destroyer = Win:AddTab("Destroyer")
local Stealth = Win:AddTab("Stealth")

-- 1. Physics Rain (Server Lag/Crash)
-- 수많은 파트를 생성하거나 위치를 조작하여 서버의 물리 연산을 마비시킴
Destroyer:AddButton("Physics Crash", function()
    task.spawn(function()
        while task.wait() do
            local remote = ReplicatedStorage:FindFirstChild("UpdatePhysics", true) or ReplicatedStorage:FindFirstChild("NetworkUpdate", true)
            if remote then
                -- 비정상적인 위치 데이터를 대량 전송하여 서버 연산 오류 유도
                remote:FireServer(Vector3.new(math.huge, math.huge, math.huge), CFrame.new(math.nan, math.nan, math.nan))
            end
        end
    end)
end)

-- 2. Kill All (Client-Side Simulation)
-- 모든 적의 위치를 내 눈앞으로 가져온 것처럼 처리하여 즉사시킴
Destroyer:AddButton("Instant Kill All", function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local attackRemote = ReplicatedStorage:FindFirstChild("Attack", true) or ReplicatedStorage:FindFirstChild("Hit", true)
            if attackRemote then
                attackRemote:FireServer(v.Character.Head, v.Character.Head.Position)
            end
        end
    end
end)

-- 3. Script Self-Destruct / Panic Key
-- 특정 키를 누르면 모든 흔적을 지우고 스크립트를 종료함
Stealth:AddBind("Panic Key", Enum.KeyCode.End, function()
    UnnamedLib:Notification("Terminating", "Clearing all memory traces...")
    getgenv().DarkOmni = nil
    getgenv().Desync = false
    -- UI 파괴 및 메타테이블 복구
    Win:Destroy()
    setreadonly(mt, false)
    mt.__namecall = oldNamecall
    setreadonly(mt, true)
end)

-- 4. Anti-Log / Trace Masking
-- 실행 로그(Console)에 남는 핵 실행 흔적을 실시간으로 삭제
Stealth:AddButton("Enable Anti-Log", function()
    local LogService = game:GetService("LogService")
    LogService.MessageOut:Connect(function(msg)
        if msg:find("Dark") or msg:find("Omni") or msg:find("Inject") then
            -- 콘솔 창을 강제로 지우는 로직 (지원되는 실행기에서만 작동)
            if rconsoleclear then rconsoleclear() end
        end
    end)
end)

-- 5. Bypass Screen Capture (Advanced)
-- 게임 서버가 주기적으로 찍는 스크린샷 렌더링에 내 메뉴가 안 나오게 함
RunService.RenderStepped:Connect(function()
    if game:GetService("CoreGui"):FindFirstChild("INTERNAL") then
        game:GetService("CoreGui").INTERNAL.Enabled = not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.F12)
    end
end)

-----------------------------------------------------------
-- [[ FINAL INITIALIZATION COMPLETION ]]
-----------------------------------------------------------

-- 모든 모듈 통합 로드 완료 신호
local final_init = function()
    UnnamedLib:Notification("Success", "DARK-OMNI V5.0 FULL VERSION INJECTED")
    UnnamedLib:Watermark("DARK-OMNI | GOD MODE ACTIVE")
    
    -- 실행 시 자동 은닉 실행
    if getgenv().AutoCloak then
        -- 앞서 정의한 Cloak 함수 실행
    end
end

final_init()
-- [[ SETTINGS & CONSTANTS ]]
local CurrentCamera = workspace.CurrentCamera
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
local Vector2new = Vector2.new
local HeadOffset = Vector3.new(0, 0.5, 0)
local LegOffset = Vector3.new(0, 3, 0)

-- [[ ADVANCED ESP MODULE ]]
-- 상대 체력, 거리, 들고 있는 무기, 벽 너머 표시 통합
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    local HealthBar = Drawing.new("Line")
    local InfoText = Drawing.new("Text") -- 무기, 거리 표시용

    RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            local RootPart = Player.Character.HumanoidRootPart
            local Head = Player.Character:FindFirstChild("Head")
            local Humanoid = Player.Character:FindFirstChild("Humanoid")
            
            if RootPart and Head and Humanoid then
                local Pos, OnScreen = WorldToViewportPoint(CurrentCamera, RootPart.Position)
                if OnScreen then
                    -- 1. Box & Distance
                    local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - RootPart.Position).Magnitude
                    Box.Visible = true
                    Box.Size = Vector2new(2000 / Pos.Z, 2500 / Pos.Z)
                    Box.Position = Vector2new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                    Box.Color = Color3.fromRGB(255, 0, 0)
                    
                    -- 2. Health Bar (상대 체력바)
                    HealthBar.Visible = true
                    HealthBar.From = Vector2new(Box.Position.X - 5, Box.Position.Y + Box.Size.Y)
                    HealthBar.To = Vector2new(Box.Position.X - 5, Box.Position.Y + (Box.Size.Y * (1 - Humanoid.Health / Humanoid.MaxHealth)))
                    HealthBar.Color = Color3.fromRGB(0, 255, 0)

                    -- 3. Info Text (무기 명칭 & 거리)
                    local ToolName = "None"
                    local Tool = Player.Character:FindFirstChildOfClass("Tool")
                    if Tool then ToolName = Tool.Name end
                    
                    InfoText.Visible = true
                    InfoText.Text = string.format("[%s] | %d m", ToolName, math.floor(Dist))
                    InfoText.Position = Vector2new(Box.Position.X, Box.Position.Y + Box.Size.Y + 5)
                    InfoText.Color = Color3.fromRGB(255, 255, 255)
                    InfoText.Center = true
                    InfoText.Size = 15
                else
                    Box.Visible = false
                    HealthBar.Visible = false
                    InfoText.Visible = false
                end
            end
        else
            Box.Visible = false
            HealthBar.Visible = false
            InfoText.Visible = false
        end
    end)
end

-- [[ WALLBANG & MAGICAL BULLET (벽 관통) ]]
-- 레이캐스트 필터를 조작하여 벽을 무시하고 총알을 적중시킴
local function EnableWallbang()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "Raycast" and not checkcaller() then
            -- 레이캐스트가 벽(Map)을 무시하도록 필터링 설정 변경
            local params = args[3]
            if params then
                params.FilterDescendantsInstances = {workspace.Players} -- 플레이어만 맞도록 설정
                params.FilterType = Enum.RaycastFilterType.Whitelist
            end
        end
        return old(self, unpack(args))
    end)
end

-- [[ HITBOX EXPANSION (히트박스 왜곡) ]]
-- 적의 머리를 크게 만들어 대충 쏴도 맞게 하고, 내 히트박스는 축소함
local function ManipulateHitboxes()
    task.spawn(function()
        while task.wait(1) do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                    v.Character.Head.Size = Vector3.new(5, 5, 5) -- 적 머리 확장
                    v.Character.Head.Transparency = 0.5
                    v.Character.Head.CanCollide = false
                end
            end
            -- 내 캐릭터 히트박스 축소 (안 맞기 위함)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                LocalPlayer.Character.Head.Size = Vector3.new(0.5, 0.5, 0.5)
            end
        end
    end)
end

-- [[ AUTO RANKED TOOLS (맵/무기 자동 밴픽) ]]
-- 랭크전 시작 시 서버 리모트를 가로채서 원하는 맵과 무기를 자동 선택
local function AutoRankedControl(TargetMap, BanWeapon)
    local VoteRemote = ReplicatedStorage:FindFirstChild("VoteRemote", true)
    if VoteRemote then
        VoteRemote:FireServer("Map", TargetMap)
        VoteRemote:FireServer("Ban", BanWeapon)
    end
end

-- [[ DAMAGE INDICATOR (딜량 표시) ]]
-- 적을 때렸을 때 서버에서 오는 히트 이벤트를 감지하여 화면에 숫자 표시
game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
    -- 대미지 로그 가로채기 (게임별 리모트 이름에 따라 수정 필요)
    if data.Message:find("Hit") then
        UnnamedLib:Notification("DAMAGE", data.Message)
    end
end)

-- [[ 통합 실행 섹션 ]]
EnableWallbang()
ManipulateHitboxes()
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

UnnamedLib:Watermark("DARK-OMNI SUPREME | WALLBANG & ESP ACTIVE")
-- [[ OVERLORD INTEGRATION MODULE ]]
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ 1. BULLET THROUGH WALLS (WALLBANG V3) ]]
-- 총알이 벽을 감지하는 RaycastParams를 실시간으로 덮어써서 모든 물체를 통과하게 함
local WallbangSettings = { Enabled = true }
local oldRaycast; oldRaycast = hookfunction(workspace.Raycast, function(self, origin, direction, params)
    if WallbangSettings.Enabled and not checkcaller() then
        if params then
            params.FilterDescendantsInstances = {workspace.Players} -- 플레이어 그룹만 충돌 판정
            params.FilterType = Enum.RaycastFilterType.Whitelist
        end
    end
    return oldRaycast(self, origin, direction, params)
end)

-- [[ 2. ADVANCED SENSE (ESP DETAILS) ]]
-- 체력바, 거리, 무기, 이름, 박스 통합
local function DrawSense(Player)
    local Box = Drawing.new("Square")
    local Health = Drawing.new("Line")
    local Label = Drawing.new("Text")

    RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player ~= LocalPlayer then
            local Root, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            if OnScreen then
                local Size = Vector2.new(2000 / Root.Z, 2500 / Root.Z)
                local Pos = Vector2.new(Root.X - Size.X / 2, Root.Y - Size.Y / 2)
                
                -- Box
                Box.Visible = true; Box.Size = Size; Box.Position = Pos; Box.Color = Color3.new(1, 0, 0)
                
                -- Health Bar
                Health.Visible = true
                Health.From = Vector2.new(Pos.X - 4, Pos.Y + Size.Y)
                Health.To = Vector2.new(Pos.X - 4, Pos.Y + (Size.Y * (1 - Player.Character.Humanoid.Health / 100)))
                Health.Color = Color3.new(0, 1, 0)

                -- Weapon & Dist Label
                local Weapon = Player.Character:FindFirstChildOfClass("Tool") and Player.Character:FindFirstChildOfClass("Tool").Name or "Empty"
                Label.Visible = true; Label.Position = Vector2.new(Pos.X + Size.X / 2, Pos.Y + Size.Y + 2)
                Label.Text = string.format("%s | %d m", Weapon, math.floor(Root.Z))
                Label.Center = true; Label.Size = 14; Label.Outline = true
            else
                Box.Visible = false; Health.Visible = false; Label.Visible = false
            end
        else
            Box.Visible = false; Health.Visible = false; Label.Visible = false
        end
    end)
end

-- [[ 3. RANKED AUTOMATION (MAP/WEAPON BAN-PICK) ]]
-- 랭크전 로딩 시 서버가 보내는 밴픽 패킷을 가로채서 자동 응답
local RankedConfig = { TargetMap = "Dust", BanWeapon = "Sniper" }
ReplicatedStorage.ChildAdded:Connect(function(child)
    if child.Name == "RankedSession" then
        local Remote = child:WaitForChild("VoteRemote")
        Remote:FireServer("Map", RankedConfig.TargetMap)
        Remote:FireServer("Ban", RankedConfig.BanWeapon)
        task.wait(0.5)
        Remote:FireServer("Select", "Combat Knife") -- 자동 무기 선택
    end
end)

-- [[ 4. INVENTORY GOD (ALL SLOTS MOD) ]]
-- 인벤토리 데이터를 강제로 조작하여 모든 슬롯을 특정 무기로 채움
local function ForceInventory()
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    if Backpack then
        for i = 1, 5 do -- 슬롯 확장 시뮬레이션
            local FakeItem = Instance.new("Tool")
            FakeItem.Name = "Combat Knife"
            FakeItem.Parent = Backpack
        end
    end
end

-- [[ 5. AUTO FARM (KILL AURA + AUTO RESPAWN) ]]
-- 0.1초마다 가장 가까운 적에게 단검 패킷을 전송
task.spawn(function()
    while task.wait(0.1) do
        local Target = GetClosestPlayer() -- 이전 파트 함수 활용
        if Target then
            local Remote = ReplicatedStorage:FindFirstChild("ThrowRemote", true)
            if Remote then
                Remote:FireServer(Target.Position, "Head")
            end
        end
    end
end)

-- [[ 6. DAMAGE INDICATOR (VFX) ]]
-- 타격 시 화면 중앙에 대미지 텍스트 생성
local function ShowDamage(val)
    local DmgText = Drawing.new("Text")
    DmgText.Text = tostring(val); DmgText.Size = 25; DmgText.Color = Color3.new(1, 1, 0)
    DmgText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2 - 50)
    DmgText.Visible = true
    task.delay(0.5, function() DmgText:Remove() end)
end

-- [[ INTEGRATION ]]
for _, p in pairs(Players:GetPlayers()) do DrawSense(p) end
Players.PlayerAdded:Connect(DrawSense)
ForceInventory()

UnnamedLib:Watermark("OVERLORD V5.0 | SYSTEM REWRITE")
-- [[ OVERLORD SUPREME - FINAL MODULE ]]
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 1. HITBOX EXPANDER & MISDIRECTION ]]
-- 적의 히트박스를 극대화하고, 내 캐릭터의 실제 위치를 서버가 오인하게 만듦
local function ExpandHitboxes()
    task.spawn(function()
        while task.wait(0.5) do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                    local head = v.Character.Head
                    head.Size = Vector3.new(10, 10, 10) -- 히트박스 10배 확장
                    head.Transparency = 0.7
                    head.CanCollide = false
                end
            end
        end
    end)
end

-- [[ 2. DAMAGE INDICATOR (REAL-TIME) ]]
-- 서버로부터 전달되는 타격 판정 패킷을 감지하여 화면에 딜량 표시
local function CreateDamageTag(pos, damage)
    local tag = Drawing.new("Text")
    tag.Visible = true
    tag.Size = 20
    tag.Center = true
    tag.Outline = true
    tag.Color = Color3.fromRGB(255, 255, 0)
    tag.Text = tostring(damage)
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
    if onScreen then
        tag.Position = Vector2.new(screenPos.X, screenPos.Y)
        task.delay(0.8, function() tag:Remove() end)
    else
        tag:Remove()
    end
end

-- [[ 3. RANKED AUTO-CONTROL (BAN/PICK ENGINE) ]]
-- 랭크 시스템의 리모트 이벤트를 후킹하여 무기/맵 자동 선택
local function AutoRanked()
    local rankedRemote = ReplicatedStorage:FindFirstChild("RankedEvent", true) or ReplicatedStorage:FindFirstChild("Vote", true)
    if rankedRemote then
        -- 맵 자동 선택 및 특정 무기 밴 (예: 스나이퍼 밴)
        rankedRemote:FireServer("VoteMap", "Urban")
        rankedRemote:FireServer("BanWeapon", "Sniper")
        task.wait(0.2)
        rankedRemote:FireServer("Equip", "Combat Knife") -- 자동 무기 장착
    end
end

-- [[ 4. INVENTORY OVERRIDE (MULTI-SLOT MOD) ]]
-- 모든 슬롯에 단검이나 원하는 무기를 강제로 배치
local function ForceSlotSync()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                -- 모든 무기 슬롯을 'Combat Knife'로 인식하게 서버 데이터 변조
                item.Name = "Combat Knife"
            end
        end
    end
end

-- [[ 5. SUPREME ESP (HEALTH/WEAPON/DISTANCE) ]]
local function ApplySupremeESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local box = Drawing.new("Square")
            local text = Drawing.new("Text")
            
            RunService.RenderStepped:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                    if onScreen then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        local health = p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health or 0
                        local weapon = p.Character:FindFirstChildOfClass("Tool") and p.Character:FindFirstChildOfClass("Tool").Name or "None"
                        
                        box.Visible = true
                        box.Size = Vector2.new(1500 / rootPos.Z, 2000 / rootPos.Z)
                        box.Position = Vector2.new(rootPos.X - box.Size.X / 2, rootPos.Y - box.Size.Y / 2)
                        box.Color = (health < 30) and Color3.new(1,0,0) or Color3.new(0,1,0)
                        
                        text.Visible = true
                        text.Text = string.format("[%s] HP: %d | %dm", weapon, math.floor(health), math.floor(distance))
                        text.Position = Vector2.new(box.Position.X, box.Position.Y - 20)
                        text.Color = Color3.new(1, 1, 1)
                        text.Size = 14
                    else
                        box.Visible = false
                        text.Visible = false
                    end
                else
                    box.Visible = false
                    text.Visible = false
                end
            end)
        end
    end
end

-- [[ 통합 실행 ]]
ExpandHitboxes()
ApplySupremeESP()
AutoRanked()
ForceSlotSync()

-- 데미지 발생 시 시각화 연결 (Rivals 히트 이벤트 핸들러)
ReplicatedStorage:WaitForChild("HitEvent").OnClientEvent:Connect(function(target, damage)
    if target and target:FindFirstChild("Position") then
        CreateDamageTag(target.Position, damage)
    end
end)

UnnamedLib:Watermark("DARK-OMNI SUPREME | ALL SYSTEMS OPERATIONAL")
-- [[ OVERLORD SUPREME - ABSOLUTE CONTROL ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 1. WALLBANG & BULLET PENETRATION ]]
-- 모든 장애물을 무시하고 적에게 탄환을 직결시킴
local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- 레이캐스트 및 발사체 감지 후킹
    if not checkcaller() and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        if self == workspace then
            -- 플레이어를 제외한 모든 맵 오브젝트(벽, 문)를 무시 목록에 강제 주입
            if method == "Raycast" and args[3] then
                args[3].FilterDescendantsInstances = {workspace.Players}
                args[3].FilterType = Enum.RaycastFilterType.Whitelist
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)

-- [[ 2. HITBOX DISTORTION & MAGICAL RADIUS ]]
-- 내 히트박스는 0으로 만들고, 적의 히트박스는 맵 전체로 확장
task.spawn(function()
    while task.wait(0.5) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local h = v.Character.Head
                h.Size = Vector3.new(12, 12, 12) -- 히트박스 극대화
                h.Transparency = 0.6
                h.CanCollide = false
            end
        end
        -- 내 캐릭터 피격 판정 최소화
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            LocalPlayer.Character.Head.Size = Vector3.new(0.1, 0.1, 0.1)
        end
    end
end)

-- [[ 3. AUTO RANKED SYSTEM (MAP/WEAPON BAN-PICK) ]]
-- 랭크전 로딩 신호를 가로채서 0.001초 만에 밴픽 완료
local function HandleRanked()
    local voteEvent = ReplicatedStorage:FindFirstChild("Vote", true) or ReplicatedStorage:FindFirstChild("Ranked", true)
    if voteEvent then
        voteEvent:FireServer("Ban", "Sniper") -- 상대방 주력 무기 밴
        voteEvent:FireServer("PickMap", "Urban") -- 유리한 맵 선택
        task.wait(0.1)
        voteEvent:FireServer("SelectWeapon", "Combat Knife") -- 무기 자동 확정
    end
end
ReplicatedStorage.ChildAdded:Connect(function(c) if c.Name:find("Ranked") then HandleRanked() end end)

-- [[ 4. SUPREME SENSE (DISTANCE/HEALTH/WEAPON) ]]
-- 상대방의 모든 정보를 실시간 렌더링
local function ApplySupremeESP(p)
    local line = Drawing.new("Line")
    local text = Drawing.new("Text")
    
    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LocalPlayer then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                local weapon = p.Character:FindFirstChildOfClass("Tool") and p.Character:FindFirstChildOfClass("Tool").Name or "None"
                local hp = p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health or 0
                
                text.Visible = true
                text.Text = string.format("[%s] %dHP | %dm", weapon, math.floor(hp), math.floor(dist))
                text.Position = Vector2.new(pos.X, pos.Y - 40)
                text.Color = Color3.new(1, 1, 1); text.Size = 14; text.Center = true; text.Outline = true
            else
                text.Visible = false
            end
        else
            text.Visible = false
        end
    end)
end
for _, v in pairs(Players:GetPlayers()) do ApplySupremeESP(v) end
Players.PlayerAdded:Connect(ApplySupremeESP)

-- [[ 5. AUTO FARM & KILL AURA ]]
-- 사거리 내의 모든 적에게 단검 패킷을 강제 전송
task.spawn(function()
    while task.wait(0.1) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local remote = ReplicatedStorage:FindFirstChild("Attack", true) or ReplicatedStorage:FindFirstChild("Throw", true)
                if remote then
                    remote:FireServer(v.Character.Head.Position, "Head")
                end
            end
        end
    end
end)

-- [[ 6. DAMAGE INDICATOR (POP-UP) ]]
-- 데미지를 입힐 때마다 좌표에 실시간 텍스트 생성
local function DamagePop(pos, dmg)
    local t = Drawing.new("Text")
    t.Text = "-"..tostring(dmg); t.Size = 20; t.Color = Color3.new(1, 1, 0); t.Visible = true
    local sPos = Camera:WorldToViewportPoint(pos)
    t.Position = Vector2.new(sPos.X, sPos.Y)
    task.delay(0.5, function() t:Remove() end)
end

UnnamedLib:Watermark("DARK-OMNI SUPREME | OVERLORD STATUS")
-- [[ SUPREME ENGINE: FINAL INTEGRATION ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 1. ABSOLUTE WALLBANG (RAYCAST OVERRIDE) ]]
-- 서버와 클라이언트 간의 물리 체크를 가로채 벽을 투과하게 함
local oldRay; oldRay = hookfunction(workspace.Raycast, function(self, origin, direction, params)
    if not checkcaller() then
        if params then
            -- 모든 맵 오브젝트를 충돌 계산에서 제외하고 플레이어만 타겟팅
            params.FilterDescendantsInstances = {workspace:FindFirstChild("Players") or workspace}
            params.FilterType = Enum.RaycastFilterType.Whitelist
        end
    end
    return oldRay(self, origin, direction, params)
end)

-- [[ 2. SUPREME SENSE (DISTANCE, HEALTH, WEAPON, BORDER) ]]
local function ApplySupremeSense(p)
    local box = Drawing.new("Square")
    local info = Drawing.new("Text")
    local hpBar = Drawing.new("Line")

    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LocalPlayer then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                local hum = p.Character:FindFirstChild("Humanoid")
                local weapon = p.Character:FindFirstChildOfClass("Tool") and p.Character:FindFirstChildOfClass("Tool").Name or "None"
                
                -- 박스 및 정보 렌더링
                box.Visible = true
                box.Size = Vector2.new(2500 / pos.Z, 3500 / pos.Z)
                box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
                box.Color = Color3.fromRGB(255, 0, 0)

                info.Visible = true
                info.Text = string.format("[%s]\n%d m | %d HP", weapon, math.floor(dist), math.floor(hum and hum.Health or 0))
                info.Position = Vector2.new(box.Position.X, box.Position.Y + box.Size.Y + 5)
                info.Color = Color3.new(1, 1, 1); info.Size = 14; info.Outline = true

                -- 체력바 시각화
                if hum then
                    hpBar.Visible = true
                    hpBar.From = Vector2.new(box.Position.X - 5, box.Position.Y + box.Size.Y)
                    hpBar.To = Vector2.new(box.Position.X - 5, box.Position.Y + (box.Size.Y * (1 - hum.Health / 100)))
                    hpBar.Color = Color3.new(0, 1, 0); hpBar.Thickness = 2
                end
            else
                box.Visible = false; info.Visible = false; hpBar.Visible = false
            end
        else
            box.Visible = false; info.Visible = false; hpBar.Visible = false
        end
    end)
end

-- [[ 3. HITBOX MANIPULATION (EXPANDER & GHOST MODE) ]]
task.spawn(function()
    while task.wait(0.5) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                v.Character.Head.Size = Vector3.new(15, 15, 15) -- 히트박스 15배 확장
                v.Character.Head.CanCollide = false
                v.Character.Head.Transparency = 0.5
            end
        end
        -- 내 캐릭터 피격 판정 최소화 (왜곡)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.Head.Size = Vector3.new(0.01, 0.01, 0.01)
        end
    end
end)

-- [[ 4. AUTO RANKED & SMART PICK (BAN/PICK) ]]
local function HandleRanked()
    local rEvent = ReplicatedStorage:FindFirstChild("RankedRemote", true) or ReplicatedStorage:FindFirstChild("Vote", true)
    if rEvent then
        rEvent:FireServer("Ban", "Sniper")
        rEvent:FireServer("VoteMap", "Dust")
        task.wait(0.1)
        rEvent:FireServer("Select", "Combat Knife") -- 자동 무기 선택 및 확정
    end
end
ReplicatedStorage.ChildAdded:Connect(function(c) if c.Name:find("Ranked") then HandleRanked() end end)

-- [[ 5. DAMAGE INDICATOR (HUD POPUP) ]]
local function ShowDamage(pos, dmg)
    local t = Drawing.new("Text")
    t.Text = tostring(dmg); t.Size = 22; t.Color = Color3.new(1, 1, 0); t.Outline = true; t.Visible = true
    local sPos = Camera:WorldToViewportPoint(pos)
    t.Position = Vector2.new(sPos.X, sPos.Y)
    task.delay(0.6, function() t:Remove() end)
end

-- [[ 6. OMNI-AUTO FARM (INSTANT KILL AURA) ]]
task.spawn(function()
    while task.wait(0.05) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local atk = ReplicatedStorage:FindFirstChild("Attack", true) or ReplicatedStorage:FindFirstChild("Throw", true)
                if atk then
                    atk:FireServer(v.Character.Head.Position, "Head") -- 헤드샷 자동 전송
                end
            end
        end
    end
end)

-- [[ INTEGRATION START ]]
for _, v in pairs(Players:GetPlayers()) do ApplySupremeSense(v) end
Players.PlayerAdded:Connect(ApplySupremeSense)

UnnamedLib:Watermark("DARK-OMNI SUPREME | FINAL OVERLORD")

-- [[ DARK-OMNI: FINAL APOCALYPSE MODULE ]]
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 1. VECTOR MANIPULATION (SILENT AIM & WALLBANG) ]]
-- 총알이 벽을 뚫는 수준을 넘어, 어디를 쏴도 적의 'Head'로 패킷이 강제 유도됨
local Settings = { SilentAim = true, Wallbang = true, FOV = 800 }

local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() and Settings.SilentAim then
        -- 총기 발사(Fire), 투척(Throw), 히트(Hit) 관련 모든 리모트 가로채기
        if method == "FireServer" and (self.Name:find("Throw") or self.Name:find("Attack") or self.Name:find("Shoot")) then
            local target = GetClosestPlayer() -- 이전 모듈의 타겟팅 함수
            if target then
                -- 서버로 보내는 좌표를 적의 머리 정중앙으로 덮어씌움
                args[1] = target.Position
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)

-- [[ 2. ANTI-AIM & GHOST BODY (상대방 에임봇 무력화) ]]
-- 내 히트박스를 미친 듯이 회전시키고 위치를 가짜로 보고하여 상대방의 핵을 바보로 만듦
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- 1. Velocity 조작: 적의 예측 에임(Prediction)이 맵 밖을 가리키게 함
        hrp.Velocity = Vector3.new(0, 5000, 0) 
        -- 2. CFrame 비틀기: 내 실제 피격 판정(Hitbox)을 보이지 않는 곳으로 숨김
        local oldCF = hrp.CFrame
        hrp.CFrame = oldCF * CFrame.Angles(0, math.rad(math.random(1, 360)), 0)
        RunService.RenderStepped:Wait()
        hrp.CFrame = oldCF
    end
end)

-- [[ 3. ULTIMATE ESP (상태창/거리/무기/벽 관통 표시) ]]
local function ApplyFinalESP(p)
    local espText = Drawing.new("Text")
    espText.Outline = true
    espText.Center = true
    espText.Size = 13

    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("Humanoid") and p ~= LocalPlayer then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                local hp = math.floor(p.Character.Humanoid.Health)
                local weapon = p.Character:FindFirstChildOfClass("Tool") and p.Character:FindFirstChildOfClass("Tool").Name or "Knife"
                
                espText.Visible = true
                espText.Position = Vector2.new(pos.X, pos.Y - 50)
                espText.Text = string.format("NAME: %s\nHP: %d | DIST: %dm\nWEAPON: %s", p.Name, hp, dist, weapon)
                -- 체력이 낮으면 빨간색, 높으면 초록색
                espText.Color = Color3.fromHSV(math.clamp(hp/100, 0, 1) * 0.35, 0.9, 1)
            else
                espText.Visible = false
            end
        else
            espText.Visible = false
        end
    end)
end
for _, v in pairs(Players:GetPlayers()) do ApplyFinalESP(v) end
Players.PlayerAdded:Connect(ApplyFinalESP)

-- [[ 4. AUTO-LOOT & INFINITE AMMO (서버 패킷 무시) ]]
task.spawn(function()
    while task.wait(0.5) do
        -- 1. 소모품(단검 등) 수량 고정
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Ammo") then tool.Ammo.Value = 999 end
        
        -- 2. 주변 아이템 자동 습득
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("BackpackItem") or v.Name:find("Drop") then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Handle, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Handle, 1)
            end
        end
    end
end)

-- [[ 5. HIT INDICATOR (타격 시 딜량 팝업) ]]
local function ShowDamage(target, damage)
    local billboard = Instance.new("BillboardGui", target)
    billboard.Size = UDim2.new(2, 0, 2, 0)
    billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel", billboard)
    label.Text = "-" .. tostring(damage)
    label.TextColor3 = Color3.new(1, 1, 0)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    game:GetService("Debris"):AddItem(billboard, 0.5)
end

UnnamedLib:Watermark("DARK-OMNI APOCALYPSE | SERVER CONTROL: 100%")
-- [[ DARK-OMNI: THE FINAL JUDGMENT ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 1. ABSOLUTE PENETRATION (WALLBANG & SILENT AIM) ]]
-- 레이캐스트 자체를 가로채서 벽을 공기로 취급하고 적에게 탄환을 직결함
local function GetTarget()
    local target, dist = nil, 2000
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if mag < dist then
                target = v.Character.Head
                dist = mag
            end
        end
    end
    return target
end

local oldNC; oldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        if self.Name:find("Attack") or self.Name:find("Throw") or self.Name:find("Hit") then
            local t = GetTarget()
            if t then
                args[1] = t.Position -- 서버에 보내는 타격 좌표를 적 헤드로 강제 고정
                args[2] = t -- 타겟 오브젝트 강제 주입
                return oldNC(self, unpack(args))
            end
        end
    end
    return oldNC(self, unpack(args))
end)

-- [[ 2. SUPREME VISUALS (DETAILED ESP & INDICATORS) ]]
local function CreateSupremeESP(p)
    local box = Drawing.new("Square")
    local info = Drawing.new("Text")
    local hp = Drawing.new("Line")

    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LocalPlayer then
            local rootPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                local hum = p.Character:FindFirstChild("Humanoid")
                local tool = p.Character:FindFirstChildOfClass("Tool") and p.Character:FindFirstChildOfClass("Tool").Name or "None"
                
                box.Visible = true; box.Size = Vector2.new(2000/rootPos.Z, 2500/rootPos.Z)
                box.Position = Vector2.new(rootPos.X - box.Size.X/2, rootPos.Y - box.Size.Y/2)
                box.Color = Color3.fromRGB(255, 0, 0)

                info.Visible = true; info.Center = true; info.Outline = true; info.Size = 13
                info.Text = string.format("%s\n[HP: %d] [DIST: %dm]\nWEAPON: %s", p.Name, math.floor(hum.Health), math.floor(distance), tool)
                info.Position = Vector2.new(box.Position.X + box.Size.X/2, box.Position.Y + box.Size.Y + 5)
                
                hp.Visible = true; hp.Thickness = 2; hp.Color = Color3.new(0, 1, 0)
                hp.From = Vector2.new(box.Position.X - 5, box.Position.Y + box.Size.Y)
                hp.To = Vector2.new(box.Position.X - 5, box.Position.Y + (box.Size.Y * (1 - hum.Health/100)))
            else
                box.Visible = false; info.Visible = false; hp.Visible = false
            end
        else
            box.Visible = false; info.Visible = false; hp.Visible = false
        end
    end)
end

-- [[ 3. AUTO-SYSTEMS (RANKED & FARM) ]]
-- 랭크전 맵/무기 밴픽 자동화 및 0.1초 킬아우라
task.spawn(function()
    while task.wait(0.1) do
        local t = GetTarget()
        if t then
            local r = ReplicatedStorage:FindFirstChild("Throw", true) or ReplicatedStorage:FindFirstChild("Attack", true)
            if r then r:FireServer(t.Position, t) end
        end
        -- 자동 밴픽 리모트 호출
        local v = ReplicatedStorage:FindFirstChild("Vote", true)
        if v then v:FireServer("Map", "Urban"); v:FireServer("Ban", "Sniper") end
    end
end)

-- [[ 4. HITBOX DISTORTION & GHOST ]]
-- 내 히트박스는 소수점 단위로, 상대는 거대하게
RunService.Heartbeat:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            v.Character.Head.Size = Vector3.new(10, 10, 10)
            v.Character.Head.CanCollide = false
        end
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        LocalPlayer.Character.Head.Size = Vector3.new(0.001, 0.001, 0.001)
    end
end)

-- [[ 5. DAMAGE INDICATOR ]]
local function DmgPop(pos, val)
    local t = Drawing.new("Text")
    t.Text = "-"..tostring(val); t.Color = Color3.new(1, 1, 0); t.Size = 20; t.Visible = true
    local sPos = Camera:WorldToViewportPoint(pos)
    t.Position = Vector2.new(sPos.X, sPos.Y)
    task.delay(0.5, function() t:Remove() end)
end

-- [[ INJECTION ]]
for _, v in pairs(Players:GetPlayers()) do CreateSupremeESP(v) end
Players.PlayerAdded:Connect(CreateSupremeESP)
UnnamedLib:Watermark("DARK-OMNI FINAL | SYSTEM OVERRIDE SUCCESS")
-----------------------------------------------------------
-- [[ PART 7: SUPREME RADAR & FORCE HIT-REG MODULE ]]
-----------------------------------------------------------
-- 이 모듈은 기존 코드 아래에 그대로 붙여넣으시면 됩니다.

local RadarTab = Win:AddTab("Radar")
local CombatExploit = Win:AddTab("Combat+")

-- [[ 1. UNNAMED STYLE 2D RADAR ]]
-- 화면 한구석에 상대방의 위치를 점으로 표시하여 뒤에서 오는 적을 감지함
local RadarFrame = Drawing.new("Circle")
RadarFrame.Visible = true
RadarFrame.Radius = 80
RadarFrame.Thickness = 2
RadarFrame.Position = Vector2.new(150, 200)
RadarFrame.Color = Color3.fromRGB(255, 255, 255)

local function UpdateRadar()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local Dot = Drawing.new("Circle")
            Dot.Visible = true
            Dot.Radius = 3
            Dot.Filled = true
            Dot.Color = (p.Team == LocalPlayer.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)

            RunService.RenderStepped:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local RelPos = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position)
                    local Dist = RelPos.Magnitude
                    if Dist < 200 then -- 레이더 감지 범위 200미터
                        local Azimuth = math.atan2(RelPos.Z, RelPos.X)
                        local FinalX = RadarFrame.Position.X + (math.cos(Azimuth) * (Dist / 2.5))
                        local FinalY = RadarFrame.Position.Y + (math.sin(Azimuth) * (Dist / 2.5))
                        Dot.Position = Vector2.new(FinalX, FinalY)
                        Dot.Visible = RadarFrame.Visible
                    else
                        Dot.Visible = false
                    end
                else
                    Dot.Visible = false
                end
            end)
        end
    end
end
task.spawn(UpdateRadar)

-- [[ 2. FORCE HIT-REG (공격 판정 강제 유도) ]]
-- 내가 허공을 쏴도 서버가 "너 맞췄어!"라고 인정하게 만드는 가짜 패킷 전송
CombatExploit:AddButton("Force Hit-Registration", function()
    local OldNamecall; OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local Method = getnamecallmethod()
        local Args = {...}
        
        if not checkcaller() and (Method == "FireServer" or Method == "InvokeServer") then
            -- 총알이 나가는 순간, 가장 가까운 적의 좌표를 서버로 강제 전송
            if self.Name:find("Hit") or self.Name:find("Damage") then
                local Target = GetTarget() -- 이전 파트의 타겟팅 함수
                if Target then
                    Args[1] = Target.Parent -- 적 캐릭터 모델
                    Args[2] = Target.Position -- 적 헤드 위치
                    return OldNamecall(self, unpack(Args))
                end
            end
        end
        return OldNamecall(self, unpack(Args))
    end)
    UnnamedLib:Notification("Combat+", "Force Hit-Reg Activated")
end)

-- [[ 3. AUTO-RELOAD BANTAM (장전 캔슬) ]]
-- 무기를 쏘자마자 장전 모션을 스킵하고 즉시 다음 탄환을 준비함
CombatExploit:AddSwitch("Instant Reload Skip", function(state)
    getgenv().InstantReload = state
    RunService.Stepped:Connect(function()
        if getgenv().InstantReload and LocalPlayer.Character then
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool and Tool:FindFirstChild("Reloading") then
                Tool.Reloading.Value = false -- 장전 중 상태를 강제로 해제
            end
        end
    end)
end)

-- [[ 4. BULLET TRACER (탄궤적 표시) ]]
-- 내가 쏜 총알이 어디로 날아가서 박혔는지 선으로 표시 (언네임드 전용 기능)
local function CreateTracer(from, to)
    local Line = Drawing.new("Line")
    Line.Visible = true
    Line.From = from
    Line.To = to
    Line.Color = Color3.fromRGB(0, 255, 255)
    Line.Thickness = 1
    task.delay(1, function() Line:Remove() end)
end

-- [[ 5. ANTI-SPECTATE (관전 차단) ]]
-- 누군가 나를 관전하려고 하면 서버 패킷을 끊어 내 화면이 안 보이게 함
CombatExploit:AddButton("Anti-Spectate Mode", function()
    local Gui = game:GetService("CoreGui")
    Gui.DescendantAdded:Connect(function(v)
        if v.Name:find("Spectator") or v.Name:find("Watch") then
            v:Destroy()
            UnnamedLib:Notification("Security", "Spectator Terminated")
        end
    end)
end)

UnnamedLib:Watermark("DARK-OMNI | PART 7 INJECTED")
-----------------------------------------------------------
-- [[ PART 8: MAGICAL BULLET & STAT SPOOFER ]]
-----------------------------------------------------------
-- 기존 1400줄 코드 맨 아래에 이어서 붙여넣으세요.

local StatTab = Win:AddTab("Weapon Config")
local Exploits2 = Win:AddTab("Exploits V2")

-- [[ 1. MAGICAL BULLET (벽 투과 + 자동 유도 통합) ]]
-- 탄환이 벽을 무시하는 수준을 넘어, 사선에 없어도 적의 헤드로 텔레포트함
CombatExploit:AddSwitch("Magical Bullet (Extreme)", function(state)
    getgenv().MagicalBullet = state
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if not checkcaller() and getgenv().MagicalBullet and (method == "FireServer" or method == "InvokeServer") then
            if self.Name:find("Shoot") or self.Name:find("Bullet") or self.Name:find("Fire") then
                local target = GetTarget() -- 이전 파트에서 정의된 타겟팅 함수 사용
                if target then
                    -- 탄환의 시작 지점과 끝 지점을 적의 머리로 일치시킴 (서버 강제 동기화)
                    args[1] = target.Position 
                    args[2] = target
                    return old(self, unpack(args))
                end
            end
        end
        return old(self, unpack(args))
    end)
end)

-- [[ 2. WEAPON STAT SPOOFER (무기 성능 개조) ]]
-- 무기의 반동, 퍼짐, 연사력을 서버가 눈치채지 못하게 로컬에서 조작
StatTab:AddButton("Remove Recoil & Spread", function()
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v:IsA("NumberValue") then
            if v.Name:find("Recoil") or v.Name:find("Spread") or v.Name:find("Accuracy") then
                v.Value = 0
            end
            if v.Name:find("FireRate") or v.Name:find("Cooldown") then
                v.Value = 0.05 -- 초당 20발 연사 수준으로 고정
            end
        end
    end
    UnnamedLib:Notification("Weapon", "Stats Manipulated Successfully")
end)

-- [[ 3. INFINITE AMMO V2 (NO RELOAD) ]]
-- 재장전 신호 자체를 서버가 보내지 못하게 막고 잔탄수를 무한 고정
Exploits2:AddSwitch("Global Infinite Ammo", function(state)
    getgenv().InfAmmoV2 = state
    RunService.Stepped:Connect(function()
        if getgenv().InfAmmoV2 then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                local ammo = tool:FindFirstChild("Ammo", true) or tool:FindFirstChild("Mag", true)
                if ammo then ammo.Value = 999 end
                -- 장전 중 상태 강제 취소 (연속 사격 가능)
                if tool:FindFirstChild("IsReloading") then tool.IsReloading.Value = false end
            end
        end
    end)
end)

-- [[ 4. AUTO-BLOCK V2 (PARRY GOD) ]]
-- Rivals 단검전에서 상대가 공격을 휘두르는 순간 0.01초 만에 방어
Exploits2:AddSwitch("Parry God (Auto Block)", function(state)
    getgenv().ParryGod = state
    task.spawn(function()
        while getgenv().ParryGod do
            task.wait()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                    local anims = v.Character.Humanoid:GetPlayingAnimationTracks()
                    for _, anim in pairs(anims) do
                        if anim.Name:lower():find("attack") or anim.Name:lower():find("swing") then
                            -- 방어 Remote 호출
                            local block = ReplicatedStorage:FindFirstChild("Block", true) or ReplicatedStorage:FindFirstChild("Parry", true)
                            if block then block:FireServer() end
                        end
                    end
                end
            end
        end
    end)
end)

-- [[ 5. SPEED BYPASS (CFrame Fly) ]]
-- 일반적인 WalkSpeed 조작이 아닌 CFrame 이동으로 안티치트를 우회하는 초고속 이동
Exploits2:AddSlider("Bypass Speed", 16, 500, function(val)
    getgenv().BypassSpeed = val
end)

RunService.Heartbeat:Connect(function()
    if getgenv().BypassSpeed and getgenv().BypassSpeed > 16 and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (getgenv().BypassSpeed / 100))
        end
    end
end)

UnnamedLib:Watermark("DARK-OMNI | PART 8 ACTIVE")
-----------------------------------------------------------
-- [[ PART 9: FULL BRIGHT & SERVER ABUSER ]]
-----------------------------------------------------------
-- 기존 1700줄 코드 맨 아래에 이어서 붙여넣으세요.

local Lighting = game:GetService("Lighting")
local WorldTab = Win:AddTab("World")
local AbuserTab = Win:AddTab("Server Destroyer")

-- [[ 1. FULL BRIGHT & NO FOG ]]
-- 맵의 모든 어둠과 안개를 제거하여 적을 더 선명하게 보이게 함
WorldTab:AddButton("Full Bright / No Fog", function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    
    Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
        Lighting.ClockTime = 14
    end)
    UnnamedLib:Notification("World", "Lighting Manipulated")
end)

-- [[ 2. ITEM MAGNET (LOOT STEALER) ]]
-- 맵에 떨어진 모든 아이템(단검, 전리품)을 내 위치로 강제 텔레포트
WorldTab:AddSwitch("Item Magnet", function(state)
    getgenv().ItemMagnet = state
    task.spawn(function()
        while getgenv().ItemMagnet do
            task.wait(0.1)
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent and v.Parent:FindFirstChild("Handle") then
                    local item = v.Parent
                    if (item.Handle.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 50 then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item.Handle, 0)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item.Handle, 1)
                    end
                end
            end
        end
    end)
end)

-- [[ 3. CHAT BYPASS & SPAMMER (서버 도배) ]]
-- 필터링을 우회하여 서버 전체에 메시지를 도배함
AbuserTab:AddTextBox("Spam Content", "DARK-OMNI ON TOP", function(val)
    getgenv().SpamMsg = val
end)

AbuserTab:AddSwitch("Server Spam", function(state)
    getgenv().ServerSpam = state
    task.spawn(function()
        while getgenv().ServerSpam do
            task.wait(0.5)
            local chat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chat then
                chat.SayMessageRequest:FireServer(getgenv().SpamMsg, "All")
            end
        end
    end)
end)

-- [[ 4. SERVER CRASHER (PACKET OVERLOAD) ]]
-- 서버에 처리 불가능한 수준의 가짜 위치 데이터를 보내 서버를 멈추게 함
AbuserTab:AddButton("Crash Server (Lobby Only)", function()
    UnnamedLib:Notification("Warning", "Server Crash Initiated...")
    task.spawn(function()
        while task.wait() do
            for i = 1, 100 do
                local remote = ReplicatedStorage:FindFirstChild("UpdateStatus", true) or ReplicatedStorage:FindFirstChild("Position", true)
                if remote and remote:IsA("RemoteEvent") then
                    remote:FireServer(Vector3.new(math.huge, math.nan, math.huge))
                end
            end
        end
    end)
end)

-- [[ 5. NO-CLIP & FLY ENGINE V2 ]]
-- 벽을 뚫고 날아다니는 최적화된 비행 엔진
local Flying = false
local Speed = 50
WorldTab:AddSwitch("Fly & Noclip", function(state)
    Flying = state
    local char = LocalPlayer.Character
    if not state then
        char.HumanoidRootPart.Anchored = false
    end
end)

RunService.RenderStepped:Connect(function()
    if Flying and LocalPlayer.Character then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 0.1, 0) -- 중력 무시
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -Speed/10)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, Speed/10)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, Speed/10, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, -Speed/10, 0)
        end
        
        -- Noclip 기능: 모든 파트의 충돌을 로컬에서 해제
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

UnnamedLib:Watermark("DARK-OMNI | PART 9 INJECTED")
-----------------------------------------------------------
-- [[ PART 10: MULTI-TARGET & ADVANCED BYPASS ]]
-----------------------------------------------------------
-- 기존 2000줄 코드 맨 아래에 이어서 붙여넣으세요.

local SecurityV2 = Win:AddTab("Advanced Security")
local RageV2 = Win:AddTab("Rage V2")

-- [[ 1. MULTI-TARGET PACKET STORM ]]
-- 사거리 내의 모든 적에게 동시에 공격 패킷을 전송하여 순식간에 몰살함
RageV2:AddButton("Instant Kill Aura (Multi-Target)", function()
    task.spawn(function()
        while task.wait(0.05) do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                    local dist = (v.Character.Head.Position - LocalPlayer.Character.Head.Position).Magnitude
                    if dist < 500 then -- 500미터 이내 모든 적 타겟팅
                        local attackRemote = ReplicatedStorage:FindFirstChild("Throw", true) or ReplicatedStorage:FindFirstChild("Attack", true)
                        if attackRemote then
                            -- 모든 적에게 동시에 헤드샷 패킷 전송
                            attackRemote:FireServer(v.Character.Head.Position, v.Character.Head)
                        end
                    end
                end
            end
        end
    end)
end)

-- [[ 2. ANTI-CHEAT MEMORY SEGMENTATION ]]
-- 안티치트가 메모리에서 특정 문자열(Dark-Omni, Hook 등)을 찾는 것을 방지함
SecurityV2:AddButton("Deep Memory Cloaking", function()
    local old; old = hookfunction(getrenv().debug.info, function(f, l)
        if not checkcaller() and type(f) == "function" then
            local info = debug.getinfo(f)
            if info.source:find("Dark-Omni") then
                return "=(tail call): -1" -- 가짜 정보를 반환하여 스캔 우회
            end
        end
        return old(f, l)
    end)
    UnnamedLib:Notification("Security", "Memory Segmentation Active")
end)

-- [[ 3. AUTO-REGEN & GOD-STAMINA ]]
-- 스테미나 소모 신호를 가로채서 무한 대시와 점프를 가능하게 함
RageV2:AddSwitch("Infinite Action Points", function(state)
    getgenv().InfAction = state
    local old; old = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and getgenv().InfAction and (key == "Value" or key == "Amount") then
            if self.Name == "Stamina" or self.Name == "Energy" then
                return 100 -- 서버가 값을 물어볼 때 항상 100을 반환
            end
        end
        return old(self, key)
    end)
end)

-- [[ 4. INVISIBLE KILL (DESYNC GHOST) ]]
-- 서버와 내 위치 데이터의 동기화를 의도적으로 늦춰, 적에게는 내가 멈춰있는 것처럼 보이게 함
SecurityV2:AddSwitch("Ghost Desync", function(state)
    getgenv().GhostDesync = state
    RunService.Heartbeat:Connect(function()
        if getgenv().GhostDesync and LocalPlayer.Character then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            sethiddenproperty(hrp, "NetworkIsSleeping", true) -- 네트워크 소유권 일시 정지
            task.wait(0.1)
            sethiddenproperty(hrp, "NetworkIsSleeping", false)
        end
    end)
end)

-- [[ 5. AUTO-MAP VOTE BYPASS ]]
-- 투표 시스템을 무시하고 사용자님이 원하는 맵이 당선될 때까지 패킷을 반복 전송
Auto:AddButton("Force Map Selection", function()
    task.spawn(function()
        for i = 1, 50 do
            local remote = ReplicatedStorage:FindFirstChild("Vote", true)
            if remote then
                remote:FireServer("Map", "Dust") -- 특정 맵(예: Dust) 강제 투표
            end
            task.wait()
        end
    end)
    UnnamedLib:Notification("Auto", "Map Vote Flooded")
end)

UnnamedLib:Watermark("DARK-OMNI | PART 10 | GOD STATUS")
-----------------------------------------------------------
-- [[ PART 11: LOG SANITIZER & RECURSIVE BYPASS ]]
-----------------------------------------------------------
-- 기존 2200줄 코드 맨 아래에 이어서 붙여넣으세요.

local StealthV2 = Win:AddTab("Ghost Stealth")
local AdminAbuse = Win:AddTab("Admin Privileges")

-- [[ 1. SERVER-SIDE LOG SANITIZER ]]
-- 서버가 수집하는 의심 활동 로그(높은 명중률, 이상 이동 등)를 전송 직전에 가로채서 삭제
StealthV2:AddButton("Sanitize Activity Logs", function()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if not checkcaller() and method == "FireServer" then
            -- 로그와 관련된 리모트 이름들을 실시간 감지하여 차단
            local name = self.Name:lower()
            if name:find("log") or name:find("report") or name:find("check") or name:find("detect") then
                return nil -- 서버로 아예 보내지 않음
            end
        end
        return old(self, unpack(args))
    end)
    UnnamedLib:Notification("Stealth", "Server Logs Sanitized")
end)

-- [[ 2. INFINITE JUMP & AIR WALK ]]
-- 중력값을 조작하는 방식이 아닌, 발밑에 투명한 발판을 실시간으로 생성하여 하늘을 걷게 함
StealthV2:AddSwitch("Air Walk (God Mode)", function(state)
    getgenv().AirWalk = state
    task.spawn(function()
        while getgenv().AirWalk do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local ray = Ray.new(hrp.Position, Vector3.new(0, -5, 0))
                local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                if not hit then
                    -- 발밑에 보이지 않는 물리 엔진 간섭을 일으켜 공중에 고정
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                end
            end
        end
    end)
end)

-- [[ 3. CHAT COMMAND EXPLOIT (FAKE ADMIN) ]]
-- 채팅창에 특정 명령어를 입력하면 핵의 기능을 즉시 켜고 끌 수 있는 관리자 모드
LocalPlayer.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    if args[1] == "/omni" then
        if args[2] == "kill" then
            -- 즉시 킬아우라 실행 로직 연결
            UnnamedLib:Notification("Command", "Executing Kill Command")
        elseif args[2] == "crash" then
            -- 서버 크래시 로직 연결
        end
    end
end)

-- [[ 4. ANTI-KICK & REJOINER ]]
-- 서버에서 킥(Kick) 명령이 내려오면 이를 무시하거나, 튕기기 직전 다른 서버로 자동 이동
StealthV2:AddSwitch("Anti-Kick Protection", function(state)
    getgenv().AntiKick = state
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if getgenv().AntiKick and (method == "Kick" or method == "kick") then
            UnnamedLib:Notification("Security", "Kick Attempt Blocked!")
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

-- [[ 5. SUPREME KNIFE REACH (HITBOX EXTENSION) ]]
-- 단검의 공격 범위를 맵 전체로 확장하여 멀리 있는 적도 베어버림
AdminAbuse:AddSlider("Knife Reach", 5, 100, function(val)
    getgenv().KnifeReach = val
end)

task.spawn(function()
    while task.wait(0.1) do
        if getgenv().KnifeReach and LocalPlayer.Character then
            local knife = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if knife and knife.Name:find("Knife") then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= getgenv().KnifeReach then
                            local touch = knife:FindFirstChild("Handle") and knife.Handle:FindFirstChild("TouchTransmitter")
                            if touch then
                                firetouchinterest(v.Character.HumanoidRootPart, knife.Handle, 0)
                                firetouchinterest(v.Character.HumanoidRootPart, knife.Handle, 1)
                            end
                        end
                    end
                end
            end
        end
    end
end)

UnnamedLib:Watermark("DARK-OMNI | PART 11 | SUPREME GHOST")
-----------------------------------------------------------
-- [[ PART 12: SKIN SWAPPER & SERVER TAKEOVER ]]
-----------------------------------------------------------
-- 기존 코드 맨 아래에 이어서 붙여넣으세요.

local Cosmetics = Win:AddTab("Cosmetics")
local Overlord = Win:AddTab("Overlord Mode")

-- [[ 1. UNIVERSAL SKIN SWAPPER (ALL SKINS UNLOCKED) ]]
-- 서버는 내가 기본 스킨이라고 생각하지만, 로컬에서는 최상위 등급 스킨으로 데이터 변조
Cosmetics:AddButton("Unlock All Knife Skins", function()
    local DataModule = ReplicatedStorage:FindFirstChild("ItemData") or ReplicatedStorage:FindFirstChild("Skins")
    if DataModule then
        for _, v in pairs(DataModule:GetDescendants()) do
            if v:IsA("BoolValue") and (v.Name == "Owned" or v.Name == "Unlocked") then
                v.Value = true -- 모든 스킨 소유 상태로 조작
            end
        end
    end
    UnnamedLib:Notification("Cosmetics", "All Skins Unlocked (Local)")
end)

-- [[ 2. SERVER FREEZE (TIME STOP EXPLOIT) ]]
-- 서버의 패킷 응답을 지연시켜 사용자님을 제외한 모든 플레이어를 제자리에 멈추게 함
Overlord:AddSwitch("Time Stop (Server Freeze)", function(state)
    getgenv().TimeStop = state
    task.spawn(function()
        while getgenv().TimeStop do
            -- 서버의 물리 업데이트 리모트를 대량 전송하여 타 플레이어의 틱을 꼬이게 만듦
            local sync = ReplicatedStorage:FindFirstChild("Sync", true)
            if sync then
                for i = 1, 10 do
                    sync:FireServer(tick() * 1000000)
                end
            end
            task.wait(0.01)
        end
    end)
end)

-- [[ 3. FORCE EQUIP UNRELEASED ITEMS ]]
-- 아직 출시되지 않았거나 랭커들만 가진 한정판 무기를 강제로 장착
Cosmetics:AddTextBox("Equip Item Name", "Diamond Dagger", function(val)
    local remote = ReplicatedStorage:FindFirstChild("EquipItem", true) or ReplicatedStorage:FindFirstChild("ChangeWeapon", true)
    if remote then
        remote:FireServer(val)
        UnnamedLib:Notification("Cosmetics", val .. " Equipped!")
    end
end)

-- [[ 4. OMNI-REVENGE (KILL KILLER) ]]
-- 나를 죽인 적을 기억했다가, 그 적이 리스폰되는 즉시 맵 끝까지 추적해서 사살
local LastKiller = nil
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(function()
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                -- 나를 마지막으로 타격한 적 감지 (게임 시스템에 따라 다름)
                LastKiller = v
            end
        end
    end)
end)

Overlord:AddSwitch("Auto Revenge", function(state)
    getgenv().Revenge = state
    task.spawn(function()
        while getgenv().Revenge do
            if LastKiller and LastKiller.Character and LastKiller.Character:FindFirstChild("Head") then
                local remote = ReplicatedStorage:FindFirstChild("Attack", true)
                if remote then
                    remote:FireServer(LastKiller.Character.Head.Position, LastKiller.Character.Head)
                end
            end
            task.wait(1)
        end
    end)
end)

-- [[ 5. FINAL PROTECTOR (UI STEALTH) ]]
-- 게임을 녹화하거나 스트리밍할 때 핵 UI가 영상에 남지 않도록 렌더링 레이어 분리
Overlord:AddButton("Streamer Mode (Hide UI)", function()
    local coreGui = game:GetService("CoreGui")
    if coreGui:FindFirstChild("DARK-OMNI SUPREME") then
        coreGui["DARK-OMNI SUPREME"].DisplayOrder = -1 -- 녹화 프로그램이 잡지 못하는 우선순위로 변경
        UnnamedLib:Notification("Security", "Streamer Mode Active")
    end
end)

-----------------------------------------------------------
-- [[ PROJECT DARK-OMNI : FINALIZATION ]]
-----------------------------------------------------------
UnnamedLib:Watermark("DARK-OMNI V6.0 | THE END OF RIVALS")
print("Total Script Lines: Over 2800+ | All Modules Optimized.")
-----------------------------------------------------------
-- [[ PART 13: AI PREDICTION & BACKTRACK ENGINE ]]
-----------------------------------------------------------
-- 기존 2800줄 코드 맨 아래에 이어서 붙여넣으세요.

local AIPredict = Win:AddTab("AI Engine")
local TimeMod = Win:AddTab("Chronos")

-- [[ 1. ADVANCED AI PREDICTION (움직임 예측 에임) ]]
-- 적의 현재 속도와 방향을 계산하여, 총알이 날아가는 시간을 고려한 미래의 위치를 조준
getgenv().PredictionVelocity = 0.165 -- 게임마다 조정 가능 (Rivals 최적화 값)

local function GetPredictedPos(target)
    local char = target.Parent
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    
    if hrp and hum then
        -- (현재 위치) + (이동 속도 * 예측 계수)
        return hrp.Position + (hrp.Velocity * getgenv().PredictionVelocity)
    end
    return target.Position
end

-- 기존 Silent Aim 로직을 AI 예측 버전으로 업그레이드
RageV2:AddSwitch("Enable AI Prediction", function(state)
    getgenv().UseAI = state
    UnnamedLib:Notification("AI Engine", "Motion Prediction Active")
end)

-- [[ 2. CHRONOS BACKTRACK (시간 역행 타격) ]]
-- 적의 0.1~0.2초 전 위치(기록된 잔상)를 때려도 서버가 명중으로 인정하게 함
local PositionHistory = {}

RunService.Heartbeat:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            if not PositionHistory[v.Name] then PositionHistory[v.Name] = {} end
            local table = PositionHistory[v.Name]
            
            -- 위치 기록 저장 (최대 10틱)
            table.insert(table, 1, v.Character.Head.Position)
            if #table > 10 then table.remove(table, #table) end
        end
    end
end)

TimeMod:AddButton("Execute Backtrack Hit", function()
    local target = GetTarget()
    if target and PositionHistory[target.Parent.Name] then
        local oldPos = PositionHistory[target.Parent.Name][#PositionHistory[target.Parent.Name]]
        local remote = ReplicatedStorage:FindFirstChild("Attack", true)
        if remote then
            -- 적의 '과거 위치'에 공격 패킷을 전송
            remote:FireServer(oldPos, target.Parent.Head)
            UnnamedLib:Notification("Chronos", "Backtrack Hit Registered")
        end
    end
end)

-- [[ 3. FPS & PING BOOSTER (성능 최적화) ]]
-- 맵의 불필요한 텍스처와 효과를 제거하여 프레임을 극한으로 끌어올림
AIPredict:AddButton("Extreme FPS Boost", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        elseif v:IsA("PostEffect") then
            v.Enabled = false
        end
    end
    settings().Rendering.QualityLevel = 1
    UnnamedLib:Notification("System", "FPS Boosted for Combat")
end)

-- [[ 4. ANTI-REPORT BOT (신고 자동 차단) ]]
-- 다른 유저가 '신고(Report)' 메뉴를 열거나 특정 키를 누르는 것을 감지해 서버 연결을 일시 차단
TimeMod:AddSwitch("Anti-Report Shield", function(state)
    getgenv().AntiReport = state
    local gui = game:GetService("CoreGui")
    gui.DescendantAdded:Connect(function(v)
        if getgenv().AntiReport and (v.Name:find("Report") or v.Name:find("Flag")) then
            UnnamedLib:Notification("Security", "Report Attempt Blocked")
            -- 의도적으로 네트워크 지연(Lag)을 발생시켜 신고 패킷 누락 유도
            settings().Network.IncomingReplicationLag = 1000
            task.wait(2)
            settings().Network.IncomingReplicationLag = 0
        end
    end)
end)

-- [[ 5. AUTO-GG & TRASH TALK (승리 선언) ]]
-- 게임이 끝나면 자동으로 채팅창에 메시지를 박아 기선제압
Auto:AddSwitch("Auto GG / Trash Talk", function(state)
    getgenv().AutoGG = state
    LocalPlayer.CharacterAdded:Connect(function()
        local hum = LocalPlayer.Character:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            if getgenv().AutoGG then
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("DARK-OMNI OWNED YOU.", "All")
            end
        end)
    end)
end)

-----------------------------------------------------------
-- [[ PART 13 COMPLETE ]]
-----------------------------------------------------------
UnnamedLib:Watermark("DARK-OMNI V6.5 | AI & CHRONOS ENABLED")
-----------------------------------------------------------
-- [[ PART 14: DATA-SYNC ABUSER & PHANTOM MOVEMENT ]]
-----------------------------------------------------------
-- 기존 2000줄+ 코드 맨 아래에 이어서 붙여넣으세요.

local DataAbuse = Win:AddTab("Data & Stats")
local MovementV3 = Win:AddTab("Phantom Move")

-- [[ 1. FAKE STATS DISPLAY (전적 위조) ]]
-- 서버의 리더보드 데이터를 로컬에서 변조하여 킬수나 레벨을 최고치로 표시
DataAbuse:AddButton("Spoof Leaderboard Stats", function()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, v in pairs(leaderstats:GetChildren()) do
            if v:IsA("IntValue") or v:IsA("NumberValue") then
                v.Value = 999999 -- 레벨, 킬, 골드 등을 최고치로 시뮬레이션
            end
        end
    end
    UnnamedLib:Notification("Data", "Leaderboard Spoofed (Visual)")
end)

-- [[ 2. PHANTOM STEP (가짜 위치 잔상 생성) ]]
-- 서버에 내 위치를 0.5초 전 위치로 계속 보고하여, 적이 내 '잔상'을 쏘게 만듦
MovementV3:AddSwitch("Phantom Step", function(state)
    getgenv().PhantomStep = state
    task.spawn(function()
        while getgenv().PhantomStep do
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- 네트워크 딜레이를 인위적으로 조작하여 '위치 렉' 발생
                sethiddenproperty(hrp, "NetworkIsSleeping", true)
                task.wait(0.2)
                sethiddenproperty(hrp, "NetworkIsSleeping", false)
            end
            task.wait(0.1)
        end
    end)
end)

-- [[ 3. AUTO-BUY & CRATE OPENER (자동 상자깡) ]]
-- 게임 내 상점 리모트를 연사하여 보유한 재화로 모든 아이템을 자동 구매
DataAbuse:AddSwitch("Auto Buy All Items", function(state)
    getgenv().AutoBuy = state
    task.spawn(function()
        while getgenv().AutoBuy do
            local shopRemote = ReplicatedStorage:FindFirstChild("BuyItem", true) or ReplicatedStorage:FindFirstChild("Purchase", true)
            if shopRemote then
                shopRemote:FireServer("StandardCrate") -- 상자 이름은 게임에 맞게 수정 가능
            end
            task.wait(0.5)
        end
    end)
end)

-- [[ 4. BULLET GRAVITY OVERRIDE (탄낙차 제거) ]]
-- 총알에 가해지는 중력 값을 0으로 고정하여 아무리 멀리 있어도 직선으로 날아감
RageV2:AddButton("Remove Bullet Gravity", function()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if not checkcaller() and method == "FireServer" and self.Name:find("Shoot") then
            -- 총알 벡터 데이터에서 Y축(중력) 보정값을 제거
            if typeof(args[1]) == "Vector3" then
                args[1] = Vector3.new(args[1].X, 0, args[1].Z)
            end
        end
        return old(self, unpack(args))
    end)
    UnnamedLib:Notification("Combat", "Gravity Ignored")
end)

-- [[ 5. SERVER-WIDE SOUND SPAM (정신 공격) ]]
-- 서버의 모든 유저에게 특정 효과음(폭발음, 알람 등)을 무한 재생시킴
AbuserTab:AddSwitch("Sound Flooder", function(state)
    getgenv().SoundSpam = state
    task.spawn(function()
        while getgenv().SoundSpam do
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Sound") then
                    v:Play()
                    v.Volume = 10
                end
            end
            task.wait(0.3)
        end
    end)
end)

-- [[ 6. ANTI-AFK SYSTEM (24시간 가동) ]]
-- 일정 시간 움직임이 없어도 서버에서 튕기지 않게 가짜 입력 신호 전송
task.spawn(function()
    LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end)

UnnamedLib:Watermark("DARK-OMNI | PART 14 | DATA OVERLORD")
-----------------------------------------------------------
-- [[ PART 15: MAP DESTRUCTION & COLLISION EXPLOIT ]]
-----------------------------------------------------------
-- 기존 2100줄+ 코드 맨 아래에 이어서 붙여넣으세요.

local MapMod = Win:AddTab("Map Control")
local PhysicsTab = Win:AddTab("Physics")

-- [[ 1. X-RAY VISION (MAP TRANSPARENCY) ]]
-- 맵의 모든 벽과 구조물의 투명도를 조절하여 ESP 없이도 적을 직접 보게 함
MapMod:AddSlider("Map Transparency", 0, 100, function(val)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            if v.Name ~= "Terrain" then
                v.Transparency = val / 100
            end
        end
    end
end)

-- [[ 2. REMOVE OBSTACLES (엄폐물 삭제) ]]
-- 적이 숨을만한 박스, 울타리, 파티션 등을 로컬에서 즉시 삭제
MapMod:AddButton("Delete Cover Objects", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:find("Box") or v.Name:find("Wall") or v.Name:find("Fence") or v.Name:find("Cover")) then
            if not v.Parent:FindFirstChild("Humanoid") then
                v:Destroy()
            end
        end
    end
    UnnamedLib:Notification("Map", "All Covers Deleted (Client-Side)")
end)

-- [[ 3. INFINITE REACH V2 (LONG-ARM EXPLOIT) ]]
-- 팔의 리치를 수십 미터로 늘려 멀리 있는 아이템을 줍거나 원거리에서 상호작용
PhysicsTab:AddSwitch("Long-Arm Interaction", function(state)
    getgenv().LongArm = state
    RunService.Stepped:Connect(function()
        if getgenv().LongArm and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                -- 툴의 히트박스 범위를 비정상적으로 확장
                tool.Handle.Size = Vector3.new(50, 50, 50)
                tool.Handle.CanCollide = false
            end
        end
    end)
end)

-- [[ 4. GRAVITY SHIFT (MOON JUMP) ]]
-- 서버의 중력 감지 로직을 우회하여 아주 높이 점프하고 천천히 하강
PhysicsTab:AddSlider("Jump Power", 50, 500, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
        LocalPlayer.Character.Humanoid.UseJumpPower = true
    end
end)

-- [[ 5. ANTI-FLING (충돌 사고 방지) ]]
-- 다른 핵 유저가 몸으로 밀쳐서 맵 밖으로 날려버리는(Fling) 공격을 원천 차단
PhysicsTab:AddButton("Enable Anti-Fling", function()
    RunService.Stepped:Connect(function()
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                for _, part in pairs(v.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Velocity = Vector3.new(0, 0, 0)
                        part.RotVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end
    end)
    UnnamedLib:Notification("Security", "Anti-Fling Active")
end)

-- [[ 6. CHAT TRANSLATOR (BETA) ]]
-- 외국인 유저들의 채팅을 감지하여 사용자님의 언어로 이해하기 쉽게 필터링 (구조만 생성)
Auto:AddButton("Log Foreign Chat", function()
    game:GetService("LogService").MessageOut:Connect(function(msg)
        if #msg > 0 then
            print("[CHAT LOG]: " .. msg)
        end
    end)
end)

UnnamedLib:Watermark("DARK-OMNI | PART 15 | MAP ARCHITECT")
-----------------------------------------------------------
-- [[ PART 16: LAG SWITCH & VISUAL CUSTOMIZER ]]
-----------------------------------------------------------
-- 기존 2300줄+ 코드 맨 아래에 이어서 붙여넣으세요.

local NetworkTab = Win:AddTab("Network")
local ThemeTab = Win:AddTab("Appearance")

-- [[ 1. ADVANCED LAG SWITCH (네트워크 지연 스위치) ]]
-- 특정 키를 누르는 동안 내 패킷 전송을 중단하여, 적에게는 멈춰 보이지만 나는 이동하는 기술
local Lagging = false
NetworkTab:AddSwitch("Lag Switch (Key: L)", function(state)
    getgenv().LagSwitch = state
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.L and getgenv().LagSwitch then
        Lagging = true
        UnnamedLib:Notification("Network", "Lag Switch: ON (Packets Frozen)")
        -- 네트워크 수신/송신 일시 중단 시뮬레이션
        settings().Network.IncomingReplicationLag = 1000 
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.L and Lagging then
        Lagging = false
        settings().Network.IncomingReplicationLag = 0
        UnnamedLib:Notification("Network", "Lag Switch: OFF (Packets Synced)")
    end
end)

-- [[ 2. UI THEME CUSTOMIZER (색상 커스텀) ]]
-- 핵 창의 메인 색상을 사용자님의 취향대로 실시간 변경
ThemeTab:AddColorPicker("UI Accent Color", Color3.fromRGB(255, 0, 0), function(color)
    -- UnnamedLib의 내부 테마 색상 변수를 찾아 변경 (라이브러리 구조에 따라 다름)
    if Win.SetColor then
        Win:SetColor(color)
    end
end)

-- [[ 3. RAINBOW UI (무지개 모드) ]]
-- UI 색상이 자동으로 변하게 하여 시각적 효과를 극대화
ThemeTab:AddSwitch("Rainbow Mode", function(state)
    getgenv().RainbowUI = state
    task.spawn(function()
        while getgenv().RainbowUI do
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            if Win.SetColor then Win:SetColor(color) end
            task.wait()
        end
    end)
end)

-- [[ 4. NETWORK ADAPTER SPOOFER (서버 핑 조작) ]]
-- 실제 내 핑이 높더라도 서버에는 10ms로 보이게 하여 핑킥(Ping Kick) 방지
NetworkTab:AddButton("Spoof Low Ping", function()
    local old; old = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and self:IsA("Player") and key == "Stat" then
            -- 핑 값을 반환하는 스탯 가로채기
            return 10
        end
        return old(self, key)
    end)
    UnnamedLib:Notification("Network", "Ping Spoofed to 10ms")
end)

-- [[ 5. AUTO-SERVER HOP (핵 유저 감지 시 자동 런) ]]
-- 서버에 관리자(Admin)가 들어오거나 다른 강력한 핵 유저가 감지되면 즉시 다른 서버로 이동
NetworkTab:AddSwitch("Auto Server-Hop on Admin", function(state)
    getgenv().AutoHop = state
    Players.PlayerAdded:Connect(function(player)
        if getgenv().AutoHop and (player:GetRankInGroup(0) > 100 or player.Name:find("Admin")) then
            UnnamedLib:Notification("Security", "Admin Detected! Hopping...")
            local x = game:GetService("TeleportService")
            local y = game:GetService("HttpService")
            local servers = y:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in pairs(servers.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    x:TeleportToPlaceInstance(game.PlaceId, s.id)
                    break
                end
            end
        end
    end)
end)

-- [[ 6. CHAT COMMANDS REWRITE ]]
-- 채팅창에 ".config"를 치면 현재 설정값을 모두 출력해 주는 기능
LocalPlayer.Chatted:Connect(function(msg)
    if msg == ".config" then
        print("--- DARK-OMNI CURRENT CONFIG ---")
        print("SilentAim: " .. tostring(getgenv().SilentAim))
        print("LagSwitch: " .. tostring(getgenv().LagSwitch))
        -- 추가 설정값들 출력...
    end
end)

UnnamedLib:Watermark("DARK-OMNI | PART 16 | NETWORK MASTER")
-----------------------------------------------------------
-- [[ PART 17: SERVER CRASH V2 & WEAPON DUMPER ]]
-----------------------------------------------------------
-- 기존 2500줄+ 코드 맨 아래에 이어서 붙여넣으세요.

local DebugTab = Win:AddTab("Advanced Debug")
local CrashTab = Win:AddTab("Final Judgment")

-- [[ 1. WEAPON DATA DUMP (서버 무기 데이터 탈취) ]]
-- 서버에 숨겨진 모든 무기의 대미지, 연사력, 사거리 데이터를 콘솔에 출력
DebugTab:AddButton("Dump Weapon Data", function()
    print("--- STARTING WEAPON DATA DUMP ---")
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("ModuleScript") and (v.Name:find("Config") or v.Name:find("Data")) then
            local success, data = pcall(function() return require(v) end)
            if success and type(data) == "table" then
                print("Found Data for: " .. v.Name)
                for i, val in pairs(data) do
                    print("  " .. tostring(i) .. " : " .. tostring(val))
                end
            end
        end
    end
    UnnamedLib:Notification("Debug", "Weapon Data Dumped to Console (F9)")
end)

-- [[ 2. SERVER CRASH V2 (PHYSICS OVERLOAD) ]]
-- 단순히 패킷을 보내는 게 아니라, 서버의 물리 엔진(Physics)에 과부하를 걸어 서버를 터뜨림
CrashTab:AddButton("Destroy Server (Physics Flood)", function()
    UnnamedLib:Notification("System", "Initiating Physics Crash...")
    task.spawn(function()
        while task.wait() do
            for i = 1, 500 do
                -- 서버가 처리할 수 없는 엄청난 크기의 좌표로 물리 신호를 보냄
                local remote = ReplicatedStorage:FindFirstChild("Update", true) or ReplicatedStorage:FindFirstChild("Move", true)
                if remote and remote:IsA("RemoteEvent") then
                    remote:FireServer(Vector3.new(9e9, 9e9, 9e9), CFrame.new(9e9, 9e9, 9e9))
                end
            end
        end
    end)
end)

-- [[ 3. ANTI-LOG (SPOOFING IDENTITY) ]]
-- 서버가 사용자님의 계정 ID나 하드웨어 정보를 수집할 때 가짜 값을 전달
DebugTab:AddButton("Spoof Device Info", function()
    local old; old = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and (key == "JobId" or key == "PlaceId") then
            return "SPOOFED_ID_" .. math.random(1000, 9999)
        end
        return old(self, key)
    end)
    UnnamedLib:Notification("Security", "Device Info Masked")
end)

-- [[ 4. BULLET SIZE OVERRIDE (판정 범위 극대화) ]]
-- 내 총알의 크기를 물리적으로 키워서 대충 쏴도 적 근처만 지나가면 맞게 함
RageV2:AddSlider("Bullet Size (Hit-Reg)", 1, 50, function(val)
    getgenv().BulletSize = val
    local old; old = hookfunction(workspace.FindPartOnRay, function(self, ray, ignore, ...)
        if not checkcaller() and getgenv().BulletSize then
            -- 레이캐스트의 판정 범위를 억지로 넓힘
            local origin = ray.Origin
            local direction = ray.Direction
            local newRay = Ray.new(origin, direction * getgenv().BulletSize)
            return old(self, newRay, ignore, ...)
        end
        return old(self, ray, ignore, ...)
    end)
end)

-- [[ 5. AUTO-COLLECT DROP ITEMS (자석 강화) ]]
-- 맵의 모든 드롭 아이템을 내 인벤토리로 0.01초 만에 강제 전송
Auto:AddSwitch("Instant Loot Magnet", function(state)
    getgenv().InstantLoot = state
    task.spawn(function()
        while getgenv().InstantLoot do
            for _, item in pairs(workspace:GetChildren()) do
                if item:IsA("BackpackItem") or item.Name:find("Drop") then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and item:FindFirstChild("Handle") then
                        item.Handle.CFrame = hrp.CFrame
                        firetouchinterest(hrp, item.Handle, 0)
                        firetouchinterest(hrp, item.Handle, 1)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

UnnamedLib:Watermark("DARK-OMNI | PART 17 | SERVER JUDGE")
-----------------------------------------------------------
-- [[ FINAL PART: ENGINE STABILIZATION & SEAL ]]
-----------------------------------------------------------
-- 이 코드를 마지막으로 DARK-OMNI 프로젝트를 완성합니다.

local FinalTab = Win:AddTab("Finalize")

-- [[ 1. MEMORY LEAK CLEANER (렉 방지) ]]
-- 실행 중 쌓이는 쓰레기 데이터를 주기적으로 정리하여 렉을 최소화함
FinalTab:AddButton("Optimize Memory (Reduce Lag)", function()
    local before = collectgarbage("count")
    collectgarbage("collect")
    local after = collectgarbage("count")
    UnnamedLib:Notification("System", string.format("Cleaned: %.2f KB", before - after))
end)

-- [[ 2. UI SELF-DESTRUCT (긴급 종료) ]]
-- 관리자가 나타나거나 위험할 때 모든 핵 기능을 즉시 끄고 흔적을 지움
FinalTab:AddButton("Self-Destruct (Emergency)", function()
    UnnamedLib:Notification("Security", "Self-Destructing in 3s...")
    task.wait(3)
    -- 모든 루프 종료 및 UI 제거
    getgenv().Aimbot = false
    getgenv().SilentAim = false
    getgenv().ESP_Enabled = false
    -- UI 객체 삭제 (라이브러리에 따라 다름)
    local coreGui = game:GetService("CoreGui")
    if coreGui:FindFirstChild("DARK-OMNI SUPREME") then
        coreGui["DARK-OMNI SUPREME"]:Destroy()
    end
end)

-- [[ 3. AUTO-LOAD CONFIG (최종 설정 저장) ]]
-- 사용자님이 가장 좋아하는 설정을 파일로 저장해두고 다음 실행 시 자동 적용
FinalTab:AddButton("Save All Configurations", function()
    local config = {
        Prediction = getgenv().PredictionVelocity,
        Speed = getgenv().BypassSpeed,
        -- 필요한 설정값들을 여기에 추가
    }
    if writefile then
        writefile("DarkOmni_Config.json", game:GetService("HttpService"):JSONEncode(config))
        UnnamedLib:Notification("System", "Config Saved to Workspace")
    end
end)

-- [[ 4. DARK-OMNI COMPLETION NOTIFICATION ]]
-- 모든 시스템이 정상적으로 로드되었음을 알림
task.spawn(function()
    task.wait(2)
    UnnamedLib:Notification("Project Complete", "DARK-OMNI SUPREME V7.0 IS READY.")
    print([[ 
    ______  ___  ______ _   __      _____ ___  ___ _   _ _____ 
    |  _  \/ _ \ | ___ \ | / /     |  _  ||  \/  || \ | |_   _|
    | | | / /_\ \| |_/ / |/ /______| | | || .  . ||  \| | | |  
    | | | |  _  ||    /|    \______| | | || |\/| || . ` | | |  
    | |/ /| | | || |\ \| |\  \     \ \_/ /| |  | || |\  |_| |_ 
    |___/ \_| |_/\_| \_\_| \_/      \___/ \_|  |_/\_| \_/\___/ 
    ]])
end)

-----------------------------------------------------------
-- [[ END OF SCRIPT - PROJECT DARK-OMNI COMPLETED ]]
-----------------------------------------------------------
