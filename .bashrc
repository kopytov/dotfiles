# .bashrc

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc
[[ -f /etc/bash/bashrc ]] && . /etc/bash/bashrc
[[ -f /etc/bash.bashrc ]] && . /etc/bash.bashrc

# User specific aliases and functions
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"

# Enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Setting umask
umask 0022

###
### Customizing command prompt
###

PS1=""

# Color of prompt
color=""
if [ $UID -eq 0 ]; then
    color="0;31"
else
    color="0;32"
fi

# Owner & location
IFS="." read -ra domains <<< "$HOSTNAME"
if [ ${#domains[@]} -gt 2 ]; then
    hostname=${domains[0]}
    location=${domains[1]}
    if [ ${#location} -eq 1 ] && [ ${#domains[@]} -gt 3 ]; then
        owner=${domains[2]}
    else
        owner="$location"
        unset location
    fi

    if [ -z "$location" ]; then
        PS1="\[\033[${color}m\][${owner}] "
        title="[$owner] $hostname"
    else
        PS1="\[\033[${color}m\][${owner} ${location}] "
        title="[$owner $location] $hostname"
    fi
else
    hostname=${HOSTNAME}
    title=$hostname
fi

# Username and hostname
if [ -n "$SUDO_USER" ] && [ $EUID -gt 0 ]; then
    PS1="${PS1}\[\033[0;33m\]\u@${hostname} "
else
    PS1="${PS1}\[\033[0;33m\]${hostname} "
fi

# Working directory
PS1="${PS1}\[\033[0;34m\]\W "

# Prompt indicator
PS1="${PS1}\[\033[${color}m\]\\$\[\033[00m\] "

# Window title
PROMPT_COMMAND='echo -ne "\e]0;${title}\a"'
