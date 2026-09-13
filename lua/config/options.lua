-- Must be set before lazy.nvim loads any plugin mappings.
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.opt.clipboard = ''
vim.o.number = true
vim.o.relativenumber = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Disable netrw (oil is the file explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.syntax = 'off'
vim.opt.winborder = 'rounded'
vim.opt.pumborder = 'rounded'
-- Native 'autocomplete' is unused: blink.cmp owns insert completion.
-- Experimental ui2 is unused: noice.nvim owns cmdline/messages UI.

if vim.g.LLM_COMPLETION_STATUS == nil then
    vim.g.LLM_COMPLETION_STATUS = true
end

-- Shared by minuet / llm-commit / llm-translate.
-- Lowercase vim.g is not stored in shada (:h shada-!).
vim.g.llm_base_url = 'http://127.0.0.1:4000'
vim.g.llm_api_key = vim.env.LLM_KEY
vim.g.llm_model = 'glm-5.3-flash'
