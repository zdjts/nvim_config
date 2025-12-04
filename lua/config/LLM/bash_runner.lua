-- lua/code/LLM/bash_runner.lua
--
-- 'BashRunner' 工具的配置 (对应 <leader>ar)
-- 这是一个使用了 'qa_handler' 和 'function_tbl' 的复杂工具
--

local tools = require("llm.tools")

return {
	handler = tools.qa_handler,
	prompt = [[编写一个合适的 bash 脚本并通过 CodeRunner 运行它]],
	opts = {
		enable_thinking = false,

		component_width = "60%",
		component_height = "50%",
		query = {
			title = "  CodeRunner ",
			hl = { link = "Define" },
		},
		input_box_opts = {
			size = "15%",
			win_options = {
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
			},
		},
		preview_box_opts = {
			size = "85%",
			win_options = {
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
			},
		},

		-- 关键部分：自定义函数
		functions_tbl = {
			CodeRunner = function(code)
				local filepath = "/tmp/script.sh"

				vim.notify(
					string.format("CodeRunner 正在运行...\n```bash\n%s\n```", code),
					vim.log.levels.INFO,
					{ title = "llm: CodeRunner" }
				)

				local file = io.open(filepath, "w")
				if file then
					file:write(code)
					file:close()
					local script_result = vim.system({ "bash", filepath }, { text = true }):wait()
					os.remove(filepath)

					-- 【改进点】检查输出是否为空
					if script_result.stdout == nil or script_result.stdout == "" then
						if script_result.stderr and script_result.stderr ~= "" then
							return "脚本执行出错: " .. script_result.stderr
						else
							return "脚本执行成功，但没有输出内容。"
						end
					else
						return script_result.stdout
					end
				else
					return "创建脚本文件失败。"
				end
			end,
		},

		-- 关键部分：函数 Schema
		schema = {
			{
				type = "function",
				["function"] = {
					name = "CodeRunner",
					description = "Bash 代码解释器",
					parameters = {
						properties = {
							code = {
								type = "string",
								description = "bash 代码",
							},
						},
						required = { "code" },
						type = "object",
					},
				},
			},
		},
	},
}
