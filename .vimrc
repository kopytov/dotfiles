syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set background=dark
let g:solarized_termtrans=1
colorscheme solarized
if filereadable( expand("~/.vimrc.local") )
    source ~/.vimrc.local
endif
