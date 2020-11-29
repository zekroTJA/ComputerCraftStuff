local ORDER_SIGNAL_SIDE = "back"

----------------------------------------------------

local rednetSide = nil

local function clear()
    shell.run("clear")
end

local function open()
    for _, v in pairs(redstone.getSides()) do
        if pcall(rednet.open, v) then
            rednetSide = v
            return
        end
    end
    print("ERR: Could not detect any wireless modem.")
    exit()
end

local function close()
    rednet.close(rednetSide)
end

local function send(receiver, msg)
    open()
    local data = textutils.serialize(msg)
    return rednet.send(receiver, data)
end

local function receive()
    open()
    local peer, data = rednet.receive()
    if not peer then
        return
    end
    local msg = textutils.unserialize(data)
    return peer, msg
end

----------------------------------------------------

local function order(peer, n)
    print("Received order ammount " .. n .. " from cid " .. peer)
    send(peer, "ack")
    for i = 1, n, 1 do
        redstone.setOutput(ORDER_SIGNAL_SIDE, true)
        sleep(0.25)
        redstone.setOutput(ORDER_SIGNAL_SIDE, false)
        sleep(0.5)
    end
end

local function mainloop()
    local peer, msg = receive()
    if not peer then
        return
    end

    if msg["cmd"] == "order" then
        order(peer, msg["n"])
    end
end

clear()
print("COMPUTER ID: " .. os.getComputerID())
print("Starting listening for orders...")
while not mainloop() do end
