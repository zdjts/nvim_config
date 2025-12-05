return {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- 确保主题插件优先加载
    config = function()
        require('catppuccin').setup({
            flavour = 'mocha', -- 主题风格: latte, frappe, macchiato, mocha
            transparent_background = false,
            term_colors = true, -- 启用终端颜色（推荐，增强兼容性）

            -- ===================================================================
            -- 集成配置
            -- 官方支持的插件集成，设置为 true 即可
            -- ===================================================================
            integrations = {
                treesitter = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = { -- 虚拟文本样式（可选，增强 LSP 诊断显示）
                        errors = { 'italic' },
                        hints = { 'italic' },
                        warnings = { 'italic' },
                        information = { 'italic' },
                    },
                    underlines = { -- 修复：每个值必须是表格
                        errors = { 'undercurl' },
                        hints = { 'undercurl' },
                        warnings = { 'undercurl' },
                        information = { 'undercurl' },
                    },
                },
                cmp = true,
                gitsigns = true,
                telescope = true,
                mason = true,
                nvimtree = true,
            },

            -- ===================================================================
            -- 自定义高亮（与 Treesitter 和 LSP 兼容）
            -- 官方支持的颜色字段，来自 mocha 调色板
            -- ===================================================================
            custom_highlights = function(colors)
                return {
                    ['@namespace'] = { fg = colors.teal },
                    ['@function'] = { fg = colors.blue, style = { 'bold' } },
                    ['@function.call'] = { fg = colors.blue },
                    ['@function.builtin'] = { fg = colors.peach, style = { 'italic' } },
                    ['@method.call'] = { fg = colors.blue },
                    ['@parameter'] = { fg = colors.maroon, style = { 'italic' } },
                    ['@type'] = { fg = colors.yellow },
                    ['@type.builtin'] = { fg = colors.teal, style = { 'italic' } },
                    ['@constructor'] = { fg = colors.sapphire },
                    ['@keyword'] = { fg = colors.mauve },
                    ['@keyword.function'] = { fg = colors.mauve, style = { 'bold' } },
                    ['@constant.builtin'] = { fg = colors.peach, style = { 'bold' } },

                    -- [修改] 属性和成员变量改为 Yellow
                    ['@property'] = { fg = colors.sky },
                    ['@variable.member'] = { fg = colors.yellow },

                    -- [修改] 操作符改为柔和的灰色，降低视觉干扰
                    ['@operator'] = { fg = colors.overlay2 },
                    ['@keyword.operator'] = { fg = colors.overlay2, style = { 'bold' } },

                    ['@punctuation.bracket'] = {
                        fg = colors.overlay2,
                        style = { 'bold' },
                    },
                    ['@punctuation.delimiter'] = { fg = colors.overlay2 },
                }
            end,
        })

        -- 应用主题（在 setup 后立即调用）
        vim.cmd.colorscheme('catppuccin')
    end,
}
