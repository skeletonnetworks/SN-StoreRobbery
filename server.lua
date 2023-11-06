local Data = nil
local RobbedRegisters = nil
local RobbedSafes = nil
local  TimeSeconds = {
    ['days'] = 86400,
    ['hours'] = 3600,
    ['minutes'] = 60,
    ['seconds'] = 1,
}

CreateThread(function() 
    Data = json.decode(LoadResourceFile('SN-StoreRobbery', 'Save.json')) or {}
    local currentTime = os.time()
    local TimePassed = 0
    if Data.lastSave then
        TimePassed = FormatTime(os.difftime(currentTime, Data.lastSave))
    end
    if not Data.lastSave or TimePassed[Config.storeCooldown.time] >= Config.storeCooldown.amount then
        Data.lastSave = currentTime
        Data.RobbedRegisters  = {}
        Data.RobbedSafes = {}
        SaveResourceFile('SN-StoreRobbery', 'Save.json', json.encode(Data), -1)
        CooldownLoop(0)
    else
        CooldownLoop(TimePassed['seconds'])
    end
    RobbedRegisters = Data.RobbedRegisters
    RobbedSafes = Data.RobbedSafes
end)

RegisterNetEvent('SN-Shops:Server:GetSave', function()
    local src = source
    TriggerClientEvent('SN-Shops:Client:UpdateSafes', src, RobbedSafes)
    TriggerClientEvent('SN-Shops:Client:UpdateRegisters', src, RobbedRegisters)
end)

RegisterNetEvent('SN-Shops:Server:RemoveItem', function(item)
    local src = source
    RemoveItem(src, item)
end)

RegisterNetEvent('SN-Shops:Server:SafeHackDone', function(ShopID, CoordsID, removeitem)
    local src = source
    if RobbedSafes[CoordsID] == true then return end
    if removeItem then 
        RemoveItem(src, Config.register_loot.item_needed)
    end
    RobbedSafes[CoordsID] = true
    TriggerClientEvent('SN-Shops:Client:UpdateSafes', -1, RobbedSafes)
    UpdateFile()
    SafeTimmer(ShopID)
end)

RegisterNetEvent('SN-Shops:Server:Reward', function(type, id, removeitem)
    local src = source
    if type == 'register' then
        if RobbedRegisters[id] == true then return end
        RobbedRegisters[id] = true
        TriggerClientEvent('SN-Shops:Client:UpdateRegisters', -1, RobbedRegisters)
        UpdateFile()
        local amount = math.random(Config.register_loot.reward_amount[1], Config.register_loot.reward_amount[2])
        if Config.register_loot.reward == ('cash' or 'bank' or 'money') then
            AddMoney(src, Config.register_loot.reward, amount, 'shop register')
        else
            if Config.register_loot.amount_type == 'info' then
                local info = {worth = amount}
                AddItem(src, Config.register_loot.reward, 1, info)
            else
                AddItem(src, Config.register_loot.reward, amount)
            end
        end
    elseif type == 'safe' then
        TriggerClientEvent('SN-Shops:Client:UpdateSafeDoor', -1, id, false)
        if removeItem then 
            RemoveItem(src, Config.safe_loot.item_needed)
        end
        local amount = math.random(Config.safe_loot.reward_amount[1], Config.safe_loot.reward_amount[2])
        if Config.safe_loot.reward == ('cash' or 'bank' or 'money') then
            AddMoney(src, Config.safe_loot.reward, amount, 'shop safe')
        else
            if Config.safe_loot.amount_type == 'info' then
                local info = {worth = amount}
                AddItem(src, Config.safe_loot.reward, 1, info)
            else
                AddItem(src, Config.safe_loot.reward, amount)
            end
        end
    end
end)

function SafeTimmer(ShopID, CoordsID)
    CreateThread(function()
        SetTimeout(Config.safeTimer, function()
            TriggerClientEvent('SN-Shops:Client:UpdateSafeDoor', -1, ShopID, true)
        end)
    end)
end

function UpdateFile()
    Data.RobbedRegisters = RobbedRegisters
    Data.RobbedSafes = RobbedSafes
    SaveResourceFile('SN-StoreRobbery', 'Save.json', json.encode(Data), -1)
end

function FormatTime(time)
    local days = math.floor(time/86400)
    local hours = math.floor(math.modf(time, 86400)/3600)
    local minutes = math.floor(math.modf(time,3600)/60)
    local seconds = math.floor(math.modf(time,60))
    return {days = days,hours = hours,minutes = minutes,seconds = seconds}
end

function CooldownLoop(secondsPassed)
    SetTimeout(((TimeSeconds[Config.storeCooldown.time] * Config.storeCooldown.amount) - secondsPassed) *1000, function()
        local currentTime = os.time()
        Data.lastSave = currentTime
        Data.RobbedRegisters = {}
        Data.RobbedSafes = {}
        SaveResourceFile('SN-StoreRobbery', 'Save.json', json.encode(Data), -1)
        CooldownLoop(0)
    end)
end