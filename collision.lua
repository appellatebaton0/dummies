// A helper library for detecting collision

collision_objects = {}

// Return if two box objects, formatted x,y,sx,sy,layer are overlapping.
function colliding_boxes(box_a, box_b, exclude_layer)

    // If its the exclude layer or in a negative [read only] layer, no.
    if box_b.layer == exclude_layer or box_b.layer < 0 then return false end

    a = {
        left   = box_a.x,
        top    = box_a.y,
        right  = box_a.x + box_a.sx,
        bottom = box_a.y + box_a.sy,
    }
    b = {
        left   = box_b.x,
        top    = box_b.y,
        right  = box_b.x + box_b.sx,
        bottom = box_b.y + box_b.sy,
    }

    if a.right >= b.left and a.left <= b.right // Horizontal
    and a.bottom >= b.top and a.top <= b.bottom // Vertical
    then return true end

    return false
    
end

function collides(box_a, exclude_layer) 
    exclude_layer = exclude_layer or box_a.layer

    for i, box in pairs(collision_objects) do
        if colliding_boxes(box_a, box, exclude_layer) then return true end
    end

    return false
end

try_position = function(last, next_x, next_y)
    attempt = {
        x  = next_x,  y  = next_y,
        sx = last.sx, sy = last.sy,
        layer = last.layer
    }

    if not collides(attempt) then
        return attempt
    end

    return last
end
