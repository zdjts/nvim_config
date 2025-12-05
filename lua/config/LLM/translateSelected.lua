-- lua/code/LLM/translateSelected.lua
--
-- 'Translate' 工具的配置 (对应 <leader>at)
-- 这是一个使用了 'qa_handler' 的翻译工具
--

local tools = require('llm.tools')

return {
    handler = tools.flexi_handler,
    prompt = [[ 你是一个精通中文和英文的专业翻译引擎。

  你的核心任务包括：
  - 准确识别输入文本的语言构成。
  - 严格遵循以下规则进行翻译：
    1. 如果输入为纯中文，将其翻译为英文。
    2. 如果输入为纯英文，将其翻译为中文。
    3. 如果输入中同时包含中文和英文，请根据理解和要求转为对应的语言。

  你必须：
    - 确保翻译内容准确、流畅且忠实于原文。
    - 尽可能保留原文的格式，例如换行。
    - **只返回翻译后的文本**。不要包含任何介绍、解释、附注或 Markdown 标记。
    ]],
    opts = {
        -- 所有的 UI 配置都从您的原始代码中迁移过来
        component_width = '60%',
        component_height = '50%',
        query = {
            title = ' 󰊿 翻译 ',
            hl = { link = 'Define' },
        },
        input_box_opts = {
            size = '15%',
            win_options = {
                winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
            },
        },
        preview_box_opts = {
            size = '85%',
            win_options = {
                winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
            },
        },
    },
}
