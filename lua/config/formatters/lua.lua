-- lua/code/formatters/lua.lua
return {
    formatters_by_ft = {
        lua = { 'stylua' },
    },
    formatters = {
        stylua = {
            -- Automatically find and use .stylua.toml or stylua.toml
            args = { '--search-parent-directories', '-' },
        },
    },
}
