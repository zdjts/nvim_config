local tools = require('llm.tools')

return {
    handler = function(name, F, state, streaming, prompt, opts)
        vim.ui.input({ prompt = '请输入优化/修改要求 (留空则默认优化): ' }, function(input)
            if input == nil then
                return
            end

            local final_prompt = prompt
            if final_prompt == nil then
                local default_prompt = require('llm.tools.prompts').action
                local lang = opts.language or 'Chinese'
                final_prompt = string.format(default_prompt, lang)
            end

            if input ~= '' then
                final_prompt = final_prompt .. '\n\n【用户具体要求 / User Requirement】:\n' .. input
            end

            tools.action_handler(name, F, state, streaming, final_prompt, opts)
        end)
    end,

    opts = {
        language = 'Chinese',
    },
}
