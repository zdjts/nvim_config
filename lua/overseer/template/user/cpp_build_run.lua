return {
    name = 'g++ Build & Run', -- 任务名称
    builder = function()
        local file = vim.fn.expand('%:p')
        local outfile = vim.fn.expand('%:p:r') -- 去掉后缀的可执行文件名
        local input_file = 'input.txt' -- 定义输入文件名为 input.txt

        -- 构建运行命令
        -- 逻辑：先编译，成功(&&)后再运行
        -- 技巧：使用 /usr/bin/time 计算运行时间
        local run_cmd = string.format(
            "g++ -std=c++20 -Wall -g '%s' -o '%s' && /usr/bin/time -f '\nTime: %%E' '%s'",
            file,
            outfile,
            outfile
        )

        -- 如果当前目录下存在 input.txt，则重定向输入
        if vim.fn.filereadable(input_file) == 1 then
            run_cmd = run_cmd .. ' < ' .. input_file
        end

        return {
            cmd = { 'bash', '-c', run_cmd }, -- 使用 shell 来支持 && 和重定向
            components = {
                { 'on_output_quickfix', open = true }, -- 编译报错自动打开 quickfix
                'default',
            },
        }
    end,
    condition = {
        filetype = { 'cpp' },
    },
}
