return {
  'hxueh/beancount.nvim',
  ft = { "beancount", "bean" },
  dependencies = { 
    {
      'saghen/blink.cmp',
      optional = true,
      opts = {
        sources = {
          default = { 'beancount' },
          providers = {
            beancount = {
              name = "beancount",
              module = "beancount.completion.blink",
              score_offset = 100,
              opts = {
                trigger_characters = { ":", "#", "^", '"', " " },
              },
            },
          },
        }
      },
    },
    { 'L3MON4D3/LuaSnip' },
  },
  config = function()
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

    require("beancount").setup({
      auto_format_on_save = false,
      python_path = python_cmd,
      main_bean_file = main_bean_file,
    })
  end,
}
