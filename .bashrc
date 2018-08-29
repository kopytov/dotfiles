# .bashrc

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc
[[ -f /etc/bash/bashrc ]] && . /etc/bash/bashrc
[[ -f /etc/bash.bashrc ]] && . /etc/bash.bashrc

# User specific aliases and functions
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"
[[ -f "$HOME/.bashrc.local" ]] && . "$HOME/.bashrc.local"

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
[[ "$HOSTNAME" == *.* ]] || HOSTNAME=$( hostname -f )

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

# Tmux or screen prompt
if [ "$TERM" == "screen" ]; then
    PS1=""
fi

# Working directory
PS1="${PS1}\[\033[0;34m\]\W "

# Prompt indicator
PS1="${PS1}\[\033[${color}m\]\\$\[\033[00m\] "

# Window title
if [ $TERM != "linux" ]; then
    PROMPT_COMMAND='echo -ne "\033]0;${title}\007"'
fi

# Git environment variables
if [ $UID -ne 0 ]; then
    export GIT_AUTHOR_NAME="Dmitry Kopytov"
    export GIT_AUTHOR_EMAIL="kopytov@kopytov.ru"
    export GIT_COMMITER_NAME="$GIT_AUTHOR_NAME"
    export GIT_COMMITER_EMAIL="$GIT_AUTHOR_EMAIL"
fi

# Start ssh-agent
AGENT_ENV="$HOME/.ssh-agent.env"
AGENT_LIFETIME=14400  # 4 hours

function ssh_agent_running() {
    test -n "$SSH_AUTH_SOCK" && test -S "$SSH_AUTH_SOCK"
}

function run_ssh_agent() {
    ssh-agent -t "$AGENT_LIFETIME" > "$AGENT_ENV"
    sed -i '/^echo/d' "$AGENT_ENV"
    source "$AGENT_ENV"
}

if [ -n "$TERM" ] && [ "$USER" != "root" ] && ! ssh_agent_running; then
    [ -f "$AGENT_ENV" ] && source "$AGENT_ENV"
    ssh_agent_running || run_ssh_agent
fi

# Setup dircolors
DIRCOLORS=$( type -P dircolors )
[ -n "$DIRCOLORS" ] && eval $( "$DIRCOLORS" "$HOME/.dircolors" )
