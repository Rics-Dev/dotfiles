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

# # Jujutsu (jj) aliases - Modern version (using bookmarks instead of branches)
# alias js="jj status" # Check working copy status (replaces git status)
# alias jst="jj status" # Alternative short form
# alias jd="jj diff" # Show changes (replaces git diff)
# alias jc="jj commit -m" # Create new commit with message (replaces git commit -m)
# alias jdesc="jj describe -m" # Update current commit message
# alias jn="jj new" # Create new change (like git checkout -b but better)
# alias je="jj edit" # Edit a specific change (like git checkout)
# alias jl="jj log" # Show commit history (better than git log)
# alias jll="jj log --limit 10" # Show last 10 commits
# alias jlg="jj log --graph" # Show graphical log
#
# # Bookmark aliases (replacing old branch commands)
# alias jb="jj bookmark list" # List bookmarks (replaces git branch)
# alias jbc="jj bookmark create" # Create new bookmark
# alias jbd="jj bookmark delete" # Delete bookmark
# alias jbs="jj bookmark set" # Set bookmark to current commit
# alias jbm="jj bookmark move" # Move bookmark to current commit
# alias jbr="jj bookmark rename" # Rename bookmark
# alias jbt="jj bookmark track" # Track remote bookmark
#
# # Git interop aliases
# alias jp="jj git push" # Push to remote (replaces git push origin)
# alias jf="jj git fetch" # Fetch from remote (replaces git pull origin - part 1)
# alias jr="jj rebase" # Rebase changes
# alias ju="jj git fetch && jj rebase" # Update from remote (replaces git pull)
# alias jcl="jj git clone" # Clone repository (replaces git clone)
# alias jinit="jj git init --colocate" # Initialize jj repo in existing git repo
#
# # Other jj commands
# alias jsh="jj show" # Show commit details
# alias jab="jj abandon" # Abandon current change
# alias jundo="jj undo" # Undo last operation
# alias jop="jj operation log" # Show operation history
# alias jsq="jj squash" # Squash changes into parent
# alias jsp="jj split" # Split current change
# alias jdup="jj duplicate" # Duplicate current change
# alias jres="jj resolve" # Resolve merge conflicts
# alias jinter="jj interdiff" # Show interdiff between commits
#
# # Advanced jj workflows
# alias jfix="jj describe -m 'fixup'" # Quick fixup commit
# alias jwip="jj describe -m 'WIP'" # Work in progress commit
#
# # Helper function to initialize jj in existing git repos
# function jj-init-here
#     if test -d .git
#         echo "🔄 Initializing jj in existing git repo..."
#         jj git init --colocate
#         echo "✅ jj repo created! You can now use jj commands alongside git."
#     else
#         echo "❌ No git repository found. Use 'jj git clone' or create a new repo first."
#     end
# end
#
# # Learning helpers - these will remind you of jj equivalents
# function git
#     echo "🔄 Learning jj! Here's the jj equivalent:"
#     switch $argv[1]
#         case status
#             echo "  jj status (alias: js)"
#         case add
#             echo "  jj doesn't need 'add' - files are automatically tracked!"
#             echo "  Just use: jj commit -m 'message' (alias: jc)"
#         case "commit"
#             if test "$argv[2]" = "-m"
#                 echo "  jj commit -m 'message' (alias: jc)"
#             else
#                 echo "  jj commit (alias: jc for with message)"
#             end
#         case push
#             echo "  jj git push (alias: jp)"
#         case pull
#             echo "  jj git fetch && jj rebase (alias: ju for update)"
#         case checkout
#             echo "  jj edit <commit> (alias: je) or jj new (alias: jn) for new change"
#         case branch
#             echo "  jj bookmark list (alias: jb) - note: jj uses 'bookmarks' not 'branches'"
#         case diff
#             echo "  jj diff (alias: jd)"
#         case clone
#             echo "  jj git clone (alias: jcl)"
#         case log
#             echo "  jj log (alias: jl, jll for last 10, jlg for graph)"
#         case init
#             echo "  jj git init --colocate (alias: jinit) for existing git repos"
#             echo "  or jj init for new repos"
#         case "*"
#             echo "  Check 'jj help' or your jj aliases!"
#     end
#
#     # Check if we're in a git repo that could be initialized with jj
#     if test -d .git; and not test -d .jj
#         echo ""
#         echo "💡 This is a git repo! You can run 'jj-init-here' to start using jj alongside git."
#     end
#
#     echo ""
#     echo "Run the git command anyway? (y/n)"
#     read -l response
#     if test "$response" = "y"
#         command git $argv
#     end
# end
#
# # Git aliases (commented out to encourage jj learning)
# # Uncomment these if you need to use git occasionally
# # alias gs="git status" # Use 'js' for jj status instead
# # alias ga="git add" # jj doesn't need staging - files auto-tracked
# # alias gcm="git commit -m" # Use 'jc' for jj commit -m instead
# # alias gpo="git push origin" # Use 'jp' for jj git push instead
# # alias gpl="git pull origin" # Use 'ju' for jj update instead
# # alias gco="git checkout" # Use 'je' for jj edit or 'jn' for jj new instead
# # alias gb="git branch" # Use 'jb' for jj bookmark list instead
# # alias gd="git diff" # Use 'jd' for jj diff instead
# # alias gcl="git clone" # Use 'jcl' for jj git clone instead
#
# # Quick jj learning function
# function jj-learn
#     echo "🎓 Jujutsu Quick Reference (Modern Commands):"
#     echo ""
#     echo "Getting Started:"
#     echo "  jj-init-here   - Initialize jj in existing git repo"
#     echo "  jinit          - Same as above (jj git init --colocate)"
#     echo "  jcl <url>      - Clone a repository"
#     echo ""
#     echo "Basic workflow:"
#     echo "  js             - Check status"
#     echo "  jd             - See changes"
#     echo "  jc 'msg'       - Commit with message"
#     echo "  jp             - Push to remote"
#     echo "  ju             - Update from remote (fetch + rebase)"
#     echo ""
#     echo "Navigation:"
#     echo "  jl             - Show history"
#     echo "  jll            - Show last 10 commits"
#     echo "  je <commit>    - Switch to commit"
#     echo "  jn             - Create new change"
#     echo ""
#     echo "Bookmarks (not branches!):"
#     echo "  jb             - List bookmarks"
#     echo "  jbc <name>     - Create bookmark"
#     echo "  jbs <name>     - Set bookmark to current commit"
#     echo "  jbm <name>     - Move bookmark to current commit"
#     echo "  jbd <name>     - Delete bookmark"
#     echo ""
#     echo "Advanced:"
#     echo "  jundo          - Undo last operation"
#     echo "  jab            - Abandon current change"
#     echo "  jsp            - Split current change"
#     echo "  jsq            - Squash into parent"
#     echo "  jdup           - Duplicate current change"
#     echo "  jop            - Show operation history"
#     echo ""
#     echo "For more: jj help"
#     echo ""
#     echo "💡 Remember: jj uses 'bookmarks' instead of 'branches'"
#     echo "💡 No staging area needed - all changes are automatically tracked"
# end


# General aliases
alias ls="eza --icons --color=auto" # Replace ls with eza, enable icons and color
alias ll="eza -la --icons --color=auto" # List all files in long format with icons and color
alias la="eza -a --icons --color=auto" # List all files including hidden ones
alias lt="eza -T --icons --color=auto" # List files in a tree format
alias lr="eza -R --icons --color=auto" # List files recursively
alias lg="eza -l --git --icons --color=auto" # List files with Git status
alias lx="eza -l --extended --icons --color=auto" # List files with extended attributes

alias v="nvim" # Open neovim
alias vim="nvim" # Open neovim
alias nv="nvim" # Open neovim
alias cl="clear" # Clear the terminal
alias search="rg" # Use ripgrep for fast searching
alias -- ..="cd .." # Go up one level
alias -- ...="cd ../.." # Go up two levels
alias -- ....="cd ../../.." # Go up three levels
alias py="python3"

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
