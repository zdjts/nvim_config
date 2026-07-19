return {
    'zdjts/llm-commit.nvim',
    opts = {
        provider = {
            endpoint = vim.g.LLM_BASE_URL .. '/v1/chat/completions',
            api_key = vim.g.LLM_API_KEY,
            model = vim.g.LLM_MODEL,
        },
        vcs = 'jj',
    },
    keys = {
        { '<leader>ag', '<cmd>LLMCommit<cr>', desc = 'LLM Commit' },
    },
}
