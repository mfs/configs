" [cmgr] .vimrc

syntax on

set number
set tabstop=4
set shiftwidth=4
set expandtab
set textwidth=80
set cindent
set cursorline
set hlsearch
set mouse=a " enable middle mouse button paste

" runtime syntax/colortest.vim
" :so $VIMRUNTIME/syntax/hitest.vim
highlight CursorLine cterm=none ctermbg=233
highlight LineNr ctermfg=7 ctermbg=233
highlight Pmenu ctermfg=0 ctermbg=7
highlight PmenuSel ctermfg=0 ctermbg=2

map <S-Left> :bp<CR>
map <S-Right> :bn<CR>

map <F1>  <Esc>:tab help<CR>
map <F2>  <Esc>:Run<CR>
map <F5>  <Esc>:make<CR>

map <F8>  <Esc>:tabnew ~/.vimrc<CR>
map <F9>  <Esc>:hardcopy<CR>
map <F10> <Esc>:nohlsearch<CR>
map <F11> <Esc>:setlocal paste!<CR>
map <F12> <Esc>:setlocal spell! spelllang=en_au<CR>

cabbrev help tab help

command Run :tabnew | setlocal buftype=nofile | r ! #:p

autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl

highlight OverLength ctermbg=darkred ctermfg=white
match OverLength /\%>80v.\+\|\s\+$/

filetype plugin indent on
