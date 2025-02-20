local game7 = {}

local skier = { x = love.graphics.getWidth() / 2, y = 100, speed = 200 } -- y 위치 더 위로 조정
local backgroundY = 0
local obstacles = {}
local score = 0

function game7.load()
    game7.reset()
end

function game7.update(dt)
    backgroundY = backgroundY + skier.speed * dt

    if love.keyboard.isDown("left") then
        skier.x = skier.x - skier.speed * dt
        if skier.x < 0 then
            skier.x = 0
        end
    elseif love.keyboard.isDown("right") then
        skier.x = skier.x + skier.speed * dt
        if skier.x > love.graphics.getWidth() - 20 then
            skier.x = love.graphics.getWidth() - 20
        end
    end

    for _, obstacle in ipairs(obstacles) do
        if obstacle.y > 600 then
            obstacle.y = math.random(-600, 0) -- y를 랜덤으로 설정
            obstacle.x = math.random(0, 800) -- x를 랜덤으로 설정
        end
    end

    for _, obstacle in ipairs(obstacles) do
        local obstacleY = (obstacle.y - backgroundY) % 600
        if skier.x < obstacle.x + 20 and
           skier.x + 20 > obstacle.x and
           100 < obstacleY + 20 and
           100 + 40 > obstacleY then
            game7.reset()
        end
    end

    score = score + 1
end

function game7.draw()
    -- 배경 스크롤 (하늘색)
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", 0, -backgroundY % 600, 800, 600)
    love.graphics.rectangle("fill", 0, (-backgroundY % 600) - 600, 800, 600)

    -- 스키어 그리기
    love.graphics.setColor(1, 0, 0) -- 빨간색으로 변경
    love.graphics.rectangle("fill", skier.x, 100, 20, 40) -- y 위치 더 위로 조정

    -- 장애물 그리기
    love.graphics.setColor(1, 1, 1)
    for _, obstacle in ipairs(obstacles) do
        local obstacleY = (obstacle.y - backgroundY) % 600
        love.graphics.rectangle("fill", obstacle.x, obstacleY, 20, 20)
    end

    -- 점수 표시
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. math.floor(score), 10, 10) -- 점수 표시
end

function game7.reset()
    skier = { x = love.graphics.getWidth() / 2, y = 100, speed = 200 } -- y 위치 더 위로 조정
    backgroundY = 0
    obstacles = {}
    for i = 1, 10 do
        table.insert(obstacles, { x = math.random(0, 800), y = math.random(0, 600) })
    end
    score = 0 -- 점수 초기화
end

function game7.mousepressed(x, y, button)
    -- do nothing
end

return game7