# Environment Variables
set -gx ANDROID_HOME "$HOME/Android/Sdk"
set -gx NDK_HOME "$ANDROID_HOME/ndk/28.0.12433566"
set -gx BUN_INSTALL "$HOME/.bun"

# Path Management
fish_add_path \
    $HOME/.modular/bin \
    $HOME/.deno/env \
    $HOME/.cargo/bin \
    $ANDROID_HOME \
    $NDK_HOME \
    $BUN_INSTALL/bin

if status is-interactive
    # Interactive session configurations

    # Initialize tools
    command -q run_fastfetch && run_fastfetch

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
