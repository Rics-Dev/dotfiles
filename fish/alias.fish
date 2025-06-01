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

# Ctrl+T - Television-powered tmux session management
function tv-tmux-sessions --description "Television-powered tmux session management"
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

    # Use television to select session with preview
    set -l selected (tmux list-sessions -F "#{session_name}" | tv --preview 'tmux list-windows -t {0} -F "#{window_index}: #{window_name} #{?window_active,(active),}"')

    # If a session was selected, attach to it
    if test -n "$selected"
        tmux attach-session -t "$selected" >/dev/null 2>&1
    end

    # Repaint commandline to refresh prompt
    commandline -f repaint
end
bind \e\ct tv-tmux-sessions

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


# Git function to add all, commit, and push in one command
function gacp
    if test (count $argv) -eq 0
        echo "Usage: gacp <commit-message>"
        echo "Example: gacp 'Fix bug in user authentication'"
        return 1
    end
    
    # Add all changes
    git add .
    
    # Commit with the provided message
    git commit -m "$argv"
    
    # Push to the current branch
    git push
    
    echo "✅ Successfully added, committed, and pushed changes!"
end

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

# Ctrl+V - Television-powered file finder and open in Neovim
function tv-nvim-files --description "Television-powered file finder for Neovim"
    set -l file (tv files --preview 'bat --color=always --style=numbers --line-range :50 {0}')
    if test -n "$file"
        nvim $file
    end
    commandline -f repaint
end
bind \cv tv-nvim-files

# Ctrl+F - Television-powered directory navigation to ~/Developer
function tv-dev-dirs --description "Television-powered Developer directory navigation"
    set -l dir "$HOME/Developer"
    if not test -d "$dir"
        echo "Developer directory not found at $dir"
        return 1
    end
    
    set -l selected (fd . $dir --type d | tv --preview 'eza -la --icons {0} | head -20')
    if test -n "$selected"
        cd "$selected"
    end
    commandline -f repaint
end
bind \cf tv-dev-dirs

# Ctrl+O - Television-powered dotfiles editor
function tv-dotfiles --description "Television-powered dotfiles editor"
    set -l dir "$HOME/.dotfiles"
    if not test -d "$dir"
        echo "Dotfiles directory not found at $dir"
        return 1
    end
    
    set -l selected (fd . $dir --type f | tv --preview 'bat --color=always --style=numbers --line-range :50 {0}')
    if test -n "$selected"
        nvim "$selected"
    end
    commandline -f repaint
end
bind \co tv-dotfiles

# Alt+Ctrl+F - Television file widget (insert path at cursor)
function tv-file-widget --description "Television file widget - insert path at cursor"
    set -l selected (tv files --preview 'bat --color=always --style=numbers --line-range :30 {0}')
    if test -n "$selected"
        commandline -i -- (string escape "$selected")
    end
    commandline -f repaint
end
bind \e\cf tv-file-widget

# Television-powered window focus (using aerospace)
function ff --description "Television-powered window focus with aerospace"
    if not command -v aerospace >/dev/null
        echo "aerospace is not installed."
        return 1
    end
    
    set -l window (aerospace list-windows --all | tv --preview 'echo "Window ID: {1}\nApp: {2}\nTitle: {3}"')
    if test -n "$window"
        set -l window_id (echo $window | awk '{print $1}')
        aerospace focus --window-id $window_id
    end
    commandline -f repaint
end

# Ctrl+Z - Television-powered Zellij session manager
function tv-zellij-sessions --description "Television-powered Zellij session management"
    if not command -v zellij >/dev/null
        echo "zellij is not installed."
        return 1
    end
    
    # Get clean session names (strip ANSI codes)
    set -l sessions (zellij list-sessions 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}' | grep -v '^$')
    
    if test (count $sessions) -eq 0
        echo "No Zellij sessions found."
        return 1
    end
    
    set -l selected (printf '%s\n' $sessions | tv --preview 'echo "Session: {0}"')
    if test -n "$selected"
        zellij attach $selected
    end
    commandline -f repaint
end
bind \cz tv-zellij-sessions

# Television-powered Android emulator selector
function remu --description "Television-powered Android emulator selector"
    if not command -v emulator >/dev/null
        echo "Android emulator not found in PATH."
        return 1
    end
    
    set -l avds (emulator -list-avds 2>/dev/null)
    if test (count $avds) -eq 0
        echo "No AVDs found."
        return 1
    end

    set -l selected (printf '%s\n' $avds | tv --preview 'echo "Android Virtual Device: {0}"')
    if test -n "$selected"
        echo "Starting emulator: $selected"
        command emulator -avd $selected &
        disown
    else
        echo "No emulator selected."
    end
end

# Television-powered iOS simulator selector
function resim --description "Television-powered iOS simulator selector"
    if not command -v xcrun >/dev/null
        echo "Xcode command line tools not found."
        return 1
    end
    
    set -l devices (xcrun simctl list devices available 2>/dev/null | grep -E "Booted|Shutdown" | sed 's/^ *//' | sed 's/ *$//')
    if test (count $devices) -eq 0
        echo "No available iOS simulators found."
        return 1
    end

    set -l selected (printf '%s\n' $devices | tv --preview 'echo "iOS Simulator: {0}"')
    if test -n "$selected"
        set -l device_name (echo "$selected" | sed 's/ (.*//')
        set -l udid (xcrun simctl list devices 2>/dev/null | grep "$device_name" | head -1 | sed 's/.*(\([^)]*\)).*/\1/')
        if test -n "$udid"
            echo "Booting iOS simulator: $selected"
            open -a Simulator
            xcrun simctl boot $udid 2>/dev/null
        else
            echo "Could not find UDID for simulator"
        end
    end
end

# Television-powered enhanced history search
function tv-history --description "Television-powered command history search"
    # Use television's built-in shell history integration if available
    # Otherwise fall back to history command
    if command -v tv >/dev/null
        set -l command (history | tv --preview 'echo "Command: {0}"')
        if test -n "$command"
            commandline -rb $command
        end
    else
        echo "Television not found. Please install television."
    end
    commandline -f repaint
end

# Smart file finder - uses television with different channels based on context
function tvf --description "Smart television file finder"
    switch $argv[1]
        case git
            # Search git-tracked files only
            tv git-repos
        case env
            # Search environment variables
            tv env
        case text
            # Search within file contents
            tv text
        case '*'
            # Default to files channel with bat preview
            tv files --preview 'bat --color=always --style=numbers --line-range :50 {0}'
    end
end

# Television-powered process selector
function tvps --description "Television-powered process selector and manager"
    if not command -v ps >/dev/null
        echo "ps command not found."
        return 1
    end
    
    set -l process (ps aux | sed 1d | tv --preview 'echo "PID: {2}\nCommand: {11}\nCPU: {3}%\nMemory: {4}%\nUser: {1}"')
    if test -n "$process"
        set -l pid (echo $process | awk '{print $2}')
        echo "Selected process PID: $pid"
        echo "Command: "(echo $process | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}')
        echo ""
        echo "Actions: [k]ill, [i]nfo, [Enter] to cancel"
        read -l action
        switch $action
            case k
                kill $pid
                echo "Sent TERM signal to process $pid"
            case i
                ps -p $pid -o pid,ppid,user,cpu,pmem,vsz,rss,tty,stat,start,time,comm,args
        end
    end
end

# Quick aliases for television channels
alias tve="tv env"           # Environment variables
alias tvf="tv files"         # Files (default)
alias tvg="tv git-repos"     # Git repositories
alias tvt="tv text"          # Text search
alias tva="tv alias"         # Aliases (if available)

# Television with common preview commands
alias tvb="tv --preview 'bat --color=always --style=numbers {0}'"  # Files with bat preview
alias tve="tv --preview 'eza -la --icons {0}'"                     # Directories with eza preview
