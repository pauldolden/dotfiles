
-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  {
  "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    },
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  { "mg979/vim-visual-multi", lazy = false },
  { "APZelos/blamer.nvim", lazy = false },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" },
    config = function()
      require("copilot").setup {
        suggestion = {
          enable = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-f>",
          },
        },
      }
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
    config = function() require("go").setup() end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },


  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },
}
