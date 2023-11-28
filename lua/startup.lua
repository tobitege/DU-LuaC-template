-- startup for initial slots detection depending on Config flags
local status, err=false,nil
if INGAME then
    ---@diagnostic disable-next-line: undefined-global
    -- Using DU-LuaC's automatic link detection code
    status, err, _ = xpcall(function()
        if Config.c_required then
            Config.core = library.getCoreUnit()
        end
        if Config.db_required then
            Config.databanks = library.getLinksByClass('DataBank', true) -- true is important!
        end
        if Config.s_required then
            Config.screens = library.getLinksByClass('Screen', true)
        end
    end, traceback)
    if not status then
        P("[E] Error in Link Detection:\n" .. err)
        unit.exit()
        return
    end
else
    -- use mocks (not included in this repo!)
    Config.core = unit.core
    Config.databanks =  { unit.databank }
    Config.screens =  { unit.screen }
end

if #Config.databanks > 0 then
    local plural = ""
    if #Config.databanks > 1 then plural = "s" else plural = " '"..Config.databanks[1].getName().."'" end
    P("[I] "..#Config.databanks .. " databank" .. plural .. " connected.")
else
    if Config.db_required then
        P("[E] No databank found!")
        unit.exit()
        return
    end
end
if #Config.screens > 0 then
    local plural = ""
    if #Config.screens > 1 then plural = "s" end
    P("[I] "..#Config.screens .. " screen" .. plural .. " connected.")
else
    if Config.s_required then
        P("[E] No screen found!")
        unit.exit()
        return
    end
end