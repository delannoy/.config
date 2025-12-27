
local toggle = {}

--- Toggle `option` between `choices` (if the current value of option is one of choices)
--- @generic T
--- @param option string
--- @param choices [T, T]
function toggle.option(option, choices)
    assert(#choices == 2, '`choices` must have exactly two elements')
    local current_value = vim.api.nvim_get_option_value(option, {})
    if not vim.tbl_contains(choices, current_value) then
        return
    end
    local toggle_map = {[choices[1]]=choices[2], [choices[2]]=choices[1]}
    local new_value = toggle_map[current_value]
    vim.api.nvim_set_option_value(option, new_value, {scope='local'})
    vim.notify(string.format('%s: %s', option, new_value), vim.log.levels.INFO)
end

--- Toggle `number`, `relativenumber`, `list`, `signcolumn`
function toggle.columns()
    toggle.line_numbers()
    toggle.listchars()
    toggle.signcolumn()
end

--- Toggle `number`, `relativenumber`
function toggle.line_numbers()
    toggle.option('number', {true, false})
    toggle.option('relativenumber', {true, false})
end

--- Toggle `list`
function toggle.listchars()
    toggle.option('list', {true, false})
end

--- Toggle `signcolumn`
function toggle.signcolumn()
    toggle.option('signcolumn', {'auto', 'no'})
end

--- Toggle `virtualedit` between `all` and `block`
function toggle.virtualedit()
    toggle.option('virtualedit', {'all', 'block'})
end

return toggle
