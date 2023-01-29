-- Buffers
vim.api.nvim_set_keymap("n", "<leader>]", "<cmd>BufferNext<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>[", "<cmd>BufferPrevious<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>BufferClose<CR>", { silent = true })
-- Telescope
vim.api.nvim_set_keymap("n", "<leader>fi", "<cmd>Telescope find_files hidden=true no_ignore=true<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope file_browser path=%:p:h hidden=true no_ignore=true<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>fe", "<cmd>Telescope diagnostics<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>fc", "<cmd>Telescope git_commits<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>f.", "<cmd>Telescope resume<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { silent = true })
-- Git
vim.api.nvim_set_keymap("n", "<leader>gb", "<cmd>BlamerToggle<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>gd", "<cmd>vertical Gdiffsplit<CR>", { silent = true })
-- Formatter
vim.api.nvim_set_keymap("n", "<silent> <leader>f","<cmd>Format<CR>", { silent = true })
-- Misc
vim.api.nvim_set_keymap("n", "<leader>ep", "<cmd>echo expand('%:p')<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>yp", "<cmd>let @+ = expand('%:p')<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>o", "o<Esc>k", { silent = true})
vim.api.nvim_set_keymap("n", "<leader>O", "O<Esc>j", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>fm", "<cmd>Neoformat<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>EslintFixAll<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>Trouble<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>u", "<cmd>UndotreeShow<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>cp", "<cmd>Copilot<CR>", { silent = true })
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
