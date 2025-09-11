return {
  "nvim-lualine/lualine.nvim",
  dependencies = {"nvim-tree/nvim-web-devicons"},
  event = "VeryLazy",
    init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = {
    options = {
      disabled_filetypes = {
        statusline = {"dashboard", "alpha" },
      },
    },
    extensions = { "lazy" },
  },
}
