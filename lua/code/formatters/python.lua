-- lua/code/formatters/python.lua
return {
	formatters_by_ft = {
		python = { "ruff" },
	},
	formatters = {
		ruff = {
			command = "ruff",
			-- Use stdin and stdout, and provide filename for config resolution
			args = { "format", "--stdin-filename", "$FILENAME", "-" },
			stdin = true,
		},
	},
}