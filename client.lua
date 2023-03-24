
ESX = exports["es_extended"]:getSharedObject()

AddEventHandler('esx:onPlayerSpawn', function()
    ClearTimecycleModifier()
    SetPedMotionBlur(PlayerPedId(), false)
    ClearExtraTimecycleModifier()
    if not firstSpawn then
        firstSpawn = false
        ESX = exports["es_extended"]:getSharedObject()
        ESX.TriggerServerCallback('xx:getInformation',function(data)
                if data[1].health then
                    local decoded = json.decode(data[1].health)
                    Wait(1000)
                    if decoded and type(decoded) == 'table' and decoded.health and decoded.armour then
                        SetEntityHealth(PlayerPedId(), decoded.health)
                        SetPedArmour(PlayerPedId(), decoded.armour)
                    end
                end
        end)
    end
end)

Citizen.CreateThread(function()
    ESX = exports["es_extended"]:getSharedObject()
    while true do
        Wait(5000)
        local ped = PlayerPedId()
        TriggerServerEvent('ob_saveinfo', GetPedArmour(ped), GetEntityHealth(ped))
    end
end)