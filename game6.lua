local game6 = {}

local player = {x = 400, y = 300, speed = 200}
local bullets = {}
local enemies = {}
local score = 0
local spawnTimer = 0

function game6.load()
    game6.reset()
end

function game6.update(dt)
    -- 플레이어 이동
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
        if player.x < 0 then
            player.x = 0
        end
    elseif love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
        if player.x > love.graphics.getWidth() - 20 then
            player.x = love.graphics.getWidth() - 20
        end
    end
    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed * dt
        if player.y < 0 then
            player.y = 0
        end
    elseif love.keyboard.isDown("down") then
        player.y = player.y + player.speed * dt
        if player.y > love.graphics.getHeight() - 20 then
            player.y = love.graphics.getHeight() - 20
        end
    end

    -- 총알 업데이트
    for i, bullet in ipairs(bullets) do
        bullet.y = bullet.y - bullet.speed * dt
        if bullet.y < 0 then
            table.remove(bullets, i)
        end
    end

    -- 적 생성
    spawnTimer = spawnTimer + dt
    if spawnTimer > 0.1 then
        table.insert(enemies, {x = math.random(0, love.graphics.getWidth() - 20), y = -10, speed = 100})
        spawnTimer = 0
    end

    -- 적 이동
    for i, enemy in ipairs(enemies) do
        enemy.y = enemy.y + enemy.speed * dt
        if enemy.y > love.graphics.getHeight() then
            table.remove(enemies, i)
        end
    end

    -- 충돌 검사
    for i, bullet in ipairs(bullets) do
        for j, enemy in ipairs(enemies) do
            if checkCollision(bullet, enemy) then
                table.remove(bullets, i)
                table.remove(enemies, j)
                score = score + 10
                break
            end
        end
    end

    -- 적과 플레이어 충돌 검사
    for i, enemy in ipairs(enemies) do
        if checkCollision(player, enemy) then
            game6.reset() -- 충돌 시 게임 재시작
            break
        end
    end
end

function game6.draw()
    love.graphics.rectangle("fill", player.x, player.y, 20, 20)
    for _, bullet in ipairs(bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, 5, 10)
    end
    for _, enemy in ipairs(enemies) do
        love.graphics.rectangle("fill", enemy.x, enemy.y, 20, 20)
    end
    love.graphics.print("Score: " .. score, 10, 10)
end

function game6.reset()
    player.x = 400
    player.y = 300
    bullets = {}
    enemies = {}
    score = 0
    spawnTimer = 0
end

function game6.mousepressed(x, y, button)
    -- do nothing
end

function love.keypressed(key)
    if key == "space" then
        table.insert(bullets, {x = player.x + 7.5, y = player.y, speed = 300})
    end
end

function checkCollision(a, b)
    return a.x < b.x + 20 and
           b.x < a.x + 20 and
           a.y < b.y + 20 and
           b.y < a.y + 20
end

return game6