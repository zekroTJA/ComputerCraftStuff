-- A stupid little pogram to display the famous DVD screensaver.

local speed = 1        -- Speed is the multiple of 0.5s between re-draws
local text = "DVD"     -- The text written, must be single line, otherwise it will break
local colorPalette = { -- Colors the text will be displayed in in subsequent order
    colors.white,
    colors.orange,
    colors.magenta,
    colors.lightBlue,
    colors.yellow,
    colors.lime,
    colors.pink,
    colors.lightGray,
    colors.cyan,
    colors.purple,
    colors.blue,
    colors.brown,
    colors.green,
    colors.red
}

---------------------------------------------------------------------------------

-- Takes a position table as first oarameter and a vector table
-- as second parameter and returns the sum of both.
local function addVec(pos, vec)
    return { x = pos.x + vec.x, y = pos.y + vec.y }
end

-- Draws the frame of the text given the position, vector and color.
-- Returns a new position of the text and vector which can be passed
-- to the next call of the function to fraw the next frame.
local function draw(pos, vec, color)
    local width, height = term.getSize()

    term.setCursorPos(pos.x, pos.y)
    term.setTextColor(colors.black)
    write(string.rep(" ", #text))

    local newPos = addVec(pos, vec)
    if newPos.x < 1 then
        vec.x = vec.x * -1
    end
    if newPos.y < 1 then
        vec.y = vec.y * -1
    end
    if newPos.x + #text - 1 > width then
        vec.x = vec.x * -1
    end
    if newPos.y > height then
        vec.y = vec.y * -1
    end

    pos = addVec(pos, vec)

    term.setCursorPos(pos.x, pos.y)
    term.setTextColor(color)
    write(text)

    return pos, vec
end

-- Returns a random position in the displays bounding box.
local function getRandomPos()
    local width, height = term.getSize()
    return {
        x = math.random(1, width - #text - 1),
        y = math.random(1, height - 1)
    }
end

-- Returns a random movement vector.
local function getRandomVec()
    local x, y = math.random(0, 1), math.random(0, 1)
    if x == 0 then
        x = -1
    end
    if y == 0 then
        y = -1
    end
    return {
        x = x,
        y = y
    }
end

------------------------------------------------------------

term.setBackgroundColor(colors.black)
term.clear()

local pos = getRandomPos()
local vec = getRandomVec()

local frame = 1

while true do
    pos, vec = draw(pos, vec, colorPalette[frame])

    if frame % #colorPalette == 0 then
        frame = 1
    else
        frame = frame + 1
    end

    sleep(0.5 / speed)
end
