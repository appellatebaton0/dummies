
code_array = {
    "a","b","c","d","e","f","g","h","i","j","k",
    "l","m","n","o","p","q","r","s","t","u","v",
    "w","x","y","z","A","B","C","D","E","F","G",
    "H","I","J","K","L","M","N","O","P","Q","R",
    "S","T","U","V","W","X","Y","Z","!","@","#",
    "$","%","^","&","*","(",")","{","}",";",":",
    ".","?","|","~","`","-","_","+","=","<",">",
}

function get_as_code(value)
    if value >= 0 and value <= 9 then return tostr(value)
    elseif value > 9 and value < #code_array then return code_array[value - 9] end

    return 0
end

function id(value)
    return value - flr(value)
end

function encode(table)
    -- The table's format is {{row1}, {row2}...}

    -- Turn it into a straight array.
    array = {}

    for i, row in pairs(table) do
        for j, value in pairs(row) do
            add(array, value)
        end
    end

    coded_string = ""

    last_value = -1
    last_id = 0
    last_count = 0
    for i, value in pairs(array) do
        if i == 1 then
            last_value = value
            last_id = id(value)
            last_count = 1
        
        elseif (value == last_value) and (id(value) == last_id) then
            last_count += 1
        
        else
            coded_string = coded_string..get_as_code(last_value)..get_as_code(last_id)..get_as_code(last_count)

            last_value = value
            last_id = id(value)
            last_count = 1
        end
    end

    printh(coded_string, 'log.txt')


end

function decode(string)

end