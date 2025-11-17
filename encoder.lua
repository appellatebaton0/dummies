
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
    -- Turn the table into a straight array.
    array = {}

    for i, row in pairs(table) do
        for j, value in pairs(row) do
            add(array, value)
        end
    end

    -- Encode it into format [VALUE][ID][COUNT]...
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

    return coded_string
end

function decode(string)
    -- Decode a string from the format [VALUE][ID][COUNT]...

    for i=1, #string do
        if i % 3 == 1 do
            index = ((i - 1) * 3) - 1
            printh("Section "..tostr(((i - 1) / 3) + 1)..": "..sub(string, i, i + 2), 'log.txt')
        end
    end
end