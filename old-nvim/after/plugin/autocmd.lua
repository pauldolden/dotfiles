-- These two fix for strangeness where markdown synxtax is not set
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

-- Formate and lint on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.cmd("Neoformat")
    vim.cmd("ALEFix")
  end,
  group = autogroup_eslint_lsp,
})
