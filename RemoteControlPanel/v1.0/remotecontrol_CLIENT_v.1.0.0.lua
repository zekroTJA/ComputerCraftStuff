-- REMOTE CONTROL PANEL [CLIENT SIDE] V.1.0
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2016

-- PASTEBIN: https://pastebin.com/VNViH32U

-- OPEN REDNET PORT
sides = {"top", "bottom", "front", "back", "left", "right"}
i = 6
while i >= 1 do
    if peripheral.isPresent(sides[i]) == true then
        rednet.open(sides[i])
    end
    i = i - 1
end

while true do
    
    id, message = rednet.receive()
    redstone.setOutput("back", message)
    
end