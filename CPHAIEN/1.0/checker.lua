--[[

© 2020 Ringo Hofmmann (zekro Development)

CPHAIEN STORAGE SYSTEM - CHECKER

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

local REDNET_SIDE = "left"
local CHECK_TIMEOUT = 60

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

function broadcast()
    open()
    local data = textutils.serialize({
        ["cmd"] = "check",
    })
    return rednet.broadcast(data)
end

function receive(timeout)
    open()
    local peer, data = rednet.receive(timeout)
    if not peer then
        return
    end
    local msg = textutils.unserialize(data)
    return peer, msg
end

----------------------------------------------------

function receivejob(timeout)
    while true do
        peer, msg = receive(timeout)
        if not peer then
            return
        end
        if msg ~= "ok" then
            print("CID " .. peer .. " has status " .. msg)
        end
    end
end

function bcloop()
    -- sleep(5)
    broadcast()
    receivejob(CHECK_TIMEOUT)
end

clear()
-- job = coroutine.create(receivejob)
-- coroutine.resume(job)

print("Starting checking for status issues ...")
while not bcloop() do end

close()
