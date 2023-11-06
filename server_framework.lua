local ox_inventory = GetResourceState('ox_inventory') == 'started' and true
local QBCore, ESX = nil, nil

if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

function GetPlayer(source)
    if QBCore then
        return QBCore.Functions.GetPlayer(source)
    elseif ESX then
        return ESX.GetPlayerFromId(source)
    end
end

function AddMoney(source, money_type, amount, reason)
    local Player = GetPlayer(source)
    if QBCore then
        Player.Functions.AddMoney(money_type, amount, reason)
    elseif ESX then
        Player.addAccountMoney(money_type, amount, reason)
    end
end

function AddItem(source, item_name, amount, metadata)
    if ox_inventory then exports.ox_inventory:AddItem(source, item_name, amount, metadata) return end -- if ox inv skips the rest
    local Player = GetPlayer(source)
    if QBCore then
        Player.Functions.AddItem(item_name, amount, false, metadata)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item_name], "add")
    elseif ESX then 
        Player.addInventoryItem(item_name, amount, metadata)
    end
end

function RemoveItem(source, item_name)
    if ox_inventory then exports.ox_inventory:RemoveItem(source, item_name, 1) return end -- if ox inv skips the rest
    local Player = GetPlayer(source)
    if QBCore then
        Player.Functions.RemoveItem(item_name, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item_name], "remove")
    elseif ESX then 
        Player.removeInventoryItem(item_name, 1)
    end
end