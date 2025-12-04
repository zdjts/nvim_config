return {
    name = 'run_script',
    builder = function()
        local file = vim.fn.expand('%:p')
        local cmd = { file }
        if vim.bo.filetype == 'shell' then
            cmd = { 'bash', file }
        elseif vim.bo.filetype == 'python' then
            cmd = { 'python3', '-u', file } -- -u 禁用缓冲，让输出实时显示
        elseif vim.bo.filetype == 'lua' then
            -- 使用 nvim -l 运行，可以使用 vim.* API
            cmd = { 'nvim', '-l', file }
        elseif vim.bo.filetype == 'javascript' then
            cmd = { 'node', file }
        end
        return {
            cmd = cmd,
            components = {
                { 'on_output_quickfix', set_diagnostics = true },
                'on_result_diagnostics',
                'default',
            },
        }
    end,
    condition = {
        -- 别忘了在这里添加 lua
        filetype = { 'sh', 'python', 'lua', 'javascript' },
    },
}
