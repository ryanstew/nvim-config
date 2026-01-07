local onedark = {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    local od = require('onedark');
    od.setup({
      style = 'darker'
    })
    od.load()
  end
}

local gruvbox_material = {
  "sainnhe/gruvbox-material",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.gruvbox_material_enable_italic = false
    vim.cmd.colorscheme('gruvbox-material')
  end,
}

return gruvbox_material

