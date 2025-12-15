-- Keymaps for project management commands

-- Create new project in parent directory
vim.keymap.set('n', '<leader>pn', ':CreateProject<CR>', {
  desc = 'Create new project in parent directory',
  silent = true,
})

-- Clone git repository to parent directory
vim.keymap.set('n', '<leader>pc', ':CloneProject<CR>', {
  desc = 'Clone git repo to parent directory',
  silent = true,
})
