local upChar = SARP_SETTINGS.upChar
local lowChar = SARP_SETTINGS.lowChar

function inArray (array, val)
    for index, value in ipairs(array) do
        if value == val then
            return true
        end
    end

    return false
end

function charNameCheck (str)
    local n = string.len(str)

    for i=n,1,-1 do 
        local x = tostring(string.byte(str,i))
        if inArray(lowChar, x) or inArray(upChar, x) or x == "32" then
            -- do noting
        else
            return false
        end
        if i == 1 then
            return true
        end
    end
end

function lowCharCheck (str)
    local n = string.len(str)

    for i=n,1,-1 do 
        local x = tostring(string.byte(str,i))
        if inArray(lowChar, x) then
            -- do noting
        else
            return false
        end
        if i == 1 then
            return true
        end
    end
end

function upCharCheck (str)
    local n = string.len(str)

    for i=n,1,-1 do 
        local x = tostring(string.byte(str,i))
        if inArray(upChar, x) then
            -- do noting
        else
            return false
        end
        if i == 1 then
            return true
        end
    end
end

function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end

  return t
end

function startswith(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function returnIndexesInTable(t)
	local i = 0;
	for _,v in pairs(t)do
 		i = i + 1
	end
	return i;
end

function debugMsg (msg)
    if(SARP_SETTINGS.debugInformation and msg)then
        print("SARP DEBUG: " .. msg)
    end
end
