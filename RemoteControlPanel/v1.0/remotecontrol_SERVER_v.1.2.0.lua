-- REMOTE CONTROL PANEL [SERVER SIDE] V.2.0
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2016

-- PASTEBIN: https://pastebin.com/WuEY2Mze

-- IMPORTANT: 
-- Please install Client Tool (http://pastebin.com/VNViH32U) as startup on your client pc's with wireless modem and redstone wire attached to the back to connect with the server


------- CUSTOM VARIABLES ------
modemSide = "top"
tableFileName = "remoteSaves.txt"
--- END OF CUSTOM VARIABLES ---


------- FILE HANDLER -------
function writeFile(filename, table)
    file = fs.open(filename, "w")
    file.write(textutils.serialize(table))
    file.close()
end

function doIfFileDoesNotExist()
	cls()
    print("Please enter entitys in table file '", tableFileName, 
        "' located in the computer folder of this program and follow ",
        "the instructions in the 'readme.txt' file.")
    print("\nThen please restart the program.")
    def_tab = {}
    writeFile(tableFileName, def_tab)
    file = fs.open("readme (better open with notepad++ cause of format ;D).txt", "w")
    file.write("To enter entitys please open the '")
    file.write(tableFileName) 
    file.write("' file with an editor and follow the pattern subsequent:\n\n")
    file.write("{\n")
    file.write("   [COMPUTER ID 1] = {\"FUNCTION NAME 1\", true/false}, \n")
    file.write("   [COMPUTER ID 2] = {\"FUNCTION NAME 2\", true/false}, \n")
    file.write("}")
    file.write("\n\n")
    file.write("Example:\n\n")
    file.write("{\n")
    file.write("    [5] = {\"NUCLEAR REACTOR\", false},\n")
    file.write("    [6] = {\"LAVA PUMP\", true},\n")
    file.write("    [7] = {\"MASSFABRICATOR\", false},\n")
    file.write("}\n\n")
    file.close()
    error()
end

function testIfFileExists(filename)
    file = fs.open(filename,"r")
    if file ~= nil then
        file.close()
        return true
    else
        return false
    end
end

function deleteFile(filename)
    fs.delete(filename)
end

function readFile(filename)
    file = fs.open(filename, "r")
    if file ~= nil then
        table = textutils.unserialize(file.readAll())
        file.close()
    else
        doIfFileDoesNotExist()
    end
    return table
end
-- END OF FILE HANDLER --

function cls()
    term.setBackgroundColor(colors.black)
    shell.run("clear")
end

function mainGui()
   
    cls()
    count1 = 0
    for k in pairs(entitys) do
        
        count1 = count1 + 2
        
        term.setCursorPos(2, count1)
        if (entitys[k][2] == false) then
            term.setBackgroundColor(colors.red)
            print("[ OFF ]")
        else
            term.setBackgroundColor(colors.green)
            print("[ ON  ]")
        end
        
        term.setCursorPos(10, count1)
        term.setBackgroundColor(colors.cyan)
        print("[", k, "]")
        
        term.setBackgroundColor(colors.gray)
        term.setCursorPos(14, count1)
        print(entitys[k][1])
        
    end
    
end

-------------------------

rednet.open(modemSide)

entitys = readFile(tableFileName)

for k in pairs(entitys) do
    rednet.send(k, entitys[k][2])
end

while true do
    
    mainGui()
    
    event,side,x,y = os.pullEvent()
    if event == "monitor_touch" then
        
        if y % 2 == 0 and x >= 2 and x <= 8 then
            count2 = 0
            for k in pairs(entitys) do
                count2 = count2 + 1
                if count2 == y/2 then
                    if entitys[k][2] == false then
                        entitys[k][2] = true
                        rednet.send(k, true)
                        writeFile(tableFileName, entitys)
                    else
                        entitys[k][2] = false
                        rednet.send(k, false)
                        writeFile(tableFileName, entitys)
                    end
                    break
                end
            end
        end
        
    end
end