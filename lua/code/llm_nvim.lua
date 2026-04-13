-- 这是【修正后的】主文件
-- 它只使用您原来的【旧版 API】

return {
    'Kurama622/llm.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
    cmd = { 'LLMSessionToggle', 'LLMSelectedTextHandler', 'LLMAppHandler' },

    -- 关键：config 函数
    config = function()
        -- 1. 保留您原来的设置：
        require('llm.state').completion.enable = vim.g.LLM_COMPLETION_STATUS

        -- 2. 加载您在 'lua/LLM/init.lua' 中定义的所有工具
        --    (这会返回一个 app_handler 表)
        local my_tools = require('config.LLM') -- 对应 lua/LLM/init.lua

        -- 3.
        -- 【这才是正确的配置】
        -- 我们使用您原来的顶层 url, model, api_type
        -- 我们【不】使用 'backends' 或 'default_backend'
        --
        require('llm').setup({
            -- [核心] 您原来的模型配置
            url = 'https://api.siliconflow.cn/v1/chat/completions',
            model = 'Qwen/Qwen3-Coder-30B-A3B-Instruct',
            api_type = 'openai',
            provider = 'openai',
            max_tokens = 4096,
            temperature = 0.3,
            top_p = 0.7,
            models = {
                {
                    name = 'TinyLlama',
                    model = 'tinyllama:latest',
                    url = 'http://localhost:11434/api/chat',
                    api_type = 'ollama',
                },
                {
                    name = 'Gemma 3 (12B)',
                    model = 'gemma3:12b',
                    url = 'http://localhost:11434/api/chat',
                    api_type = 'ollama',
                },
            },

            prefix = {
                user = { text = '  ', hl = 'Title' },
                assistant = { text = '  ', hl = 'Added' },
            },
            style = 'right', -- right | left | top | bottom
            chat_ui_opts = {
                input = {
                    split = {
                        relative = 'win',
                        position = {
                            row = '80%',
                            col = '50%',
                        },
                        border = {
                            text = {
                                top = '  Enter Your Question ',
                                top_align = 'center',
                            },
                        },
                        win_options = {
                            winblend = 0,
                            winhighlight = 'Normal:String,FloatBorder:LlmYellowLight,FloatTitle:LlmYellowNormal',
                        },
                        size = { height = 2, width = '80%' },
                    },
                },
                output = {
                    split = {
                        size = '40%',
                    },
                },
                history = {
                    split = {
                        -- Default: true.
                        -- If the window flickers when the cursor moves on macOS, you can set enable_fzf_focus_print = false.
                        enable_fzf_focus_print = true,
                        size = '60%',
                    },
                },
                models = {
                    split = {
                        relative = 'win',
                        size = { height = '30%', width = '60%' },
                    },
                },
            },
            -- popup window options
            popwin_opts = {
                relative = 'cursor',
                enter = true,
                focusable = true,
                zindex = 50,
                position = { row = -7, col = 15 },
                size = { height = 15, width = '50%' },
                border = { style = 'single', text = { top = ' Explain ', top_align = 'center' } },
                win_options = {
                    winblend = 0,
                    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
                },

                -- move popwin
                move = {
                    left = {
                        mode = 'n',
                        keys = '<left>',
                        distance = 5,
                    },
                    right = {
                        mode = 'n',
                        keys = '<right>',
                        distance = 5,
                    },
                    up = {
                        mode = 'n',
                        keys = '<up>',
                        distance = 2,
                    },
                    down = {
                        mode = 'n',
                        keys = '<down>',
                        distance = 2,
                    },
                },
            },

            prompt = [[
        你是一个高效、精准的问答助手。

        你的核心任务是：
          - 针对提问，只提供最核心的事实或结论。

        你必须：
          1. 保持中立和直接的语气。
          2. **只返回核心答案**。不要包含任何介绍、附注或无关信息。
        ]],

            -- [核心] 保留您原来的 Session 关闭快捷键
            keys = {
                ['Session:Close'] = { mode = 'n', key = { '<esc>', 'Q', 'q' } },
                ['Session:History'] = { mode = 'n', key = {} },
                -- ['Completion:Accept'] = { mode = 'i', key = '<A-a>' },
            },

            -- [核心] 传入我们从 'lua/LLM/init.lua' 加载的工具
            app_handler = my_tools,
        })
    end,

    -- 4. 您原来的所有工具快捷键保持不变
    keys = {
        {
            '<leader>at',
            mode = { 'v' },
            '<cmd>LLMAppHandler TranslateSelected<cr>',
            desc = 'AI 翻译器',
        },
        {
            '<leader>ag',
            mode = 'n',
            '<cmd>LLMAppHandler CommitMsg<cr>',
            desc = '生成 AI 提交信息',
        },
        {
            '<leader>ad',
            mode = 'v',
            '<cmd>LLMAppHandler DocString<cr>',
            desc = '生成文档字符串',
        },
    },
}
