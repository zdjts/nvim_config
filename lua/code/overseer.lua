-- lua/code/overseer.lua
return {
    'stevearc/overseer.nvim',
    dependencies = { 'folke/snacks.nvim' },
    cmd = {
        'OverseerRun',
        'OverseerToggle',
        'OverseerBuild',
        'OverseerClose',
        'OverseerOpen',
    },
    opts = {
        -- 任务列表弹窗的 UI 配置
        task_list = {
            direction = 'bottom', -- 窗口显示在底部
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
        -- 你的自定义模板
        templates = { 'make', 'shell', 'user.cpp_single_file', 'user.run_script' },
    },
}
