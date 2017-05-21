Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('sarp:sessionStart')
			return
		end
	end
end)

AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
    
    exports.spawnmanager:setAutoSpawnCallback(function()
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(3)
                TriggerServerEvent('es:getPlayerFromId', source, function(user)
                    if user ~= nil then
                        TriggerServerEvent('sarp:spawn')
                        return
                    end
                end)
            end
        end)
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