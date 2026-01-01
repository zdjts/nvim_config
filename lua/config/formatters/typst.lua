return {
    formatters_by_ft = {
        -- 核心推荐：typstyle (The rustfmt for Typst)
        typst = { 'typstyle' },
    },
    formatters = {
        ['typstyle'] = {
            -- 按照你的 Rust/Google 风格习惯进行配置
            -- -c / --column: 设为 100
            -- -t / --indent-width: 如果你习惯 Rust 的 4 空格可以设为 4，否则 2 是默认值
            args = { '--column', '100', '--indent-width', '4' },

            -- 重要：确保 conform 将格式化后的内容正确读取
            -- typstyle 默认输出到 stdout，这符合 conform 的工作流
        },
    },
}
