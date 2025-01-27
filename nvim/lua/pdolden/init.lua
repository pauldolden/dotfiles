local load = require('pdolden.utils.autoload').load_directory

load('options')
load('remaps')
load('extras')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "pdolden.plugins",
    change_detection = { notify = false },
})

require('pdolden.utils.fzf')
