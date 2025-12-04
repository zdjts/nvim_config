return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = true,
	build = ":TSUpdate",
	-- event = { 'BufReadPost', 'BufNewFile' },
	-- event = { 'BufReadPost' },
	event = "VeryLazy",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"python",
				"cpp",
				"html",
				"xml",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"verilog",
			},
			auto_install = false,
			highlight = {
				enable = true,
			},
		})
	end,
}
