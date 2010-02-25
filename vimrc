" [cmgr] .vimrc

syntax on

set number
set tabstop=4
set shiftwidth=4
set expandtab
set cindent
set cursorline
set mouse=a " enable middle mouse button paste

set tabpagemax=20

highlight CursorLine cterm=none ctermbg=80
highlight LineNr ctermfg=7 ctermbg=80

map <S-Left> :bp<CR>
map <S-Right> :bn<CR>

map <F10> <Esc>:setlocal spell spelllang=en_au<CR>
map <F11> <Esc>:setlocal nospell<CR>

ab so: std::cout
ab si: std::cin
ab ss: std::string
ab sv: std::vector
ab sm: std::map
ab se: std::endl;

autocmd BufNewFile,BufRead  *.txt set tw=80
autocmd BufNewFile,BufRead  *.tex set tw=80
autocmd BufNewFile,BufRead  *.cc set tw=80
autocmd BufNewFile,BufRead  *.cpp set tw=80
autocmd BufNewFile,BufRead  *.hh set tw=80
autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl

highlight OverLength ctermbg=darkred ctermfg=white
match OverLength /\%>80v.\+\|\s\+$/
" match OverLength /\s\+$/

filetype plugin indent on
