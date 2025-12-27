vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
vim.lsp.enable('marksman')
vim.lsp.enable('bashls')
vim.lsp.enable('cmake')
vim.lsp.enable('texlab')
vim.lsp.enable('tsserver')
vim.lsp.enable('html-lsp')
vim.lsp.enable('solidity_ls')
vim.lsp.enable('cssls')
vim.lsp.enable('rust-analyzer')
-- lua/lsp/lsp.lua
--
-- LSP 通用配置文件
-- 这是一个自包含文件，不依赖于外部的 'ui.icons' 或其他自定义模块。
-- 它负责定义 LSP 附加到缓冲区时的通用行为，例如快捷键和 UI 美化。

-- ===================================================================
-- 1. 在文件顶部定义所有需要的图标，避免外部依赖
-- ===================================================================
local diagnostic_icons = {
    ERROR = '',
    WARN = '',
    INFO = '',
    HINT = '',
}

-- ===================================================================
-- 2. 设置 LSP 附加时的回调函数
-- ===================================================================
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my-lsp-attach-group', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        -- 定义一个快捷键映射的辅助函数，确保只对当前缓冲区生效
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        -- 切换诊断信息显示的逻辑
        local diag_status = 1
        map('n', '<leader>td', function()
            if diag_status == 1 then
                diag_status = 0
                vim.diagnostic.config({ underline = false, virtual_text = false, signs = false }, 0)
            else
                diag_status = 1
                vim.diagnostic.config({ underline = true, virtual_text = true, signs = true }, 0)
            end
        end, 'LSP: Toggle diagnostics display')

        -- 1. 代码折叠 (使用冒号调用 :supports_method)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
            vim.wo.foldlevel = 99
        end

        -- 2. Inlay Hints (修正 enable 参数签名)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('n', '<leader>th', function()
                -- 0.12 推荐写法：is_enabled 现在接收 filter 表
                local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                -- enable 第一个参数是 boolean，第二个参数是 filter 表
                vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
            end, 'LSP: Toggle Inlay Hints')
        end

        -- 3. 光标下单词高亮 (使用冒号调用 :supports_method)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('my-lsp-highlight', { clear = true })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = bufnr,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = bufnr,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

-- ===================================================================
-- 3. 美化诊断信息的 UI (使用本文件中定义的图标)
-- ===================================================================
vim.diagnostic.config({
    virtual_text = {
        spacing = 4,
        prefix = '●',
    },
    float = { severity_sort = true },
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
            [vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
            [vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
            [vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
        },
    },
})

-- ===================================================================
-- 4. 添加方便的自定义命令
-- ===================================================================
vim.api.nvim_create_user_command('LspInfo', ':checkhealth lsp', { desc = 'Alias to `:checkhealth lsp`' })

vim.api.nvim_create_user_command('LspLog', function()
    local log_path = vim.lsp.log.get_filename()
    vim.cmd('tabnew ' .. log_path)
end, { desc = 'Opens the Nvim LSP client log.' })
