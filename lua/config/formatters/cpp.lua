-- lua/code/formatters/cpp.lua
return {
	formatters_by_ft = {
		cpp = { "clang-format" },
		c = { "clang-format" },
		objc = { "clang-format" },
		objcpp = { "clang-format" },
	},
	formatters = {
		["clang-format"] = {
			-- 使用命令行参数指定Google风格，无需 .clang-format 文件
			args = { "--style={BasedOnStyle: Google, ColumnLimit: 100, IndentWidth: 4}" },
		},
	},
}
