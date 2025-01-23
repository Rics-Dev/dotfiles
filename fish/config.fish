# Environment Variables
set -gx ANDROID_HOME "$HOME/Android/Sdk"
set -gx CHROME_EXECUTABLE /usr/bin/chromium
#set -gx EMULATORS "$ANDROID_HOME/emulator"
#set -gx NDK_HOME "$ANDROID_HOME/ndk/28.0.12433566"
#set -gx BUN_INSTALL "$HOME/.bun"
#set -gx JAVA_HOME "$HOME/dev/tools/sdkman/candidates/java/current"
#set -gx FLUTTER "$HOME/dev/tools/flutter/bin"
#set -gx DEPOT_TOOLS "$HOME/dev/tools/depot_tools"
# Path Management
fish_add_path \
    #$HOME/.modular/bin \
    #$HOME/.deno/env \
    #$HOME/.cargo/bin \
    #$EMULATORS \
    #$NDK_HOME \
    #$BUN_INSTALL/bin \
    #$JAVA_HOME \
    #$FLUTTER \
    #$DEPOT_TOOLS
    $CHROME_EXECUTABLE \
    $ANDROID_HOME
if status is-interactive
    # Interactive session configurations

    # TMux aliases and functions
    alias ta="tmux attach" # Just attach
    alias tls="tmux ls" # List sessions

    # Function to create a new named session
    function tn
        if test (count $argv) -eq 0
            echo "Usage: tn <session-name>"
            return 1
        end
        tmux new -s $argv[1]
    end

    # Function to attach to a specific session
    function ts
        if test (count $argv) -eq 0
            echo "Usage: ts <session-name>"
            return 1
        end
        tmux attach -t $argv[1]
    end

    # Function to kill a specific tmux session
    function tk
        if test (count $argv) -eq 0
            echo "Usage: tk <session-name>"
            return 1
        end
        tmux kill-session -t $argv[1]
    end


    #theme_gruvbox dark medium
    # Initialize tools
    if functions -q run_fastfetch
        run_fastfetch
    end

    # Shell enhancements
    if command -q zoxide
        zoxide init --cmd cd fish | source
    end

    if command -q starship
        starship init fish | source
    end



    # Uncomment to use oh-my-posh instead of starship
    # if command -q oh-my-posh
    #     oh-my-posh init fish --config ~/.dotfiles/oh-my-posh/ricsdev.omp.json | source
    # end
end
