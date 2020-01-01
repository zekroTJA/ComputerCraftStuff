-- NOTE TOOL V.1.2.2
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2016

-- PASTEBIN: https://pastebin.com/reVGU1Kw


------------------------------------------------------
---------------  C U S T O M  V A R S  ---------------
------------------------------------------------------
local noteFileName = "notes"    -- default: "notes"
local colorTitle = 8192         -- default: 8192
local colorPageButtons = 128    -- default:  128
local colorAddButton = 8192     -- default: 8192
------------------------------------------------------
-- For a color table use this:
-- http://computercraft.info/wiki/Colors_(API)
------------------------------------------------------


local notes = {}

-- test if a monitor is "pluged in"
function testForMonitor()
    for k in pairs(rs.getSides()) do
        if peripheral.isPresent(rs.getSides()[k]) == true then
            break
        else
            if k == 6 then
                print("Please start this program on a monitor!")
                print("\nUse 'monitor <side> <program name>' or put this in your startup:")
                print("\nshell.run(''monitor <side> <program name>'')")
                error()    
            end
        end
    end
end

-- get monitor size: width = monSize().w ; height = monSize().h
function monSize()
    for i, v in ipairs(rs.getSides()) do
        if peripheral.isPresent(v) == true then
            monitor = peripheral.wrap(v)
            w, h = monitor.getSize()
            return {["w"] = w, ["h"] = h}
        end
    end
end

-- clear screen
function cls()
    term.setBackgroundColor(colors.black)
    shell.run("clear") 
end

-- load notes file or if it not exists, create a file with default values
function loadTabFile(filename)
    file = fs.open(filename, "r")
    if file ~= nil then
        table = textutils.unserialize(file.readLine())
        file.close()
    else
        defaultTable = {
            "NOTE TOOL v1.2",
            "(c) 2016 by zekro",
            "Click add to add note",
            "Click on note to remove",
        }
        
        file = fs.open(filename, "w")
        file.write(textutils.serialize(defaultTable))
        file.close()
        table = defaultTable
    end
    return table
end

-- save the table from memory
function saveTabFile(filename, input)
    file = fs.open(filename, "w")
    file.write(textutils.serialize(input))
    file.close()
end

-- render main gui
function renderGui(page)
    cls()
    
    term.setCursorPos((monSize().w)/2-6, 1)
    term.setBackgroundColor(colorTitle)
    print("NOTES - Page ", pageNumb)
    
    term.setBackgroundColor(colors.black)
    count2 = 0
    for k in pairs(notes) do
        count2 = count2 + 1
        if count2 >= (page-1) * ((monSize().h)-2) then
            print(count2, " - ", notes[k])
        end
        
        if count2 == (page) * ((monSize().h)-3) then
           break 
        end
    end
    
    term.setBackgroundColor(colorAddButton)
    term.setCursorPos((monSize().w)/2-3, (monSize().h))
    write("[ ADD ]")
    
    term.setBackgroundColor(colorPageButtons)
    term.setCursorPos((monSize().w)-4, (monSize().h))
    write("[ > ]")
    
    term.setBackgroundColor(colorPageButtons)
    term.setCursorPos(1, (monSize().h))
    write("[ < ]")
    
    
end

-- get length of a table (just in case if i need to use it later for some reason ;D)
function tablelength(table)
  local count5 = 0
  for k in pairs(table) do 
        count5 = count5 + 1 
    end
  return count5
end



--------------------------------------------------------
---------------  M A I N  P R O G R A M  ---------------
--------------------------------------------------------

testForMonitor()

notes = loadTabFile(noteFileName)
pageNumb = 1

renderGui(pageNumb)
while true do
    
    event,side,x,y = os.pullEvent()
    
    -- TOUCH EVENT: ADD
    if (event == "monitor_touch") and (x >= ((monSize().w)/2-3)) and (x <= ((monSize().w)/2+7)) and (y == (monSize().h)) then
        
        cls()
        print("Add note:")
        
        for i=1,1000,1 do
            if notes[i] == nil then
                print("Ad to: ",i)
                input = io.read()
                if (string.len(input) <= (monSize().w)-4) then
                    notes[i] = input
                else
                    print("\n Too much chars. Please only use ", ((monSize().w)-4), " chars or change display width.") 
                    io.read()
                end
                break
            end
        end
        
    end
    
    -- TOUCH EVENT: DELETE
    if (event == "monitor_touch") and (x >= 1) and (x <= monSize().w) and (y >= 2) and (y <= (monSize().h)-3) then
        
        cls()
        count1 = 0
        for k in pairs(notes) do
            count1 = count1 + 1
            if count1 == ((y - 1) + (pageNumb - 1)*(monSize().h - 3)) then
                notes[k] = nil
                break
            end
        end
        
    end
    
    -- TOUCH EVENT: PAGE UP
    if (event == "monitor_touch") and (x >= (((monSize().w)-4)) and (x <= (monSize().w))) and (y == (monSize().h)) then
        pageNumb = pageNumb + 1  
    end
    
    -- TOUCH EVENT: PAGE DOWN
    if (event == "monitor_touch") and (x >= 0) and (x <= 4) and (y == (monSize().h)) then
        if pageNumb >= 2 then
            pageNumb = pageNumb - 1
        end
    end
    
    renderGui(pageNumb)
    saveTabFile(noteFileName, notes)
end