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

