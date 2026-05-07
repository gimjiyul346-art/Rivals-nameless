-- [[ Nameless Hub v2: Rivals 전용 ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Library:CreateWindow({
   Name = "Nameless Hub | Rivals Edition",
   LoadingTitle = "최강의 스크립트 로딩 중...",
   ConfigurationSaving = { Enabled = true, FileName = "NamelessHub" }
})

-- 변수 설정
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local SpeedValue = 16 -- 기본 속도

-- [ 1. Main 탭: Silent Aim ]
local MainTab = Window:CreateTab("Main")
MainTab:CreateToggle({
   Name = "Silent Aim (총알 유도)",
   CurrentValue = false,
   Callback = function(Value)
       _G.SilentAim = Value
   end
})

-- Silent Aim 로직 (Hookmetamethod 사용)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
   local method = getnamecallmethod()
   local args = {...}
   if _G.SilentAim and method == "FindPartOnRayWithIgnoreList" then
       local closestEnemy = nil
       local shortestDistance = math.huge
       for _, v in pairs(Players:GetPlayers()) do
           if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
               local pos = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
               local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
               if mag < shortestDistance then
                   closestEnemy = v.Character.HumanoidRootPart
                   shortestDistance = mag
               end
           end
       end
       if closestEnemy then
           args[1] = Ray.new(Camera.CFrame.Position, (closestEnemy.Position - Camera.CFrame.Position).Unit * 1000)
       end
   end
   return oldNamecall(self, unpack(args))
end)

-- [ 2. ESP 탭: 적 위치 표시 ]
local ESPTab = Window:CreateTab("ESP")
ESPTab:CreateToggle({
   Name = "Box ESP (적 박스 표시)",
   CurrentValue = false,
   Callback = function(Value)
       _G.ESPEnabled = Value
   end
})

-- ESP 실행 루프
RunService.RenderStepped:Connect(function()
    if _G.ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                -- 여기에 박스 드로잉 로직 추가 (모바일 성능 최적화)
                -- (Highlight 개체를 사용하면 모바일에서도 렉 없이 깔끔하게 보입니다)
                local highlight = player.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight", player.Character)
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Enabled = true
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                player.Character.ESPHighlight:Destroy()
            end
        end
    end
end)

-- [ 3. Misc 탭: 이동 속도 조절 ]
local MiscTab = Window:CreateTab("Misc")
MiscTab:CreateSlider({
   Name = "WalkSpeed (이동 속도)",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
       SpeedValue = Value
   end
})

-- 속도 유지 루프
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
    end
end)
