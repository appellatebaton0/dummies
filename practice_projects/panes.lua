
// State class
state = {
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