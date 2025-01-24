local open_func = require('pdolden.utils.open_in_floating_window')

local open = function()
    open_func('lazygit')
end

-- Command and keymap
vim.api.nvim_create_user_command('LazyGit', open, { desc = "Open lazygit in a floating window" })
vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>', { desc = 'Open lazygit in a floating window' })
