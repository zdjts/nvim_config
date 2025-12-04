-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text", "gitcommit", "gitrebase" }, -- 对这些文件类型禁用拼写检查
	callback = function()
		vim.opt.spell = false
	end,
	desc = "Disable spellcheck for specific filetypes",
})

-- Force .h files to be treated as C++
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.h",
	callback = function()
		vim.bo.filetype = "cpp"
	end,
	desc = "Set .h filetype to cpp for clangd",
})
