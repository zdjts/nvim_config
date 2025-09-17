return {
  'Kurama622/llm.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
  cmd = { 'LLMSessionToggle', 'LLMSelectedTextHandler', 'LLMAppHandler' },
  config = function()
    require('llm').setup({
      url = 'https://api.siliconflow.cn/v1/chat/completions',
      -- model = "deepseek-ai/DeepSeek-R1-0528-Qwen3-8B", -- "moonshot-v1-8k", "moonshot-v1-32k", "moonshot-v1-128k"
      model = 'Qwen/Qwen3-Coder-30B-A3B-Instruct',
      api_type = 'openai',
      max_tokens = 4096,
      -- fetch_key = vim.env.KEY,
      temperature = 0.3,
      top_p = 0.7,
    })
  end,
  keys = {
    { '<leader>ac', mode = 'n', '<cmd>LLMSessionToggle<cr>' },
    -- { "<leader>aa", mode = "v", "<cmd>LLMSelectedTextHandler<cr>" },
  },
}
