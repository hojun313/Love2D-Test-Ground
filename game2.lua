local game2 = {}
local target = {}
local score = 0
local targetImage
local quad
local enemies = {}
local spawnTimer = 0

function game2.load()
    targetImage = love.graphics.newImage("essets/원형 타겟 이미지.png") -- 타겟 이미지 로드

    -- 이미지의 일부를 잘라서 사용하기 위해 Quad 객체 생성
    local imageWidth = targetImage:getWidth()
    local imageHeight = targetImage:getHeight()
    quad = love.graphics.newQuad(imageWidth * 5 / 32, imageHeight * 5 / 32, imageWidth * 22 / 32, imageHeight * 22 / 32, imageWidth, imageHeight) -- 이미지의 왼쪽 상단 1/4 부분을 사용

    game2.reset()
end

function game2.reset()
    score = 0
    target.x = love.graphics.getWidth() / 2
    target.y = love.graphics.getHeight() / 2
    target.radius = 50
    enemies = {} -- 적들을 초기화
    spawnTimer = 0 -- 스폰 타이머 초기화
end

function game2.update(dt)
    spawnTimer = spawnTimer + dt
    if spawnTimer >= 2 then
        game2.spawnEnemy()
        spawnTimer = 0
    end

    -- 적 업데이트
    for _, enemy in ipairs(enemies) do
        enemy.x = enemy.x + enemy.vx * dt
        enemy.y = enemy.y + enemy.vy * dt
    end
end

function game2.draw()
    love.graphics.setFont(font)
    love.graphics.print("Score: " .. score, 10, 10)

    -- 타겟 그리기
    love.graphics.draw(targetImage, quad, target.x - target.radius, target.y - target.radius)

    -- 적 그리기
    for _, enemy in ipairs(enemies) do
        love.graphics.circle("fill", enemy.x, enemy.y, 20)
    end
end

function game2.mousepressed(x, y, button)
    if button == 1 then -- Left mouse button
        local dx = target.x - x
        local dy = target.y - y
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance < target.radius then
            score = score + 1
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        end
    end
end

function game2.spawnEnemy()
    local side = math.random(1, 4)
    local enemy = {x = 0, y = 0, vx = 0, vy = 0, speed = 100}

    if side == 1 then -- 상단
        enemy.x = math.random(0, love.graphics.getWidth())
        enemy.y = -30
        enemy.vy = enemy.speed
    elseif side == 2 then -- 하단
        enemy.x = math.random(0, love.graphics.getWidth())
        enemy.y = love.graphics.getHeight() + 30
        enemy.vy = -enemy.speed
    elseif side == 3 then -- 좌측
        enemy.x = -30
        enemy.y = math.random(0, love.graphics.getHeight())
        enemy.vx = enemy.speed
    elseif side == 4 then -- 우측
        enemy.x = love.graphics.getWidth() + 30
        enemy.y = math.random(0, love.graphics.getHeight())
        enemy.vx = -enemy.speed
    end

    table.insert(enemies, enemy)
end

return game2