[ -f ~/.bashrc       ] && source ~/.bashrc
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH
