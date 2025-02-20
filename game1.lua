local game1 = {}
local score = 0
local target = {x = 0, y = 0, radius = 50}
local targetImage
local quad
local font

function game1.load()
    targetImage = love.graphics.newImage("assets/images/원형 타겟 이미지.png") -- 타겟 이미지 로드
    font = love.graphics.newFont("assets/fonts/Jua-Regular.ttf", 32) -- 한글을 지원하는 폰트 로드

    -- 이미지의 일부를 잘라서 사용하기 위해 Quad 객체 생성
    local imageWidth = targetImage:getWidth()
    local imageHeight = targetImage:getHeight()
    quad = love.graphics.newQuad(imageWidth * 5 / 32, imageHeight * 5 / 32, imageWidth * 22 / 32, imageHeight * 22 / 32, imageWidth, imageHeight) -- 이미지의 왼쪽 상단 1/4 부분을 사용
    game1.reset()
end

function game1.reset()
    score = 0
    target.x = love.graphics.getWidth() / 2
    target.y = love.graphics.getHeight() / 2
    target.radius = 50
end

function game1.update(dt)
    -- do nothing
end

function game1.draw()
    love.graphics.setFont(font)
    love.graphics.print("Score: " .. score, 10, 10)

    -- 타겟 그리기
    local scaleX = (target.radius * 2) / (targetImage:getWidth() * 22 / 32)
    local scaleY = (target.radius * 2) / (targetImage:getHeight() * 22 / 32)
    love.graphics.draw(targetImage, quad, target.x - target.radius, target.y - target.radius, 0, scaleX, scaleY) -- 타겟 이미지의 일부 그리기
end

function game1.mousepressed(x, y, button)
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

return game1