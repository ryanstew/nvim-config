return {
  'folke/trouble.nvim',
  cmd = "Trouble",
  opts = {},
  keys = {
    {
      '<leader>ee',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = "Show buffer diagnostics",
    },
    {
      '<leader>eE',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = "Show all diagnostics",
    },
    {
      '<leader>bs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = "Show symbols",
    },
  }
}
