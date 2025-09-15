local open_func = require('pdolden.utils.open_in_floating_window')

local open = function()
    open_func('lazydocker')
end

-- Command and keymap
vim.api.nvim_create_user_command('LazyDocker', open, { desc = "Open lazydocker in a floating window" })
vim.keymap.set('n', '<leader>ld', ':LazyDocker<CR>', { desc = 'Open lazydocker in a floating window' })
