ROWS = 15
COLS = 15

-- @table string[][]
Grid = {}

Neighbors = {
    { -1, -1 },
    { -1, 0 },
    { -1, 1 },
    { 1, -1 },
    { 1, 0 },
    { 1, 1 },
    { 0, -1 },
    { 0, 1 },
}

local function printNeighbors(n)
    for _, v in pairs(n) do
        for _, vv in pairs(v) do
            io.write(vv, ",")
        end

        io.write(" | ")
    end

    print()
end

local function initGrid(grid)
    for i = 1, ROWS do
        grid[i] = {}

        for j = 1, COLS do
            grid[i][j] = '0'
        end
    end
end

local function getNeighbors(row, col)
    local n = {}

    for _, v in pairs(Neighbors) do
        if row + v[1] > 0 and col + v[2] > 0 and row + v[1] <= ROWS and col + v[2] < COLS then
            table.insert(n, { row + v[1], col + v[2] })
        end
    end

    return n
end

local function printGrid()
    for i = 1, ROWS do
        for j = 1, COLS do
            io.write(Grid[i][j], " ")
        end

        print("")
    end
end

-- Any live cell with fewer than two live neighbors dies, as if by underpopulation.
-- Any live cell with two or three live neighbors lives on to the next generation.
-- Any live cell with more than three live neighbors dies, as if by overpopulation.
-- Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.
local function nextState()
    local newGrid = {}

    initGrid(newGrid)

    for row = 1, ROWS do
        for col = 1, COLS do
            local neighbors = getNeighbors(row, col)

            local count = 0

            for _, v in pairs(neighbors) do
                if Grid[v[1]][v[2]] == '1' then count = count + 1 end
            end

            newGrid[row][col] = Grid[row][col]

            if count < 2 then newGrid[row][col] = '0' end
            if count > 3 then newGrid[row][col] = '0' end
            if count == 3 and Grid[row][col] == '0' then newGrid[row][col] = '1' end
        end
    end

    Grid = newGrid
end

--- @param grid string[][]
--- @return string[]
local function concatGrid(grid)
    local str = {  }

    for row = 1, ROWS do
        for col = 1, COLS do
            table.insert(str, grid[row][col])
            table.insert(str, " ")
        end

        table.insert(str, "<CR>")
    end

    return str
end

local function createWindow()
    local dims = {
        width = 80,
        height = 24,
        row = 0,
        col = 0,
    }

    local config = {
        relative = "editor",
        anchor = "NW",
        row = dims.row,
        col = dims.col,
        width = dims.width,
        height = dims.height,
        border = "none",
        title = "lmao",
        style = "minimal",
    }

    local buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buffer, false, config)

    return buffer
end

--- @param bufferId integer
local function writeTextToBuffer(bufferId)
    -- Parameters: ~
    --   • {buffer}           Buffer handle, or 0 for current buffer
    --   • {start}            First line index
    --   • {end}              Last line index, exclusive
    --   • {strict_indexing}  Whether out-of-bounds should be an error.
    --   • {replacement}      Array of lines to use as replacement

    local last = 0

    for i, row in pairs(Grid) do
        last = i

        local str = ""

        for _, thing in pairs(row) do
            if thing == "1" then
                str = str .. "X" .. "  "
            else
                str = str .. " " .. "  "
            end
        end

        vim.api.nvim_buf_set_lines(bufferId, i, i + 1, false, { str })
    end

    vim.api.nvim_buf_set_lines(bufferId, last + 1, last + 1, false, { "" })
end

function Start()
    initGrid(Grid)
    local buffer = createWindow()

    -- X
    --   X X
    -- X X
    Grid[1][1] = "1"
    Grid[2][2] = "1"
    Grid[2][3] = "1"
    Grid[3][1] = "1"
    Grid[3][2] = "1"

    for _ = 1,50 do
        writeTextToBuffer(buffer)
        vim.cmd("redraw")
        vim.wait(100)
        nextState()
    end
end

Start()
