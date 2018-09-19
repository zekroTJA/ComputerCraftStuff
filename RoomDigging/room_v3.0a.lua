-- Grid definition:
--     y   x        
--     |  /         
--     | /          
--     |/           
--     -------- z 


_x, _y, _z = ...
t = turtle

-- Getting numeral cords in a map
CORDS = {
    ["x"] = tonumber(_x),
    ["y"] = tonumber(_y),
    ["z"] = tonumber(_z)
}

-----------------------------------------------------------
-- HELP FUNCTIONS

-- Clear screen help function
function cls()
    shell.run("clear") 
end

-----------------------------------------------------------
-- MINING FUNCTIONS

-- Dig and go forward after
-- @param {boolen} up:   true → dig also all blocks above
-- @param {boolen} down: true → dig also all blocks below
function dig(up, down)
    if up then t.digUp() end
    if down then t.digDown() end
    t.dig()
    t.forward()
end

-- Dig down for defined times
-- @param {number} times: dig down x times
function dig_down(times)
    for i = 1, times do
        t.digDown()
        t.down()
    end
end

-- Dig one line
-- @param {number} len:  length of the line
-- @param {boolen} up:   true → dig also all blocks above
-- @param {boolen} down: true → dig also all blocks below
function dig_line(len, up, down)
    for i = 1, len do
        dig(up, down)
    end
end

-- Dig one layer
-- @param {number} x:    depth of the layer
-- @param {number} y:    width of the layer
-- @param {boolen} up:   true → dig also all blocks above
-- @param {boolen} down: true → dig also all blocks below
function dig_layer(x, z, up, down)
    for i = 1, z do
        if i > 1 and i % 2 == 0 then
            t.turnRight()
            dig(up, down)
            t.turnRight()
        elseif i > 1 then
            t.turnLeft()
            dig(up, down)
            t.turnLeft()
        end
        dig_line(x - 1, up, down)
    end
    if z % 2 == 0 then
        t.turnRight()
        dig_line(z - 1, up, down)
        t.turnRight()
    else
        t.turnLeft()
        dig_line(z - 1, up, down)
        t.turnLeft()
        dig_line(x - 1, up, down)
        t.turnLeft()
        t.turnLeft()
    end
end

-- Finally dig the room
-- @param {number} x: depth of the room
-- @param {number} z: width of the room
-- @param {number} y: height of the room
function dig_room(x, z, y)
    local n = y

    dig()
    if n == 1 then
        dig_layer(x, z, 1)
        return
    end

    while n > 0 do
        print(n)
        while t.down() do end
        if n ~= y then dig_down(1) end
        if n >= 3 then
            dig_down(1)
            dig_layer(x, z, true, true)
            n = n - 3
        elseif n >= 2 then
            dig_layer(x, z, false, true)
            n = n - 2
        else
            dig_layer(x, z)
            n = n - 1
        end
    end
end


-----------------------------------------------------------
-- MAIN

-- dig_line(3, true, true)
-- dig_layer(3, 4, true, true)
dig_room(3, 3, 5)