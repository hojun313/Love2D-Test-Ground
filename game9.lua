local game9 = {}

local playerCards = {}  -- 하단의 5개의 카드
local boardCards = {}   -- 상단의 5개의 카드
local currentPlayerTurn = true
local turnEndButton = {x = 300, y = 400, width = 100, height = 50}
local turnEndTime = 0
local selectedCard = nil

-- 초기화 함수
function game9.load()
    for i = 1, 5 do
        table.insert(playerCards, {x = 50 * i, y = 500, width = 40, height = 60})
        table.insert(boardCards, {x = 50 * i, y = 100, width = 40, height = 60, card = nil})
    end
end

function game9.reset()
    playerCards = {}
    boardCards = {}
    currentPlayerTurn = true
    turnEndTime = 0
    selectedCard = nil
    game9.load()
end

-- 카드 클릭 이벤트 처리 함수
function game9.mousepressed(x, y, button, istouch, presses)
    if button == 1 and currentPlayerTurn then
        if not selectedCard then
            for i, card in ipairs(playerCards) do
                if x > card.x and x < card.x + card.width and y > card.y and y < card.y + card.height then
                    selectedCard = card
                    table.remove(playerCards, i)
                    break
                end
            end
        else
            for j, boardCard in ipairs(boardCards) do
                if x > boardCard.x and x < boardCard.x + boardCard.width and y > boardCard.y and y < boardCard.y + boardCard.height then
                    if boardCard.card then
                        table.insert(playerCards, boardCard.card)
                    end
                    boardCard.card = selectedCard
                    selectedCard = nil
                    break
                end
            end
        end
    end

    if button == 1 and x > turnEndButton.x and x < turnEndButton.x + turnEndButton.width and y > turnEndButton.y and y < turnEndButton.y + turnEndButton.height then
        currentPlayerTurn = false
        turnEndTime = love.timer.getTime()
    end
end

-- 턴 관리 로직
function game9.update(dt)
    if not currentPlayerTurn and love.timer.getTime() - turnEndTime > 3 then
        currentPlayerTurn = true
    end
end

-- 그리기 함수
function game9.draw()
    for _, card in ipairs(playerCards) do
        love.graphics.rectangle("line", card.x, card.y, card.width, card.height)
    end

    for _, boardCard in ipairs(boardCards) do
        love.graphics.rectangle("line", boardCard.x, boardCard.y, boardCard.width, boardCard.height)
        if boardCard.card then
            love.graphics.rectangle("fill", boardCard.x, boardCard.y, boardCard.width, boardCard.height)
        end
    end

    if selectedCard then
        love.graphics.rectangle("line", selectedCard.x, selectedCard.y, selectedCard.width, selectedCard.height)
    end

    love.graphics.rectangle("line", turnEndButton.x, turnEndButton.y, turnEndButton.width, turnEndButton.height)
    love.graphics.print("End Turn", turnEndButton.x + 10, turnEndButton.y + 20)
end

return game9