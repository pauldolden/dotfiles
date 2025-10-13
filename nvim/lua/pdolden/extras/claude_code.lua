local open_func = require('pdolden.utils.open_in_floating_window')

local open = function()
  open_func('claude')
end

-- Command and keymap
vim.api.nvim_create_user_command('ClaudeCode', open, { desc = "Open Claude Code in a floating window" })
vim.keymap.set('n', '<leader>c', ':ClaudeCode<CR>', { desc = 'Open Claude Code in a floating window' })
