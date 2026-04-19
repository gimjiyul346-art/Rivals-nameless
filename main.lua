getgenv().KeyInput = "Bypassed"
getgenv().KeyVerified = true

local SourceURL = "https://raw.githubusercontent.com/mrgunz/UnnamedCheat/main/Source"
local Core = game:HttpGet(SourceURL)

loadstring(Core)()

