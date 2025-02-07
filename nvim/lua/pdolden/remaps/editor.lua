-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move line up" })

-- Paste under cursor without yanking
vim.keymap.set("x", "<leader>p", [["_dP]], { noremap = true, silent = true, desc = "Paste under cursor without yanking" })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { noremap = true, silent = true, desc = "Copy to clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { noremap = true, silent = true, desc = "Cut to clipboard" })

-- Format buffer
vim.keymap.set("n", "<leader>fb", vim.lsp.buf.format, { noremap = true, silent = true, desc = "Format file" })

-- Search and replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { noremap = true, silent = true, desc = "Search and replace word under cursor" })

vim.keymap.set("n", "<leader>R", function()
  local search_term = vim.fn.getreg("/") -- Get last searched pattern
  if search_term == "" then
    print("No search pattern found!")
    return
  end

  local replacement = vim.fn.input("Replace '" .. search_term .. "' with: ")
  if replacement == "" then return end -- Exit if empty replacement

  vim.cmd("vimgrep /\\V" .. search_term .. "/g %") -- Populate quickfix list
  vim.cmd("cdo s//" .. replacement .. "/gc") -- Confirm replacements
  vim.cmd("cclose") -- Close quickfix window after replacement
end, { noremap = true, silent = false, desc = "Search & replace interactively" })
