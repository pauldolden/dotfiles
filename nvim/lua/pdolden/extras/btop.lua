local open_func = require('pdolden.utils.open_in_floating_window')

local open = function()
    open_func('btop')
end

-- Command and keymap
vim.api.nvim_create_user_command('Btop', open, { desc = "Open btop in a floating window" })
vim.keymap.set('n', '<leader>lb', ':Btop<CR>', { desc = 'Open btop in a floating window' })
