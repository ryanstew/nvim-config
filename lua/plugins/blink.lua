return {
  {
    'saghen/blink.cmp',
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = { 
        preset = 'default',
        ['<C-y>'] = false,
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = { documentation = { auto_show = false } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  {
    'saghen/blink.pairs',
    dependencies = 'saghen/blink.download',
    version = '*',
    opts = {},
    init = function()
      local pairs_enabled = true
      vim.keymap.set('n', '<leader>bp', function()
        pairs_enabled = not pairs_enabled
        if pairs_enabled then
          require('blink.pairs.mappings').enable()
        else
          require('blink.pairs.mappings').disable()
        end
      end, { desc = "Toggle pair matching" })
    end,
  },
  {
    'saghen/blink.indent',
    opts = {
      enabled_filetypes = { 'lua', 'rust', 'python', 'c3', 'zig' },
      static = {
        char = '┊'
      },
      scope = {
        char = '┊'
      },
    },
    init = function()
      local indent_enabled = true
      vim.keymap.set('n', '<leader>bi', function()
        indent_enabled = not indent_enabled
        require('blink.indent').enable(indent_enabled)
      end, { desc = "Toggle indent guides" })
    end,
  }
}
