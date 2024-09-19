function run_fastfetch
    
    set -l term_width (tput cols)
    
    if test $term_width -ge 50
        fastfetch --config ~/.config/fastfetch/example13.jsonc
    end
end
