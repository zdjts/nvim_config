-- Plugin load policy for vim.pack. See :h vim.pack-examples and
-- echasnovski's guide: load with :packadd when needed, then setup().
local pack = require('config.pack')

local function setup(id, names, fn)
    pack.once(id, function()
        if type(names) == 'string' then
            names = { names }
        end
        for _, name in ipairs(names) do
            if not pack.ensure(name) then
                return
            end
        end
        local ok, err = pcall(fn)
        if not ok then
            vim.notify(('plugin setup %s: %s'):format(id, err), vim.log.levels.ERROR)
        end
    end)
end

-- ---------------------------------------------------------------------------
-- Eager: needed before first redraw / LSP / directory args
-- ---------------------------------------------------------------------------
setup('theme', 'catppuccin', function()
    require('ui.theme').setup()
end)

setup('devicons', 'nvim-web-devicons', function() end)

setup('snacks', 'snacks.nvim', function()
    require('ui.snacks').setup()
end)

setup('mason', 'mason.nvim', function()
    require('code.mason').setup()
end)

setup('oil', 'oil.nvim', function()
    require('ui.oil').setup()
    pack.ensure('oil-git.nvim')
end)

setup('treesitter', 'tree-sitter-manager.nvim', function()
    require('code.treesitter').setup()
end)

require('code.jupytext').setup_jupytext()
setup('jupytext', 'jupytext.vim', function() end)
setup('aw-watcher', 'aw-watcher-vim', function() end)

-- ---------------------------------------------------------------------------
-- Later: after UIEnter (VeryLazy equivalent)
-- ---------------------------------------------------------------------------
if vim.fn.argc(-1) > 0 then
    vim.o.statusline = ' '
else
    vim.g.lualine_laststatus = vim.o.laststatus
    vim.o.laststatus = 0
end

pack.later(function()
    setup('which-key', 'which-key.nvim', function()
        require('ui.which-key').setup()
    end)
    setup('lualine', 'lualine.nvim', function()
        require('ui.lualine').setup()
    end)
    setup('bufferline', 'bufferline.nvim', function()
        require('ui.bufferline').setup()
    end)
    setup('noice', { 'nui.nvim', 'nvim-notify', 'noice.nvim' }, function()
        require('ui.noice').setup()
    end)
    setup('rainbow', 'rainbow-delimiters.nvim', function()
        require('code.rainbow_delimiters').setup()
    end)
    setup('jjsigns', 'jjsigns.nvim', function()
        require('ui.jjsigns').setup()
    end)
    setup('conform', 'conform.nvim', function()
        require('code.conform').setup()
    end)
end)

-- ---------------------------------------------------------------------------
-- Insert / cmdline: completion stack
-- ---------------------------------------------------------------------------
pack.on_event({ 'InsertEnter', 'CmdlineEnter' }, function()
    setup('blink', { 'friendly-snippets', 'blink.cmp' }, function()
        require('code.completion').setup()
    end)
    setup('autopairs', 'nvim-autopairs', function()
        require('code.auto_pairs').setup()
    end)
    setup('minuet', { 'plenary.nvim', 'minuet-ai.nvim' }, function()
        require('code.minuet_ai').setup()
    end)
end)

-- ---------------------------------------------------------------------------
-- FileType
-- ---------------------------------------------------------------------------
pack.on_event('FileType', function()
    pack.once('vimtex', function()
        require('code.vimtex').init()
        pack.ensure('vimtex')
    end)
end, { pattern = { 'tex', 'plaintex', 'bib' }, once = true })

pack.on_event('FileType', function()
    setup('typst-preview', 'typst-preview.nvim', function()
        require('code.typst_preview').setup()
    end)
end, { pattern = 'typst', once = true })

pack.on_event('FileType', function()
    setup('render-markdown', { 'mini.icons', 'render-markdown.nvim' }, function()
        require('code.render_markdown').setup()
    end)
    setup('markdown-preview', { 'live-server.nvim', 'markdown-preview.nvim' }, function()
        require('code.live_preview').setup_markdown()
    end)
end, { pattern = 'markdown', once = true })

pack.on_event('FileType', function()
    setup('live-preview', 'live-preview.nvim', function()
        require('code.live_preview').setup_html()
    end)
end, { pattern = 'html', once = true })

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('user.pack.iron', { clear = true }),
    pattern = { 'python', 'ipynb' },
    callback = function(ev)
        setup('iron', 'iron.nvim', function()
            require('code.jupytext').setup_iron()
        end)
        if pcall(require, 'iron.core') then
            require('code.jupytext').map_iron(ev.buf)
        end
    end,
})

pack.on_event('User', function()
    setup('kitty-scrollback', 'kitty-scrollback.nvim', function()
        require('code.kitty-scrollback').setup()
    end)
end, { pattern = 'KittyScrollbackLaunch', once = true })

-- ---------------------------------------------------------------------------
-- Keys that must work before later() finishes
-- ---------------------------------------------------------------------------
local function map_load(mode, lhs, desc, names, setup_id, setup_fn, rhs)
    vim.keymap.set(mode, lhs, function()
        setup(setup_id, names, setup_fn)
        rhs()
    end, { silent = true, desc = desc })
end

map_load({ 'n', 'x', 'o' }, 's', 'Flash', 'flash.nvim', 'flash', function()
    require('ui.flash').setup()
end, function()
    require('flash').jump()
end)

map_load({ 'n', 'x', 'o' }, 'S', 'Flash Treesitter', 'flash.nvim', 'flash', function()
    require('ui.flash').setup()
end, function()
    require('flash').treesitter()
end)

map_load({ 'n', 'v' }, '<leader>fc', 'Format Buffer', 'conform.nvim', 'conform', function()
    require('code.conform').setup()
end, function()
    require('conform').format({ async = true, lsp_format = 'fallback' })
end)

local function toggleterm()
    setup('toggleterm', 'toggleterm.nvim', function()
        require('ui.toggleterm').setup()
    end)
    vim.cmd('ToggleTerm')
end
vim.keymap.set('n', '<c-/>', toggleterm, { desc = 'Toggle Terminal' })
vim.keymap.set('n', '<leader>ft', toggleterm, { desc = 'ToggleTerm' })

map_load('n', '<leader>ag', 'LLM Commit', 'llm-commit.nvim', 'llm-commit', function()
    require('code.llm_commit').setup()
end, function()
    vim.cmd('LLMCommit')
end)

local function translate()
    setup('llm-translate', 'llm-translate.nvim', function()
        require('code.llm_translate').setup()
    end)
    vim.cmd('LLMTranslate')
end
vim.keymap.set('n', '<leader>t', translate, { desc = 'Translate line' })
vim.keymap.set('v', '<leader>t', function()
    setup('llm-translate', 'llm-translate.nvim', function()
        require('code.llm_translate').setup()
    end)
    vim.cmd("'<,'>LLMTranslate")
end, { desc = 'Translate selection' })

local overseer_cmds = {
    'OverseerRun',
    'OverseerToggle',
    'OverseerOpen',
    'OverseerClose',
    'OverseerShell',
    'OverseerTaskAction',
    'OverseerRestartLast',
}

local function load_overseer()
    for _, cmd in ipairs(overseer_cmds) do
        pcall(vim.api.nvim_del_user_command, cmd)
    end
    setup('overseer', 'overseer.nvim', function()
        require('code.overseer').setup()
    end)
end

local function proxy_overseer(name, opts)
    vim.api.nvim_create_user_command(name, function(cmd_opts)
        load_overseer()
        local bang = cmd_opts.bang and '!' or ''
        vim.cmd(('%s%s %s'):format(name, bang, cmd_opts.args or ''))
    end, opts)
end

proxy_overseer('OverseerRun', { nargs = '*', desc = 'Run a task from a template' })
proxy_overseer('OverseerToggle', { nargs = '?', bang = true, desc = 'Toggle the overseer window' })
proxy_overseer('OverseerOpen', { nargs = '?', bang = true, desc = 'Open the overseer window' })
proxy_overseer('OverseerClose', { desc = 'Close the overseer window' })
proxy_overseer('OverseerShell', { nargs = '*', bang = true, desc = 'Run a shell command as an overseer task' })
proxy_overseer('OverseerTaskAction', { desc = 'Select a task to run an action on' })
proxy_overseer('OverseerRestartLast', { desc = 'Restart last Overseer task' })
