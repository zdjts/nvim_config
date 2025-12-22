-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- vim.opt.spell = false
-- setting <localleader> is
vim.g.maplocalleader = ','
-- -- vim.opt.clipboard = 'unnamedplus'
vim.opt.clipboard = ''
vim.g.mapleader = ' '
-- vim.o.relativenumber = true
vim.o.number = true
vim.o.relativenumber = true

vim.o.tabstop = 2 -- Tab 键宽度设置为 2 个空格
vim.o.shiftwidth = 2 -- 自动缩进宽度设置为 2 个空格
vim.o.expandtab = true -- 按 Tab 键时插入空格，而不是 Tab 字符

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.syntax = 'off'

if vim.g.LLM_COMPLETION_STATUS == nil then
    print('set llm_status')
    vim.g.LLM_COMPLETION_STATUS = true
end
