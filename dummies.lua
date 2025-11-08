-- Puzzle Game Test
-- Baton0

settings = {
    pane_fill = 6,
    pane_outline = 0
}

// Helper functions
function rectline(x, y, size_x, size_y, fill, outline)
    rectfill(x, y, x + size_x, y + size_y, fill)
    rect(x, y, x + size_x, y + size_y, outline)
end

function inherit(target, from, is_array, afterword)
    // Default the afterword to nothing.
    afterword = afterword or function(target) end 

    if is_array then
        for i,sub_target in pairs(target) do
            if type(sub_target) == "table" do
                setmetatable(sub_target, {__index=from})
                afterword(sub_target)
            end
        end
    else
        setmetatable(target, {__index=from})
        afterword(target)

    end
    
end

// States
state = {
    options = {},

    _init = function(this, pane)

    end,

    _update = function(this, pane)

    end,

    _draw = function(this, pane)

    end,
}


// Pane functions
pane_value = 1


panes = {}
pane = {
    x=0,y=0,size_x=0,size_y=0,

    state = "main",
    change_state = function(this, to)
        this.state = to
    end,
    init_states = function(this)
        // Inherit the states.
        inherit(this.states, state, true)

        // Initialize the states.
        for i, state in pairs(this.states) do
            state:_init(this)
        end
    end,
    states = {
        main = {
            _init = function(this, pane)

            end,

            _update = function(this, pane)

            end,

            _draw = function(this, pane)
                rectline(pane.x, pane.y, 5, 5, 3, 0)
            end,
        }
    },

    _init = function (this)
        this:init_states()
    end,

    _update = function(this)
        // Update the current state.
        this.states[this.state]:_update(this)
    end,

    _draw = function(this)
        rectline(this.x, this.y, this.size_x, this.size_y, settings.pane_fill, settings.pane_outline)

        // Draw the current state.
        this.states[this.state]:_draw(this)
    end,

}

// -

// Panes

// The pane to store the puzzle solution.
goal_pane = {
    x = 4, y = 4, size_x = 31, size_y = 31
}

// The pane where the player solves the puzzle.
puzzle_pane = {
    x = 4, y = 40, size_x = 81, size_y = 81
}

// 



function _init()
    
    // Inherit the pane as, well, panes.
    inherit({
        puzzle_pane,
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