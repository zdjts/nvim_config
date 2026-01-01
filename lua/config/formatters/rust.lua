-- lua/code/formatters/rust.lua
-- 这是一个针对 Rust 语言，使用 rustfmt 的格式化器配置。

return {
    -- 1. 适用的文件类型
    formatters_by_ft = {
        rust = { 'rustfmt' },
    },

    -- 2. 定义格式化器命令
    formatters = {
        ['rustfmt'] = {
            -- 命令：运行 Cargo fmt
            -- 推荐使用 'cargo fmt'，因为它会自动处理 Cargo Workspace 和项目上下文。
            -- 如果您的格式化工具只接受单个命令，也可以直接使用 'rustfmt'。
            command = 'Cargo',
            -- 参数：执行 'fmt' 子命令
            args = { 'fmt', '--' },
            -- 注意：'--' 是为了分隔 cargo fmt 的参数和 rustfmt 自身的参数，确保其行为正确。

            -- 根目录：确保格式化器只在 Cargo 项目中运行
            root_dir = require('lspconfig').util.root_pattern('Cargo.toml'),

            -- Rustfmt 的配置（如 4空格/100列）将由项目根目录的 'rustfmt.toml' 文件控制。
            -- 在这里无需像 clang-format 一样传递 --style 参数。
        },
    },
}
