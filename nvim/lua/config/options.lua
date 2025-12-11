
-- https://neovim.io/doc/user/options.html
-- https://neovim.io/doc/user/quickref.html#_options

local opt = vim.opt

local tabstop = 4

local leadmultispace = string.format('┊%s', string.rep(' ', tabstop-1)) -- [I feel like leadmultispace deserves more attention](https://old.reddit.com/r/neovim/comments/17aponn)

-- color scheme
vim.cmd.colorscheme('wildcharm')

-- completion
opt.completeopt = { -- A comma-separated list of options for Insert mode completion ins-completion.
    'menuone', -- Use the popup menu also when there is only one match.
    'noinsert', -- Do not insert any text for a match until the user selects a match from the menu.
    'noselect', -- Same as "noinsert", except that no menu item is pre-selected.
}

-- cursor
opt.cursorline = true -- Highlight the text line of the cursor with CursorLine hl-CursorLine.
opt.virtualedit = { -- Virtual editing means that the cursor can be positioned where there is no actual character.
    'block' -- Allow virtual editing in Visual block mode.
}

-- line numbers
opt.number = true -- Print the line number in front of each line.
opt.relativenumber = true -- Show the line number relative to the line with the cursor in front of each line.

-- meta files
opt.undofile = true -- When on, Vim automatically saves undo history to an undo file when writing a buffer to a file, and restores undo history from the same file on buffer read.

-- mouse
opt.mouse = '' -- Enables mouse support.

-- rendering
opt.list = true -- List mode: By default, show tabs as ">", trailing spaces as "-", and non-breakable space characters as "+".
opt.listchars = { -- Strings to use in 'list' mode and for the :list command.
    leadmultispace = leadmultispace, -- Like the listchars-multispace value, but for leading spaces only.
    multispace = '·', -- One or more characters to use cyclically to show for multiple consecutive spaces.
    nbsp = '‡', -- Character to show for a non-breakable space character (0xA0 (160 decimal) and U+202F).
    tab = '→·', -- The 'x' is always used, then 'y' as many times as will fit.
    trail = '·', -- Character to show for trailing spaces.  When omitted, trailing spaces are blank.
}
opt.scrolloff = 4 -- Minimal number of screen lines to keep above and below the cursor.
opt.showmode = false -- If in Insert, Replace, or Visual mode: put a message on the last line.
opt.termguicolors = true -- Enables 24-bit RGB color in the TUI.
opt.wrap = false -- When off, lines will not wrap and only part of long lines will be displayed.
opt.winblend = 25 -- Enables pseudo-transparency for a floating window. Valid values are in the range of 0 for fully opaque window (disabled) to 100 for fully transparent background.

-- search/substitute
opt.inccommand = 'split' -- When nonempty, shows the effects of :substitute, :smagic, :snomagic and user commands with the :command-preview flag as you type.
    -- nosplit: Shows the effects of a command incrementally in the buffer.
    -- split: Like "nosplit", but also shows partial off-screen results in a preview window.
opt.ignorecase = true -- Ignore case in search patterns, cmdline-completion, when searching in the tags file, expr-== and for Insert-mode completion ins-completion.
opt.smartcase = true -- Override the 'ignorecase' option if the search pattern contains upper case characters.

-- splits
opt.splitbelow = true -- When on, splitting a window will put the new window below the current one.
opt.splitright = true -- When on, splitting a window will put the new window right of the current one.

-- tabs
opt.expandtab = true -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
opt.shiftround = true -- Round indent to multiple of 'shiftwidth'.
opt.shiftwidth = tabstop -- Number of columns that make up one level of (auto)indentation.
opt.smarttab = true -- When enabled, the <Tab> key will indent by 'shiftwidth' if the cursor is in leading whitespace.
opt.softtabstop = tabstop -- Create soft tab stops, separated by 'softtabstop' number of columns.
opt.tabstop = tabstop -- Defines the column multiple used to display the Horizontal Tab character (ASCII 9);
