export PATH=/home/ric/.local/bin:$PATH
# export PATH="/opt/flutter/bin:$PATH"
# export ANDROID_HOME=/home/ric/Android/Sdk
# export PATH=$ANDROID_HOME/platform-tools:$PATH

# -----------------------------------------------------
# Fastfetch if on wm
# -----------------------------------------------------
if [[ $(tty) == *"pts"* ]]; then
    fastfetch --config ~/.config/fastfetch/example13.jsonc
fi




# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(oh-my-posh init zsh --config ~/.cache/oh-my-posh/themes/robbyrussell.omp.json)"



# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vi='nvim'
alias c='clear'
alias f="fzf --preview='bat --color=always {}'"
alias zshc='nvim .zshrc'




#export PATH="$PATH":"$HOME/.pub-cache/bin"
export CHROME_EXECUTABLE=/usr/bin/chromium
export EDITOR=nvim
export PATH="$PATH:/home/ric/.turso"
# bun completions
[ -s "/home/ric/.bun/_bun" ] && source "/home/ric/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
