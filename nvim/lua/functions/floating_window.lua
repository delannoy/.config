
local floating_window = {}

--- @type vim.api.keyset.win_config -- https://neovim.io/doc/user/api.html#api-win_config
local default_config = {
    relative = 'win', -- Window given by the win field, or current window.
    title = '',
    title_pos = 'center',
    width = 100,
    height = 25,
    style = 'minimal',
    border = 'solid',
}
default_config.row = math.floor((vim.o.lines - default_config.height) / 2)
default_config.col = math.floor((vim.o.columns - default_config.width) / 2)

-- https://neovim.io/doc/user/api.html#api-floatwin

--- Close all floating windows
function floating_window.close()
    vim.cmd.nohlsearch()
    for _, window_id in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(window_id).relative ~= '' then
            local opt = {window=window_id, force=false}
            vim.api.nvim_win_close(opt.window, opt.force)
        end
    end
end

--- Create buffer and fill with `content`
--- @param content string[] Array of lines to use pass as `replacement` for `vim.api.nvim_buf_set_line`
--- @return integer buffer_id ID of created buffer
function floating_window.create_buffer(content)
    local opt = {listed=false, scratch=true}
    local buffer_id = vim.api.nvim_create_buf(opt.listed, opt.scratch)
    opt = {buffer=buffer_id, start=0, end_=-1, strict_indexing=false, replacement=content}
    vim.api.nvim_buf_set_lines(opt.buffer, opt.start, opt.end_, opt.strict_indexing, opt.replacement)
    vim.api.nvim_set_option_value('modifiable', false, {buf=buffer_id})
    return buffer_id
end

--- Create a floating window
--- @param content string[] Array of lines to be inserted into the floating window
--- @param config {[string]: any} Map defining the window configuration
--- @return integer? buffer_id, integer? window_id Buffer ID and window ID of floating window
function floating_window.create(content, config)
    if floating_window.duplicated(config.title or '') then
        return nil
    end
    local buffer_id = floating_window.create_buffer(content)
    local opt = {buffer=buffer_id, enter=true, config=vim.tbl_extend('force', default_config, config)}
    local window_id = vim.api.nvim_open_win(opt.buffer, opt.enter, opt.config)
    vim.api.nvim_set_option_value('number', true, {win=window_id})
    vim.api.nvim_set_option_value('relativenumber', true, {win=window_id})
    return buffer_id, window_id
end

--- Return true if a floating window with `title` already exists
--- @param title string Title of target floating window
--- @return boolean -- Whether the target floating window already exists
function floating_window.duplicated(title)
    for _, window_id in ipairs(vim.api.nvim_list_wins()) do
        local win_config = vim.api.nvim_win_get_config(window_id)
        if (win_config.relative ~= '') and (win_config.title[1][1] == title) then
            return true
        end
    end
    return false
end

--- Focus cursor inside floating window
function floating_window.focus()
    for _, window_id in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(window_id).relative ~= '' then
        vim.api.nvim_set_current_win(window_id)
        end
    end
end

return floating_window
