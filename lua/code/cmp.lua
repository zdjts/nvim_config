-- /home/zeng/.config/nvim/lua/code/cmp.lua
-- This file contains the configuration for nvim-cmp and its ecosystem.
-- It's structured for lazy.nvim to load automatically.

return {
    -- Core completion engine
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- Snippet engine
            'L3MON4D3/LuaSnip',
            -- Snippet collection
            'rafamadriz/friendly-snippets',
            -- Completion sources
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            -- Bridge between cmp and luasnip
            'saadparwaiz1/cmp_luasnip',
            'Kurama622/llm.nvim',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            -- Load friendly-snippets
            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                -- Key mappings
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    -- 手动触发 / 取消 (Escape) 的智能映射
                    ['<C-Space>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            -- 1. 如果补全菜单可见，则关闭它（相当于 Escape）
                            cmp.close()
                        else
                            -- 2. 如果补全菜单不可见，则手动触发补全
                            cmp.complete()
                        end
                    end, { 'i', 's' }), -- 适用于插入模式 (i) 和选择模式 (s)
                }),
                -- Completion sources, order matters
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'llm', group_index = 1 },
                    -- { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'nvim_lua' },
                }),
                performance = {
                    -- LLM 响应比 LSP 慢，调高超时时间可以防止补全被过早中断
                    fetching_timeout = 5000,
                },
                formatting = {
                    format = function(entry, vim_item)
                        -- 为 llm 源添加一个酷炫的图标
                        if entry.source.name == 'llm' then
                            vim_item.kind = ' ' -- Nerd Font 图标 (Brain)
                            vim_item.menu = '[LLM]'
                        end
                        return vim_item
                    end,
                },
                -- Optional: Add a border to the completion window
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })
        end,
    },

    -- Snippet engine
    {
        'L3MON4D3/LuaSnip',
        -- Follow latest release.
        version = 'v2.*',
        event = 'InsertEnter',
        -- Build step is optional, but recommended for performance.
        build = 'make install_jsregexp',
        config = function()
            require('luasnip').setup({
                -- Tell luasnip to update more frequently
                update_events = 'TextChanged,TextChangedI',
                -- Highlight all inactive placeholders with the 'Comment' style
                ext_opts = {
                    [require('luasnip.util.types').choiceNode] = {
                        inactive = {
                            hl_group = 'Comment',
                        },
                    },
                    [require('luasnip.util.types').insertNode] = {
                        inactive = {
                            hl_group = 'Comment',
                        },
                    },
                },
            })
        end,
    },
}
