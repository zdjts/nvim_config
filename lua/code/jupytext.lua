local M = {}

function M.setup_jupytext()
    vim.g.jupytext_fmt = 'py:percent'
    vim.g.jupytext_filetype_guess = 1
end

function M.setup_iron()
    local iron = require('iron.core')
    local view = require('iron.view')
    local common = require('iron.fts.common')

    iron.setup({
        config = {
            scratch_repl = true,
            repl_definition = {
                python = {
                    command = { 'ipython', '--no-autoindent' },
                    format = common.bracketed_paste,
                    block_dividers = { '# %%', '#%%' },
                    env = { PYTHON_BASIC_REPL = '1' },
                },
            },
            repl_open_cmd = view.split.vertical.botright(0.4),
        },
        keymaps = {},
    })
end

function M.map_iron(buf)
    local iron = require('iron.core')
    local ft = 'python'
    local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buf = buf, silent = true, desc = desc })
    end

    map('n', '<localleader>rr', function()
        iron.repl_for(ft)
        iron.focus_on(ft)
    end, 'Iron: Open/Focus REPL')
    map('n', '<localleader>rl', function()
        iron.hide_repl(ft)
    end, 'Iron: Hide REPL')
    map('n', '<localleader>ra', function()
        iron.send_file()
    end, 'Iron: Run All File')
    map('n', '<localleader>rs', function()
        iron.send_line()
    end, 'Iron: Run Line')
    map('n', '<localleader>rc', function()
        iron.send_code_block()
    end, 'Iron: Run Cell (# %%)')
    map('n', '<localleader>re', function()
        iron.repl_restart()
    end, 'Iron: Restart REPL')
    map('n', '<localleader>rq', function()
        iron.close_repl(ft)
    end, 'Iron: Exit REPL')
    map('v', '<localleader>rc', function()
        iron.visual_send()
    end, 'Iron: Run Selection')
end

return M
