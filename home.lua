print("home работает")
local BASE = "https://github.com/skirkzhdimenya-source/DeadEye/tree/main"

local function loadFile(name)
    local success, result = pcall(function()
        local code = game:HttpGet(BASE .. name)
        local func = assert(loadstring(code))
        return func()
    end)

    if success then
        print("[Loader] " .. name .. " запущен")
    else
        warn("[Loader] Ошибка в " .. name .. ": " .. tostring(result))
    end
end

loadFile("home.lua")
loadFile("vis.lua")
loadFile("oth.lua")

print("[Loader] Все скрипты загружены!")
