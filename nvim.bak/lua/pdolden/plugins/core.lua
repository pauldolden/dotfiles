return {
  {
    "nvim-lua/plenary.nvim",
    name = "plenary",
  },
  -- Spectre
  {
    "nvim-pack/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end,
        { silent = true, desc = "Add a file to Harpoon" })

      vim.keymap.set("n", "<leader>A", function() harpoon:list():remove() end,
        { silent = true, desc = "Remove a file from Harpoon" })

      vim.keymap.set("n", "<C-a>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { silent = true, desc = "Toggle Harpoon" })

      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { silent = true, desc = "Select Buffer 1" })
      vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end, { silent = true, desc = "Select Buffer 2" })
      vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end, { silent = true, desc = "Select Buffer 3" })
      vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end, { silent = true, desc = "Select Buffer 4" })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { silent = true, desc = "Previous Buffer" })
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { silent = true, desc = "Next Buffer" })

      local harpoon_extensions = require("harpoon.extensions")
      harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
    end,
  },
  -- fzf-lua
  { "ibhagwan/fzf-lua" },
  { "github/copilot.vim" },
  { "gpanders/editorconfig.nvim" },
  { 'wakatime/vim-wakatime',       lazy = false },
  -- nvim-web-devicons
  { "kyazdani42/nvim-web-devicons" },
  {
    'stevearc/conform.nvim',
    opts = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { "rustfmt", lsp_format = "fallback" },
      -- Conform will run the first available formatter
      javascript = { "prettierd", "prettier", stop_after_first = true },
      -- Go will run goimports and gofmt
      go = { "goimports", "gofmt" },
      -- Zig will run zig fmt
      zig = { "zig fmt" }
    },
    config = function()
      require("conform").setup({
        format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      })
    end,
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
          require("which-key").show({ global = true })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
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
      }
    }
  }
}
