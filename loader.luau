repeat task.wait() until game:IsLoaded()

-- [[ 데이터 저장/로드 시스템 ]]
local HttpService = game:GetService("HttpService")
local FileName = "NamelessConfig.json"

getgenv().Nameless_Settings = {
    SilentAim = false,
    Wallbang = false,
    Fly = false,
    AntiAim = false,
    FlySpeed = 50,
    FOV = 150,
    AutoLoad = false
}

-- 설정 저장 함수
local function SaveSettings()
    if getgenv().Nameless_Settings.AutoLoad then
        writefile(FileName, HttpService:JSONEncode(getgenv().Nameless_Settings))
    end
end

-- 설정 로드 함수
local function LoadSettings()
    if isfile(FileName) then
        local data = HttpService:JSONDecode(readfile(FileName))
        if data.AutoLoad then
            getgenv().Nameless_Settings = data
        end
    end
end

LoadSettings() -- 시작 시 자동 로드

-- [[ UI 라이브러리 로드 ]]
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Win = Kavo.CreateLib("NAMELESS HUB V1.2", "Midnight")

-- [ 메뉴 단축키 설정 ]
-- 모바일은 화면의 버튼으로, PC는 오른쪽 Shift키로 메뉴를 껐다 켤 수 있습니다.
Kavo:ToggleUI() 

local Main = Win:NewTab("Rage Combat")
local Move = Win:NewTab("Movement")
local Config = Win:NewTab("Settings")

-- [[ Combat 섹션 ]]
local Combat = Main:NewSection("Combat (총기 전용)")

Combat:NewToggle("유도탄 (Silent Aim)", "체크 시 머리 자동 조준", function(s)
    getgenv().Nameless_Settings.SilentAim = s
    SaveSettings()
end)

Combat:NewToggle("벽 관통 (Wallbang)", "체크 시 모든 벽 무시", function(s)
    getgenv().Nameless_Settings.Wallbang = s
    SaveSettings()
end)

Combat:NewSlider("FOV 범위", "핵 적용 반경", 1000, 0, function(v)
    getgenv().Nameless_Settings.FOV = v
    SaveSettings()
end)

-- [[ Movement 섹션 ]]
local MSection = Move:NewSection("Movement")

MSection:NewToggle("비행 (Fly)", "체크 시 공중 부양", function(s)
    getgenv().Nameless_Settings.Fly = s
    SaveSettings()
end)

MSection:NewSlider("비행 속도", "속도 조절", 300, 16, function(v)
    getgenv().Nameless_Settings.FlySpeed = v
    SaveSettings()
end)

MSection:NewToggle("안티 에임 (Anti-Aim)", "상대방의 조준을 방해", function(s)
    getgenv().Nameless_Settings.AntiAim = s
    SaveSettings()
end)

-- [[ Config 섹션 ]]
local CSection = Config:NewSection("Save System")

CSection:NewToggle("Auto Load (설정 저장)", "다음에 켤 때 이 설정을 유지합니다", function(s)
    getgenv().Nameless_Settings.AutoLoad = s
    SaveSettings()
end)

CSection:NewButton("현재 설정 즉시 저장", "파일로 현재 값을 기록합니다", function()
    SaveSettings()
end)

-- [[ 게임 엔진 후킹 (칼찌 버그 수정본) ]]
local LP = game:GetService("Players").LocalPlayer
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() then
        if (method == "Raycast" or method == "FindPartOnRay") and getgenv().Nameless_Settings.SilentAim then
            -- 타겟팅 로직 (에러 방지)
            local target = nil
            local dist = getgenv().Nameless_Settings.FOV
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    local p, os = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                    if os then
                        local mag = (Vector2.new(p.X, p.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                        if mag < dist then target = v.Character.Head; dist = mag end
                    end
                end
            end

            if target then
                if getgenv().Nameless_Settings.Wallbang and args[3] then
                    args[3].FilterType = Enum.RaycastFilterType.Exclude
                end
                if method == "Raycast" then
                    args[2] = (target.Position - args[1]).Unit * 1000
                end
                return old(self, unpack(args))
            end
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- [[ 루프 실행 ]]
game:GetService("RunService").Heartbeat:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        if getgenv().Nameless_Settings.Fly then
            LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0)
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + (workspace.CurrentCamera.CFrame.LookVector * getgenv().Nameless_Settings.FlySpeed / 10)
            end
        end
        if getgenv().Nameless_Settings.AntiAim then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(90), 0)
        end
    end
end)

print("NAMELESS HUB V1.2 : AUTO LOAD ENABLED")

