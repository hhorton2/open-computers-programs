local transposer = require("component").transposer
local sides = require("sides")
local transposerUtils = {}
function transposerUtils.IsInventoryFull(side)
    for i = 1, transposer.getInventorySize(side) do
        if transposer.getSlotStackSize(side, i) == 0 then return false end
    end
    return true
end
function transposerUtils.IsInventorySlotAvailable(side)
    for i = 1, transposer.getInventorySize(side) do
        if transposer.getSlotStackSize(side, i) == 0 then return true end
    end
    return false
end
function transposerUtils.IsInventoryClear(side)
    for i = 1, transposer.getInventorySize(side) do
        if transposer.getSlotStackSize(side, i) > 0 then return false end
    end
    return true
end
return transposerUtils