local REDNET_SIDE = "bottom"
local CHECK_SIGNAL_SIDE = "top"

----------------------------------------------------

local rednetSide = nil

local function clear()
    shell.run("clear")
end

local function open()
    rednet.open(REDNET_SIDE)
    rednetSide = REDNET_SIDE
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

local function check(peer)
    print("Received check from cid " .. peer)
    local state = "ok"
    if redstone.getInput(CHECK_SIGNAL_SIDE) then
        state = "blocked"
    end
    send(peer, state)
end

local function mainloop()
    local peer, msg = receive()
    if not peer then
        return
    end

    if msg["cmd"] == "check" then
        check(peer)
    end
end

clear()
open()
print("COMPUTER ID: " .. os.getComputerID())
print("Starting listening for checks...")
while not mainloop() do end
