Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('lsrp:dbLoad')
			return
		end
	end
end)

AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
    
    exports.spawnmanager:setAutoSpawnCallback(function()
        if(true)then
            TriggerServerEvent('sarp:spawn')
        end
    end)
end)

RegisterNetEvent("sarp:notify")
AddEventHandler("sarp:notify", function(icon, type, sender, title, text)
    Wait(1)
    SetNotificationTextEntry("STRING");
    AddTextComponentString(text);
    SetNotificationMessage(icon, icon, true, type, sender, title, text);
    DrawNotification(false, true);
end)

RegisterNetEvent('sarp:spawnPlayer')
AddEventHandler('sarp:spawnPlayer', function(x, y, z, model)
	exports.spawnmanager:spawnPlayer({x = x, y = y, z = z, model = GetHashKey(model)})
end)