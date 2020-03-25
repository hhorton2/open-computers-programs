local robot = require("robot")
local sides = require("sides")
local robotUtils = {}
function robotUtils.MoveWithRetry(move)
    while not move() do robotUtils.RemoveIfPresent(sides.front) end
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
function robotUtils.IsInventorySlotAvailable()
    for i = 1, robot.inventorySize() do
        if robot.space(i) == 64 then return true end
    end
    return false
end
function robotUtils.DropAllInventory()
    for i = 1, robot.inventorySize() do
        robot.select(i)
        local count = robot.count(i)
        if count > 0 then robot.drop(count) end
    end
end
function robotUtils.Excavate(width, height, depth)
    for i = 1, depth do
        for j = 1, width do
            for k = 1, height do
                robotUtils.RemoveIfPresent(sides.front)
                if k ~= height then
                    robotUtils.MoveWithRetry(robot.up)
                end
            end
            for k = 1, height - 1 do
                robotUtils.MoveWithRetry(robot.down)
            end
            if j ~= width then
                robot.turnRight()
                robotUtils.MoveWithRetry(robot.forward)
                robot.turnLeft()
            end
        end
        robot.turnLeft()
        for j = 1, width - 1 do robotUtils.MoveWithRetry(robot.forward) end
        robot.turnRight()
        robotUtils.MoveWithRetry(robot.forward)
    end
    robot.turnAround()
    for i = 1, depth do robotUtils.MoveWithRetry(robot.forward) end
    robot.turnAround()
end
function robotUtils.ExcavateWithChest(width, height, depth)
    for i = 1, depth do
        for j = 1, width do
            for k = 1, height do
                robotUtils.RemoveIfPresent(sides.front)
                if k ~= height then
                    robotUtils.MoveWithRetry(robot.up)
                end
            end
            for k = 1, height - 1 do
                robotUtils.MoveWithRetry(robot.down)
            end
            if not robotUtils.IsInventorySlotAvailable() then
                robot.turnAround()
                robotUtils.MoveLateral(j-1, i-1)
                robotUtils.DropAllInventory()
                if not robotUtils.IsInventorySlotAvailable() then
                    do return end
                end
                robot.turnAround()
                robotUtils.MoveLateral(j-1,i-1)
            end
            if j ~= width then
                robot.turnRight()
                robotUtils.MoveWithRetry(robot.forward)
                robot.turnLeft()
            end
        end
        robot.turnLeft()
        for j = 1, width - 1 do robotUtils.MoveWithRetry(robot.forward) end
        robot.turnRight()
        robotUtils.MoveWithRetry(robot.forward)
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
