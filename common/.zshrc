# add uv tools dir to path
export PATH="$HOME/.local/bin:$PATH"

# Completion configuration
autoload -Uz compinit
compinit -u

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
PROMPT='%F{blue}(zsh)%f %F{cyan}%n%f@%F{green}toolbox%f:%F{blue}%~%f%(!.#.$) '

# Zsh Autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi


# Key bindings
# Key bindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[2~" overwrite-mode
bindkey "^[[5~" beginning-of-buffer-or-history
bindkey "^[[6~" end-of-buffer-or-history
bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history
bindkey "^[[D" backward-char
bindkey "^[[C" forward-char

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
    
    zstyle ':completion:*:descriptions' format '[%d]'
    # set list-colors to enable filename colorizing
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    # preview command output (e.g. for kill)
    zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
    zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
    zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
    # preview environment variables
    zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
        fzf-preview 'echo ${(P)word}'
    # custom fzf flags
    # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
    zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
    # To make fzf-tab follow FZF_DEFAULT_OPTS.
    # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
    zstyle ':fzf-tab:*' use-fzf-default-opts yes
    # switch group using `<` and `>`
    zstyle ':fzf-tab:*' switch-group '<' '>'
    zstyle ':fzf-tab:complete:*:*' fzf-preview-window down:wrap
fi

# Zsh Syntax Highlighting (Must be last)
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
