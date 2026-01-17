# add uv tools dir to path
export PATH="/root/.local/bin:$PATH"

# Completion configuration
autoload -Uz compinit
compinit

# History configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Colored Prompt
autoload -Uz colors && colors
# User @ Host : Directory $
PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{blue}%~%f$ '

# Zsh Autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Zsh Syntax Highlighting (Must be last)
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
