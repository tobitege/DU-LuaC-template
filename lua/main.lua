-- DU-LuaC template with dynamic slot detection by tobitege

-- This script is drafted to have this project entry point load most
-- required code parts via xpcall's for error handling.
-- Generally speaking such parts can be:
--  * globals -> as the name suggests ;)
--  * startup -> runs link detection and sets global Config variable
--  * library -> any shared, independent objects and functions
--  * events -> DU-LuaC assignment of code to specific element's events
--  * main -> the actual main code of this project

-- First some setup code to allow debugging in VSCode.
-- These 2 lines do not interfere ingame but allow the use
-- of debuggers running the script outside of the game.
---@diagnostic disable: param-type-mismatch
package.path = "lua/?.lua;util/?.lua;"..package.path

-- File with commonly shared, independent global constants and switches etc.
-- This is for use across multiple project entry points and most importantly
-- defines a "Config" global variable (see below)
require('globals')

-- "startup" has all the Config setup with links detection.
-- By default config requires links to core, a screen and a databank.
-- Here we choose to not require a core link for demonstration:
Config.core_required = false
local status, err, _ = xpcall(function() require('startup') end, traceback)
if not status then
    P("[E] Error in startup!")
    if err then P(err) end
    unit.exit()
    return
end

-- Example: we could check that exactly 2 databanks were (linked and) detected:
-- if #Config.databanks ~= 2 then
--     P("[E] 2 databanks must be linked!")
--     unit.exit()
--     return
-- end

-- Using global variables (uppercase 1st letter) for our elements.
-- We choose to use the first databank and screen (could by mistake have more linked)
-- Comment out/remove any line if no databank or screen is required.
Databank = Config.databanks[1]
Screen = Config.screens[1]

-- The "common-library" could contain commonly shared functions
-- for use across multiple project entries
-- Remove or replace as needed!
status, err, _ = xpcall(function() require('common-library') end, traceback)
if not status then
    P("[E] Error in common-library!")
    if err then P(err) end
    unit.exit()
    return
end

-- Event example: attaching a function to the system.onInputText() event at runtime.
-- Instead of using inline code right here, it is in a separate file
-- to return a table with a "Run" method declaration (name can be anything)
-- and a single parameter ("text" is the actual LUA chat input then).
local inpEvent = require('main-sys_onInputText')
if inpEvent ~= nil then
    -- important: event names start lowercase!
    system:onEvent('onInputText', function (self, text) inpEvent.Run(text) end)
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