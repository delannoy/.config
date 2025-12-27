
local kwargs = {}

--- Return api-metadata as a dictionary with function/method names as keys and their signatures (parameter names & types) as values
--- @return {[string]: {[integer]: string, name: string, return_type: string}} signature function/method names and signatures
function kwargs.api_info()
    local signature = {}
    for _, func in ipairs(vim.fn.api_info().functions) do
        local params = {}
        for _, param in ipairs(func.parameters) do
            local param_type, param_name = unpack(param)
            table.insert(params, string.format('%s<%s>', param_name, param_type))
        end
        params['name'] = func.name
        params['return_type'] = func.return_type
        signature[func.name] = params
    end
    return signature
end

--- Wrapper for function keyword arguments (expects a list of dicts, in order to retain positional argument order)
--- @param kwargs_list {[string]: any}[] A list of dicts with keyword argument key-value pairs
--- @return any ... Ordered values unpacked into a tuple
function kwargs.kw(kwargs_list)
    local ordered_values = {}
    for _, kwarg in ipairs(kwargs_list) do
        for _, value in pairs(kwarg) do
            table.insert(ordered_values, value)
        end
    end
    return unpack(ordered_values)
end

kwargs.signature = kwargs.api_info()

return kwargs
