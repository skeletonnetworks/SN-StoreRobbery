local RobbedRegisters = {}
local RobbedSafes = {}
local OpenedSafe = {}

CreateThread(function()
    TriggerServerEvent('SN-Shops:Server:GetSave')
    for i, Shop in pairs(Shops) do
        AddTargetBox('ShopSafe'..i, Shop.safe, {
            {
                icon = 'fas fa-laptop',
                label = 'Hack Safe',
                item = Config.safe_loot.item_needed,
                items = Config.safe_loot.item_needed,
                debug = Config.debug,
                distance = 2.0,
                action = function()
                    local coordsID = tostring(math.floor(Shop.safe.x+Shop.safe.y+Shop.safe.z))
                    if RobbedSafes[coordsID] then return Config.Notify('Safe was recently robbed.','error') end
                    if exports['SN-Hacking']:MemoryGame(6, 3, 10000) then
                        local removeItem = false
                        if Config.safe_loot.remove_item_fail ~= false then
                            if type(Config.safe_loot.remove_item_fail) == 'table' and math.random(Config.safe_loot.remove_item_fail[1], Config.safe_loot.remove_item_fail[2]) == 1 then
                                removeItem = true
                            elseif type(Config.safe_loot.remove_item_fail) == 'bool' then
                                removeItem = true
                            end
                        end
                        Config.Notify('You are in wait a for the safe to open.', 'success')
                        TriggerServerEvent('SN-Shops:Server:SafeHackDone', i, coordsID, removeItem)
                    else
                        if Config.safe_loot.remove_item_fail ~= false then
                            if type(Config.safe_loot.remove_item_fail) == 'table' and math.random(Config.safe_loot.remove_item_fail[1], Config.safe_loot.remove_item_fail[2]) == 1 then
                                TriggerServerEvent('SN-Shops:Server:RemoveItem', Config.safe_loot.item_needed)
                            elseif type(Config.safe_loot.remove_item_fail) == 'bool' then
                                TriggerServerEvent('SN-Shops:Server:RemoveItem', Config.safe_loot.item_needed)
                            end
                        end
                    end
                end,
            },
            {
                icon = 'fas fa-sack-dollar',
                label = 'Grab Loot',
                distance = 2.0,
                action = function()
                    TriggerServerEvent('SN-Shops:Server:Reward', 'safe', i)
                end,
                canInteract = function()
                    return OpenedSafe[i]
                end,
            }
        })
    end
    AddTargetModel('prop_till_01', {
        {
            icon = 'fas fa-sack-dollar',
            label = "Rob",
            item = Config.register_loot.item_needed,
            items = Config.register_loot.item_needed,
            distance = 2.0,
            action = function(entity)
                if type(entity) == 'table' then entity = entity.entity end
                local coords = GetEntityCoords(entity)
                local coordsID = tostring(math.floor(coords.x+coords.y+coords.z))
                if RobbedRegisters[coordsID] then return Config.Notify('Register was recently robbed.','error') end
                if math.abs(GetEntityHeading(entity)-GetEntityHeading(PlayerPedId())) > 70 then return Config.Notify('You are not behind the counter!','error') end
                if exports['SN-Hacking']:SkillCheck(40, 5000, {'w','a','s','w'}, 3, 20, 3) then
                    local removeItem = false
                    if Config.register_loot.remove_item_fail ~= false then
                        if type(Config.register_loot.remove_item_fail) == 'table' and math.random(Config.register_loot.remove_item_fail[1], Config.register_loot.remove_item_fail[2]) == 1 then
                            removeItem = true
                        elseif type(Config.register_loot.remove_item_fail) == 'bool' then
                            removeItem = true
                        end
                    end
                    TriggerServerEvent('SN-Shops:Server:Reward', 'register', coordsID, removeItem)
                else
                    if Config.register_loot.remove_item_fail ~= false then
                        if type(Config.register_loot.remove_item_fail) == 'table' and math.random(Config.register_loot.remove_item_fail[1], Config.register_loot.remove_item_fail[2]) == 1 then
                            TriggerServerEvent('SN-Shops:Server:RemoveItem', Config.register_loot.item_needed)
                        elseif type(Config.register_loot.remove_item_fail) == 'bool' then
                            TriggerServerEvent('SN-Shops:Server:RemoveItem', Config.register_loot.item_needed)
                        end
                    end
                end
            end,
            canInteract = function(entity)
                for i, shop in pairs(Shops) do
                    if #(GetEntityCoords(entity) - shop.counter) < 10.0 then
                        return true
                    end
                end
                return false
            end,
        }
    })
end)

RegisterNetEvent('SN-Shops:Client:UpdateRegisters', function(NewData)
    RobbedRegisters = NewData
end)

RegisterNetEvent('SN-Shops:Client:UpdateSafes', function(NewData)
    RobbedSafes = NewData
end)

RegisterNetEvent('SN-Shops:Client:UpdateSafeDoor', function(ShopID, Bool)
    OpenedSafe[ShopID] = Bool
    if Bool then
        exports.xsound:PlayUrlPos('safe_opened', 'https://www.youtube.com/watch?v=R8WB_-Pfd-I', 0.2, vector3(Shops[ShopID].safe.x, Shops[ShopID].safe.y, Shops[ShopID].safe.z), false, {})
        exports.xsound:Distance('safe_opened', 15)
    end
end)

function AddTargetBox(id, coords, options)
    if Config.target.script == 'qb-target' then
        exports[Config.target.name or 'qb-target']:AddBoxZone(id, coords.xyz, 1.0, 1.0, {
            name = id,
            heading = coords.w,
            debugPoly = Config.debug,
            minZ = coords.z-1.0,
            maxZ = coords.z+1.5,
        }, {
            options = options,
            distance = 2.5,
        })
    elseif Config.target.script == 'ox_target' then
        for i, option in pairs(options) do option.onSelect = option.action end
        exports[Config.target.name or 'ox_target']:addBoxZone({
            name = id,
            debug = Config.debug,
            coords = vec3(coords.x, coords.y, coords.z),
            size = vec3(1.0, 1.0, 1.0),
            rotation = coords.w,
            options = options,
        })
    end
end

function AddTargetModel(model, options)
    if Config.target.script == 'qb-target' then
        exports[Config.target.name or 'qb-target']:AddTargetModel(model,{
            options = options,
            distance = 2.0
        })
    elseif Config.target.script == 'ox_target' then
        for i, option in pairs(options) do option.onSelect = option.action end
        exports[Config.target.name or 'ox_target']:addModel(model, options)
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for i, location in pairs(Shops) do
        if Config.target.script == 'qb-target' then
            exports[Config.target.name or 'qb-target']:RemoveZone('ShopSafe'..i)
        elseif Config.target.script == 'ox_target' then
            exports[Config.target.name or 'ox_target']:removeZone('ShopSafe'..i)
        end
    end
end)