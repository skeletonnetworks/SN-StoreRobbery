Config = {}

Config.debug = false -- for debugging
Config.safeTimer = (3 * 60 * 1000)  -- how long it takes for the safe to open (miliseconds)  (3 * 60 * 1000) = 3 minutes

Config.target = {
    script = 'qb-target', -- options: qb-target or ox_target
    name = nil, --- if you renamed the script else leave nil
}

Config.storeCooldown = {
    time = 'hours', -- options: days, hours, minutes, seconds
    amount = 5 -- how many of that time
}

Config.register_loot = {
    item_needed = 'lockpick', -- item name or nil
    remove_item_success = false, --on success remove item true false or {0, number} to make it a chance it gets removed
    remove_item_fail = {0,1}, --on fail remove item true false or {0, number} to make it a chance it gets removed {0,1} == 50/50
    reward = 'markedbills',  -- options: cash, bank , money(FOR ESX) or item name
    reward_amount = {500, 1000}, -- {minimum, maximum}
    amount_type = 'info' -- options: info or item (info = metadata of 1 item) (item = amount of item) no need if you use cash or bank
}

Config.safe_loot = {
    item_needed = 'electronickit', -- item name or nil
    remove_item_success = false, --on success remove item true false or {0, number} to make it a chance it gets removed
    remove_item_fail = {0,1}, --on fail remove item true false or {0, number} to make it a chance it gets removed {0,1} == 50/50
    reward = 'markedbills', -- options: cash, bank , money(FOR ESX) or item name
    reward_amount = {1000, 2500}, -- {minimum, maximum}
    amount_type = 'info' -- options: info or item (info = metadata of 1 item) (item = amount of item)
}

Config.Notify = function(msg, type)
    TriggerEvent('QBCore:Notify', msg, type)
    --TriggerEvent('ox_lib:notify',{title = msg, type = type})
end

Shops = {
     ---==========[24/7]==========--- NOT GABZ (IF USING GABZ 24/7 line: 83-126)
    {  -- /tp 29.2 -1344.72 29.5
        counter = vector3(26.2, -1346.84, 29.5),
        safe = vector4(28.2, -1339.13, 29.5, 359.77),
    },
    { -- /tp -3042.08 588.92 7.91
        counter = vector3(-3039.97, 586.11, 7.91),
        safe = vector4(-3047.89, 585.64, 7.91, 110.47),
    },
    { -- /tp -3243.57, 1005.4, 12.83
        counter = vector3(-3242.5, 1001.8, 12.83),
        safe = vector4(-3250.06, 1004.43, 12.83, 92.38),
    },
    { -- /tp 1733.21, 6415.14, 35.04
        counter = vector3(1729.63, 6414.91, 35.04),
        safe = vector4(1734.85, 6420.86, 35.04, 330.86),
    },
    { -- /tp 377.75, 326.87, 103.57
        counter = vector3(374.38, 326.48, 103.57),
        safe = vector4(378.2, 333.42, 103.57, 250.52),
    },
    { -- /tp -49.63, -1753.66, 29.42
        counter = vector3(-47.9, -1757.46, 29.42),
        safe = vector4(-43.44, -1748.33, 29.42, 49.38),
    },
    { -- /tp 2555.38, 385.94, 108.62
        counter = vector3(2556.84, 382.54, 108.62),
        safe = vector4(2549.26, 384.89, 108.62, 87.23),
    },
    { -- /tp 2679.13, 3284.83, 55.24
        counter = vector3(2678.51, 3281.1, 55.24),
        safe = vector4(2672.69, 3286.61, 55.24, 60.15),
    },
    { -- /tp 1963.82, 3743.6, 32.34
        counter = vector3(1961.36, 3741.23, 32.34),
        safe = vector4(1959.25, 3748.98, 32.34, 26.96),
    },
    { -- /tp 543.98, 2669.18, 42.16
        counter = vector3(547.34, 2670.61, 42.16),
        safe = vector4(546.42, 2662.79, 42.16, 187.68),
    },

    ---==========[GABZ 27/7]==========---
    --[[{  -- /tp 29.2 -1344.72 29.5
        counter = vector3(26.2, -1346.84, 29.5),
        safe = vector4(31.23, -1339.27, 29.5, 267.24),
    },
    { -- /tp -3042.08 588.92 7.91
        counter = vector3(-3039.97, 586.11, 7.91),
        safe = vector4(-3048.63, 588.49, 7.91, 16.44),
    },
    { -- /tp -3243.57, 1005.4, 12.83
        counter = vector3(-3242.5, 1001.8, 12.83),
        safe = vector4(-3249.68, 1007.46, 12.83, 353.63),
    },
    { -- /tp 1733.21, 6415.14, 35.04
        counter = vector3(1729.63, 6414.91, 35.04),
        safe = vector4(1737.52, 6419.38, 35.04, 242.19),
    },
    { -- /tp 377.75, 326.87, 103.57
        counter = vector3(374.38, 326.48, 103.57),
        safe = vector4(381.07, 332.55, 103.57, 250.52),
    },
    { -- /tp -49.63, -1753.66, 29.42
        counter = vector3(-47.9, -1757.46, 29.42),
        safe = vector4(-43.36, -1748.34, 29.42, 46.88),
    },
    { -- /tp 2555.38, 385.94, 108.62
        counter = vector3(2556.84, 382.54, 108.62),
        safe = vector4(2549.44, 387.85, 108.62, 359.32),
    },
    { -- /tp 2679.13, 3284.83, 55.24
        counter = vector3(2678.51, 3281.1, 55.24),
        safe = vector4(2674.41, 3289.23, 55.24, 335.86),
    },
    { -- /tp 1963.82, 3743.6, 32.34
        counter = vector3(1961.36, 3741.23, 32.34),
        safe = vector4(1961.89, 3750.24, 32.34, 298.3),
    },
    { -- /tp 543.98, 2669.18, 42.16
        counter = vector3(547.34, 2670.61, 42.16),
        safe = vector4(543.67, 2662.61, 42.16, 101.06),
    },
    { -- Paleto
        counter = vector3(162.17, 6640.82, 31.7),
        safe = vector4(170.97, 6642.55, 31.7, 229.44),
    },]] -- GABZ END

    ---==========[LTD]==========---
    { -- /tp -711.2, -911.95, 19.22
        counter = vector3(-707.41, -914.35, 19.22),
        safe = vector4(-709.76, -904.09, 19.22, 91.89),
    },
    { -- /tp -1825.15, 791.45, 138.2
        counter = vector3(-1820.63, 793.0, 138.11),
        safe = vector4(-1829.3, 798.82, 138.19, 128.69),
    },
    { -- /tp 1158.73, -323.23, 69.21
        counter = vector3(1163.54, -323.54, 69.21),
        safe = vector4(1159.5, -314.12, 69.21, 98.55),
    },
    { -- /tp 1702.15, 4926.36, 42.06
        counter = vector3(1698.37, 4924.25, 42.06),
        safe = vector4(1707.87, 4920.48, 42.06, 327.37),
    },

    ---==========[liquor stores]==========---
    { -- /tp -1222.73, -907.19, 12.33
        counter = vector3(-1222.73, -907.19, 12.33),
        safe = vector4(-1220.84, -916.04, 11.33, 129.4),
    },
    { -- /tp -1488.68, -381.03, 40.16
        counter = vector3(-1487.28, -379.03, 40.16),
        safe = vector4(-1478.91, -375.35, 39.16, 223.69),
    },
    { -- /tp -2970.43, 390.77, 15.04
        counter = vector3(-2967.8, 390.76, 15.04),
        safe = vector4(-2959.56, 387.09, 14.04, 177.43),
    },
    { -- /tp 1167.09, 2707.52, 38.16
        counter = vector3(1166.01, 2709.36, 38.16),
        safe = vector4(1169.33, 2717.79, 37.16, 269.66),
    },
    { -- /tp 1137.98, -981.33, 46.42
        counter = vector3(1135.65, -982.3, 46.42),
        safe = vector4(1126.74, -980.09, 45.42, 7.3),
    },
}