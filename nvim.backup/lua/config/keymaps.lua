-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.set("n", "ss", function()
--
-- Search and replace word under cursor
vim.keymap.set(
  "n",
  "<leader>sf",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { noremap = true, silent = true, desc = "Search and replace word under cursor" }
)

-- open new tmux tab
vim.keymap.set("n", "<leader>tn", function()
  vim.fn.system("tmux new-window")
end, { desc = "open new tmux tab" })
