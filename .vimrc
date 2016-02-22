" ========= Vundle Start ========
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rust-lang/rust.vim'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'Raimondi/delimitMate'

call vundle#end()
filetype plugin indent on
" ======== Vundle End ========

set laststatus=2

syntax on
set number
set textwidth=80
set cindent
set cursorline
set hlsearch
set mouse=r " enable middle mouse button paste

" runtime syntax/colortest.vim
" :so $VIMRUNTIME/syntax/hitest.vim
highlight CursorLine cterm=none ctermbg=233
highlight LineNr ctermfg=7 ctermbg=233
highlight Pmenu ctermfg=0 ctermbg=7
highlight PmenuSel ctermfg=0 ctermbg=2

highlight clear SignColumn

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

highlight TrailingSpaces ctermbg=darkred ctermfg=white
match TrailingSpaces /\s\+$/

" vims yaml syntax highlighting performance is crap
autocmd FileType yaml set syntax=off
