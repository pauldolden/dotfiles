-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.title = true
-- set window title to root directory
vim.opt.titlestring = "%{expand('%:p:h:t')}"
vim.opt.compatible = false
-- Vimwiki stuff
vim.cmd("filetype plugin on")
vim.cmd("syntax on")
vim.g.vimwiki_list = {
  {
    path = "~/vault/",
    syntax = "markdown",
    ext = ".md",
  },
}
