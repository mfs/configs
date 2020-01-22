
packadd minpac
call minpac#init()

call minpac#add('k-takata/minpac', {'type':'opt'})

call minpac#add('bling/vim-airline')
call minpac#add('airblade/vim-gitgutter')
call minpac#add('kien/ctrlp.vim')
call minpac#add('w0rp/ale')

call minpac#add('tpope/vim-sleuth')
call minpac#add('tpope/vim-fugitive')
call minpac#add('rust-lang/rust.vim')
call minpac#add('Raimondi/delimitMate')

call minpac#add('racer-rust/vim-racer')
call minpac#add('pangloss/vim-javascript')
call minpac#add('mxw/vim-jsx')
call minpac#add('elzr/vim-json')
call minpac#add('tikhomirov/vim-glsl')
call minpac#add('LeonB/vim-nginx')
call minpac#add('saltstack/salt-vim')
"call minpac#add('zxqfl/tabnine-vim')


let g:airline_powerline_fonts = 1

set laststatus=2

syntax on
set number
set textwidth=80
set cindent
set cursorline
set hlsearch
set mouse=r " enable middle mouse button paste
set hidden

set list
set listchars=tab:\|\ 

let g:jsx_ext_required = 0

" runtime syntax/colortest.vim
" :so $VIMRUNTIME/syntax/hitest.vim
highlight CursorLine cterm=none ctermbg=233
highlight LineNr ctermfg=7 ctermbg=233
highlight Pmenu ctermfg=0 ctermbg=7
highlight PmenuSel ctermfg=0 ctermbg=2
highlight SpecialKey ctermfg=241
highlight MatchParen ctermbg=238 ctermfg=45
highlight Search ctermbg=238 ctermfg=45

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

command Run :tabnew | setlocal buftype=nofile | r ! #:p

highlight TrailingSpaces ctermbg=darkred ctermfg=white
match TrailingSpaces /\s\+$/

" vims yaml syntax highlighting performance is crap
"autocmd FileType yaml set syntax=off

autocmd FileType javascript setl shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab
autocmd FileType python setl shiftwidth=4 tabstop=4 softtabstop=4 expandtab
