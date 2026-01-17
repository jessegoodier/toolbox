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
# User @ Host : Directory $
# Cyan User, Green Host, Blue Directory
export PS1='\[\033[01;36m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '
