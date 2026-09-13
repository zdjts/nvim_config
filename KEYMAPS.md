# Neovim 快捷键配置指南 (最新版)

本文档记录了当前配置中所有激活的快捷键。配置遵循 **Mnemonics (助记符)** 原则，大部分自定义操作通过 `<leader>` (空格) 或 `<localleader>` (逗号) 触发。

## 1. 核心编辑器快捷键

### 窗口管理

| 快捷键  | 动作         | 源文件 |
| :------ | :----------- | :----- |
| `<C-h>` | 移至左侧窗口 |        |
| `<C-j>` | 移至下方窗口 |        |
| `<C-k>` | 移至上方窗口 |        |
| `<C-l>` | 移至右侧窗口 |        |

### Buffer (标签页) 管理

| 快捷键       | 动作                     | 源文件 |
| :----------- | :----------------------- | :----- |
| `[b`         | 上一个 Buffer            |        |
| `]b`         | 下一个 Buffer            |        |
| `<leader>bc` | 删除当前 Buffer (Snacks) |        |

---

## 2. LSP 与代码功能 (`<leader>l` / `g`)

Neovim 0.12 内置全局 LSP 键（不要映射 `gr`，否则会挡住 `gr*` 前缀）：

| 快捷键 | 动作 |
| :----- | :--- |
| `gra` | Code Action |
| `grn` | Rename |
| `grr` | References |
| `gri` | Implementation |
| `grt` | Type Definition |
| `grx` | Code Lens |
| `gO` | Document Symbols |
| `K` | Hover |
| `[d` / `]d` | 上一个/下一个诊断 |
| `<C-w>d` | 当前诊断浮窗 |

### 额外别名与跳转

| 快捷键 | 动作 | 源文件 |
| :----- | :--- | :----- |
| `gd` | 跳转到定义 | `lua/lsp/lsp.lua` |
| `gD` | 跳转到声明 | `lua/lsp/lsp.lua` |
| `<leader>la` | 代码操作 (Code Action) | `lua/lsp/lsp.lua` |
| `<leader>ln` | 重命名 (Rename) | `lua/lsp/lsp.lua` |
| `<leader>ld` | 显示当前行诊断详情 | `lua/lsp/lsp.lua` |
| `<leader>ls` | 文档符号 | `lua/lsp/lsp.lua` |
| `<leader>th` | 开关 Inlay Hints | `lua/lsp/lsp.lua` |
| `<leader>td` | 开关 diagnostics | `lua/lsp/lsp.lua` |
| `<leader>ti` | 开关 LSP inline completion（服务器支持时） | `lua/lsp/lsp.lua` |
| `<A-l>` | **(插入模式)** 采纳 LSP inline completion | `lua/lsp/lsp.lua` |
| `grx` | 运行 Code Lens | Neovim 0.12 默认 |
| `<leader>fc` | 格式化当前文件 (Conform) | `lua/code/conform.lua` |
| `[e` / `]e` | 上一个/下一个错误 | `lua/config/keymaps.lua` |
| `[w` / `]w` | 上一个/下一个警告 | `lua/config/keymaps.lua` |

---

## 3. LLM (人工智能) 功能 (`<leader>a` / `<leader>t`)

| 快捷键       | 动作                                      | 源文件 |
| :----------- | :---------------------------------------- | :----- |
| `<leader>t`  | 翻译当前行 / 选中文本 (llm_translate)     | `lua/code/llm_translate.lua` |
| `<leader>ag` | 生成 AI 提交信息 (llm-commit.nvim)        | `lua/code/llm_commit.lua` |
| `<leader>al` | 切换 LLM 代码补全开启/关闭状态            |        |
| `Alt + a`    | **(插入模式)** 采纳当前的行内代码补全建议 |        |

---

## 4. 文件查找与 UI 开关 (`<leader>f`)

### 查找 (Snacks Picker)

| 快捷键       | 动作                       | 源文件 |
| :----------- | :------------------------- | :----- |
| `<leader>ff` | 智能查找文件               |        |
| `<leader>fw` | 全局搜索文本 (Grep)        |        |
| `<leader>fh` | 查找帮助文档               |        |
| `<leader>e`  | 打开 Oil 文件浏览器 (浮窗) |        |

### 界面开关

| 快捷键                 | 动作                        | 源文件 |
| :--------------------- | :-------------------------- | :----- |
| `<C-/>` / `<leader>ft` | 打开/关闭终端 (ToggleTerm)  |        |
| `<leader>uz`           | 禅模式 (Zen Mode)           |        |

---

## 5. 运行与任务控制 (`<localleader>r` 即 `,r`)

该组快捷键根据**文件类型**动态变化：

### 通用 (Overseer) - 适用于 C++, Shell, Rust 等

| 快捷键 | 动作             | 源文件 |
| :----- | :--------------- | :----- |
| `,rr`  | 运行任务列表     |        |
| `,rl`  | 切换任务列表窗口 |        |
| `,rc`  | 运行 Shell 命令 (`:OverseerShell`) |        |
| `,rq`  | 任务动作 (`:OverseerTaskAction`) |        |
| `,re`  | 重启上一个任务   |        |

### Python (Iron.nvim REPL)

| 快捷键 | 动作                              | 源文件 |
| :----- | :-------------------------------- | :----- |
| `,rr`  | 打开并定位到 REPL 窗口            |        |
| `,rc`  | 发送当前行或代码块 (# %%) 到 REPL |        |
| `,ra`  | 运行整个文件                      |        |

### 实时预览

| 快捷键 | 动作                                       | 源文件 |
| :----- | :----------------------------------------- | :----- |
| `,rr`  | Markdown 预览 / Typst 预览 / HTML 实时预览 |        |

---

## 6. Git 操作 (`<leader>g`)

| 快捷键       | 动作                  | 源文件 |
| :----------- | :-------------------- | :----- |
| `<leader>go` | 打开 LazyGit          |        |
| `<leader>gl` | 查看 Git 日志         |        |
| `<leader>gf` | 查看当前文件 Git 日志 |        |

---

## 7. 其他功能

- **快速跳转**: `s` 触发 Flash 跳转，`S` 触发 Flash Treesitter 选择。
- **终端模式**: 在终端内按 `<Esc>` 可退出输入模式回到普通模式。
- **Undo tree** (`:Undotree`): `<leader>uu`
- **插件更新** (`vim.pack`): `<leader>pu` 更新（新标签确认后 `:w` 应用），`<leader>ps` 查看状态。
- **LSP 管理**: `:lsp`（0.12 内置）。
