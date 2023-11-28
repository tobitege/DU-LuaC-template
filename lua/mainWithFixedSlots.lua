-- DU-LuaC template with fixed slots by tobitege
-- Script requires screen and databank to be linked in this fixed order!!!

-- This script is drafted to have this project entry point load most
-- required code parts via xpcall's for error handling.
-- Generally speaking such parts can be:
--  * globals -> as the name suggests ;)
--  * startup -> not used in this entry point!
--  * library -> any shared, independent objects and functions
--  * events -> DU-LuaC assignment of code to specific element's events
--  * main -> the actual main code of this project

-- First some setup code to allow debugging in VSCode.
-- These 2 lines do not interfere ingame but allow the use
-- of debuggers running the script outside of the game.
---@diagnostic disable: param-type-mismatch
package.path = "lua/?.lua;util/?.lua;"..package.path

-- File with commonly shared, independent global constants and switches etc.
-- This is for use across multiple project entry points.
require('globals')

-- Compared to the "main.lua" script, we don't use the "startup" file 
-- here since slots are fixed and named!

-- Since the project file specifies named slots, we now must
-- check for "MyScreen" and "MyDB" to actually exist or error out:
if not MyScreen or not MyDB then
    P("[E] First link screen, then databank!")
    unit.exit()
    return
end

-- The "common-library" could contain commonly shared functions
-- for use across multiple project entries.
-- Remove or replace as needed!
local status, err, _ = xpcall(function() require('common-library') end, traceback)
if not status then
    P("[E] Error in common-library!")
    if err then P(err) end
    unit.exit()
    return
end

-- Event example: attach code to the screen's onOutputChanged event.
-- This assumes the code in the file to return a table with a Run function
-- and 1 parameter (here "output" is coming from the screen)!
-- This ONLY works with the screen being a fixed slot in the project file
-- as otherwise DU-LuaC won't be able to add its event handler code
-- in the corresponding LUA section!
local screenEvent = require('main-screen.onOutputChanged')
if screenEvent ~= nil then
    -- important: event names start lowercase!
    MyScreen:onEvent('onOutputChanged', function (self, output) screenEvent.Run(output) end)
end

-- Require the main script's code and in case of error, stop the board
status, err, _ = xpcall(function() require('main-onStart') end, traceback)
if not status then
    P("[E] Error in main-onStart!")
    if err then P(err) end
    unit.exit()
end

-- Any additional code can be placed here
P("Script finished.")

-- Optionally hide the programming board widget
--unit.hideWidget()

-- Optionally end the script now
unit.exit()