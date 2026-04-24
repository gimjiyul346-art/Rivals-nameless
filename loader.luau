-- [[ UNNAMED HUB CRACKED FOR CODEX ]] --
-- 멈춤 방지를 위한 태스크 스케줄링 적용

task.wait(0.5) -- 코덱스 엔진이 준비될 때까지 잠시 대기

local function LoadScript()
    -- 1. 유료 UI 라이브러리 (코덱스 최적화 서버에서 로드)
    local Success, Library = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
    end)

    if not Success then 
        warn("UI 로드 실패 - 다시 실행해주세요")
        return 
    end

    -- 2. 메인 윈도우 생성
    local Window = Library:CreateWindow({
        Title = 'UNNAMED PREMIUM | CODEX BYPASS',
        Center = true,
        AutoShow = true,
    })

    -- 3. 기능 구성 (가장 가벼운 세팅)
    local Tabs = {
        Main = Window:AddTab('Main'),
        Misc = Window:AddTab('Misc')
    }

    local Combat = Tabs.Main:AddLeftGroupbox('Combat')
    Combat:AddToggle('SAim', { Text = 'Silent Aim', Default = false })
    Combat:AddSlider('FOV', { Text = 'FOV', Default = 150, Min = 0, Max = 500, Rounding = 0 })

    -- 4. 유료급 사일런트 에임 엔진 (매칭 서버 우회 포함)
    local OldNC
    OldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if Toggles.SAim and Toggles.SAim.Value and method == "Raycast" and not checkcaller() then
            -- 유료 버전의 타겟팅 로직을 짧고 굵게 압축
            local target = nil
            local dist = Toggles.FOV.Value
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                    local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                    if vis then
                        local mDist = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                        if mDist < dist then dist = mDist target = v end
                    end
                end
            end
            if target then
                args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
                return OldNC(self, unpack(args))
            end
        end
        
        -- 화이트리스트 에러 킥 방지
        if method == "Kick" and not checkcaller() then return nil end
        
        return OldNC(self, unpack(args))
    end)

    Library:Notify('언네임드 크랙 로드 성공!')
end

-- 안전하게 실행
task.spawn(LoadScript)
