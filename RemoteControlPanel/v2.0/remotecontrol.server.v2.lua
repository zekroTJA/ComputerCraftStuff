-- CC REMOTE TOOL v2 - SERVER

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
SIDES       = {"top", "bottom", "front", "back", "left", "right"}
CONFIG_FILE = "server.config"
VERSION     = "S2.1.0"
----------------------------------------------------------------------------

STATUS = {
    [0]   = {"DOWN", colors.red},
    [1]   = {" UP ", colors.green},
    [2]   = {"OFFL", colors.purple},
}

statusMap = {}
tileLocations = {}
sizeX, sizeY = term.getSize()

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

function drawTile(text, bgColor, textColor)
    term.setBackgroundColor(bgColor)
    term.setTextColor(textColor)
    term.write(text)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end

function itoa(i)
    if i < 10 then
        return "0" .. i
    end
    return tostring(i)
end

function status(id)
    return statusMap[id]
end

function printStatus(id)
    local _status = STATUS[status(id)][1]
    local _color  = STATUS[status(id)][2]
    drawTile("[" .. _status .. "]", _color, colors.black)
end

function printTitle()
    local title = ""
    local text = "CC REMOTE v." .. VERSION .. " | (c) zekro 2018"
    local space = (sizeX - string.len(text)) / 2
    for i = 1, space, 1 do
        title = title .. " "
    end
    title = title .. text
    for i = 1, space+2, 1 do
        title = title .. " "
    end
    drawTile(title, colors.lightGray, colors.black)
end

function printGUI(config)
    shell.run("clear")
    printTitle()
    local i = 3
    for k, v in pairs(config) do
        term.setCursorPos(2, i)
        printStatus(k)
        term.write(" ")
        drawTile("[" .. itoa(k) .. "]", colors.cyan, colors.black)
        term.write(" ")
        drawTile(v, colors.orange, colors.black)
        tileLocations[i] = k
        i = i + 2
    end
end

function swap(n) 
    if n == 1 then return 0 end
    return 1
end

----------------------------------- MAIN -----------------------------------

shell.run("clear")

if not mountModem() then
    fatal("No modem found to mount")
end

config = readFile(CONFIG_FILE)
if config == nil then
    writeFile(CONFIG_FILE, {
        [1] = "EXAMPLE DISPLAY NAME",
        [2] = "EXAMPLE DISPLAY NAME 2"
    })
    print("Config file was not existent yet and was created in the computers root directory as 'server.config'.\
           \nOpen it and edit the variables. Then restart the server component.")
    return
end

for k, v in pairs(config) do
    statusMap[k] = 2
    local id, status = rednet.receive(10)
    if id ~= nil then
        statusMap[id] = status
        print("Received status of " .. id .. ": " .. status)
    else
        print("Timed out.")
    end
end

while true do
    printGUI(config)
    event, side, x, y = os.pullEvent()
    if event == "monitor_touch" then
        local id = tileLocations[y]
        if id ~= nil then
            local _status = swap(statusMap[id])
            statusMap[id] = _status
            rednet.send(id, _status)
        end
    end
end

----------------------------------------------------------------------------
