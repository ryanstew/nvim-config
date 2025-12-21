return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.2.0',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader><space>',
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
    },
    {
      '<leader>G',
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live Grep",
    },
    {
      '<leader>g',
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Grep token",
    },
    {
      '<leader>fo',
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find open buffer",
    },
  }
}
