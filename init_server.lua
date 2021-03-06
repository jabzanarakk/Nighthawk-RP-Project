AddEventHandler('playerConnecting', function(name, setReason)
    -- Check Ban
    local identifier = GetPlayerIdentifiers(source)[1]
	debugMsg('Checking user ban: ' .. identifier .. " (" .. name .. ")")

	local status, err = pcall(isIdentifierBanned(identifier))
	if(err)then
		dbOpen()
    end
	local banned = isIdentifierBanned(identifier)
	if(banned)then
		if(type(settings.defaultSettings.banreason) == "string")then
			setCallback(settings.defaultSettings.banreason)
		elseif(type(settings.defaultSettings.banreason) == "function")then
			setCallback(settings.defaultSettings.banreason(identifier, name))
		else
			setCallback("Default ban reason error")
		end
		CancelEvent()
	end
    -- Check RP name
    local function badNameKick ()
        setReason('ชื่อของคุณไม่สอดคล้องกับนโยบายความเป็น Role Play ของเซิฟเวอร์เรา ตัวอย่างชื่อ  "Jack Winter", "Somchai Sabyedee" สามารถเข้าไปอ่านข้อมูลเพิ่มเติมได้ที่ http://sarp.eaglege.com/rules')
        CancelEvent()
        print ('Bad Role Play name ' .. name)
    end
    
    if charNameCheck(name) and string.match(name, "%s") then
        local x = 0
        for word in string.gmatch(name, "%s+") do x = x + 1 end
        local i, j = string.find(name, "%s+")
        if x == 1 and i == j then
            local _, n = string.gsub(name, "%S+", "")
            if n == 2 then
                local fn = string.sub(name, 2, i-1)
                local ln = string.sub(name, i+2, string.len(name))
                local fcfn = string.sub(name, 1, 1)
                local fcln = string.sub(name, i+1, i+1)
                if upCharCheck(fcfn) and upCharCheck(fcln) and lowCharCheck(fn) and lowCharCheck(ln) then
                    print ('Good Role Play name ' .. name)
                else
                    badNameKick ()
                end
            else
                badNameKick ()
            end
        else
            badNameKick ()
        end
    else
        badNameKick ()
    end
    -- Check Rename
    if hasAccount(identifier) then
        if renameCheck(identifier, name) then
            setReason('ชื่อของคุณไม่ตรงกับที่สมัครใว้ หากพบปัญหา ติดต่อได้ที่ http://sarp.eaglege.com/contact')
            CancelEvent()
            print ('Rename Kick ' .. name)
        end
    end
end)
