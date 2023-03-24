ESX = exports["es_extended"]:getSharedObject()
local playerDataCache = {}
local playerIdentifiers = {}


RegisterNetEvent('ob_saveinfo', function(armour, health)
    if not playerIdentifiers[source] then
        local xPlayer = ESX.GetPlayerFromId(source)
        playerIdentifiers[source] = xPlayer.identifier
    end
    playerDataCache[source] = {
        armour = armour,
        health = health
    }
end)

AddEventHandler('playerDropped', function()
    if playerDataCache[source] and playerIdentifiers[source] then
        MySQL.Async.execute('UPDATE users SET health = @health WHERE identifier = @identifier', {
            ['@health'] = json.encode(playerDataCache[source]),
            ['@identifier'] = playerIdentifiers[source]
        })

        playerDataCache[source] = nil
        playerIdentifiers[source] = nil
    end
end)

ESX.RegisterServerCallback('xx:getInformation',
                           function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT health FROM users WHERE identifier = ?',
                 {xPlayer.identifier}, function(result) cb(result) end)
end)
RegisterNetEvent('esx:playerDropped', function(source)
    if playerDataCache[source] and playerIdentifiers[source] then
        MySQL.Async.execute('UPDATE users SET health = @health WHERE identifier = @identifier', {
            ['@health'] = json.encode(playerDataCache[source]),
            ['@identifier'] = playerIdentifiers[source]
        })

        playerDataCache[source] = nil
        playerIdentifiers[source] = nil
    end
end)