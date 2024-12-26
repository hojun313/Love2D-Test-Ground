local game2 = {}
local score = 0
local player = {x = 0, y = 0}
local enemies = {}
local spawnTimer = 0

function game2.load()
    font = love.graphics.newFont("essets/fonts/Jua-Regular.ttf", 32) -- 한글을 지원하는 폰트 로드
    game2.reset()
end

function game2.reset()
    score = 0
    enemies = {} -- 적들을 초기화
    spawnTimer = 0 -- 스폰 타이머 초기화

    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
end

function game2.update(dt)
    if love.keyboard.isDown("left") then
        player.x = player.x - 100 * dt
    end
    if love.keyboard.isDown("right") then
        player.x = player.x + 100 * dt
    end
    if love.keyboard.isDown("up") then
        player.y = player.y - 100 * dt
    end
    if love.keyboard.isDown("down") then
        player.y = player.y + 100 * dt
    end

    spawnTimer = spawnTimer + dt
    if spawnTimer >= 2 then
        game2.spawnEnemy()
        spawnTimer = 0
    end

    -- 적 업데이트
    for _, enemy in ipairs(enemies) do
        enemy.x = enemy.x + enemy.vx * dt
        enemy.y = enemy.y + enemy.vy * dt
        if enemy.x < -30 or enemy.x > love.graphics.getWidth() + 30 or enemy.y < -30 or enemy.y > love.graphics.getHeight() + 30 then
            table.remove(enemies, _)
        end
    end

    -- 충돌 검사
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        local dx = player.x - enemy.x
        local dy = player.y - enemy.y
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance < 30 then
            game2.reset()
        end
    end

    score = score + 1
end

function game2.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(font)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("enemies: " .. #enemies, 10, 50)

    -- 플레이어 그리기
    love.graphics.circle("fill", player.x, player.y, 20)

    -- 적 그리기
    for _, enemy in ipairs(enemies) do
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", enemy.x, enemy.y, 10)
    end
end

function game2.mousepressed(x, y, button)
    -- do nothing
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