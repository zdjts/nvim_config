-- lua/code/formatters/javascript.lua
return {
	formatters_by_ft = {
		html = { "prettier" },
		css = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
	},
	formatters = {
		prettier = {
			command = "prettierd",
			-- Pass the filename to ensure correct parser and config are used
			args = { "--stdin-filepath", "$FILENAME" },
		},
	},
}
