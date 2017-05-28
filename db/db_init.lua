-- Server mem
Users = {}

require "resources/sarp/lib/MySQL"
MySQL:open("127.0.0.1", "sarp_01", "Eagleone", "129657")

AddEventHandler('playerDropped', function()
	if(Users[source])then
		TriggerEvent("sarp:playerDropped", Users[source])
        
        local LastPos = "{" .. Users[source].coords.x .. ", " .. Users[source].coords.y .. ", " .. Users[source].coords.z .. "}"
		MySQL:executeQuery("UPDATE users SET `money`='@value', `pos`='@pos' WHERE identifier = '@identifier'",
		{['@value'] = 0, ['@identifier'] = Users[source].identifier, ['@pos'] = LastPos})

		Users[source] = nil
	end
end)

RegisterServerEvent('sarp:sessionStart')
AddEventHandler('sarp:sessionStart', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	if(Users[source] == nil)then
        local name = GetPlayerName(source)
		debugMsg("DB API | Loading user: " .. identifier)
        if not hasAccount(identifier) then
            registerUser(identifier, name, source)
        else
            LoadUser(identifier, source)
        end
	end
end)

RegisterServerEvent('sarp:updatePositions')
AddEventHandler('sarp:updatePositions', function(x, y, z)
	if(Users[source])then
		Users[source]:setCoords(x, y, z)
	end
end)