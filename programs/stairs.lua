local robot = require("robot")
local sides = require("sides")
local robotUtils = require("robotUtils")

local args = {...}
if #args < 1 or #args > 1 then
    print("Steps is the only argument that is required")
    do return end
end
local steps = tonumber(args[1])
if steps == nil or steps > 32 then
    print("Steps must be a positive integer up to 32")
    do return end
end

robot.select(1)
robotUtils.Excavate(2,3,4)
for i = 1, steps do
    robotUtils.RemoveIfPresent(sides.bottom)
    robotUtils.MoveWithRetry(robot.down)
    robotUtils.RemoveIfPresent(sides.right)
    robotUtils.Excavate(2,1,4)
    robotUtils.MoveWithRetry(robot.forward)
    robot.turnAround()
    robot.place(sides.front)
    robot.turnLeft()
    robotUtils.MoveWithRetry(robot.forward)
    if i % 5 == 0 then
        robot.select(2)
        robot.placeUp(sides.front)
        robot.select(1)
    end
    robot.turnRight()
    robot.place(sides.front)
    robot.turnRight()
    robotUtils.MoveWithRetry(robot.forward)
    robot.turnRight()
end
robot.turnAround()
for i = 1, steps do
    robotUtils.MoveWithRetry(robot.up)
    robotUtils.MoveWithRetry(robot.forward)
end