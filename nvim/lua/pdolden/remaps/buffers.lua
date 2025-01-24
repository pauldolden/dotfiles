-- Close buffer and bring next buffer to the current window
vim.keymap.set('n', '<leader>bd', function()
  local current_buf = vim.api.nvim_get_current_buf()

  -- Check if the current buffer is displayed in more than one window
  local buf_windows = vim.fn.win_findbuf(current_buf)

  if #buf_windows > 1 then
    -- Detach buffer from the current split
    local scratch_buf = vim.api.nvim_create_buf(false, true) -- Create a temporary buffer
    vim.api.nvim_win_set_buf(0, scratch_buf)                -- Replace the current buffer with scratch
    vim.api.nvim_buf_delete(scratch_buf, { force = true })  -- Immediately delete the scratch buffer
  else
    -- Single window showing the buffer
    if #vim.fn.getbufinfo({ buflisted = 1 }) == 1 then
      -- If it's the last buffer, show a warning
      vim.notify("Cannot delete the last buffer", vim.log.levels.WARN)
      return
    end

    -- Try to switch to the next buffer
    vim.cmd("bnext")

    -- If still on the same buffer, fallback to previous buffer
    if vim.api.nvim_get_current_buf() == current_buf then
      vim.cmd("bprev")
    end

    -- Delete the current buffer
    vim.cmd("bdelete " .. current_buf)
  end
end, { desc = "Close the current buffer or split" })
-- Toggle between the last two buffers
vim.keymap.set('n', '<leader>bt', function()
    vim.cmd('b#')
end, { desc = 'Toggle between the last two buffers' })
-- Move to the window in the specified direction
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to the left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to the upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to the right window' })
-- Custom function to cycle through windows
local function cycle_through_windows(direction)
    if direction == 'next' then
        vim.cmd('wincmd w') -- Go to the next window
    elseif direction == 'prev' then
        vim.cmd('wincmd W') -- Go to the previous window
    end
end
-- Cycle through windows
vim.keymap.set('n', '<Tab>', function() cycle_through_windows('next') end, { desc = 'Move to the next window' })
vim.keymap.set('n', '<S-Tab>', function() cycle_through_windows('prev') end, { desc = 'Move to the previous window' })
-- Split window vertically and horizontally
vim.keymap.set("n", "|", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "-", ":split<CR>", { desc = "Split window horizontally" })
-- Resize active window
vim.keymap.set("n", "<leader>+", ":resize +5<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<leader>_", ":resize -5<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>>", ":vertical resize +5<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<leader><", ":vertical resize -5<CR>", { desc = "Decrease window width" })

