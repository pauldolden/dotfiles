local tmux = require('pdolden.cmds.tmux')

-- Fast operations
vim.keymap.set('n', '<leader>ts', tmux.create_or_switch_session,
  { desc = 'Tmux: Create/switch to project session' })

vim.keymap.set('n', '<leader>tl', tmux.fzf_sessions,
  { desc = 'Tmux: List sessions (fzf)' })

vim.keymap.set('n', '<leader>lt', tmux.fzf_sessions,
  { desc = 'Tmux: List sessions (fzf)' })

vim.keymap.set('n', '<leader>tn', tmux.new_session,
  { desc = 'Tmux: New session' })

vim.keymap.set('n', '<leader>tr', tmux.rename_session,
  { desc = 'Tmux: Rename session' })

vim.keymap.set('n', '<leader>tk', tmux.kill_session,
  { desc = 'Tmux: Kill session' })

vim.keymap.set('n', '<leader>fd', require('pdolden.cmds.tmux').open_dotfiles,
  { desc = 'Open dotfiles' })

vim.keymap.set('n', '<leader><leader>', require('pdolden.cmds.tmux').toggle_last_session,
  { desc = 'Toggle last tmux session' })

tmux.setup_auto_rename()
