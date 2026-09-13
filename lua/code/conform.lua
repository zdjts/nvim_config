local M = {}

function M.setup()
    local conform = require('conform')
    _G.auto_format_on_save = true

    local formatters_path = 'config.formatters.'
    local formatters_by_ft = {}
    local formatters = {}
    local files = {
        'lua',
        'python',
        'cpp',
        'shell',
        'cmake',
        'markdown',
        'tex',
        'javascript',
        'typst',
        'rust',
    }
    for _, file in ipairs(files) do
        local ok, config = pcall(require, formatters_path .. file)
        if ok and config then
            if config.formatters_by_ft then
                for ft, formatter_names in pairs(config.formatters_by_ft) do
                    formatters_by_ft[ft] = formatter_names
                end
            end
            if config.formatters then
                for name, formatter_config in pairs(config.formatters) do
                    formatters[name] = formatter_config
                end
            end
        end
    end

    conform.setup({
        formatters_by_ft = formatters_by_ft,
        formatters = formatters,
        format_on_save = function()
            if _G.auto_format_on_save then
                return { timeout_ms = 500, lsp_format = 'fallback' }
            end
            return nil
        end,
    })
end

return M
