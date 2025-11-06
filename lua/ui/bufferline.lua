return {
  {
    'akinsho/bufferline.nvim',
    event = 'VimEnter',
    -- 依赖图标插件
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    opts = {
      options = {
        diagnostics = 'nvim_lsp',
        -- Add this section to show diagnostic counts
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match('error') and ' ' or ' '
          return ' ' .. icon .. count
        end,
        show_buffer_icons = true, -- 显示图标
        offsets = {
          {
            filetype = 'oil',
            text = '文件浏览器',
            text_align = 'left',
          },
        },
      },
    },
  },
}
