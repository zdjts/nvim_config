-- 安装 rainbow-delimiters 插件
return {
  'hiphish/rainbow-delimiters.nvim',
  -- event = { 'BufReadPost' },
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  -- 你不需要任何额外的配置，它开箱即用
  -- 它会与你的 colorscheme 完美配合
}
