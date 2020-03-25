local robot = require("robot")
local sides = require("sides")
local robotUtils = require("robotUtils")
function GoHome(steps)
    robot.turnAround()
    for i = 1, steps do robotUtils.MoveWithRetry(robot.forward) end
end
function PlaceTorch()
    robot.turnRight()
    robot.select(1)
    robot.placeUp(sides.front)
    robot.turnLeft()
end
function StripMine(depth)
    robot.select(1)
    local torchesCount = robot.count()
    if torchesCount == 0 then do return end end
    for i = 1, depth do
        robotUtils.RemoveIfPresent(sides.front)
        robotUtils.MoveWithRetry(robot.up)
        robotUtils.RemoveIfPresent(sides.front)
        robotUtils.MoveWithRetry(robot.down)
        if i % 13 == 0 then
            PlaceTorch()
            torchesCount = torchesCount - 1
            if torchesCount == 0 then
                GoHome(i)
                do return end
            end
        end
        if robotUtils.IsInventoryFull() then
            GoHome(i)
            do return end
        end
        robotUtils.MoveWithRetry(robot.forward)
    end
    GoHome(depth)
end

local args = {...}
if #args < 1 or #args > 1 then
    print("Depth is the only argument that is required")
    do return end
end
local depth = tonumber(args[1])
if depth == nil or depth > 832 then
    print("Depth must be a positive integer up to 832")
    do return end
end
StripMine(depth)
