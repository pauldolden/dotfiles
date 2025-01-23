return {
  "nvim-pack/nvim-spectre",
  config = function()
    -- Configure nvim-spectre
    require("spectre").setup({
      -- Add your custom configuration here if needed
    })

    -- Key mappings for nvim-spectre
    local keymap = vim.keymap.set
    keymap('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
    keymap('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search current word" })
    keymap('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search current word (visual)" })
    keymap('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search in current file" })
  end,
}
