local opt = vim.opt
local keymap = vim.keymap

opt.tabstop = 2
opt.smartindent = true
opt.shiftwidth = 2
opt.expandtab = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "number"
opt.splitright = true
opt.splitbelow = true
opt.shellpipe = ">%s 2>&1"
opt.textwidth = 100
opt.colorcolumn = "100"

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    -- Never allow comment extension, yuck
    vim.opt.formatoptions:remove 'r'
    vim.opt.formatoptions:remove 'o'
  end,
})

