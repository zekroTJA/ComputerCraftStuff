-- A simple program to controll a rolling create door using a gearshift and a clutch.

local INPUT_SIDE = "front"    -- Redstone input side of the remote controller
local GEARSHIFT_SIDE = "left" -- Redsone output side for the gearshift
local CLUTCH_SIDE = "right"   -- Redstone output side for the clutch
local ROLL_TIME_SECONDS = 8   -- Time it takes to completely roll the door

----------------------------------------------------------------------------------------------------

local active = false
local timer = nil

-- Disengage the clutch on cimputer startup
redstone.setOutput(CLUTCH_SIDE, true)

-- Loop listening for the redsone input of the controller and toggliing
-- the up and down rolling of the door alternatingly.
local function redstoneLoop()
    while true do
        os.pullEvent("redstone")
        print("-- REDSTONE EVENT RECEIVED")
        if redstone.getInput(INPUT_SIDE) then
            active = not active

            redstone.setOutput(GEARSHIFT_SIDE, active)
            redstone.setOutput(CLUTCH_SIDE, false)

            if timer then
                os.cancelTimer(timer)
            end
            timer = os.startTimer(ROLL_TIME_SECONDS)

            -- The redstone event fires each tick when staying active.
            -- Thsi avoids re-trigger when the redstone signal persists
            -- for a little longer than some ticks.
            sleep(1)
        end
    end
end

-- Loop that listens on the registered timer to disengage the
-- clutch after the door has fully moved. This is not strictly
-- necessary but nice to have.
local function timerLoop()
    while true do
        local _, t = os.pullEvent("timer")
        if t == timer then
            print("-- TIMER EVENT RECEIVED")
            redstone.setOutput(CLUTCH_SIDE, true)
        end
    end
end

parallel.waitForAny(redstoneLoop, timerLoop)
