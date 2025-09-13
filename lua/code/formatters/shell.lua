-- lua/code/formatters/shell.lua
return {
	formatters_by_ft = {
		sh = { "shfmt" },
		bash = { "shfmt" },
	},
	formatters = {
		shfmt = {
			-- Indent with 2 spaces
			args = { "-i", "2" },
		},
	},
}