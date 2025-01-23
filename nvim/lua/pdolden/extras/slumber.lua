local open_func = require('pdolden.utils.open_in_floating_window')

local open = function()
    open_func('slumber')
end

-- Command and keymap
vim.api.nvim_create_user_command('Slumber', open, { desc = "Open slumber in a floating window" })
vim.keymap.set('n', '<leader>lr', ':Slumber<CR>', { desc = 'Open slumber in a floating window' })
