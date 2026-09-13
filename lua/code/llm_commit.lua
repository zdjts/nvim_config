local M = {}

function M.setup()
    require('llm_commit').setup({
        provider = {
            endpoint = vim.g.llm_base_url .. '/v1/chat/completions',
            api_key = vim.g.llm_api_key,
            model = vim.g.llm_model,
        },
        vcs = 'jj',
    })
end

return M
