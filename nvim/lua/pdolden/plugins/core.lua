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
  { "gpanders/editorconfig.nvim" },
  { 'wakatime/vim-wakatime',       lazy = false },
  -- nvim-web-devicons
  { "kyazdani42/nvim-web-devicons" },
  {
    'stevearc/conform.nvim',
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          rust = { "rustfmt" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          go = { "goimports", "gofmt" },
          zig = { "zigfmt" },
        },
        format_on_save = {
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
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require('blame').setup {}
    end,
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>e",
        "<cmd>Yazi<cr>",
        desc = "Open yazi file manager",
      },
      {
        "<leader>E",
        "<cmd>Yazi cwd<cr>",
        desc = "Open yazi in current working directory",
      },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = '<f1>',
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
      { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
      { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Search tags" },
      { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
      { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's note" },
      { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch workspace" },
      { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "Link selection", mode = "v" },
      { "<leader>oln", "<cmd>ObsidianLinkNew<cr>", desc = "Link to new note", mode = "v" },
      { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link" },
      { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename note" },
    },
    opts = {
      workspaces = {
        {
          name = "vault",
          path = "~/vault",
        },
      },
      daily_notes = {
        folder = "Daily Notes",
        date_format = "%Y-%m-%d",
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      -- Use fzf-lua picker (compatible with Snacks)
      picker = {
        name = "fzf-lua",
      },
      mappings = {
        -- Follow links with gf (works in normal mode on [[links]])
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle checkboxes with <leader>ch
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action with <CR> (enter key)
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      ui = {
        enable = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
      },
      -- Disable frontmatter if you don't use it, or configure as needed
      disable_frontmatter = false,
      -- Follow Obsidian's link format
      note_id_func = function(title)
        return title
      end,
    },
  },
}
