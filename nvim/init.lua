-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- function Transparent(color)
--   color = color or "onedark"
--   vim.cmd.colorscheme(color)
--   vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--   vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- end
-- Transparent()

-- Custom Restart command
vim.api.nvim_create_user_command("R", function()
  vim.cmd("wa")
  print("Restarting Neovim")
  vim.cmd("!~/.dotfiles/neovide/restart_nvim.sh")
end, {})
