// Provides a grid to host levels on.

level_bank = {
    {
        level = {
            7,7,7,7,7,7,7,7,7,7,
            7,0,0,0,0,0,0,0,0,7,
            7,0,7,0,0,0,0,7,0,7,
            7,0,0,0,0,0,0,0,0,7,
            7,0,0,0,7,7,0,0,0,7,
            7,0,7,0,0,0,0,7,0,7,
            7,0,0,7,7,7,7,0,0,7,
            7,0,0,0,0,0,0,0,0,7,
            7,0,0,0,0,0,0,0,0,7,
            7,7,7,7,7,7,7,7,7,7,
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
        for i,value in pairs(level) do
            if value == 7 do
                
                new = {
                    x = ((i - 1) % width) * (this.pixels_per_unit + 1), sx = this.pixels_per_unit,
                    y = flr((i - 1) / width) * (this.pixels_per_unit + 1), sy = this.pixels_per_unit,
                    layer = this.layer
                }

                collision_objects[add_index] = (new)
                add_index += 1
            end
        end
    end,

    unload_level = function(this)

    end
}