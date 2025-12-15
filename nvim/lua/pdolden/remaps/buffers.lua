-- Toggle between the last two buffers
vim.keymap.set("n", "<leader>bb", function()
	vim.cmd("b#")
end, { desc = "Toggle between the last two buffers" })
-- Move to the window in the specified direction
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to the left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to the upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to the right window" })
-- Split window vertically and horizontally
vim.keymap.set("n", "|", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "-", ":split<CR>", { desc = "Split window horizontally" })
-- Resize active window
vim.keymap.set("n", "<leader>+", ":resize +5<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<leader>_", ":resize -5<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>>", ":vertical resize +5<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<leader><", ":vertical resize -5<CR>", { desc = "Decrease window width" })
