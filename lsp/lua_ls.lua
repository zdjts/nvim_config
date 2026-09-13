---@type vim.lsp.Config
return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        { '.luarc.json', '.luarc.jsonc', '.emmyrc.json' },
        { '.stylua.toml', 'stylua.toml' },
        { 'selene.toml', 'selene.yml' },
        '.luacheckrc',
        '.git',
    },
    settings = {
        Lua = {
            -- 运行时设置：告诉 lua-language-server 这是 Neovim 环境
            runtime = {
                version = 'LuaJIT',
                pathStrict = true,
                path = { '?.lua', '?/init.lua' },
            },
            -- 诊断设置：指定全局变量和库
            diagnostics = {
                -- 定义全局变量
                globals = { 'vim', 'describe', 'it', 'before_each', 'after_each' },
                -- 调整诊断级别
                disable = { 'lowercase-global' },
            },
            -- 工作空间库配置：包含 Neovim 和 LuaJIT 的类型定义
            workspace = {
                library = {
                    vim.env.VIMRUNTIME .. '/lua',
                    '${3rd}/luv/library',
                    '${3rd}/busted/library',
                },
                checkThirdParty = 'Fallback',
                maxPreload = 5000,
                preloadFileSize = 50000,
            },
            -- 代码透镜和 Hint 配置
            codeLens = { enable = true },
            hint = { enable = true, semicolon = 'Disable' },
            -- 补全设置
            completion = {
                callSnippet = 'Replace',
                keywordSnippet = 'Replace',
            },
        },
    },
}