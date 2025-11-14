-- lua/code/LLM/completion.lua
--
-- 'Completion' (代码补全) 工具的配置
--
-- 注意：'completion_handler' 会独立管理其模型，
-- 这就是为什么我们在 'opts' 内部定义 'url' 和 'model'，
-- 而不是在 'backends.lua' 中。
--

local tools = require('llm.tools')

return {
  handler = tools.completion_handler,
  opts = {
    -------------------------------------------------
    ---                 ollama
    -------------------------------------------------
    -- url = 'http://localhost:11434/v1/completions',
    -- model = 'qwen2.5-coder:1.5b',
    -- api_type = 'ollama',
    ------------------- end ollama ------------------

    -------------------------------------------------
    ---                 deepseek
    -------------------------------------------------
    -- url = "https://api.deepseek.com/beta/completions",
    -- model = "deepseek-chat",
    -- api_type = "deepseek",
    -- fetch_key = function()
    --   return "your api key"
    -- end,
    ------------------ end deepseek -----------------
    -------------------------------------------------
    ---                 siliconflow
    -------------------------------------------------
    -- 这是您原来启用的配置
    url = 'https://api.siliconflow.cn/v1/completions',
    model = 'Qwen/Qwen2.5-Coder-7B-Instruct',
    api_type = 'openai',
    ------------------ end siliconflow -----------------

    -------------------------------------------------
    ---                 codeium
    ---  dependency: "Exafunction/codeium.nvim"
    -------------------------------------------------
    -- api_type = "codeium",
    ------------------ end codeium ------------------

    n_completions = 3,
    context_window = 512,
    max_tokens = 256,

    -- A mapping of filetype to true or false, to enable completion.
    filetypes = { sh = false },

    -- Whether to enable completion of not for filetypes not specifically listed above.
    default_filetype_enabled = true,

    auto_trigger = false,

    -- just trigger by { "@", ".", "(", "[", ":", " " } for `style = "nvim-cmp"`
    only_trigger_by_keywords = true,

    style = 'virtual_text', -- nvim-cmp or blink.cmp

    timeout = 10, -- max request time

    -- only send the request every x milliseconds, use 0 to disable throttle.
    throttle = 1000,
    -- debounce the request in x milliseconds, set to 0 to disable debounce
    debounce = 400,

    --------------------------------
    ---   just for virtual_text
    --------------------------------
    keymap = {
      toggle = {
        mode = 'n',
        keys = '<leader>cp',
        desc = '反转 LLM Lsp 状态',
      },
      virtual_text = {
        accept = {
          mode = 'i',
          keys = '<A-a>',
        },
        next = {
          mode = 'i',
          keys = '<A-n>',
        },
        prev = {
          mode = 'i',
          keys = '<A-p>',
        },
        toggle = {
          mode = 'n',
          keys = '<leader>cp',
        },
      },
    },
  },
}
