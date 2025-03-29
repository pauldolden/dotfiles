-- Function to open any terminal application in a floating window
local function open_in_floating_window(app_command)
  local ui = vim.api.nvim_list_uis()[1]
  local width  = math.floor(ui.width * 0.9)   -- 90% of the screen width
  local height = math.floor(ui.height * 0.9)  -- 90% of the screen height
  local row    = math.floor((ui.height - height) / 2)  -- center vertically
  local col    = math.floor((ui.width - width) / 2)    -- center horizontally

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  -- Defer launching the terminal so that the floating window is rendered first.
  vim.schedule(function()
    vim.fn.termopen(app_command, {
      on_exit = function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end,
    })
    vim.cmd('startinsert')
  end)
end

return open_in_floating_window
