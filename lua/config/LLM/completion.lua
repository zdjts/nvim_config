local tools = require('llm.tools')
local llm_cfg = require('config.LLM.backends')

return {
    handler = tools.completion_handler,
    opts = {
        url = llm_cfg.fim_url,
        model = llm_cfg.model,
        api_type = 'openai',

        -- =================================================
        -- 2. 驯服 Instruct 模型 (关键步骤)
        -- =================================================
        request_body = {
            -- 降低温度，让模型不要“发疯”写废话
            temperature = 0.1,
            top_p = 0.9,

            -- [绝对关键] 停止符
            -- 因为我们用的是 Instruct 模型，它很想和你聊天。
            -- 我们必须设置这些停止符，一旦它想输出 "```" (Markdown结尾)
            -- 或者 "<|im_end|>" (对话结束)，就强制截断它。
            stop = { '<|im_end|>', '```', '\n\nclass', '\n\nvoid' },
        },

        -- =================================================
        -- 3. 触发与性能
        -- =================================================
        -- 开启全自动触发
        auto_trigger = true,
        only_trigger_by_keywords = false,

        -- 防抖设置：打字停顿 300ms 后才请求，避免请求太频繁导致卡顿
        debounce = 300,
        throttle = 500,
        timeout = 10,

        -- =================================================
        -- 4. 生成限制
        -- =================================================
        n_completions = 1,
        context_window = 1024,
        -- 限制生成长度，防止它写完代码后开始写注释
        max_tokens = 64,

        -- =================================================
        -- 5. UI 样式
        -- =================================================
        style = 'virtual_text',
    },
}
