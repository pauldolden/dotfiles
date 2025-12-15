-- Core keymaps for navigation and essential commands

-- Quit
vim.keymap.set("n", "<leader>qq", ":qa!<cr>", { noremap = true, silent = true, desc = "Force close all and exit" })

-- Scrolling with cursor centering
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Search navigation with cursor centering
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Tool launchers
vim.keymap.set("n", "<leader>ll", ":Lazy<CR>", { noremap = true, silent = true, desc = "Open Lazy" })
vim.keymap.set("n", "<leader>mm", ":Mason<CR>", { noremap = true, silent = true, desc = "Open Mason" })
