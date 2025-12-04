return {
	-- 1. LSP 命令 (cmd)
	-- 启动 rust-analyzer 的命令。
	-- 确保 rust-analyzer 已经在您的系统 PATH 中。
	cmd = { "rust-analyzer" },

	-- 2. 适用的文件类型 (filetypes)
	-- 明确指定 rust-analyzer 只用于 Rust 文件。
	filetypes = { "rust" },

	-- 3. 根目录标记 (root_markers)
	-- rust-analyzer 用这些文件来识别项目根目录。
	-- 核心是 Cargo.toml 和 .git。
	root_markers = { "Cargo.toml", ".git" },

	-- 4. LSP 设置 (settings)
	-- 这是 rust-analyzer 特有的配置部分，用于微调其行为。
	-- 您可以根据需要添加或删除这些设置。
	settings = {
		["rust-analyzer"] = {
			-- 启用或禁用自动导入缺失的依赖项，非常实用。
			imports = {
				granularity = "module",
				prefix = "self",
			},
			-- 启用额外的代码操作和诊断。
			procMacro = {
				enable = true,
			},
			-- 设置为 true 可以加快启动速度，但需要您手动创建 'rust-project.json' 文件。
			-- 默认 (false) 是自动扫描 Cargo.toml，通常更方便。
			checkOnSave = {
				-- 禁用保存时自动运行 cargo check，如果您的项目很大，这会减少延迟。
				-- 建议通过其他插件 (如 null-ls/efm) 或 hooks 来处理检查。
				enable = true,
				command = "check", -- 默认运行 'cargo check'
				allTargets = false,
			},
			-- 更多实用配置：
			inlayHints = {
				enable = true, -- 启用内联提示（如类型、参数名）
			},
		},
	},
}
