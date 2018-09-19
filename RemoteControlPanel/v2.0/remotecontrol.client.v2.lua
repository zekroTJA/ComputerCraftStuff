-- CC REMOTE TOOL v2 - CLIENT

-- Copyright 2018 zekro Development (Ringo Hoffmann)

-- Permission is hereby granted, free of charge, to any person obtaining 
-- a copy of this software and associated documentation files (the "Software"), 
-- to deal in the Software without restriction, including without limitation 
-- the rights to use, copy, modify, merge, publish, distribute, sublicense, 
-- and/or sell copies of the Software, and to permit persons to whom the Software 
-- is furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all 
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
-- CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---------------------------------- CONSTS ----------------------------------
SIDES      = {"top", "bottom", "front", "back", "left", "right"}
STATUSFILE = "status.dat"
VERSION    = "C2.0.1"
----------------------------------------------------------------------------

function fatal(error) 
    print("[ERROR] ", error)
    exit()
end

function mountModem() 
    for k, v in pairs(SIDES) do
        if pcall(rednet.open, v) then
            return true
        end
    end
    return false
end

function writeFile(filename, table)
    local file = fs.open(filename, "w")
    file.write(textutils.serialize(table))
    file.close()
end

function readFile(filename)
    local file = fs.open(filename, "r")
    if file ~= nil then
        local table = textutils.unserialize(file.readAll())
        file.close()
        return table
    end
    return nil
end

----------------------------------- MAIN -----------------------------------

local rsout, serverid = ...

if rsout == nil then
    fatal("No redstone output side defined as start argument.")
end

if serverid == nil then
    fatal("No server id defined as second start argument.")
end
serverid = tonumber(serverid)

print(
    "--------------------\n",
    "CC REMOTE TOOL\n",
    "(c) zekro 2018\n",
    "version ", VERSION, "\n",
    "--------------------\n"
)

if mountModem() then
    print("Modem mounted.")
else
    fatal("Failed to mount modem.")
end

status = readFile(STATUSFILE)

if status == nil then
    status = false
end

print("Set saved status: " .. tostring(status))
redstone.setOutput(rsout, status)

print("Waiting for 3 seconds...")
os.sleep(3)

print("Sending status message to server...")
rednet.send(serverid, status)

print("Listening for events...")
while true do
    id, message = rednet.receive()
    if id == serverid then
        print("[ SERVER ] " .. tostring(message))
        redstone.setOutput(rsout, message)
        writeFile(STATUSFILE, message)
    end
end

----------------------------------------------------------------------------