vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>", { noremap = true, silent = true, desc = "Search files" })
vim.keymap.set("n", "<leader>/", ":FzfLua grep_project<CR>", { noremap = true, silent = true, desc = "Search in files" })
vim.keymap.set("n", "<leader>fg", ":FzfLua git_files<CR>", { noremap = true, silent = true, desc = "Search git files" })
