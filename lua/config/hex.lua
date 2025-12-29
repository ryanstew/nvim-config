
if vim.fn.executable("xxd") == 1 then
  local binary_group = vim.api.nvim_create_augroup("BinaryEditing", { clear = true })

  vim.api.nvim_create_autocmd("BufReadPost", {
    group = binary_group,
    pattern = "*.bin",
    callback = function()
      vim.cmd('%!xxd')
      vim.bo.filetype = "xxd"
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
      group = binary_group,
      pattern = "xxd",
      callback = function(args)
        vim.notify("Enabling hex mode", vim.log.levels.INFO)

        local buf = args.buf
        local xxd_save = vim.api.nvim_create_autocmd("BufWriteCmd", {
          buffer = buf,
          group = binary_group,
          callback = function(write_args)
              local filename = write_args.file
              local cmd = string.format("silent write !xxd -r > %s", vim.fn.shellescape(filename))
              vim.cmd(cmd)
              vim.bo[buf].modified = false
              vim.api.nvim_exec_autocmds("BufWritePost", { buffer = buf })
          end,
        })
        local xxd_reload = vim.api.nvim_create_autocmd("BufWritePost", {
          buffer = buf,
          group = binary_group,
          callback = function(post_args)
            local view = vim.fn.winsaveview()
            vim.cmd("silent %delete")
            vim.cmd("silent read !xxd " .. vim.fn.shellescape(post_args.file))
            vim.cmd("silent 1delete")
            vim.fn.winrestview(view)
            vim.bo[buf].modified = false
          end,
        })

        vim.api.nvim_create_autocmd("FileType", {
          buffer = buf,
          group = binary_group,
          callback = function()
            if vim.bo[buf].filetype ~= "xxd" then 
              vim.notify("Hex mode disabled", vim.log.levels.INFO)
              vim.api.nvim_del_autocmd(xxd_save)
              vim.api.nvim_del_autocmd(xxd_reload)
              return true
            end
          end,
        })
      end,
  })

  local function toggle_hex()
    if vim.bo.filetype == "xxd" then
      vim.cmd('%!xxd -r')
      vim.bo.filetype = ""
      vim.cmd('filetype detect')
    else
      vim.cmd('%!xxd')
      vim.bo.filetype = "xxd"
    end
  end

  vim.api.nvim_create_user_command("HexEdit", toggle_hex, {})
  vim.keymap.set("n", "<leader>bh", toggle_hex, { desc = "Toggle hex mode" })
end
