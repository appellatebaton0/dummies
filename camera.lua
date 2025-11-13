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

camera = {
    x = 0, y = 0,
    off_x = 60, off_y = 60,
    follow_object = -1,

    _update = function(this)
        if this.follow_object != -1 then
            this.x = this.follow_object.x - this.off_x
            this.y = this.follow_object.y - this.off_y
        end
    end
}