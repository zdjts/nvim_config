-- 作者从toppair/peek.nvim fork一份
return {
	"toppair/peek.nvim",
	event = { "VeryLazy" },
	build = "deno task --quiet build:fast",
	config = function()
		require("peek").setup({
			app = {
				"google-chrome-stable",
				-- "--app=http://localhost:9000/?theme=dark",
				"--incognito",
				"--no-first-run",
				"--disable-features=Translate",
			},
		})
	end,
}
