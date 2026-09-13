-- ~/.config/nvim/init.lua
if vim.fn.has('nvim-0.12') == 0 then
    vim.notify('This config requires Neovim 0.12+', vim.log.levels.ERROR)
    return
end

require('config.options')
require('config.autocmds')
require('config.pack')
require('config.load')
require('config.keymaps')
require('lsp.lsp')
