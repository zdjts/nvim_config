return {
    -- 1. 解析器管理：使用专为 0.12 打造的轻量级管理器替代旧插件
    {
        'romus204/tree-sitter-manager.nvim',
        lazy = false, -- 确保在启动时加载，以便打开文件时能正确读取解析器
        config = function()
            require('tree-sitter-manager').setup({
                -- 声明你需要的语言解析器
                ensure_installed = {
                    'bash',
                    'python',
                    'cpp',
                    'html',
                    'xml',
                    'lua',
                    'luadoc',
                    'markdown',
                    'markdown_inline',
                    'query',
                    'vim',
                    'vimdoc',
                    -- 'verilog',
                    'rust',
                },
                -- 是否在打开未知文件类型时自动尝试下载对应的解析器
                auto_install = true,
            })

            -- 2. 性能优化：使用 Neovim 0.12 原生 API 实现大文件禁用 Treesitter 的逻辑
            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('NativeLargeFileTSDisable', { clear = true }),
                callback = function(args)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
                    if ok and stats and stats.size > max_filesize then
                        -- 主动停止当前 buffer 的原生 Treesitter 解析，防止卡顿
                        vim.treesitter.stop(args.buf)
                    end
                end,
            })
        end,
    },
}
