local M = {}

M.config = function()
  lvim.builtin.treesitter.auto_install = true

  lvim.plugins = {
    {
      "folke/trouble.nvim",
      cmd = "TroubleToggle",
    },
    {
      "romgrk/nvim-treesitter-context",
      config = function()
        require("treesitter-context").setup {
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          throttle = true, -- Throttles plugin updates (may improve performance)
          max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
          patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
              'class',
              'function',
              'method',
            },
          },
        }
      end
    },
    { "zbirenbaum/copilot.lua",
      event = { "InsertEnter" },
      config = function()
        require("copilot").setup({
          suggestion = {
            enable = true,
            auto_trigger = true,
            keymap = {
              accept = "<C-J>"
            }
          }
        })
      end,
    },
    { "zbirenbaum/copilot-cmp",
      after = { "copilot.lua", "nvim-cmp" },
    },
    {
      "mrjones2014/nvim-ts-rainbow",
      config = function()
        require("nvim-treesitter.configs").setup {
          rainbow = {
            enable = true,
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
          },
        }
      end
    },
    {
      "tpope/vim-surround",
    },
    {
      "gelguy/wilder.nvim",
      config = function()
        local wilder = require('wilder')
        wilder.setup({ modes = { ':', '/', '?' } })

        wilder.set_option('renderer', wilder.popupmenu_renderer(
          wilder.popupmenu_palette_theme({
            highlighter = wilder.basic_highlighter(),
            border = 'single',
            max_height = '75%',
            min_height = 0,
            prompt_position = 'top',
            reverse = 0,
          })
        ))
      end
    },
    { "mg979/vim-visual-multi" },
    { "APZelos/blamer.nvim" },
    {
      "wakatime/vim-wakatime"
    },
    {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup()
      end,
    },
  }

  lvim.builtin.treesitter.rainbow.enable = true
  lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
  table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })
end

return M
