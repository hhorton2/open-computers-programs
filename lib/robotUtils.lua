local robot = require("robot")
local sides = require("sides")
local component = require("component")
local inventory = component.isAvailable("inventory_controller") and component.inventory_controller or nil
local tractorBeam = component.isAvailable("tractor_beam") and component.tractor_beam or nil
local robotUtils = {}
function robotUtils.FindInternalSlotFromLabel(label)
    if inventory then
        for i = 1, robot.inventorySize() do
            if inventory.getStackInInternalSlot(i) ~= nil and
                inventory.getStackInInternalSlot(i).label == label then
                return i
            end
        end
        return -1
    else
        return -1
    end
end
function robotUtils.MoveWithRetry(move, stepCount)
    stepCount = stepCount or 1
    for i = 1, stepCount do
        while not move() do
            if move == robot.forward then
                robotUtils.RemoveIfPresent(sides.front)
            elseif move == robot.up then
                robotUtils.RemoveIfPresent(sides.top)
            elseif move == robot.down then
                robotUtils.RemoveIfPresent(sides.bottom)
            elseif move == robot.back then
                robotUtils.RemoveIfPresent(sides.back)
            end
        end
    end
end
function robotUtils.RemoveIfPresent(side)
    if side == sides.front then
        while robot.detect() do robot.swing(side) end
    elseif side == sides.top then
        while robot.detectUp() do robot.swingUp(side) end
    elseif side == sides.bottom then
        while robot.detectDown() do robot.swingDown(side) end
    elseif side == sides.left then
        robot.turnLeft()
        while robot.detect() do robot.swing(side) end
        robot.turnRight()
    elseif side == sides.right then
        robot.turnRight()
        while robot.detect() do robot.swing(side) end
        robot.turnLeft()
    elseif side == sides.back then
        robot.turnAround()
        while robot.detect() do robot.swing(side) end
        robot.turnAround()
    end
end
function robotUtils.IsInventoryFull()
    for i = 1, robot.inventorySize() do
        if robot.space(i) > 0 then return false end
    end
    return true
end
function robotUtils.IsInventoryClear()
    for i = 1, robot.inventorySize() do
        if robot.count(i) > 0 then return false end
    end
    return true
end
function robotUtils.IsInventorySlotAvailable()
    for i = 1, robot.inventorySize() do
        if robot.space(i) == 64 then return true end
    end
    return false
end
function robotUtils.DropAllInventory()
    while not robotUtils.IsInventoryClear() do
        for i = 1, robot.inventorySize() do
            robot.select(i)
            local count = robot.count(i)
            if count > 0 then robot.drop(count) end
        end
    end
end
function robotUtils.Excavate(width, height, depth, widthStepAmount,
                             heightStepAmount, withChest)
    widthStepAmount = widthStepAmount or 1
    heightStepAmount = heightStepAmount or 1
    withChest = withChest or false
    local heightMax = height / heightStepAmount
    local widthMax = width / widthStepAmount
    local enderChestLabel = "Ender Chest"
    local enderChestSlot = inventory and robotUtils.FindInternalSlotFromLabel(enderChestLabel) or -1
    if not withChest or enderChestSlot ~= -1 then
        for i = 1, depth do
            for j = 1, widthMax do
                for k = 1, heightMax do
                    robotUtils.RemoveIfPresent(sides.front)
                    if k ~= heightMax then
                        robotUtils.MoveWithRetry(robot.up, heightStepAmount)
                    end
                end
                for k = 1, heightMax - 1 do
                    robotUtils.MoveWithRetry(robot.down, heightStepAmount)
                end
                if withChest then
                    if not robotUtils.IsInventorySlotAvailable() then
                        robot.turnAround()
                        robot.select(enderChestSlot)
                        while not robot.place() do
                            robotUtils.RemoveIfPresent(sides.front)
                        end
                        robotUtils.DropAllInventory()
                        if not robotUtils.IsInventoryClear() then
                            do return end
                        end
                        robot.select(enderChestSlot)
                        robotUtils.RemoveIfPresent(sides.front)
                        if tractorBeam then
                            for i = 1, 30 do
                                tractorBeam.suck()
                            end
                        end
                        enderChestSlot =
                            robotUtils.FindInternalSlotFromLabel(enderChestLabel)
                        if enderChestSlot == -1 then
                            do return end
                        end
                        robot.select(enderChestSlot)
                        robot.turnAround()
                    end
                end
                if j ~= widthMax then
                    robot.turnRight()
                    robotUtils.MoveWithRetry(robot.forward, widthStepAmount)
                    robot.turnLeft()
                end
            end
            robot.turnLeft()
            for j = 1, widthMax - 1 do
                robotUtils.MoveWithRetry(robot.forward, widthStepAmount)
            end
            robot.turnRight()
            robotUtils.MoveWithRetry(robot.forward)
        end
    end
    robot.turnAround()
    for i = 1, depth do robotUtils.MoveWithRetry(robot.forward) end
    robot.turnAround()
end
function robotUtils.MoveLateral(x, y)
    robot.turnRight()
    for i = 1, x do robotUtils.MoveWithRetry(robot.forward) end
    robot.turnLeft()
    for i = 1, y do robotUtils.MoveWithRetry(robot.forward) end
end
return robotUtils
