syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set background=dark
if filereadable( expand("~/.vimrc.local") )
    source ~/.vimrc.local
endif
