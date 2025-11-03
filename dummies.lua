
-- Conway's Game Of Life
-- Recreation by Baton0

// Player

// How many ticks between updates
ticks_per_update = 0
tick = 0

// How big each square is, in pixels.
size = 128 / 32
grid_size = (128/size)-1

// Whether the simulation is paused or not
paused = true

// inputs as variables to remind self
left = 0 right = 1 up = 2 down = 3
o = 4 x = 5

grid = {
    data={},

    init=function(this)

        for i=0,grid_size do
            row = {}
            
            switch = false
            for j=0,grid_size do
                row[j] = 0
            end

            this.data[i] = row
        end
    end,

    get_neighbors=function(this, x, y)
        neighbors = 0

        for i=-1,1 do
            for j=-1,1 do
                if not (i == 0 and j == 0) then
                    xi = x+i
                    yj = y+j

                    if xi < 0 then
                        xi = grid_size
                    end

                    if yj < 0 then
                        yj = grid_size
                    end

                    if xi > grid_size then
                        xi = 0
                    end

                    if yj > grid_size then
                        yj = 0
                    end

                    if this.data[xi][yj] == 1 then
                        neighbors = neighbors + 1
                    end
                end
            end
        end

        return neighbors
    end,

    should_live=function(current, neighbors)
        return (neighbors == 3 or (current == 1 and neighbors == 2))
    end,

    update=function(this)
        next={}

        for i=0,grid_size do
            row = {}
            for j=0,grid_size do
                neighbors = this.get_neighbors(this, i, j)

                if this.should_live(this.data[i][j], neighbors) then
                    row[j] = 1
                else
                    row[j] = 0
                end
            end
            next[i] = row
        end

        this.data = next
    end,

    draw=function(this, colorA, colorB)
        for i=0,grid_size do
            for j=0,grid_size do

                tx = i * size ty = j * size
                bx = (i+1)*size-1 by =(j+1)*size-1

                if this.data[i][j] == 0 then
                    rectfill(tx, ty, bx, by, colorA)
                else
                    rectfill(tx, ty, bx, by, colorB)
                end
            end
        end
    end
}

cursor = {
    init=function(this)
        this.x = flr(grid_size / 2)
        this.y = flr(grid_size / 2)
    end,

    control=function(this)
        nx = this.x
        ny = this.y

        if btnp(left, 0) then nx = nx - 1 end
        if btnp(right, 0) then nx = nx + 1 end
        if btnp(up, 0) then ny = ny - 1 end
        if btnp(down, 0) then ny = ny + 1 end

        if nx < 0 then
            nx = grid_size
        end

        if ny < 0 then
            ny = grid_size
        end

        if nx > grid_size then
            nx = 0
        end

        if ny > grid_size then
            ny = 0
        end

        this.x = nx
        this.y = ny
    end,

    write=function(this, grid)
        if btnp(x,0 ) then
            px = this.x
            py = this.y 
            
            alive = grid.data[px][py]
            if alive == 1 then
                alive = 0
                sfx(5)
            else
                alive = 1
                sfx(4)
            end
            
            grid.data[px][py] = alive
        end
    end,

    update=function(this, grid)
        this.control(this)
        this.write(this, grid)
    end,

    draw=function(this, grid)
        tx = this.x * size ty = this.y * size
        bx = (this.x+1)*size-1 by =(this.y+1)*size-1

        if grid.data[this.x][this.y] == 1 then
            color = 10
        else
            color = 9
        end

        rectfill(tx, ty, bx, by, color)
    end
}

function _init()
	grid:init()
    cursor:init()
    music(0)
end

function _update()

    // Pausing
    if btnp(o,0) then
        paused = not paused
    end

    // Ticks & Updating
    if not paused then 
        tick = tick + 1
        if tick >= ticks_per_update then
            grid:update()
            tick = 0
        end
    end

    // Cursor
    cursor:update(grid)

	cls(1)
    grid:draw(0,7)
    cursor:draw(grid)

    if paused then
        print("paused (c)", 5, 5, 10)
    end
end