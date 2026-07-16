return {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    build = 'make', -- 既然是 Linux，直接 make 即可

    opts = {
        provider = 'local_deepseek',
        enable_cursor_planning_mode = false,
        enable_claude_text_editor_tool_mode = false,
        behaviour = {
            auto_suggestions = false,
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            support_paste_from_clipboard = false,
            minimize_diff = true,
            enable_token_counting = true,
            auto_add_current_file = true,
            enable_cursor_planning_mode = false, -- 只保留在 behaviour 里
            enable_claude_text_editor_tool_mode = false,
            confirmation_ui_style = 'inline_buttons',
        },
        -- 以后增加供应商，只需按下面的结构往 providers 里加
        providers = {
            local_deepseek = {
                __inherited_from = 'openai',
                endpoint = 'http://127.0.0.1:4000',
                model = 'deepseek-v4-pro',
                api_key_name = 'LLM_KEY',
                timeout = 30000,
                extra_request_body = {
                    temperature = 0,
                    max_tokens = 8000,
                },
            },
        },
    },

    dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
    },
}
