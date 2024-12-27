local game3 = {}
local font
local can = {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2, width = 50, height = 100, rotation = 0}
local score = 0
local canImage
local gravity = 100
local speedx = 0
local speedy = 0
local rotationalSpeed = 0

function game3.load()
    font = love.graphics.newFont("assets/fonts/Jua-Regular.ttf", 32) -- 한글을 지원하는 폰트 로드
    canImage = love.graphics.newImage("assets/images/canBeer.jpg")
end

function game3.reset()
    score = 0
    can.x = love.graphics.getWidth() / 2
    can.y = love.graphics.getHeight() / 4
    can.rotation = 0
    rotationalSpeed = 0
    speedx = 0
    speedy = 0
end

function game3.update(dt)
    can.rotation = can.rotation + rotationalSpeed * dt -- 캔을 회전시킴

    can.x = can.x + speedx * dt -- 캔을 좌우로 이동시킴
    if can.x < 0 then
        can.x = 0
        speedx = -speedx
    elseif can.x > love.graphics.getWidth() then
        can.x = love.graphics.getWidth()
        speedx = -speedx
    end

    speedy = speedy + gravity * dt -- 가속도를 더해 속도를 증가시킴
    can.y = can.y + speedy * dt -- 캔을 아래로 이동시킴
    if can.y > love.graphics.getHeight() then
        game3.reset()
    end
end

function game3.draw()
    love.graphics.setFont(font)
    love.graphics.print("Score: " .. score, 10, 10)

    -- 캔 이미지 그리기
    local scaleX = can.width / canImage:getWidth()
    local scaleY = can.height / canImage:getHeight()
    love.graphics.draw(canImage, can.x, can.y, can.rotation, scaleX, scaleY, canImage:getWidth() / 2, canImage:getHeight() / 2)
end

function game3.mousepressed(x, y, button)
    if button == 1 then -- Left mouse button
        -- 회전된 캔의 좌표 변환
        local cosR = math.cos(-can.rotation)
        local sinR = math.sin(-can.rotation)
        local dx = x - can.x
        local dy = y - can.y
        local rotatedX = cosR * dx - sinR * dy
        local rotatedY = sinR * dx + cosR * dy

        -- 캔의 경계 내에 있는지 확인
        if math.abs(rotatedX) <= can.width / 2 and math.abs(rotatedY) <= can.height / 2 then
            score = score + 1
            rotationalSpeed = math.random() * 10 - 5 -- -5에서 5 사이의 랜덤한 회전 속도
            speedx = math.random() * 500 - 250 -- -100에서 100 사이의 랜덤한 좌우 속도
            speedy = -200 -- 위로 튕기는 힘
        end
    end
end

return game3