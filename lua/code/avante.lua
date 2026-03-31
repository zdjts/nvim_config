return {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    build = 'make', -- 既然是 Linux，直接 make 即可

    opts = {
        provider = 'siliconflow',
        enable_cursor_planning_mode = false,
        enable_claude_text_editor_tool_mode = false,
        behaviour = {
            auto_suggestions = false, -- 实验阶段
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            support_paste_from_clipboard = false,
            minimize_diff = true, -- 是否在应用代码块时删除未更改的行
            enable_token_counting = true, -- 是否启用令牌计数。默认为 true。
            auto_add_current_file = true, -- 打开新聊天时是否自动添加当前文件。默认为 true。
            enable_cursor_planning_mode = false, -- 是否启用 Cursor 规划模式。默认为 false。
            enable_claude_text_editor_tool_mode = false, -- 是否启用 Claude 文本编辑器工具模式。
            ---@type "popup" | "inline_buttons"
            confirmation_ui_style = 'inline_buttons',
        },
        -- 以后增加供应商，只需按下面的结构往 providers 里加
        providers = {
            claude = {
                endpoint = 'https://api.anthropic.com',
                model = 'claude-3-5-sonnet-20240620',
                timeout = 30000,
                -- ✅ 修复：必须放在 extra_request_body 里面
                extra_request_body = {
                    temperature = 0,
                    max_tokens = 8000,
                },
            },
            moonshot = {
                endpoint = 'https://api.moonshot.ai/v1',
                model = 'kimi-k2-0711-preview',
                extra_request_body = {
                    temperature = 0.75,
                    max_tokens = 32768,
                },
            },
            siliconflow = {
                __inherited_from = 'openai',
                endpoint = 'https://api.siliconflow.cn',
                model = 'Qwen/Qwen3.5-122B-A10B',
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
