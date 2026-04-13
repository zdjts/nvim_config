---@type vim.lsp.Config
return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        '.emmyrc.json',
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
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
                    vim.fn.expand('$VIMRUNTIME/lua'),
                    vim.fn.expand('${3rd}/luv/library'),
                    vim.fn.expand('${3rd}/busted/library'),
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