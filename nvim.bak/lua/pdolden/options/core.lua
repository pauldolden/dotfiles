vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2        -- Number of spaces a <Tab> represents
vim.opt.softtabstop = 2    -- Number of spaces a <Tab> counts for while editing
vim.opt.shiftwidth = 2     -- Number of spaces used for auto-indent
vim.opt.expandtab = true   -- Use spaces instead of tabs

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true

vim.opt.fillchars = 'eob: '

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
