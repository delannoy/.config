
Table = require('functions/table')

Nvim = {
    debug = {},
    float_win = {},
    jump = {},
    toggle = {},
}

do
    function Nvim.debug.echo(message, timeout_ms)
        -- echo `message` for `timeout_ms`
        vim.api.nvim_echo({{message}}, false, {}) -- https://neovim.io/doc/user/api.html#nvim_echo()
        vim.defer_fn(vim.cmd.echo, timeout_ms) -- https://neovim.io/doc/user/lua.html#vim.defer_fn()
    end

    function Nvim.debug.inspect(object)
        -- print a human-readable representation of `object`
        print(vim.inspect(object)) -- https://neovim.io/doc/user/lua.html#vim.inspect()
    end
end

do
    -- https://neovim.io/doc/user/api.html#floating-windows

    function Nvim.float_win.close()
        vim.cmd.nohlsearch()
        -- https://old.reddit.com/r/neovim/comments/1335pfc/is_there_any_generic_simple_way_to_close_floating/ji918lo/
        -- https://github.com/lettertwo/config/blob/0b56ed8f5b0e8c1186ca29cbf8623ed64976568e/nvim/lua/util/init.lua#L19
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative == 'win' then
                vim.api.nvim_win_close(win, false)
            end
        end
    end

    function Nvim.float_win.focus()
        for _, window_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(window_id).relative ~= '' then -- To check whether a window is floating, check whether the relative option in its config is non-empty
            vim.api.nvim_set_current_win(window_id)
            end
        end
    end

    function Nvim.float_win.test()
        vim.api.nvim_open_win(0, false, {relative='win', row=3, col=3, width=60, height=20})
    end
end

do
    function Nvim.jump.paragraph(command)
        -- [In vim, don't store {} motions in jumplist](https://superuser.com/a/836924/1765015)
        local count = vim.api.nvim_get_vvar('count1') -- The count given for the last Normal mode command; defaults to 1. https://neovim.io/doc/user/vvars.html#count1-variable
        local command = string.format('keepjumps normal! %s%s', count, command) -- Moving around in {command} does not change the '', '. and '^ marks, the jumplist or the changelist. https://neovim.io/doc/user/motion.html#%3Akeepjumps
        vim.cmd(command)
    end
end

do
    function Nvim.toggle.option(option, choices)
        local value = vim.api.nvim_get_option_value(option, {})
        if Table.contains(choices, value) then
            local _1, _2 = unpack(choices)
            value = (value==_1 and _2) or (value==_2 and _1)
            vim.api.nvim_set_option_value(option, value, {scope='local'})
        end
        Nvim.debug.echo(string.format('%s: %s', option, value), 1000)
    end

    function Nvim.toggle.line_numbers()
        Nvim.toggle.option('number', {true, false})
        Nvim.toggle.option('relativenumber', {true, false})
    end

    function Nvim.toggle.listchars()
        Nvim.toggle.option('list', {true, false})
    end

    function Nvim.toggle.virtualedit()
        Nvim.toggle.option('virtualedit', {'all', 'block'})
    end
end

return Nvim
