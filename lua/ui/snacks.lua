local M = {}

function M.setup()
    require('snacks').setup({
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = false },
        quickfile = { enabled = true },
        scope = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        dim = { enabled = true },
        zen = { enabled = true },
        lazygit = { enabled = true },
        image = { enabled = true },
    })

    local map = function(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
    end
    map('<leader>ff', function()
        require('snacks').picker.smart()
    end, 'Smart find file')
    map('<leader>fw', function()
        require('snacks').picker.grep()
    end, 'Find content')
    map('<leader>fh', function()
        require('snacks').picker.help()
    end, 'Find help')
    map('<leader>bc', function()
        require('snacks').bufdelete.delete()
    end, 'Delete buffers')
    map('<leader>udn', function()
        require('snacks').dim.disable()
    end, 'no use dim')
    map('<leader>udy', function()
        require('snacks').dim.enable()
    end, 'use dim')
    map('<leader>uz', function()
        require('snacks').zen.zen()
    end, 'use zen')
    map('<leader>gl', function()
        require('snacks').lazygit.log()
    end, 'Lazygit log')
    map('<leader>gf', function()
        require('snacks').lazygit.log_file()
    end, 'Lazygit file log')
    map('<leader>go', function()
        require('snacks').lazygit.open()
    end, 'Lazygit open')
end

return M
