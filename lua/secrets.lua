local M = {}
M.secret_cache = {}

function M.unlock()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.6)
  local height = 4

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width, height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal", border = "rounded", title = "Unlock Vault"
  })
  local function close()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end

  local command = {}
  if vim.fn.executable("rbw") == 1 then
    vim.fn.termopen("rbw unlock", {
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          M.secret_cache = {}
          vim.notify("Vault unlocked")
          close()
        else
          vim.notify("Vault unlock failed", vim.log.levels.ERROR)
          vim.defer_fn(close, 1000)
        end
      end,
    })
  elseif vim.fn.executable("bw") == 1 then
    vim.fn.termopen("bw unlock --raw", {
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          local session_token = vim.iter(lines):filter(function(s)
            return s:gsub("%s+", "") ~= ""
          end):last()
          vim.env.BW_SESSION = session_token
          M.secret_cache = {}
          vim.notify("Vault unlocked")
          close()
        else
          vim.notify("Vault unlock failed", vim.log.levels.ERROR)
          vim.defer_fn(close, 1000)
        end
      end,
    })
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>i", true, false, true), 'n', false)
  else
    vim.notify("No supported vault installed")
  end
end

function M.get(name, allow_cache)
  if allow_cache and M.secret_cache[name] then
    return M.secret_cache[name]
  end

  local command = {}
  if vim.fn.executable("rbw") == 1 then
    command = {"rbw", "get", name}
  elseif vim.fn.executable("bw") == 1 then
    command = {"bw", "get", "password", name, "--raw"}
  else
    vim.notify("no secret command available")
    return nil
  end

  local result = vim.system(command, {text = true, stderr = true}):wait()
  if result.code == 0 then
    local secret = result.stdout:gsub("%s+", "")
    if allow_cache then
      M.secret_cache[name] = secret
    end
    return secret
  else
    vim.notify("Error fetching secret '" .. name .. "': " .. result.stderr)
  end
end

return M

