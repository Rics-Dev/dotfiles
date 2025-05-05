--- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Close current buffer
vim.keymap.set("n", "<S-q>", ":bd<CR>", { desc = "Close current buffer" })

vim.keymap.set("n", "<C-p>", function()
  require("fzf-lua").files({ cwd = vim.fn.getcwd() })
end, { desc = "Open file finder" })

vim.keymap.set("n", "<c-t>", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
vim.keymap.set("t", "<c-t>", "<cmd>close<cr>", { desc = "Hide/Close Terminal" })
