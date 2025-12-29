local function is_dx_project(bufnr)
  if vim.b[bufnr].is_dx ~= nil then
    return vim.b[bufnr].is_dx
  end

  local file_path = vim.api.nvim_buf_get_name(bufnr)
  local project_root = vim.fs.root(file_path, { "Cargo.toml", ".gitignore" })
  if project_root then
    local dx_path = project_root .. "/Dioxus.toml"
    local dx_exists = vim.uv.fs_stat(dx_path)
    vim.b[bufnr].is_dx = (dx_exists ~= nil)
  else
    vim.b[bufnr].is_dx = false
  end
  return vim.b[bufnr].is_dx
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.rs",
  callback = function(args)
    if is_dx_project(args.buf) then
      vim.fn.jobstart({ "dx", "fmt", "-f", args.file }, {
        on_exit = function(_, exit_code)
          if exit_code == 0 then
            vim.api.nvim_command("checktime")
            print("Dx formatted!")
          end
        end,
      })
    end
  end,
})
