--[[

© 2020 Ringo Hofmmann (zekro Development)

CPHAIEN STORAGE SYSTEM - ORDER PANEL

---------

CPHAIEN PROTOCOL V1.1

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

local REDNET_SIDE = "top"

local ID_TABLE = {
    ["cobblestone"] = 2,
}

----------------------------------------------------

local rednetSide = nil

local function clear()
    shell.run("clear")
end

local function findByName(name)
    local i, n, id = 999999, nil, nil
    for k, v in pairs(ID_TABLE) do
        local s = string.find(k, name)
        if s and s < i then
            i = s
            n = k
            id = v
        end
    end
    return n, id
end

local function open()
    rednet.open(REDNET_SIDE)
    rednetSide = REDNET_SIDE
end

local function close()
    rednet.close(rednetSide)
end

local function send(receiver, n)
    open()
    local cmd = {
        ["cmd"] = "order",
        ["n"] = n,
    }
    local data = textutils.serialize(cmd)
    return rednet.send(receiver, data)
end

local function receive(timeout)
    open()
    local peer, data = rednet.receive(timeout)
    if not peer then
        return
    end
    local msg = textutils.unserialize(data)
    return peer, msg
end

local function receiveAck(receiver)
    open()
    local id, msg = receive(5)
    if not id then
        return false, "timeout"
    end
    if id ~= receiver then
        return false, "invalid ack id"
    end
    if msg ~= "ack" then
        return false, "invalid ack message"
    end
    return true, ""
end

----------------------------------------------------

local function mainloop()
    clear()
    print("Enter the item to be ordered:")
    local input = read()
    
    local item, id = findByName(input)
    if not item then
        print("Could not find any item by '" .. input .."'.")
        read()
        return
    end

    print("\nSelected item:  " .. item .. " [cid: " .. id .. "]")
    print("\nHow much do you want to order?")
    print("Press enter for 1 stack or enter a number of stacks.")
    print("Enter 'c' or 'e' to cancel the order.")
    input = read()

    local inputn = 1
    if input ~= "" then
        inputn = tonumber(input)
        if not inputn then
            return
        end
    end

    print("\nOrdering " .. inputn .. " stacks of '" .. item .. "' ...")
    send(id, inputn)
    
    print("Waiting for order acknowledgement ...")
    local ok, err = receiveAck(id)
    if not ok then
        print("Failed receiving acknowledgement: " .. err)
        read()
        return
    end

    print("Received order acknowledgement. Your order will arrive soon! :)")
    sleep(3)
end

open()
while not mainloop() do end

close()
