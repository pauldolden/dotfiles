local M = {}

M.config = function()
	-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
	lvim.leader = "space"
	-- add your own keymapping
	lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

	lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"
	lvim.keys.normal_mode["<leader>q"] = ":BufferKill<CR>"
	lvim.keys.normal_mode["<leader>t"] = ":Trouble<CR>"

	lvim.keys.normal_mode["<leader>yp"] = "<cmd>let @+ = expand('%:p')<CR>"
	lvim.keys.normal_mode["<C-d>"] = "<C-d>zz<CR>"
	lvim.keys.normal_mode["<C-u>"] = "<C-u>zz<CR>"

	-- -- Use which-key to add extra bindings with the leader-key prefix
	lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
	lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
end

return M
