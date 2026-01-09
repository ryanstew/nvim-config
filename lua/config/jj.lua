local function run_jj(args)
  vim.cmd("term jj --no-pager " .. args)
end

vim.api.nvim_create_user_command(
  'Jj',
  function(opts)
    run_jj(opts.args)
  end,
  {
    nargs = '*',
    desc = 'Run jj command in a terimnal buffer'
  }
)

vim.api.nvim_create_user_command(
  'Jjv',
  function(opts)
    vim.cmd('vsplit')
    run_jj(opts.args)
  end,
  {
    nargs = '*',
    desc = 'Run jj command in a vsplit terimnal buffer'
  }
)

vim.keymap.set("n", "<leader>js", function()
  vim.cmd("20split")
  run_jj("status")
end, { desc = "jj status" })

vim.keymap.set("n", "<leader>jd", function()
  run_jj("diff")
end, { desc = "jj diff" })

vim.keymap.set("n", "<leader>jl", function()
  vim.cmd("vsplit")
  run_jj("log")
end, { desc = "jj log" })

vim.keymap.set("n", "<leader>jc", function()
  vim.ui.input({ prompt = "Description" }, function(desc)
    if desc ~= nil and desc ~= '' then
      vim.cmd("10split")
      run_jj("commit -m \"" .. desc .. "\"")
    end
  end)
end, { desc = "jj commit" })

vim.keymap.set("n", "<leader>jm", function()
  vim.ui.input({ prompt = "Description" }, function(desc)
    if desc ~= nil and desc ~= '' then
      vim.cmd("10split")
      run_jj("describe -m \"" .. desc .. "\"")
    end
  end)
end, { desc = "jj describe" })
