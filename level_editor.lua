
pixels_per_unit = 8

size = 2
level = {
    0, 1, 0, 2
}

function draw_level()
    for i = 1, #level do
        x = ((i - 1) % size) * pixels_per_unit
        y = flr((i - 1) / size) * pixels_per_unit

        cspr(flr(level[i]), x, y)
    end
end

cursor = {
    ix = 1, iy = 1,
    x = 0, y = 0, i = 1,


    write = function(this)
        -- Add any necessary rows  
        m = max(this.ix, this.iy) + 1

        while size < m do
            for i=1, size do
                add(level, 0, (size + 1) * i)
            end
            size += 1
        end

        while #level < size*size do
            add(level,0)
        end

        -- Add any necessary columns
        --for i=1, #level do
        --    while #level[i] <= m do
        --        level[i][#level[i] + 1] = 0
        --    end
        --end
       

        i = (this.ix) + ((this.iy) * size) + 1

        //printh("WROTE "..this.i.." to "..i, 'log.txt')

        level[i] = this.i
        
    end,

    control = function (this)
        -- Moving the cursor
        if btnp(0) then this.ix -= 1 end
        if btnp(1) then this.ix += 1 end
        if btnp(2) then this.iy -= 1 end
        if btnp(3) then this.iy += 1 end

        if this.ix < 0 then this.ix = 0 end
        if this.iy < 0 then this.iy = 0 end

        -- Changing the current index
        if btnp(5,1) then this.i -= 1 end
        if btnp(4,1) then this.i += 1 end

        if this.i < 0  then this.i = 15 end
        if this.i > 15 then this.i = 0 end

        -- Writing
        if btn(4) then this:write() end
    end,

    _update = function (this)
        this:control()
    end,

    _draw = function (this)
        this.x = this.ix * pixels_per_unit
        this.y = this.iy * pixels_per_unit
        crect(this.x - 1, this.y - 1, this.x + pixels_per_unit, this.y + pixels_per_unit, 7)
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

    if btnp(1, 1) then decode(encode(level)) end

    cursor:_draw()
    draw_level()

    crect(-1, -1, (size * pixels_per_unit), (size * pixels_per_unit))

    print("p: "..cursor.ix..','..cursor.iy.." i: "..cursor.i.." size: "..size, 3, 120, 7)
end