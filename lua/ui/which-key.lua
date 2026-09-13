local M = {}

function M.setup()
    require('which-key').setup({
        preset = 'helix',
        spec = {
            { '<leader>f', group = ' file' },
            { '<leader>b', group = ' buffer' },
            { '<leader>l', group = ' lsp' },
            { '<leader>d', group = ' diagnostic' },
            { '<leader>g', group = ' git' },
            { '<leader>a', group = ' LLM' },
            { '<leader>c', group = ' code' },
            { '<leader>u', group = '󱖫 use status' },
            { '<leader>p', group = '󰏖 pack' },
            { '<localleader>r', group = '󰐊 run/task' },
        },
    })
    vim.keymap.set('n', '<leader>?', function()
        require('which-key').show({ global = false })
    end, { desc = 'Buffer Local Keymaps (which-key)' })
end

return M
