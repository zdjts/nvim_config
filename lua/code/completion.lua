local M = {}

function M.setup()
    require('blink.cmp').setup({
        keymap = {
            preset = 'enter',
            ['<C-Space>'] = { 'show', 'hide', 'fallback' },
            ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        },
        snippets = { preset = 'default' },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
                snippets = {
                    opts = {
                        search_paths = { vim.fn.stdpath('config') .. '/lua/snippets' },
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
    })
end

return M
