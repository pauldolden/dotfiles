vim.api.nvim_create_autocmd("BufRead", {
  pattern = { "*.md" },
  callback = function()
    vim.cmd("set syntax=markdown")
  end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.md" },
  callback = function()
    vim.cmd("set syntax=markdown")
  end,
})

