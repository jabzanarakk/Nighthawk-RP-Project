-- Server mem
Users = {}
newbie = {}

AddEventHandler('playerDropped', function()
	if(Users[source])then
		TriggerEvent("es:playerDropped", Users[source])

		MySQL:executeQuery("UPDATE users SET `money`='@value', `pos`='@pos' WHERE identifier = '@identifier'",
		{['@value'] = 0, ['@identifier'] = Users[source].identifier, ['@pos'] = Users[source].coords})

		Users[source] = nil
	end
end)

local justJoined = {}

RegisterServerEvent('es:sessionStart')
AddEventHandler('es:sessionStart', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	if(Users[source] == nil)then
		debugMsg("DB API | Loading user: " .. GetPlayerName(source))
        local identifier = identifiers[i]
        if not hasAccount(identifier) then
            registerUser(identifier, source)
        else
            LoadUser(identifier, source)
        end
		justJoined[source] = true
	end
end)