
local register_history = require('functions/register_history')

--- Wrapper for `vim.api.nvim_create_augroup`
--- @param name string The name of the group
--- @param clear boolean? Clear existing commands if the group already exists autocmd-groups.
--- @return integer group_id
local function create_augroup(name, clear)
    return vim.api.nvim_create_augroup(name, {clear=clear or true})
end

--- Restore cursor position as when last exitin the current buffer
local function buffer_cursor_restore()
    -- https://neovim.io/doc/user/usr_05.html#restore-cursor
    -- https://stackoverflow.com/a/79676790/13019084
    local buffer_id = vim.api.nvim_get_current_buf()
    local mark_row, mark_col = unpack(vim.api.nvim_buf_get_mark(buffer_id, '"')) -- `'quote` cursor position when last exiting the current buffer (defaults to the first character of the first of the first line)
    local line_count = vim.api.nvim_buf_line_count(buffer_id)
    if mark_row <= line_count then
        local opt = {window=0, pos={mark_row, mark_col}}
        pcall(vim.api.nvim_win_set_cursor, opt.window, opt.pos)
        opt = {keys='zvzz', mode='n', escape_ks=true}
        vim.api.nvim_feedkeys(opt.keys, opt.mode, opt.escape_ks)
        -- zv: View cursor line: Open just enough folds to make the line in which the cursor is located not folded.
        -- zz: Redraw, line [count] at center of window (default cursor line) and leave cursor in the same column
    end
end

--- Remove 'o' and 'r' from `formatoptions` (to avoid comment leader being inserted in new lines)
local function format_newline_comment()
    -- [Disable "o", "r" formatoption globally?](https://old.reddit.com/r/neovim/comments/1iofs0r/)
    vim.opt.formatoptions:remove({ -- You can use the 'formatoptions' option to influence how Vim formats text.
        'o', -- Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode
        'r', -- Automatically insert the current comment leader after hitting <Enter> in Insert mode
    })
end

vim.api.nvim_create_autocmd('FileType', {
    -- [Search vim help for subject under cursor](https://stackoverflow.com/a/15867465/13019084)
    desc = 'Search vim help for subject under cursor',
    group = create_augroup('buffer_cursor_help'),
    pattern = {'lua', 'vim'},
    callback = function()
        vim.bo.keywordprg = ':help'
    end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Restore cursor position after reopening file',
    group = create_augroup('buffer_cursor_restore'),
    callback = buffer_cursor_restore,
})

vim.api.nvim_create_autocmd('FileType', {
    -- https://rdrn.me/neovim/#basic-configuration
    desc = 'Switch on spell checking for several filetypes',
    group = create_augroup('filetype_spellcheck'),
    pattern = {'latex', 'tex', 'md', 'markdown'},
    command = 'setlocal spell',
})

vim.api.nvim_create_autocmd('BufEnter', {
    desc = 'Disable auto-inserted comments on newline',
    group = create_augroup('format_newline_comment'),
    callback = format_newline_comment,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = create_augroup('yank_highlight'),
    callback = function()
        vim.highlight.on_yank({timeout=100}) -- https://github.com/neovim/neovim/issues/31210#issuecomment-2476511467
     end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Store unnamed register in a `register_history` table',
    group = create_augroup('register_history'),
    callback = function(args) -- Lua callback receives one argument, a table with these keys: {id, event, group, file, match, buf, data}
        register_history.add(args.buf)
    end
})
