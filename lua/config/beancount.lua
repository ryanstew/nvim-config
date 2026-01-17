local python_cmd = "python"
if vim.fn.executable("uv_python") == 1 then
  python_cmd = "uv_python"
end

local files = { "root.bean", "data/root.bean" }
local main_bean_file = ""
for _, file in ipairs(files) do
  local root = vim.fn.getcwd() .. '/' .. file
  if vim.fn.filereadable(root) == 1 then
    main_bean_file = file
    break
  end
end

local lspconfig = require('lspconfig')

vim.lsp.config("beancount", {
  init_options = {
    journal_file = main_bean_file,
    bean_check = {
      method = "python-system",
      python_cmd = "python"
    },
    formatting = {
      currency_column = 70
    }
  }
})
vim.lsp.enable("beancount")

vim.filetype.add({
  extension = {
    beancount = "beancount",
    bean = "beancount",
  }
})
