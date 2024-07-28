-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Custom Restart command
vim.api.nvim_create_user_command("R", function()
  vim.cmd("wa")
  print("Restarting Neovim")
  vim.cmd("!~/.dotfiles/neovide/restart_nvim.sh")
end, {})
