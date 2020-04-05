local component = require("component")
local transposer = component.transposer
local transposerUtils = require("transposerUtils")
local sides = require("sides")
local event = require("event")
repeat
    if not transposerUtils.IsInventoryClear(sides.west) then
        for i = 1, transposer.getInventorySize(sides.west) do
            local sourceStackSize = transposer.getSlotStackSize(sides.west, i)
            if sourceStackSize > 0 then
                local slotName = transposer.getStackInSlot(sides.west, i).label
                local moveCount = 0
                local succesString = ""
                if string.match(slotName, "Cobblestone") or
                    string.match(slotName, "Andesite") or
                    string.match(slotName, "Diorite") or
                    string.match(slotName, "Gravel") or
                    string.match(slotName, "Granite") or
                    string.match(slotName, "Dirt") then
                    succesString = " to nullifier."
                    moveCount = transposer.transferItem(sides.west, sides.south,
                                                        sourceStackSize, i)
                elseif string.match(slotName, "Ore") and
                    not string.match(slotName, "Cinnabar") then
                    succesString = " to processing."
                    moveCount = transposer.transferItem(sides.west, sides.down,
                                                        sourceStackSize, i)
                else
                    succesString = " to storage."
                    moveCount = transposer.transferItem(sides.west, sides.north,
                                                        sourceStackSize, i)
                end
                if moveCount > 0 then
                    succesString = "Moved " .. moveCount .. " " .. slotName ..
                                       succesString
                    print(succesString)
                end
            end
        end
    end
until event.pull(1) == "interrupted"
