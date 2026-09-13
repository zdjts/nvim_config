local M = {}

function M.setup()
    require('bufferline').setup({
        options = {
            diagnostics = 'nvim_lsp',
            diagnostics_indicator = function(count, level)
                local icon = level:match('error') and ' ' or ' '
                return ' ' .. icon .. count
            end,
            show_buffer_icons = true,
            offsets = {
                {
                    filetype = 'oil',
                    text = '文件浏览器',
                    text_align = 'left',
                },
            },
        },
    })
    vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous Buffer' })
    vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer' })
end

return M
