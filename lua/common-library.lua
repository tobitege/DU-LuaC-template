-- some global sample functions for strings
-- use at your own risk :)
function EndsWith(s, suffix)
    if not s or not suffix then return false end
    return string.sub(s, -#suffix) == suffix
end

function Rtrim(s)
    local res, _ = string.gsub(s, "%s+$", "")
    return res
end

function RtrimChar(s,char)
    if not s or not char then return s end
    while #s > 0 and EndsWith(s, char) do
        s = string.sub(s,1,#s - #char)
    end
    return s
end

function DumpTable(o)
   -- omitt any spaces in s!
   if type(o) == 'table' then
      local s = '{'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..']=' .. DumpTable(v) .. ','
      end
      s = RtrimChar(s,",")
      return s .. '}'
   else
      return tostring(o)
   end
end
