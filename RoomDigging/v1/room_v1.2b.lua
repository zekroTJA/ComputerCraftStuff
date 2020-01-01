-- ROOM DIGGING PROGRAMM V.1.2 B
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2015

-- PASTEBIN: https://pastebin.com/D0U13E4D

function drop()
	turtle.select(1)
	turtle.dropDown(64)
	turtle.select(2)
	turtle.dropDown(64)
	turtle.select(3)
	turtle.dropDown(64)
	turtle.select(4)
	turtle.dropDown(64)
	turtle.select(5)
	turtle.dropDown(64)
	turtle.select(6)
	turtle.dropDown(64)
	turtle.select(7)
	turtle.dropDown(64)
	turtle.select(8)
	turtle.dropDown(64)
	turtle.select(9)
	turtle.dropDown(64)
	turtle.select(10)
	turtle.dropDown(64)
	turtle.select(11)
	turtle.dropDown(64)
	turtle.select(12)
	turtle.dropDown(64)
	turtle.select(13)
	turtle.dropDown(64)
	turtle.select(14)
	turtle.dropDown(64)
	turtle.select(15)
	turtle.dropDown(64)
	turtle.select(16)
	turtle.dropDown(64)
end


-- Begrüßung

shell.run("clear")
textutils.slowPrint("Wilkommen beim\nVolumenaushebungsprogramm [v1.2]\nvon Zekro.")
textutils.slowPrint("\n(C) Zekrommaster110 2015\n")
print("Druecke Enter zum fortfahren.")

local input = read()



-- First Input

shell.run("clear")
print("")
print("     Y           ")
print("     |           ")
print("     |           ")
print("     |           ")
print("     --------- X ")
print("    /            ")
print("   /             ")
print("  Z              ")
print("")

write("Y (Hoehe):  ")
local ycord = read()
write("X (Breite): ")
local xcord = read()
write("Z (Tiefe):  ")
local zcord = read()

write("\nEs werden ")
write(ycord * xcord * zcord)
write(" Bloecke abgebaut!\n\n")

fuel = turtle.getFuelLevel()
needfuel = xcord * ycord * zcord * 2

write("Dieser Vorgang wird benoetigen:\n - ")
write(xcord * ycord * zcord * 2)
write(" Fuel\n")
write("Aktuelles Fuel Level:\n - ")
write(fuel)
write(" Fuel\n\n")

if fuel > needfuel then
	print("Der Treibstoff ist ausreichend fuer den Vorgang!\n")
end
if fuel < needfuel then
	print("ACHTUNG! Der Treibstoff ist nicht ausreichend fuer den Vorgang! Bitte nachfuellen!")
	write("Benoetigt wird noch ")
	write(needfuel - fuel)
	write(" Fuel.\n\n")
	
	print("Bitte legen sie den benoetigten Brennstoff in das Turtle-Inventar! (AUFRUNDEN!)")
	print("Benutzt werden kann:")
	write(needfuel/80)
	write(" Kohle\n")
	write(needfuel/15)
	write(" Wooden Planks/Log\n\n")
	
	print("Druecke Enter zum auffuellen.")
	local input = read()
	
	shell.run("refuel all")
	
	print("\n")
	
end

print("Druecke Enter zum fortfahren.")
local input = read()

shell.run("clear")
print("Bitte Legen sie nun eine Truhe in den ersten Slot der Turtle.")
print("Art der Truhe (Wooden Chest, Iron Chest...) ist unrelevant.\n")

print("Druecke Enter zum fortfahren.")
local input = read()

layervol = xcord * zcord

if layervol > 950 then
	shell.run("clear")
	print("ACHTUNG! Bei der angegebenen Layergroesse:\n")
	write(xcord)
	write(" Bloecke x ")
	write(zcord)
	write(" Blocke\n\n")
	print("besteht die Gefahr, dass das Turtle-Inventar voll ist bevor sie es in die Kiste transportieren kann!")
	print("Wenn sie nun fortfahren, koennten Recourcen verloren gehen!\n")
	
	print("Druecke Enter zum fortfahren.")
	local input = read()
end


-- MAIN PROGRAMM

turtle.dig()
shell.run("go forward")
turtle.digDown()
turtle.select(1)
turtle.placeDown()

chest = 0

for y = 2, ycord, 1 do

	for x = 2, xcord, 1 do
	
		for z = 2, zcord, 1 do
			turtle.dig()
			shell.run("go forward")
		end
		turtle.turnRight()
		turtle.turnRight()
		for z = 2, zcord, 1 do
			turtle.dig()
			shell.run("go forward")
		end
		turtle.turnLeft()
		turtle.dig()
		shell.run("go forward")
		turtle.turnLeft()
	
	end
	
	for z = 2, zcord, 1 do
		turtle.dig()
		shell.run("go forward")
	end
	turtle.turnRight()
	turtle.turnRight()
	for z = 2, zcord, 1 do
		turtle.dig()
		shell.run("go forward")
	end
	
	turtle.turnRight()
	
	for backlayer1 = 2, zcord, 1 do
		shell.run("go forward")
	end
	
	turtle.turnRight()
	
	for chestloop = 1, chest, 1 do
		shell.run("go down")
	end
	
	drop()
	
	for chestloop = 1, chest, 1 do
		shell.run("go up")
	end
	
	chest = chest + 1
	
	turtle.digUp()
	shell.run("go up")
	
end

for x = 2, xcord, 1 do
	
		for z = 2, zcord, 1 do
			turtle.dig()
			shell.run("go forward")
		end
		turtle.turnRight()
		turtle.turnRight()
		for z = 2, zcord, 1 do
			turtle.dig()
			shell.run("go forward")
		end
		turtle.turnLeft()
		turtle.dig()
		shell.run("go forward")
		turtle.turnLeft()
	
	end
	
	for z = 2, zcord, 1 do
		turtle.dig()
		shell.run("go forward")
	end
	turtle.turnRight()
	turtle.turnRight()
	for z = 2, zcord, 1 do
		turtle.dig()
		shell.run("go forward")
	end
	
	turtle.turnRight()
	
	for backlayer1 = 2, zcord, 1 do
		shell.run("go forward")
end

for godown1 = 2, ycord, 1 do
	shell.run("go down")
end

turtle.turnRight()

drop()

-- End

shell.run("clear")
print("Vorgang ist abgeschlossen!")
write(xcord * ycord * zcord)
write(" Bloecke wurden erfolgreich abgebaut!")