" [cmgr] .vimrc

set nocompatible              " required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sleuth.git'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'airblade/vim-gitgutter.git'
Plugin 'Raimondi/delimitMate'
Plugin 'rust-lang/rust.vim'

call vundle#end()            " required
filetype plugin indent on    " required

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

autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl

highlight TrailingSpaces ctermbg=darkred ctermfg=white
match TrailingSpaces /\s\+$/

filetype plugin indent on

" vims yaml syntax highlighting performance is crap
autocmd FileType yaml set syntax=off
