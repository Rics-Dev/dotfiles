return {
  "numToStr/FTerm.nvim",
  config = function()
    vim.keymap.set('n', '<C-i>', '<CMD>lua require("FTerm").toggle()<CR>')
    vim.keymap.set('t', '<C-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
  end
}
