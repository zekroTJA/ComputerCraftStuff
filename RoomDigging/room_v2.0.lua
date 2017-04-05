-- ROOM DIGGING PROGRAMM V2.0
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2016

-- PASTEBIN: https://pastebin.com/P0DJrjA7

-- The program will work in the cartesian coordinate system right in that direction the picture shows.
-- So the turtle will start digging to the right and back when you look at the back of the turtle.
--
--     z   x        
--     |  /         
--     | /          
--     |/           
--     -------- y               


local _x, _y, _z = ...
local x = tonumber(_x)
local y = tonumber(_y)
local z = tonumber(_z)

local t = turtle

local currentLayer = 0
local bcount = 0


------------------------------------------------------------------------------------------------
-- FUNCTIONS -----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

function cls()
   shell.run("clear") 
end

function checkInv()
    for i=1, 16, 1 do
        if (t.getItemCount(i) >= 1) then
            return true
        end
    end
    return false
end

function checkFuel()
	if y % 2 == 1 then
		fuelNeed = z * ((x * y - 1) + (x + y - 2) + 1) + z - 2
	else
		fuelNeed = z * ((x * y - 1) + (y - 1) + 1) + z - 2
	end
	fuelIn = t.getFuelLevel()
	fuelToRefill = fuelNeed - fuelIn
	if fuelIn < fuelNeed then
		print("Not enough fuel!\n")
		print("AVAILABLE FUEL: ", fuelIn)
		print("FUEL NEED:      ", fuelNeed)
		print("FUEL TO INPUT:  ", fuelToRefill)
		print("\nThat means: ")
		print("- ", fuelToRefill / 5, " Sticks")
		print("- ", fuelToRefill / 15, " Wood")
		print("- ", fuelToRefill / 80, " Coal")
		print("- ", fuelToRefill / 120, " Blaze Rods")
		print("- ", fuelToRefill / 1000, " Buckets Lava")
		print("\nPut fuel to input in slot 1...")
		
		while t.getItemCount(1) == 0 do
			os.sleep(0.5)
		end
		t.refuel(64)
		checkFuel()
	end
end

function count()
	bcount = bcount+1
	cls()
	print("Digging in progress...\n\n", bcount, " blocks digged...")
end

function fw(times)
    for i=1, times, 1 do
        t.forward()
    end
end

function digLine()
    for i=2, x, 1 do
        t.dig()
		count()
        t.forward()
    end
end

function digLayer()
    for i=1, y, 1 do
        digLine()
        if i % 2 == 0 and i ~= y then
            t.turnLeft()
            t.dig()
			count()
            t.forward()
            t.turnLeft()
        elseif i ~= y then
            t.turnRight()
            t.dig()
			count()
            t.forward()
            t.turnRight()
        end
    end
    if y % 2 == 1 then
        t.turnRight()
        t.turnRight()
        fw(x-1)
        t.turnRight()
        fw(y-1)
    else
        t.turnRight()
        fw(y-1)
    end
    t.turnRight()
	
	if (t.getItemCount(16) >= 1) then
		for i=1, currentLayer, 1 do
			t.down()
		end
		for i=1, 16, 1 do
			t.select(i)
			t.dropDown(64)
		end
		t.select(1)
		for i=2, currentLayer, 1 do
			t.up()
		end
	end
end

------------------------------------------------------------------------------------------------
-- MAIN PROGRAMM -------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

cls()
t.select(1)

if x == nil or y == nil or z == nil then
    print("The program arguments are invalid!\nPlease use the program like this:\n\n\"<programm name> <xcords> <ycords> <zcords>\"",
    "\n\nExample:\n\"room 20 14 18\"")
    error()
elseif x <= 1 or y <= 1 or z <= 1 then
    print("Please use coordinates that are more than 1 block.")
    error()
end

while (checkInv() == true) do
    cls()
    print("Please clear the inventory of the turtle to continue.")
    os.sleep(0.5)
end

checkFuel()

cls()
if (x*y*z) >= 800 then
	print("The turtle will dig ", (x*y*z), " blocks in this progress, so the inventory of the turtle will flow over. So I implemented a drop-out-system: Please place a (double) chest right under the turtle to catch overflowing items.")
	print("\n\nPress enter to continue...")
	io.read()
end

cls()
for i=1, z, 1 do
	currentLayer = currentLayer+1
    digLayer()
    if i ~= z then
        t.digUp()
		count()
        t.up()
    end
end

for i=1, z, 1 do
    t.down()
end

cls()
print("Progress finished!\n\n", bcount, " blocks got digged.")