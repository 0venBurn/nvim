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
			local opts = { noremap = true, silent = true }

			-- Basic navigation
			vim.keymap.set("n", "gD", function()
				vim.lsp.buf.definition()
			end, opts)
			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, opts)
			vim.keymap.set("n", "gi", function()
				vim.lsp.buf.implementation()
			end, opts)
			vim.keymap.set("n", "<C-k>", function()
				vim.lsp.buf.signature_help()
			end, opts)

			-- Add workspace folder
			vim.keymap.set("n", "<space>wa", function()
				vim.lsp.buf.add_workspace_folder()
			end, opts)
			vim.keymap.set("n", "<space>wr", function()
				vim.lsp.buf.remove_workspace_folder()
			end, opts)
			vim.keymap.set("n", "<space>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)

			-- Rename
			vim.keymap.set("n", "<space>rn", function()
				vim.lsp.buf.rename()
			end, opts)

			-- Code action
			vim.keymap.set({ "n", "v" }, "<space>ca", function()
				vim.lsp.buf.code_action()
			end, opts)

			-- References
			vim.keymap.set("n", "gr", function()
				vim.lsp.buf.references()
			end, opts)

			-- Diagnostics
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.goto_prev()
			end, opts)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.goto_next()
			end, opts)
			vim.keymap.set("n", "<space>e", function()
				vim.diagnostic.open_float()
			end, opts)
			vim.keymap.set("n", "<space>q", function()
				vim.diagnostic.setloclist()
			end, opts)
		end

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				if server_name ~= "jdtls" then
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
