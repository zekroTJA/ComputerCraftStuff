--[[

© 2020 Ringo Hofmmann (zekro Development)

CPHAIEN STORAGE SYSTEM - CLIENT

---------

CPHAIEN PROTOCOL V1.0

The CPHAIEN protocol is a simple protocol which is utilized for
communication between the CLIENT pc's, SERVER pc and the CHECKER
interface pc.

The protocol communication is baed on a simple command-response
communication system.

A command is a string encoded map which MUUST always have the
key "cmd" with the COMMAND as string value. These are the 
currently implemented commands:

"order" / 1

    Issues an ORDER to a CLIENT.
    Takes one argument named "n", which specifies the ammount 
    of ordered entities (type number).
    An order request MUST be answered by an acknowledgement
    message with the encoded content < "ack" >.

    Example:
        A -> B:  {"cmd"="order","n"=5,}
        B -> A:  "ack"

"check" / 0

    Requests the CLIENT state.
    Takes no arguments.
    A check command must be responded by an encoded STATUS 
    string. A status can be any string, but the string "ok"
    MUST be interpreted as the normal, default state.

    Example:
        A -> B:  {"cmd"="check",}
        B -> A:  "ok"

]]

local REDNET_SIDE = "right"
local REDSTONE_SIDE = "back"

----------------------------------------------------

function clear()
    shell.run("clear")
end

function open()
    if not rednet.isOpen(REDNET_SIDE) then
        rednet.open(REDNET_SIDE)
    end
end

function close()
    if rednet.isOpen(REDNET_SIDE) then
        rednet.close(REDNET_SIDE)
    end
end

function send(receiver, msg)
    open()
    local data = textutils.serialize(msg)
    return rednet.send(receiver, data)
end

function receive()
    open()
    local peer, data = rednet.receive()
    if not peer then
        return
    end
    local msg = textutils.unserialize(data)
    return peer, msg
end

----------------------------------------------------

function order(peer, n)
    print("Received order ammount " .. n .. " from cid " .. peer)
    send(peer, "ack")
    for i = 1, n, 1 do
        redstone.setOutput(REDSTONE_SIDE, true)
        sleep(0.25)
        redstone.setOutput(REDSTONE_SIDE, false)
        sleep(0.5)
    end
end

function check(peer)
    print("Received check from cid " .. peer)
    local state = "ok"
    if redstone.getInput(REDSTONE_SIDE) then
        state = "blocked"
    end
    send(peer, state)
end

function mainloop()
    local peer, msg = receive()
    if not peer then
        return
    end

    if msg["cmd"] == "order" then
        order(peer, msg["n"])
    elseif msg["cmd"] == "check" then
        check(peer)
    end
end

clear()
print("COMPUTER ID: " .. os.getComputerID())
print("Starting listening for orders...")
while not mainloop() do end
