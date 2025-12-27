
local floating_window = require('functions/floating_window')

local register_history = {}

local register = '"' -- the unnamed register is filled with text deleted using d, D, x, X, s, S, c, C, or text yanked using y or Y.

--- @type {[integer]: string[]} -- Per-session history for `register` (unnamed register, by default), where the keys correspond to the `buffer_id` and the values are arrays of deleted/yanked text
local history = {}

--- Add contents of `register` to `history` (unless it is already the first element in `history`)
--- @param buffer_id integer ID of current/parent buffer
function register_history.add(buffer_id)
    local unnamed_register = vim.fn.getreg(register)
    unnamed_register = unnamed_register:gsub('[\n]+', '󰌑') -- replace newlines with 󰌑
    local buffer_history = history[buffer_id] or {}
    if unnamed_register ~= buffer_history[1] then
        table.insert(buffer_history, 1, unnamed_register)
    end
    history[buffer_id] = buffer_history
end

--- Reinsert `content` into `register` and prepend to `history[buffer_id]`
--- @param content string Yanked/deleted text to reinsert into `register`
--- @param buffer_id integer ID of current/parent buffer
function register_history.reinsert(content, buffer_id)
    if content == nil then
        return
    end
    content = content:gsub('󰌑', '\n') -- replace 󰌑 with newlines
    vim.fn.setreg(register, content)
    vim.notify(string.format('unnamed register (")\n%s', content), vim.log.levels.INFO)
    register_history.add(buffer_id)
end

--- Pop and prepend n-th element of `history[buffer_id]` (where n is the `row_position` of the cursor in the floating window, unless it is passed explicitly); and insert into `register`
--- @param buffer_id integer ID of current/parent buffer
--- @param row_position integer? Row position of cursor in floating window
function register_history.select(buffer_id, row_position)
    row_position = row_position or vim.api.nvim_win_get_cursor(0)[1]
    local buffer_history = history[buffer_id] or {}
    local content = table.remove(buffer_history, row_position)
    register_history.reinsert(content, buffer_id)
    local opt = {window=0, force=false}
    vim.api.nvim_win_close(opt.window, opt.force)
end

--- Define keymaps to execute `register_history.select`
--- @param parent_buffer_id integer ID of current/parent buffer
--- @param floating_buffer_id integer? ID of floating window buffer
--- @param keymap_numbers boolean? Whether to define keymaps for numbers 1-9 to execute `register_history.select`
function register_history.define_keymaps(parent_buffer_id, floating_buffer_id, keymap_numbers)
    if floating_buffer_id == nil then
        return -- `floating_window.create` returns nil when the floating window already exists, in which case the keymaps have already been defined
    end
    vim.keymap.set({'n'}, '<CR>', function() register_history.select(parent_buffer_id) end, {noremap=true, silent=true, buffer=floating_buffer_id})
    keymap_numbers = keymap_numbers or false
    if keymap_numbers then
        for idx = 1, 9 do
            vim.keymap.set('n', tostring(idx), function() register_history.select(parent_buffer_id, idx) end, {noremap=true, silent=true, buffer=floating_buffer_id})
        end
    end
end

--- Create/show floating window and populate with contents of `history[buffer_id]`; if needed, define keymaps to execute `register_history.select`
--- @param keymap_numbers boolean? Whether to define keymaps for numbers 1-9 to execute `register_history.select`
function register_history.show(keymap_numbers)
    local parent_buffer_id = vim.api.nvim_get_current_buf()
    local buffer_history = history[parent_buffer_id] or {}
    local content = {}
    for _, item in ipairs(buffer_history) do
        table.insert(content, item)
    end
    local opts = {content=content, config={title='Unnamed Register History', width=100}}
    local floating_buffer_id, _ = floating_window.create(opts.content, opts.config)
    register_history.define_keymaps(parent_buffer_id, floating_buffer_id, keymap_numbers)
end

return register_history
