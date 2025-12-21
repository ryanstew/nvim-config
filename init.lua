require "config.config"
require "config.lazy"

vim.keymap.set("n", "<leader>rr", function()
  vim.cmd("source $MYVIMRC")
  print("Config reloaded")
end, { desc = "[RR]eload vim config" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = function(ev)
    vim.opt_local.makeprg = "zig build"
    vim.keymap.set("n", "<leader>zb", function()
      vim.cmd("split | term zig build")
    end, { buffer = ev.buf, desc = "Zig Build" })
    vim.keymap.set("n", "<leader>zw", function()
      vim.cmd("vsplit | term zig build --watch --prominent-compile-errors")
    end, { buffer = ev.buf, desc = "Zig Watch" })
    vim.keymap.set("n", "<leader>zr", function()
      vim.cmd("split | term zig build run")
    end, { buffer = ev.buf, desc = "Zig Run" })
  end
})
