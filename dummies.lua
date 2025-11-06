-- Basic Drawing Program
-- Baton0

c = {
    x=3,
    o=12,
    n=0
}

printer = {
    update = function (this)
        if btnp(4, 1) then this:print() end
    end,

    print=function (this)
        printh('{', 'drawings.txt')


        for i=1,grid.box_size do
            row = "{"
            for j=1,grid.box_size do
                row = row..grid.box[i][j]..','

                grid.box[i][j] = 0
            end
            row = row.."},"
            printh(row, 'drawings.txt')
        end

        printh('},')

    end
}

grid = {

    offset = {x=4, y=4},
    unit_size = 12,
    box_size = 10,

    init=function(this)
        this.box = {
        }

        for i=1,this.box_size do
            row = {}
            for j=1,this.box_size do
                row[j] = 0
            end
            this.box[i] = row
        end

    end,

    draw=function(this)
        for i=1,#this.box do
            for j=1,#this.box do
                left = this.offset.x + ((i-1) * this.unit_size)
                right = this.offset.x + ((i) * this.unit_size)
                top = this.offset.y + ((j-1) * this.unit_size)
                bottom = this.offset.y + ((j) * this.unit_size)

                rectfill(left,top,right,bottom, this.box[i][j]);
                //rect(left,top,right,bottom, 0);
            end
        end
    end
}

cursor = {
    x=1, y=1, value=0,

    control_cursor=function(this,clamp)
        nx = this.x ny = this.y

        if btnp(0) then nx -= 1 this.timer = 20 end
        if btnp(1) then nx += 1 this.timer = 20 end
        if btnp(2) then ny -= 1 this.timer = 20 end
        if btnp(3) then ny += 1 this.timer = 20 end

        if clamp then 
            if nx > #grid.box then nx = #grid.box end
            if nx < 1 then nx = 1 end
            if ny > #grid.box then ny = #grid.box end
            if ny < 1 then ny = 1 end
        else
            if nx > #grid.box then nx = 1 end
            if nx < 1 then nx = #grid.box end
            if ny > #grid.box then ny = 1 end
            if ny < 1 then ny = #grid.box end
        end
        
        this.x = nx 
        this.y = ny
    end,

    write_cursor=function(this)
        if btnp(4) then this.value += 1 this.timer = 20 end
        if btn(5) then grid.box[this.x][this.y] = this.value this.timer = 20 end
    end,

    update=function(this, clamp)
        this:control_cursor(clamp)
        this:write_cursor()
    end,

    timer = 0,
    draw=function(this)
        this.timer+=1;

        if this.timer > 15 then
            left = grid.offset.x + ((this.x-1) * grid.unit_size)
            right = grid.offset.x + ((this.x) * grid.unit_size)
            top = grid.offset.y + ((this.y-1) * grid.unit_size)
            bottom = grid.offset.y + ((this.y) * grid.unit_size)

            rectfill(left,top,right,bottom, 7);
            rect(left,top,right,bottom, this.value);
            
            if this.timer > 30 then
                this.timer = 0
            end

        end
    end
}

function _init()
    grid:init()
end

function _update()
    cursor:update(true)
    printer:update()
end

function _draw()
    cls(5)

    grid:draw()
    cursor:draw()
end