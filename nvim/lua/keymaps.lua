-- Navigate buffers sequentially
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { silent = true })
vim.keymap.set('n', '<S-l>', ':bnext<CR>', { silent = true })

-- Fast delete/close current buffer without closing your window split
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { silent = true })

