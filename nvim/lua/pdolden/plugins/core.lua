return {
  {
    "nvim-lua/plenary.nvim",
    name = "plenary",
  },

  "github/copilot.vim",
  "gpanders/editorconfig.nvim",
  { 'wakatime/vim-wakatime', lazy = false },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    config = function()
      -- Configure nvim-spectre
      require("spectre").setup({
        -- Add your custom configuration here if needed
      })

      -- Key mappings for nvim-spectre
      local keymap = vim.keymap.set
      keymap('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
      keymap('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
        { desc = "Search current word" })
      keymap('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>',
        { desc = "Search current word (visual)" })
      keymap('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
        { desc = "Search in current file" })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
      })
    end,
  },
  {
    "leath-dub/snipe.nvim",
    keys = {
      { "<leader>bl", function() require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu" }
    },
    opts = {}
  },
  {
    'jinh0/eyeliner.nvim',
    config = function()
      require 'eyeliner'.setup {
        -- show highlights only after keypress
        highlight_on_key = true,

        -- dim all other characters if set to true (recommended!)
        dim = false,

        -- set the maximum number of characters eyeliner.nvim will check from
        -- your current cursor position; this is useful if you are dealing with
        -- large files: see https://github.com/jinh0/eyeliner.nvim/issues/41
        max_length = 9999,

        -- filetypes for which eyeliner should be disabled;
        -- e.g., to disable on help files:
        -- disabled_filetypes = {"help"}
        disabled_filetypes = {},

        -- buftypes for which eyeliner should be disabled
        -- e.g., disabled_buftypes = {"nofile"}
        disabled_buftypes = {},

        -- add eyeliner to f/F/t/T keymaps;
        -- see section on advanced configuration for more information
        default_keymaps = true,
      }
    end
  }
}
