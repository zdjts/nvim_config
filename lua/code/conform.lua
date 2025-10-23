-- lua/code/conform.lua
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' }, -- 我们将通过 autocmd 手动控制
  cmd = { 'ConformInfo' },
  dependencies = { 'mason.nvim' },
  config = function()
    local conform = require('conform')

    -- 全局变量，用于控制是否在保存时自动格式化
    _G.auto_format_on_save = true

    -- 动态加载所有格式化器配置
    -- 这会自动加载 lua/code/formatters/ 目录下的所有 .lua 文件
    local formatters_path = 'code.formatters.'
    local formatters_by_ft = {}
    local formatters = {}

    -- 注意：这是一个简化的加载器，适用于您的结构
    -- 您需要手动创建 lua/code/formatters 目录
    local files = {
      'lua',
      'python',
      'cpp',
      'shell',
      'cmake',
      'markdown',
      'tex',
      'javascript',
    }
    for _, file in ipairs(files) do
      local ok, config = pcall(require, formatters_path .. file)
      if ok and config then
        if config.formatters_by_ft then
          for ft, formatter_names in pairs(config.formatters_by_ft) do
            formatters_by_ft[ft] = formatter_names
          end
        end
        if config.formatters then
          for name, formatter_config in pairs(config.formatters) do
            formatters[name] = formatter_config
          end
        end
      end
    end

    conform.setup({
      -- 在此处合并所有语言的 formatters_by_ft
      formatters_by_ft = formatters_by_ft,
      -- 在此处合并所有自定义的 formatters
      formatters = formatters,

      -- 配置保存时自动格式化
      format_on_save = function(bufnr)
        if _G.auto_format_on_save then
          -- 如果不想格式化某些文件类型，可以在这里添加判断
          -- local buftype = vim.api.nvim_buf_get_option(bufnr, "filetype")
          -- if buftype == "go" then return end
          return { timeout_ms = 500, lsp_fallback = true }
        end
        return nil
      end,
    })
  end,
}
