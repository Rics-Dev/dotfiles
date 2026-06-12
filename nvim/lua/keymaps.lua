-- Navigate buffers sequentially
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', {  desc = '', silent = true })
vim.keymap.set('n', '<S-l>', ':bnext<CR>', {  desc = '', silent = true })

-- Fast delete/close current buffer without closing your window split
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', {  desc = 'Delete Buffer', silent = true })

