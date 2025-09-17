return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha', -- 你要使用的颜色主题
      integrations = {
        treesitter = true, -- 确保 Treesitter 集成开启
      },
    },
    config = function(_, opts)
      -- 1. 使用 setup() 函数将 opts 表中的配置应用到插件
      require('catppuccin').setup(opts)
      -- 2. 使用 colorscheme 命令来真正应用这个主题
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}
