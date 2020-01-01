-- STRIP MINING PROGRAMM V1.3
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2015

-- PASTEBIN: https://pastebin.com/nTYYA3Nj

ent = 0
 
function clear()
        shell.run("clear")
end
 
function s1()
        while turtle.detect() == true do
                turtle.dig()
                os.sleep(0.6)
        end
        turtle.forward()
        test()
        while turtle.detectUp() == true do
                turtle.digUp()
                os.sleep(0.6)
                os.sleep(0.6)
        end
end
 
function test()
        if turtle.detectDown()==false then
                turtle.select(2)
                turtle.placeDown()
                print("false")
        end
end
 
function drop()
        turtle.select(3)
        turtle.drop(64)
        turtle.select(4)
        turtle.drop(64)
        turtle.select(5)
        turtle.drop(64)
        turtle.select(6)
        turtle.drop(64)
        turtle.select(7)
        turtle.drop(64)
        turtle.select(8)
        turtle.drop(64)
        turtle.select(9)
        turtle.drop(64)
        turtle.select(10)
        turtle.drop(64)
        turtle.select(11)
        turtle.drop(64)
        turtle.select(12)
        turtle.drop(64)
        turtle.select(13)
        turtle.drop(64)
        turtle.select(14)
        turtle.drop(64)
        turtle.select(15)
        turtle.drop(64)
        turtle.select(16)
        turtle.drop(64)
end
 
---------------------------------------------------
-- START
clear()
print("\n  <-[MINING PROGRAM V1.3.1]->")
print("  (C) Zekrommaster110 2015\n")
sleep(1.5)
 
clear()
write("\n Bitte anzahl der Gaenge eingeben: ")
local gaenge = read()
 
clear()
write("\nDieser Vorgang wird c.a. ")
write(gaenge*0.65)
write(" Minuten in anspruch nehmen.\n\n")
write("\nIn Slot 1 bitte ")
write(gaenge)
write(" Fackeln legen.\n\n")
local nullinput = read()
 
nfuel = gaenge*30
if nfuel > turtle.getFuelLevel() then
        print("Es ist nicht genuegend Fuel eingefuellt!")
        write("Benoetigt werden noch: ")
        write(nfuel-turtle.getFuelLevel())
        write(" Fuel. \n")
        print("Das sind: ")
        write("- ")
        write(nfuel/80)
        write(" Kohle")
        write("\n\n- ")
        write(nfuel/15)
        write(" Wood\n\n")
        print("Druecke Enter zum befuellen.")
        local nullinput = read()
        shell.run("refuel all")
end
 
clear()
print("Bitte legen sie nun noch 2 Truhen in Slot 3.")
print("\nZum starten bitte nocheinmal Enter druecken!\n")
local nullinput = read()
 
 
-- MINING PROGRAMM
 
s1()
        turtle.turnRight()
        s1()
        turtle.back()
        turtle.select(3)
        turtle.place()
        turtle.turnLeft()
s1()
        turtle.turnRight()
        s1()
        turtle.back()
        turtle.select(3)
        turtle.place()
        turtle.turnLeft()
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
 
for strip = 2, gaenge, 1 do
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
       
       
       
        -- ENTLEERUNG NACH 30 GAENGEN
        ent = ent+1
        if ent == 20 then
                turtle.turnRight()
                turtle.turnRight()
                goback1 = strip*3
                for goback2 = 2, goback1, 1 do
                        turtle.forward()
                        test()
                end
                turtle.turnLeft()
                drop()
                turtle.turnLeft()
                for goback2 = 2, goback1, 1 do
                        turtle.forward()
                        test()
                end
                ent = 0
        end
end
 
back = gaenge*3
turtle.turnRight()
turtle.turnRight()
for goback = 1, back, 1 do
        turtle.forward()
        test()
end