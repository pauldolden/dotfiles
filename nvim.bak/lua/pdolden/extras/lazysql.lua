local open_func = require('pdolden.utils.open_in_floating_window')

local open = function()
    open_func('lazysql')
end

-- Command and keymap
vim.api.nvim_create_user_command('LazySql', open, { desc = "Open lazysql in a floating window" })
vim.keymap.set('n', '<leader>ls', ':LazySql<CR>', { desc = 'Open lazysql in a floating window' })
