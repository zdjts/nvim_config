-- lua/ui/snacks.lua
return {
	"folke/snacks.nvim",
	-- [优化] 将快捷键与它们对应的函数直接绑定
	keys = {
		{
			"<leader>ff",
			function()
				require("snacks").picker.smart()
			end,
			desc = "Smart find file",
		},
		{
			"<leader>fw",
			function()
				require("snacks").picker.grep()
			end,
			desc = "Find content",
		},
		{
			"<leader>fh",
			function()
				require("snacks").picker.help()
			end,
			desc = "Find help",
		},
		{
			"<leader>bc",
			function()
				require("snacks").bufdelete.delete()
			end,
			desc = "Delete buffers",
		},
		{
			"<leader>udn",
			function()
				require("snacks").dim.disable()
			end,
			desc = "no use dim",
		},
		{
			"<leader>udy",
			function()
				require("snacks").dim.enable()
			end,
			desc = "use dim",
		},
		{
			"<leader>uz",
			function()
				require("snacks").zen.zen()
			end,
			desc = "use zen",
		},
		{
			"<leader>gl",
			function()
				require("snacks").lazygit.log()
			end,
			desc = "Lazygit log",
		},
		{
			"<leader>gf",
			function()
				require("snacks").lazygit.log_file()
			end,
			desc = "Lazygit file log",
		},
		{
			"<leader>go",
			function()
				require("snacks").lazygit.open()
			end,
			desc = "Lazygit open",
		},
	},

	-- config 函数现在只负责 setup，不再需要手动设置快捷键
	config = function()
		require("snacks").setup({
			-- 所有的配置项都在这里
			bigfile = { enabled = true },
			dashboard = { enabled = false },
			explorer = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = false },
			quickfile = { enabled = true },
			scope = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			dim = { enabled = true },
			zen = { enalbed = true },
			lazygit = { enabled = true },
			image = {
				enabled = true,
			},
		})

		-- [已删除] 所有手动的 map(...) 调用都已移除，因为 lazy.nvim 处理了
	end,
}
