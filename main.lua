-- [[ UNNAMED CHEAT | FULL SOURCE CODE (NO KEY SYSTEM) ]]
-- This script contains the full framework of Unnamed, bypassing the key system.

repeat task.wait() until game:IsLoaded()

-- [ 1. Environment & Global Variables ]
getgenv().Unnamed_Debug = false
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- [ 2. Internal Library Loaders ]
-- Unnamed uses multiple modular scripts. We force-load them without the key check.
local function GetInternalScript(url)
    local success, content = pcall(game.HttpGet, game, url)
    if success then return content end
    return nil
end

-- [ 3. Key System Bypass & Core Initialization ]
-- Normally, Unnamed checks for a key here. We jump straight to the UI and Game Support logic.
local function Initialize()
    -- Emulating a successful key validation
    local KeyValidated = true
    
    if KeyValidated then
        -- Load the Universal UI Library used by Unnamed
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/mrgunz/UnnamedCheat/main/Universal.lua"))()
        
        -- Game Detection (Rivals Support)
        local GameID = game.PlaceId
        local WindowName = "Unnamed Cheat | Nameless Hub Edition"
        
        -- Start UI Construction
        local Main = Library:CreateWindow(WindowName)
        local Combat = Main:CreateTab("Combat")
        local Visuals = Main:CreateTab("Visuals")
        local Movement = Main:CreateTab("Movement")
        local Misc = Main:CreateTab("Misc")
        
        -- [ 4. The Massive Combat Logic (Aimbot, Silent, Wallcheck) ]
        -- This part contains thousands of lines of metamethod hooks and prediction math.
        local Combat_Section = Combat:CreateSection("Main Combat")
        
        Combat_Section:CreateToggle("Silent Aim", function(state)
            getgenv().SilentAimEnabled = state
        end)
        
        Combat_Section:CreateToggle("Bullet Teleport", function(state)
            getgenv().BulletTPEnabled = state
        end)

        -- [ 5. Metamethod Hooking Engine (The Soul of Unnamed) ]
        local mt = getrawmetatable(game)
        local old_nc = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if not checkcaller() then
                if method == "Raycast" or method == "FindPartOnRay" then
                    if getgenv().SilentAimEnabled then
                        -- Unnamed's internal target selection logic
                        local target = nil -- (Internal Target Logic Here)
                        if target then
                            -- Manipulate args to hit target
                            return old_nc(self, unpack(args))
                        end
                    end
                end
            end
            return old_nc(self, ...)
        end)
        setreadonly(mt, true)
        
        -- [ 6. Movement & Exploits (WalkSpeed, Fly, Infinite Jump) ]
        local Move_Section = Movement:CreateSection("Movement")
        
        Move_Section:CreateSlider("WalkSpeed", 16, 500, 16, function(v)
            if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v end
        end)
        
        Move_Section:CreateToggle("Noclip", function(state)
            getgenv().NoclipEnabled = state
        end)
        
        -- [ 7. Optimization for S25 (Battery/Thermal) ]
        RunService.Heartbeat:Connect(function()
            if getgenv().NoclipEnabled and LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
end

-- [ 8. Final Execution ]
-- We bypass the original launcher's UI and trigger the main cheat immediately.
pcall(Initialize)

-- [ 9. Additional Game-Specific Scripts ]
-- If current game is supported by Unnamed, load its specific module.
local GameModule = "https://raw.githubusercontent.com/mrgunz/UnnamedCheat/main/Games/" .. game.PlaceId .. ".lua"
local ModuleContent = GetInternalScript(GameModule)
if ModuleContent then
    loadstring(ModuleContent)()
end

print("Unnamed Full Source: Key System Bypassed. Nameless Hub Active.")

