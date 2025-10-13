return {
  -- Mason for managing external tools
  {
    "williamboman/mason.nvim",
    config = true,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "j-hui/fidget.nvim",
    },
    config = function()
      -- Setup fidget for LSP progress
      require("fidget").setup({})

      -- Enhanced diagnostics config
      vim.diagnostic.config({
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Enhanced capabilities with cmp
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Improved keymaps function
      local function setup_keymaps(bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Navigation
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

        -- Documentation
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

        -- Workspace
        vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)

        -- Code actions
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        -- Diagnostics
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

        -- Format
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end

      -- Common on_attach with language-specific autocommands
      local function on_attach(client, bufnr)
        setup_keymaps(bufnr)

        -- Go-specific: organize imports on save
        if client.name == "gopls" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              local params = vim.lsp.util.make_range_params()
              params.context = { only = { "source.organizeImports" } }
              vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
            end,
          })
        end

        -- Rust-specific: auto-format on save
        if client.name == "rust_analyzer" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end

      -- Mason-lspconfig setup with handlers
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "gopls",
          "ts_ls",
          "zls",
        },
        automatic_installation = true,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end,

          -- Lua with Neovim-specific settings
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = {
                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME,
                      "${3rd}/luv/library",
                    },
                  },
                  telemetry = { enable = false },
                },
              },
            })
          end,

          -- Go with comprehensive settings
          ["gopls"] = function()
            require("lspconfig").gopls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                gopls = {
                  gofumpt = true,
                  codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                  },
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                  analyses = {
                    fieldalignment = true,
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                  },
                  usePlaceholders = true,
                  completeUnimported = true,
                  staticcheck = true,
                  directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                  semanticTokens = true,
                },
              },
            })
          end,

          -- TypeScript with modern settings
          ["ts_ls"] = function()
            require("lspconfig").ts_ls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                typescript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
                javascript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
              },
            })
          end,

          -- Rust with Clippy and comprehensive settings
          ["rust_analyzer"] = function()
            require("lspconfig").rust_analyzer.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                ["rust-analyzer"] = {
                  imports = {
                    granularity = {
                      group = "module",
                    },
                    prefix = "self",
                  },
                  cargo = {
                    buildScripts = {
                      enable = true,
                    },
                  },
                  procMacro = {
                    enable = true,
                  },
                  checkOnSave = {
                    command = "clippy",
                  },
                  inlayHints = {
                    bindingModeHints = {
                      enable = false,
                    },
                    chainingHints = {
                      enable = true,
                    },
                    closingBraceHints = {
                      enable = true,
                      minLines = 25,
                    },
                    closureReturnTypeHints = {
                      enable = "never",
                    },
                    lifetimeElisionHints = {
                      enable = "never",
                      useParameterNames = false,
                    },
                    maxLength = 25,
                    parameterHints = {
                      enable = true,
                    },
                    reborrowHints = {
                      enable = "never",
                    },
                    renderColons = true,
                    typeHints = {
                      enable = true,
                      hideClosureInitialization = false,
                      hideNamedConstructor = false,
                    },
                  },
                },
              },
            })
          end,

          -- Zig language server
          ["zls"] = function()
            require("lspconfig").zls.setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end,
        },
      })
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = false,
          help = false,
        },
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      -- Setup copilot-cmp
      require("copilot_cmp").setup()

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot",  group_index = 2 },
          { name = "nvim_lsp", group_index = 2 },
          { name = "luasnip",  group_index = 2 },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Add source name to completion items
            vim_item.menu = ({
              copilot = "[Copilot]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      })
    end,
  },
}
