-- ===================================================================
-- 1. LSP 快速启用
-- ===================================================================
local servers = {
    'lua_ls',
    'clangd',
    'pyright',
    'marksman',
    'bashls',
    'cmake',
    'texlab',
    'tsserver',
    'html-lsp',
    'solidity_ls',
    'cssls',
    'rust-analyzer',
}
for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

-- ===================================================================
-- 2. 诊断图标定义
-- ===================================================================
local diagnostic_icons = {
    ERROR = '',
    WARN = '',
    INFO = '',
    HINT = '󰌵', -- 修正了部分字体图标
}

-- ===================================================================
-- 3. LSP 附加行为 (LspAttach)
-- ===================================================================
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my-lsp-attach-group', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        -- 基础跳转 (Neovim 0.12 API)
        map('n', ']d', function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, 'Next Diagnostic')
        map('n', '[d', function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, 'Prev Diagnostic')

        -- 切换诊断 (基于实时状态)
        map('n', '<leader>td', function()
            local is_enabled = vim.diagnostic.is_enabled({ bufnr = bufnr })
            vim.diagnostic.enable(not is_enabled, { bufnr = bufnr })
        end, 'LSP: Toggle diagnostics')

        -- 1. 代码折叠
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
            vim.wo.foldlevel = 99
        end

        -- 2. Inlay Hints
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('n', '<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, 'LSP: Toggle Inlay Hints')
        end

        -- 3. 单词高亮
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_grp = vim.api.nvim_create_augroup('my-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = bufnr,
                group = highlight_grp,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = bufnr,
                group = highlight_grp,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

-- ===================================================================
-- 4. 诊断全局 UI 配置
-- ===================================================================
vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = '●' },
    float = { severity_sort = true, border = 'rounded' }, -- 增加圆角边框更美观
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
-- 5. 自定义命令
-- ===================================================================

-- 重新定义 LspInfo，它实际上是执行 checkhealth lsp
vim.api.nvim_create_user_command('LspInfo', 'checkhealth lsp', { desc = 'LSP information' })

-- 之前的 LspLog 命令保留
vim.api.nvim_create_user_command('LspLog', function()
    vim.cmd('tabnew ' .. vim.fn.fnameescape(vim.lsp.log.get_filename()))
end, { desc = 'Opens the Nvim LSP client log.' })
