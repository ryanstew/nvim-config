local be_brief = [[
  You are a general AI assistant. Your goal is to answer the user's questions factually and
  helpfully.

  - If you're unsure, don't guess and say you don't know instead.
  - Ask questions if you need clarification to provide a better answer.
  - Focus on providing expert knowledge on how the system works, citing references when possible.
  - Don't elide code from your output if the answer requires coding.
  - Be brief with your responses. Answer the question completely but with as few words as you can.
  - Don't compliment the user or comment on the question itself. The user values brevity.
  - Act like you're engaging in an IM chat with a coworker who is knowledgable, but needs your
    expertise to point them in the right direction.
  - Provide examples when necessary, but keep them short and to the point.

  Example:

  User: 
  I have a Rust program that needs to parse some mildly complex data. What's the best
  way to approach this?

  Assistant: 
  The most commonly used library for assisting with parsing in Rust is `nom`. `nom`
  can be used to string together small parsing tasks into larger parsers very simply. An example
  nom parser might look like this, which will extract the text in between parentheses:

  ```rust
  fn parens(input: &str) -> IResult<&str, &str> {
    delimited(char('('), is_not(")"), char(')')).parse(input)
  }
  ```
]]

local function api_key_command(key_name)
  if vim.fn.executable("rbw") == 1 then
    return {"rbw", "get", key_name}
  elseif vim.fn.executable("bw") == 1 then
    return {"bw", "get", "password", key_name, "--raw"}
  else
    vim.notify("no api key command available")
  end
end

local api_key_cache = {}
local function get_cached_api_key(key_name)
  if api_key_cache[key_name] then
    return api_key_cache[key_name]
  end

  vim.notify("Fetching key...")
  local cmd = api_key_command(key_name)
  local result = vim.system(cmd, {text = true}):wait()
  if result.code == 0 then
    local key = result.stdout:gsub("%s+", "")
    api_key_cache[key_name] = key
    return key
  else
    vim.notify("Error fetching key: " .. result.code)
    return nil
  end
end

local function api_key_for(key_name)
  return function()
    return get_cached_api_key(key_name)
  end
end

local codecompanion = {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion Toggle Chat" },
    { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion Inline" },
    { "<leader>ax", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "CodeCompanion Add to Chat" },
  },
  opts = {
    adapters = {
      http = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = api_key_for("api-key-gemini"),
            },
            schema = { model = { default = "gemini-3-flash-preview" } },
          })
        end,
        groq = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://api.groq.com/openai/v1",
              api_key = api_key_for("api-key-groq"),
              chat_url = "/chat/completions",
            },
            schema = {
              model = {
                default = "meta-llama/llama-4-maverick-17b-128e-instruct",
                choices = {
                  "qwen/qwen3-32b",
                  "meta-llama/llama-4-maverick-17b-128e-instruct",
                },
              },
            },
          })
        end,
        openrouter = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api/v1",
              api_key = api_key_for("api-key-openrouter"),
              chat_url = "/chat/completions",
            },
            schema = {
              model = {
                default = "xiaomi/mimo-v2-flash:free",
                choices = {
                  "xiaomi/mimo-v2-flash:free",
                  "mistralai/devstral-5212:free",
                  "openai/gpt-oss-120b:free",
                  "qwen/qwen3-coder:free",
                },
              },
            },
          })
        end,
      }
    },
    interactions = {
      chat = {
        adapter = "groq",
      },
      inline = {
        adapter = "groq",
      },
      agent = {
        adapter = "groq",
      },
    },
  },
}

return {
  codecompanion
}
