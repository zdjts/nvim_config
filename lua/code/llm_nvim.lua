return {
  'Kurama622/llm.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
  cmd = { 'LLMSessionToggle', 'LLMSelectedTextHandler', 'LLMAppHandler' },
  config = function()
    local tools = require('llm.tools')
    require('llm').setup({
      url = 'https://api.siliconflow.cn/v1/chat/completions',
      -- model = "deepseek-ai/DeepSeek-R1-0528-Qwen3-8B", -- "moonshot-v1-8k", "moonshot-v1-32k", "moonshot-v1-128k"
      model = 'Qwen/Qwen3-Coder-30B-A3B-Instruct',
      api_type = 'openai',
      max_tokens = 4096,
      -- fetch_key = vim.env.KEY,
      temperature = 0.3,
      top_p = 0.7,
      keys = {
        ['Session:Close'] = { mode = 'n', key = { '<esc>', 'Q', 'q' } },
      },
      OptimCompare = {
        handler = tools.action_handler,
        opts = {
          fetch_key = function()
            return vim.env.GITHUB_TOKEN
          end,

          url = 'https://api.siliconflow.cn/v1/chat/completions',
          -- model = "deepseek-ai/DeepSeek-R1-0528-Qwen3-8B", -- "moonshot-v1-8k", "moonshot-v1-32k", "moonshot-v1-128k"
          model = 'Qwen/Qwen3-Coder-30B-A3B-Instruct',
          api_type = 'openai',
          language = 'Chinese',
        },
      },
      -- OptimizeCode = {
      --   handler = tools.side_by_side_handler,
      --   opts = {
      --     left = {
      --       focusable = false,
      --     },
      --   },
      -- },
      Translate = {
        handler = tools.qa_handler,
        opts = {
          component_width = '60%',
          component_height = '50%',
          query = {
            title = ' 󰊿 Trans ',
            hl = { link = 'Define' },
          },
          input_box_opts = {
            size = '15%',
            win_options = {
              winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
            },
          },
          preview_box_opts = {
            size = '85%',
            win_options = {
              winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
            },
          },
        },
      },
    })
  end,
  keys = {
    { '<leader>ac', mode = 'n', '<cmd>LLMSessionToggle<cr>' },
    {
      '<leader>at',
      mode = 'n',
      '<cmd>LLMAppHandler Translate<cr>',
      desc = ' AI Translator',
    },
    {
      '<leader>an',
      mode = { 'n', 'v' },
      '<cmd>LLMAppHandler OptimizeCode<cr>',
      desc = ' AI Translator',
    },

    -- { "<leader>aa", mode = "v", "<cmd>LLMSelectedTextHandler<cr>" },
  },
}
