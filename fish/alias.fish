# ~/.config/fish/alias.fish

# TMux aliases
alias ta="tmux attach" # Just attach
alias tls="tmux ls" # List sessions
# Function to create a new named TMux session
function tn
    if test (count $argv) -eq 0
        echo "Usage: tn <session-name>"
        return 1
    end
    tmux new -s $argv[1]
end

# Function to attach to a specific TMux session
function ts
    if test (count $argv) -eq 0
        echo "Usage: ts <session-name>"
        return 1
    end
    tmux attach -t $argv[1]
end

# Function to kill a specific TMux session
function tk
    if test (count $argv) -eq 0
        echo "Usage: tk <session-name>"
        return 1
    end
    tmux kill-session -t $argv[1]
end

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
alias ll="eza -la --icons --color=auto" # List all files in long format with icons and color
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
alias hx="helix" # Open helix
alias cl="clear" # Clear the terminal
alias search="rg" # Use ripgrep for fast searching
alias -- ..="cd .." # Go up one level
alias -- ...="cd ../.." # Go up two levels
alias -- ....="cd ../../.." # Go up three levels


function rmf
    echo "Are you sure you want to delete '$argv'? (y/n)"
    read confirm
    if test "$confirm" = y
        command rm -rf $argv
    else
        echo "Deletion canceled."
    end
end


# Function to create a directory and cd into it
function mkcd
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory-name>"
        return 1
    end
    mkdir -p $argv[1]
    cd $argv[1]
end
