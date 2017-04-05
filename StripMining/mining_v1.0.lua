-- STRIP MINING PROGRAMM V1.0
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2015

-- PASTEBIN: https://pastebin.com/nTYYA3Nj

function clear()
        shell.run("clear")
end
 
function s1()
        turtle.dig()
        turtle.forward()
        test()
        turtle.digUp()
end
 
function test()
        if turtle.detectDown()==false then
                turtle.select(2)
                turtle.placeDown()
                print("false")
        end
end
 
---------------------------------------------------
-- START
clear()
print("\n  <-[MINING PROGRAM V1.0]->")
print("  (C) Zekrommaster110 2015\n")
sleep(1,8)
 
clear()
write("\n Bitte anzahl der Gaenge eingeben: ")
local gaenge = read()
 
clear()
write("\nIn Slot 1 bitte ")
write(gaenge)
write(" Fackeln legen.\n\n")
local nullinput = read()
 
 
-- MINING PROGRAMM
for strip = 1, gaenge, 1 do
        s1()
        s1()
        s1()
        turtle.back()
        turtle.select(1)
        turtle.placeUp()
        turtle.forward()
        test()
        turtle.turnRight()
        for s2 = 1, 4, 1 do
                s1()
        end
        turtle.turnRight()
        turtle.turnRight()
        for s2 = 1, 8, 1 do
                s1()
        end
        turtle.turnRight()
        turtle.turnRight()
        for s2 = 1, 4, 1 do
                s1()
        end
        turtle.turnLeft()
end
 
back = gaenge*3
turtle.turnRight()
turtle.turnRight()
for goback = 1, back, 1 do
        turtle.forward()
        test()
end