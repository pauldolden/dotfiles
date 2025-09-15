-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move line up" })

-- Paste under cursor without yanking
vim.keymap.set("x", "<leader>p", [["_dP]], { noremap = true, silent = true, desc = "Paste under cursor without yanking" })
vim.keymap.set("n", "<leader>px", [["_ddP]],
  { noremap = true, silent = true, desc = "Replace line under cursor without yanking" })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { noremap = true, silent = true, desc = "Copy to clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { noremap = true, silent = true, desc = "Cut to clipboard" })

-- Format buffer
vim.keymap.set("n", "<leader>fb", vim.lsp.buf.format, { noremap = true, silent = true, desc = "Format file" })

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
  desc = "Search on current file"
})

-- Search and replace word under cursor
vim.keymap.set("n", "<leader>sf", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { noremap = true, silent = true, desc = "Search and replace word under cursor" })

vim.keymap.set("n", "ss", function()
  local last_search = vim.fn.getreg('/')
  if last_search == "" then
    print("No last search pattern found!")
    return
  end

  -- Escape any slashes in the last search pattern.
  local escaped = vim.fn.escape(last_search, '/')
  -- Build the substitution command.
  -- This creates a command like: :%s/\<foo\>/foo/gI
  local cmd = ":%s/\\<" .. escaped .. "\\>/" .. escaped .. "/gI"

  -- Move left so that the cursor is positioned at the end of the replacement text.
  -- (Based on our math, 3 left moves are expected;
  --  if that doesn’t feel right in your setup, try adjusting this number.)
  local left_count = 3
  local lefts = string.rep("<Left>", left_count)

  -- Replace termcodes so that <Left> is understood properly.
  local full_cmd = vim.api.nvim_replace_termcodes(cmd .. lefts, true, false, true)

  -- Feed the keys into Vim so that the command-line is prefilled and the cursor is moved.
  vim.api.nvim_feedkeys(full_cmd, 'n', false)
end, {
  noremap = true,
  silent = true,
  desc = "Search and replace last searched word (cursor at end of replacement)"
})
vim.keymap.set("n", "<leader>R", function()
  local search_term = vim.fn.getreg("/") -- Get last searched pattern
  if search_term == "" then
    print("No search pattern found!")
    return
  end

  local replacement = vim.fn.input("Replace '" .. search_term .. "' with: ")
  if replacement == "" then return end             -- Exit if empty replacement

  vim.cmd("vimgrep /\\V" .. search_term .. "/g %") -- Populate quickfix list
  vim.cmd("cdo s//" .. replacement .. "/gc")       -- Confirm replacements
  vim.cmd("cclose")                                -- Close quickfix window after replacement
end, { noremap = true, silent = false, desc = "Search & replace interactively" })
