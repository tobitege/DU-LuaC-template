-- Example of how a screen event (or any other event that passes 1 parameter)
-- could look like.
-- Function name can be different from "Run", but must be renamed
-- in main lua file accordingly!

-- This code is non-functional demo code, it does not work right now
-- as this repo doesn't include a RenderScript script for the screen
-- to actually communicate with!
local outputChanged = {}
function outputChanged.Run(output)
    -- Hint: in regular script we'd use like Screen.getScriptOutput()
    -- But how the events work, we get that passed in via "output"
    local screenoutput = output
    local screeninput = ""
    -- react to what the screen sent back
    if screenoutput == "" then
        screeninput = "?"
    elseif screenoutput == "TESTME" then
        -- do something
        P("Testme received")
    end
    Screen.setScriptInput(screeninput)
    Screen.clearScriptOutput()
    if DEBUG then
        P("* OUT: "..screenoutput)
        P("* IN: ".. screeninput)
    end
end
return outputChanged