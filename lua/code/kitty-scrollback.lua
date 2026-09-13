local M = {}

function M.setup()
    require('kitty-scrollback').setup({
        keymaps_enabled = true,
    })
end

return M
