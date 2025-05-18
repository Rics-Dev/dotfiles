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

# Ctrl+T - Fuzzy find and attach to tmux sessions
function fzf-tmux-sessions --description "Fuzzy-find and manage tmux sessions"
    # Check if tmux is installed
    if not command -v tmux >/dev/null
        echo "tmux is not installed."
        return 1
    end

    # Check if there are any tmux sessions
    if not tmux list-sessions >/dev/null 2>&1
        echo "No tmux sessions found. Create a new one with 'tn <session-name>'."
        return 1
    end

    # Get session names only (simpler format for fzf)
    set -l sessions (tmux list-sessions -F "#{session_name}")

    # Construct fzf command with preview and keybindings
    set -l selected (printf '%s\n' $sessions | fzf \
        --height 50% \
        --reverse \
        --prompt='Select tmux session > ' \
        --header='Enter: Attach | Ctrl-K: Kill ' \
        --bind='ctrl-k:execute(tmux kill-session -t {} >/dev/null 2>&1)+reload(tmux list-sessions -F "#{session_name}")')

    # If a session was selected, attach to it
    if test -n "$selected"
        tmux attach-session -t "$selected" >/dev/null 2>&1
    end

    # Repaint commandline to refresh prompt
    commandline -f repaint
end
bind \ct fzf-tmux-sessions

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
alias v="nvim" # Open neovim
alias nv="nvim" # Open neovim
alias cl="clear" # Clear the terminal
alias search="rg" # Use ripgrep for fast searching
alias -- ..="cd .." # Go up one level
alias -- ...="cd ../.." # Go up two levels
alias -- ....="cd ../../.." # Go up three levels

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
    commandline -f repaint
end
bind \cl y



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

# Fuzzy find files and open in Neovim (requires bat for preview)
function nvf
    set -l file (fzf --height 80% --reverse --preview 'bat --color=always --style=numbers --line-range :500 {}' --preview-window right:60%)
    if test -n "$file"
        nvim $file
    end
        commandline -f repaint
end
bind \cv nvf

# Ctrl+F - Fuzzy file finder (cd into directory)
function fzf-dev
    set -l dir "$HOME/Developer"
    set -l selected (fd . $dir --type d | fzf --height 40% --reverse --preview 'bat --color=always --style=numbers {}')
    if test -n "$selected"
        cd "$selected"
    end
    commandline -f repaint
end
bind \cf fzf-dev


function fzf-dotfiles
    set -l dir "$HOME/.dotfiles"
    set -l selected (fd . $dir --type f | fzf --height 40% --reverse --preview 'bat --color=always --style=numbers {}')
    if test -n "$selected"
        nvim "$selected"
    end
        commandline -f repaint
    commandline -f repaint
end
bind \co fzf-dotfiles


# Fuzzy file finder (insert path at cursor)
function fzf-file-widget
    set -l dir (pwd)
    set -l selected (fzf --height 40% --reverse --preview 'bat --color=always --style=numbers {}')
    if test -n "$selected"
        commandline -i -- (string escape "$selected")
    end
    commandline -f repaint
end
bind \e\cf fzf-file-widget



function ff
    command  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
    commandline -f repaint
end


# Ctrl+Z - Attach to zellij session (with ANSI color codes stripped)
function fzf-zellij-sessions
    zellij list-sessions | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}' | fzf --height 20% | read -l session
    if test -n "$session"
        zellij attach $session
    end
end
bind \cz fzf-zellij-sessions


function remu
    set -l avds (emulator -list-avds)
    if test (count $avds) -eq 0
        echo "No AVDs found."
        return 1
    end

    set -l selected (printf '%s\n' $avds | fzf --height 40% --reverse --prompt="Select emulator > ")
    if test -n "$selected"
        echo "Starting emulator: $selected"
        command emulator -avd $selected
    else
        echo "No emulator selected."
    end
end


function resim
    set -l devices (xcrun simctl list devices available | grep -E "Booted|Shutdown" | awk -F '[()]' '{print $1 " (" $2 ")"}' | sed 's/ *$//')
    if test (count $devices) -eq 0
        echo "No available iOS simulators found."
        return 1
    end

    set -l selected (printf '%s\n' $devices | fzf --height 40% --reverse --prompt="Select iOS simulator > ")
    if test -n "$selected"
        set -l udid (xcrun simctl list devices | grep "$selected" | awk -F '[()]' '{print $3}')
        echo "Booting iOS simulator: $selected"
        open -a Simulator
        xcrun simctl boot $udid 2>/dev/null
    else
        echo "No simulator selected."
    end
end


# Ctrl+R - Enhanced history search
# function fzf-history-widget
#     history | fzf --height 80% --reverse | read -l command
#     if test -n "$command"
#         commandline -rb $command
#     end
# end
# bind \cr fzf-history-widget
