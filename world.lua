// Provides a grid to host levels on.

function inherit(from, obj)
    obj = obj or {}
    setmetatable(obj, {__index = from})
    return obj
end

tile_functionalities = {
    { -- Wall tiles

        _init = function (this)
            this.sx = 7 this.sy = 7

            this.sn = this.value
            this.layer = this.value

            this.draw_priority = 0
        end,

        _ready = function(this, world) end,

        _draw = function(this)
            cspr(this.sn, this.x, this.y)
        end,

        _update = function(this) end
    },
    { -- Goals

        _init = function (this)
            this.sx = 7 this.sy = 7

            this.sn = this.value
            this.layer = -this.value

            this.draw_priority = 0
        end,

        _ready = function(this, world) end,

        _draw = function(this)
            cspr(this.sn, this.x, this.y)
            
        end,

        _update = function(this) 
            if collides(this) then world:unload_level() end
        end
    },
    { -- Buttons

        _init = function (this)
            this.sx = 7 this.sy = 7

            this.sn = this.value
            this.layer = -flr(this.value)

            this.interaction_id = this.value - flr(this.value)

            this.draw_priority = 0
        end,

        _ready = function(this, world)
            for i, object in pairs(world) do
                if object.value != this.value and 
                   object.interaction_id == this.interaction_id then
                    this.pair_obj = object
                end
            end
        end,

        _draw = function(this)
            cspr(this.sn, this.x, this.y)
        end,

        _update = function(this) 
            this.down = collides(this)
            if this.down then this.sn = 3 + 16 else this.sn = 3 end
        end
    },
    { -- Doors
        _init = function (this)
            this.sx = 7 this.sy = 7

            this.sn = this.value
            this.layer = this.value

            this.interaction_id = this.value - flr(this.value)

            this.draw_priority = 0
        end,

        _ready = function(this, world)
            for i, object in pairs(world) do
                if object.value != this.value and 
                   object.interaction_id == this.interaction_id then
                    this.pair_obj = object
                end
            end
        end,

        _draw = function(this)
            cspr(this.sn, this.x, this.y)
        end,

        _update = function(this) 
            if this.pair_obj != nil then

                if this.pair_obj.down then 
                    this.layer = -4 
                    this.sn = 4 + 16
                else 
                    this.layer = 4 
                    this.sn = 4
                end

            end
        end
    }
}

level_bank = {
    {
        level = {
            1,1,1,1,1,1,1,1,1,1,
            1,0,3.1,0,4.1,0,0,0,0,1,
            1,0,2,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,1,
            1,1,1,1,1,1,1,1,1,1,
        },
        width = 10
    }
}

world = {

    level_objects = {},
    pixels_per_unit = 7,
    layer = 3,

    load_level = function(this, level_id)
        level = level_bank[level_id].level
        width = level_bank[level_id].width

        obj_index = #this.level_objects + 1
        collide_index = #collision_objects + 1
        draw_index = #draw_call + 1
        update_index = #update_call + 1

        for i,value in pairs(level) do
            if value != 0 do

                new = inherit(tile_functionalities[flr(value)])

                new.x = ((i - 1) % width) * (this.pixels_per_unit + 1)
                new.y = flr((i - 1) / width) * (this.pixels_per_unit + 1)
                
                new.level_object = true

                new.value = value
                new:_init()

                -- Add to the object list
                this.level_objects[obj_index] = new
                obj_index += 1

                
                -- Add to the collision list
                collision_objects[collide_index] = new
                collide_index += 1

                -- Add to the draw list
                draw_call[draw_index] = new
                draw_index += 1

                -- Add to the update call
                update_call[update_index] = new
                update_index += 1
            end
        end

        for i, object in pairs(this.level_objects) do
            object:_ready(this.level_objects)
        end
    end,

    unload_level = function(this)
        -- Remove the objects from the call, then clear the object queue
        for i, obj in pairs(this.level_objects) do
            del(collision_objects, obj)
            del(draw_call, obj)
            del(update_call, obj)
        end

        this.level_objects = {}
    end
}