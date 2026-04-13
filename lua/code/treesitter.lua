return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = true,
    build = ':TSUpdate',
    -- event = { 'BufReadPost', 'BufNewFile' },
    -- event = { 'BufReadPost' },
    event = 'VeryLazy',
    config = function()
        require('nvim-treesitter.configs').setup({
            indent = {
                enable = true,
            },
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
                'verilog',
                'rust',
            },
            auto_install = false,
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    -- 对大文件禁用高亮以提高性能
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<CR>',
                    node_incremental = '<CR>',
                    scope_incremental = '<BS>',
                    node_decremental = '<BS>',
                },
            },
        })
    end,
}
