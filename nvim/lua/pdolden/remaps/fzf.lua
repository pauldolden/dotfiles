vim.keymap.set("n", "<leader>fp", ":FindProjects<CR>", { noremap = true, silent = true, desc = "Search projects" })
vim.keymap.set("n", "<leader>ff", ":FzfLua files --hidden<CR>", { noremap = true, silent = true, desc = "Search files including hidden" })
vim.keymap.set("n", "<leader>/", ":FzfLua live_grep --hidden<CR>", { noremap = true, silent = true, desc = "Search in files including hidden" })
vim.keymap.set("n", "<leader>fg", ":FzfLua git_files --hidden<CR>", { noremap = true, silent = true, desc = "Search git files including hidden" })
