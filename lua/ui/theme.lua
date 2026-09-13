local M = {}

function M.setup()
    require('catppuccin').setup({
        flavour = 'mocha',
        transparent_background = false,
        term_colors = true,
        integrations = {
            treesitter = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { 'italic' },
                    hints = { 'italic' },
                    warnings = { 'italic' },
                    information = { 'italic' },
                },
                underlines = {
                    errors = { 'undercurl' },
                    hints = { 'undercurl' },
                    warnings = { 'undercurl' },
                    information = { 'undercurl' },
                },
            },
            cmp = true,
            gitsigns = true,
            mason = true,
        },
        custom_highlights = function(colors)
            return {
                ['@punctuation.bracket'] = {
                    fg = colors.overlay2,
                    style = { 'bold' },
                },
                DiagnosticVirtualTextError = { fg = colors.red, italic = true },
                DiagnosticVirtualTextWarn = { fg = colors.yellow, italic = true },
                DiagnosticVirtualTextInfo = { fg = colors.blue, italic = true },
                DiagnosticVirtualTextHint = { fg = colors.teal, italic = true },
                DiagnosticSignError = { fg = colors.red, bg = 'NONE' },
                DiagnosticSignWarn = { fg = colors.yellow, bg = 'NONE' },
                DiagnosticSignInfo = { fg = colors.blue, bg = 'NONE' },
                DiagnosticSignHint = { fg = colors.teal, bg = 'NONE' },
            }
        end,
    })
    vim.cmd.colorscheme('catppuccin')
end

return M
