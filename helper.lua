// Helper functions
function rectline(x, y, size_x, size_y, fill, outline)
    rectfill(x, y, x + size_x, y + size_y, fill)
    rect(x, y, x + size_x, y + size_y, outline)
end

function inherit(target, from, is_array, afterword)
    // Default the afterword to nothing.
    afterword = afterword or function(target) end 

    if is_array then
        for i,sub_target in pairs(target) do
            if type(sub_target) == "table" do
                setmetatable(sub_target, {__index=from})
                afterword(sub_target)
            end
        end
    else
        setmetatable(target, {__index=from})
        afterword(target)

    end
    
end