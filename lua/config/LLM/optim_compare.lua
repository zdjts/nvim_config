local tools = require('llm.tools')

return {
    handler = function(name, F, state, streaming, prompt, opts)
        -- 1. 空值保护 (保留之前的修复)
        opts = opts or {}

        -- 2. 【新增】强制指定后端配置 (防止读取全局失败)
        -- 既然 completion 已经能用了，这里的配置要跟 completion 保持一致
        local start_opts = {
            url = 'https://api.siliconflow.cn/v1/chat/completions',
            model = 'Qwen/Qwen2.5-Coder-32B-Instruct',
            api_type = 'openai',
            -- 优化任务不需要流式传输太快，稍微慢点更稳
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
