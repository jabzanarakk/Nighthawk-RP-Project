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