Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('sarp:sessionStart')
			return
		end
	end
end)

local loaded = false
local cashy = 0
local oldPos

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local pos = GetEntityCoords(GetPlayerPed(-1))

		if(oldPos ~= pos)then
			TriggerServerEvent('sarp:updatePositions', pos.x, pos.y, pos.z)

			if(loaded)then
				SendNUIMessage({
					setmoney = true,
					money = cashy
				})

				loaded = false
			end
			oldPos = pos
		end
	end
end)

AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:forceRespawn()
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

RegisterNetEvent('sarp:activateMoney')
AddEventHandler('sarp:activateMoney', function(e)
	SendNUIMessage({
		setmoney = true,
		money = e
	})
end)

RegisterNetEvent("sarp:addedMoney")
AddEventHandler("sarp:addedMoney", function(m)
	SendNUIMessage({
		addcash = true,
		money = m
	})

end)

RegisterNetEvent("sarp:removedMoney")
AddEventHandler("sarp:removedMoney", function(m)
	SendNUIMessage({
		removecash = true,
		money = m
	})
end)
