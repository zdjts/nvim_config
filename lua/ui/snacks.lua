return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  -- 移除整个 opts 表格
  -- config 函数现在负责所有配置
  config = function()
    -- 1. 在 config 函数的开头，显式调用 setup
    require('snacks').setup({
      -- 2. 将你之前在 opts 中的所有配置项全部移到这里
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      -- scroll = { enabled = true }, -- 平滑滚动
      statuscolumn = { enabled = true },
      words = { enabled = true },
      dim = { enabled = true },
      zen = { enalbed = true },
      lazygit = { enabled = true },
      image = {
        enabled = true,
        -- doc = {
        --   enabled = true,
        --   inline = false,
        --   float = true,
        --   max_width = 80,
        --   max_height = 20,
        -- },
      },
    })

    -- 3. 保留你原来的键盘映射设置，它们依赖于 setup 成功后才存在的全局变量 Snacks
    local map = function(key, func, _desc)
      vim.keymap.set('n', key, func, { desc = _desc })
    end
    map('<leader>ff', require('snacks').picker.smart, 'Smart find file')
    map('<leader>fw', require('snacks').picker.grep, 'Find content')
    map('<leader>fh', require('snacks').picker.help, 'Find help')
    map('<leader>bc', require('snacks').bufdelete.delete, 'Delete buffers')
    map('<leader>udn', require('snacks').dim.disable, 'no use dim')
    map('<leader>udy', require('snacks').dim.enable, 'use dim')
    map('<leader>uz', require('snacks').zen.zen, 'use zen')
    map('<leader>gl', require('snacks').lazygit.log, 'Lazygit log')
    map('<leader>gf', require('snacks').lazygit.log_file, 'Lazygit file log')
    map('<leader>go', require('snacks').lazygit.open, 'Lazygit open')

    -- 注意：为了更健壮，建议使用 require('snacks') 来访问其模块，而不是依赖全局变量 Snacks
  end,
}
