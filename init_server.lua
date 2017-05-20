game = {
	["currentArea"] = SARP_SETTINGS.defaultArea,
	["secondaryArea"] = nil
}

AddEventHandler('playerConnecting', function(name, setReason)
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
end)

RegisterServerEvent('sarp:spawn')
AddEventHandler('sarp:spawn', function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if(user)then
			TriggerClientEvent('es:activateMoney', source, user.money)
		end
	end)

	local pos = nil
	if(game.secondaryArea)then
		local spawns = MergeTable(game.currentArea.spawns, game.secondaryArea.spawns)
		pos = spawns[ math.random( #spawns ) ]
	else
		pos = game.currentArea.spawns[ math.random( #game.currentArea.spawns ) ]
	end
    
    if Users[source].new then
        pos = SARP_SETTINGS.spawnAreas.paletobay[ math.random( #SARP_SETTINGS.spawnAreas.paletobay ) ]
    end

	local model = "mp_m_freemode_01"
	TriggerClientEvent('sarp:spawnPlayer', source, pos.x, pos.y, pos.z, model)
end)