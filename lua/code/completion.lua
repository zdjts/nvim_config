-- /home/zeng/.config/nvim/lua/code/completion.lua

return {
    {
        'saghen/blink.cmp',
        url = 'https://gh-proxy.org/https://github.com/Saghen/blink.cmp.git',
        -- version = '~0.x',
        build = 'cargo build --release',
        dependencies = {
            'rafamadriz/friendly-snippets',
            'Kaiser-Yang/blink-cmp-avante',
            { 'saghen/blink.compat', opts = { im_select = false } },
            -- 'Kurama622/llm.nvim', -- 你的本地 LLM 插件
        },
        event = 'InsertEnter',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 1. 键位映射：回归极简
            keymap = {
                preset = 'enter', -- 回车确认，Tab/S-Tab 选择
                ['<C-Space>'] = { 'show', 'hide', 'fallback' },
                -- 如果你怀念原来的 Tab 跳转 Snippet 逻辑：
                ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
            },

            -- 2. 彻底抛弃 LuaSnip，使用 blink 原生引擎
            snippets = { preset = 'default' },

            -- 3. 补全源配置 (Sources)
            sources = {
                default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    avante = {
                        module = 'blink-cmp-avante',
                        name = 'Avante',
                        opts = {},
                    },
                    snippets = {
                        name = 'Snippets',
                        module = 'blink.cmp.sources.snippets',
                        -- score_offset = 100, -- 给予极高权重，确保排在第一位
                        opts = {
                            -- 这里的路径必须指向你刚才创建 JSON 的文件夹
                            search_paths = { vim.fn.expand('~/.config/nvim/lua/snippets') },
                        },
                    },
                },
            },

            completion = {
                list = { selection = { preselect = true, auto_insert = true } },
                menu = {
                    border = 'rounded',
                    draw = {
                        columns = {
                            { 'label', 'label_description', gap = 1 },
                            { 'kind_icon', 'kind' },
                        },
                        treesitter = { 'lsp' }, -- 为 LSP 结果启用 treesitter 高亮
                    },
                },
                documentation = {
                    window = { border = 'rounded', max_height = 15 },
                    auto_show = true,
                },
                -- 类似 VSCode 的虚影补全，非常有破坏力的体验增强
                ghost_text = { enabled = false },
            },

            -- 5. 修正图标
            appearance = {
                kind_icons = { LLM = ' ' },
            },
        },
    },
}
