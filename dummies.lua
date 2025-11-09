-- Puzzle Game Test
-- Baton0

settings = {
    pane_fill = 6,
    pane_outline = 0
}

function point_to_index(x, y, width)
    return x + (y * width)
end

function index_to_point(i, width)
    res = {}
    j = i - 1
    
    res.x = (j % width)
    res.y = flr(j / width)
    return res
end

// -

// Panes

// The pane to store the puzzle solution.
goal_pane = {
    grid_width = 10,
    pixel_size = 3,
    grid = {
        7,0,0,0,0,0,0,0,0,0,
        0,7,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,4,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,
        0,0,5,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,7,
    },

    x = 4, y = 4, size_x = 31, size_y = 31,

    states = {
        main = {
            _draw = function(this, pane)
                // Draw the contents of the grid to the screen.
                for i=1,#pane.grid do
                    point = index_to_point(i, pane.grid_width)

                    x = point.x
                    y = point.y

                    l = pane.x + (x * pane.pixel_size) + 1
                    t = pane.y + (y * pane.pixel_size) + 1
                    r = pane.x + (x * pane.pixel_size) + pane.pixel_size
                    b = pane.y + (y * pane.pixel_size) + pane.pixel_size
                    
                    rectfill(l, t, r, b, pane.grid[i])
                end
                

                //rectline(pane.x, pane.y, 30, 30, 0)
            end
        }
    }
}

// The pane where the player solves the puzzle.
game_pane = {
    grid_width = 10,
    pixel_size = 8,
    grid = {
        0,0,0,0,0,0,0,0,0,0,
        0,7,0,7,0,0,0,0,0,0,
        0,7,0,0,0,0,0,0,0,0,
        0,7,0,0,0,0,0,0,0,0,
        0,7,0,0,0,5,0,0,0,0,
        0,7,0,0,0,0,0,0,0,0,
        0,7,0,0,0,0,0,0,5,0,
        0,7,0,0,0,0,0,0,0,0,
        0,7,0,0,0,0,0,0,0,0,
        0,7,0,0,0,0,0,0,0,0,
    },

    x = 4, y = 40, size_x = 81, size_y = 81,

    states = {
        main = {
            _draw = function(this, pane)
                // Draw the contents of the grid to the screen.
                for i=1,#pane.grid do
                    j = i - 1

                    x = (j % pane.grid_width)
                    y = flr(j / pane.grid_width)
                    l = pane.x + (x * pane.pixel_size) + 1
                    t = pane.y + (y * pane.pixel_size) + 1
                    r = pane.x + (x * pane.pixel_size) + pane.pixel_size
                    b = pane.y + (y * pane.pixel_size) + pane.pixel_size
                    
                    rectfill(l, t, r, b, pane.grid[i])
                end
                

                //rectline(pane.x, pane.y, 30, 30, 0)
            end
        }
    },

    gravity_timer = 0,
    apply_gravity = function(this)
        this.gravity_timer += 1
        if this.gravity_timer >= 2 then 
            next_grid = {}


            for i=1,#this.grid do
                next_grid[i] = this.grid[i]
            end

            for i=1,#this.grid do
                if this.grid[i + this.grid_width] == 0 and this.grid[i] != 5 then 
                    //color = this.grid[i]
                    
                    next_grid[i + this.grid_width] = this.grid[i]
                    if this.grid[i] != 0 then
                        next_grid[i] = 0
                    end
                end

            end

            for i=1,#this.grid do
                this.grid[i] = next_grid[i]
            end

            this.gravity_timer = 0
        end

    end,

    control_rotate = function(this)
        if btnp(5) then
            next_grid = {}


            for i=1,#this.grid do
                next_grid[i] = this.grid[i]
            end

            for i=1,#this.grid do
                point = index_to_point(i, this.grid_width)

                next_i = point_to_index(this.grid_width - point.y, point.x, this.grid_width) + 1

                next_grid[next_i] = this.grid[i]

            end

            for i=1,#this.grid do
                this.grid[i] = next_grid[i]
            end
        end
            
    end,

    _init = function (this)
        for i=1,this.grid_width ^ 2 do
            this.grid[i] = 0 if i % 4 == 0 then this.grid[i] = 1 end

        end

        this:init_states()
    end,
    
    _update = function(this)
        // Update the current state.
        this.states[this.state]:_update(this)

        this:apply_gravity()
        this:control_rotate()

        cursor:_update(this)
    end,

    _draw = function(this)
        rectline(this.x, this.y, this.size_x, this.size_y, settings.pane_fill, settings.pane_outline)

        // Draw the current state.
        this.states[this.state]:_draw(this)

        cursor:_draw(this)
    end,
}

cursor = {
    x=0, y=0,
    cache = -1,

    clamp = function(this)
        this.x = max(0, min(this.x, game_pane.grid_width - 1))
        this.y = max(0, min(this.y, game_pane.grid_width - 1))
    end,

    _update = function(this, pane)
        if btnp(0) then this.x -= 1 end
        if btnp(1) then this.x += 1 end
        if btnp(2) then this.y -= 1 end
        if btnp(3) then this.y += 1 end

        this:clamp()

        if btnp(4) then
            i = point_to_index(this.x, this.y, pane.grid_width) + 1

            if this.cache == -1 then
                if  pane.grid[i] != 0 then
                

                    this.cache = pane.grid[i]
                    pane.grid[i] = 0
                end
            elseif pane.grid[i] == 0 then
                pane.grid[i] = this.cache
                this.cache = -1
            end
        end
    end,

    _draw = function (this, pane)
        l = pane.x + (this.x * pane.pixel_size) 
        t = pane.y + (this.y * pane.pixel_size)
        r = pane.x + (this.x * pane.pixel_size) + pane.pixel_size + 1
        b = pane.y + (this.y * pane.pixel_size) + pane.pixel_size + 1

        rect(l, t, r, b, 9)
    end
}


function _init()
    
    // Inherit the pane as, well, panes.
    inherit({
        game_pane,
        goal_pane
    }, pane, true, function(target)
        // After inheritance, add it to the panes.
        panes[pane_value] = target
        pane_value += 1
    end)

    // Initialize the panes.
    for i, pane in pairs(panes) do 
        pane:_init()
    end
end

function _update()

    // Update the panes.
    for i, pane in pairs(panes) do 
        pane:_update()
    end

end

function _draw()
    cls(7)

    // Draw the panes.
    for i, pane in pairs(panes) do 
        pane:_draw()
    end

end