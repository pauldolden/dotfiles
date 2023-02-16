local M = {}


M.config = function()
  local linters = require "lvim.lsp.null-ls.linters"
  linters.setup {
      {
          command = "eslint", filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }
      },
  }

  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup {
      {
          command = "prettier",
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      },
  }
end

return M
