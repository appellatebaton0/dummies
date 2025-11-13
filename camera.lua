// Provides functionality for translating the entire screen like
// theres a camera

// Rectfill but translated by the camera.
function crectfill(left, top, right, bottom, fill)

    left -= camera.x right -= camera.x
    top -= camera.y bottom -= camera.y

    if fill != nil then
        rectfill(left, top, right, bottom, fill)
    else
        rectfill(left, top, right, bottom)
    end
end

function cspr(n, x, y, flip)
    x -= camera.x y -= camera.y

    spr(n, x, y, 1, 1,flip)
end

camera = {
    x = 0, y = 0,
    off_x = 60, off_y = 60,
    follow_object = -1,
    follow_speed = 5,

    _update = function(this)
        if this.follow_object != -1 then
            x_change = (this.follow_object.x - this.off_x) - this.x
            y_change = (this.follow_object.y - this.off_y) - this.y

            x_change = max(-this.follow_speed, min(x_change, this.follow_speed))
            y_change = max(-this.follow_speed, min(y_change, this.follow_speed))

            this.x += x_change
            this.y += y_change
        end
    end
}