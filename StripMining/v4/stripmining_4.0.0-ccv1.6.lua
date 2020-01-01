--[[
MIT LICENCE

Copyright (c) 2020 zekro Development

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

-- PASTEBIN: UHsCxFk7

-----------------------------------------------------------------
-- CONFIGURABLE VALUES
-----------------------------------------------------------------
-- DELAY is the ammount of seconds which are
-- waited until the next block in front of or
-- above the turtle will be detected to dig
-- falling blocks like sand or gravel.
-- 0.4s is the minimum which should be set. If
-- you notice problems digging gravel or sand,
-- you should crank this up a bit.
local DELAY  = 0.4
-- DEPTH is the length of the corridor arms
-- which are digged left and right of the mine
-- shaft.
    local DEPTH  = 4
-- SPACES is the ammount of inventory fields
-- which must be free to dig a new corridor
-- part. If this value is 1, for example, the
-- turtle will go back to the base to drop the
-- inventory, if set on startup, when only
-- 1 or less inventory fields are free.
    local SPACES = 1
-----------------------------------------------------------------

local VERSION = '4.0.0-ccv1.6'
local ARG, ARG2, ARG3 = ...

local PROGNAME = shell.getRunningProgram()
local HELP = 'Usage: ' .. PROGNAME .. ' LEN [STORE]\n\
LEN is the length of the mining shaft\
in corridors, so the total length is\
LEN * 3 blocks.\n\
STORE is the type of storage used:\
  - 0: no storage (default)\
  - 1: double/single chest'

local VERSIONTXT = 'stripmining v.' .. VERSION .. '\
Compatible with ComputerCraft >= 1.6.\n\
(c) 2020 zekro Development\
Covered by the MIT Licence.'

----------------------------------------------------------------
-- HELPER FUNCTIONS 
----------------------------------------------------------------

-- Output help message and exit program
-- with error().
function printHelp(extended)
    print(HELP)
    error()
end

-- Clear screen.
function cls()
    shell.run('clear')
end

-- Returns the number of the first slot
-- of the turtles inventory which is not
-- empty. If all slots are empty, 0 will
-- be returned.
function firstInvNotEmpty()
    for i = 1, 16, 1 do
        if turtle.getItemCount(i) > 0 then
            return i
        end
    end
    return 0
end

-- Returns the ammount of inventory fields
-- that are empty.
function emptyInvFields()
    local empty = 0
    for i = 1, 16, 1 do
        if turtle.getItemCount(i) == 0 then
            empty = empty + 1
        end 
    end
    return empty
end

-- Blocks until a key was pressed and then
-- returns the name of the pressed key.
function pullKeyEvent(txt)
    if txt then
        print(txt)
    end
    local _, key, _ = os.pullEvent("key")
    return keys.getName(key)
end

----------------------------------------------------------------
-- TURTLE SHORTCUTS
----------------------------------------------------------------

-- Executes the passed function, which
-- returns true on success, n times and
-- retries the function if it fails after
-- 0.1 a delay of seconds.
function _do(n, f)
    n = n and n or 1
    for i = 1, n, 1 do
        while not f() do 
            sleep(0.1)
        end
    end
end

-- Tries to move the turthe forward
-- n times.
function goForward(n)
    _do(n, turtle.forward)
end

-- Tries to move the turthe back
-- n times.
function goBack(n)
    _do(n, turtle.back)
end

-- Tries to move the turthe up
-- n times.
function goUp(n)
    _do(n, turtle.up)
end

-- Tries to move the turthe down
-- n times.
function goDown(n)
    _do(n, turtle.down)
end

-- Tries to turn the turtle n times
-- to the right.
function turnRight(n)
    _do(n, turtle.turnRight)
end

-- Tries to turn the turtle n times
-- to the left.
function turnLeft(n)
    _do(n, turtle.turnLeft)
end

-- Drops the whole inventory except the
-- items in the first slot. Also, at least
-- 5 blocks for filling ground are kept in
-- the first slot of the inventory.
function emptyInv()
    local amm1 = turtle.getItemCount(2)
    local dropAmm = amm1 <= 5 and 0 or (amm1 - 5)
    turtle.select(2)
    turtle.drop(dropAmm)
    for i = 3, 16, 1 do
        turtle.select(i)
        turtle.drop(64)
    end
    turtle.select(1)
end

----------------------------------------------------------------
-- PROGRAM STRUCTURE FUNCTIONS
----------------------------------------------------------------

-- Checks if the turtle has a label set and
-- warns the user if the turtle has no label set.
function checkLabel()
    if not os.getComputerLabel() then
        print('ATTENTION!\nThis computer does not have a label!\n' ..
              'You should set a label to this computer to save ' ..
              'fuel and program state on breaking the computer.\n')
        local key = pullKeyEvent('Do you want to continue anyway? [yN]')
        if key ~= 'y' then
            print('Canceled.')
            error()
        end
    end
end

-- Checks if the turtle has estimated enought
-- fuel to fulfil the mining process and refuels
-- the turtle on user input of fuel into the
-- inventory.
function checkFuel(len)
    cls()
    local fuelRequired = len * 30
    local fuelExistent = turtle.getFuelLevel()
    local fuelDelta = fuelRequired - fuelExistent
    if fuelExistent < fuelRequired then
        print('Not enough fuel to fulfil the process. Please refuel:\n\n' ..
              ' - ' .. fuelDelta / 80 .. ' coal\n' ..
              ' - ' .. fuelDelta / 15 .. ' wooden plancks\n\n' ..
              'Just put the fuel to be refueld somewhere in the turtles inventory.')
        while firstInvNotEmpty() == 0 do
            sleep(0.5)
        end
        shell.run('refuel all')
        return false
    end
    return true
end

-- Displays fuel level and shows information to
-- prepare the inventory of the turtle for
-- the mining process.
function checkRequirements(len, store)
    cls()
    write('Fuel level is ' .. turtle.getFuelLevel() .. '.\n\n' ..
          'Please put ' .. len .. ' in slot 1')
    if store > 0 then
        write(' and one or two chests in slot 2')
    end
    print('.\n\nThen press any key to continue or [c] to cancel.')
    local key = pullKeyEvent()
    if key == 'c' then
        print('Canceled.')
        error()
    end
end

-- Digs and moves forward by digging 1x2x1
-- blocks with checking for falling blocks
-- (like sand or gravel) and missing ground
-- blocks which will be filled.
function digForward(n)
    n = n and n or 1
    for i = 1, n, 1 do
        while turtle.detect() do
            turtle.dig()
            sleep(DELAY)
        end
        goForward()
        sleep(DELAY)
        while turtle.detectUp() do
            turtle.digUp()
            sleep(DELAY)
        end
        if not turtle.detectDown() then
            turtle.select(2)
            turtle.placeDown()
        end
    end
end

-- Digs the base for one or two chests,
-- depending on passed chest count.
-- If storage type is > 0 and 0 chests
-- are passed, a base bay of the size of
-- 1 will be created where items will
-- be like there was a chest.
function makeBase(store, chests)
    local place = true
    if chests == 0 then
        place = false
        chests = 1
    else
        chests = chests > 2 and 2 or chests
    end
    for i = 1, chests, 1 do
        digForward()
        turnRight()
        digForward()
        goBack()
        if place then 
            turtle.select(2)
            turtle.place()
            turtle.select(1)
        end
        turnLeft()
    end
end

-- One instance of digging one corridor
-- pair with or without placing a torch,
-- depending on the passed value.
function digCorridorPart(placeTorch)
    digForward(2)
    if placeTorch then
        turtle.select(1)
        turtle.placeUp()
    end
    digForward()
    turnRight()
    digForward(DEPTH)
    turnRight(2)
    digForward(DEPTH * 2)
    goBack(DEPTH)
    turnRight()
end

----------------------------------------------------------------
-- MAIN ROUTINE
----------------------------------------------------------------

if ARG == 'v' or ARG == 'version' then
    print(VERSIONTXT)
    error()
end

local len = tonumber(ARG)
local store = tonumber(ARG2)
store = store and store or 0

if not len or len < 1 then
    printHelp()
end

if store and (store < 0 or store > 1) then
    printHelp()
end

checkLabel()

while not checkFuel(len) do end

checkRequirements(len, store)

local torches = turtle.getItemCount(1) > 0
local chests = turtle.getItemCount(2)

if store > 0 then
    makeBase(store, chests)
end

local way = 0
for i = 1, len, 1 do
    digCorridorPart(torches)
    way =  way + 3
    if store > 0 and emptyInvFields() <= SPACES then
        goBack(way)
        turnRight()
        emptyInv()
        turnLeft()
        goForward(way)
    end
end

goBack(way)
