# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/ric/.zsh/completions:"* ]]; then export FPATH="/Users/ric/.zsh/completions:$FPATH"; fi
# Zsh Configuration
# Converted from Fish configuration

# Zsh-specific settings
# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_SPACE      # Don't record commands starting with space
setopt HIST_IGNORE_DUPS       # Don't record duplicated commands
setopt HIST_FIND_NO_DUPS      # Don't show duplicates when searching
setopt HIST_REDUCE_BLANKS     # Remove unnecessary blanks
setopt EXTENDED_HISTORY       # Record command start time

# Completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion

# Key bindings
bindkey -e                     # Use emacs key bindings
bindkey '^[[A' up-line-or-search    # Up arrow for history search
bindkey '^[[B' down-line-or-search  # Down arrow for history search


# Colors and syntax highlighting
# Enable color support
autoload -U colors && colors

# Basic color definitions for prompts
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Load syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || \
source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Colored ls output
alias ls="ls --color=auto"
alias ll="ls -la --color=auto"

# Colored grep output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Add color to man pages
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\e[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\e[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline


# Environment Variables
export ANDROID_HOME="$HOME/Library/Android/Sdk"
export EMULATORS="$ANDROID_HOME/emulator"
export FLUTTER="$HOME/Developer/tools/flutter/bin"
export HOMEBREW="/opt/homebrew/bin"
export NODE="/opt/homebrew/opt/node@22/bin"
export GEM_HOME="/opt/homebrew/lib/ruby/gems/3.4.0"
export GEM_BIN="$GEM_HOME/bin"
export RUBY="/opt/homebrew/opt/ruby/bin"
export LDFLAGS="-L/opt/homebrew/opt/node@22/lib -L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/node@22/include -I/opt/homebrew/opt/ruby/include"
export POSTGRESQL="/Library/PostgreSQL/17/bin"
export MYSQL="/usr/local/mysql/bin/"
export BUN="$HOME/.bun/bin"

# Path Management
path=(
  "$GEM_BIN"
  "$FLUTTER"
  "$NODE"
  "$RUBY"
  "$BUN"
  "$MYSQL"
  "$HOMEBREW"
  "$EMULATORS"
  "$POSTGRESQL"
  "$ANDROID_HOME"
  $path
)

# Source aliases and utilities
[[ -f "$HOME/.dotfiles/zsh/aliases.zsh" ]] && source "$HOME/.dotfiles/zsh/aliases.zsh"

# Source rustup
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Source atuin
[[ -f "$HOME/.atuin/bin/env.sh" ]] && source "$HOME/.atuin/bin/env.sh"

# Initialize tools if they exist
# Zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Atuin
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

# Starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Run fastfetch if in a terminal
# if [[ $(tty) == *pts* ]]; then
#   fastfetch --config ~/.config/fastfetch/example13.jsonc
# fi

# Yazi file manager function
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if [[ -f "$tmp" ]]; then
    local cwd="$(cat -- "$tmp")"
    if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
      cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  fi
}
. "/Users/ric/.deno/env"