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

function can_switch()
    a = {player1.x, player1.y}
    b = {player2.x, player2.y}

    c = {
        x = (player1.x - player2.x)  ^ 2,
        y = (player1.y - player2.y)  ^ 2
    }

    return (sqrt(c.x + c.y) / 8) <= 4
end

function sort_draw_call() 

    new = {}
    add_index = 1

    priority_index = 0

    while true do

        if add_index == #draw_call + 1 then break end
        
        for i,obj in pairs(draw_call) do
            if obj.draw_priority == (priority_index or nil) then
                new[add_index] = obj
                add_index += 1
            end
        end
        priority_index += 1
    end

    for i=1,#draw_call do
        
        draw_call[i] = new[i]
    end

end


function _init()
    active_player = player1

    draw_call   = {player1, player2}
    update_call = {player1, player2, camera}
    collision_objects = {player1, player2}

    world:load_level(current_level)

    music(0 )
end

function _update()

    // Switching between players
    if btnp(5) and can_switch() then
        if active_player == player1 then active_player = player2 player1.draw_priority = 2 player2.draw_priority = 3 sort_draw_call()
    elseif active_player == player2 then active_player = player1 player1.draw_priority = 3 player2.draw_priority = 2 sort_draw_call()end
    end

    camera.follow_object = active_player

    for i, object in pairs(update_call) do
        object:_update()
    end
end

function _draw()
    cls(0)
    
    sort_draw_call()

    xdown = 0 if btn(5) then xdown = 1 end

    if can_switch() then
        rectfill(2, 2, 12, 12, 11)
        rect(2, 2, 12, 12,  3)

        
        print("❎", 4, 5, 5)
        print("❎", 4, 4 + xdown, 3)

        
        cline(player1.x + 4, player1.y + 4, player2.x + 4, player2.y + 4, 4)
        
    else
        rectfill(2, 2, 12, 12, 8)
        rect(2, 2, 12, 12,  2)


        print("❎", 4, 5, 0)
        print("❎", 4, 4 + xdown, 2)
    end

    print("switch", 16, 5, 7)
    

    for i, object in pairs(draw_call) do
        object:_draw()
    end

end