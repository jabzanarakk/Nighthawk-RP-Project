AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
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