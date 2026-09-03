local G = getgenv().DeadEye or {}

getgenv().DeadEye = G

G.State = G.State or {}
G.UI = G.UI or {}
G.Functions = G.Functions or {}

print("[DeadEye] home.lua работает")
local BASE = "https://raw.githubusercontent.com/skirkzhdimenya-source/DeadEye/main/"

local function loadFile(name)
    local success, result = pcall(function()

        local code = game:HttpGet(BASE .. name)

        local func, err = loadstring(code)

        assert(func, err)

        return func()

    end)

    if success then
        print("[DeadEye] " .. name .. " успешно запущен")
    else
        warn("[DeadEye] ошибка " .. name .. ": " .. tostring(result))
    end
end

loadFile("main.lua")
loadFile("vis.lua")
loadFile("oth.lua")
