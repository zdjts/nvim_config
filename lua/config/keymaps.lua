local wk = require("which-key")

-- =============================================================================
-- 1. 自动命令组定义 (用于管理动态键位)
-- =============================================================================
local run_key_group = vim.api.nvim_create_augroup("UserRunKeyGroup", { clear = true })

-- 黑名单：在这些文件类型中，完全不加载 Overseer 的快捷键
local overseer_blacklist = {
	python = true,
	ipynb = true,
	markdown = true,
	typst = true,
	html = true,
}

-- =============================================================================
-- 2. 动态键位注入逻辑
-- =============================================================================

-- A. Overseer 注入 (仅针对非黑名单文件)
vim.api.nvim_create_autocmd("FileType", {
	group = run_key_group,
	pattern = "*",
	callback = function(ev)
		if not overseer_blacklist[vim.bo[ev.buf].filetype] then
			wk.add({
				{
					buffer = ev.buf,
					{ "<localleader>rr", "<cmd>OverseerRun<cr>", desc = "Run Task (List)" },
					{ "<localleader>rl", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
					{ "<localleader>rb", "<cmd>OverseerBuild<cr>", desc = "Task Builder" },
					{ "<localleader>rc", "<cmd>OverseerRunCmd<cr>", desc = "Run Command" },
					{ "<localleader>rq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
					{ "<localleader>ri", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
					{ "<localleader>re", "<cmd>OverseerRestartLast<cr>", desc = "Restart Last Task" },
				},
			})
		end
	end,
})

-- B. 预览类文件注入 (Markdown, Typst, HTML)
vim.api.nvim_create_autocmd("FileType", {
	group = run_key_group,
	pattern = { "markdown", "typst", "html" },
	callback = function(ev)
		local ft = vim.bo[ev.buf].filetype
		local spec = {
			markdown = {
				desc = "Preview: Markdown",
				cmd = function()
					vim.cmd("MarkdownPreview")
				end,
			},
			typst = { desc = "Preview: Typst", cmd = "<cmd>TypstPreview<cr>" },
			html = { desc = "Preview: HTML", cmd = "<cmd>LivePreview start<cr>" },
		}

		local current = spec[ft]
		if current then
			wk.add({
				{ "<localleader>rr", current.cmd, desc = current.desc, buffer = ev.buf },
			})
		end
	end,
})

-- =============================================================================
-- 3. 全局静态快捷键定义
-- =============================================================================
local keymaps = {
	-- 分组定义
	{ "<leader>f", group = " file" },
	{ "<leader>b", group = " buffer" },
	{ "<leader>l", group = " lsp" },
	{ "<leader>t", group = "󰚙 toggle" },
	{ "<leader>d", group = " diagnostic" },
	{ "<leader>g", group = " git" },
	{ "<leader>a", group = " LLM" },
	{ "<leader>c", group = " code" },
	{ "<leader>u", group = "󱖫 use status" },
	{ "<localleader>r", group = "󰐊 run/task" },

	-- 窗口导航
	{ "<C-h>", "<C-w>h", desc = "Window left" },
	{ "<C-j>", "<C-w>j", desc = "Window down" }, -- 修正笔误
	{ "<C-k>", "<C-w>k", desc = "Window up" },
	{ "<C-l>", "<C-w>l", desc = "Window right" },

	-- 诊断跳转
	{
		"]e",
		function()
			vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
		end,
		desc = "Next Error",
	},
	{
		"[e",
		function()
			vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
		end,
		desc = "Prev Error",
	},
	{
		"]w",
		function()
			vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })
		end,
		desc = "Next Warning",
	},
	{
		"[w",
		function()
			vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })
		end,
		desc = "Prev Warning",
	},

	-- 文件与 Buffer
	{ "<leader>fn", "<cmd>e<cr>", desc = "Create File" },
	{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
	{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },

	-- LSP 核心功能
	{ "gd", vim.lsp.buf.definition, desc = "LSP: Goto Definition" },
	{ "gr", vim.lsp.buf.references, desc = "LSP: Goto References" },
	{ "gD", vim.lsp.buf.declaration, desc = "LSP: Goto Declaration" },
	{ "K", vim.lsp.buf.hover, desc = "LSP: Hover Documentation" },
	{ "<leader>la", vim.lsp.buf.code_action, desc = "LSP: Code Action" },
	{ "<leader>ln", vim.lsp.buf.rename, desc = "LSP: Rename" },
	{ "<leader>ld", vim.diagnostic.open_float, desc = "LSP: Line Diagnostics" },
	{ "<leader>ls", vim.lsp.buf.document_symbol, desc = "LSP: Document Symbols" },
	{ "<C-.>", vim.lsp.buf.code_action, desc = "LSP: Quick Fix" },

	-- 功能插件
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
		desc = "Format Buffer",
		mode = { "n", "v" },
	},
	{ "<c-/>", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
	{ "<leader>ft", "<cmd>ToggleTerm<CR>", desc = "ToggleTerm" },

	-- LLM 状态切换
	{
		"<leader>al",
		function()
			local s = require("llm.state").completion
			s.enable = not s.enable
			vim.g.LLM_COMPLETION_STATUS = not vim.g.LLM_COMPLETION_STATUS
		end,
		desc = "Toggle LLM Completion",
	},
}

-- 应用全局键位
wk.add(keymaps)
