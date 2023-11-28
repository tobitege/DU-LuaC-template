-- Put any code to process user input (content of "text" parameter)
-- within the "Run" function.
local inputTextFunc = {}

function inputTextFunc.Run(text)
    system.print("You wrote: "..text)
end

return inputTextFunc