-- lua/config/code/LLM/init.lua
--
-- 这是【修正版】的 "工具汇总器"
--
-- 键名 (例如 "CommitMsg") 必须与
-- 'llm_nvim.lua' 中 <cmd>config.LLMAppHandler CommitMsg<cr>
-- 使用的名字完全一致。
--

return {
  -- 【路径已修正】
  OptimCompare = require('config.LLM.optim_compare'),
  CommitMsg = require('config.LLM.commit_msg'),
  DocString = require('config.LLM.doc_string'),
  BashRunner = require('config.LLM.bash_runner'),
  Completion = require('config.LLM.completion'),
  Translate = require('config.LLM.translate'),
  TranslateSelected = require('config.LLM.translateSelected'),
  ScratchChat = require('config.LLM.ScratchChat'),
  AttachAndChat = require('config.LLM.AttachAndChat')
}
