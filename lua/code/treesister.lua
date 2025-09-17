return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  lazy = false,
  build = ':TSUpdate',

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

  config = function(_, opts)
    require('nvim-treesitter.configs').setup({
      highlight = {
        enable = true,
        disable = { 'latex' },
        additional_vim_regex_highlighting = { 'ruby' },
      },
    })

    -- 将 @variable 设置为特定的颜色
    -- 设置 Treesitter 的变量高亮。@variable 通常指代函数体内的局部变量。
    -- fg: 前景颜色（文本颜色），bg: 背景颜色，bold: 字体加粗。
    -- vim.api.nvim_set_hl(0, "@variable", { fg = "#FF00FF", bg = "NONE", bold = true })
    --
    -- -- 设置 Treesitter 的属性高亮。@property 通常指代对象属性，如 my_object.property。
    -- -- 这里只修改前景色和字体加粗。
    -- vim.api.nvim_set_hl(0, "@property", { fg = "#FFD700", bold = true })
    --
    -- -- 设置 Treesitter 的变量成员高亮。@variable.member 更加精确，用于嵌套的成员，如 my_object.property.value。
    -- vim.api.nvim_set_hl(0, "@variable.member", { fg = "#1E90FF", bold = true })
    --
    -- -- 设置 Treesitter 的所有括号高亮。@punctuation.bracket 是一个通用组，用于所有括号类型。
    -- vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#FFFF00", bold = true })

    -- 设置所有括号相关（这是你提供的代码，作用是让括号加粗，但不改变颜色）
    -- 这个设置会覆盖上面 @punctuation.bracket 的颜色设置，只保留 bold。
    vim.api.nvim_set_hl(0, '@punctuation.bracket', { bold = true })
  end,
}
