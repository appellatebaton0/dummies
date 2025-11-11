-- 
-- Baton0

// Lets try to make a platformer.

test_box = {
    x = 30, y = 30, sx = 8, sy = 8, layer = 1,

    _draw = function(this)
        bounding_box = {x=this.x, y=this.y, sx=this.sx, sy=this.sy}
        bounding_box_b = {x=player.x, y=player.y, sx=player.sx, sy=player.sy}

        c = 7 if collides(test_box) then c = 3 end
        rectfill(this.x, this.y, this.x + this.sx, this.y + this.sy, c)
    end
}

player = {
    x = 0, y = 0, sx = 8, sy = 8, layer = 2,
    sn = 0, speed = 1,

    next_position = function (this, x, y)
        nx = x or this.x ny = y or this.y

        if btn(0) then nx -= 1 end
        if btn(1) then nx += 1 end
        if btn(2) then ny -= 1 end
        if btn(3) then ny += 1 end

        return {x=nx, y=ny}
    end,

    control = function (this)
        
        next = {x = this.x, y = this.y}

        for i=1,this.speed do 
            attempt = this:next_position(next.x, next.y)
            attempt.sx = this.sx attempt.sy = this.sy

            if not collides(attempt, this.layer) then
                next = attempt
            end
        end

        this.x = next.x
        this.y = next.y
    end,

    _update = function (this)
        this:control(this:next_position())

        //this.x = next.x
        //this.y = next.y

    end,

    _draw = function(this)
        //spr(this.sn, this.x, this.y)
        bounding_box = {x=this.x, y=this.y, sx=this.sx, sy=this.sy}
        bounding_box_b = {x=test_box.x, y=test_box.y, sx=test_box.sx, sy=test_box.sy}

        c = 7 if collides(this) then c = 3 end
        rectfill(this.x, this.y, this.x + this.sx, this.y + this.sy, c)
    end
}

function _init()
    draw_call   = {player, test_box}
    update_call = {player}
    collision_objects = {player, test_box}
end

function _update()
    for i, object in pairs(update_call) do
        object:_update()
    end

end

function _draw()
    cls(0)
    

    for i, object in pairs(draw_call) do
        object:_draw()
    end

end