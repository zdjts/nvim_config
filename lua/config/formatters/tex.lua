-- lua/code/formatters/tex.lua
return {
	formatters_by_ft = { tex = { "latexindent" } },
	formatters = {
		latexindent = {
			args = {
				"-l",
				"-o=-",
				"-",
			},
			stdin = true,
		},
	},
}
