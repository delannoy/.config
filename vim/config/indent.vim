
" [Every wrapped line will continue visually indented (same amount of space as the beginning of that line), thus preserving horizontal blocks of text](https://vimhelp.org/options.txt.html#%27breakindent%27)
" set breakindent

" [This is a sequence of letters which describes how automatic formatting is to be done](https://vimhelp.org/options.txt.html#%27formatoptions%27)
" ['formatoptions' is a string that can contain any of the letters below](https://vimhelp.org/change.txt.html#fo-table)
"   l       Long lines are not broken in insert mode: When a line was longer than 'textwidth' when the insert command started, Vim does not automatically format it.
set formatoptions=l

" [In Insert mode: Use the appropriate number of spaces to insert a <Tab>. Spaces are used in indents with the '>' and '<' commands and when 'autoindent' is on.](https://vimhelp.org/options.txt.html#%27expandtab%27)
set expandtab

" [Maximum width of text that is being inserted. A longer line will be broken after white space to get this width. A zero value disables this.](https://vimhelp.org/options.txt.html#%27textwidth%27)
set textwidth=0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" [When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'. 'tabstop' or 'softtabstop' is used in other places. A <BS> will delete a 'shiftwidth' worth of space at the start of the line](https://vimhelp.org/options.txt.html#%27smarttab%27)
set smarttab

" [Number of spaces to use for each step of (auto)indent](https://vimhelp.org/options.txt.html#%27shiftwidth%27)
set shiftwidth=4

" [Number of spaces that a <Tab> in the file counts for](https://vimhelp.org/options.txt.html#%27tabstop%27)
set tabstop=4

" [Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>. It 'feels' like <Tab>s are being inserted, while in fact a mix of spaces and <Tab>s is used.](https://vimhelp.org/options.txt.html#%27softtabstop%27)
set softtabstop=4

" [Round indent to multiple of 'shiftwidth'. Applies to > and < commands.](https://vimhelp.org/options.txt.html#%27shiftround%27)
set shiftround

" [specifies the key sequence that toggles the 'paste' option](https://vimhelp.org/options.txt.html#%27pastetoggle%27)
set pastetoggle=<F2>
        " Paste mode [...] is useful if you want to cut or copy some text from one window and paste it in Vim. This will avoid unexpected effects.
        " [https://vimhelp.org/options.txt.html#%27paste%27] [https://stackoverflow.com/a/2514520]

if has("patch-7.4.354")
    " Word-wrap preserving indentation [https://stackoverflow.com/a/26578161]
    set breakindent
        " Every wrapped line will continue visually indented (same amount of space as the beginning of that line), thus preserving horizontal blocks of text
        " [https://vimhelp.org/options.txt.html#%27breakindent%27]
    set formatoptions=l
        " This is a sequence of letters which describes how automatic formatting is to be done
        " [https://vimhelp.org/options.txt.html#%27formatoptions%27]
            " l     Long lines are not broken in insert mode: When a line was longer than 'textwidth' when the insert command started, Vim does not automatically format it.
            "       [https://vimhelp.org/change.txt.html#fo-table]
    set linebreak
        " Wrap long lines at a character in 'breakat' rather than at the last character that fits on the screen
        " Unlike 'wrapmargin' and 'textwidth', this does not insert <EOL>s in the file, it only affects the way the file is displayed, not its contents.
        " [https://vimhelp.org/options.txt.html#%27linebreak%27]
endif

" filetype plugin on
"     " Loads the plugin file ["ftplugin.vim" in 'runtimepath'] for specific file types
"     " [https://vimhelp.org/filetype.txt.html#filetype-plugins] [https://vi.stackexchange.com/a/10125]
"     " causes vim to wrap inserted text at column 78 [https://vi.stackexchange.com/a/2786]
"         " :echo &textwidth [https://learnvimscriptthehardway.stevelosh.com/chapters/19.html]
"         " :verbose set textwidth?
"             " textwidth=78
"             " Last set from /usr/share/vim/vim80/ftplugin/vim.vim
"     " autocmd FileType text set textwidth=0 [https://vi.stackexchange.com/a/9266]
"     if empty(glob($VIMHOME.'/after/ftplugin/vim.vim'))
"         " [https://vimways.org/2018/from-vimrc-to-vim/]
"         silent !mkdir -p "${VIMHOME}/after/ftplugin/"
"         silent !echo 'set textwidth=0' > "${VIMHOME}/after/ftplugin/vim.vim"
"     endif

" [Copy indent from current line when starting a new line (typing <Return> in Insert mode or when using the 'o' or 'O' command)](https://vimhelp.org/options.txt.html#%27autoindent%27)
" set autoindent

" [Do smart autoindenting when starting a new line. Works for C-like programs, but can also be used for other languages.](https://vimhelp.org/options.txt.html#%27smartindent%27)
" set smartindent

" [Enables automatic C program indenting. See 'cinkeys' to set the keys that trigger reindenting in insert mode and 'cinoptions' to set your preferred indent style.](https://vimhelp.org/options.txt.html#%27cindent%27) [https://vimhelp.org/indent.txt.html#C-indenting]
" set cindent

" [A list of keys that, when typed in Insert mode, cause reindenting of the current line. Only used if 'cindent' is on and 'indentexpr' is empty](https://vimhelp.org/options.txt.html#%27cinkeys%27) [https://vimhelp.org/indent.txt.html#cinkeys-format]
" set cinkeys="0{,0},0),0],:,0#,!^F,o,O,e"

" [Sets how Vim performs indentation](https://vimhelp.org/indent.txt.html#cinoptions-values) [https://vimhelp.org/options.txt.html#%27cinoptions%27]
" set cinoptions=(0,l1,j1

" [Expression which is evaluated to obtain the proper indent for a line. It is used when a new line is created, for the |=| operator and in Insert mode as specified with the 'indentkeys' option](https://vimhelp.org/options.txt.html#%27indentexpr%27) [http://vimhelp.org/options.html#%27indentexpr%27]
" set indentexpr

