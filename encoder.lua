
code_array = {
    "a","b","c","d","e","f","g","h","i","j","k",
    "l","m","n","o","p","q","r","s","t","u","v",
    "w","x","y","z","A","B","C","D","E","F","G",
    "H","I","J","K","L","M","N","O","P","Q","R",
    "S","T","U","V","W","X","Y","Z","!","@","#",
    "$","%","^","&","*","(",")","{","}",";",":",
    ".","?","|","~","`","-","_","+","=","<",">",
}

function num_as_code(value)

    value = flr(value)

    if value >= 0 and value <= 9 then return tostr(value)
    elseif value > 9 and value < #code_array then return code_array[value - 9] end

    return 0
end

function code_as_num(value)
    
   
    for i, v in ipairs(code_array) do
        if v == value then
            return i + 9
        end
    end

    value = tonum(value)
    if value != nil then if value >= 0 and value <= 9 then return tonum(value) end end

    return -1
end

function as_id(value)
    

    decim = value - flr(value)

    printh("IDing "..value.." to "..(decim * ( 10 ^ (#tostr(decim) - 2) )), 'log.txt')

    return flr(decim * ( 10 ^ (#tostr(decim) - 2) ) + 0.5)
end

function encode(array)
    -- Encode it into format [VALUE][ID][COUNT]...
    coded_string = ""

    last_value = -1
    last_id = 0
    last_count = 0
    for i, value in pairs(array) do
        if i == 1 then
            last_value = value
            last_id = as_id(value)
            last_count = 1
        
        elseif (value == last_value) and (as_id(value) == last_id) then
            last_count += 1
        
        else
            coded_string = coded_string..num_as_code(last_value)..num_as_code(last_id)..num_as_code(last_count)

            last_value = value
            last_id = as_id(value)
            last_count = 1
        end
    end

    coded_string = coded_string..num_as_code(array[#array])

    return coded_string
end

function decode(string)
    -- Decode a string from the format [VALUE][ID][COUNT]...

    table = {}

    for i=1, #string do
        if i % 3 == 1 do
            if i == #string then add(table)
                add(table, code_as_num(sub(string, i, i)))
            else

                pair_id    = sub(string, i + 1, i + 1)
                pair_id    = code_as_num(pair_id) / (10^#pair_id)

                value = code_as_num(sub(string, i, i)) + pair_id
                count = code_as_num(sub(string, i + 2, i + 2))

                for i=1, count do
                    add(table, value)
                end

            end
        end
    end

    return table
end