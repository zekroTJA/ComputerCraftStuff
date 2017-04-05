-- ELEVATOR SOFTWARE [CLIENT SIDE] V.1.0
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2016

-- PASTEBIN: https://pastebin.com/2UJA8KwD


--os.sleep(5) --if your server is making trouble after restart with this program please activate this delay to solve

-- VARIABLES

sides = {"top", "bottom", "front", "back", "left", "right"}
i = 6
while i >= 1 do
    if peripheral.isPresent(sides[i]) == true then
        rednet.open(sides[i])
    end
    i = i - 1
end

-- Automatic detection of server id from server
-- serverID = <enter serverID here> --use this and disable the code below to disable automatic id detection system
shell.run("clear")
print("[ELEVATOR] Wating for server broadcast to grab server id...")
PREserverID, message, dist = rednet.receive()
if message == "547892135" then
    serverID = PREserverID
end

while true do

    shell.run("clear")
    print("[ELEVATOR] Please chose your etage you want to elevate to (between 1 and 15): ")
    etage = io.read()
    
    if tonumber(etage) >= 1 and tonumber(etage) <= 15 then
        rednet.send(serverID, etage)
        shell.run("clear")
    else
        print("Your input is invalid. Please type in a number between 1 and 15.")
        io.read()
        shell.run("clear")
    end
end