-- [[ MAIN MODULE ]] --
AddToggle(Main, "Silent Aim", "SilentAim")
AddToggle(Main, "Wallbang (All Surfaces)", "Wallbang")
AddToggle(Main, "Auto Shoot", "AutoShoot")
AddToggle(Main, "Trigger Bot", "TriggerBot")
AddSlider(Main, "Hitchance %", 0, 100, 100, "Hitchance")
AddSlider(Main, "Aim Field of View", 0, 1000, 100, "AimFov")
AddToggle(Main, "No Recoil (100%)", "NoRecoil")
AddToggle(Main, "No Spread", "NoSpread")
AddToggle(Main, "Rapid Fire", "RapidFire")
AddToggle(Main, "Instant Reload", "InstantReload")
AddToggle(Main, "Infinite Ammo", "InfAmmo")
AddToggle(Main, "Fast Pump (Shotgun)", "FastPump")
AddToggle(Main, "No Sway", "NoSway")
AddToggle(Main, "Bullet Tracer (Snap)", "BulletTraces")
-- [[ RAGE MODULE ]] --
AddToggle(Rage, "Enable Ragebot", "RageEnabled")
AddToggle(Rage, "Spinbot (X/Y/Z)", "Spinbot")
AddSlider(Rage, "Spinbot Speed", 1, 500, 50, "SpinSpeed")
AddToggle(Rage, "Anti-Aim (Desync)", "AntiAim")
AddToggle(Rage, "Kill Aura (Melee/Close)", "KillAura")
AddSlider(Rage, "Aura Range", 1, 50, 15, "AuraRange")
AddToggle(Rage, "Auto Respawn (Instant)", "AutoRespawn")
AddToggle(Rage, "Teleport to Players", "TpPlayers")
AddToggle(Rage, "Crash Server (Experimental)", "ServerCrasher")
AddToggle(Rage, "Shield Bypass", "ShieldBypass")
-- [[ ESP MODULE ]] --
AddToggle(ESPTab, "Master Switch", "ESPEnabled")
AddToggle(ESPTab, "Box ESP (2D/3D)", "ESPBoxes")
AddToggle(ESPTab, "Skeleton (Bones)", "ESPSkeletons")
AddToggle(ESPTab, "Tracers (Bottom/Center)", "ESPTracers")
AddToggle(ESPTab, "Show Names", "ESPNames")
AddToggle(ESPTab, "Show Distance", "ESPDist")
AddToggle(ESPTab, "Show Health Bar", "ESPHealth")
AddToggle(ESPTab, "Show Current Weapon", "ESPWeapons")
AddToggle(ESPTab, "View Angle Lines", "ESPViewLines")
AddToggle(ESPTab, "Team Check", "ESPTeamCheck")
AddToggle(ESPTab, "Chams (Wallhack)", "ESPChams")
-- [[ MISC MODULE ]] --
AddSlider(Misc, "Walk Speed Bypass", 16, 1000, 16, "WalkSpeed")
AddSlider(Misc, "Jump Power Multiplier", 50, 1000, 50, "JumpPower")
AddSlider(Misc, "Gravity Modifier", 0, 196, 196, "Gravity")
AddToggle(Misc, "Fly (V-Style)", "FlyEnabled")
AddSlider(Misc, "Fly Speed Multiplier", 1, 20, 1, "FlySpeed")
AddToggle(Misc, "Noclip (Walk Through Walls)", "Noclip")
AddToggle(Misc, "Infinite Jump", "InfJump")
AddToggle(Misc, "Auto Bunnyhop", "Bhop")
AddToggle(Misc, "Speed Bypass (No Kick)", "SpeedBypass")
AddToggle(Misc, "Anti-Void (TP Up)", "AntiVoid")
AddToggle(Misc, "Water Walk", "WaterWalk")
-- [[ CHARACTER MODULE ]] --
AddToggle(Character, "Invisibility (Client Side)", "Invis")
AddToggle(Character, "Fake Lag (Desync)", "FakeLag")
AddSlider(Character, "Fake Lag Limit", 1, 15, 5, "LagLimit")
AddToggle(Character, "God Mode (Semi)", "GodMode")
AddToggle(Character, "No Fall Damage", "NoFall")
AddToggle(Character, "Auto Eat / Heal", "AutoHeal")
AddToggle(Character, "Headless Mode", "Headless")
-- [[ VISUALS & SETTINGS ]] --
AddSlider(Visuals, "Field of View (FOV)", 70, 150, 70, "FovValue")
AddToggle(Visuals, "Full Brightness", "FullBright")
AddToggle(Visuals, "No Fog / Smoke", "NoFog")
AddToggle(Visuals, "Rainbow UI Theme", "RainbowUI")
AddToggle(Visuals, "Third Person Mode", "ThirdPerson")
AddToggle(Visuals, "No Camera Shake", "NoShake")
AddToggle(Visuals, "Crosshair Customizer", "Crosshair")
AddToggle(Settings, "Save Configuration", "SaveConf")
AddToggle(Settings, "Auto Load Config", "LoadConf")
AddToggle(Settings, "Unload Cheat", "Unload")
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- 1. 이동 관련 (Speed, Fly, Noclip)
        if _G.WalkSpeed > 16 then 
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * (_G.WalkSpeed/100)) 
        end
        
        -- 2. 레이지 관련 (Spinbot)
        if _G.Spinbot then 
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.SpinSpeed), 0) 
        end

        -- 3. 비주얼 관련 (FOV, FullBright)
        Camera.FieldOfView = _G.FovValue
        if _G.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 14 end
    end
end)
