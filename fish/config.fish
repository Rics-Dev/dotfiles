if status is-interactive
    # Commands to run in interactive sessions can go here
    run_fastfetch
    #oh-my-posh init fish --config ~/.dotfiles/oh-my-posh/ricsdev.omp.json | source
    zoxide init --cmd cd fish | source
    starship init fish | source
end
