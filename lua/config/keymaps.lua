local wk = require("which-key")
local run_key_group = vim.api.nvim_create_augroup("FileTypeKeyMaps", { clear = true })
function md_create()
	vim.keymap.set("n", "<localleader>r", function()
		require("peek").close()
		require("peek").open()
	end, { buffer = true })
end
vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", callback = md_create, group = run_key_group })

local keymaps = {
	{ "<leader>f", group = " file" },
	{ "<leader>b", group = " buffer" },
	{ "<leader>l", group = " lsp" },
	{ "<leader>t", group = "󰚙 toggle" },
	{ "<leader>d", group = " diagnostic" },
	{ "<leader>g", group = " git" },
	{ "<leader>a", group = " LLM" },
	{ "<leader>c", group = " code" },
	{ "<leader>u", group = "󱖫 use status" },
	{
		"]e",
		function()
			vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
		end,
		desc = "Next Error",
	},
	{
		"[e",
		function()
			vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
		end,
		desc = "Prev Error",
	},
	{
		"]w",
		function()
			vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
		end,
		desc = "Next Warning",
	},
	{
		"[w",
		function()
			vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
		end,
		desc = "Prev Warning",
	},
}

table.insert(keymaps, {
	{ "<C-h>", "<C-w>h", desc = "Window left", mode = "n" },
	{ "<C-j>", "<C-w>j", desc = "Window down", mode = "n" },
	{ "<C-k>", "<C-w>k", desc = "Window up", mode = "n" },
	{ "<C-l>", "<C-w>l", desc = "Window right", mode = "n" },
	{ "<leader>fn", "<cmd>e<cr>", desc = "create file" },
	{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "previous buffer" },
	{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "next buffer" },
	{ "gd", vim.lsp.buf.definition, desc = "LSP: Goto Definition", mode = "n" },
	{ "gr", vim.lsp.buf.references, desc = "LSP: Goto References", mode = "n" },
	{ "gD", vim.lsp.buf.declaration, desc = "LSP: Goto Declaration", mode = "n" },
	{ "K", vim.lsp.buf.hover, desc = "LSP: Hover Documentation", mode = "n" },
	{
		"<leader>la",
		vim.lsp.buf.code_action,
		desc = "LSP: Code Action",
		mode = "n",
	},
	{ "<leader>ln", vim.lsp.buf.rename, desc = "LSP: Rename", mode = "n" },
	{
		"<leader>ld",
		vim.diagnostic.open_float,
		desc = "LSP: Line Diagnostics",
		mode = "n",
	},
	{ "<c-/>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal", mode = "n" },
	{
		"s",
		function()
			require("flash").jump()
		end,
		desc = "Flash",
		mode = { "n", "x", "o" },
	},
	{
		"S",
		function()
			require("flash").treesitter()
		end,
		desc = "Flash Treesitter",
		mode = { "n", "x", "o" },
	},
	{
		"<leader>fc",
		function()
			require("conform").format({ async = true, lsp_fallback = true })
		end,
		desc = "Format buffer",
		mode = { "n", "v" },
	},
	{ "<leader>ft", "<cmd>ToggleTerm<CR>", desc = "ToggleTerm", mode = "n" },
})

wk.add(keymaps)
