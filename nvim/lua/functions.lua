
local main = {
    nvim = {
        debug = {},
        float = {},
        jump = {},
        toggle = {},
    },
    table = {
        merge = {},
    },
}

do
    main.nvim = {}
    do
        main.nvim.debug = {}

        function main.nvim.debug.echo(message, timeout_ms)
            -- echo `message` for `timeout_ms`
            vim.api.nvim_echo({{message}}, false, {}) -- https://neovim.io/doc/user/api.html#nvim_echo()
            vim.defer_fn(vim.cmd.echo, timeout_ms) -- https://neovim.io/doc/user/lua.html#vim.defer_fn()
        end

        function main.nvim.debug.inspect(object)
            -- print a human-readable representation of `object`
            print(vim.inspect(object)) -- https://neovim.io/doc/user/lua.html#vim.inspect()
        end
    end

    do
        main.nvim.float = {}
        -- https://neovim.io/doc/user/api.html#floating-windows

        function main.nvim.float.close()
            vim.cmd.nohlsearch()
            -- https://old.reddit.com/r/neovim/comments/1335pfc/is_there_any_generic_simple_way_to_close_floating/ji918lo/
            -- https://github.com/lettertwo/config/blob/0b56ed8f5b0e8c1186ca29cbf8623ed64976568e/nvim/lua/util/init.lua#L19
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_config(win).relative == 'win' then
                    vim.api.nvim_win_close(win, false)
                end
            end
        end

        function main.nvim.float.focus()
            for _, window_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.api.nvim_win_get_config(window_id).relative ~= '' then -- To check whether a window is floating, check whether the relative option in its config is non-empty
                vim.api.nvim_set_current_win(window_id)
                end
            end
        end

        function main.nvim.float.test()
            vim.api.nvim_open_win(0, false, {relative='win', row=3, col=3, width=60, height=20})
        end
    end

    do
        main.nvim.jump = {}

        function main.nvim.jump.paragraph(command)
            -- [In vim, don't store {} motions in jumplist](https://superuser.com/a/836924/1765015)
            local count = vim.api.nvim_get_vvar('count1') -- The count given for the last Normal mode command; defaults to 1. https://neovim.io/doc/user/vvars.html#count1-variable
            local command = string.format('keepjumps normal! %s%s', count, command) -- Moving around in {command} does not change the '', '. and '^ marks, the jumplist or the changelist. https://neovim.io/doc/user/motion.html#%3Akeepjumps
            vim.cmd(command)
        end
    end

    do
        main.nvim.toggle = {}

        function main.nvim.toggle.option(option, choices)
            local value = vim.api.nvim_get_option_value(option, {})
            if main.table.contains(choices, value) then
                local _1, _2 = unpack(choices)
                value = (value==_1 and _2) or (value==_2 and _1)
                vim.api.nvim_set_option_value(option, value, {scope='local'})
            end
            main.nvim.debug.echo(string.format('%s: %s', option, value), 1000)
        end

        function main.nvim.toggle.line_numbers()
            main.nvim.toggle.option('number', {true, false})
            main.nvim.toggle.option('relativenumber', {true, false})
        end

        function main.nvim.toggle.listchars()
            main.nvim.toggle.option('list', {true, false})
        end

        function main.nvim.toggle.virtualedit()
            main.nvim.toggle.option('virtualedit', {'all', 'block'})
        end
    end
end

do
    main.table = {}

    function main.table.contains(input_table, element)
        for _, value in pairs(input_table) do
            if value == element then
                return true
            end
        end
        return false
    end

    function main.table.length(input_table)
        local count = 0
        for idx, _ in pairs(input_table) do
            count = count + 1
        end
        return count
    end

    function main.table.keys(input_table)
        local keys = {}
        for key, _ in pairs(input_table) do
            table.insert(keys, key)
        end
        return keys
    end

    function main.table.values(input_table)
        local values = {}
        for _, value in pairs(input_table) do
            table.insert(values, value)
        end
        return values
    end

    function main.table.map(input_table, func)
        local output_table
        for idx, val in pairs(input_table) do
            output_table[idx] = func(val)
        end
        return output_table
    end

    function main.table.filter(input_table, condition)
        local output_table
        for idx, val in pairs(input_table) do
            if condition(val) then
                output_table[idx] = func(val)
            end
        end
        return output_table
    end

    do
        main.table.merge = {}

        function main.table.merge.arrays(arrays)
            local output_array = {}
            for _, array in ipairs(arrays) do
                for _, value in ipairs(array) do
                    table.insert(output_array, value)
                end
            end
            return output_array
        end

        function main.table.merge.dicts(dicts)
            local output_dict = {}
            for _, dict in ipairs(dicts) do
                for key, val in pairs(dict) do
                    output_dict[key] = val
                end
            end
            return output_dict
        end
    end
end

return main
