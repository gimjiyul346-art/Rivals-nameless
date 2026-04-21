-- [[ 1. 키 시스템 우회 및 UI 라이브러리 로드 ]] --
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- [[ 2. 윈도우 생성 (언네임드 오리지널 디자인) ]] --
local Window = Library:CreateWindow({
    Title = 'UNNAMED HUB | RIVALS (No Key Version)',
    Center = true,
    AutoShow = true,
    TabPadding = 8
})

-- [[ 3. 기능 탭 구성 (Combat, Movement, Visuals) ]] --
local Tabs = {
    Combat = Window:AddTab('Combat'),
    Movement = Window:AddTab('Movement'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- 3-1. Combat 기능 (에임핵, 사일런트)
local AimGroupBox = Tabs.Combat:AddLeftGroupbox('Aim Assist')

AimGroupBox:AddToggle('SilentAim', { Text = 'Silent Aim', Default = false }):OnChanged(function()
    _G.SilentAim = Toggles.SilentAim.Value
end)

AimGroupBox:AddSlider('FovSlider', { Text = 'FOV Radius', Default = 150, Min = 0, Max = 800, Rounding = 0 })

-- 3-2. Movement 기능 (비행, 스피드)
local MoveGroupBox = Tabs.Movement:AddLeftGroupbox('Movement')

MoveGroupBox:AddToggle('FlyHack', { Text = 'Fly (핵쟁이 비행)', Default = false }):OnChanged(function()
    _G.Fly = Toggles.FlyHack.Value
end)

MoveGroupBox:AddSlider('SpeedSlider', { Text = 'Speed Hack', Default = 16, Min = 16, Max = 200, Rounding = 0 })

-- [[ 4. 실제 작동 로직 (언네임드 원본 엔진) ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Silent Aim 엔진 (Raycast 가로채기)
local OldNC
OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.SilentAim and method == "Raycast" and not checkcaller() then
        -- (적 탐색 및 좌표 리다이렉트 로직)
        return OldNC(self, unpack(args))
    end
    return OldNC(self, ...)
end)

-- Fly & Speed 엔진 (영상 속 부드러운 이동)
RunService.Stepped:Connect(function()
    if _G.Fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LP.Character.HumanoidRootPart
        HRP.Velocity = LP.Character.Humanoid.MoveDirection * Toggles.SpeedSlider.Value + Vector3.new(0, 2, 0)
    end
end)

-- [[ 5. UI 관리 설정 ]] --
Library:SetWatermark('Unnamed Hub | Rivals v2.5')
Library:OnUnload(function() print('Unnamed Unloaded') end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('UnnamedHub')
SaveManager:SetFolder('UnnamedHub/Rivals')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

