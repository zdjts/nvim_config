-- lua/code/LLM/commit_msg.lua
--
-- 'CommitMsg' 工具的配置 (对应 <leader>ag)
-- 这是从您原来的配置中完整迁移过来的
--

local tools = require("llm.tools")

return {
	-- 1. 选择正确的处理器
	handler = tools.flexi_handler,

	-- 2. 动态生成 Prompt
	prompt = function()
		-- 获取暂存区的 diff 内容
		local diff_content = vim.fn.system("git diff --no-ext-diff --staged")

		-- 将 diff 内容格式化到 Prompt 模板中
		return string.format(
			[[你是一个遵循 Conventional Commit 规范的专家。请根据下面列出的 git diff 内容为我生成一个提交信息：
      1. 第一行：常规提交格式（类型：简洁描述）（记住使用语义化类型如 feat、fix、docs、style、refactor、perf、test、chore 等）
      2. 如果需要更多上下文，可选的要点：
        - 保持第二行为空
        - 保持简短直接
        - 专注于变更内容
        - 始终保持简洁
        - 不要过度解释
        - 避免任何华丽或正式的语言

      只返回提交信息 - 不要介绍，不要解释，不要用引号包围。

      示例：
      feat: 添加用户认证系统

      - 为 API 认证添加 JWT 令牌
      - 处理长时间会话的令牌刷新

      fix: 解决工作池中的内存泄漏

      - 清理空闲连接
      - 为陈旧工作线程添加超时

      简单变更示例：
      fix: 修复 README.md 中的拼写错误

      非常重要：不要回复任何示例。你的消息必须基于即将提供的 diff，并根据你即将看到的最近提交进行少量样式调整。

      基于此格式，生成适当的提交信息。仅返回消息。不要将消息格式化为 Markdown 代码块，不要使用反引号：

      ```diff
      %s
      ```
      ]],
			diff_content
		)
	end,

	-- 3. 为工具定制选项
	opts = {
		-- 核心配置：上下文不来自视觉选择，而是来自上面的 prompt 函数
		apply_visual_selection = false,

		-- 自动聚焦到弹出的结果窗口
		enter_flexible_window = true,

		-- 配置窗口居中显示
		win_opts = {
			relative = "editor",
			position = "50%",
		},

		-- 4. 定义接受操作：这是最精彩的部分！
		accept = {
			mapping = {
				mode = "n",
				keys = "<cr>", -- 在结果窗口的普通模式下，按回车键触发
			},
			action = function()
				-- a. 获取 AI 生成的所有行（commit message）
				local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)

				-- b. 巧妙地将多行 message 转换为多个 -m 参数
				-- 例如 ["feat: new", "body"] 会变成 "feat: new\" -m \"body"
				local commit_cmd_part = table.concat(contents, '" -m "')

				-- c. 构建并执行 git commit 命令
				local final_cmd = string.format('!git commit -m "%s"', commit_cmd_part)
				vim.api.nvim_command(final_cmd)

				-- d. (可选) 提交后自动打开 LazyGit，方便推送
				vim.schedule(function()
					-- 确保您在其他地方 require('snacks')
					-- 或者如果它是一个全局模块
					require("snacks").lazygit.open()
				end)
			end,
		},
	},
}
