
Table = {
    merge = {}
}

function Table.contains(input_table, element)
    for _, value in pairs(input_table) do
        if value == element then
            return true
        end
    end
    return false
end

function Table.length(input_table)
    local count = 0
    for idx, _ in pairs(input_table) do
        count = count + 1
    end
    return count
end

function Table.keys(input_table)
    local keys = {}
    for key, _ in pairs(input_table) do
        table.insert(keys, key)
    end
    return keys
end

function Table.values(input_table)
    local values = {}
    for _, value in pairs(input_table) do
        table.insert(values, value)
    end
    return values
end

function Table.map(input_table, func)
    local output_table
    for idx, val in pairs(input_table) do
        output_table[idx] = func(val)
    end
    return output_table
end

function Table.filter(input_table, condition)
    local output_table
    for idx, val in pairs(input_table) do
        if condition(val) then
            output_table[idx] = func(val)
        end
    end
    return output_table
end

do
    function Table.merge.arrays(arrays)
        local output_array = {}
        for _, array in ipairs(arrays) do
            for _, value in ipairs(array) do
                table.insert(output_array, value)
            end
        end
        return output_array
    end

    function Table.merge.dicts(dicts)
        local output_dict = {}
        for _, dict in ipairs(dicts) do
            for key, val in pairs(dict) do
                output_dict[key] = val
            end
        end
        return output_dict
    end
end

return Table
