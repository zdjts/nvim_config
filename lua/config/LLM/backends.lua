-- lua/plugins/LLM/backends.lua
--
-- 在这里集中管理所有 AI 模型 (后端)
-- "llm_nvim.lua" (主文件) 会读取这个文件
--
-- 切换模型：
-- 1. 在这里添加一个新的模型条目 (例如 "ollama_llama3")
-- 2. 去 "llm_nvim.lua" 文件中，
--    修改 default_backend = "ollama_llama3"
--

return {

  -- 您的默认 SiliconFlow 聊天模型
  -- 这是从您原来的 setup 配置中提取的
  siliconflow_qwen = {
    -- 插件源代码 lua/llm/backends/openai.lua
    -- 会处理 'openai' 类型的 API
    api_type = 'openai',

    url = 'https://api.siliconflow.cn/v1/chat/completions',
    model = 'Qwen/Qwen3-Coder-30B-A3B-Instruct',

    -- 保留您原来的参数
    max_tokens = 4096,
    temperature = 0.3,
    top_p = 0.7,
  },

  -- 【示例】未来如果您想添加本地的 Ollama
  -- ollama_llama3 = {
  --   api_type = 'ollama', -- 插件会使用 lua/llm/backends/ollama.lua
  --   model = 'llama3',
  --   -- (Ollama 会自动使用 http://127.0.0.1:11434)
  -- },

  -- 【示例】未来如果您想添加 Kimi
  -- kimi_moonshot = {
  --   api_type = 'openai', -- Kimi 兼容 OpenAI API
  --   url = 'https://api.moonshot.cn/v1/chat/completions',
  --   model = 'moonshot-v1-32k',
  --   -- (您需要设置 MOONSHOT_API_KEY 环境变量)
  -- },

  --
  -- 注意：
  -- 'Completion' (代码补全) 工具是特例。
  -- 它有自己的模型配置，我们会将它放在 "LLM/completion.lua" 文件中，
  -- 而不是放在这里。
  --
}
