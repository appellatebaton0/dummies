-- 
-- Baton0

// Lets try to make a platformer.

player1 = {
    x = 26, y = 20, sx = 7, sy = 7, layer = 0,
    sn = 0, speed = 2, draw_priority = 2,

    control = function (this)
        for i=1,this.speed do 
            next_x = this.x next_y = this.y

            // Attempt to move in the desired directions, but only do so
            // If theres nothing in the way.
            if btn(0) then next_x = try_position(this, next_x - 1, next_y).x this.flip = true end
            if btn(1) then next_x = try_position(this, next_x + 1, next_y).x this.flip = false end
            if btn(2) then next_y = try_position(this, next_x, next_y - 1).y end
            if btn(3) then next_y = try_position(this, next_x, next_y + 1).y end

            this.x = next_x
            this.y = next_y
        end

        
    end,

    _update = function (this)
        if active_player == this then 
            this:control()
        end
    end,

    _draw = function(this)
        cspr(this.sn, this.x, this.y, this.flip)
        //crectfill(this.x, this.y, this.x + this.sx, this.y + this.sy, 5)
    end
}

player2 = {
    x = 40, y = 20, sx = 7, sy = 7, layer = 0,
    sn = 0, speed = 2, draw_priority = 2,

    control = function (this)
        for i=1,this.speed do 
            next_x = this.x next_y = this.y

            // Attempt to move in the desired directions, but only do so
            // If theres nothing in the way.
            if btn(0) then next_x = try_position(this, next_x - 1, next_y).x this.flip = true end
            if btn(1) then next_x = try_position(this, next_x + 1, next_y).x this.flip = false end
            if btn(2) then next_y = try_position(this, next_x, next_y - 1).y end
            if btn(3) then next_y = try_position(this, next_x, next_y + 1).y end

            this.x = next_x
            this.y = next_y
        end
        
    end,

    _update = function (this)
        if active_player == this then 
            this:control()
        end

        //this.x = next.x
        //this.y = next.y

    end,

    _draw = function(this)
        cspr(this.sn, this.x, this.y, this.flip)
    end
}

function sort_draw_call() 

    new = {}
    add_index = 1

    priority_index = 0

    in_loop = true
    while in_loop do

        printh(add_index.. " vs "..#draw_call, 'log.txt')
        in_loop = add_index != #draw_call
        for i,obj in pairs(draw_call) do
            if obj.draw_priority == (priority_index or nil) then
                new[add_index] = obj
                add_index += 1
            end
        end
        priority_index += 1
    end

    printh("new_len: "..#new.. " draw_len: "..#draw_call, 'log.txt')

    for i=1,#draw_call do
        
        draw_call[i] = new[i]
    end

end


function _init()
    active_player = player1

    draw_call   = {player1, player2}
    update_call = {player1, player2, camera}
    collision_objects = {player1, player2}

    world:load_level(1)
end

function _update()

    // Switching between players
    if btnp(4) then
        if active_player == player1 then active_player = player2
    elseif active_player == player2 then active_player = player1 end
    end

    camera.follow_object = active_player

    for i, object in pairs(update_call) do
        object:_update()
    end
end

function _draw()
    cls(0)
    
    sort_draw_call()

    for i, object in pairs(draw_call) do
        object:_draw()
    end

end