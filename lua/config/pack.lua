-- Neovim 0.12 built-in plugin manager. See :h vim.pack
local M = {}

local gh = function(repo)
    return 'https://github.com/' .. repo
end

-- blink.cmp is large; keep the existing GitHub proxy.
local blink_src = 'https://gh-proxy.org/https://github.com/Saghen/blink.cmp.git'

M.specs = {
    -- eager
    { src = gh('catppuccin/nvim'), name = 'catppuccin' },
    { src = gh('nvim-tree/nvim-web-devicons') },
    { src = gh('folke/snacks.nvim') },
    { src = gh('mason-org/mason.nvim') },
    { src = gh('stevearc/oil.nvim') },
    { src = gh('benomahony/oil-git.nvim') },
    { src = gh('romus204/tree-sitter-manager.nvim') },
    { src = gh('goerz/jupytext.vim') },
    { src = gh('activitywatch/aw-watcher-vim') },

    -- insert
    { src = blink_src, name = 'blink.cmp', version = vim.version.range('1.x') },
    { src = gh('rafamadriz/friendly-snippets') },
    { src = gh('windwp/nvim-autopairs') },
    { src = gh('nvim-lua/plenary.nvim') },
    { src = gh('milanglacier/minuet-ai.nvim') },

    -- later / ft / keys
    { src = gh('stevearc/conform.nvim') },
    { src = gh('folke/which-key.nvim') },
    { src = gh('MunifTanjim/nui.nvim') },
    { src = gh('rcarriga/nvim-notify') },
    { src = gh('folke/noice.nvim') },
    { src = gh('nvim-lualine/lualine.nvim') },
    { src = gh('akinsho/bufferline.nvim') },
    { src = gh('evanphx/jjsigns.nvim') },
    { src = gh('hiphish/rainbow-delimiters.nvim') },
    { src = gh('nvim-mini/mini.icons') },
    { src = gh('MeanderingProgrammer/render-markdown.nvim') },
    { src = gh('chomosuke/typst-preview.nvim'), version = vim.version.range('1') },
    { src = gh('lervag/vimtex') },
    { src = gh('brianhuster/live-preview.nvim') },
    { src = gh('selimacerbas/live-server.nvim') },
    { src = gh('selimacerbas/markdown-preview.nvim') },
    { src = gh('Vigemus/iron.nvim') },
    { src = gh('stevearc/overseer.nvim') },
    { src = gh('akinsho/toggleterm.nvim') },
    { src = gh('folke/flash.nvim') },
    { src = gh('mikesmithgh/kitty-scrollback.nvim') },
    { src = gh('zdjts/llm-commit.nvim') },
    { src = gh('zdjts/llm-translate.nvim') },
}

local packed = {}
local configured = {}

function M.ensure(name)
    if packed[name] then
        return true
    end
    local ok, err = pcall(vim.cmd.packadd, name)
    if not ok then
        vim.notify(('packadd %s failed: %s'):format(name, err), vim.log.levels.ERROR)
        return false
    end
    packed[name] = true
    return true
end

function M.once(id, fn)
    if configured[id] then
        return
    end
    configured[id] = true
    fn()
end

function M.later(fn)
    vim.api.nvim_create_autocmd('UIEnter', {
        group = vim.api.nvim_create_augroup('user.pack.later', { clear = false }),
        once = true,
        callback = function()
            vim.schedule(fn)
        end,
    })
end

function M.on_event(event, fn, opts)
    opts = opts or {}
    vim.api.nvim_create_autocmd(event, {
        group = vim.api.nvim_create_augroup('user.pack.event', { clear = false }),
        pattern = opts.pattern,
        once = opts.once ~= false,
        callback = fn,
    })
end

-- Build blink.cmp after install/update. Register BEFORE the first vim.pack.add().
vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('user.pack.hooks', { clear = true }),
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
            if not ev.data.active then
                pcall(vim.cmd.packadd, 'blink.cmp')
            end
            -- 0.x used blink.build(); 1.x downloads the fuzzy binary on setup().
            local ok, blink = pcall(require, 'blink.cmp')
            if ok and blink.build then
                blink.build():wait(60000)
            end
        end
    end,
})

local function spec_name(spec)
    if type(spec) == 'string' then
        return spec:match('([^/]+)$'):gsub('%.git$', '')
    end
    if spec.name then
        return spec.name
    end
    return spec.src:match('([^/]+)$'):gsub('%.git$', '')
end

-- vim.pack blobless clone can time out and leave an empty worktree (only .git).
local function repair_empty_checkouts()
    local root = vim.fs.joinpath(vim.fn.stdpath('data'), 'site/pack/core/opt')
    for _, spec in ipairs(M.specs) do
        local name = spec_name(spec)
        local path = vim.fs.joinpath(root, name)
        if vim.uv.fs_stat(vim.fs.joinpath(path, '.git')) then
            local empty = true
            local handle = vim.uv.fs_scandir(path)
            while handle do
                local fname = vim.uv.fs_scandir_next(handle)
                if not fname then
                    break
                end
                if fname ~= '.git' then
                    empty = false
                    break
                end
            end
            if empty then
                vim.system({ 'git', '-C', path, 'checkout', '-f', 'HEAD' }):wait()
            end
        end
    end
end

-- During init.lua, default load=false is :packadd! (rtp only, no plugin/).
vim.pack.add(M.specs, { confirm = false, load = false })
repair_empty_checkouts()

vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update()
end, { desc = 'Update vim.pack plugins (confirm in new tab, :w to apply)' })

vim.api.nvim_create_user_command('PackStatus', function()
    vim.pack.update(nil, { offline = true })
end, { desc = 'Browse installed vim.pack plugins' })

return M
