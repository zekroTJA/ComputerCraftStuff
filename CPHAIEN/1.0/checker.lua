local REDNET_SIDE = "top"
local CHECK_TIMEOUT = 60

local ID_TABLE = {
    [2] = 69,
    [3] = 88,
}

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

local function broadcast()
    open()
    local data = textutils.serialize({
        ["cmd"] = "check",
    })
    return rednet.broadcast(data)
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

local function itoa(i)
    if i < 10 then
        return "0" .. i
    end
    return tostring(i)
end

----------------------------------------------------

local statusTable = {}

local function receivejob(timeout)
    for k, v in pairs(ID_TABLE) do
        statusTable[k] = "timeout"
    end

    while true do
        peer, msg = receive(timeout)
        if not peer then
            clear()
            print("Starting checking for status issues ...\n")
            for k, v in pairs(statusTable) do
                local id = ID_TABLE[k]
                if id then
                    print(itoa(id) .. " - " .. v)
                end
            end
            return
        end
        statusTable[peer] = msg
    end
end

local function bcloop()
    broadcast()
    receivejob(CHECK_TIMEOUT)
end

clear()

print("Starting checking for status issues ...")
while not bcloop() do end

close()
