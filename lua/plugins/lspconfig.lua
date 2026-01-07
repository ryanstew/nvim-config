return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config("zls", {
      semantic_tokens = 'partial',
      enable_build_on_save = true,
    })

    vim.lsp.enable('zls')
    vim.lsp.enable('rust_analyzer')
    vim.lsp.enable('jedi_language_server')
    vim.lsp.enable('c3_lsp')

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'koto',
      callback = function()
        vim.lsp.start({
          cmd = { "koto-ls" },
          root_dir = vim.fn.getcwd(),
        })
      end,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "g.", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "cd", vim.lsp.buf.rename, opts)
      end,
    })
  end,
}
