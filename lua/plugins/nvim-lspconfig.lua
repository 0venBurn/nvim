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
				"cssls",
				"powershell_es",
				"solargraph",
				"pyright",
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
				"eslint_d",
				"prettier",
				"isort",
				"goimports",
				"gofumpt",
				"stylua",
				"hadolint",
				"ast-grep",
			},
		})

		vim.api.nvim_command("MasonToolsInstall")

		local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

		local lsp_attach = function(client, bufnr)
			-- Create your keybindings here...
			-- Enable inlay hints if supported
			if client.server_capabilities.inlayHintProvider then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
		end

		-- Configure global LSP settings using vim.lsp.config
		-- Set default capabilities and on_attach for all servers
		vim.lsp.config("*", {
			capabilities = lsp_capabilities,
		})

		-- Configure specific servers with custom settings
		vim.lsp.config("svelte", {
			capabilities = lsp_capabilities,
		})

		vim.lsp.config("rust_analyzer", {
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

		vim.lsp.config("emmet_ls", {
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

		vim.lsp.config("lua_ls", {
			capabilities = lsp_capabilities,
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

		vim.lsp.config("solargraph", {
			capabilities = lsp_capabilities,
			settings = {
				solargraph = {
					diagnostics = true,
				},
			},
			filetypes = { "ruby", "rakefile" },
			root_markers = { "Gemfile", ".git" },
		})

		vim.lsp.config("denols", {
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
			root_markers = { "deno.json", "deno.jsonc" },
		})

		vim.lsp.config("ts_ls", {
			capabilities = lsp_capabilities,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayEnumMemberValueHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayParameterNameHints = "all",
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
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayVariableTypeHints = true,
					},
				},
			},
			root_markers = { "package.json", "tsconfig.json", ".git" },
		})

		vim.lsp.config("gopls", {
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

		-- Setup LspAttach autocmd for on_attach functionality
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				lsp_attach(client, event.buf)

				-- Special handling for svelte
				if client.name == "svelte" then
					vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
						end,
					})
				end
			end,
		})

		-- Enable LSP servers using the new API
		-- Servers to enable (excluding jdtls which needs special handling)
		local servers_to_enable = {
			"bashls",
			"cssls",
			"powershell_es",
			"solargraph",
			"pyright",
			"html",
			"gradle_ls",
			"dockerls",
			"docker_compose_language_service",
			"lua_ls",
			"rubocop",
			"jsonls",
			"rust_analyzer",
			"svelte",
			"lemminx",
			"nginx_language_server",
			"marksman",
			"zls",
			"yamlls",
			"tailwindcss",
			"graphql",
			"gopls",
			"emmet_ls",
		}

		-- Conditionally enable ts_ls or denols based on project type
		if vim.fn.filereadable("deno.json") == 1 or vim.fn.filereadable("deno.jsonc") == 1 then
			table.insert(servers_to_enable, "denols")
		else
			table.insert(servers_to_enable, "ts_ls")
		end

		-- Enable all configured servers
		vim.lsp.enable(servers_to_enable)

		-- Globally configure all LSP floating preview popups
		local open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			return open_floating_preview(contents, syntax, opts, ...)
		end
	end,
}
