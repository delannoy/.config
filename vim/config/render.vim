
" [Change the way text is displayed. This is comma separated list of flags](https://vimhelp.org/options.txt.html#%27display%27)
    " lastline      When included, as much as possible of the last line in a window will be displayed. '@@@' is put in the last columns of the last screen line to indicate the rest of the line is not displayed.
set display+=lastline

" [Sets the character encoding used inside Vim. It applies to text in the buffers, registers, Strings in expressions, text stored in the viminfo file, etc. It sets the kind of characters which Vim can work with](https://vimhelp.org/options.txt.html#%27encoding%27)
set encoding=utf-8

" [If on, Vim will wrap long lines at a character in 'breakat' rather than at the last character that fits on the screen. Unlike 'wrapmargin' and 'textwidth', this does not insert <EOL>s in the file, it only affects the way the file is displayed, not its contents](https://vimhelp.org/options.txt.html#%27linebreak%27)
set linebreak

" [Strings to use in 'list' mode and for the :list command. It is a comma separated list of string settings](https://vimhelp.org/options.txt.html#%27listchars%27)
" [What do you use for your listchars?](https://www.reddit.com/4hoa6e/)
    " tab:xy      Two characters to be used to show a tab. The first char is used once. The second char is repeated to fill the space that the tab normally occupies.
    " trail:c     Character to show for trailing spaces.
    " precedes:c  Character to show in the first column, when 'wrap' is off and there is text preceding the character visible in the first column.
    " extends:c   Character to show in the last column, when 'wrap' is off and the line continues beyond the right of the screen.
set list
set listchars=tab:→·,trail:·,precedes:←,extends:→,nbsp:‡

" [Minimal number of screen lines to keep above and below the cursor. This will make some context visible around where you are working](https://vimhelp.org/options.txt.html#%27scrolloff%27)
set scrolloff=4

" [String to put at the start of lines that have been wrapped. Useful values are '> ' or '+++ '](https://vimhelp.org/options.txt.html#%27showbreak%27)
set showbreak=

" [The minimal number of columns to scroll horizontally. Used only when the 'wrap' option is off and the cursor is moved off of the screen](https://vimhelp.org/options.txt.html#%27sidescroll%27)
set sidescroll=80

" [The minimal number of screen columns to keep to the left and to the right of the cursor if 'nowrap' is set. Setting this option to a value greater than 0 while having 'sidescroll' also at a non-zero value makes some context visible in the line you are scrolling in horizontally (except at beginning of the line)](https://vimhelp.org/options.txt.html#%27sidescrolloff%27)
set sidescrolloff=4

" [How do I make opening new tabs the default?](https://vi.stackexchange.com/a/2197)
"   The `++nested` part is required to run autocommands such as `BufRead` for the files we open
"   We don't do any of this if `&diff` is set; if it is, we're using `vimdiff` or `vim -d`, where we want to have 2 windows, and not 2 tabs
"   `tab all` opens all the entries in the argument list (`:args`) in a tab
"   And the `tabfirst` makes sure the first tab is focused rather than the last (this is optional)
augroup openTabs
    autocmd!
    autocmd VimEnter * ++nested if !&diff | tab all | tabfirst | endif
augroup END
