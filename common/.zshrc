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


# FZF Configuration
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# FZF Keybindings (Alpine Path)
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

# FZF-Tab Configuration
if [ -f /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]; then
    source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
    
    # Preview directory contents with ls when using cd
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
    # Switch to using ripgrep for previewing file content if you want, or just less
    # zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
    zstyle ':fzf-tab:complete:*:*' fzf-preview-window down:wrap
fi

# Zsh Syntax Highlighting (Must be last)
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
