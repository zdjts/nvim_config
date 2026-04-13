-- ~/.config/nvim/init.lua 或 lazy.lua
-- 1. 基础配置预加载
require('config.autocmds')
require('config.options')

-- 2. Bootstrap lazy.nvim (自动安装逻辑)
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    local out = vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
    -- 修正：检查系统调用的返回码
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' }, -- 现在 out 有定义了
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

-- 3. 将 lazy.nvim 加入运行时路径 (RTP)
vim.opt.rtp:prepend(lazypath)

-- 4. 初始化插件配置
require('lazy').setup({
    spec = {
        { import = 'ui' },
        -- { import = "lsp" }, -- 既然你在下方手动 require('lsp.lsp')，这里可以保持注释
        { import = 'code' },
    },
    -- 建议：加上这个，可以让你在 Arch Linux 等滚挂包后自动检查更新
    checker = {
        enabled = true,
        -- notify = false, -- 不要在启动时弹窗骚扰
    },
})

-- 5. 加载后置配置
-- 注意：确保你的 keymaps 和 LSP 配置不会在插件还没加载完时就调用插件函数
require('config.keymaps')
require('lsp.lsp')
