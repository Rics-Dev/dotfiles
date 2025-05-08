#!/usr/bin/fish
# function run_fastfetch
#     if string match -q "*pts*" (tty)
#         fastfetch --config ~/.config/fastfetch/example13.jsonc
#     end
# end


# macOS
function run_fastfetch
    # On macOS, tty output is often like /dev/ttys000 instead of /dev/pts/0
    if not string match -q "/dev/null" (tty)
        fastfetch --config ~/.config/fastfetch/example13.jsonc
    end
end

