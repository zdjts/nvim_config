-- lua/plugins/toggleterm.lua

return {
  'akinsho/toggleterm.nvim',
  version = '*', -- 建议锁定版本以确保稳定
  config = function()
    require('toggleterm').setup({
      -- 因为我们将手动精细化地定义所有快捷键，
      -- 所以这里就不再需要 open_mapping 和 terminal_mappings 了。
      -- direction = 'float',
      start_in_insert = true,
      persist_size = true,
      close_on_exit = true,
    })

    -- 1. 定义在普通模式下的快捷键 (已移至 lua/config/keymaps.lua)
    --    - 用途：打开/关闭终端
    -- vim.keymap.set('n', '<c-/>', '<cmd>ToggleTerm<CR>', {
    --   desc = 'Toggle terminal'
    -- })

    -- 2. 定义一个函数，用于设置终端模式下的专属快捷键
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0, silent = true }

      -- 关键行为：在终端模式下按 Esc，切换到普通模式
      -- <C-\><C-n> 是 Neovim 退出终端模式的原生命令
      vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)

      -- 方便的行为：在终端模式下按 <C-/>，直接关闭终端
      vim.keymap.set('t', '<c-/>', [[<C-\><C-n><cmd>ToggleTerm<CR>]], opts)
    end

    -- 3. 使用自动命令，在终端打开时应用我们上面定义的专属快捷键
    vim.api.nvim_create_autocmd({ 'TermOpen' }, {
      pattern = 'term://*',
      callback = function()
        set_terminal_keymaps()
      end,
    })
  end,
}
