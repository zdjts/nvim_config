return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",

  -- 解释器列表
  ensure_installed = {
    'bash',
    'python',
    'cpp',
    'diff',
    'html',
    'xml',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'snakemake',
  },
  ignore_install = {
    'latex',
  },
  auto_install = true,
  highlight = {
    enable = true,
    disable = { 'latex' },
    additional_vim_regex_highlighting = { 'ruby' },
  },
}
