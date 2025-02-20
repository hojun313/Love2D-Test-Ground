local game1 = require("game1")
local game2 = require("game2")
local game3 = require("game3")
local game4 = require("game4")
local game5 = require("game5")
local game6 = require("game6")
local game7 = require("game7")
local game8 = require("game8")
local game9 = require("game9") -- 새로운 게임 추가

local font
local state = "menu" -- 현재 상태를 저장하는 변수 ("menu", "game1", "game2", "game3", "game4", "game5", "game6", "game7", "game8", "game9", "paused")
local pauseButton = {x = love.graphics.getWidth() - 110, y = 10, width = 100, height = 40}
local previousState

local gamelists = {"타겟", "닷지", "캔", "카드", "퍼즐", "슈팅", "스키", "우주 탐험가", "카드 이동"} -- 새로운 게임 추가

function love.load()
    font = love.graphics.newFont("assets/fonts/Jua-Regular.ttf", 32) -- 한글을 지원하는 폰트 로드
    game1.load()
    game2.load()
    game3.load()
    game4.load()
    game5.load()
    game6.load()
    game7.load()
    game8.load()
    game9.load() -- 새로운 게임 로드
end

function love.update(dt)
    if state == "game1" then
        game1.update(dt)
    elseif state == "game2" then
        game2.update(dt)
    elseif state == "game3" then
        game3.update(dt)
    elseif state == "game4" then
        game4.update(dt)
    elseif state == "game5" then
        game5.update(dt)
    elseif state == "game6" then
        game6.update(dt)
    elseif state == "game7" then
        game7.update(dt)
    elseif state == "game8" then
        game8.update(dt)
    elseif state == "game9" then
        game9.update(dt) -- 새로운 게임 업데이트
    end
end

function resetGame()
    game1.reset()
    game2.reset()
    game3.reset()
    game4.reset()
    game5.reset()
    game6.reset()
    game7.reset()
    game8.reset()
    game9.reset() -- 새로운 게임 리셋
end

function love.draw()
    if state == "menu" then
        drawMenu()
    elseif state == "game1" then
        game1.draw()
    elseif state == "game2" then
        game2.draw()
    elseif state == "game3" then
        game3.draw()
    elseif state == "game4" then
        game4.draw()
    elseif state == "game5" then
        game5.draw()
    elseif state == "game6" then
        game6.draw()
    elseif state == "game7" then
        game7.draw()
    elseif state == "game8" then
        game8.draw()
    elseif state == "game9" then
        game9.draw() -- 새로운 게임 그리기
    elseif state == "paused" then
        if previousState == "game1" then
            game1.draw()
        elseif previousState == "game2" then
            game2.draw()
        elseif previousState == "game3" then
            game3.draw()
        elseif previousState == "game4" then
            game4.draw()
        elseif previousState == "game5" then
            game5.draw()
        elseif previousState == "game6" then
            game6.draw()
        elseif previousState == "game7" then
            game7.draw()
        elseif previousState == "game8" then
            game8.draw()
        elseif previousState == "game9" then
            game9.draw() -- 새로운 게임 그리기
        end
        drawPauseMenu()
    end
    if state ~= "menu" then
        drawPauseButton()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if state == "game1" then
        game1.mousepressed(x, y, button)
    elseif state == "game2" then
        game2.mousepressed(x, y, button)
    elseif state == "game3" then
        game3.mousepressed(x, y, button)
    elseif state == "game4" then
        game4.mousepressed(x, y, button)
    elseif state == "game5" then
        game5.mousepressed(x, y, button)
    elseif state == "game6" then
        game6.mousepressed(x, y, button)
    elseif state == "game7" then
        game7.mousepressed(x, y, button)
    elseif state == "game8" then
        game8.mousepressed(x, y, button)
    elseif state == "game9" then
        game9.mousepressed(x, y, button) -- 새로운 게임 마우스 입력 처리
    elseif state == "menu" then
        mousepressedMenu(x, y, button)
    elseif state == "paused" then
        mousepressedPauseMenu(x, y, button)
    end

    if state ~= "menu" then
        if button == 1 and x > pauseButton.x and x < pauseButton.x + pauseButton.width and y > pauseButton.y and y < pauseButton.y + pauseButton.height then
            previousState = state
            state = "paused"
        end
    end
end

function love.keypressed(key)
    if state == "game8" then
        game8.keypressed(key)
    elseif state == "game9" then
        game9.keypressed(key) -- 새로운 게임 키 입력 처리
    end
end

function mousepressedMenu(x, y, button)
    if button == 1 then -- Left mouse button
        for i = 1, 10 do
            if x > love.graphics.getWidth() / 2 - 100 and x < love.graphics.getWidth() / 2 + 100 and y > 100 + i * 50 and y < 140 + i * 50 then
                if i == 1 then
                    state = "game1"
                elseif i == 2 then
                    state = "game2"
                elseif i == 3 then
                    state = "game3"
                elseif i == 4 then
                    state = "game4"
                elseif i == 5 then
                    state = "game5"
                elseif i == 6 then
                    state = "game6"
                elseif i == 7 then
                    state = "game7"
                elseif i == 8 then
                    state = "game8"
                elseif i == 9 then
                    state = "game9" -- 새로운 게임 선택
                end
            end
        end
    end
end

function mousepressedPauseMenu(x, y, button)
    if button == 1 then -- Left mouse button
        if x > love.graphics.getWidth() / 2 - 100 and x < love.graphics.getWidth() / 2 + 100 and y > love.graphics.getHeight() / 2 and y < love.graphics.getHeight() / 2 + 40 then
            state = previousState
        elseif x > love.graphics.getWidth() / 2 - 100 and x < love.graphics.getWidth() / 2 + 100 and y > love.graphics.getHeight() / 2 + 50 and y < love.graphics.getHeight() / 2 + 90 then
            state = "menu"
            resetGame()
        end
    end
end

function drawMenu()
    love.graphics.setFont(font)
    love.graphics.print("게임을 선택하세요!", love.graphics.getWidth() / 2 - 50, 50)
    for i = 1, #gamelists do
        love.graphics.rectangle("line", love.graphics.getWidth() / 2 - 100, 100 + i * 50, 200, 40)
        love.graphics.print(gamelists[i], love.graphics.getWidth() / 2 - 50, 105 + i * 50)
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