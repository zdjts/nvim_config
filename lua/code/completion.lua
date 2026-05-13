-- /home/zeng/.config/nvim/lua/code/completion.lua

return {
    {
        'saghen/blink.cmp',
        url = 'https://gh-proxy.org/https://github.com/Saghen/blink.cmp.git',
        version = '~0.x',
        build = function()
            require('blink.cmp').build():wait(60000)
        end,
        dependencies = {
            'saghen/blink.lib', -- 必须添加这一行
            'rafamadriz/friendly-snippets',
            'Kaiser-Yang/blink-cmp-avante',
            { 'saghen/blink.compat', opts = { im_select = false } },
        },
        event = 'InsertEnter',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 1. 键位映射
            keymap = {
                preset = 'enter', -- 回车确认，Tab/S-Tab选择
                ['<C-Space>'] = { 'show', 'hide', 'fallback' },
                ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
            },

            -- 2. 使用原生引擎
            snippets = { preset = 'default' },

            -- 3. 补全源配置
            sources = {
                default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    avante = {
                        module = 'blink-cmp-avante',
                        name = 'Avante',
                        opts = {},
                    },
                    snippets = {
                        opts = {
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
                        treesitter = { 'lsp' },
                    },
                },
                documentation = {
                    window = { border = 'rounded', max_height = 15 },
                    auto_show = true,
                },
                ghost_text = { enabled = false },
            },
            signature = {
                enabled = true,
                window = { border = 'rounded' },
            },

            appearance = {
                kind_icons = { LLM = '' },
            },
        },
    },
}
