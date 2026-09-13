local M = {}

function M.init()
    vim.g.vimtex_view_method = 'sioyek'
    vim.g.vimtex_quickfix_mode = 0
end

function M.setup()
    M.init()
end

return M
