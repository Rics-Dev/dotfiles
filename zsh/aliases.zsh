# Zsh Aliases
# Converted from Fish configuration

# TMux aliases
alias ta="tmux attach" # Just attach
alias tls="tmux ls" # List sessions

# Function to create a new named TMux session
tn() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: tn <session-name>"
    return 1
  fi
  tmux new -s "$1"
}

# Function to attach to a specific TMux session
ts() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: ts <session-name>"
    return 1
  fi
  tmux attach -t "$1"
}

# Function to kill a specific TMux session
tk() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: tk <session-name>"
    return 1
  fi
  tmux kill-session -t "$1"
}

# Zellij aliases
alias zj="zellij" # Shortcut for zellij
alias zja="zellij attach" # Attach to a session
alias zjs="zellij attach --session-name" # Attach to a named session
alias zjl="zellij list-sessions" # List all sessions
alias zjn="zellij new-session" # Create a new session
alias zjk="zellij kill-session" # Kill a session
alias zjr="zellij run --" # Run a command in a new pane
alias zjf="zellij attach -c" # Create and attach to a new session (floating)
alias zjd="zellij delete-session" # Delete a session
alias zje="zellij edit" # Edit a file in a new pane
alias zjt="zellij attach -c -l compact" # Create and attach to a new session with the "compact" layout
alias zjh="zellij --help" # Show Zellij help

# General aliases
alias ls="eza --icons --color=auto" # Replace ls with eza, enable icons and color
alias la="eza -a --icons --color=auto" # List all files including hidden ones
alias lt="eza -T --icons --color=auto" # List files in a tree format
alias lr="eza -R --icons --color=auto" # List files recursively
alias lg="eza -l --git --icons --color=auto" # List files with Git status
alias lx="eza -l --extended --icons --color=auto" # List files with extended attributes

alias gs="git status" # Check git status
alias ga="git add" # Add files to git staging
alias gcm="git commit -m" # Shortcut for git commit with a message
alias gpo="git push origin" # Push to origin
alias gpl="git pull origin" # Pull from origin
alias gco="git checkout" # Switch branches
alias gb="git branch" # List branches
alias gd="git diff" # Show changes
alias gcl="git clone" # Clone a repository
alias nv="nvim" # Open neovim
alias cl="clear" # Clear the terminal
alias search="rg" # Use ripgrep for fast searching
alias ..="cd .." # Go up one level
alias ...="cd ../.." # Go up two levels
alias ....="cd ../../.." # Go up three levels

alias fzn='nvim $(fzf)'

# Function to safely remove files with confirmation
rmf() {
  echo "Are you sure you want to delete '$1'? (y/n)"
  read confirm
  if [[ "$confirm" == "y" ]]; then
    rm -rf "$1"
  else
    echo "Deletion canceled."
  fi
}

# Function to create a directory and cd into it
mkcd() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: mkcd <directory-name>"
    return 1
  fi
  mkdir -p "$1"
  cd "$1"
}

# Fuzzy find files and open in Neovim (requires bat for preview)
nvf() {
  local file=$(fzf --height 80% --reverse --preview 'bat --color=always --style=numbers --line-range :500 {}' --preview-window right:60%)
  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}

# Fuzzy file finder (insert path at cursor)
fzf-file-widget() {
  local selected=$(fzf --height 40% --reverse --preview 'bat --color=always --style=numbers {}')
  if [[ -n "$selected" ]]; then
    LBUFFER+="${(q)selected}"
  fi
  zle reset-prompt
}
zle -N fzf-file-widget
bindkey '^F' fzf-file-widget

# Fuzzy directory finder (cd into directory)
fzf-dir-widget() {
  local selected=$(fd --type d --hidden | fzf --height 40% --reverse --preview 'tree -C {} | head -200')
  if [[ -n "$selected" ]]; then
    cd "$selected"
    zle reset-prompt
  fi
}
zle -N fzf-dir-widget
bindkey '^[^F' fzf-dir-widget  # Ctrl+Alt+F

# Enhanced history search
fzf-history-widget() {
  local selected=$(history -n 1 | fzf --height 80% --reverse)
  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
    CURSOR=$#BUFFER
  fi
  zle reset-prompt
}
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget

# Attach to zellij session (with ANSI color codes stripped)
fzf-zellij-sessions() {
  local session=$(zellij list-sessions | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}' | fzf --height 20%)
  if [[ -n "$session" ]]; then
    zellij attach "$session"
  fi
}
zle -N fzf-zellij-sessions
bindkey '^Z' fzf-zellij-sessions