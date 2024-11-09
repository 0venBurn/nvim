return {
	-- LSP Support
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		-- LSP Management
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		{ "j-hui/fidget.nvim", opts = {} },
		{ "folke/neodev.nvim" },
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				-- List of LSP servers to install automatically
				"bashls",
				"denols",
				"clangd",
				"cssls",
				"powershell_es",
				"solargraph",
				"html",
				"gradle_ls",
				"dockerls",
				"docker_compose_language_service",
				"lua_ls",
				"rubocop",
				"jdtls",
				"jsonls",
				"rust_analyzer",
				"svelte",
				"lemminx",
				"nginx_language_server",
				"pyright",
				"marksman",
				"zls",
				"yamlls",
				"tailwindcss",
				"graphql",
				"gopls",
				"ts_ls",
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"java-debug-adapter",
				"java-test",
				"black",
				"eslint_d",
				"prettier",
				"isort",
				"mypy",
				"goimports",
				"gofumpt",
				"stylua",
				"hadolint",
				"ast-grep",
			},
		})

		vim.api.nvim_command("MasonToolsInstall")

		local lspconfig = require("lspconfig")
		local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

		local lsp_attach = function(client, bufnr)
			-- Create your keybindings here...
			-- Enable inlay hints
		end

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				if
					server_name ~= "jdtls"
					and server_name ~= "solargraph"
					and server_name ~= "denols"
					and server_name ~= "ts_ls"
					and server_name ~= "rust_analyzer"
					and server_name ~= "lua_ls"
					and server_name ~= "gopls"
				then
					lspconfig[server_name].setup({
						on_attach = lsp_attach,
						capabilities = lsp_capabilities,
					})
				end
			end,
			["svelte"] = function()
				lspconfig["svelte"].setup({
					capabilities = lsp_capabilities,
					on_attach = function(client, bufnr)
						lsp_attach(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end,
				})
			end,
			["rust_analyzer"] = function()
				lspconfig["rust_analyzer"].setup({
					on_attach = lsp_attach,
					capabilities = lsp_capabilities,
					settings = {
						["rust-analyzer"] = {
							checkOnSave = {
								command = "clippy",
							},
							inlayHints = {
								enable = true,
								showParameterNames = true,
								parameterHintsPrefix = "<- ",
								otherHintsPrefix = "=> ",
							},
						},
					},
				})
			end,
			["emmet_ls"] = function()
				lspconfig["emmet_ls"].setup({
					capabilities = lsp_capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"tailwindcss",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup({
					capabilities = lsp_capabilities,
					on_attach = lsp_attach,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim", "capabilities" },
							},
							completion = {
								callSnippet = "Replace",
							},
							hint = {
								enable = true,
								setType = true,
								paramType = true,
								paramName = "All",
								semicolon = "SameLine",
								arrayIndex = "All",
							},
						},
					},
				})
			end,
			["solargraph"] = function()
				lspconfig["solargraph"].setup({
					on_attach = lsp_attach,
					capabilities = lsp_capabilities,
					settings = {
						solargraph = {
							diagnostics = true,
						},
					},
					filetypes = { "ruby", "rakefile" },
					root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
				})
			end,
			["denols"] = function()
				-- Use denols only for Deno projects
				if vim.fn.filereadable("deno.json") == 1 or vim.fn.filereadable("deno.jsonc") == 1 then
					lspconfig.denols.setup({
						on_attach = lsp_attach,
						capabilities = lsp_capabilities,
						init_options = {
							lint = true,
							inlayHints = {
								enable = true,
								parameterNames = {
									enabled = "all",
								},
								parameterTypes = {
									enabled = true,
								},
								variableTypes = {
									enabled = true,
								},
								propertyDeclarationTypes = {
									enabled = true,
								},
								functionLikeReturnTypes = {
									enabled = true,
								},
								enumMemberValues = {
									enabled = true,
								},
							},
						},
						root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
					})
				end
			end,
			["ts_ls"] = function()
				-- Use tsserver for non-Deno projects
				if vim.fn.filereadable("deno.json") == 0 and vim.fn.filereadable("deno.jsonc") == 0 then
					lspconfig.ts_ls.setup({
						on_attach = lsp_attach,
						capabilities = lsp_capabilities,
						settings = {
							typescript = {
								inlayHints = {
									includeInlayEnumMemberValueHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
									includeInlayParameterNameHintsWhenArgumentMatchesName = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayVariableTypeHints = true,
								},
							},
							javascript = {
								inlayHints = {
									includeInlayEnumMemberValueHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
									includeInlayParameterNameHintsWhenArgumentMatchesName = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayVariableTypeHints = true,
								},
							},
						},
						root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
					})
				end
			end,
			["gopls"] = function()
				lspconfig.gopls.setup({
					on_attach = lsp_attach,
					capabilities = lsp_capabilities,
					settings = {
						gopls = {
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				})
			end,
		})

		-- Globally configure all LSP floating preview popups
		local open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			return open_floating_preview(contents, syntax, opts, ...)
		end
	end,
}
