-- lua/code/LLM/doc_string.lua
--
-- 'DocString' 工具的配置 (对应 <leader>ad)
-- 这是从您原来的配置中完整迁移过来的
--

local tools = require("llm.tools")

return {
	prompt = [[ 你是一个 AI 编程助手。你需要为给定的语言编写一个遵循最佳实践的优秀文档字符串。

你的核心任务包括：
- 参数和返回类型（如果适用）
- 可能引发或返回的任何错误，取决于语言

你必须：
- 将生成的文档字符串放在代码开始之前
- 如果提供了示例，请仔细遵循示例的格式
- 在答案中使用 Markdown 格式
- 在 Markdown 代码块开头包含编程语言名称]],
	handler = tools.action_handler,
	opts = {
		only_display_diff = true,
		templates = {
			-- Lua 的模板
			lua = [[- 对于 Lua 语言，你应该使用 LDoc 风格
- 所有注释行都以 "---" 开头
]],
			-- 新增：C++ (cpp) 的模板
			cpp = [[- 对于 C++，你必须遵循 Google C++ 风格指南的注释规范
- 使用 Doxygen 风格的注释
- 使用 `@param` 表示参数，`@return` 表示返回值
- 示例：
  /**
   * @brief 函数的简要描述
   *
   * 函数功能的更详细描述
   * @param param_name 参数的描述
   * @return 函数返回值的描述
   */
]],
		},
	},
}
