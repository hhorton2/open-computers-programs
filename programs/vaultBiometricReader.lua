local event = require("event") -- load event table and store the pointer to it in event
local component = require("component")
local door = component.isAvailable("os_doorcontroller") and
                 component.os_doorcontroller or nil
local os = require("os")
local computer = require("computer")
local term = require("term")
local char_space = string.byte(" ") -- numerical representation of the space char
local running = true -- state variable so the loop can terminate

local args = {...}
local password = args[1]

if not password then
    print("Password is required for door controller.")
    do return end
end

if not door then
    print("No door controller connected.")
    do return end
end
term.clear()

function unknownEvent()
    -- do nothing if the event wasn't relevant
end

-- table that holds all event handlers
-- in case no match can be found returns the dummy function unknownEvent
local myEventHandlers = setmetatable({}, {
    __index = function() return unknownEvent end
})

-- Example key-handler that simply sets running to false if the user hits space
function myEventHandlers.key_up(adress, char, code, playerName)
    if (char == char_space) and string.lower(playerName) == "psyduck77" then
        running = false
    else
        print(playerName .. " tried to stop program")
    end
end

function myEventHandlers.bioReader(componentGuid, playerGuid)
    if playerGuid == "b4ac2322-e7fd-4488-8ff8-4adf58fd5e27" then
        computer.beep("-")
        door.open(password)
        os.sleep(2)
        door.close(password)
    else
        computer.beep("...")
    end
end

-- The main event handler as function to separate eventID from the remaining arguments
function handleEvent(eventID, ...)
    if (eventID) then -- can be nil if no event was pulled for some time
        myEventHandlers[eventID](...) -- call the appropriate event handler with all remaining arguments
    end
end

-- main event loop which processes all events, or sleeps if there is nothing to do
while running do
    handleEvent(event.pull()) -- sleeps until an event is available, then process it
end

