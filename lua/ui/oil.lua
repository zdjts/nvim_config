local M = {}

function M.setup()
    function _G.get_oil_winbar()
        local dir = require('oil').get_current_dir()
        if dir then
            return vim.fn.fnamemodify(dir, ':~')
        end
        return vim.api.nvim_buf_get_name(0)
    end

    local detail = false
    require('oil').setup({
        default_file_explorer = true,
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
        win_options = {
            winbar = '%!v:lua.get_oil_winbar()',
        },
        float = {
            padding = 4,
            max_width = 120,
            max_height = 40,
        },
        view_options = {
            show_hidden = false,
        },
    })

    vim.keymap.set('n', '<leader>e', function()
        require('oil').toggle_float()
    end, { desc = 'File browser (Oil)' })
end

return M
