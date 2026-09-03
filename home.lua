print("home работает")

local BASE = "https://raw.githubusercontent.com/skirkzhdimenya-source/DeadEye/main/"

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

loadFile("main.lua")
loadFile("vis.lua")
loadFile("oth.lua")

print("[Loader] Все разделы загружены!")
