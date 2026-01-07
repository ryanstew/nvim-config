return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ':TSUpdate',
    config = function()
      ts = require('nvim-treesitter')
      ts.install({'rust', 'zig', 'lua', 'c3', 'koto'})

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'rust', 'zig', 'lua', 'c3', 'koto' },
        callback = function() vim.treesitter.start() end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = false,
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local object_maps = {
        ["f"] = "@function",
        ["c"] = "@class",
        ["s"] = "@statement",
        ["l"] = "@loop",
        ["i"] = "@conditional",
      }

      ts = require("nvim-treesitter-textobjects")
      ts.setup({
        select = {
          lookahead = true,
          include_surrounding_whitespace = false,
        },
      })

      ts_select = require("nvim-treesitter-textobjects.select")
      ts_move = require("nvim-treesitter-textobjects.move")

      local function yank_object_linewise(query)
        ts_select.select_textobject(query, "textobjects")
        if vim.fn.mode() == "v" then
          vim.cmd("normal! V")
        end
        vim.cmd('normal! y')
      end

      for key,object in pairs(object_maps) do
        vim.keymap.set({ "x", "o" }, "a" .. key, function()
          ts_select.select_textobject(object .. ".outer", "textobjects")
        end, { desc = "Select outer " .. object })

        vim.keymap.set({ "x", "o" }, "i" .. key, function()
          ts_select.select_textobject(object .. ".inner", "textobjects")
        end, { desc = "Select inner " .. object })

        vim.keymap.set("n", "<leader>y" .. key, function()
          yank_object_linewise(object .. ".outer")
        end, { desc = "Yank " .. object .. " (linewise)" })

        vim.keymap.set({ "n", "x", "o" }, "]" .. key, function()
          ts_move.goto_next_start(object .. ".outer", "textobjects")
        end, { desc = "Go to next " .. object })

        vim.keymap.set({ "n", "x", "o" }, "[" .. key, function()
          ts_move.goto_previous_start(object .. ".outer", "textobjects")
        end, { desc = "Go to previous " .. object })
      end
    end,
  }
}
