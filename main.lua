local game1 = require("game1")
local game2 = require("game2")

local font
local state = "menu" -- 현재 상태를 저장하는 변수 ("menu", "game1", "game2", "paused")
local pauseButton = {x = love.graphics.getWidth() - 110, y = 10, width = 100, height = 40}
local previousState

function love.load()
    font = love.graphics.newFont("essets/fonts/Jua-Regular.ttf", 32) -- 한글을 지원하는 폰트 로드
    game1.load()
    game2.load()
end

function love.update(dt)
    if state == "game1" then
        game1.update(dt)
    elseif state == "game2" then
        game2.update(dt)
    end
end

function resetGame()
    game1.reset()
    game2.reset()
end

function love.draw()
    if state == "menu" then
        drawMenu()
    elseif state == "game1" then
        game1.draw()
    elseif state == "game2" then
        game2.draw()
    elseif state == "paused" then
        drawPauseMenu()
        if previousState == "game1" then
            game1.draw()
        elseif previousState == "game2" then
            game2.draw()
        end
    end
    if state ~= "menu" then
        drawPauseButton()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if state == "menu" then
        if button == 1 then -- Left mouse button
            for i = 1, 10 do
                if x > love.graphics.getWidth() / 2 - 100 and x < love.graphics.getWidth() / 2 + 100 and y > 100 + i * 50 and y < 140 + i * 50 then
                    if i == 1 then
                        resetGame()
                        state = "game1"
                    elseif i == 2 then
                        resetGame()
                        state = "game2"
                    end
                end
            end
        end
    elseif state == "game1" then
        game1.mousepressed(x, y, button)
        if button == 1 and x > pauseButton.x and x < pauseButton.x + pauseButton.width and y > pauseButton.y and y < pauseButton.y + pauseButton.height then
            previousState = state
            state = "paused"
        end
    elseif state == "game2" then
        game2.mousepressed(x, y, button)
        if button == 1 and x > pauseButton.x and x < pauseButton.x + pauseButton.width and y > pauseButton.y and y < pauseButton.y + pauseButton.height then
            previousState = state
            state = "paused"
        end
    elseif state == "paused" then
        if button == 1 then -- Left mouse button
            if x > love.graphics.getWidth() / 2 - 100 and x < love.graphics.getWidth() / 2 + 100 and y > love.graphics.getHeight() / 2 and y < love.graphics.getHeight() / 2 + 40 then
                state = previousState
            elseif x > love.graphics.getWidth() / 2 - 100 and x < love.graphics.getWidth() / 2 + 100 and y > love.graphics.getHeight() / 2 + 50 and y < love.graphics.getHeight() / 2 + 90 then
                state = "menu"
                resetGame()
            end
        end
    end
end

function drawMenu()
    love.graphics.setFont(font)
    love.graphics.print("메뉴", love.graphics.getWidth() / 2 - 50, 50)
    for i = 1, 10 do
        love.graphics.rectangle("line", love.graphics.getWidth() / 2 - 100, 100 + i * 50, 200, 40)
        love.graphics.print("게임 " .. i, love.graphics.getWidth() / 2 - 50, 100 + i * 50)
    end
end

function drawPauseButton()
    love.graphics.setFont(font)
    love.graphics.rectangle("line", pauseButton.x, pauseButton.y, pauseButton.width, pauseButton.height)
    love.graphics.print("일시정지", pauseButton.x + 10, pauseButton.y + 5)
end

function drawPauseMenu()
    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("게임 일시정지", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 100)
    love.graphics.rectangle("line", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2, 200, 40)
    love.graphics.print("게임 재개", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 + 5)
    love.graphics.rectangle("line", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 + 50, 200, 40)
    love.graphics.print("메인 메뉴로", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 + 55)
end