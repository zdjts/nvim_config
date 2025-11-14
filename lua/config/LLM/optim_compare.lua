-- lua/code/LLM/optim_compare.lua
--
-- 'OptimCompare' 工具的配置 (对应 <leader>an)
--

-- 1. 导入 llm.nvim 插件的 'tools' 模块
--    您原来的配置中 'OptimCompare' 使用了 'tools.action_handler'
local tools = require('llm.tools')

-- 2. 返回从您原来配置中提取的 'OptimCompare' 定义
--    这部分代码直接从您原来的配置中迁移过来
return {
  handler = tools.action_handler,
  opts = {},
}
