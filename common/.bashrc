# Source common shell settings
source "$HOME/shell-common"

# Completion configuration
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Better Tab Completion (readline settings)
# https://askubuntu.com/a/1063994
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

# Auto cd - type directory name to cd into it
shopt -s autocd

# History configuration
HISTFILE=$HOME/.bash_history
HISTFILESIZE=10000
shopt -s histappend
export HISTCONTROL=ignoreboth

# Colored Prompt
# Shell:User @ Host : Directory ($/#)
# Blue Shell, Cyan User, Green Host, Blue Directory, $/#
export PS1='\[\033[01;34m\](bash)\[\033[00m\] \[\033[01;36m\]\u\[\033[00m\]@\[\033[01;32m\]toolbox\[\033[00m\]:\[\033[01;34m\]$PWD\[\033[00m\]
\$ '

# FZF Keybindings (Alpine Path)
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
