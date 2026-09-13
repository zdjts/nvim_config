local M = {}

function M.setup_html()
    -- live-preview.nvim ships commands from plugin/
end

function M.setup_markdown()
    require('markdown_preview').setup({
        instance_mode = 'takeover',
        port = 0,
        open_browser = true,
        debounce_ms = 300,
    })
end

return M
