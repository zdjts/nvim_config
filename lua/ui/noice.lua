return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    -- **新增：视图配置**
    views = {
      cmdline_popup = {
        position = {
          row = 5, -- 设置在第 5 行，离开顶部一段距离
          col = '50%', -- 水平居中
        },
        size = {
          width = 'auto',
          height = 'auto',
        },
      },
      -- 当命令面板弹出时，让它显示在输入框下方
      popupmenu = {
        position = {
          row = 6,
          col = '50%',
        },
      },
    },
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'written',
        },
        opts = { skip = true },
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
}
