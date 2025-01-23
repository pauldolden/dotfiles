-- Function to open any terminal application in a floating window
local function open_in_floating_window(app_command)
    local ui = vim.api.nvim_list_uis()[1]
    local width = math.floor(ui.width * 0.9)  -- 90% of the screen width
    local height = math.floor(ui.height * 0.9)  -- 90% of the screen height
    local row = math.floor((ui.height - height) / 2)  -- Center the window
    local col = math.floor((ui.width - width) / 2)  -- Center the window

    local buf = vim.api.nvim_create_buf(false, true)  -- Create a new empty buffer
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
    })

    vim.fn.termopen(app_command, {
        on_exit = function()
            vim.api.nvim_win_close(win, true)
            vim.api.nvim_buf_delete(buf, {force = true})
        end,
    })
    vim.cmd('startinsert')
end

return open_in_floating_window
