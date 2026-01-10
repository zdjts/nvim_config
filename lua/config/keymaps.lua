local wk = require('which-key')

-- =============================================================================
-- 1. 特定文件类型的动态覆盖 (解决 Desc 不更新的问题)
-- =============================================================================
local run_key_group = vim.api.nvim_create_augroup('UserRunKeyGroup', { clear = true })

-- Markdown 预览配置
local function md_setup()
    wk.add({
        {
            '<localleader>rr',
            function()
                require('peek').close()
                require('peek').open()
            end,
            desc = 'Preview: Markdown', -- 强制覆盖描述
            buffer = true,
        },
    })
end

-- Typst 预览配置
local function typst_setup()
    wk.add({
        {
            '<localleader>rr',
            function()
                vim.cmd('TypstPreview')
            end,
            desc = 'Preview: Typst', -- 强制覆盖描述
            buffer = true,
        },
    })
end

-- 注册自动命令
vim.api.nvim_create_autocmd('FileType', { pattern = 'markdown', callback = md_setup, group = run_key_group })
vim.api.nvim_create_autocmd('FileType', { pattern = 'typst', callback = typst_setup, group = run_key_group })

-- =============================================================================
-- 2. 全局快捷键定义
-- =============================================================================
local keymaps = {
    -- 分组定义
    { '<leader>f', group = ' file' },
    { '<leader>b', group = ' buffer' },
    { '<leader>l', group = ' lsp' },
    { '<leader>t', group = '󰚙 toggle' },
    { '<leader>d', group = ' diagnostic' },
    { '<leader>g', group = ' git' },
    { '<leader>a', group = ' LLM' },
    { '<leader>c', group = ' code' },
    { '<leader>u', group = '󱖫 use status' },
    { '<localleader>r', group = '󰐊 run/task' },

    -- 窗口导航
    { '<C-h>', '<C-w>h', desc = 'Window left' },
    { '<C-j>', '<C-j>j', desc = 'Window down' },
    { '<C-k>', '<C-w>k', desc = 'Window up' },
    { '<C-l>', '<C-w>l', desc = 'Window right' },

    -- 诊断跳转
    {
        ']e',
        function()
            vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
        end,
        desc = 'Next Error',
    },
    {
        '[e',
        function()
            vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
        end,
        desc = 'Prev Error',
    },
    {
        ']w',
        function()
            vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })
        end,
        desc = 'Next Warning',
    },
    {
        '[w',
        function()
            vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })
        end,
        desc = 'Prev Warning',
    },

    -- 文件与 Buffer
    { '<leader>fn', '<cmd>e<cr>', desc = 'Create File' },
    { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Previous Buffer' },
    { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },

    -- LSP 核心功能
    { 'gd', vim.lsp.buf.definition, desc = 'LSP: Goto Definition' },
    { 'gr', vim.lsp.buf.references, desc = 'LSP: Goto References' },
    { 'gD', vim.lsp.buf.declaration, desc = 'LSP: Goto Declaration' },
    { 'K', vim.lsp.buf.hover, desc = 'LSP: Hover Documentation' },
    { '<leader>la', vim.lsp.buf.code_action, desc = 'LSP: Code Action' },
    { '<leader>ln', vim.lsp.buf.rename, desc = 'LSP: Rename' },
    { '<leader>ld', vim.diagnostic.open_float, desc = 'LSP: Line Diagnostics' },

    -- 功能插件 (Flash, Conform, ToggleTerm)
    {
        's',
        function()
            require('flash').jump()
        end,
        desc = 'Flash',
        mode = { 'n', 'x', 'o' },
    },
    {
        'S',
        function()
            require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
        mode = { 'n', 'x', 'o' },
    },
    {
        '<leader>fc',
        function()
            require('conform').format({ async = true, lsp_fallback = true })
        end,
        desc = 'Format Buffer',
        mode = { 'n', 'v' },
    },
    { '<c-/>', '<cmd>ToggleTerm<CR>', desc = 'Toggle Terminal' },
    { '<leader>ft', '<cmd>ToggleTerm<CR>', desc = 'ToggleTerm' },

    -- =========================================================================
    -- 3. Overseer 任务管理 (全局默认)
    -- =========================================================================
    { '<localleader>rr', '<cmd>OverseerRun<cr>', desc = 'Run Task (List)' },
    { '<localleader>rl', '<cmd>OverseerToggle<cr>', desc = 'Toggle Task List' },
    { '<localleader>rb', '<cmd>OverseerBuild<cr>', desc = 'Task Builder' },
    { '<localleader>rc', '<cmd>OverseerRunCmd<cr>', desc = 'Run Command' },
    { '<localleader>rq', '<cmd>OverseerQuickAction<cr>', desc = 'Quick Action' },
    { '<localleader>ri', '<cmd>OverseerInfo<cr>', desc = 'Overseer Info' },
    { '<localleader>re', '<cmd>OverseerRestartLast<cr>', desc = 'Restart Last Task' },

    -- LLM 状态切换
    {
        '<leader>al',
        function()
            local s = require('llm.state').completion
            s.enable = not s.enable
            vim.g.LLM_COMPLETION_STATUS = not vim.g.LLM_COMPLETION_STATUS
        end,
        desc = 'Toggle LLM Completion',
    },
}

-- 应用所有快捷键
wk.add(keymaps)
