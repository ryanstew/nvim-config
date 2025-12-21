require "config.config"
require "config.lazy"

vim.keymap.set("n", "<leader>rr", function()
  vim.cmd("source $MYVIMRC")
  print("Config reloaded")
end, { desc = "[R]eload vim config" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = function(ev)
    vim.opt_local.makeprg = "zig build"
    vim.keymap.set("n", "<leader>zb", function()
      vim.cmd("split | term zig build")
    end, { buffer = ev.buf, desc = "[Z]ig [B]uild" })
    vim.keymap.set("n", "<leader>zw", function()
      vim.cmd("vsplit | term zig build --watch --prominent-compile-errors")
    end, { buffer = ev.buf, desc = "[Z]ig [W]atch" })
    vim.keymap.set("n", "<leader>zr", function()
      vim.cmd("split | term zig build run")
    end, { buffer = ev.buf, desc = "[Z]ig [R]un" })
  end
})

vim.keymap.set("n", "<leader>/", function()
  vim.cmd('nohlsearch')
end, { desc = "Disable highlights" })
