#!/usr/bin/fish
function run_fastfetch
    if string match -q "*pts*" (tty)
        fastfetch --config ~/.config/fastfetch/example13.jsonc
    end
end
