require "config.config"
require "config.lazy"

local keymap = vim.keymap

-- Reload!
keymap.set("n", "<leader>rr", function()
  vim.cmd("source $MYVIMRC")
  print("Config reloaded")
end, { desc = "[R]eload vim config" })

-- Zig-specific fun
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = function(ev)
    vim.opt_local.makeprg = "zig build"
    keymap.set("n", "<leader>zb", function()
      vim.cmd("split | term zig build")
    end, { buffer = ev.buf, desc = "[Z]ig [B]uild" })
    keymap.set("n", "<leader>zw", function()
      vim.cmd("vsplit | term zig build --watch --prominent-compile-errors")
    end, { buffer = ev.buf, desc = "[Z]ig [W]atch" })
    keymap.set("n", "<leader>zr", function()
      vim.cmd("split")
      local win = vim.api.nvim_get_current_win()
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_win_set_buf(win, buf)

      vim.fn.termopen("zig build run", {
        on_exit = function(_, exit_code, _)
          if exit_code == 0 then
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_close(win, true)
              print("Zig Run: Success")
            end
          else
            print("Zig Run: Failed (Exit Code " .. exit_code .. ")")
          end
        end
      })
    end, { buffer = ev.buf, desc = "[Z]ig [R]un" })
  end
})

-- Highlight management
keymap.set("n", "<leader>/", function()
  vim.cmd('nohlsearch')
end, { desc = "Disable highlights" })

-- Configure autoformat
vim.g.autoformat_enabled = true

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.zig", "*.rs" },
  callback = function()
    if vim.g.autoformat_enabled then
      vim.lsp.buf.format({ async = false })
    end
  end,
})

keymap.set("n", "<leader>af", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Auto-format Buffer" })

keymap.set("n", "<leader>at", function()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  local status = vim.g.autoformat_enabled and "Enabled" or "Disabled"
  print("Auto-format " .. status)
end, { desc = "Toggle Auto-format" })
