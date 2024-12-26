local target = {}
local score = 0
local font
local targetImage
local quad
local state = "menu" -- 현재 상태를 저장하는 변수 ("menu", "game1", "game2", "paused")
local pauseButton = {x = love.graphics.getWidth() - 110, y = 10, width = 100, height = 40}
local player = {x = 0, y = 0, speed = 200, vx = 0, vy = 0, ax = 0, ay = 0, maxSpeed = 300, acceleration = 600, friction = 400} -- game2에서 사용할 플레이어
local enemies = {} -- 적들을 저장할 테이블
local spawnTimer = 0 -- 적 스폰 타이머

function love.load()
    font = love.graphics.newFont("essets/fonts/Jua-Regular.ttf", 32) -- 한글을 지원하는 폰트 로드
    targetImage = love.graphics.newImage("essets/원형 타겟 이미지.png") -- 타겟 이미지 로드

    -- 이미지의 일부를 잘라서 사용하기 위해 Quad 객체 생성
    local imageWidth = targetImage:getWidth()
    local imageHeight = targetImage:getHeight()
    quad = love.graphics.newQuad(imageWidth * 5 / 32, imageHeight * 5 / 32, imageWidth * 22 / 32, imageHeight * 22 / 32, imageWidth, imageHeight) -- 이미지의 왼쪽 상단 1/4 부분을 사용

    resetGame()
end

function resetGame()
    score = 0
    target.x = love.graphics.getWidth() / 2
    target.y = love.graphics.getHeight() / 2
    target.radius = 50
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.vx = 0
    player.vy = 0
    player.ax = 0
    player.ay = 0
    enemies = {} -- 적들을 초기화
    spawnTimer = 0 -- 스폰 타이머 초기화
end

function love.update(dt)
    if state == "game1" then
        updateGame1(dt)
    elseif state == "game2" then
        updateGame2(dt)
    end
end

function love.draw()
    if state == "menu" then
        drawMenu()
    elseif state == "game1" then
        drawGame1()
        drawPauseButton()
    elseif state == "game2" then
        drawGame2()
        drawPauseButton()
    elseif state == "paused" then
        if previousState == "game1" then
            drawGame1()
        elseif previousState == "game2" then
            drawGame2()
        end
        drawPauseMenu()
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

function drawGame1()
    love.graphics.setColor(1, 1, 1) -- White color
    local scaleX = (target.radius * 2) / (targetImage:getWidth() * 22 / 32)
    local scaleY = (target.radius * 2) / (targetImage:getHeight() * 22 / 32)
    love.graphics.draw(targetImage, quad, target.x - target.radius, target.y - target.radius, 0, scaleX, scaleY) -- 타겟 이미지의 일부 그리기
    love.graphics.setFont(font) -- 설정한 폰트를 사용
    love.graphics.print("Score: " .. score, 10, 10)
end

function drawGame2()
    love.graphics.setColor(1, 1, 1) -- White color
    love.graphics.setFont(font) -- 설정한 폰트를 사용
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.rectangle("fill", player.x, player.y, 50, 50) -- 플레이어 그리기

    -- 적 그리기
    for _, enemy in ipairs(enemies) do
        love.graphics.rectangle("fill", enemy.x, enemy.y, 30, 30)
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

function updateGame2(dt)
    player.ax, player.ay = 0, 0

    if love.keyboard.isDown("up") then
        player.ay = player.ay - player.acceleration
    end
    if love.keyboard.isDown("down") then
        player.ay = player.ay + player.acceleration
    end
    if love.keyboard.isDown("left") then
        player.ax = player.ax - player.acceleration
    end
    if love.keyboard.isDown("right") then
        player.ax = player.ax + player.acceleration
    end

    player.vx = player.vx + player.ax * dt
    player.vy = player.vy + player.ay * dt

    -- 속도 제한
    if player.vx > player.maxSpeed then player.vx = player.maxSpeed end
    if player.vx < -player.maxSpeed then player.vx = -player.maxSpeed end
    if player.vy > player.maxSpeed then player.vy = player.maxSpeed end
    if player.vy < -player.maxSpeed then player.vy = -player.maxSpeed end

    -- 마찰력 적용
    if player.ax == 0 then
        if player.vx > 0 then
            player.vx = player.vx - player.friction * dt
            if player.vx < 0 then player.vx = 0 end
        elseif player.vx < 0 then
            player.vx = player.vx + player.friction * dt
            if player.vx > 0 then player.vx = 0 end
        end
    end

    if player.ay == 0 then
        if player.vy > 0 then
            player.vy = player.vy - player.friction * dt
            if player.vy < 0 then player.vy = 0 end
        elseif player.vy < 0 then
            player.vy = player.vy + player.friction * dt
            if player.vy > 0 then player.vy = 0 end
        end
    end

    player.x = player.x + player.vx * dt
    player.y = player.y + player.vy * dt

    -- 적 스폰 타이머 업데이트
    spawnTimer = spawnTimer + dt
    if spawnTimer >= 1 then
        spawnEnemy()
        spawnTimer = 0
    end

    -- 적 업데이트
    for _, enemy in ipairs(enemies) do
        enemy.x = enemy.x + enemy.vx * dt
        enemy.y = enemy.y + enemy.vy * dt
    end
end

function spawnEnemy()
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

function updateGame1(dt)
    -- do nothing
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
        if button == 1 then -- Left mouse button
            if x > pauseButton.x and x < pauseButton.x + pauseButton.width and y > pauseButton.y and y < pauseButton.y + pauseButton.height then
                previousState = state
                state = "paused"
            end
            local dx = target.x - x
            local dy = target.y - y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance < target.radius then
                score = score + 1
                target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
                target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
            end
        end
    elseif state == "game2" then
        if button == 1 then -- Left mouse button
            if x > pauseButton.x and x < pauseButton.x + pauseButton.width and y > pauseButton.y and y < pauseButton.y + pauseButton.height then
                previousState = state
                state = "paused"
            end
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