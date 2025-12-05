return {
    'stevearc/oil.nvim',

    keys = {
        {
            '<leader>e',
            function()
                require('oil').toggle_float() -- 或者是 .open() 取决于你想要浮动还是替换buffer
            end,
            desc = 'File browser (Oil)',
        },
    },
    -- 依赖 echasnovski/mini.icons 来提供图标
    dependencies = { 'nvim-tree/nvim-web-devicons', 'benomahony/oil-git.nvim' },

    -- 将所有配置逻辑都放入 config 函数中
    config = function()
        -- 1. 先定义 winbar 需要的全局函数
        function _G.get_oil_winbar()
            local dir = require('oil').get_current_dir()
            if dir then
                -- 返回相对路径（如: ~/.config/nvim）
                return vim.fn.fnamemodify(dir, ':~')
            else
                -- 如果不在 oil 缓冲区，返回当前文件名
                return vim.api.nvim_buf_get_name(0)
            end
        end

        -- 2. 定义用于切换视图的局部量
        local detail = false
        -- 3. 调用 setup 函数，传入所有配置
        require('oil').setup({
            default_file_explorer = true,
            -- oil 窗口内部的快捷键
            keymaps = {
                ['<C-l>'] = false,
                ['<C-k>'] = false,
                ['<C-j>'] = false,
                ['<C-r>'] = 'actions.refresh',
                ['<leader>y'] = 'actions.yank_entry',
                ['g.'] = false,
                ['zh'] = 'actions.toggle_hidden',
                ['\\'] = { 'actions.select', opts = { horizontal = true } },
                ['|'] = { 'actions.select', opts = { vertical = true } },
                ['q'] = 'actions.close',
                ['-'] = 'actions.parent',
                ['<C-h>'] = false,
                ['gd'] = {
                    desc = '切换文件详情视图',
                    callback = function()
                        detail = not detail
                        if detail then
                            require('oil').set_columns({
                                'icon',
                                'permissions',
                                'size',
                                'mtime',
                            })
                        else
                            require('oil').set_columns({ 'icon' })
                        end
                    end,
                },
            },
            -- 窗口选项
            win_options = {
                -- 使用我们定义的全局函数来设置 winbar
                winbar = '%!v:lua.get_oil_winbar()',
            },
            -- 以下是示例中没有，但建议添加的浮动窗口配置
            float = {
                padding = 4,
                max_width = 120,
                max_height = 40,
            },
            view_options = {
                show_hidden = false,
            },
        })
    end,
}
