-- A simple program to controll a rolling create door using a gearshift and a clutch.

local INPUT_SIDE = "front"    -- Redstone input side of the remote controller
local RESET_OVERRIDE_SIDE = "back"
local GEARSHIFT_SIDE = "left" -- Redsone output side for the gearshift
local CLUTCH_SIDE = "right"   -- Redstone output side for the clutch
local ROLL_TIME_SECONDS = 8   -- Time it takes to completely roll the door

-- The area where the door will be triggered when a player is inside.
local activationArea = {
    {
        x = -232,
        y = -50,
        z = 26,
    },
    {
        x = -138,
        y = 255,
        z = 63,
    }
}

-- List of players to toggle door when in activationArea.
local activationPlayers = { "zekroTJA" }

----------------------------------------------------------------------------------------------------

local isOpen = false
local isOverride = false
local timer = nil

-- Disengage the clutch on cimputer startup
redstone.setOutput(CLUTCH_SIDE, true)

local function setDoor(open)
    print("[info ] set door state:", open)
    redstone.setOutput(GEARSHIFT_SIDE, not open)
    redstone.setOutput(CLUTCH_SIDE, false)

    if timer then
        os.cancelTimer(timer)
    end
    timer = os.startTimer(ROLL_TIME_SECONDS)
end

-- Returns true when t contains any value of cont.
local function containsAny(t, cont)
    for _, v in pairs(t) do
        for _, c in pairs(cont) do
            if c == v then
                return true
            end
        end
    end
    return false
end

-- Loop listening for the redsone input of the controller and toggliing
-- the up and down rolling of the door alternatingly.
local function redstoneLoop()
    while true do
        os.pullEvent("redstone")
        print("[info ] redstone event received")

        if redstone.getInput(INPUT_SIDE) then
            isOpen = not isOpen
            isOverride = true
            setDoor(isOpen)
        end

        if redstone.getInput(RESET_OVERRIDE_SIDE) then
            print("[info ] overide disengaged")
            isOverride = false
        end

        -- The redstone event fires each tick when staying active.
        -- Thsi avoids re-trigger when the redstone signal persists
        -- for a little longer than some ticks.
        sleep(1)
    end
end

-- Checks is a player of the activationPlayers list is inside the activationArea.
-- If this is the case, the door will open. Otherwise, it will close.
-- This will be deactivated if override is engaged by manually opening or closing
-- the door.
local function presenceLoop()
    local detector = peripheral.find("playerDetector")
    if not detector then
        print("[warn ] no player detector found; player detection is deactivated")
        return
    end

    while true do
        sleep(1)
        if isOverride then
            goto continue
        end

        local players = detector.getPlayersInCoords(activationArea[1], activationArea[2])
        local present = containsAny(players, activationPlayers)
        if present and not isOpen then
            isOpen = true
            setDoor(true)
        elseif not present and isOpen then
            isOpen = false
            setDoor(false)
        end

        ::continue::
    end
end

-- Loop that listens on the registered timer to disengage the
-- clutch after the door has fully moved. This is not strictly
-- necessary but nice to have.
local function timerLoop()
    while true do
        local _, t = os.pullEvent("timer")
        if t == timer then
            print("[info ] timer event received")
            redstone.setOutput(CLUTCH_SIDE, true)
        end
    end
end

parallel.waitForAll(
    redstoneLoop,
    timerLoop,
    presenceLoop
)
