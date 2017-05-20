local dbName = LSRP_SETTINGS.dbName

Users = {}

local justJoined = {}

RegisterServerEvent('lsrp:dbLoad')
AddEventHandler('lsrp:dbLoad', function()
	dbGetUser(GetPlayerIdentifiers(source)[1], source)
	justJoined[source] = true
    print ('db_init')
end)