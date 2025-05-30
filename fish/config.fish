# Environment Variables
# set -x COLORTERM truecolor

set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
set -gx ANDROID_HOME "$HOME/Library/Android/Sdk"
#set -gx CHROME_EXECUTABLE /usr/bin/chromium
set -gx EMULATORS "$ANDROID_HOME/emulator"
#set -gx PLATFORM_TOOLS "$ANDROID_HOME/platform-tools"
set -gx FLUTTER "$HOME/Developer/tools/flutter/bin"
set -gx FLUTTER_EXE "$HOME/.pub-cache/bin"
set -gx HOMEBREW /opt/homebrew/bin
set -gx NODE /opt/homebrew/opt/node@22/bin
set -gx GEM_HOME "/opt/homebrew/lib/ruby/gems/3.4.0"
set -gx GEM_BIN "$GEM_HOME/bin"
set -gx RUBY /opt/homebrew/opt/ruby/bin
set -gx LDFLAGS "-L/opt/homebrew/opt/node@22/lib -L/opt/homebrew/opt/ruby/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/node@22/include -I/opt/homebrew/opt/ruby/include"
set -gx POSTGRESQL /Library/PostgreSQL/17/bin
set -gx MYSQL /usr/local/mysql/bin/
set -gx CHROME_EXECUTABLE "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
#set -gx CEF_PATH "$HOME/.local/share/cef"
#set -gx LD_LIBRARY_PATH "$LD_LIBRARY_PATH:$HOME/.local/share/cef"
#set -gx NDK_HOME "$ANDROID_HOME/ndk/28.0.12433566"
set -gx BUN "$HOME/.bun/bin"
set -gx DENO "$HOME/.deno/bin"
#set -gx JAVA_HOME "$HOME/dev/tools/sdkman/candidates/java/current"
#set -gx DEPOT_TOOLS "$HOME/dev/tools/depot_tools"i
# Path Management
fish_add_path \
    #$HOME/.modular/bin \
    $HOME/.deno/env \
    #$HOME/.cargo/bin \
    #$NDK_HOME \
    #$BUN_INSTALL/bin \
    #$JAVA_HOME \
    #$DEPOT_TOOLS
    #$LD_LIBRARY_PATH \
    #$CEF_PATH \
    #~/.local/bin \
    #~/.cargo/bin \
    $GEM_BIN \
    $FLUTTER \
    $FLUTTER_EXE \
    $NODE \
    $RUBY \
    $BUN \
    $DENO \
    $MYSQL \
    $HOMEBREW \
    $EMULATORS \
    $POSTGRESQL \
    #$PLATFORM_TOOLS \
    #$CHROME_EXECUTABLE \
    $ANDROID_HOME
if status is-interactive
    source ~/.config/fish/alias.fish



    if functions -q run_fastfetch
        run_fastfetch
    end

    carapace _carapace | source

    if command -q atuin
        atuin init fish | source
    end

    if command -q zoxide
        zoxide init --cmd cd fish | source
    end

    if command -q starship
        starship init fish | source
    end

end

#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(/opt/homebrew/bin/brew shellenv)"
