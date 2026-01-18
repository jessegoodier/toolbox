# add uv tools dir to path
export PATH="/root/.local/bin:$PATH"

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

# History configuration
HISTFILE=$HOME/.bash_history
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend
export HISTCONTROL=ignoreboth

# Colored Prompt
# Shell:User @ Host : Directory ($/#)
# Blue Shell, Cyan User, Green Host, Blue Directory, $/#
export PS1='\[\033[01;34m\](bash)\[\033[00m\] \[\033[01;36m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# FZF Configuration
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# FZF Keybindings (Alpine Path)
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'