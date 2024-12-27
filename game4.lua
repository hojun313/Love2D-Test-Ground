-- 카드 선택 기능
-- 애니메이션 기능
-- 픽셀 이미지 그리기

local game4 = {}
local score = 0
local cards = {}
local cardImages = {}
local selectedCards = {}
local cardBackImage
local cardWidth, cardHeight = 112, 160 -- 카드 크기 증가
local cardSpacing = 10 -- 카드 간의 간격 추가
local scale = 4 -- 이미지 스케일링 비율
local showTime = 1 -- 카드 앞면을 보여주는 시간
local timer = 0 -- 타이머 변수

function game4.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    cardBackImage = love.graphics.newImage("assets/images/card_back1.png")
    for i = 1, 9 do
        cardImages[i] = love.graphics.newImage("assets/images/card_H" .. i .. ".png")
    end
    game4.reset()
end

function game4.reset()
    cards = {}
    selectedCards = {}
    local cardIndices = {}
    for i = 1, 9 do
        table.insert(cardIndices, i)
        table.insert(cardIndices, i)
    end
    for i = 1, 18 do
        local index = table.remove(cardIndices, love.math.random(#cardIndices))
        table.insert(cards, {image = cardImages[index], matched = false})
    end
    timer = 0
    love.graphics.setBackgroundColor(0.2, 0.5, 0.8)
end

function game4.update(dt)
    if #selectedCards == 2 then
        timer = timer + dt
        if timer >= showTime then
            if selectedCards[1].image == selectedCards[2].image then
                selectedCards[1].matched = true
                selectedCards[2].matched = true
            end
            selectedCards = {}
            timer = 0
        end
    end
end

function game4.draw()
    for i, card in ipairs(cards) do
        local x = (i - 1) % 6 * (cardWidth + cardSpacing) + 50
        local y = math.floor((i - 1) / 6) * (cardHeight + cardSpacing) + 50
        if card.matched or card == selectedCards[1] or card == selectedCards[2] then
            love.graphics.draw(card.image, x, y, 0, scale, scale)
        else
            love.graphics.draw(cardBackImage, x, y, 0, scale, scale)
        end
    end
end

function game4.mousepressed(x, y, button)
    if button == 1 and #selectedCards < 2 then
        for i, card in ipairs(cards) do
            local cardX = (i - 1) % 6 * (cardWidth + cardSpacing) + 50
            local cardY = math.floor((i - 1) / 6) * (cardHeight + cardSpacing) + 50
            if x > cardX and x < cardX + cardWidth and y > cardY and y < cardY + cardHeight then
                if not card.matched and not (selectedCards[1] == card) then
                    table.insert(selectedCards, card)
                end
            end
        end
    end
end

return game4
