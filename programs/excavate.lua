local robotUtils = require("robotUtils")

local args = {...}
if #args < 4 then
    print(
        "Excavate requires 4 arguments - Width, Height, Depth and EnableChest.")
    do return end
end
if args[4] == nil then
    print("EnableChest is a required argument.")
    do return end
end
local width = tonumber(args[1])
local height = tonumber(args[2])
local depth = tonumber(args[3])
local enableChest = string.lower(args[4]) == "true"
if width == nil or width < 1 then
    print("Width must be a positive integer")
    do return end
end
if height == nil or height < 1 then
    print("Height must be a positive integer")
    do return end
end
if depth == nil or depth < 1 then
    print("Depth must be a positive integer")
    do return end
end
print("Beginning excavation with arguments:")
print("Width: " .. width)
print("Height: " .. height)
print("Depth: " .. depth)
print("EnableChest: " .. tostring(enableChest))
if enableChest then
    robotUtils.ExcavateWithChest(width, height, depth)
else
    robotUtils.Excavate(width, height, depth)
end
