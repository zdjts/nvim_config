local M = {}

function M.setup()
    local overseer = require('overseer')
    overseer.setup({
        task_list = {
            direction = 'bottom',
            min_height = 10,
            max_height = 20,
            default_detail = 1,
            bindings = {
                ['?'] = 'ShowHelp',
                ['<CR>'] = 'RunAction',
                ['<C-e>'] = 'Edit',
                ['o'] = 'Open',
                ['<C-v>'] = 'OpenVsplit',
                ['<C-s>'] = 'OpenSplit',
                ['<C-f>'] = 'OpenFloat',
                ['p'] = 'TogglePreview',
                ['<C-l>'] = 'IncreaseDetail',
                ['<C-h>'] = 'DecreaseDetail',
                ['L'] = 'IncreaseAllDetail',
                ['H'] = 'DecreaseAllDetail',
                ['['] = 'DecreaseWidth',
                [']'] = 'IncreaseWidth',
                ['{'] = 'PrevTask',
                ['}'] = 'NextTask',
            },
        },
        templates = { 'make', 'shell', 'user.cpp_single_file', 'user.run_script' },
    })

    vim.api.nvim_create_user_command('OverseerRestartLast', function()
        local tasks = overseer.list_tasks({
            status = {
                overseer.STATUS.SUCCESS,
                overseer.STATUS.FAILURE,
                overseer.STATUS.CANCELED,
            },
            sort = require('overseer.task_list').sort_finished_recently,
        })
        if vim.tbl_isempty(tasks) then
            vim.notify('No tasks found', vim.log.levels.WARN)
        else
            overseer.run_action(tasks[1], 'restart')
        end
    end, { desc = 'Restart last Overseer task' })
end

return M
