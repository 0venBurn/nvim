-- LSP, formatters, Mason tooling, and Java LSP
return {
	-- nvim-lspconfig.lua
	{
		-- LSP Support
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			-- LSP Management
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		},
		config = function()
			local lsp_toggle = require("core.lsp-toggle")

			require("mason").setup()
			require("mason-lspconfig").setup({
				-- Keep Mason from calling vim.lsp.enable() automatically.
				-- LSPs should only start through :LspOn / :LspToggle.
				automatic_enable = false,
				ensure_installed = {
					-- List of LSP servers to install automatically
					"bashls",
					"jdtls",
					"cssls",
					"powershell_es",
					"ols",
					"solargraph",
					"basedpyright",
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
					"ts_ls",
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"debugpy",
					"java-debug-adapter",
					"java-test",
					"eslint_d",
					"prettier",
					"stylua",
					"isort",
					"black",
					"gofumpt",
					"hadolint",
					"ast-grep",
				},
			})

			if lsp_toggle.is_enabled() then
				vim.api.nvim_command("MasonToolsInstall")
			end

			local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lsp_attach = function(client, bufnr)
				-- Create your keybindings here...
				-- Enable inlay hints if supported
				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
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

			vim.lsp.config("basedpyright", {
				capabilities = lsp_capabilities,
				settings = {
					["basedpyright"] = {
						analysis = {
							typeCheckingMode = "off",
						},
						inlayHints = {
							enable = true,
						},
					},
				},
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
					typescript = {},
					javascript = {},
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

			-- Enable all configured servers unless the persistent LSP toggle is off.
			if lsp_toggle.is_enabled() then
				vim.lsp.enable(lsp_toggle.servers_to_enable())
			end

			-- Globally configure all LSP floating preview popups
			local open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				if opts.focusable == nil then
					opts.focusable = true
				end
				if opts.focus == nil then
					opts.focus = true
				end
				return open_floating_preview(contents, syntax, opts, ...)
			end
		end,
	},

	-- formatting.lua
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					svelte = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					liquid = { "prettier" },
					go = { "gofumpt" },
					lua = { "stylua" },
					ruby = { "rubocop" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},

	-- nvim-jdtls.lua
	{
		-- https://github.com/mfussenegger/nvim-jdtls
		"mfussenegger/nvim-jdtls",
		ft = "java",
		keys = {
			{
				"<leader>go",
				function()
					if vim.bo.filetype == "java" then
						require("jdtls").organize_imports()
					end
				end,
				desc = "Java organize imports",
			},
			{
				"<leader>gu",
				function()
					if vim.bo.filetype == "java" then
						require("jdtls").update_projects_config()
					end
				end,
				desc = "Java update project config",
			},
			{
				"<leader>tc",
				function()
					if vim.bo.filetype == "java" then
						require("jdtls").test_class()
					end
				end,
				desc = "Java test class",
			},
			{
				"<leader>tm",
				function()
					if vim.bo.filetype == "java" then
						require("jdtls").test_nearest_method()
					end
				end,
				desc = "Java test nearest method",
			},
		},
		config = function()
			require("core.lsp-toggle").start_jdtls()
		end,
	},
}
