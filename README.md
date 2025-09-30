# Neovim 重装配置指南

## 1. 配置文件下载

使用以下命令克隆配置文件到用户目录：

```bash
git clone https://github.com/zdjts/nvim_config.git ~/.config/nvim
```

## 2. Mason 插件管理器配置

### 2.1 Mason 简介

Mason 是 Neovim 的包管理器，用于管理 LSP 服务器、格式化工具等开发工具。

### 2.2 需要安装的工具列表

在 Mason 中安装以下开发工具：

- `clang-format` - C/C++ 代码格式化工具
- `clangd` - C/C++ 语言服务器
- `cmake-language-server` - CMake 语言服务器
- `latexindent` - LaTeX 代码格式化工具
- `llm-ls` - 大语言模型语言服务器
- `lua-language-server` - Lua 语言服务器
- `marksman` - Markdown 语言服务器
- `prettierd` - 通用代码格式化工具
- `ruff` - Python 代码检查和格式化工具
- `shfmt` - Shell 脚本格式化工具
- `stylua` - Lua 代码格式化工具
- `texlab` - LaTeX 语言服务器
- `typescript-language-server` - TypeScript 语言服务器
- `html-lsp` - HTML及CSS语言服务器
- `vscode-solidity-server` - solidity 语言服务器

### 2.3 安装命令

在 Neovim 中执行以下命令安装所有工具：

```
:MasonInstall clang-format clangd cmake-language-server latexindent llm-ls lua-language-server marksman prettierd ruff shfmt stylua texlab typescript-language-server html-lsp vscode-solidity-server
```

## 3. 格式化配置文件

需要在主目录下创建相应的配置文件来支持各种格式化工具：

### 3.1 配置文件位置

所有配置文件位于用户主目录下（`~`）：

- `~/.ruff.toml` - Ruff Python 格式化配置
- `~/.stylua.toml` - Stylua Lua 格式化配置
- `~/.prettierrc.json` - Prettier 通用格式化配置
- `~/.latexmkrc` - LaTeX 编译配置
