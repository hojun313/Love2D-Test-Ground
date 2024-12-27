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

function game4.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    cardBackImage = love.graphics.newImage("assets/images/card_back1.png")
    for i = 1, 9 do
        cardImages[i] = love.graphics.newImage("assets/images/card_H" .. i .. ".png")
    end
    resetCards()
end

function resetCards()
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
end

function game4.update(dt)
    if #selectedCards == 2 then
        if selectedCards[1].image == selectedCards[2].image then
            selectedCards[1].matched = true
            selectedCards[2].matched = true
        end
        selectedCards = {}
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
    if button == 1 then
        for i, card in ipairs(cards) do
            local cardX = (i - 1) % 6 * (cardWidth + cardSpacing) + 50
            local cardY = math.floor((i - 1) / 6) * (cardHeight + cardSpacing) + 50
            if x > cardX and x < cardX + cardWidth and y > cardY and y < cardY + cardHeight then
                if not card.matched and #selectedCards < 2 and not (selectedCards[1] == card) then
                    table.insert(selectedCards, card)
                end
            end
        end
    end
end

function game4.reset()
    resetCards()
end

return game4
