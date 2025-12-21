require "config.config"
require "config.lazy"

vim.keymap.set("n", "<leader>rr", function()
  vim.cmd("source $MYVIMRC")
  print("Config reloaded")
end, { desc = "[RR]eload vim config" })
