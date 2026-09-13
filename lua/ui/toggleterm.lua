local M = {}

function M.setup()
    require('toggleterm').setup({
        start_in_insert = true,
        persist_size = true,
        close_on_exit = true,
    })

    vim.api.nvim_create_autocmd({ 'TermOpen' }, {
        pattern = 'term://*',
        callback = function()
            local opts = { buf = 0, silent = true }
            vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', '<c-/>', [[<C-\><C-n><cmd>ToggleTerm<CR>]], opts)
        end,
    })
end

return M
