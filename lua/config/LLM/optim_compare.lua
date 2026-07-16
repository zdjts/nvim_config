local tools = require('llm.tools')
local llm_cfg = require('config.LLM.backends')

return {
    handler = function(name, F, state, streaming, prompt, opts)
        opts = opts or {}

        local start_opts = {
            url = llm_cfg.chat_url,
            model = llm_cfg.model,
            api_type = 'openai',
            max_tokens = 4096,
        }

        -- 合并配置：优先用上面的 start_opts
        opts = vim.tbl_deep_extend('force', opts, start_opts)

        vim.ui.input({ prompt = '请输入优化/修改要求 (留空则默认优化): ' }, function(input)
            if input == nil then
                return
            end

            -- 3. 【调试】打印日志，确认请求真的发出去了
            print('正在发送 AI 请求 (SiliconFlow)... 请稍候')

            local final_prompt = prompt
            -- 如果没有预设 prompt，加载默认的
            if final_prompt == nil then
                local default_prompt = require('llm.tools.prompts').action
                local lang = opts.language or 'Chinese'
                final_prompt = string.format(default_prompt, lang)
            end

            -- 拼接用户输入
            if input ~= '' then
                final_prompt = final_prompt .. '\n\n【用户具体要求】:\n' .. input
            end

            -- 4. 调用处理函数
            -- 注意：action_handler 会负责处理 Diff 界面
            tools.action_handler(name, F, state, streaming, final_prompt, opts)
        end)
    end,

    opts = {
        language = 'Chinese',
    },
}
