vim.g.neoformat_try_node_exe = 1

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.svelte", "*.astro" },
--   callback = function()
--     vim.cmd("Neoformat prettier")
--     vim.cmd("EslintFixAll")
--   end,
--   group = autogroup_eslint_lsp,
-- })
