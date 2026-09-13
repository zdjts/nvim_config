-- Native LSP: configs live in <config>/lsp/<name>.lua and are merged by
-- vim.lsp.enable() (see :h lsp-config).

vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            semanticTokens = {
                multilineTokenSupport = true,
            },
        },
    },
})

vim.lsp.enable({
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
    'tinymist',
})

local diagnostic_icons = {
    ERROR = '',
    WARN = '',
    INFO = '',
    HINT = '󰌵',
}

local function open_diagnostic_float(bufnr)
    vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor' })
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my-lsp-attach-group', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        -- Neovim already maps: gra/grn/grr/gri/grt/grx, gO, K, ]d/[d, <C-w>d.
        -- Do not map `gr` — it shadows the `gr*` prefix. Extra aliases below.
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buf = bufnr, silent = true, desc = desc })
        end

        map('n', 'gd', function()
            vim.lsp.buf.definition()
        end, 'LSP: Goto Definition')
        map('n', 'gD', function()
            vim.lsp.buf.declaration()
        end, 'LSP: Goto Declaration')
        map('n', '<leader>la', function()
            vim.lsp.buf.code_action()
        end, 'LSP: Code Action')
        map('n', '<leader>ln', function()
            vim.lsp.buf.rename()
        end, 'LSP: Rename')
        map('n', '<leader>ld', function()
            vim.diagnostic.open_float()
        end, 'LSP: Line Diagnostics')
        map('n', '<leader>ls', function()
            vim.lsp.buf.document_symbol()
        end, 'LSP: Document Symbols')
        map({ 'n', 'x' }, '<C-.>', function()
            vim.lsp.buf.code_action()
        end, 'LSP: Quick Fix')

        map('n', '<leader>td', function()
            local is_enabled = vim.diagnostic.is_enabled({ bufnr = bufnr })
            vim.diagnostic.enable(not is_enabled, { bufnr = bufnr })
        end, 'LSP: Toggle diagnostics')

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win].foldmethod = 'expr'
            vim.wo[win].foldexpr = 'v:lua.vim.lsp.foldexpr()'
            vim.wo[win].foldlevel = 99
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('n', '<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, 'LSP: Toggle Inlay Hints')
        end

        if client and client:supports_method('textDocument/codeLens') then
            vim.lsp.codelens.enable(true, { bufnr = bufnr, client_id = client.id })
        end

        if client and client:supports_method('textDocument/onTypeFormatting') then
            vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
        end

        if client and client:supports_method('textDocument/linkedEditingRange') then
            vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
        end

        if client and client:supports_method('textDocument/inlineCompletion') then
            vim.lsp.inline_completion.enable(true, { bufnr = bufnr, client_id = client.id })
            vim.keymap.set('i', '<A-l>', function()
                if not vim.lsp.inline_completion.get() then
                    return '<A-l>'
                end
            end, { expr = true, buf = bufnr, desc = 'LSP: Accept inline completion' })
            map('n', '<leader>ti', function()
                vim.lsp.inline_completion.enable(
                    not vim.lsp.inline_completion.is_enabled({ bufnr = bufnr }),
                    { bufnr = bufnr }
                )
            end, 'LSP: Toggle inline completion')
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_grp = vim.api.nvim_create_augroup('my-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buf = bufnr,
                group = highlight_grp,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buf = bufnr,
                group = highlight_grp,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('my-lsp-detach-group', { clear = true }),
    callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = 'my-lsp-highlight', buf = event.buf })
    end,
})

vim.diagnostic.config({
    virtual_text = {
        prefix = '󰄨 ',
        spacing = 4,
        source = 'if_many',
        severity = { min = vim.diagnostic.severity.WARN },
    },
    float = {
        severity_sort = true,
        border = 'rounded',
        source = true,
        focusable = true,
        max_width = 80,
        max_height = 20,
        header = '',
        prefix = '  ',
    },
    -- 0.12: JumpOpts.float is deprecated; use on_jump.
    jump = {
        on_jump = function(_, bufnr)
            open_diagnostic_float(bufnr)
        end,
    },
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
            [vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
            [vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
            [vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
        },
        linehl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
        },
    },
})

vim.api.nvim_create_user_command('LspInfo', 'checkhealth vim.lsp', { desc = 'LSP information' })

vim.api.nvim_create_user_command('LspLog', function()
    vim.cmd('tabnew ' .. vim.fn.fnameescape(vim.lsp.log.get_filename()))
end, { desc = 'Opens the Nvim LSP client log.' })
