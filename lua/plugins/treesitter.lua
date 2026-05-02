-- Treesitter syntax and parser setup
return {
	-- nvim-treesitter.lua
	{
	-- https://github.com/nvim-treesitter/nvim-treesitter
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false, -- treesitter does not support lazy-loading
	dependencies = {
		-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	build = ":TSUpdate",
	config = function()
		-- nvim-treesitter's main branch keeps its bundled queries in a runtime/
		-- subdirectory. Add it explicitly so query-only dependencies like
		-- `ecma`, `jsx`, and `html_tags` are visible; without these, Svelte/JS/HTML
		-- highlighting is mostly blank.
		vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime")

		local nts = require("nvim-treesitter")
		local install_dir = vim.fn.stdpath("data") .. "/site"

		nts.setup({
			install_dir = install_dir,
		})

		local ensure_installed = {
			"c",
			"java",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
			"comment",
			"xml",
			"http",
			"json",
			"graphql",
			"html",
			"html_tags",
			"css",
			"scss",
			"javascript",
			"typescript",
			"tsx",
			"ecma",
			"jsx",
			"svelte",
		}

		nts.install(ensure_installed)

		vim.filetype.add({
			extension = {
				star = "python",
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-highlighting", { clear = true }),
			callback = function(args)
				local ok = pcall(vim.treesitter.start, args.buf)
				if not ok then
					-- Fall back to Vim regex syntax for filetypes without a parser.
					vim.bo[args.buf].syntax = "ON"
				end
			end,
		})
	end,
}
}
