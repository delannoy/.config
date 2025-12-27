
local reload = {}

--- Delete all global keymaps for `map_mode` whose description matches `desc_pattern`
--- @param map_mode string? Mode short-name ("n", "i", "v", ...)
--- @param desc_pattern string? Pattern to match against keymap descriptions
function reload.keymaps(map_mode, desc_pattern)
    map_mode = map_mode or 'n'
    desc_pattern = desc_pattern or ''
    for _, map in ipairs(vim.api.nvim_get_keymap(map_mode)) do
        if map.desc and map.desc:match(desc_pattern) then
            vim.keymap.del(map_mode, map.lhs)
        end
    end
end
--- Delete cache and reload packages inside 'functions/' and 'config/' directories
--- @param delete_keymaps boolean? Whether to delete `map_mode` keymaps whose description match `desc_pattern`
--- @param map_mode string? Mode short-name ("n", "i", "v", ...)
--- @param desc_pattern string? Pattern to match against keymap descriptions
function reload.config(delete_keymaps, map_mode, desc_pattern)
    for name, _ in pairs(package.loaded) do
        if name:match('^functions/') or name:match('^config/') then
            vim.notify(name, vim.log.levels.INFO)
            package.loaded[name] = nil
        end
    end
    delete_keymaps = delete_keymaps or false
    if delete_keymaps then
        reload.keymaps(map_mode, desc_pattern)
    end
    dofile(vim.env.MYVIMRC)
end

return reload
