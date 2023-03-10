return {
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
    "mrjones2014/nvim-ts-rainbow",
    config = function()
      require("nvim-treesitter.configs").setup({
        rainbow = {
          enable = true,
          extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
          max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        },
      })
    end,
  },
  {
    "tpope/vim-surround",
  },
  {
    "gelguy/wilder.nvim",
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(wilder.popupmenu_palette_theme({
          highlighter = wilder.basic_highlighter(),
          border = "single",
          max_height = "75%",
          min_height = 0,
          prompt_position = "top",
          reverse = 0,
        }))
      )
    end,
  },
  { "mg979/vim-visual-multi" },
  { "APZelos/blamer.nvim" },
  {
    "wakatime/vim-wakatime",
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "ray-x/go.nvim",
    config = function()
      require("go").setup()
    end,
  },
  {
    "vimwiki/vimwiki",
    config = function()
      vim.g.vimwiki_list = {
        {
          path = "~/vault/",
          syntax = "markdown",
          ext = ".md",
        },
      }
    end,
  },
}
