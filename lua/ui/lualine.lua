local M = {}

function M.setup()
    require('lualine').setup({
        options = {
            disabled_filetypes = {
                statusline = { 'dashboard', 'alpha' },
            },
        },
        sections = {
            lualine_x = {
                function()
                    return vim.diagnostic.status()
                end,
                'encoding',
                'fileformat',
                'filetype',
            },
        },
    })
    vim.o.laststatus = vim.g.lualine_laststatus or 2
end

return M
