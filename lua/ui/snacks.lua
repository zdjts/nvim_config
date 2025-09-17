return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  -- -@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  config = function()
    local map = function(key, func, _desc)
      vim.keymap.set('n', key, func, { desc = _desc })
    end
    map('<leader>ff', Snacks.picker.smart, 'Smart find file')
    map('<leader>fw', Snacks.picker.grep, 'Find content')
    map('<leader>fh', Snacks.picker.help, 'Find help')

    -- Show dashboard on startup
    -- 		vim.api.nvim_create_autocmd("VimEnter", {
    -- 			nested = true,
    -- 			callback = function()
    -- 				if vim.fn.argc() == 0 and vim.fn.bufname() == "" then
    -- 					require("snacks").show_dashboard()
    -- 				end
    -- 			end,
    -- 			desc = "Show dashboard when starting Neovim without files",
    -- 		})
  end,
}
