-- lua/config/formatters/rust.lua
-- Use conform's builtin rustfmt (no nvim-lspconfig).

return {
    formatters_by_ft = {
        rust = { 'rustfmt' },
    },
}
