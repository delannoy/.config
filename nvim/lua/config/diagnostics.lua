
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
    virtual_lines = {current_line = true},
    signs = {text = ascii}, -- https://github.com/manrajgrover/py-log-symbols/blob/master/log_symbols/symbols.py
})

vim.keymap.set('n', '<leader>dg', vim.diagnostic.open_float, {desc='Show diagnostics in a floating window'})
vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_prev, {desc='Move to previous diagnostic and show in a floating window'})
vim.keymap.set('n', '<leader>d[', vim.diagnostic.goto_prev, {desc='Move to previous diagnostic and show in a floating window'})
vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_next, {desc='Move to next diagnostic and show in a floating window'})
vim.keymap.set('n', '<leader>d]', vim.diagnostic.goto_next, {desc='Move to next diagnostic and show in a floating window'})
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, {desc='Add buffer diagnostics to the location list'})
