-- Close buffer
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = 'Close the current buffer' })
vim.keymap.set('n', '<leader>bw', ':bw<CR>', { desc = 'Close the buffer and window' })
-- Close all buffers except the current one
vim.keymap.set('n', '<leader>bo', function()
    local current_buf = vim.api.nvim_get_current_buf()
    local bufs = vim.api.nvim_list_bufs()
    for _, buf in ipairs(bufs) do
        if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
end, { desc = 'Close all other buffers' })

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

vim.keymap.set('n', '<Tab>', function() cycle_through_windows('next') end, { desc = 'Move to the next window' })
vim.keymap.set('n', '<S-Tab>', function() cycle_through_windows('prev') end, { desc = 'Move to the previous window' })


