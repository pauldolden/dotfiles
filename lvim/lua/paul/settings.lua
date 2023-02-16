local M = {}

M.config = function()
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.relativenumber = true
  vim.opt.title = true
  -- set window title to root directory
  vim.opt.titlestring = "%{expand('%:p:h:t')}"
  lvim.log.level = "info"
  lvim.format_on_save = {
      enabled = true,
      pattern = "*.lua",
      timeout = 1000,
  }
end

return M
