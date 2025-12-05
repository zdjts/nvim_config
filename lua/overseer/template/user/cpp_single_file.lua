return {
    name = 'g++ build single_file (Fixed)',
    builder = function()
        local source_file = vim.fn.expand('%:p')
        local executable_name = vim.fn.expand('%:p:r')
        return {
            cmd = { 'g++' },
            args = {
                '-o',
                executable_name,
                source_file,
                '-Wall',
                '-std=c++20',
            },
            components = { { 'on_output_quickfix', open = true }, 'default' },
        }
    end,
    condition = {
        filetype = { 'cpp' },
    },
}
