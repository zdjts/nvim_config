local wk = require('which-key')
local run_key_group = vim.api.nvim_create_augroup('FileTypeKeyMaps', { clear = true })
function md_create()
    vim.keymap.set('n', '<localleader>r', function()
        require('peek').close()
        require('peek').open()
    end, { buffer = true })
end
vim.api.nvim_create_autocmd('FileType', { pattern = 'markdown', callback = md_create, group = run_key_group })

local keymaps = {
    { '<leader>f', group = ' file' },
    { '<leader>b', group = ' buffer' },
    { '<leader>l', group = ' lsp' },
    { '<leader>t', group = '󰚙 toggle' },
    { '<leader>d', group = ' diagnostic' },
    { '<leader>g', group = ' git' },
    { '<leader>a', group = ' LLM' },
    { '<leader>c', group = ' code' },
    { '<leader>u', group = '󱖫 use status' },
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
}

table.insert(keymaps, {
    { '<C-h>', '<C-w>h', desc = 'Window left', mode = 'n' },
    { '<C-j>', '<C-w>j', desc = 'Window down', mode = 'n' },
    { '<C-k>', '<C-w>k', desc = 'Window up', mode = 'n' },
    { '<C-l>', '<C-w>l', desc = 'Window right', mode = 'n' },
    { '<leader>fn', '<cmd>e<cr>', desc = 'create file' },
    { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'previous buffer' },
    { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'next buffer' },
    { 'gd', vim.lsp.buf.definition, desc = 'LSP: Goto Definition', mode = 'n' },
    { 'gr', vim.lsp.buf.references, desc = 'LSP: Goto References', mode = 'n' },
    { 'gD', vim.lsp.buf.declaration, desc = 'LSP: Goto Declaration', mode = 'n' },
    { 'K', vim.lsp.buf.hover, desc = 'LSP: Hover Documentation', mode = 'n' },
    {
        '<leader>la',
        vim.lsp.buf.code_action,
        desc = 'LSP: Code Action',
        mode = 'n',
    },
    { '<leader>ln', vim.lsp.buf.rename, desc = 'LSP: Rename', mode = 'n' },
    {
        '<leader>ld',
        vim.diagnostic.open_float,
        desc = 'LSP: Line Diagnostics',
        mode = 'n',
    },
    { '<c-/>', '<cmd>ToggleTerm<CR>', desc = 'Toggle terminal', mode = 'n' },
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
        desc = 'Format buffer',
        mode = { 'n', 'v' },
    },
    { '<leader>ft', '<cmd>ToggleTerm<CR>', desc = 'ToggleTerm', mode = 'n' },

    -- Overseer 快捷键
    { '<localleader>rr', '<cmd>OverseerRun<cr>', desc = 'Run Task (List)' }, -- 弹出模板列表供选择
    { '<localleader>rl', '<cmd>OverseerToggle<cr>', desc = 'Toggle Task List' }, -- 打开/关闭任务面板
    { '<localleader>rb', '<cmd>OverseerBuild<cr>', desc = 'Task Builder' }, -- 构建任务
    { '<localleader>rc', '<cmd>OverseerRunCmd<cr>', desc = 'Run Command' }, -- 直接运行 Shell 命令
    { '<localleader>rq', '<cmd>OverseerQuickAction<cr>', desc = 'Quick Action' }, -- 对最近的任务执行操作（如重启）
    { '<localleader>ri', '<cmd>OverseerInfo<cr>', desc = 'Overseer Info' }, -- 查看调试信息

    -- [可选] 如果你想快速重启上一次的任务
    { '<localleader>re', '<cmd>OverseerRestartLast<cr>', desc = 'Restart Last Task' },

    {
        '<leader>al',
        function()
            local s = require('llm.state').completion
            s.enable = not s.enable
            vim.g.LLM_COMPLETION_STATUS = not vim.g.LLM_COMPLETION_STATUS
        end,
        desc = '切换补全状态',
    },
})

wk.add(keymaps)
