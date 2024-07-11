return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    local logo = [[


██████╗ ██╗ ██████╗███████╗    ██╗   ██╗██╗███╗   ███╗
██╔══██╗██║██╔════╝██╔════╝    ██║   ██║██║████╗ ████║
██████╔╝██║██║     ███████╗    ██║   ██║██║██╔████╔██║
██╔══██╗██║██║     ╚════██║    ╚██╗ ██╔╝██║██║╚██╔╝██║
██║  ██║██║╚██████╗███████║     ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝      ╚═══╝  ╚═╝╚═╝     ╚═╝
                                                      

]]
    opts = opts or {}
    opts.section = opts.section or {}
    opts.section.header = opts.section.header or {}
    opts.section.header.val = vim.split(logo, "\n", { trimempty = true })
    return opts
  end,
}
