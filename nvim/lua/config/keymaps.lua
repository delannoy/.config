
local floating_window = require('functions/floating_window')
local kwargs = require('functions/kwargs')
local toggle = require('functions/toggle')
local register_history = require('functions/register_history')
local reload = require('functions/reload')

local level = vim.log.levels.WARN

local modes = {normal = 'n', insert = 'i', visual = 'x', select = 's', command = 'c', terminal = 't', operator_pending = 'o', replace = 'r', replace_virtual = 'r?'} -- https://neovim.io/doc/user/map.html#map-listing
local n = {modes.normal}
local nv = {modes.normal, modes.visual}
local nvi = {modes.normal, modes.visual, modes.insert}

--- Wrapper for the `opts` table to be passed to `vim.keymap.set`
--- @param desc string Human-readable description
--- @param noremap boolean? Disables recursive_mapping, like :noremap
--- @param silent boolean? Whether to excute silently. Normal messages will not be given or added to the message history.
--- @return vim.keymap.set.Opts -- {desc: string, noremap: boolean, silent: boolean}
local function opts(desc, noremap, silent)
    return {desc=desc, noremap=noremap or true, silent=silent or true}
end

--- Excute `curly bracket` motion (with counts) without populating the `jumplist`
--- @param command string Motion command
local function jump_paragraph(command)
    -- [In vim, don't store {} motions in jumplist](https://superuser.com/a/836924/1765015)
    local count = vim.api.nvim_get_vvar('count1') -- The count given for the last Normal mode command; defaults to 1. https://neovim.io/doc/user/vvars.html#count1-variable
    local cmd = string.format('keepjumps normal! %s%s', count, command) -- Moving around in {command} does not change the '', '. and '^ marks, the jumplist or the changelist. https://neovim.io/doc/user/motion.html#%3Akeepjumps
    vim.cmd(cmd)
end

-- Disable Ex mode
vim.keymap.set(n, 'Q', function() vim.notify('Ex mode disabled!', level) end, opts('Ex mode'))

-- Disable arrow keys in normal+visual mode
vim.keymap.set(nv, '<left>', function() vim.notify('Use h to move right', level) end, opts('disable arrow keys'))
vim.keymap.set(nv, '<right>', function() vim.notify('Use l to move right', level) end, opts('disable arrow keys'))
vim.keymap.set(nv, '<up>', function() vim.notify('Use k to move up', level) end, opts('disable arrow keys'))
vim.keymap.set(nv, '<down>', function() vim.notify('Use j to move down', level) end, opts('disable arrow keys'))

-- Switch between splits
vim.keymap.set(nv, '<C-h>', '<C-w><C-h>', opts('Move focus to the left split'))
vim.keymap.set(nv, '<C-l>', '<C-w><C-l>', opts('Move focus to the right split'))
vim.keymap.set(nv, '<C-j>', '<C-w><C-j>', opts('Move focus to the lower split'))
vim.keymap.set(nv, '<C-k>', '<C-w><C-k>', opts('Move focus to the upper split'))

-- Switch to alternate buffer
vim.keymap.set(n, '<leader>b', function() vim.cmd.buffer('#') end, opts('Switch to alternate buffer'))

-- Switch to next/prev buffer
vim.keymap.set(nv, '<M-PageDown>', vim.cmd.bnext, opts('Switch to next buffer'))
vim.keymap.set(nv, '<M-l>', vim.cmd.bnext, opts('Switch to next buffer'))
vim.keymap.set(nv, '<M-j>', vim.cmd.bnext, opts('Switch to next buffer'))
vim.keymap.set(nv, '<M-PageUp>', vim.cmd.bprevious, opts('Switch to previous buffer'))
vim.keymap.set(nv, '<M-k>', vim.cmd.bprevious, opts('Switch to previous buffer'))
vim.keymap.set(nv, '<M-h>', vim.cmd.bprevious, opts('Switch to previous buffer'))

-- Don't pollute jumplist with {} motions
vim.keymap.set(n, '{', function() jump_paragraph('{') end, opts('Previous paragraph (do not pollute jumplist)'))
vim.keymap.set(n, '}', function() jump_paragraph('}') end, opts('Next paragraph (do not pollute jumplist)'))

-- Clear search highlights and close all floating windows
vim.keymap.set(n, '<Esc>', floating_window.close, opts('Clear search highlights and close all floating windows'))

-- toggle options
vim.keymap.set(n, '<leader>`', toggle.columns, opts('Toggle number column, sign column, and listchars'))
vim.keymap.set(n, '<leader>n', toggle.line_numbers, opts('Toggle number & relativenumber'))
vim.keymap.set(n, '<leader>v', toggle.virtualedit, opts('Toggle virtualedit: block <-> all'))

-- write buffer
vim.keymap.set(n, '<leader>w', vim.cmd.update, opts('Write buffer'))

-- lua execute line
vim.keymap.set(n, '<leader>x', function() vim.cmd.lua(vim.api.nvim_get_current_line()) end, opts('Execute line with lua'))

-- reload config
vim.keymap.set(n, '<leader>r', reload.config, opts('Reload config'))

-- unnamed register history
vim.keymap.set(n, '<leader>y', register_history.show, opts('Show unnamed register history'))

-- inspect vim.api function signature
vim.keymap.set(n, '<leader>K', function() vim.notify(vim.inspect(kwargs.signature[vim.fn.expand('<cword>')])) end, opts('Search `api_info` for function/method signature'))

-- Partial match
-- map.set('n', '*', 'g*', opts('Find partial matches'))
-- map.set('n', '#', 'g#', opts('Find partial matches'))
