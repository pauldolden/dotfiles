return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "mg979/vim-visual-multi", lazy = false },
  { "APZelos/blamer.nvim", lazy = false },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" },
    config = function()
      require("copilot").setup({
        suggestion = {
          enable = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-f>",
          },
        },
      })
    end,
  },
  { "zbirenbaum/copilot-cmp", after = { "copilot.lua", "nvim-cmp" } },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
