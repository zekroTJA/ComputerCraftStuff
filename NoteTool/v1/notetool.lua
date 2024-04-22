-- NOTE TOOL V.1.3.1
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2016

-- PASTEBIN: https://pastebin.com/reVGU1Kw


------------------------------------------------------
---------------  C U S T O M  V A R S  ---------------
------------------------------------------------------
local noteFileName = "notes"
local colorTitle = colors.red
local colorTitleBackground = colors.gray
local colorSelectLine = colors.pink
local colorPageButtons = colors.pink
local colorAddButton = colors.red
------------------------------------------------------
-- For a color table use this:
-- https://tweaked.cc/module/colors.html
------------------------------------------------------


local notes = {}
local selected = nil

-- test if a monitor is "pluged in"
local function testForMonitor()
    if not peripheral.find("monitor") then
        print("Please start this program on a monitor!")
        print("\nUse 'monitor <side> <program name>' or put this in your startup:")
        print("\nshell.run(''monitor <side> <program name>'')")
        error()
    end
end

-- get monitor size: width = monSize().w ; height = monSize().h
local function monSize()
    for _, v in ipairs(rs.getSides()) do
        if peripheral.isPresent(v) == true then
            local monitor = peripheral.wrap(v)
            local w, h = monitor.getSize()
            return { ["w"] = w, ["h"] = h }
        end
    end
end

-- clear screen
local function cls()
    term.setBackgroundColor(colors.black)
    shell.run("clear")
end

-- load notes file or if it not exists, create a file with default values
local function loadTabFile(filename)
    local file = fs.open(filename, "r")
    local t = nil
    if file ~= nil then
        t = textutils.unserialize(file.readAll())
        file.close()
    else
        local defaultTable = {
            "NOTE TOOL v1.2",
            "(c) 2016 by zekro",
            "Click add to add note",
            "Click on note to remove",
        }

        file = fs.open(filename, "w")
        file.write(textutils.serialize(defaultTable))
        file.close()
        t = defaultTable
    end
    return t
end

-- save the table from memory
local function saveTabFile(filename, input)
    local file = fs.open(filename, "w")
    file.write(textutils.serialize(input))
    file.close()
end

local function printEmptyLine(w)
    local line = ""
    for _ = 1, w do
        line = line .. " "
    end
    write(line)
end

-- render main gui
local function renderGui(page)
    local size = monSize()
    local maxItems = size.h - 2
    local maxPage = math.floor(#notes / maxItems) + 1

    cls()

    term.setBackgroundColor(colorTitleBackground)
    term.setCursorPos(1, 1)
    printEmptyLine(size.w)
    term.setBackgroundColor(colorTitle)
    local title = " NOTES - Page " .. page .. "/" .. maxPage .. " "
    term.setCursorPos(size.w / 2 - #title / 2, 1)
    print(title)

    term.setBackgroundColor(colors.black)

    for i = (page - 1) * maxItems + 1, math.min(page * maxItems, #notes) do
        if selected == i then
            term.setBackgroundColor(colorSelectLine)
            printEmptyLine(size.w)
            term.setCursorPos(1, i + 1)
            print(i, "-", notes[i])
            term.setCursorPos(size.w - 8, i + 1)
            print(" | ^ v X")
            term.setBackgroundColor(colors.black)
        else
            print(i, "-", notes[i])
        end
    end

    term.setCursorPos(1, size.h)
    term.setBackgroundColor(colorTitleBackground)
    printEmptyLine(size.w)

    term.setBackgroundColor(colorAddButton)
    term.setCursorPos(size.w / 2 - 3, size.h)
    write("[ ADD ]")

    if page < maxPage then
        term.setBackgroundColor(colorPageButtons)
        term.setCursorPos(size.w - 4, size.h)
        write("[ > ]")
    end

    if page > 1 then
        term.setBackgroundColor(colorPageButtons)
        term.setCursorPos(1, size.h)
        write("[ < ]")
    end
end


--------------------------------------------------------
---------------  M A I N  P R O G R A M  ---------------
--------------------------------------------------------

testForMonitor()

notes = loadTabFile(noteFileName)
local pageNumb = 1

while true do
    renderGui(pageNumb)
    saveTabFile(noteFileName, notes)

    local event, _, x, y = os.pullEvent()
    local size = monSize()

    if event ~= "monitor_touch" then
        goto continue
    end

    -- TOUCH EVENT: ADD
    if (x >= (size.w / 2 - 3)) and (x <= (size.w / 2 + 3)) and (y == size.h) then
        cls()
        print("Add note:")

        local input = io.read()
        if #input == 0 then
            goto continue
        end

        if (string.len(input) <= size.w - 4) then
            table.insert(notes, input)
        else
            print("\n Too much chars. Please only use ", (size.w - 4), " chars or change display width.")
            _ = io.read()
        end

        goto continue
    end

    -- TOUCH EVENT: PAGE UP
    if (x >= ((size.w - 4)) and (x <= size.w)) and (y == size.h) then
        pageNumb = pageNumb + 1
        goto continue
    end

    -- TOUCH EVENT: PAGE DOWN
    if (x >= 0) and (x <= 4) and (y == size.h) then
        if pageNumb >= 2 then
            pageNumb = pageNumb - 1
        end
        goto continue
    end

    if y > 1 and y < size.h then
        local i = y - 1
        if selected == i then
            if x == size.w - 1 then
                table.remove(notes, i)
                selected = nil
            elseif x == size.w - 3 then
                if i < #notes then
                    notes[i], notes[i + 1] = notes[i + 1], notes[i]
                    selected = selected + 1
                end
            elseif x == size.w - 5 then
                if i > 1 then
                    notes[i], notes[i - 1] = notes[i - 1], notes[i]
                    selected = selected - 1
                end
            else
                selected = nil
            end
        else
            selected = i
        end
    end

    ::continue::
end
