-- ~/.config/nvim/init.lua
-- this is nvim init file
require("config.options")
require("config.autocmds")
require("lsp.lsp")
-- require("lsp.lspinit")
-- vim.lsp.enable("lua_ls")
require("config.lazy")
require("config.keymaps")
