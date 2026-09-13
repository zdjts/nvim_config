local M = {}

function M.setup()
    require('noice').setup({
        views = {
            cmdline_popup = {
                position = { row = 5, col = '50%' },
                size = { width = 'auto', height = 'auto' },
            },
            popupmenu = {
                position = { row = 6, col = '50%' },
            },
        },
        lsp = {
            override = {
                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                ['vim.lsp.util.stylize_markdown'] = true,
            },
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
        },
        routes = {
            {
                filter = {
                    event = 'msg_show',
                    kind = '',
                    find = 'written',
                },
                opts = { skip = true },
            },
        },
    })
end

return M
