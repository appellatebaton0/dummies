
pixels_per_unit = 7

level = {
    {0}
}

function get_level_size()
    a = #level
    b = #level[1]
    if a > b then return a else return b end
end

function draw_level()
    for i, row in pairs(level) do
        for j, value in pairs(row) do
            cspr(value, (i-1) * pixels_per_unit, (j-1) * pixels_per_unit)
        end
    end
end

cursor = {
    ix = 1, iy = 1,
    x = 0, y = 0, i = 1,

    write = function(this)
        -- Add any necessary rows  
        m = max(this.ix, this.iy)
        printh("level: "..#level, 'log.txt')
        printh("iy: "..this.iy, 'log.txt')
        while not (#level > m) do
            level[#level + 1] = {0}
        end

        -- Add any necessary columns
        for i=1, #level do
            while #level[i] <= m do
                level[i][#level[i] + 1] = 0
            end
        end

        level[this.ix + 1][this.iy + 1] = this.i
        
    end,

    control = function (this)
        if btnp(0) then this.ix -= 1 end
        if btnp(1) then this.ix += 1 end
        if btnp(2) then this.iy -= 1 end
        if btnp(3) then this.iy += 1 end

        if this.ix < 0 then this.ix = 0 end
        if this.iy < 0 then this.iy = 0 end

        if btnp(4) then this:write() end
    end,

    _update = function (this)
        this:control()
    end,

    _draw = function (this)
        this.x = this.ix * pixels_per_unit
        this.y = this.iy * pixels_per_unit
        crect(this.x - 1, this.y - 1, this.x + pixels_per_unit + 1, this.y + pixels_per_unit + 1, 7)
    end
}

function _init()
    camera.follow_object = cursor

    camera.follow_speed = pixels_per_unit * 2

    camera.off_x = 64 - pixels_per_unit
    camera.off_y = 64 - pixels_per_unit
end

function _update()
    cursor:_update()
    camera:_update()
    
end

function _draw()
    cls(0)


    cursor:_draw()
    draw_level()

    ls = get_level_size()
    crect(-1, -1, (ls * pixels_per_unit) + 1, (ls * pixels_per_unit) + 1)

    print("I: "..cursor.ix..','..cursor.iy.." size: "..ls, 3, 120, 7)
end