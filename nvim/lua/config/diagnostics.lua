
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

