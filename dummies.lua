--
-- Baton0

// Container for collisions
collisions = {
    list = {}, // All the current colliders

    // Add a new collision.
    collisions = 0,
    add_collision=function(this, static, left, top, right, bottom)
        new = {}

        new.static = static

        new.left = left
        new.top = top
        new.right = right
        new.bottom = bottom

        this.list[this.collisions] = new
        
        this.collisions += 1
    end,

    // Sets the bounding box of a collision.
    set_collision=function(this, index, new_left, new_top, new_right, new_bottom)
        if #this.list >= index then
            box = this.list[index]

            box.left = new_left
            box.top = new_top
            box.right = new_right
            box.bottom = new_bottom
        end
    end,

    // Translate a collision by a certain amount.
    translate_collision=function(this, index, x, y)
        if #this.list >= index then
            box = this.list[index]

            box.left += x
            box.top += y
            box.right += x
            box.bottom += y

            this.list[index] = box

            return box
        end
    end,


    // Takes in two collision indexes and resolves their collision.
    resolve_collision=function (this, a, b)
        if a == b do return false end // If same, ignore.

        // Get the bounding boxes.
        bxa = this.list[a]
        bxb = this.list[b]

        if bxa.static and bxb.static then return end
        if bxa == nil or bxb == nil then return end

        resolve_vector = {x=0,y=0}

        // Make the resolve vector.
        if bxa.right > bxb.left then resolve_vector.x += bxa.right - bxb.left end
        if bxa.left < bxb.right then resolve_vector.x += bxa.left - bxb.right end
        if bxb.bottom > bxb.top then resolve_vector.y += bxa.bottom - bxb.top end
        if bxa.top < bxb.bottom then resolve_vector.y += bxa.top - bxb.bottom end
        
        print(tostr(resolve_vector.x)..","..tostr(resolve_vector.y).." <- "..tostr(bxa.right), 10, 20 + (10*a))

        // Resolve the collision.
        if bxa == static then     
            this:translate_collision(a, resolve_vector.x, resolve_vector.y)
        elseif bxb == static then 
            this:translate_collision(b, -resolve_vector.x, -resolve_vector.y)
        else
            this:translate_collision(a, resolve_vector.x/2, resolve_vector.y/2)
            this:translate_collision(b, -resolve_vector.x/2, -resolve_vector.y/2)
        end
    end,

    // Stops any overlaps between collision boxes.
    resolve_collisions=function(this)
        for i=0,#this.list do
            for j=0,#this.list do
                this:resolve_collision(i,j)
            end
        end
    end,

    // Draw all existing collisions
    draw_collisions=function(this)
        for i=0,#this.list do
            col = this.list[i]
            rectfill(col.left, col.top, col.right, col.bottom, 3)
        end
    end
}

player = {
    
    init=function(this)
        collisions:add_collision(false, 64, 64, 68, 68)
        this.collision_index = #collisions.list
    end,

    gravity = 0.3,
    sum_gravity = 0,
    apply_gravity=function(this)
        this.sum_gravity += this.gravity
        
        collisions:translate_collision(this.collision_index, 0, this.sum_gravity)
    end,

    update=function(this)
        this:apply_gravity()
    end,

    draw=function(this)
        print("updated "..tostring(this.collision_index), 60, 5)

        col = collisions.list[this.collision_index]
        rectfill(col.left, col.top, col.right, col.bottom, 3)
    end
}

function _init()
    
    cls(4)
    player:init()
    collisions:add_collision(true, 20,100,120,130)
    
end

function _update()
    //player:update()
cls(4)
    collisions:resolve_collisions()
end

function _draw()
    
    player:draw()
    collisions:draw_collisions()
end