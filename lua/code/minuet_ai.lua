local M = {}

function M.setup()
    require('minuet').setup({
        enable_predicates = {
            function()
                return vim.g.LLM_COMPLETION_STATUS == true
            end,
        },
        -- Local proxy only exposes OpenAI chat completions (FIM /v1/completions is 405).
        provider = 'openai_compatible',
        provider_options = {
            openai_compatible = {
                model = vim.g.llm_model,
                end_point = vim.g.llm_base_url .. '/v1/chat/completions',
                -- Env var name or function; not the key itself (:h minuet API Keys).
                api_key = 'LLM_KEY',
                name = 'Local',
                optional = { max_tokens = 256, top_p = 0.9 },
            },
        },
        virtualtext = {
            auto_trigger_ft = { '*' },
            keymap = {
                accept = '<A-A>',
                accept_line = '<A-a>',
                accept_n_lines = '<A-z>',
                prev = '<A-[>',
                next = '<A-]>',
                dismiss = '<A-e>',
            },
        },
    })
end

return M
