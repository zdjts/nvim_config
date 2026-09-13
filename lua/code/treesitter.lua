local M = {}

function M.setup()
    require('tree-sitter-manager').setup({
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
            'rust',
        },
        auto_install = true,
        noauto_install = {
            'c',
            'lua',
            'markdown',
            'markdown_inline',
            'query',
            'vim',
            'vimdoc',
        },
    })

    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('NativeLargeFileTSDisable', { clear = true }),
        callback = function(args)
            local max_filesize = 100 * 1024
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
            if ok and stats and stats.size > max_filesize then
                vim.schedule(function()
                    pcall(vim.treesitter.stop, args.buf)
                end)
            end
        end,
    })
end

return M
