getgenv().KeyInput = "Bypassed"
getgenv().KeyVerified = true

local RawData = game:HttpGet("https://raw.githubusercontent.com/mrgunz/UnnamedCheat/main/Source")

local function ExecuteUnnamed()
    local LoadedData = loadstring(RawData)
    if LoadedData then
        LoadedData()
    else
        local BackupData = game:HttpGet("https://raw.githubusercontent.com/Edgeiy/UnnamedCheat/main/Source.lua")
        loadstring(BackupData)()
    end
end

task.spawn(ExecuteUnnamed)

