return {
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
