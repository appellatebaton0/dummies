
pixels_per_unit = 7

level = {

}

cursor = {
    x = 1, y = 1,

    control = function (this)
        
    end,

    _update = function (this)
        this:control()
    end

    _draw = function (this)
        x = this.x * pixels_per_unit
        y = this.y * pixels_per_unit
        rect(x - 1, y - 1, x + pixels_per_unit + 1, y + pixels_per_unit + 1, 7)
    end
}

function _draw()
    cls(0)

    cursor:_draw()
end