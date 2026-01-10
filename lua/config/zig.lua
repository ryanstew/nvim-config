-- Zig-specific fun
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
      vim.cmd("10split")
      RunTermAutoclose("zig build run", true)
    end, { buffer = ev.buf, desc = "[Z]ig [R]un" })
    vim.keymap.set("n", "<leader>zt", function()
      vim.cmd("vsplit | term zig build test")
    end, { buffer = ev.buf, desc = "[Z]ig [T]est" })
  end
})
