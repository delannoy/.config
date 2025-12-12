
-- https://neovim.io/doc/user/api.html#nvim_create_autocmd()
local autocmd = vim.api.nvim_create_autocmd

local function autogroup(name, clear)
    -- https://neovim.io/doc/user/api.html#nvim_create_augroup()
    return vim.api.nvim_create_augroup(name, {clear=clear or true})
end

local function buffer_cursor_restore()
    -- https://neovim.io/doc/user/usr_05.html#restore-cursor
    -- [Restore cursor position in Neovim when opening multiple files](https://stackoverflow.com/a/79676790)
    local buf = vim.api.nvim_get_current_buf()
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= line_count then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
        vim.api.nvim_feedkeys('zvzz', 'n', true)
    end
end

local function format_newline_comment()
    -- [Disable "o", "r" formatoption globally?](https://old.reddit.com/r/neovim/comments/1iofs0r/)
    vim.opt.formatoptions:remove({ -- You can use the 'formatoptions' option to influence how Vim formats text.
        'o', -- Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode
        'r', -- Automatically insert the current comment leader after hitting <Enter> in Insert mode
    })
end

autocmd('FileType', {
    -- [Search vim help for subject under cursor](https://stackoverflow.com/a/15867465/13019084)
    desc = 'Search vim help for subject under cursor',
    group = autogroup('buffer_cursor_help'),
    pattern = {'lua', 'vim'},
    callback = function()
        vim.bo.keywordprg = ':help'
    end,
})

autocmd('BufReadPost', {
    desc = 'Restore cursor position after reopening file',
    group = autogroup('buffer_cursor_restore'),
    callback = buffer_cursor_restore,
})

autocmd('FileType', {
    -- https://rdrn.me/neovim/#basic-configuration
    desc = 'Switch on spell checking for several filetypes',
    group = autogroup('filetype_spellcheck'),
    pattern = {'latex', 'tex', 'md', 'markdown'},
    command = 'setlocal spell',
})

autocmd('BufEnter', {
    desc = 'Disable auto-inserted comments on newline',
    group = autogroup('format_newline_comment'),
    callback = format_newline_comment,
})

autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = autogroup('highlight_yank'),
    callback = function()
        vim.highlight.on_yank({timeout=100}) -- https://github.com/neovim/neovim/issues/31210#issuecomment-2476511467
     end,
})
