local game5 = {}

local puzzle = {}
local emptyTile = {x = 4, y = 4}
local puzzleSize = 4
local tileSize = 100
local score = 0
local timer = 0

function game5.load()
    game5.reset()
end

function shufflePuzzle()
    for i = 1, 1000 do
        local direction = math.random(4)
        if direction == 1 and emptyTile.x > 1 then
            puzzle[emptyTile.y][emptyTile.x] = puzzle[emptyTile.y][emptyTile.x - 1]
            puzzle[emptyTile.y][emptyTile.x - 1] = 0
            emptyTile.x = emptyTile.x - 1
        elseif direction == 2 and emptyTile.x < puzzleSize then
            puzzle[emptyTile.y][emptyTile.x] = puzzle[emptyTile.y][emptyTile.x + 1]
            puzzle[emptyTile.y][emptyTile.x + 1] = 0
            emptyTile.x = emptyTile.x + 1
        elseif direction == 3 and emptyTile.y > 1 then
            puzzle[emptyTile.y][emptyTile.x] = puzzle[emptyTile.y - 1][emptyTile.x]
            puzzle[emptyTile.y - 1][emptyTile.x] = 0
            emptyTile.y = emptyTile.y - 1
        elseif direction == 4 and emptyTile.y < puzzleSize then
            puzzle[emptyTile.y][emptyTile.x] = puzzle[emptyTile.y + 1][emptyTile.x]
            puzzle[emptyTile.y + 1][emptyTile.x] = 0
            emptyTile.y = emptyTile.y + 1
        end
    end
end

function game5.update(dt)
    if checkPuzzleComplete() then
        timer = timer + dt
        if timer >= 1 then
            score = score + 100
            game5.reset()
            timer = 0
        end
    end
end

function game5.draw()
    for i = 1, puzzleSize do
        for j = 1, puzzleSize do
            if puzzle[i][j] ~= 0 then
                love.graphics.rectangle("line", (j - 1) * tileSize, (i - 1) * tileSize, tileSize, tileSize)
                love.graphics.print(puzzle[i][j], (j - 1) * tileSize + 40, (i - 1) * tileSize + 40)
            end
        end
    end
    love.graphics.print("Score: " .. score, 10, 10)
end

function game5.reset()
    for i = 1, puzzleSize do
        puzzle[i] = {}
        for j = 1, puzzleSize do
            puzzle[i][j] = (i - 1) * puzzleSize + j
        end
    end
    puzzle[puzzleSize][puzzleSize] = 0 -- 빈 타일
    emptyTile = {x = puzzleSize, y = puzzleSize}
    shufflePuzzle()
end

function game5.mousepressed(x, y, button)
    if button == 1 then
        local tileX = math.floor(x / tileSize) + 1
        local tileY = math.floor(y / tileSize) + 1
        if tileX > 0 and tileX <= puzzleSize and tileY > 0 and tileY <= puzzleSize then
            if (math.abs(tileX - emptyTile.x) == 1 and tileY == emptyTile.y) or (math.abs(tileY - emptyTile.y) == 1 and tileX == emptyTile.x) then
                puzzle[emptyTile.y][emptyTile.x] = puzzle[tileY][tileX]
                puzzle[tileY][tileX] = 0
                emptyTile.x = tileX
                emptyTile.y = tileY
            end
        end
    end
end

function checkPuzzleComplete()
    for i = 1, puzzleSize do
        for j = 1, puzzleSize do
            if not (i == puzzleSize and j == puzzleSize) and puzzle[i][j] ~= (i - 1) * puzzleSize + j then
                return false
            end
        end
    end
    return true
end

return game5