return {
    'milanglacier/minuet-ai.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        -- 初始化你的全局变量
        require('minuet').setup({
            -- 1. 核心控制逻辑：只有当该变量为 true 时才允许触发自动补全
            enable_predicates = {
                function()
                    return vim.g.LLM_COMPLETION_STATUS == true
                end,
            },

            -- 其他原有配置...
            provider = 'openai_fim_compatible',
            presets = {
                deepseek = {
                    provider = 'openai_fim_compatible',
                    provider_options = {
                        openai_fim_compatible = {
                            model = 'deepseek-v4-pro',
                            end_point = 'http://127.0.0.1:4000',
                            api_key = vim.env.LLM_KEY,
                            name = 'DeepSeek',
                            optional = { max_tokens = 256, top_p = 0.9 },
                        },
                    },
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
    end,
}
