
" Toggle color highlight for column 80
" ['colorcolumn' is a comma separated list of screen columns that are highlighted with ColorColumn hl-ColorColumn](https://vimhelp.org/options.txt.html#%27colorcolumn%27)
nnoremap <expr> <leader>80 (&colorcolumn) ? ':set colorcolumn=0<Return>' : ':set colorcolumn=80<Return>'

" [Toggle cursorline and cursorcolumn](https://vim.fandom.com/wiki/Highlight_current_line#Highlighting_that_moves_with_the_cursor)
nnoremap <leader> c :set cursorline! cursorcolumn! <Return>

" [Toggle search highlight](https://stackoverflow.com/a/26504944/13019084)
nnoremap <expr> <leader>/ (&hlsearch && v:hlsearch) ? ':nohlsearch<Return>' : ':set hlsearch<Return>'

" Clear search highlight
nnoremap <leader> <esc> :nohlsearch<Return>

" [Edit or source $VIMRC](https://learnvimscriptthehardway.stevelosh.com/chapters/07.html#editing-your-vimrc)
nnoremap <leader> ev :vsplit $VIMRC<cr>
nnoremap <leader> sv :source $VIMRC<cr>

" Toggle virtualedit
" [Virtual editing means that the cursor can be positioned where there is no actual character](https://vimhelp.org/options.txt.html#%27virtualedit%27)
" [Vim 101: Virtual Editing](https://medium.com/usevim/vim-101-virtual-editing-661c99c05847)
" [Visual Block Mode: How to insert text to multiple lines after line ending?](https://vi.stackexchange.com/a/18184)
" [Visual block insert into multiple areas with no text with virtualedit=all](https://vi.stackexchange.com/a/6080)
nnoremap <expr> <leader>v (&virtualedit == '') ? ':set virtualedit=all<Return>' : ':set virtualedit=<Return>'

" Toggle text wrapping
" [This option changes how text is displayed. It doesn't change the text in the buffer, see 'textwidth' for that. When on, lines longer than the width of the window will wrap and displaying continues on the next line. When off lines will not wrap and only part of long lines will be displayed. When the cursor is moved to a part that is not shown, the screen will scroll horizontally. The line will be broken in the middle of a word if necessary. See 'linebreak' to get the break at a word boundary.](https://vimhelp.org/options.txt.html#%27wrap%27)
nnoremap <F3> :set wrap! <Return>

" Tab navigation [https://medium.com/@hql287/10-vim-tips-to-ease-the-learning-curve-c8234cbdafa5] [https://yanpritzker.com/stop-using-colon-commands-in-vim-ddfd62a22216]
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
nnoremap <leader>10 10gt
nnoremap <leader>11 11gt
nnoremap <leader>12 12gt
nnoremap <leader>13 13gt
nnoremap <leader>14 14gt
nnoremap <leader>15 15gt
nnoremap <leader>16 16gt
nnoremap <leader>17 17gt
nnoremap <leader>18 18gt
nnoremap <leader>19 19gt
