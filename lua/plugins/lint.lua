return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		local eslint = lint.linters.eslint_d
		lint.linters_by_ft = {
			javascript = { "eslint_d", "eslint" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			go = { "golangcilint" },
			ruby = { "standardrb" },
			Dockerfile = { "hadolint" },
			python = { "ruff" }, -- Add both Ruff and MyPy for Python
		}

		-- Configuration for Ruff
		require("lint").linters.ruff.cmd = "ruff"
		require("lint").linters.ruff.args = {
			"check",
			"--format",
			"json",
			"-",
			"--stdin-filename",
		}

		-- Existing ESLint configuration
		eslint.args = {
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "§", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
