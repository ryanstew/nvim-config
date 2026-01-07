return {
  {
    'nvim-mini/mini.files',
    version = '*',
    opts = {
      content = {
        filter = function(entry)
          return entry.name ~= '.git' and entry.name ~= '.jj'
        end,
      },
      mappings = {
        close = '<ESC>',
        go_in_plus = '<CR>',
      },
      windows = {
        preview = true,
      },
    },
    init = function()
      vim.keymap.set("n", "<leader>ff", function()
        MiniFiles.open()
      end, { desc = "Mini Files" })
    end,
  }
}
