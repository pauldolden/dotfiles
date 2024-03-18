-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
vim.api.nvim_set_keymap("n", "<leader>t", ":Trouble<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>yp", '<cmd>let @+ = expand("%:p")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-x>[", ":BufferLineCloseLeft<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-x>]", ":BufferLineCloseRight<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-x>.", ":BufferLinePickClose<CR>", { noremap = true, silent = true })
-- Harpoon
vim.api.nvim_set_keymap(
  "n",
  "<leader>hw",
  ':lua require("harpoon.ui").toggle_quick_menu()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>ha",
  ':lua require("harpoon.mark").add_file()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>hn",
  ':lua require("harpoon.ui").nav_next()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>hp",
  ':lua require("harpoon.ui").nav_prev()<CR>',
  { noremap = true, silent = true }
)
