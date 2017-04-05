-- STRIP MINING PROGRAMM V3.3.2
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2016

-- PASTEBIN: https://pastebin.com/mfNUumgr

-- Usage:   type in the console of any labeled mining turtle (w/o the ""):
--          "pastebin get mfNUumgr mining" (you can also replace "mining" with another programname you want)
--          "mining <number of mining floors> <type of delivery>" (or instead of "mining" your chosen programname)
-- EXAMPLE: "mining 20 1"
-- OR:      "mining" only to show the help

 
local arg1, arg2 = ...
local vers = "MINING v3.3.2 | (c) 2016 zekro"
 
function cls()
    shell.run("clear")
end
 
function dff(times)
    for i = 1, tonumber(times), 1 do
        while turtle.detect(forward) do
            turtle.dig()
            sleep(0.3)
        end
        turtle.forward()
        turtle.digUp()
    end
end
 
-- start script
function start()
   
    cls()
    -- tests for the right start arguments
    if (arg1 == nil) or (arg2 == nil) or (tonumber(arg2) > 2) then
        print("Please name the length of the mine you want to have in the first Argument and the type of delivery in the second Argument!")
        print("\nFor arg 2: 0 - without chests, 1 - double chest places nexto turtle, 2 - enderchest delivery")
        print("\nExample: '<programname> 5 0'")
        print("\nATTENTION: 1 unit means 3 Blocks!")
        error()
    end
   
    -- tests for a required empty inventory
    while (turtle.getItemCount(1)>0) or (turtle.getItemCount(2)>0) or (turtle.getItemCount(4)>0) or (turtle.getItemCount(5)>0)  or (turtle.getItemCount(6)>0) or (turtle.getItemCount(7)>0) or (turtle.getItemCount(8)>0) or (turtle.getItemCount(9)>0) or (turtle.getItemCount(10)>0) or (turtle.getItemCount(11)>0) or (turtle.getItemCount(12)>0) or (turtle.getItemCount(13)>0) or (turtle.getItemCount(14)>0) or (turtle.getItemCount(15)>0) or (turtle.getItemCount(16)>0) do
        cls()
        print(vers, "\n")
        print("Please empty the inventory of the turtle to continue!")
        sleep(0,5)
    end
   
    cls()
    print(vers, "\n")
    testForFuel()
    print("Please put ", arg1, " torches in the first slot.")
    repeat
        sleep(0.5)
    until turtle.getItemCount(1)==tonumber(arg1)
   
    -- if MODE 1 was chosen
    if arg2 == "1" then
        cls()
        print(vers, "\n")
        print("Please put in the second slot two normal chests.")
        turtle.select(2)
        repeat
            sleep(0.5)
        until turtle.getItemCount(2)==2
    end
   
    -- if MODE 2 was chosen
    if arg2 == "2" then
        cls()
        print(vers, "\n")
        print("Please put in the second slot an enderchest.")
        turtle.select(2)
        repeat
            sleep(0.5)
        until turtle.getItemCount(2)==1
    end
end
 
-- tests for the fuel level of turtle & refilling
function testForFuel()
    fuel_need = arg1*30
    if turtle.getFuelLevel() < fuel_need then
        print("The fuel level don't suffice for the process.\nPlease put the following ammount of fuel in any slot:")
        fuel_delta = fuel_need-turtle.getFuelLevel()
        print("\n- ", fuel_delta/80, " coal\n- ", fuel_delta/15, " wooden plancks")
        while (turtle.getItemCount(1)==0) and (turtle.getItemCount(2)==0) and (turtle.getItemCount(4)==0) and (turtle.getItemCount(5)==0)   and (turtle.getItemCount(6)==0) and (turtle.getItemCount(7)==0) and (turtle.getItemCount(8)==0) and (turtle.getItemCount(9)==0) and (turtle.getItemCount(10)==0) and (turtle.getItemCount(11)==0) and (turtle.getItemCount(12)==0) and (turtle.getItemCount(13)==0) and (turtle.getItemCount(14)==0) and (turtle.getItemCount(15)==0) and (turtle.getItemCount(16)==0) do
            sleep(0.5)
        end
        shell.run("refuel all")
        turtle.select(1)
        cls()
    end
end
 
-- dig base with 2 standart chests (MODE 0)
function base_1()
    cls()
    print(vers, "\n")
    print("Digging base with two chests in progress...")
   
    dff(1)
    turtle.turnRight()
    dff(1)
    turtle.back()
    turtle.place()
    turtle.turnLeft()
    dff(1)
    turtle.turnRight()
    dff(1)
    turtle.back()
    turtle.place()
    turtle.turnLeft()
end
 
function base_2()
    cls()
    print(vers, "\n")
    print("Digging base with enderchest in progress...")
   
    dff(1)
    turtle.turnRight()
    dff(1)
    turtle.back()
    turtle.place()
    turtle.turnLeft()
end
 
function strip()
    for sf = 1, tonumber(arg1), 1 do
        dff(2)
        turtle.select(1)
        dff(1)
        turtle.back()
        turtle.placeUp()
        turtle.forward()
        turtle.turnRight()
        dff(4)
        turtle.turnLeft()
        turtle.turnLeft()
        dff(8)
        turtle.turnLeft()
        turtle.turnLeft()
        dff(4)
        turtle.turnLeft()
        if tonumber(arg2)>0 and (turtle.getItemCount(1)>0) and (turtle.getItemCount(2)>0) and (turtle.getItemCount(4)>0) and (turtle.getItemCount(5)>0) and (turtle.getItemCount(6)>0) and (turtle.getItemCount(7)>0) and (turtle.getItemCount(8)>0) and (turtle.getItemCount(9)>0) and (turtle.getItemCount(10)>0) and (turtle.getItemCount(11)>0) and (turtle.getItemCount(12)>0) and (turtle.getItemCount(13)>0) and (turtle.getItemCount(14)>0) and (turtle.getItemCount(15)>0) and (turtle.getItemCount(16)>0) then
            turtle.turnLeft()
            turtle.turnLeft()
            for goback = 1, sf*3, 1 do
                turtle.forward()
            end
            turtle.turnLeft()
            for ind = 2, 16, 1 do
            turtle.select(ind)
                while turtle.getItemCount(ind)>0 do
                    turtle.drop()
                end
            end
            turtle.turnLeft()
            for goback = 1, sf*3, 1 do
                turtle.forward()
            end
        end
    end
    turtle.turnLeft()
    turtle.turnLeft()
    for goback = 1, tonumber(arg1)*3, 1 do
        turtle.forward()
    end
    turtle.turnLeft()
    for ind = 2, 16, 1 do
        turtle.select(ind)
        while turtle.getItemCount(ind)>0 do
            turtle.drop()
        end
    end
    turtle.turnRight()
    turtle.forward()
    turtle.forward()
end
 
-- MAIN PROGRAM
start()
if arg2 == "1" then
    base_1()
end
if arg2 == "2" then
    base_2()
end
strip()
cls()
print(vers, "\n")
print("FINISHED.")