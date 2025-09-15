-- Force close all and exit
vim.api.nvim_set_keymap(
	"n",
	"<leader>qq",
	":qa!<cr>",
	{ noremap = true, silent = true, desc = "force close all and exit" }
)
-- open new tmux tab
vim.keymap.set("n", "<leader>tn", function()
	vim.fn.system("tmux new-window")
end, { desc = "open new tmux tab" })
-- Move to bottom/top
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Move to next/previous non-empty line
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Open Lazy
vim.keymap.set("n", "<leader>ll", ":Lazy<CR>", { noremap = true, silent = true, desc = "Open Lazy" })
-- Open Mason
vim.keymap.set("n", "<leader>mm", ":Mason<CR>", { noremap = true, silent = true, desc = "Open Mason" })
