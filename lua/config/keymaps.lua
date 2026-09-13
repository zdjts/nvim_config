-- Plugin-independent keymaps and filetype-local task/preview maps.
-- Plugin-owned maps (flash, conform, snacks, oil, toggleterm, bufferline, LLM
-- plugins) are declared in each plugin spec so lazy.nvim can load on keypress.

local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Window navigation
map('n', '<C-h>', '<C-w>h', 'Window left')
map('n', '<C-j>', '<C-w>j', 'Window down')
map('n', '<C-k>', '<C-w>k', 'Window up')
map('n', '<C-l>', '<C-w>l', 'Window right')

-- Severity-filtered diagnostic jumps (]d/[d are Neovim defaults)
map('n', ']e', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, 'Next Error')
map('n', '[e', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, 'Prev Error')
map('n', ']w', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
end, 'Next Warning')
map('n', '[w', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
end, 'Prev Warning')

map('n', '<leader>fn', '<cmd>enew<cr>', 'Create File')

-- Neovim 0.12 builtins
map('n', '<leader>uu', '<cmd>Undotree<cr>', 'Undo tree')
map('n', '<leader>pu', '<cmd>PackUpdate<cr>', 'Update plugins')
map('n', '<leader>ps', '<cmd>PackStatus<cr>', 'Plugin status')

-- LLM 补全开关（minuet-ai reads this global; plugin itself loads on InsertEnter）
map('n', '<leader>al', function()
    vim.g.LLM_COMPLETION_STATUS = not vim.g.LLM_COMPLETION_STATUS
    vim.notify('LLM_COMPLETION_STATUS = ' .. tostring(vim.g.LLM_COMPLETION_STATUS))
end, 'Toggle LLM Completion')

-- =============================================================================
-- FileType-local run / preview maps
-- Dummy commands from plugin `cmd`/`ft` specs make these lazy-load correctly.
-- =============================================================================
local run_key_group = vim.api.nvim_create_augroup('UserRunKeyGroup', { clear = true })

local overseer_blacklist = {
    python = true,
    ipynb = true,
    markdown = true,
    typst = true,
    html = true,
}

local function buf_map(bufnr, lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { buf = bufnr, silent = true, desc = desc })
end

vim.api.nvim_create_autocmd('FileType', {
    group = run_key_group,
    pattern = '*',
    callback = function(ev)
        if overseer_blacklist[vim.bo[ev.buf].filetype] then
            return
        end
        buf_map(ev.buf, '<localleader>rr', '<cmd>OverseerRun<cr>', 'Run Task (List)')
        buf_map(ev.buf, '<localleader>rl', '<cmd>OverseerToggle<cr>', 'Toggle Task List')
        buf_map(ev.buf, '<localleader>rc', '<cmd>OverseerShell<cr>', 'Run Shell Command')
        buf_map(ev.buf, '<localleader>rq', '<cmd>OverseerTaskAction<cr>', 'Task Action')
        buf_map(ev.buf, '<localleader>re', '<cmd>OverseerRestartLast<cr>', 'Restart Last Task')
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = run_key_group,
    pattern = { 'markdown', 'typst', 'html' },
    callback = function(ev)
        local cmds = {
            markdown = { '<cmd>MarkdownPreview<cr>', 'Preview: Markdown' },
            typst = { '<cmd>TypstPreview<cr>', 'Preview: Typst' },
            html = { '<cmd>LivePreview start<cr>', 'Preview: HTML' },
        }
        local spec = cmds[vim.bo[ev.buf].filetype]
        if spec then
            buf_map(ev.buf, '<localleader>rr', spec[1], spec[2])
        end
    end,
})
