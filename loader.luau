repeat task.wait() until game:IsLoaded()

-- [[ 파일 시스템 서비스 ]]
local HttpService = game:GetService("HttpService")
local FileName = "Nameless_V14_Config.json"

-- [[ 기본 설정값 ]]
getgenv().Nameless_Settings = {
    SilentAim = false,
    Wallbang = false,
    Fly = false,
    AntiAim = false,
    FlySpeed = 50,
    FOV = 150,
    AutoLoad = false -- 이 값이 true일 때만 저장함
}

-- [ 안전한 저장 함수 ]
local function SafeSave()
    if getgenv().Nameless_Settings.AutoLoad then
        pcall(function()
            if writefile then
                writefile(FileName, HttpService:JSONEncode(getgenv().Nameless_Settings))
            end
        end)
    end
end

-- [ 안전한 로드 함수 ]
local function SafeLoad()
    pcall(function()
        if isfile and isfile(FileName) then
            local data = HttpService:JSONDecode(readfile(FileName))
            -- 파일에 저장된 AutoLoad가 true일 때만 값 덮어쓰기
            if data.AutoLoad then
                getgenv().Nameless_Settings = data
            end
        end
    end)
end

-- 시작하자마자 기존 설정 불러오기
SafeLoad()

local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- [[ 안티치트 우회 엔진 ]]
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() then
        if (method == "Raycast" or method == "FindPartOnRay") and getgenv().Nameless_Settings.SilentAim then
            local target = nil
            local dist = getgenv().Nameless_Settings.FOV
            
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    local p, os = Camera:WorldToViewportPoint(v.Character.Head.Position)
                    if os then
                        local mag = (Vector2.new(p.X, p.Y) - UserInput:GetMouseLocation()).Magnitude
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

