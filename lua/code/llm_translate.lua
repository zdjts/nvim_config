return {
    'zdjts/llm-translate.nvim',
    opts = {
        engine = 'llm',
        from = 'auto',
        to = 'zh',
        llm = {
            endpoint = vim.g.LLM_BASE_URL .. '/v1/chat/completions',
            api_key = vim.g.LLM_API_KEY,
            model = vim.g.LLM_MODEL,
        },
    },
    keys = {
        { '<leader>t', '<cmd>LLMTranslate<cr>', mode = 'n', desc = 'Translate line' },
        { '<leader>t', ':LLMTranslate<cr>', mode = 'v', desc = 'Translate selection' },
    },
}
