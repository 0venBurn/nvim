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
				"jdtls",
				"jsonls",
				"rust_analyzer",
				"svelte",
				"lemminx",
				"nginx_language_server",
				"ruff_lsp",
				"pyright",
				"marksman",
				"quick_lint_js",
				"yamlls",
				"tailwindcss",
				"graphql",
				"gopls",
				"tsserver",
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"java-debug-adapter",
				"java-test",
				"black",
				"eslint_d",
				"ruff",
				"prettier",
				"isort",
				"mypy",
				"flake8",
				"goimports",
				"hadolint",
				"revive",
				"ast-grep",
				"bacon",
			},
		})

		vim.api.nvim_command("MasonToolsInstall")

		local lspconfig = require("lspconfig")
		local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

		local lsp_attach = function(client, bufnr)
			-- Create your keybindings here...
		end

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				if
					server_name ~= "jdtls"
					and server_name ~= "solargraph"
					and server_name ~= "denols"
					and server_name ~= "tsserver"
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
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim", "capabilities" },
							},
							completion = {
								callSnippet = "Replace",
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
						},
						root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
					})
				end
			end,
			["tsserver"] = function()
				-- Use tsserver for non-Deno projects
				if vim.fn.filereadable("deno.json") == 0 and vim.fn.filereadable("deno.jsonc") == 0 then
					lspconfig.tsserver.setup({
						on_attach = lsp_attach,
						capabilities = lsp_capabilities,
						root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
					})
				end
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
