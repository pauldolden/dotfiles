local nnoremap = require("pauldolden.keymap").nnoremap
-- Buffers
nnoremap("<leader>]", "<cmd>BufferNext<CR>")
nnoremap("<leader>[", "<cmd>BufferPrevious<CR>")
nnoremap("<leader>q", "<cmd>BufferClose<CR>")
-- Misc
nnoremap("<leader>fm", "<cmd>Neoformat<CR>")
nnoremap("<leader>l", "<cmd>EslintFixAll<CR>")
nnoremap("<leader>t", "<cmd>Trouble<CR>")
nnoremap("<leader>u", "<cmd>UndotreeShow<CR>")
-- Telescope
nnoremap("<leader>fi", "<cmd>Telescope find_files hidden=true no_ignore=true<CR>")
nnoremap("<leader>ff", "<cmd>Telescope file_browser path=%:p:h hidden=true no_ignore=true<CR>")
nnoremap("<leader>fe", "<cmd>Telescope diagnostics<CR>")
nnoremap("<leader>fg", "<cmd>Telescope git_files<CR>")
nnoremap("<leader>fc", "<cmd>Telescope git_commits<CR>")
nnoremap("<leader>f.", "<cmd>Telescope resume<CR>")
nnoremap("<leader>fs", "<cmd>Telescope live_grep<CR>")
-- Git
nnoremap("<leader>gb", "<cmd>BlamerToggle<CR>")
nnoremap("<leader>gd", "<cmd>vertical Gdiffsplit<CR>")
-- Misc
nnoremap("<leader>ep", "<cmd>echo expand('%:p')<CR>")
nnoremap("<leader>yp", "<cmd>let @+ = expand('%:p')<CR>")
nnoremap("<leader>o", "o<Esc>k")
nnoremap("<leader>O", "O<Esc>j")
