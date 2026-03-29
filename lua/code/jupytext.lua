return {
	{
		"goerz/jupytext.vim",
		lazy = false,
		init = function()
			vim.g.jupytext_fmt = "py:percent"
			vim.g.jupytext_filetype_guess = 1
		end,
	},
	{
		"Vigemus/iron.nvim",
		ft = { "ipynb", "python" },
		config = function()
			local iron = require("iron.core")
			local view = require("iron.view")
			local common = require("iron.fts.common")
			local wk = require("which-key")

			iron.setup({
				config = {
					scratch_repl = true,
					repl_definition = {
						python = {
							command = { "ipython", "--no-autoindent" },
							format = common.bracketed_paste,
							block_dividers = { "# %%", "#%%" },
							env = { PYTHON_BASIC_REPL = "1" },
						},
					},
					repl_open_cmd = view.split.vertical.botright(0.4),
				},
				keymaps = {},
			})

			-- =============================================================================
			-- 最终修正版：严格对齐 iron.core 导出函数
			-- =============================================================================
			-- ... 前面的 iron.setup 部分保持不变 ...

			local ft = "python"
			wk.add({
				{
					buffer = true,
					mode = "n",
					{ "<localleader>r", group = "󰐊 iron-repl" },
					{
						"<localleader>rr",
						function()
							iron.repl_for(ft)
							iron.focus_on(ft)
						end,
						desc = "Iron: Open/Focus REPL",
					},
					{
						"<localleader>rl",
						function()
							iron.hide_repl(ft)
						end,
						desc = "Iron: Hide REPL",
					},
					{
						"<localleader>ra",
						function()
							iron.send_file()
						end,
						desc = "Iron: Run All File",
					},
					{
						"<localleader>rs",
						function()
							iron.send_line()
						end,
						desc = "Iron: Run Line",
					},
					{
						"<localleader>rc",
						function()
							iron.send_code_block()
						end,
						desc = "Iron: Run Cell (# %%)",
					},
					{
						"<localleader>re",
						function()
							iron.reproduce(ft)
						end, -- 核心修正：使用 reproduce
						desc = "Iron: Restart REPL",
					},
					{
						"<localleader>rq",
						function()
							iron.close_repl(ft)
						end,
						desc = "Iron: Exit REPL",
					},
				},
				{
					buffer = true,
					mode = "v",
					{
						"<localleader>rc",
						function()
							iron.visual_send()
						end,
						desc = "Iron: Run Selection",
					},
				},
			})
		end,
	},
}
