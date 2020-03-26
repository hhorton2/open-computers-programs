local robotUtils = require("robotUtils")
local component = require("component")

local args = {...}
if #args < 6 then
    print(
        "Excavate requires 6 arguments - Width, Height, Depth, WidthMove, HeightMove and EnableChest.")
    do return end
end
if args[6] == nil then
    print("EnableChest is a required argument.")
    do return end
end
local width = tonumber(args[1])
local height = tonumber(args[2])
local depth = tonumber(args[3])
local widthMove = tonumber(args[4])
local heightMove = tonumber(args[5])
local enableChest = string.lower(args[6]) == "true"
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
if widthMove == nil or widthMove < 1 then
    print("WidthMove must be a positive integer")
    do return end
end
if heightMove == nil or heightMove < 1 then
    print("HeightMove must be a positive integer")
    do return end
end
if width % widthMove ~= 0 then
    print("Width must be divisible by WidthMove")
    do return end
end
if height % heightMove ~= 0 then
    print("Height must be divisible by HeightMove")
    do return end
end

for k, v in component.list() do
    if v == "chunkloader" then
        print("chunkloader found. Activating.")
        component.chunkloader.setActive(true)
    end
end
print("Beginning excavation with arguments:")
print("Width: " .. width)
print("Height: " .. height)
print("Depth: " .. depth)
print("WidthMove: " .. widthMove)
print("HeightMove: " .. heightMove)
print("EnableChest: " .. tostring(enableChest))
robotUtils.Excavate(width, height, depth, widthMove, heightMove, enableChest)
