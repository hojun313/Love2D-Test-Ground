local game8 = {}

local sequence = {}
local playerInput = {}
local currentStep = 1
local gameState = "start"
local timer = 0
local showTime = 1
local inputTime = 5

function game8.load()
    love.graphics.setFont(love.graphics.newFont(30))
    math.randomseed(os.time())
end

function game8.update(dt)
    if gameState == "show" then
        timer = timer + dt
        if timer > showTime then
            gameState = "input"
            timer = 0
        end
    elseif gameState == "input" then
        timer = timer + dt
        if timer > inputTime then
            gameState = "fail"
        end
    end
end

function game8.draw()
    if gameState == "start" then
        love.graphics.printf("Press Space to Start", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    elseif gameState == "show" then
        love.graphics.printf(table.concat(sequence, " "), 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    elseif gameState == "input" then
        love.graphics.printf("Enter the sequence: " .. table.concat(playerInput, " "), 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    elseif gameState == "fail" then
        love.graphics.printf("Game Over! Press Space to Restart", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end

    love.graphics.print("Current Step: " .. currentStep, 10, 10)
    love.graphics.print("Timer: " .. math.floor(6 - timer), 10, 50)
end

function game8.mousepressed(x, y, button)
    if gameState == "start" and button == 1 then
        startGame()
    elseif gameState == "fail" and button == 1 then
        resetGame()
    end
end

function game8.reset()
    gameState = "start"
end

function game8.keypressed(key)
    if gameState == "start" and key == "space" then
        startGame()
    elseif gameState == "input" then
        if (key >= "0" and key <= "9") or (key >= "kp0" and key <= "kp9") then
            table.insert(playerInput, key:match("%d"))
            if #playerInput == #sequence then
                checkSequence()
            end
        end
    elseif gameState == "fail" and key == "space" then
        resetGame()
    end
end

function startGame()
    sequence = {tostring(math.random(0, 9))}
    playerInput = {}
    currentStep = 1
    gameState = "show"
    timer = 0
end

function checkSequence()
    for i = 1, #sequence do
        if sequence[i] ~= playerInput[i] then
            gameState = "fail"
            return
        end
    end
    table.insert(sequence, tostring(math.random(0, 9)))
    playerInput = {}
    gameState = "show"
    timer = 0
    currentStep = currentStep + 1
end

function resetGame()
    gameState = "start"
end

return game8