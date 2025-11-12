-- 
-- Baton0

// Lets try to make a platformer.

test_box = {
    x = 30, y = 30, sx = 8, sy = 8, layer = 1,

    _draw = function(this)
        bounding_box = {x=this.x, y=this.y, sx=this.sx, sy=this.sy}
        bounding_box_b = {x=player.x, y=player.y, sx=player.sx, sy=player.sy}

        c = 7 if collides(test_box) then c = 3 end
        crectfill(this.x, this.y, this.x + this.sx, this.y + this.sy, c)
    end
}

player = {
    x = 0, y = 0, sx = 8, sy = 8, layer = 2,
    sn = 0, speed = 1,

    control = function (this)
        for i=1,this.speed do 
            next_x = this.x next_y = this.y

            // Attempt to move in the desired directions, but only do so
            // If theres nothing in the way.
            if btn(0) then next_x = try_position(this, next_x - 1, next_y).x end
            if btn(1) then next_x = try_position(this, next_x + 1, next_y).x end
            if btn(2) then next_y = try_position(this, next_x, next_y - 1).y end
            if btn(3) then next_y = try_position(this, next_x, next_y + 1).y end

            this.x = next_x
            this.y = next_y
        end

        
    end,

    _update = function (this)
        this:control()

        //this.x = next.x
        //this.y = next.y

    end,

    _draw = function(this)
        c = 7 if collides(this) then c = 3 end
        crectfill(this.x, this.y, this.x + this.sx, this.y + this.sy, c)
    end
}

function _init()
    camera.follow_object = player

    draw_call   = {player, test_box}
    update_call = {player, camera}
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