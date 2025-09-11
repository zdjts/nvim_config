-- lua/core/keymaps.lua

local wk = require("which-key")
print("hello world")

local keymaps = {
	{ "<leader>f", group = "file" },
	{ "<leader>b", group = "buffer" },
	{ "<leader>l", group = "lsp" },
	{ "<leader>t", group = "toggle" },
	{ "<leader>w", group = "window" },
	{ "<leader>d", group = "diagnostic" },
	-- Diagnostic keymaps
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
	-- Window navigation
	{ "<C-h>", "<C-w>h", desc = "Window left", mode = "n" },
	{ "<C-j>", "<C-w>j", desc = "Window down", mode = "n" },
	{ "<C-k>", "<C-w>k", desc = "Window up", mode = "n" },
	{ "<C-l>", "<C-w>l", desc = "Window right", mode = "n" },

	{ "<leader>fn", "<cmd>e<cr>", desc = "create file" },
	{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "previous buffer" },
	{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "next buffer" },

	-- lsp config
	{ "gd", vim.lsp.buf.definition, desc = "LSP: Goto Definition", mode = "n" },
	{ "gr", vim.lsp.buf.references, desc = "LSP: Goto References", mode = "n" },
	{ "gD", vim.lsp.buf.declaration, desc = "LSP: Goto Declaration", mode = "n" },
	{ "K", vim.lsp.buf.hover, desc = "LSP: Hover Documentation", mode = "n" },

	{ "<leader>la", vim.lsp.buf.code_action, desc = "LSP: Code Action", mode = "n" },
	{ "<leader>ln", vim.lsp.buf.rename, desc = "LSP: Rename", mode = "n" },
	{ "<leader>ld", vim.diagnostic.open_float, desc = "LSP: Line Diagnostics", mode = "n" },
	{ "<c-/>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal", mode = "n" },

	-- flash.nvim config
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
	-- { "r", function() require("flash").remote() end, desc = "Remote Flash", mode = "o" },
	-- { "R", function() require("flash").treesitter_search() end, desc = "Treesitter Search", mode = { "o", "x" } },
	-- { "<c-s>", function() require("flash").toggle() end, desc = "Toggle Flash Search", mode = { "c" } },

	-- Conform.nvim (Formatter)
	{
		"<leader>fc",
		function()
			require("conform").format({ async = true, lsp_fallback = true })
		end,
		desc = "Format buffer",
		mode = { "n", "v" },
	},
	{
		"<leader>ft",
		"<cmd>ToggleTerm<CR>",
		desc = "ToggleTerm",
		mode = "n",
	},
})

wk.add(keymaps)
