local M = {}

function M.setup()
    require('flash').setup({
        modes = {
            char = { enabled = false },
        },
    })
end

return M
