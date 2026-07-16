-- 集中管理所有 AI 模型配置
-- 所有 AI 插件都引用此配置

local M = {}

M.base_url = 'http://127.0.0.1:4000'
M.api_key = vim.env.LLM_KEY
M.model = 'deepseek-v4-pro'
M.chat_url = M.base_url .. '/v1/chat/completions'
M.fim_url = M.base_url .. '/v1/completions'

M.backends = {
    local_deepseek = {
        api_type = 'openai',
        url = M.chat_url,
        model = M.model,
        max_tokens = 4096,
        temperature = 0.3,
        top_p = 0.7,
    },
}

return M
