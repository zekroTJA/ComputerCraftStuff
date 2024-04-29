-- The side of the computer from where the redstone signal is coming
-- top control the player bases.
local inputSide = "front"
-- The color coding for the control redstone input.
local inputCoding = {
    p1Up = colors.orange,
    p1Down = colors.red,
    p2Up = colors.purple,
    p2Down = colors.blue,
}
-- The rate (in events per second) at which the input is getting pulled.
-- Increasing this value also increases the speed on which the bases are
-- moving, so take this in consideration when dialing in the value for
-- baseSpeed.
local inputRate = 20

-- The rate at which the game is re-drawn (in frames per second). Keep in
-- mind that this will also influence the speed at which the ball is moving
-- when dialing in the ball speed values. This does not influcen the base
-- movement speed though.
local frameRate = 20

-- The width of the bases in pixels.
local baseWidth = 4
-- The movement speed of the base per frame in pixels.
local baseSpeed = 0.3
-- The movement speed of the ball per frame in pixels.
local ballSpeed = { x = 0.5, y = 0.5 }
-- The minimum score required to win a game.
local winmax = 5

-- Some styling.
local baseColor = colors.white
local ballColor = colors.red

---------------------------------------------------------------------------------------

local width, height = term.getSize()

local score = { p1 = 0, p2 = 0 }

local p1BasePos = 0
local p2BasePos = 0

local ballPos = { x = 0, y = 0 }
local ballVec = { x = 0, y = 0 }

local function addVec(a, b)
    return { x = a.x + b.x, y = a.y + b.y }
end

local function drawTitle()
    local text = " PING PONG "
    term.setCursorPos(width / 2 - #text / 2, 1)
    term.setBackgroundColor(colors.red)
    write(text)
    term.setBackgroundColor(colors.black)
end

local function drawReadyState(p1, p2)
    term.setCursorPos(width / 2 - 5, height / 2)

    if p1 then
        term.setTextColor(colors.white)
        term.setBackgroundColor(colors.red)
    else
        term.setTextColor(colors.gray)
        term.setBackgroundColor(colors.black)
    end
    write("[P1]")

    term.setBackgroundColor(colors.black)
    write("  ")

    if p2 then
        term.setTextColor(colors.white)
        term.setBackgroundColor(colors.red)
    else
        term.setTextColor(colors.gray)
        term.setBackgroundColor(colors.black)
    end
    write("[P2]")

    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
end

local function drawMenu()
    term.setBackgroundColor(colors.black)
    term.setCursorPos(1, 1)
    term.clear()

    drawTitle()

    local text = "Touch anywhere to start"
    term.setCursorPos(width / 2 - #text / 2, height / 2)
    write(text)

    os.pullEvent("monitor_touch")

    term.setBackgroundColor(colors.black)
    term.setCursorPos(1, 2)
    term.clear()

    drawTitle()

    text = "Touch anywhere to cancel"
    term.setCursorPos(width / 2 - #text / 2, height)
    term.setTextColor(colors.gray)
    write(text)
    term.setTextColor(colors.white)

    local ready = { p1 = false, p2 = false }

    while true do
        local event = os.pullEvent()
        if event == "monitor_touch" then
            break
        elseif event == "redstone" then
            local signal = redstone.getBundledInput(inputSide)
            if colors.test(signal, inputCoding.p1Down) or colors.test(signal, inputCoding.p1Up) then
                ready.p1 = not ready.p1
            end
            if colors.test(signal, inputCoding.p2Down) or colors.test(signal, inputCoding.p2Up) then
                ready.p2 = not ready.p2
            end
        end
        drawReadyState(ready.p1, ready.p2)
        if ready.p1 and ready.p2 then
            sleep(1)
            return
        end
    end

    drawMenu()
end

local function resetBall(direction)
    local yVel = math.random() * 2 - 1
    ballPos = { x = math.floor(width / 2), y = math.floor(height / 2) }
    ballVec = { x = ballSpeed.x * direction, y = ballSpeed.y * yVel }
end

local function resetGame()
    p1BasePos = math.floor(height / 2 - baseWidth / 2)
    p2BasePos = math.floor(height / 2 - baseWidth / 2)
    score = { p1 = 0, p2 = 0 }
end

local function getRandomDeflection()
    return (math.random() - 0.5) / 5
end

local function drawBase()
    term.setBackgroundColor(baseColor)
    local x, y = term.getCursorPos()
    for i = 1, baseWidth do
        write(" ")
        term.setCursorPos(x, y + i)
    end
end

local function draw()
    term.setBackgroundColor(colors.black)
    term.setCursorPos(1, 1)
    term.clear()

    local scoreText = score.p1 .. " : " .. score.p2
    term.setCursorPos(width / 2 - #scoreText / 2, 1)
    term.setTextColor(colors.lightGray)
    write(scoreText)
    term.setTextColor(colors.white)

    term.setCursorPos(1, p1BasePos)
    drawBase()

    term.setCursorPos(width, p2BasePos)
    drawBase()

    local newPos = addVec(ballPos, ballVec)
    if newPos.y < 1 or newPos.y > height + 1 then
        ballVec.y = -ballVec.y + getRandomDeflection()
    end
    if newPos.x < 2 then
        if newPos.y > p1BasePos and newPos.y < p1BasePos + baseWidth then
            ballVec.x = -ballVec.x
        else
            score.p2 = score.p2 + 1
            resetBall(1)
        end
    elseif newPos.x > width then
        if newPos.y > p2BasePos and newPos.y < p2BasePos + baseWidth then
            ballVec.x = -ballVec.x + getRandomDeflection()
        else
            score.p1 = score.p1 + 1
            resetBall(-1)
        end
    end

    if score.p1 == winmax then
        return 1
    elseif score.p2 == winmax then
        return 2
    end

    ballPos = addVec(ballPos, ballVec)

    term.setCursorPos(ballPos.x, ballPos.y)
    term.setBackgroundColor(ballColor)
    write(" ")

    return 0
end

local function drawLoop()
    local winner = 0
    while winner == 0 do
        winner = draw()
        sleep(1 / frameRate)
    end

    term.setBackgroundColor(colors.black)
    term.clear()

    local text = "Yay, player " .. winner .. " has won!"
    term.setCursorPos(width / 2 - #text / 2, height / 2)
    write(text)
    sleep(3)
end

local function controlLoop()
    while true do
        local signal = redstone.getBundledInput(inputSide)
        if signal == 0 then
            goto continue
        end

        if colors.test(signal, inputCoding.p1Down) then
            p1BasePos = p1BasePos + baseSpeed
        end
        if colors.test(signal, inputCoding.p1Up) then
            p1BasePos = p1BasePos - baseSpeed
        end
        if colors.test(signal, inputCoding.p2Down) then
            p2BasePos = p2BasePos + baseSpeed
        end
        if colors.test(signal, inputCoding.p2Up) then
            p2BasePos = p2BasePos - baseSpeed
        end

        if p1BasePos < 1 then
            p1BasePos = 1
        end
        if p2BasePos < 1 then
            p2BasePos = 1
        end
        if p1BasePos > height - baseWidth + 1 then
            p1BasePos = height - baseWidth + 1
        end
        if p2BasePos > height - baseWidth + 1 then
            p2BasePos = height - baseWidth + 1
        end

        ::continue::
        sleep(1 / inputRate)
    end
end

-----------------------------------------------------------------------

while true do
    term.setBackgroundColor(colors.black)
    term.clear()

    drawMenu()

    resetGame()
    resetBall(1)

    parallel.waitForAny(
        drawLoop,
        controlLoop
    )
end
