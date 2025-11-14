// Provides a grid to host levels on.

tile_functionalities = {
    { -- Wall tiles
        new = function(this, obj)
            obj = obj or {}   -- create object if user does not provide one
            setmetatable(obj, {__index = this})
            return obj
        end,

        _init = function (this, x, y, v)
            this.x = x this.y = y
            this.sx = 7 this.sy = 7

            this.sn = v
            this.layer = v

            this.draw_priority = 0

            printh("x: "..this.x.." y: "..this.y, 'log.txt')
        end,

        _draw = function(this)
            cspr(this.sn, this.x, this.y)
            
        end
    },
    { -- Goals
        new = function(this, obj)
            obj = obj or {}   -- create object if user does not provide one
            setmetatable(obj, {__index = this})
            return obj
        end,

        _init = function (this, x, y, v)
            this.x = x this.y = y
            this.sx = 7 this.sy = 7

            this.sn = v
            this.layer = -v

            this.draw_priority = 0

            printh("x: "..this.x.." y: "..this.y, 'log.txt')
        end,

        _draw = function(this)
            cspr(this.sn, this.x, this.y)
            
        end
    }
}

level_bank = {
    {
        level = {
            1,1,1,1,1,1,1,1,1,1,
            1,0,0,0,0,0,0,0,0,1,
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

        add_index = #collision_objects + 1
        draw_index = #draw_call + 1
        for i,value in pairs(level) do
            if value != 0 do

                x = ((i - 1) % width) * (this.pixels_per_unit + 1)
                y = flr((i - 1) / width) * (this.pixels_per_unit + 1)
                printh('should be: '..x..','..y, 'log.txt')

                new = {}
                setmetatable(new, {__index =tile_functionalities[flr(value)]})
                new:_init(x, y, value)

                

                collision_objects[add_index] = new
                add_index += 1

                draw_call[draw_index] = new
                draw_index += 1
            end
        end
    end,

    unload_level = function(this)

    end
}