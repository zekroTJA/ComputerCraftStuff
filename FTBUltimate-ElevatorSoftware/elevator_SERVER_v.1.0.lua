-- ELEVATOR SOFTWARE [SERVER SIDE] V.1.0
-- FOR MINECRAFT COMPUTER CRAFT
-- (C) zekro 2016

-- PASTEBIN: https://pastebin.com/ZA5Tyj2u


-- WHITE	         1	     0
-- ORANGE	         2	     1
-- MAGENTA	         4	     2
-- LIGHT BLUE	     8	     3
-- YELLOW	        16	     4
-- LIME GREEN	    32	     5
-- PINK	            64	     6
-- GRAY	           128	     7
-- LIGHT GRAY	   256	     8
-- CYAN	           512	     9
-- PURPLE	      1024	    10
-- BLUE	          2048	    11
-- BROWN	      4096	    12
-- GREEN	      8192	    13
-- RED	          16384	    14
-- BLACK	      32768	    15    // R-SIGNAL

--os.sleep(5) //if your server is making trouble after restart with this program please activate this delay to solve

-- VARIABLES
sideBundle = "right" --please enter here the side, where the elevator main cable gets into the server computer


sides = {"top", "bottom", "front", "back", "left", "right"}
i = 6
while i >= 1 do
    if peripheral.isPresent(sides[i]) == true then
        rednet.open(sides[i])
    end
    i = i - 1
end


-- Automatic broadcast to give elevator clients servers id (can be disabled if you want manually enter server id)
os.sleep(1)
rednet.broadcast("547892135")

os.sleep(1)

shell.run("clear")
print("[ELEVATOR SERVER] Server is running.")

while true do
    
    id, message, dist = rednet.receive()
    
    if tonumber(message) >= 1 then
        redstone.setBundledOutput(sideBundle, 2^(tonumber(message)-1))
        while redstone.testBundledInput(sideBundle, 32768) == false do
            os.sleep(1)
        end
        os.sleep(1.5)
        while redstone.testBundledInput(sideBundle, 32768) == false do
            os.sleep(1)
        end
        redstone.setBundledOutput(sideBundle, 0)
    end
        
end