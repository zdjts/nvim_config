vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'text', 'gitcommit', 'gitrebase' },
    callback = function()
        vim.opt_local.spell = false
    end,
    desc = 'Disable spellcheck for specific filetypes',
})

-- Force .h files to be treated as C++
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.h',
    callback = function()
        vim.bo.filetype = 'cpp'
    end,
    desc = 'Set .h filetype to cpp for clangd',
})
