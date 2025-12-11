
local func = require('functions')

local map = vim.keymap

local function opts(desc)
    return {desc = desc, silent = true, noremap = true}
end

-- Disable Ex mode
map.set('n', 'Q', function() func.nvim.debug.echo('Ex mode disabled!', 1000) end, opts('Ex mode is disabled'))

-- Disable arrow keys in normal+visual mode
map.set({'n', 'v'}, '<left>', function() func.nvim.debug.echo('Use h to move left!', 1000) end, opts('Use h to move left'))
map.set({'n', 'v'}, '<right>', function() func.nvim.debug.echo('Use l to move right!', 1000) end, opts('Use l to move right'))
map.set({'n', 'v'}, '<up>', function() func.nvim.debug.echo('Use k to move up!', 1000) end, opts('Use k to move up'))
map.set({'n', 'v'}, '<down>', function() func.nvim.debug.echo('Use j to move down!', 1000) end, opts('Use j to move down'))

-- Switch between splits with CTRL+<hjkl>
map.set('n', '<C-h>', '<C-w><C-h>', opts('Move focus to the left split'))
map.set('n', '<C-l>', '<C-w><C-l>', opts('Move focus to the right split'))
map.set('n', '<C-j>', '<C-w><C-j>', opts('Move focus to the lower split'))
map.set('n', '<C-k>', '<C-w><C-k>', opts('Move focus to the upper split'))

-- Switch to next/prev buffer with ALT+PgDn/ALT+PgUp
map.set({'n', 'i'}, '<M-PageDown>', vim.cmd.bnext, opts('Switch to next buffer'))
map.set({'n', 'i'}, '<M-PageUp>', vim.cmd.bprevious, opts('Switch to previous buffer'))

-- Don't pollute jumplist with {} motions
map.set('n', '{', function() func.nvim.jump.paragraph('{') end, opts('Previous paragraph (do not pollute jumplist)'))
map.set('n', '}', function() func.nvim.jump.paragraph('}') end, opts('Next paragraph (do not pollute jumplist)'))

-- Clear search highlights and close all floating windows with ESC
map.set('n', '<Esc>', func.nvim.float.close, opts('Clear search highlights and close all floating windows after pressing <Esc> in normal mode'))

-- toggle options
map.set('n', '<leader><esc>', func.nvim.toggle.listchars, opts('Toggle listchars'))
map.set('n', '<leader>n', func.nvim.toggle.line_numbers, opts('Toggle number & relativenumber'))
map.set('n', '<leader>v', func.nvim.toggle.virtualedit, opts('Toggle virtualedit: block <-> all'))
map.set('n', '<leader>w', vim.cmd.update, opts('Write buffer'))
