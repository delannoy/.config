
local toggle = require('functions/toggle')

local unicode = {
    [vim.diagnostic.severity.ERROR] = '✖',
    [vim.diagnostic.severity.WARN] = '⚠',
    [vim.diagnostic.severity.INFO] = '🛈',
    [vim.diagnostic.severity.HINT] = '✔',
}

local ascii = {
    [vim.diagnostic.severity.ERROR] = '×',
    [vim.diagnostic.severity.WARN] = '‼',
    [vim.diagnostic.severity.INFO] = 'i',
    [vim.diagnostic.severity.HINT] = '√',
}

vim.diagnostic.config({
    -- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts
    virtual_text = false,
    virtual_lines = {current_line=true},
    signs = {text = ascii}, -- https://github.com/manrajgrover/py-log-symbols/blob/master/log_symbols/symbols.py
})

local virtual_lines_insert_mode = vim.api.nvim_create_augroup('AutoToggleVirtualLines', {clear=true})

vim.api.nvim_create_autocmd('InsertEnter', {
    desc = 'Disable virtual_lines when entering insert mode',
    group = virtual_lines_insert_mode,
    callback = function()
        vim.diagnostic.config({virtual_lines=false})
    end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
    desc = 'Enable virtual_lines when leaving insert mode',
    group = virtual_lines_insert_mode,
    callback = function()
        vim.diagnostic.config({virtual_lines={current_line=true}})
    end,
})

vim.keymap.set('n', '<leader>dg', vim.diagnostic.open_float, {desc='Show diagnostics in a floating window'})
vim.keymap.set('n', '<leader>dk', function() vim.diagnostic.jump({count=-1}) end, {desc='Move to previous diagnostic and show in a floating window'})
vim.keymap.set('n', '<leader>d[', function() vim.diagnostic.jump({count=-1}) end, {desc='Move to previous diagnostic and show in a floating window'})
vim.keymap.set('n', '<leader>dj', function() vim.diagnostic.jump({count=1}) end, {desc='Move to next diagnostic and show in a floating window'})
vim.keymap.set('n', '<leader>d]', function() vim.diagnostic.jump({count=1}) end, {desc='Move to next diagnostic and show in a floating window'})
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, {desc='Add buffer diagnostics to the location list'})
vim.keymap.set('n', '<leader>dv', toggle.diagnostic_virtual_lines, {desc='Toggle diagnostic virtual_lines'})
