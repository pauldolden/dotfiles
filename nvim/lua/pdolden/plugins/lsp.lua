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

			-- Workaround for Neovim 0.11.2 LSP sync bug
			-- Use full sync instead of incremental to avoid nil prev_line errors
			capabilities.textDocument.synchronization = {
				dynamicRegistration = false,
				willSave = true,
				willSaveWaitUntil = true,
				didSave = true,
				change = vim.lsp.protocol.TextDocumentSyncKind.Full,
			}

			-- Improved keymaps function
			local function setup_keymaps(bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }

				-- Navigation (gd/gD/gr/gI/gy handled by Snacks picker)
					
				-- Documentation
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)

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
				vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

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

			-- Configure LSP servers using new vim.lsp.config API
		-- Helper function to safely configure LSP servers
		local function configure_lsp(server_name, binary_name, config)
			if vim.fn.executable(binary_name) ~= 1 then
				vim.notify(
					string.format("LSP: %s not found (install via Mason)", server_name),
					vim.log.levels.WARN,
					{ title = "LSP Config" }
				)
				return false
			end
			vim.lsp.config(server_name, config)
			return true
		end

			-- Lua Language Server
			configure_lsp("lua_ls", "lua-language-server", {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = {
					".luarc.json",
					".luarc.jsonc",
					".luacheckrc",
					".stylua.toml",
					"stylua.toml",
					"selene.toml",
					"selene.yml",
					".git",
				},
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

			-- Go Language Server
			configure_lsp("gopls", "gopls", {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
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
						directoryFilters = {
							"-.git",
							"-.vscode",
							"-.idea",
							"-.vscode-test",
							"-node_modules",
						},
						semanticTokens = true,
					},
				},
			})

			-- TypeScript Language Server
			configure_lsp("ts_ls", "typescript-language-server", {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
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

			-- Rust Analyzer
			configure_lsp("rust_analyzer", "rust-analyzer", {
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
				root_markers = { "Cargo.toml", "rust-project.json" },
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

			-- Zig Language Server
			configure_lsp("zls", "zls", {
				cmd = { "zls" },
				filetypes = { "zig", "zir" },
				root_markers = { "zls.json", "build.zig", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- Enable LSP servers on appropriate file types
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"lua",
					"go",
					"gomod",
					"gowork",
					"gotmpl",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"rust",
					"zig",
					"zir",
				},
				callback = function(args)
					local filetype = vim.bo[args.buf].filetype
					local server_map = {
						lua = "lua_ls",
						go = "gopls",
						gomod = "gopls",
						gowork = "gopls",
						gotmpl = "gopls",
						javascript = "ts_ls",
						javascriptreact = "ts_ls",
						typescript = "ts_ls",
						typescriptreact = "ts_ls",
						rust = "rust_analyzer",
						zig = "zls",
						zir = "zls",
					}

					local server = server_map[filetype]
					if server then
						vim.lsp.enable(server)
					end
				end,
			})

			-- Mason-lspconfig for automatic installation
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"ts_ls",
					"zls",
				},
				automatic_installation = true,
			})
		end,
	},

	-- Copilot with inline ghost text
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = false, -- Handled by nvim-cmp
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				panel = { enabled = false },
				filetypes = {
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					["."] = false,
				},
			})
		end,
	},
}
