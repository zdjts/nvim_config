-- lua/code/formatters/markdown.lua
return {
	formatters_by_ft = {
		markdown = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
	},
	formatters = {
		prettier = {
			command = "prettierd",
			-- Pass the filename to ensure correct parser and config are used
			args = { "--stdin-filepath", "$FILENAME" },
		},
	},
}
